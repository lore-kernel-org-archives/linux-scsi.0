From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [patch 1/1] megaraid build fix, updated megaraid driver 2.20.
	3.0
Date: Thu, 19 Aug 2004 11:28:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC97B@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C48601.340468D0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:12937 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266254AbUHSP3C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 11:29:02 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Andrew Morton' <akpm@osdl.org>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C48601.340468D0
Content-Type: text/plain;
	charset="iso-8859-1"

Updated megaraid driver version 2.20.3.0 is being released. It has some of
the change discussed on the list during last weeks and fix for issues found
internally. The highlights of the release is inlined with this mail. I am
also attaching the patch against the previous version 2.20.2.0

The complete driver source code and patches for lk 2.6.8.1 are available for
download at
ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.3.0/


i.	When copying the mailbox packets, copy only first 14 bytes (for
32-bit
	mailboxes) and only first 22 bytes (for 64-bit mailboxes). This is
to
	avoid getting the stale values for busy bit. We want to set the busy
	bit just before issuing command to the FW.

ii.	In the reset handling, if the reseted command is not owned by the
	driver, do not (wrongly) print information for the "attached" driver
	packet.

iii.	Have extended wait when issuing command in synchronous mode. This is
	required for the cases where the option ROM is disabled and there is
	no BIOS to start the controller. The FW starts to boot after
receiving
	the first command from the driver. The current driver has 1 second
	timeout for the synchronous commands, which is far less than what is
	actually required. We now wait up to MBOX_RESET_TIME (180 seconds)
for
	FW boot process.

iv.	In megaraid_mbox_product_info, clear the mailbox contents completely
	before preparing the command for inquiry3. This is to ensure that
the
	FW does not get junk values in the command.

v.	Do away with the redundant LSI_CONFIG_COMPAT redefinition for
	CONFIG_COMPAT. Replace <asm/ioctl32.h> with <linux/ioctl32.h>

		- James Bottomley <James.Bottomley@SteelEye.com>, 08.17.2004
		 linux-scsi mailing list

vi.	Add support for 64-bit applications. Current drivers assume only
	32-bit applications, even on 64-bit platforms. Use the "data" and
	"buffer" fields of the mimd_t structure, instead of embedded 32-bit
	addresses in application mailbox and passthru structures.

vii.	Move the function declarations for the management module from
	megaraid_mm.h to megaraid_mm.c

		- Andrew Morton <akpm@osdl.org>, 08.19.2004
		linux-scsi mailing list

viii.	Change default values for MEGARAID_NEWGEN, MEGARAID_MM, and
	MEGARAID_MAILBOX to 'n' in Kconfig.megaraid

		- Andrew Morton <akpm@osdl.org>, 08.19.2004
		linux-scsi mailing list

ix.	replace udelay with msleep

x.	Typos corrected in comments and whitespace adjustments, explicit
	grouping of expressions.

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@osdl.org]
> Sent: Thursday, August 19, 2004 1:22 AM
> To: James.Bottomley@steeleye.com; linux-scsi@vger.kernel.org
> Subject: Re: [patch 1/1] megaraid build fix
> 
> 
> 
> hm, unregister_ioctl32_conversion() isn't implemented either. 
>  Maybe this
> would be better: 
> 
> 
> diff -puN include/linux/ioctl32.h~megaraid-build-fix 
> include/linux/ioctl32.h
> --- 25/include/linux/ioctl32.h~megaraid-build-fix	
> 2004-08-18 22:15:26.126368872 -0700
> +++ 25-akpm/include/linux/ioctl32.h	2004-08-18 
> 22:21:01.287416648 -0700
> @@ -3,6 +3,15 @@
>  
>  struct file;
>  
> +typedef int (*ioctl_trans_handler_t)(unsigned int, unsigned int,
> +					unsigned long, struct file *);
> +
> +struct ioctl_trans {
> +	unsigned long cmd;
> +	ioctl_trans_handler_t handler;
> +	struct ioctl_trans *next;
> +};
> +
>  /* 
>   * Register an 32bit ioctl translation handler for ioctl cmd.
>   *
> @@ -13,16 +22,16 @@ struct file;
>   *                        struct file *file: file descriptor pointer.
>   */ 
>  
> -extern int register_ioctl32_conversion(unsigned int cmd, int 
> (*handler)(unsigned int, unsigned int, unsigned long, struct file *));
> -
> +#ifdef CONFIG_COMPAT
> +extern int register_ioctl32_conversion(unsigned int cmd,
> +				ioctl_trans_handler_t handler);
>  extern int unregister_ioctl32_conversion(unsigned int cmd);
>  
> -typedef int (*ioctl_trans_handler_t)(unsigned int, unsigned 
> int, unsigned long, struct file *);
> +#else
>  
> -struct ioctl_trans {
> -	unsigned long cmd;
> -	ioctl_trans_handler_t handler;
> -	struct ioctl_trans *next;
> -};
> +#define register_ioctl32_conversion(cmd, handler)	({ 0; })
> +#define unregister_ioctl32_conversion(cmd)		({ 0; })
> +
> +#endif
>  
>  #endif
> _
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


