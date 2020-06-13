#tag Class
Protected Class SKCanvasButton
Inherits canvas
	#tag Event
		Function MouseDown(X As Integer, Y As Integer) As Boolean
		  #Pragma Unused X
		  #Pragma Unused Y
		  
		  pressed = True
		  
		  Me.Invalidate
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseEnter()
		  hovered = True
		  Me.Invalidate
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseExit()
		  hovered = False
		  Me.Invalidate
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(X As Integer, Y As Integer)
		  #Pragma Unused X
		  #Pragma Unused Y
		  
		  pressed = False
		  
		  Me.Invalidate
		  RaiseEvent action
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As REALbasic.Rect)
		  paintButton(g, areas)
		  paintIcon(g, areas)
		  paintText(g, areas)
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub paintButton(g as Graphics, areas() as REALbasic.Rect)
		  #Pragma Unused areas
		  
		  If pressed Or hovered Then
		    g.DrawingColor = selectFillColour
		    g.FillRoundRectangle(0, 0, g.Width, g.Height, arc, arc)
		  End If
		  
		  g.DrawingColor = selectLIneColour
		  g.penheight = lineThickness
		  g.penwidth = lineThickness
		  g.DrawRoundRectangle(0, 0, g.Width, g.Height, arc, arc)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub paintIcon(g as Graphics, areas() as REALbasic.Rect)
		  #Pragma Unused areas
		  
		  If Me.image <> Nil Then
		    Var pic As Picture = Me.Image
		    pic = proportionalscale(pic, 0.75*g.Height, 0.75*g.Height)
		    
		    
		    g.DrawPicture(pic, 5, (g.Height - pic.Height)/2)
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub paintText(g as Graphics, areas() as REALbasic.Rect)
		  #Pragma Unused areas
		  
		  g.DrawingColor = selectTextColour
		  
		  If Me.fontName = "" Then Me.fontName = "System"
		  g.TextFont = fontName
		  
		  If me.fontSize = 0 Then me.fontSize = 12
		  g.TextSize = fontSize
		  
		  Var captionWidth As Double = g.TextWidth( Me.caption )
		  
		  Var captionHeight As Double = g.TextHeight
		  
		  Var baselineShift As Double = g.TextHeight - g.TextAscent
		  
		  g.DrawString( Me.caption, ( g.Width - captionWidth ) / 2, ( ( g.Height - captionHeight ) / 2 ) + _
		  captionHeight - baselineShift )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ProportionalScale(Pic as Picture, Width as integer, Height as Integer) As Picture
		  //https://forum.xojo.com/17230-is-there-a-simple-way-such-as-property-method-to-scale-image-in
		  
		  // Calculate scale factor // original method
		  //Dim factor As Double = Min( Height / Pic.Height, Width / Pic.Width )
		  
		  //my scale factor - should fit width of container always and if necessary increase height (change min to max)
		  Var factor As Double
		  If pic.Width > pic.Height Then
		    factor = Max( Height / Pic.Height, Width / Pic.Width )
		  Else
		    factor = Min( Height / Pic.Height, Width / Pic.Width )
		  End If
		  
		  // Calculate new size
		  Dim w As Integer = Pic.Width * factor
		  Dim h As Integer = Pic.Height * factor
		  
		  // create new picture
		  Dim NewPic As New Picture( w, h, 32 )
		  
		  // draw picture in the new size
		  NewPic.Graphics.DrawPicture( Pic, 0, 0, w, h, 0, 0, Pic.Width, Pic.Height )
		  
		  // return scaled image
		  Return NewPic
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function selectFillColour() As color
		  //fill colours for each theme - more can be added here
		  
		  Var tColour As Color
		  
		  
		  Select Case Me.colourTheme
		  Case 1 //dark theme
		    If pressed Then
		      tColour = kBlackPressed
		    Elseif hovered Then
		      tColour = kBlackHover
		    End If
		    
		  Case 2 //red theme
		    If pressed Then
		      tColour = kRedPressed
		    Elseif hovered Then
		      tColour = kRedHover
		    End If
		    
		  Case 3 //light theme
		    If pressed Then
		      tColour = kWhitePressed
		    Elseif hovered Then
		      tColour = kWhiteHover
		    End If
		    
		  Else
		    If pressed Then
		      tColour = kBlackPressed
		    Elseif hovered Then
		      tColour = kBlackHover
		    End If
		  End Select
		  
		  Return tcolour
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function selectLineColour() As color
		  //line/border colours for each theme - more can be added here
		  Var tColour As Color
		  Var t As Integer = Me.colourTheme
		  
		  Select Case t
		  Case 1 // dark theme
		    tColour = kBlackBorder
		    
		  Case 2 // red theme
		    tColour = kRedBorder
		    
		  Case 3 // light theme
		    tColour = kWhiteBorder
		    
		  Else
		    tColour = kBlackBorder
		    
		  End Select
		  
		  Return tColour
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function selectTextColour() As Color
		  //text colours for each theme - more can be added here
		  Var tColour As Color
		  Var t As Integer = Me.colourTheme
		  
		  Select Case t 
		  Case 1 //dark theme
		    If pressed Or hovered Then
		      tColour = Color.White
		    Else
		      tColour = Color.Black
		    End If
		    
		  Case 2 //red theme
		    If pressed Or hovered Then
		      tColour = Color.White
		    Else
		      tColour = kRedBorder
		    End If
		    
		  Case 3 //light theme
		    tColour = Color.White
		    
		  Else
		    tColour = Color.Black
		    
		  End Select
		  
		  Return tColour
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event action()
	#tag EndHook


	#tag Property, Flags = &h0
		arc As Integer = 40
	#tag EndProperty

	#tag Property, Flags = &h0
		caption As string = "SKCanvasButton"
	#tag EndProperty

	#tag Property, Flags = &h0
		Attributes( Dark = 1, Red = 2, Light = 3 ) colourTheme As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0
		fontName As string = "Calibri"
	#tag EndProperty

	#tag Property, Flags = &h0
		fontSize As Integer = 14
	#tag EndProperty

	#tag Property, Flags = &h21
		Private hovered As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		image As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		lineThickness As double = 2
	#tag EndProperty

	#tag Property, Flags = &h21
		Private pressed As Boolean
	#tag EndProperty


	#tag Constant, Name = kBlackBorder, Type = Color, Dynamic = False, Default = \"&c262626", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kBlackHover, Type = Color, Dynamic = False, Default = \"&c383838", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kBlackPressed, Type = Color, Dynamic = False, Default = \"&c262626", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kRedBorder, Type = Color, Dynamic = False, Default = \"&c7D0C25", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kRedHover, Type = Color, Dynamic = False, Default = \"&c7C0B24", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kRedPressed, Type = Color, Dynamic = False, Default = \"&c540012", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kWhiteBorder, Type = Color, Dynamic = False, Default = \"&cD6D6D6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kWhiteHover, Type = Color, Dynamic = False, Default = \"&c6A90B3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kWhitePressed, Type = Color, Dynamic = False, Default = \"&c435C73", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=false
			Group="Appearance"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=false
			Group="Appearance"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocus"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowTabs"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="caption"
			Visible=true
			Group="SKCButton"
			InitialValue="SKCanvasButton"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="image"
			Visible=true
			Group="SKCButton"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="colourTheme"
			Visible=true
			Group="SKCButton"
			InitialValue="Dark"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"1 - Dark"
				"2 - Red"
				"3 - LIght"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="lineThickness"
			Visible=true
			Group="SKCButton"
			InitialValue="2"
			Type="double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="arc"
			Visible=true
			Group="SKCButton"
			InitialValue="40"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="fontName"
			Visible=true
			Group="SKCButton"
			InitialValue="Calibri"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="fontSize"
			Visible=true
			Group="SKCButton"
			InitialValue="14"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DoubleBuffer"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InitialParent"
			Visible=false
			Group=""
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
