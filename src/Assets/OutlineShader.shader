Shader "Unlit/OutlineShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_OutlineColor("Outline color", Color) = (1,0,0,1)
		_OutlineSize("Outline Size", Range(0.00, 0.1)) = 0.01
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			uniform fixed4	_OutlineColor;
			uniform fixed   _OutlineSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
				fixed col0 = tex2D(_MainTex, i.uv).a;
				fixed a = col0;
				if (a < 1.0) 
				{
					fixed col1 = tex2D(_MainTex, i.uv + float2(-0.35, -0.35) * _OutlineSize).a;
					fixed col2 = tex2D(_MainTex, i.uv + float2(-0.35, +0.35) * _OutlineSize).a;
					fixed col3 = tex2D(_MainTex, i.uv + float2(+0.35, -0.35) * _OutlineSize).a;
					fixed col4 = tex2D(_MainTex, i.uv + float2(+0.35, +0.35) * _OutlineSize).a;
					fixed col5 = tex2D(_MainTex, i.uv + float2(-0.50, +0.00) * _OutlineSize).a;
					fixed col6 = tex2D(_MainTex, i.uv + float2(+0.50, +0.00) * _OutlineSize).a;
					fixed col7 = tex2D(_MainTex, i.uv + float2(+0.00, -0.50) * _OutlineSize).a;
					fixed col8 = tex2D(_MainTex, i.uv + float2(+0.00, +0.50) * _OutlineSize).a;

					a = max(a, col1);
					a = max(a, col2);
					a = max(a, col3);
					a = max(a, col4);
					a = max(a, col5);
					a = max(a, col6);
					a = max(a, col7);
					a = max(a, col8);
				}

                return fixed4(_OutlineColor.xyz, a * _OutlineColor.a);
            }
            ENDCG
        }
    }
}
