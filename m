From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: How to reset a single drive?
Date: Tue, 13 Mar 2012 19:33:07 +0100
Message-ID: <20120313193307.5da0895d@harpe.intellique.com>
References: <4F5F7973.7000007@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:53723 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab2CMSeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 14:34:11 -0400
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id 4A10A7AF967
	for <linux-scsi@vger.kernel.org>; Tue, 13 Mar 2012 19:34:07 +0100 (CET)
In-Reply-To: <4F5F7973.7000007@shiftmail.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joystick <joystick@shiftmail.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le Tue, 13 Mar 2012 17:44:35 +0100
joystick <joystick@shiftmail.org> =E9crivait:

> It could also have been a controller glitch maybe?
>=20
> For a future time, I know there are SCSI reset messages which can be=20
> sent to various things in the path to the drive. Could someone teach
> me how to send a reset message to the controller card, to a slot
> and/or to a drive, from bash?
> Or any other suggestion for reviving a slot / drive which do not
> imply powering off the machine?
>=20
> Our controller is LSI 6201-16i. No SAS expanders. I am able to
> determine the phy port number of the unresponsive drive.

You're out of luck here. Usually removing the driver (rmmod mpt_sas) is
the best you can do, it almost always force a complete scsi bus reset
and rescan, but that obviously won't do anything more than a reboot. Of
course you could try to force the drive offline, then online with
MegaCli:

MegaCli -PDOffline -PhysDrv [E:S] -aN
MegaCli -PDOnline -PhysDrv [E:S] -aN

Or you could try a controller scan:

MegaCli -CfgForeign -Scan -aALL=20

You're obviously either got an LSI firmware bug or a drive
firmware bug. The fact that several reboots and therefore controller
firmware restarts occured makes me thing that's the drive.  WD SATA
drives are notoriously complete sh*te in professional environment and
love living their life by themselves, out of RAID arrays.

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
