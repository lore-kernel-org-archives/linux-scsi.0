From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH]improve Documentation for DC395
Date: Fri, 23 May 2003 23:02:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305232302.04907.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mail1.KONTENT.De ([81.88.34.36]:20703 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S264185AbTEWUsi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2003 16:48:38 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, dc395x@twibble.org

Hi,

this improves the Documentation for the DC395 driver for 2.5.
James, if nobody objects, could you send it onwards?

	Regards
		Oliver

You can import this changeset into BK by piping this whole message to:
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.1211, 2003-05-23 22:52:28+02:00, oliver@oenone.homelinux.org
  dc395-doku.diff


 dc395x.txt |   94 ++++++++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 62 insertions(+), 32 deletions(-)


diff -Nru a/Documentation/scsi/dc395x.txt b/Documentation/scsi/dc395x.txt
--- a/Documentation/scsi/dc395x.txt	Fri May 23 22:57:18 2003
+++ b/Documentation/scsi/dc395x.txt	Fri May 23 22:57:18 2003
@@ -23,40 +23,70 @@
 Both can be overriden by command line parameters (module or kernel
 parameters).
 
-The syntax is as follows:
- dc395x = AdapterID, SpeedIdx, DevMode, AdaptMode, Tags, DelayReset
+The following parameters are available:
 
-AdapterID : Host Adapter SCSI ID
-SpeedIdx  : 0,1,...7 = 20,13.3,10,8,6.7,5.8,5,4 MHz               [ 7]
-DevMode   : Bitmap for Dev Cfg                                    [63]
-AdaptMode : Bitmap for Adapter Cfg                                [47]
-Tags      : The number of tags is 1<<x, if x has been specified   [ 4]
-DelayReset: The seconds to not accept commands after a SCSI Reset [ 1]
-
-DevMode bit definition:
-   Bit Val(hex) Val(dec)  Meaning
-   *0	 0x01	    1	  Parity check
-   *1	 0x02	    2	  Synchronous Negotiation
-   *2	 0x04	    4	  Disconnection
-   *3	 0x08	    8	  Send Start command on startup. (Not used)
-   *4	 0x10	   16	  Tagged Command Queueing
-   *5	 0x20	   32	  Wide Negotiation
-
-AdaptMode bit definition
-   Bit Val(hex) Val(dec)  Meaning
-   *0	 0x01	    1	  Support more than two drives. (Not used)
-   *1	 0x02	    2	  Use DOS compatible mapping for HDs greater than 1GB.
-   *2	 0x04	    4	  Reset SCSI Bus on startup.
-   *3	 0x08	    8	  Active Negation: Improves SCSI Bus noise immunity.
-    4	 0x10	   16	  Immediate return on BIOS seek command. (Not used)
- (*)5	 0x20	   32	  Check for LUNs >= 1.
-
-If you set AdapterID to -1, the adapter will use conservative
-("safe") default settings instead; more precisely, dc395x=-1 is a
-shortcut for dc395x=7,4,9,15,2,10
+ - safe
+   Default: 0, Acceptable values: 0 or 1
+
+   If safe is set to 1 then the adapter will use conservative
+   ("safe") default settings. This sets:
+
+		shortcut for dc395x=7,4,9,15,2,10
+
+ - adapter_id
+   Default: 7, Acceptable values: 0 to 15
+
+   Sets the host adapter SCSI ID.
+
+ - max_speed
+   Default: 1, Acceptable value: 0 to 7
+   0 = 20   Mhz
+   1 = 12.2 Mhz
+   2 = 10   Mhz
+   3 = 8    Mhz
+   4 = 6.7  Mhz
+   5 = 5.8  Hhz
+   6 = 5    Mhz
+   7 = 4    Mhz
+
+ - dev_mode
+   Bitmap for device configuration
+
+   DevMode bit definition:
+      Bit Val(hex) Val(dec)  Meaning
+      *0    0x01       1     Parity check
+      *1    0x02       2     Synchronous Negotiation
+      *2    0x04       4     Disconnection
+      *3    0x08       8     Send Start command on startup. (Not used)
+      *4    0x10      16     Tagged Command Queueing
+      *5    0x20      32     Wide Negotiation
+
+ - adapter_mode
+   Bitmap for adapter configuration
+
+   AdaptMode bit definition
+      Bit Val(hex) Val(dec)  Meaning
+      *0    0x01       1     Support more than two drives. (Not used)
+      *1    0x02       2     Use DOS compatible mapping for HDs greater than 1GB.
+      *2    0x04       4     Reset SCSI Bus on startup.
+      *3    0x08       8     Active Negation: Improves SCSI Bus noise immunity.
+       4    0x10      16     Immediate return on BIOS seek command. (Not used)
+    (*)5    0x20      32     Check for LUNs >= 1.
+
+ - tags
+   Default: 3, Acceptable values: 0-5
+   
+   The number of tags is 1<<x, if x has been specified
+
+ - reset_delay
+   Default: 1, Acceptable values: 0-180
+
+   The seconds to not accept commands after a SCSI Reset
+
+
+For the built  in driver the parameters should be prefixed with
+dc395x. (eg "dc395x.safe=1")
 
-If you specify -2 for a value, it will be ignored. You don't need to
-specify all six parameters.
 
 Copyright
 ---------

===================================================================


This BitKeeper patch contains the following changesets:
1.1211
## Wrapped with gzip_uu ##


begin 664 bkpatch8940
M'XL(`"Z+SCX``[566W/:.!1^CG_%F?0E:<%(\@V8TMDD;%MF>\F&=/>E,QG%
M%EA3VV(LF9`=?OP>R28E4YJ=[;0$8HYTKM\Y^L0S^*1%/3Y2A5R+VGL&;Y4V
M*(I*5<+/52D*634;7]5+W+Q2"C<'=GG06@RN:R'T0&=B[:'")3=I#KBNQT?4
M#QY6S/U*C(^N?G_SZ=W9E>=-)G"1\VHIYL+`9.(95:]YD>G?N,D+5?FFYI4N
MA>%^JLKM@^J6$<+P+Z))0*)X2V,2)MN49I3RD(J,L'`8AUZ;V6^':GCL"YTP
M1N(H"H=;$B2$>5.@/F64`@D&)!JP`!@;1VS,AB\(&Q,"3_B&%Q3ZQ#N'GUO-
MA9="E@:CJ)^I+XV?R<7"^P."*!IZEU]1]/K_\^5YA!/OU5,%;:<J;4I1&6ZD
MJ@8ZU7+@,MGX9M,!&+(8X4I"3#^,DW@;,A&$*;U-@C#A(PXKV_X?]AZQ@)%P
M%`9;0J.`N,%YTLP.TZ^MZ&>Y3[;A,`@#-W&L&S<Z`C(<!Z,Q&W7C]GWXX$7,
MH!^P7S)OLW*E:M-&_V;X7D,PBF,:XA2ZIGR$?GWGWCA5ET_WYP?&=,IB8-Z,
M)4"]ZUS`0A6%NI/5$M.K.9:)9`.\%L#77!;\MA!CM!D!&WJS*(:8>M`'S1?"
M`X"I6/"F,&,@/3A+4[$RU@`0OD9H7`558YC/5G6V<%8@-6AD*:.`@LE%9?\!
MS_@*`\.=+`IHM(!45<BC:RQZ[0*='%OCXU/(VHC6A\&DM0_7>>M2CS'0T9'.
M$>JT,5A8W6*]F22]L#?JT:C'>I38=/J[B#<R>U1'\ITZ;+I16PBV7KND<Z3V
MA\SG%_,9S*9^Z[WDFQN]$N*Q<_JM\\YW8O4(3(`1_/(^_\?*%&7*<)H[F5EY
M;S]`>0A?Y1#EV$\>Y`CER$>-MZT<6WE//T$YW,DN;;QU;DJ5.<3/I2GYJD51
MK&7J>K*0RZ9VD]AB,17K]Z@/M]+8SLA*VKVQW6I=P%^\.,G%YM1]R41ZBN$$
MK[!UG=)S6Q&0#:&M#.WSDM?2W$.:B_3+3I-VFJS3;)_S^RK-:U6I1L,'L51&
MM@EV1JPS"CNC]CF5&LNI1+JO&G2JPTZU?<Y%E<'<<#S`>/Y+CI*J0-N%9N7#
MR0=E[,AFISLW8>O&M<K6$[O'-5\N1087G8L_&]&(/12BUHAU1D%;V]\2P=TO
MZM'L'FC5;AP/].K,;AWHUD]HUKQ9.8(K%?*&08($<Z<@J_'PZD,('6XD_G*"
MZ<>Y11F94MHS@F6M+#79TMY.-2QKP6UY+@9]<^X_W>4K8:G&'<USG(Z]MCW=
M\K/4\HX%WN$WM@1>*RSFJZ]*24Q7EF6#*-[O_,'AWL_*4F3800&U,$U=V4S.
M9UBJ%N++;JJ^`>KD^>GAJ;BPA\)A\N[3!PVOD!8ZWC%\J1]13G"8S_J1U;(?
M>P5437F+H*J%L[<,35^^W/1`+F`#.==P*Y"GD<]2N9#(:2Y4;;&]R43![_^+
MY%Q$.B3M'-J(6N"`9MI27X4U<V>P`P*OGX5M,F_1=DU$T\_>:U4[XKUM)-X`
M(*MVQ-K%O=L+KX"FR#!K6-4XYAL\=G?2Y%YW;\*)6,)Q)]AK94*/3[UI-,1[
9\>$7MB,>W903%@T7(4\S[U_^I,AVVPL`````
`
end

