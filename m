From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 53281] New: megaraid_mbox kernel panic during boot
Date: Thu, 31 Jan 2013 13:00:32 +0000 (UTC)
Message-ID: <bug-53281-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33417 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab3AaNAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2013 08:00:36 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A215D20327
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jan 2013 13:00:34 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 6C4B92028D
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jan 2013 13:00:33 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D53281

           Summary: megaraid_mbox kernel panic during boot
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.26, 2.6.32, 3.2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: romomoruno@gmail.com
        Regression: Yes


Distribution: Debian Squeeze
Kernel: 2.6.32

Tested kernel not failing: 2.6.18 (etch)
Tested kernel failing: 2.6.26 (lenny), 2.6.32 (squeeze), 3.2 (squeeze-b=
ackport)

It appears be a problem with megaraid_mbox kernel module during boot on=
 linux
systems with a LSI Megaraid SCSI adaptor, with three SCSI hard disks in=
 raid 5
and a SCSI DAT Tape (non-RAID device) connected on same adaptor.

I have 17 servers affected with different hardware configurations, and =
common
point combination is a DAT device tape connected to LSI Megaraid adapto=
r with
three hard disks array in raid 5.

Disconecting SCSI DAT Tape device from LSI adaptor or connecting it on =
a second
adaptor solved the problem, but unfortunatelly no option for me.

Hardware configurations:

LSI Megaraid Adaptor    3 SCSI Hard Disks in raid 5    SCSI DAT Tape

530 SCSI 320-0X    69618MB FUJITSU MAT3073NC 0108            SONY SDX-4=
50V
ver0100
530 SCSI 320-0X    69618MB FUJITSU MAP3735NC 0108            SONY SDX-4=
50V
ver0100
Intel SRCU41L    69618MB MAXTOR ATLAS10K4_73WLS DFL0    SEAGATE DAT DAT=
72-000
A1A0
520 SCSI 320-1    69808MB MAXTOR ATLAS10K5_73WLS JS03    HP C7438A V310
530 SCSI 320-0X    69618MB FUJITSU MAT3073NC 0108            SONY SDX-4=
50V
ver0100
530 SCSI 320-0X    69618MB FUJITSU MAW3073NC 0104            SONY SDX-4=
50V
ver0100
530 SCSI 320-0X    69618MB FUJITSU MAT3073NC 0108            SEAGATE DA=
T
DAT72-000 A060
530 SCSI 320-0X    69618MB FUJITSU MAT3073NC 0108            SONY SDX-4=
50V
ver0100
Intel SRCU42E    140190MB FUJITSU MAU3147NP 0102            SEAGATE DAT
DAT72-000 A1A0
520 SCSI 320-1    70006MB FUJITSU MAP3735NP HPF6            HP C7438A Z=
P5B
530 SCSI 320-0X    69618MB FUJITSU MAT3073NC 0108            SONY SDX-4=
50V
ver0100
520 SCSI 320-1    69808MB MAXTOR ATLAS10K5_73WLS JS03    HP C7438A ZP5B
Intel SRCU42E    140268MB FUJITSU MAU3147NP 0102            SEAGATE DAT
DAT72-000 A1A0
520 SCSI 320-1    70006MB HP 73.4G ST373207LW HPC1    HP C7438A V310
520 SCSI 320-1    139712MB MAXTOR ATLAS10K5_147WLS JS03    HP C7438A ZP=
5B
520 SCSI 320-1    69808MB MAXTOR ATLAS10K5_73WLS JS03    HP C7438A ZP5B
518 DELL PERC 4/DC    70140MB MAXTOR ATLAS10K5_73WLS JNZH    SEAGATE DA=
T
DAT72-000 A1A0


