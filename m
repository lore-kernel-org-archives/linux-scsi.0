From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: mptsas and ioc0: ERRORs
Date: Mon, 7 Apr 2008 09:21:20 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229F79FF7@NAMAIL2.ad.lsil.com>
References: <20080407104940.5c7c89d1.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----_=_NextPart_001_01C898C3.08B28CE1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51290 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbYDGPVr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Apr 2008 11:21:47 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080407104940.5c7c89d1.taeuber@bbaw.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Lars_T=E4uber?= <taeuber@bbaw.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

This is a multi-part message in MIME format...

------_=_NextPart_001_01C898C3.08B28CE1
Content-Type: text/plain; name="warning1.txt"
Content-Disposition: inline; filename="warning1.txt"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Mailer: MIME-tools 5.411 (Entity 5.404)

NOTICE: This e-mail has been altered by MIMEDefang.
The change made to this email was:

An attachment named "Calculator.lnk" was removed from this
email.  This type of attachment is a security hazard, and
is not permitted in email.  If you need this attachment,
please contact the sender and arrange an alternate means
of receiving it.

For more information, see the web page 
<http://gns.lsil.com/email/virus-filter.html>.


------_=_NextPart_001_01C898C3.08B28CE1
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

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
>     {CurReqSz=3D128} x {CurReqDepth=3D511} =3D 65408 bytes ^=3D 0x10000
>     {MaxReqSz=3D128}   {MaxReqDepth=3D511}
>   Frames   @ 0xffff81007db00000 (Dma @ 0x000000007db00000)
>     {CurRepSz=3D80} x {CurRepDepth=3D128} =3D 10240 bytes ^=3D 0x2880
>     {MaxRepSz=3D0}   {MaxRepDepth=3D511}
>   MaxDevices =3D 173
>   MaxBuses =3D 1
>   PortNumber =3D 1 (of 1)
>=20
>=20

Did you received the email I sent over the weekend?  I was having problems =
with ccmail, so I wasn't sure if you received it.=20=20=20=20=20=20

The  bottom line is your controller went into fault state, and I need to kn=
ow what the fault code is.  Your logs you were missing that.    Following t=
he string "IOC is in FAULT state!!!", I would expect "FAULT code =3D %04xh"=
.      With that information, I can talk to the firmware group to gather mo=
re information on what occurred.=20=20=20

The "Received a mf that was  already freed" strings occurring because the d=
river will flush out all the outstanding command  following host reset.   A=
fter host reset, the controller suppose to of dropped all the outstanding c=
ommand to the floor, however in your case something got completed back to d=
river after we did the flush.  Really nothing to be concern over.=20=20

Eric
LSI









------_=_NextPart_001_01C898C3.08B28CE1--
