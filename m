From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: mptsas and ioc0: ERRORs
Date: Tue, 8 Apr 2008 09:38:58 +0200
Message-ID: <20080408093858.5ea6f2ed.taeuber@bbaw.de>
References: <20080407104940.5c7c89d1.taeuber@bbaw.de>
	<0631C836DBF79F42B5A60C8C8D4E8229F79FF7@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:59693 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbYDHHhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2008 03:37:19 -0400
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id E6A5F4A807D
	for <linux-scsi@vger.kernel.org>; Tue,  8 Apr 2008 09:37:15 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 29E4E93782
	for <linux-scsi@vger.kernel.org>; Tue,  8 Apr 2008 09:37:15 +0200 (CEST)
Received: from taeuber.bbaw.de (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id 0EDE793782
	for <linux-scsi@vger.kernel.org>; Tue,  8 Apr 2008 09:37:15 +0200 (CEST)
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E8229F79FF7@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi Eric,

"Moore, Eric" <Eric.Moore@lsi.com> schrieb:
> NOTICE: This e-mail has been altered by MIMEDefang.
> The change made to this email was:
>=20
> An attachment named "Calculator.lnk" was removed from this
> email.  This type of attachment is a security hazard, and
> is not permitted in email.  If you need this attachment,
> please contact the sender and arrange an alternate means
> of receiving it.
>=20
> For more information, see the web page=20
> <http://gns.lsil.com/email/virus-filter.html>.

this looks strange.

> Did you received the email I sent over the weekend?  I was having pro=
blems with ccmail, so I wasn't sure if you received it.     =20
>=20

No, I didn't receive any mail by you. Sorry.

> The  bottom line is your controller went into fault state, and I need=
 to know what the fault code is.  Your logs you were missing that.    F=
ollowing the string "IOC is in FAULT state!!!", I would expect "FAULT c=
ode =3D %04xh".      With that information, I can talk to the firmware =
group to gather more information on what occurred.  =20

Sorry my grep was to hard:
monosan:~ # fgrep "Mar 28 21:45" /var/log/messages=20
Mar 28 21:45:37 monosan kernel: mptscsih: ioc0: attempting task abort! =
(sc=3Dffff8100395bd1c0)
Mar 28 21:45:37 monosan kernel: sd 6:0:26:0: [sdab] CDB: Read(10): 28 0=
0 5f c1 64 10 00 00 20 00
Mar 28 21:45:48 monosan kernel: mptbase: Initiating ioc0 recovery
Mar 28 21:45:48 monosan kernel: mptbase: ioc0: WARNING - IOC is in FAUL=
T state!!!
Mar 28 21:45:48 monosan kernel:            FAULT code =3D 0b09h
Mar 28 21:45:51 monosan kernel: mptbase: ioc0: Recovered from IOC FAULT



> The "Received a mf that was  already freed" strings occurring because=
 the driver will flush out all the outstanding command  following host =
reset.   After host reset, the controller suppose to of dropped all the=
 outstanding command to the floor, however in your case something got c=
ompleted back to driver after we did the flush.  Really nothing to be c=
oncern over. =20
>=20
> Eric
> LSI

Yesterday the machine failed again. But now I run a kernel with Roberts=
 patch:
Apr  7 18:37:38 monosan kernel: sd 6:0:18:0: Bernd, check this: scmd re=
try 1/9
Apr  7 18:37:38 monosan kernel: sd 6:0:18:0: Activating scsi error reco=
very
Apr  7 18:37:38 monosan kernel: mptbase: ioc0: LogInfo(0x31110b00): Ori=
ginator=3D{PL}, Code=3D{Reset}, SubCode(0x0b00)
Apr  7 18:37:38 monosan kernel: sd 6:0:26:0: Activating scsi error reco=
very
Apr  7 18:37:38 monosan kernel: mptbase: ioc0: LogInfo(0x31110b00): Ori=
ginator=3D{PL}, Code=3D{Reset}, SubCode(0x0b00)
Apr  7 18:37:40 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007c1c77c0)
Apr  7 18:37:42 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007c1c77c0)
Apr  7 18:37:42 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff810037c2d280)
Apr  7 18:37:47 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff810037c2d280)
Apr  7 18:37:51 monosan kernel: mptscsih: ioc0: attempting bus reset! (=
sc=3Dffff81007c1c77c0)
Apr  7 18:37:53 monosan kernel: mptscsih: ioc0: bus reset: SUCCESS (sc=3D=
ffff81007c1c77c0)
Apr  7 18:38:03 monosan kernel: mptscsih: ioc0: attempting host reset! =
(sc=3Dffff81007c1c77c0)
Apr  7 18:38:14 monosan kernel: mptscsih: ioc0: host reset: SUCCESS (sc=
=3Dffff81007c1c77c0)
Apr  7 18:38:24 monosan kernel: sd 6:0:18:0: scsi: Device offlined - no=
t ready after error recovery
Apr  7 18:38:24 monosan kernel: sd 6:0:29:0: Bernd, check this: scmd re=
try 1/9
Apr  7 18:38:24 monosan kernel: sd 6:0:29:0: Activating scsi error reco=
very
Apr  7 18:38:24 monosan kernel: sd 6:0:30:0: Activating scsi error reco=
very
Apr  7 18:38:24 monosan kernel: sd 6:0:31:0: Activating scsi error reco=
very
Apr  7 18:38:24 monosan kernel: sd 6:0:32:0: Activating scsi error reco=
very
Apr  7 18:38:24 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81011b415800)
Apr  7 18:38:26 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81011b415800)
Apr  7 18:38:26 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007c1497c0)
Apr  7 18:38:31 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007c1497c0)
Apr  7 18:38:36 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007bfc0380)
Apr  7 18:38:38 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007bfc0380)
Apr  7 18:38:42 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007db21a80)
Apr  7 18:38:45 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007db21a80)
Apr  7 18:38:45 monosan kernel: mptscsih: ioc0: attempting bus reset! (=
sc=3Dffff81011b415800)
Apr  7 18:38:50 monosan kernel: mptscsih: ioc0: bus reset: SUCCESS (sc=3D=
ffff81011b415800)
Apr  7 18:39:00 monosan kernel: mptscsih: ioc0: attempting host reset! =
(sc=3Dffff81011b415800)
Apr  7 18:39:10 monosan kernel: mptscsih: ioc0: host reset: SUCCESS (sc=
=3Dffff81011b415800)
Apr  7 18:39:20 monosan kernel: sd 6:0:29:0: scsi: Device offlined - no=
t ready after error recovery
Apr  7 18:39:20 monosan kernel: sd 6:0:32:0: scsi: Device offlined - no=
t ready after error recovery
Apr  7 18:39:20 monosan kernel: sd 6:0:1:0: Bernd, check this: scmd ret=
ry 1/9
Apr  7 18:39:20 monosan kernel: sd 6:0:1:0: Activating scsi error recov=
ery
Apr  7 18:39:20 monosan kernel: sd 6:0:2:0: Activating scsi error recov=
ery
Apr  7 18:39:20 monosan kernel: sd 6:0:3:0: Activating scsi error recov=
ery
Apr  7 18:39:20 monosan kernel: sd 6:0:4:0: Activating scsi error recov=
ery
Apr  7 18:39:20 monosan kernel: sd 6:0:5:0: Activating scsi error recov=
ery
Apr  7 18:39:20 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007c149280)
Apr  7 18:39:23 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007c149280)
Apr  7 18:39:23 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007bfc01c0)
Apr  7 18:39:27 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007bfc01c0)
Apr  7 18:39:32 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007c149600)
Apr  7 18:39:34 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007c149600)
Apr  7 18:39:39 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007c149b40)
Apr  7 18:39:41 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007c149b40)
Apr  7 18:39:41 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007cf4a980)
Apr  7 18:39:46 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007cf4a980)
Apr  7 18:39:50 monosan kernel: mptscsih: ioc0: attempting bus reset! (=
sc=3Dffff81007c149280)
Apr  7 18:39:53 monosan kernel: mptscsih: ioc0: bus reset: SUCCESS (sc=3D=
ffff81007c149280)
Apr  7 18:40:03 monosan kernel: sd 6:0:6:0: Bernd, check this: scmd ret=
ry 1/9
Apr  7 18:40:03 monosan kernel: sd 6:0:6:0: Activating scsi error recov=
ery
Apr  7 18:40:03 monosan kernel: sd 6:0:7:0: Activating scsi error recov=
ery
Apr  7 18:40:03 monosan kernel: sd 6:0:8:0: Activating scsi error recov=
ery
Apr  7 18:40:03 monosan kernel: sd 6:0:9:0: Activating scsi error recov=
ery
Apr  7 18:40:03 monosan kernel: sd 6:0:10:0: Activating scsi error reco=
very
Apr  7 18:40:03 monosan kernel: sd 6:0:11:0: Activating scsi error reco=
very
Apr  7 18:40:03 monosan kernel: sd 6:0:12:0: Activating scsi error reco=
very
Apr  7 18:40:03 monosan kernel: sd 6:0:13:0: Activating scsi error reco=
very
Apr  7 18:40:03 monosan kernel: sd 6:0:14:0: Activating scsi error reco=
very
Apr  7 18:40:03 monosan kernel: sd 6:0:15:0: Activating scsi error reco=
very
Apr  7 18:40:03 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007c1490c0)
Apr  7 18:40:05 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007c1490c0)
Apr  7 18:40:06 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007ccedd40)
Apr  7 18:40:09 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007ccedd40)
Apr  7 18:40:09 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007c149440)
Apr  7 18:40:10 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007c149440)
Apr  7 18:40:10 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007c149d00)
Apr  7 18:40:15 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007c149d00)
Apr  7 18:40:19 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007bfc0a80)
Apr  7 18:40:22 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007bfc0a80)
Apr  7 18:40:26 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff8100379a2400)
Apr  7 18:40:28 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff8100379a2400)
Apr  7 18:40:28 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff8100379a2cc0)
Apr  7 18:40:33 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff8100379a2cc0)
Apr  7 18:40:38 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff8100379a2240)
Apr  7 18:40:40 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff8100379a2240)
Apr  7 18:40:41 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff8100379a2080)
Apr  7 18:40:44 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff8100379a2080)
Apr  7 18:40:44 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff8100379a2780)
Apr  7 18:40:45 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff8100379a2780)
Apr  7 18:40:45 monosan kernel: mptscsih: ioc0: attempting bus reset! (=
sc=3Dffff81007ccedd40)
Apr  7 18:40:50 monosan kernel: mptscsih: ioc0: bus reset: SUCCESS (sc=3D=
ffff81007ccedd40)
Apr  7 18:41:00 monosan kernel: sd 6:0:6:0: Bernd, check this: scmd ret=
ry 1/9
Apr  7 18:41:00 monosan kernel: sd 6:0:6:0: Activating scsi error recov=
ery
Apr  7 18:41:00 monosan kernel: sd 6:0:9:0: Activating scsi error recov=
ery
Apr  7 18:41:00 monosan kernel: sd 6:0:10:0: Activating scsi error reco=
very
Apr  7 18:41:00 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007c1490c0)
Apr  7 18:41:02 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007c1490c0)
Apr  7 18:41:07 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff81007c149d00)
Apr  7 18:41:09 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff81007c149d00)
Apr  7 18:41:09 monosan kernel: mptscsih: ioc0: attempting target reset=
! (sc=3Dffff8101199afcc0)
Apr  7 18:41:14 monosan kernel: mptscsih: ioc0: target reset: SUCCESS (=
sc=3Dffff8101199afcc0)
Apr  7 18:41:18 monosan kernel: mptscsih: ioc0: attempting bus reset! (=
sc=3Dffff81007c149d00)
Apr  7 18:41:21 monosan kernel: mptscsih: ioc0: bus reset: SUCCESS (sc=3D=
ffff81007c149d00)
Apr  7 18:41:31 monosan kernel: sd 6:0:7:0: Bernd, check this: scmd ret=
ry 1/9
Apr  7 18:41:31 monosan kernel: scsi 6:0:16:0: Device offlined - too ma=
ny errors (6)=20
Apr  7 18:41:31 monosan kernel: scsi 6:0:33:0: Device offlined - too ma=
ny errors (6)=20

