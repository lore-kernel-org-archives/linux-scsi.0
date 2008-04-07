From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: mptsas and ioc0: ERRORs
Date: Mon, 7 Apr 2008 09:29:52 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229F7A000@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52078 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbYDGPaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 11:30:05 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Lars_T=E4uber?= <taeuber@bbaw.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

On Monday, April 07, 2008 2:50 AM, Lars T=E4uber wrote:
> Hi there!
>=20
> Because it might be of interest:
>=20
> monosan:~ # cat /proc/mpt/version=20
> mptlinux-3.04.05
>   Fusion MPT base driver
>   Fusion MPT SAS host driver
> monosan:~ # cat /proc/mpt/ioc0/info=20
> ioc0:
>   ProductID =3D 0x2202 (LSISAS1068)
>   FWVersion =3D 0x01120000
>   MsgVersion =3D 0x0105
>   FirstWhoInit =3D 0x00
>   EventState =3D 0x01
>   CurrentHostMfaHighAddr =3D 0x00000000
>   CurrentSenseBufferHighAddr =3D 0x00000000
>   MaxChainDepth =3D 0x60 frames
>   MinBlockSize =3D 0x20 bytes
>   RequestFrames @ 0xffff81007db02800 (Dma @ 0x000000007db02800)
>     {CurReqSz=3D128} x {CurReqDepth=3D511} =3D 65408 bytes ^=3D 0x100=
00
>     {MaxReqSz=3D128}   {MaxReqDepth=3D511}
>   Frames   @ 0xffff81007db00000 (Dma @ 0x000000007db00000)
>     {CurRepSz=3D80} x {CurRepDepth=3D128} =3D 10240 bytes ^=3D 0x2880
>     {MaxRepSz=3D0}   {MaxRepDepth=3D511}
>   MaxDevices =3D 173
>   MaxBuses =3D 1
>   PortNumber =3D 1 (of 1)
>=20
>=20

Did you received the email I sent over the weekend?  I was having probl=
ems with ccmail, so I wasn't sure if you received it.     =20

The  bottom line is your controller went into fault state, and I need t=
o know what the fault code is.  Your logs you were missing that.    Fol=
lowing the string "IOC is in FAULT state!!!", I would expect "FAULT cod=
e =3D %04xh".      With that information, I can talk to the firmware gr=
oup to gather more information on what occurred.  =20

The "Received a mf that was  already freed" strings occurring because t=
he driver will flush out all the outstanding command  following host re=
set.   After host reset, the controller suppose to of dropped all the o=
utstanding command to the floor, however in your case something got com=
pleted back to driver after we did the flush.  Really nothing to be con=
cern over. =20

Eric
LSI







--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
