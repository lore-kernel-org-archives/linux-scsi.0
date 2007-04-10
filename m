From: Ulrich Teichert <krypton@ulrich-teichert.org>
Subject: Disk spin up with esp on Sparc
Date: Tue, 10 Apr 2007 16:37:57 +0200 (MEST)
Message-ID: <200704101437.l3AEbv0o015320@arbas.nms.ulrich-teichert.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from i577A18A0.versanet.de ([87.122.24.160]:13475 "EHLO
	arbas.nms.ulrich-teichert.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753887AbXDJOyc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Apr 2007 10:54:32 -0400
Received: from arbas.nms.ulrich-teichert.org (localhost [127.0.0.1])
	by arbas.nms.ulrich-teichert.org (8.13.6/8.13.6) with ESMTP id l3AEbw5b015321
	for <linux-scsi@vger.kernel.org>; Tue, 10 Apr 2007 16:37:58 +0200
Received: (from ut@localhost)
	by arbas.nms.ulrich-teichert.org (8.13.6/8.13.6/Submit) id l3AEbv0o015320
	for linux-scsi@vger.kernel.org; Tue, 10 Apr 2007 16:37:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>

Hi,

I've noticed something strange as I've build and tested vanilla 2.6.20.=
3
for my Sparc Ultra-2: one of my hard disks wasn't spinning up. It was
jumpered in a way where it would require a host command for spinning
up. This ran OK with 2.6.14, which I had on that box before, though.
[SMP kernel, 2 CPUs, 2 disks and one CD-ROM attached to the on-board
esp SCSI, framebuffer and HME 4port ethernet SBUS card]

I simply changed the jumpering and all was OK, disk spun up, filesystem
got mounted, everything OK, but I wasn't really satisfied. I tried a ve=
ry
similar kernel config on my E250 (with make oldconfig), which I knew ha=
d
some drives jumpered that way, too. Similar, because the E250 uses two
SymbiosLogic 875 SCSI on-board hosts. The drives spun up without any pr=
oblem.

Now to the questions: does that mean that the low-level driver fires th=
e
motor start command? Or is that left to the generic sd driver and the e=
sp
driver simply fails to deliver the status of the drive to the upper lay=
er
or something like that? As the drives of the E250 spun up OK, I don't t=
hink
that this is an intendend change of behaviour, but I really would like
to debug this further.

TIA for all hints and pointers,
Uli
--=20
Dipl. Inf. Ulrich Teichert|e-mail: Ulrich.Teichert@gmx.de
Stormweg 24               |listening to: Single (Hushpuppies), Pay The =
Cobra
24539 Neumuenster, Germany|(The Bellrays), Ne Me Touch Pas (Op=E9ration=
 S)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