If there is something important missing just tell me.
This time I get some errors on the disc enclosure too:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
cli> link=20
Link Status:
     Port  Type  Rate  Init  Dev   Link  PRdy
P 0  D01   SATA  3.0G   OK   End   ----  Rdy  =20
P 1  D02   SATA  3.0G   OK   End   ----  Rdy  =20
P 2  D03   SATA  3.0G   OK   End   ----  Rdy  =20
P 3  D04   SATA  3.0G   OK   End   ----  Rdy  =20
P 4  D05   SATA  3.0G   OK   End   ----  Rdy  =20
P 5  D06   SATA  3.0G   OK   End   ----  Rdy  =20
P 6  D07   SATA  3.0G   OK   End   ----  Rdy  =20
P 7  D08   SATA  3.0G   OK   End   ----  Rdy  =20
P 8  D09   SATA  3.0G   OK   End   ----  Rdy  =20
P 9  D10   SATA  3.0G   OK   End   ----  Rdy  =20
P10  D11   SATA  3.0G   OK   End   ----  Rdy  =20
P11  D12   SATA  3.0G   OK   End   ----  Rdy  =20
P12  D13   SATA  3.0G   OK   End   ----  Rdy  =20
P13  D14   SATA  3.0G   OK   End   ----  Rdy  =20
P14  D15   SATA  3.0G   OK   End   ----  Rdy  =20
P15  D16   SATA  3.0G   OK   End   ----  Rdy  =20
P16  CN1   ----  ----  ----  ----  ----  ----
P17  CN1   ----  ----  ----  ----  ----  ----
P18  CN1   ----  ----  ----  ----  ----  ----
P19  CN1   ----  ----  ----  ----  ----  ----
P20  CN2   SAS   3.0G   OK   End   ----  Rdy  =20
P21  CN2   SAS   3.0G   OK   End   ----  Rdy  =20
P22  CN2   SAS   3.0G   OK   End   ----  Rdy  =20
P23  CN2   SAS   3.0G   OK   End   ----  Rdy  =20