------_=_NextPart_000_01C48601.340468D0
Content-Type: application/octet-stream;
	name="megaraid2.20.2.0-2.20.3.0.patch.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="megaraid2.20.2.0-2.20.3.0.patch.gz"

H4sICFrLJEEAA21lZ2FyYWlkMi4yMC4yLjAtMi4yMC4zLjAucGF0Y2gAvTxpd9tGkp+hX9FRNg4p
EjQB8JRij2mJsjkRJY8kx9lN8vBAoClihIODQ8dM/N+3qrtxEqAoObt5fhIFVFVX19V1NGPZyyWR
z404IC69MQLDttSO2u2one7r45Xh3dAz/6aTvCrCaJUwe7Is70JLUrvdntwdycqYKMphr3eoDTuK
1te6vdF4QORur9vda7Vau6xZpqUdKhpA97uDnqqpgta7d0RW2kqXtJT2oEfevdtrXVKHGiElJ0ZE
pUNyvYrJJL4hQKU7PuyPDjWNTE+uCVInMplEsUPm8e0tDchPBvzhvnNC2+mYvvt2r3UcBwH1IvIL
DULb94BcwjBphGZoE9e3Yoc22yQRCmmYrps83mtdOBYQLqGrNejKBvpey+5IX1bUI6a/frS9GxKt
KHEN21n4D2RtmLc0CtvsJfE955Es7SCMiNIji8eIhqSx9AOiqfLCjvZaksCjYZMYnpVHUNU8wqCH
CCQD74AU7ZDAv8gHOsadD2ZzQ6Mo4SiMDIeSO8OJgQaSWMThIwEiHfKFknsDRBj5JKQRg8aXQAbX
+GcMqy8ooFAgH8ZIEETvIn+AgdCnXzpMECCJmceeBBQpgcFYDsC3ib3MHlMrxQd2PT8i/r0HDxeP
CAOrWoF9R4M2sXz2tnEf+N6N89gk68AGNm0PeHGNCNTFNoKE940oMswVtfYJxwYyXPaCM2Dto3FH
CX2IqGfBavcG7O0e9VbelO2R8NEzV7CqH4eoaZpKF8gG9F+xHQCFZG0TTDlEUiAg/NtfM9YuL+a4
P8sOjYUD4ExeDIiR8XzyfnZxxYQeGQEXu+l7UeA7Dg1wRRQsf4laJQsfhGEsI7DWgJrUvgOmgRDi
cRNJNrAMfJeR46LgpEzhJ/wZqCYkCqgbVrSQiO1SP47SPeUFIMiCEd+vbHOFm1oaAXFoCGyBiuGx
EfFNGWYUGw7YbCIkZlyef8/FHa9xH/P3F7/ql9Or6bV+PZtPSUMZdQUnYPbAARCCjbPtrgPfhHW4
Eu+YeSXBR3fB8nUAsGIz0tEowMsgrgQFB0SJwrbZLtYOGJ/D7Jqb8zqgayNIPCQVH8jA9pD/Ry3v
VoR6Ycx0bETCUoFNy6fciMHZwFe828THbC9Ple0ANnDiE+PeeCT3drQSLmHFnoXud3Y1048vzk9n
H+DX/NPkGt/Rpe3ZianDigWADrmka8cwKcTF0H1t+2bkaGpn9ZaT/wl8L37IPUYeJEkmfzdcYPC9
H0W+69BH8hN70EkfvLuKKHWmj5TF2DbpjjrKsIPhGPEJIyvz6AhiRvk5dhixHYKfTSyLhPF67Qfc
nkSsMtZrxzaZ24Ydclwwx5AY4IQuZQEP1uDxsIDSJvQOnBUEIejBxiMMBEDsc8g9b98yImMfPQ1o
7C/i5ZIG++Ac1LFC4vMQ5NqupUfgVgGYDagTYpMXRtSwEIC6C2phdEgDsmFZELRCrs8cP6mBocWs
gftoFcQZVW6xdxh25v4d524ZeyZDtajpgAmzbaUeB0Zi3FAXZcLPFubGeCSk9u52VmiG+QdmotKJ
B3zekzkIHVb4ybhdu+/80HI6fnAjNDhONbhVgcgzP+qB0aURO1H+1JhPP0wuJ7MT/Xz65cP0vJ09
mM/bQvLZo8nsDJwdmf7R+xEl+DP449LOZS1/Mfv2QwcCNPeJ2KJO4mlu6FC6RggAuH5c+xgQwAJN
PI1sj3kpCxOoTghzcNCukYZh4fHHXoEBPqD6mVncBH68xoXRaB7WaCLMrnGFPVLKb04Dm/wdchhV
I0r/UFUPu8Od8xtSk9/snKCQyvxGqUHvbqDvEeHSn45nxLa4FUxMIAkH3HuiTknoOzHaMsDKdgXw
rEecW/jHE4TNt2wNfIV6yakF34bxInwE3+N/pflwCH5OtG5X7j0AtrUlmS4b3GZau2GSlYl0GUqk
vkMZlTo8hH99AEv+25ZG11DaKYnWMIlWFEyiCSdTdsg9IsHB6ZB9OE0I5Oq2Sc7BsT5Qj/KIQxCY
nNA7G8z7hEff/T1ZSny9cXUMmK9eoZJA/fB8DQlTiIEX1QYvEABerKizhl/ZOhWEUbVlPudzwIoC
cFjwjjyf8ywCznkEbCDrnFQzz+N/bW66mk38vQkrON9cD5KJO9vCWI9HZhuyoHAZFs6ylFuukVF7
CBoZtAdMIxV75QGwbsNgAVxoPCd7ertMdjtslcElCoKFMUyJbbDsO8kyQ7aN3ghtqtXrY5WGG2FK
Tblj1DUVnO1XSQHjPgSLBItnn/qaUguuTFPwkQDvduvB1SpwFcRQBJ9cTyCKArgE4OP+oaYoaspM
b4N6At6TOHVlPOhy8F5f1WrBBxvgXQSvYyYnmTEH1/CsqgMfVYGP4FjZBGdBrpp6HXgNdSLNzq+n
Z9xNj1MTIFeXx597al61o+5ogNJUt+FcKYOciAQKk+i2ZfI65jioYzTCgQpe1OqjRzETrKMCh04V
Ha03Hm9du6+cVfDbBZzTq+NMiuhRU36gswMub5NDrQfyHPRB8pPj6WWGhIBovwUDVvuwud4JhgXp
2mf1h+1gJohFIXd4qMEMcdJC7bLyfcgZ5gRrxENWYBBJpIL3tuNADQ6lpoOlZKEE4tIbYyQaJJEI
yu1S2HvjbUanM/hw/N81wekM1jAfyzHqW06K69zORTAKWepbMOMeBFXSU/GHhj9gT2QIxkF64+7W
k74glI65efCWAKrP+RJQ+ZgfHaq93Y75akLlU34Ap3x31M2d8r0BD8aDJBiTA1IbjpnBSei04hOL
x7UYyjTDGIlPLCTXYqiVGBCVNzBKcVnCuJwy1atYohSZJfRL/olH5lqEwQYCj831K+QENeafeHiu
xRhVYkCErsQQMbpyjXqMujVg42zzT0drrngMZRKP1tuwMF7n5CawQG4sfPQx+A567XFichAUpe1B
UZgEBEWJBUXBN9sxhkepOjwmlqT2JRYeWxyFLwoZFgSJyA8eMWMxWRUKhVdIIaP0zRhzNZbEVvW/
gcBrCLYsL9OG4/YIMjNtpIjzBKi/C821BAXQ2rc9bKKJ5iWrgnINzQU2CakZQ6bE0SzfwyoOY+/C
MG8JlH6R7VEBK0Iy78uxho9rse7agqY9J0aImds/YhoDfVDMI+eD1zWil7CAorGQnon2Ux7e5g05
KLeQHq+KXBQYsj+72KTBFPLcdYU08VSAswDg97JD519ISxcSa/CWB5OibrrAwwGIuU1Y/7lxQFB4
zQqgZpNrajjGM6sFv4egMXbyS1/xR0CjOPAAZXEEf35ljYLXr8n5xTW5nE6OP07hZP2Khyujoyp9
1HQLfveExtnBCxjH2Hlnp65g+ccw3Tj2i3B3Ptk3LGMNKvwx3E/ewlEHojXXj42GiW0gPWpiLAcv
IekD01zIb5Onaq95xBo2z0JSm7hB/FN+C7YDYnuDu5bfhp5/xDYhWJPfguGBRjzL9m5AjFbYah3x
3Q9VDVy3Bb8HQoqABklA47ulH3tWk/wHRQoK1h3/pnF8pk/Oz4Ghn6eX5/qXyeX57PwD7FaS9tMy
2VjA8XxIfnCswx+s337An3+Ijvw99ut/9/bbDAW0DazSwDYc3YvdBTbuE/bFJ4ve6ejLHnUSHPE0
MoIbGjWZ2CpW567pwuKOtbF4q3JxpIWbR82fzn6dTw/J1cqPnaT3Dl5pZK7Mm2+ZafwtZ3lXn4+P
p1dXQsJjZdxW0MDGqtLWRI567y4aTHtfLmfnJxcXlw3mILCzNkk+cU3rlmuQP0n3QWH8ycgea4lz
N3yw3dhN+/G88wGuF7O289rH3tZzMTpktkwGP/iYj1o4HeMOLBynEqw5ZnspnXbShz39ggis9Ww4
9r+x08U6Y4YtSOCChpeNUwwXDI3VmThKENbHjRoUI3h48wYkcHoK5ogkxEPsnT/SKGMKdcB7dw21
3zzi8pJwwYYNvtE9IjV0MeW0yU8Ej5kjYrdaTWZtLqelcCt7ER3wHzS3gOsbP/KGYkIUwxOzOty1
jXQQF9GQgaf9Lmf6Ivgc5sWTigYMHw0cUYSVygrnp3oNiJaz4ykDqFoitSdQtxgwddgCrCtbEFW9
Ll+94vSlBsosN9z5MpldNwvyywtwk+N9sbaUEy9KkT/6KphKJVxeCdeooVyQNxfG796zJC4ol4T+
tVr0+7/5t38IRHGcfU3OqbGG5xyEkf447bZkrrKG45d8h5IdDkXQznlCnSPksZ7tA5UrA5FGQqW5
qwtUOwB5UiFcLnBuM7kMRwW5XJ6UIiswB0yqu0inDvf5Mqrn4v9dUlgjYKajdbUk08kZEM7tmyRn
pvkkaDPrWcFBkQ2tahKeXOYSGPc6f6QManOdavheOc2RJBZBptljZB6fKtkjNEsGeCQ2D4k9pIua
0u2nm/ciDAtsq5yjkEaNCha6kI7Y/6b+spE8a6Y8gZ6ZBPUIUtPktZDeAV961NWY3EdaN1n61vZN
yD9Y2BBccnIDKGolQXLQY0QbsRfaN3jPwfG9myZHBUEs4mWGxZMFTe0ImkkmyP7CuJ+wxqjHsPWR
Hh2AFRbRUTNVkMDGBmSaJ69jTNAXydx6GUDRtfZ95xlNl9VTbZDVLk2X1ctnK9WEnm66QE6HwUcR
yfP3tmc6EFpIembqbCLQWe0zecnfs7k8zVppv0wvr2YX59J+sqf9CqDpr9cZYCM/JOR3oNiMUMUZ
IfaZ1HRG2Nzfaz2xooYrbgI9tWLdrasm3ycB299N++72hpv7dLvN3Wy2vUTvbm2rbdgdaGN1lB+o
DXnp2dbGomaqUDxO3VEakAGAk0yzCpqPL6GuCSBjsGh67yirmYkrKOj+mnpJEWwz6IO2iLtkiV3h
A4ymVZjM7rajtgm6N/wsBBiWszCeRb+CVQZwvgCT7KpX4aaQzwskwm9WFVlhFyZ8HSNWQ9yegDUT
Dg1rzR/E8J6FmOJObtljX0fMRgLTTq5hHOT4/EidNQ3SaxJhgQy7SkZ1K7gLTCSU3ysXAMS3NgMt
c+A4wn0bu/DMGhcMXMfeRaMOBKliqWOBdBsbos9DrvBuEorAxA+CidXC0PlzJo2s91Jaq8RyahdQ
NuuiL5BTSnn7CfMpGhS+8ISrski5zHWKYtF6pFqtZwuye3k6nHL1uIzvOgJwmMdrLJ91PIzCndnG
80tHoICGfhyYdHfUiBqB5d9721eFcGsvIeCSwpWs6k1gI9CIhBWmxlL02k0fZj2OjSjxPXVCmsX6
gN7YIViBLq556dzF8bJHw2gvmpLl/+fr/QrQG91mhhZ7WxE30KDKt5dY5c4vTj6fTfXJ5+uPkA/n
BkbHfrD2+R2DfcyrBODJ9Or4cvbpGo6gxrZhfx7nDIrW86tpY//DpzN8zo7oUZ9nfsmEsDIuxfhh
IzjBr8zaEL65x/LtJD2TpAP+kaW0LA2UxDOWmzFqySUveHewxg8se5Iw9IDwAAHdkbXsJBGOgIa/
NiFki+RV62OWoQ3Syg9A8fIopMEj5ZDXLzwv5GiSKHKP5ydH2buHJQ0c6sFL3GsntjtLM+zAk5to
xeqLAokCjVaZxlNE4hDsA8sFna9YwK6CK1Pkd/COsoqnKjAw9SChdnGBZpPVRKKaacjT84v5dC7s
QeuNsOWpjXrJhZicNLsvkCazoQ5Ec/iTvOW7sD1kg/yNN2mkPMRhDuIFYt+6Gu+n7LLcyxWEf/yf
6GWotSHxavUUdl+J1UmQRhKJHKR3aY3seq5rHfG78flLuywtQS4Z2musS5l7klxJBRXVlpKKNclE
cfqqUax5mjz76IjCdNRMvB6qtlLNtn0FjgU4FeWXWJuvkV+uJzoVCQrKlJWqjo+qKZaBycujKoSV
zUtOuVw8JhCswF6K/5CprE+AQ6rvuI2CieqfJldX1x8vP4vOLBwNsQN57Qm8Y8wmiLlFnkFBztyt
YIdpjV4Ss/C2KhEdVZCqNn25Ep8VwxU6BYVCgGeSbkmi95ATYyOJ8pvgqQfxN4whyw7IK/J5dnGs
f7lMWjsIg5auo3XryH0jI3aHxBI3S3fW5jcCulobKqJWD84Phd/vQGdKnYjf70/vIIu7Ijd4Xzki
Hn2IiPIzWeAcyAgeO3jVVlwuASKsFcQw+JcQADKZZBpRp+R+Bd1vqh5kDgjiaGT9D76d9LCU85pj
T5m/lU7XzV5JEn2rzaFay4WldXamVSz+iuULAi5x6JzmK1SfI5kM2UpaFRC5Nlh55TYzCNGMKu+/
2RQWk8XX08nns+vmkegjyy/xJcEUN9AsrJDqF6kAc4a+sazwuw0C3P2EbJ7wihc5BanZEjuagC46
zVDBLl1rqKV9wnLdJR2wwox3wOQqTsirW5FOsp+JvliqCVoSAbWE9AROtV7hcZY43OYTqHwCOVQV
THmG2d0gNtXFnAc7PijYf0xOJp9m56cXIgGS2B5J6mbZ9je9rLUNvMIruRpK6jrKVs1KXl4Ct8kr
9idJ5yklsAJUMsfNZAxw3EDS/CWBTeXMMUV+UiFoJkVt2Fb6IMaBhr/5lQMB2s18rDLj2NbDbVWg
PNn3LXhJFiCYd7D5hjBy8oaUYdhs6bb8PqtMUBEbsmtgpXvQfNWIU+/BITtvMDfbIlqkULfVUK06
ythgrqLcTkaECVAV4cSxhS5FEZWGw8p4CMpiOu2PsLQajnqFSyRfi55dFgKP/air35ThHxCvk+dV
vXghmyrmWlukUVqDySF7WbkQqRFA3XnAWpl8INJSFC258fT6gF+qqmxCSIdEU/FbVJFPBj38wB6T
rAeQtA35TSBZ9Do2vqNW0wUp3hx6sg1CllaxE4KFAbeHgvsQI7gpdT/x57q5c5t664jCfXpA4f41
4wm3djix2aZWIU71SEtNw1XapRZf8OOXhNdA2sUv+W28X5t25XP80hT7VmD5Re4bg8WmOLvJQpch
a4nvPCXhRjOfX5zr84vy5EIpTC62grKxCqkBzY86fkdfLc87tn0LCycsmxi7TEjy3Jy8/3D2yxnY
rLW4cegddcTgsK2qpKWNxd1sqI4wXw9dvDgYRgRvBrE5W0prLr7Doc/OZ9f6+8+np/rV7H+mktTr
jgco2Nf8MuGZbyaXc4TGCLoBDahn0hBBuOMSTtcijYKTNsmffyavGrr+MBrocGbphcezCaS60/nn
swk28Jqc3HfJW0FuNhn0mmV156OBLNqH6e8t8UTOjLH4nVbExs6n/LLOp/yyzqdgGaJpxfdzUb65
QMuSPIisF44FMeoRohMPqvyL6NmcnTQsug6oCUZmNdnVUB7C1bY2IK3xMP060VeiYz8msBdxRHWd
NBqMlNVs8rXYKQ/msMtcSn7xXKoS8xvmUrLg+QVzKfnb5lLys+ZSCZ8bcyn55XMp+dlzKfnpuZS8
81xK/ua5lPxNcyn5RXMp+dvmUpX2+5y5VCWBp+dS1WzvNJeqRt1pLrU1tv6Vsyl5czaVxXeShM3X
+S8l6h/ZpYLX5M4+5P+rkfDNiIT38CO6fzMcHe79LwXCJpkYRwAA

------_=_NextPart_000_01C48601.340468D0
Content-Type: application/octet-stream;
	name="megaraid2.20.2.0-2.20.3.0.patch.gz.sig"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="megaraid2.20.2.0-2.20.3.0.patch.gz.sig"

iQA/AwUAQSTDcU7bVrSvAqjJEQKxWQCffewEr+f6bSMivd+rTOJ8zhGDNTYAn1b/QuLVZ1kJmRqD
LkA/XRGiVWI7

------_=_NextPart_000_01C48601.340468D0--