modinfo megaraid_mbox (kernel 2.6.32)
filename:
/lib/modules/2.6.32-5-686/kernel/drivers/scsi/megaraid/megaraid_mbox.ko
version: 2.20.5.1
license: GPL
description: LSI Logic MegaRAID Mailbox Driver
author: megaraidlinux@=E2=80=A6
srcversion: 4846B66054D71B69BF4A7D3
alias: pci:v00001000d00000409sv*sd*bc*sc*i*
alias: pci:v00001000d00001960sv*sd*bc*sc*i*
alias: pci:v0000101Ed00001960sv*sd*bc*sc*i*
alias: pci:v00001000d00000408sv*sd*bc*sc*i*
alias: pci:v00001028d00000013sv00001028sd00000170bc*sc*i*
alias: pci:v00001028d00000013sv00001028sd0000016Fbc*sc*i*
alias: pci:v00001028d00000013sv00001028sd0000016Ebc*sc*i*
alias: pci:v00001028d00000013sv00001028sd0000016Dbc*sc*i*
alias: pci:v00001028d00000013sv00001028sd0000016Cbc*sc*i*
alias: pci:v00001028d0000000Fsv00001028sd0000014Abc*sc*i*
alias: pci:v00001000d00000407sv*sd*bc*sc*i*
alias: pci:v00001000d00001960sv00001028sd00000518bc*sc*i*
alias: pci:v00001000d00001960sv00001028sd00000520bc*sc*i*
alias: pci:v00001028d0000000Esv00001028sd00000123bc*sc*i*
depends: scsi_mod,megaraid_mm
vermagic: 2.6.32-5-686 SMP mod_unload modversions 686=20
parm: unconf_disks:Set to expose unconfigured disks to kernel (default=3D=
0) (int)
parm: busy_wait:Max wait for mailbox in microseconds if busy (default=3D=
10) (int)
parm: max_sectors:Maximum number of sectors per IO command (default=3D1=
28) (int)
parm: cmd_per_lun:Maximum number of commands per logical unit (default=3D=
64)
(int)
parm: fast_load:Faster loading of the driver, skips physical devices!
(default=3D0) (int)
parm: debug_level:Debug level for driver (default=3D0) (int)


modinfo megaraid_mbox (kernel 2.6.18)
filename:
/lib/modules/2.6.18-6-686/kernel/drivers/scsi/megaraid/megaraid_mbox.ko
author: sju@=E2=80=A6
description: LSI Logic MegaRAID Mailbox Driver
license: GPL
version: 2.20.4.9
vermagic: 2.6.18-6-686 SMP mod_unload 686 REGPARM gcc-4.1
depends: scsi_mod,megaraid_mm
alias: pci:v00001028d0000000Esv00001028sd00000123bc*sc*i*
alias: pci:v00001000d00001960sv00001028sd00000520bc*sc*i*
alias: pci:v00001000d00001960sv00001028sd00000518bc*sc*i*
alias: pci:v00001000d00000407sv*sd*bc*sc*i*
alias: pci:v00001028d0000000Fsv00001028sd0000014Abc*sc*i*
alias: pci:v00001028d00000013sv00001028sd0000016Cbc*sc*i*
alias: pci:v00001028d00000013sv00001028sd0000016Dbc*sc*i*
alias: pci:v00001028d00000013sv00001028sd0000016Ebc*sc*i*
alias: pci:v00001028d00000013sv00001028sd0000016Fbc*sc*i*
alias: pci:v00001028d00000013sv00001028sd00000170bc*sc*i*
alias: pci:v00001000d00000408sv*sd*bc*sc*i*
alias: pci:v0000101Ed00001960sv*sd*bc*sc*i*
alias: pci:v00001000d00001960sv*sd*bc*sc*i*
alias: pci:v00001000d00000409sv*sd*bc*sc*i*
srcversion: 0B71F30F1E95E778A74A4D1
parm: debug_level:Debug level for driver (default=3D0) (int)
parm: fast_load:Faster loading of the driver, skips physical devices!
(default=3D0) (int)
parm: cmd_per_lun:Maximum number of commands per logical unit (default=3D=
64)
(int)
parm: max_sectors:Maximum number of sectors per IO command (default=3D1=
28) (int)
parm: busy_wait:Max wait for mailbox in microseconds if busy (default=3D=
10) (int)
parm: unconf_disks:Set to expose unconfigured disks to kernel (default=3D=
0) (int)


Kernel panic trace is attached in a screenshot: megaraid_mbox_panic.jpg

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