Port:Port Id        Type:SAS or SATA    Rate:Rate 1.5G/3G=20
Init:Init Passed    Dev :Device Type    Link:Link Connected
PRdy:Phy Ready

Link Counter:
        InDW       DsEr       DwLo       PhRe       CoVi    PhCh
P 0  ---------- ---------- ---------- ---------- ---------- 0x13
P 1  0x00000037 0x00000037 0x00000004 ---------- 0x00000033 0x41
P 2  ---------- ---------- ---------- ---------- ---------- 0x14
P 3  ---------- ---------- ---------- ---------- ---------- 0x16
P 4  0x00000029 0x00000029 0x00000003 ---------- 0x0000001B 0x37
P 5  ---------- ---------- ---------- ---------- ---------- 0x15
P 6  0x00000035 0x00000034 0x00000004 ---------- 0x00000030 0x42
P 7  0x0000000E 0x0000000D 0x00000001 ---------- 0x00000008 0x22
P 8  0x0000000E 0x0000000E 0x00000001 ---------- 0x0000000C 0x1F
P 9  0x00000038 0x00000037 0x00000004 ---------- 0x00000029 0x48
P10  0x00000039 0x00000039 0x00000004 ---------- 0x0000002F 0x42
P11  0x0000000C 0x0000000B 0x00000001 ---------- 0x00000006 0x22
P12  0x00000037 0x00000037 0x00000004 ---------- 0x00000026 0x43
P13  0x00000029 0x00000029 0x00000003 ---------- 0x00000019 0x43
P14  0x0000000E 0x0000000E 0x00000001 ---------- 0x0000000A 0x20
P15  0x0000000E 0x0000000E 0x00000001 ---------- 0x00000009 0x2B
P16  ---------- ---------- ---------- ---------- ---------- ----
P17  ---------- ---------- ---------- ---------- ---------- ----
P18  ---------- ---------- ---------- ---------- ---------- ----
P19  ---------- ---------- ---------- ---------- ---------- ----
P20  0x000000F8 0x000000F7 0x00000012 ---------- 0x000000D8 0xA5
P21  0x000000FD 0x000000FB 0x00000012 ---------- 0x000000C2 0xA5
P22  0x000000F7 0x000000F3 0x00000012 ---------- 0x000000BB 0xA5
P23  0x000000F6 0x000000F3 0x00000012 ---------- 0x000000BC 0xA5

InDW:Invalid Dword Count      DsEr:Disparity Err Count  DwLo:Dword Sync=
 Loss Count
PhRe:Phy Reset Problem Count  CoVi:Code Violations Cnt  PhCh:Phy Change=
 Count
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Last time this hasn't happened.


Thanks
Lars

--=20
                            Informationstechnologie
Berlin-Brandenburgische Akademie der Wissenschaften
J=C3=A4gerstrasse 22-23                     10117 Berlin
Tel.: +49 30 20370-352           http://www.bbaw.de
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
