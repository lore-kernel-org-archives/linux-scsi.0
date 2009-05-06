From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13242] New: System Panics with emulex lpfc driver during the
 boot
Date: Wed, 6 May 2009 15:07:29 GMT
Message-ID: <bug-13242-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40285 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbZEFPH3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2009 11:07:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n46F7T6c009070
	for <linux-scsi@vger.kernel.org>; Wed, 6 May 2009 15:07:29 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13242

           Summary: System Panics with emulex lpfc driver during the boot
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.30-rc4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: babu.moger@lsi.com
                CC: babu.moger@lsi.com, james.smart@emulex.com
        Regression: No



James Smart <james.smart@emulex.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |james.smart@emulex.com


I have two luns connected to my system with lpfc adapter. During the boot up I
am seeing following panic.

=========================================================
Starting udev: [  OK  ]
Loading default keymap (us): [  OK  ]
Setting hostname mymachine:  [  OK  ]
BUG: unable to handle kernel NULL pointer dereference at 0000000000000011
IP: [<ffffffffa0137367>] lpfc_mbox_timeout_handler+0x34/0x176 [lpfc]
PGD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/block/sdh/dev
CPU 2
Modules linked in: dm_round_robin scsi_dh_rdac dm_multipath scsi_dh sbs sbshc
battery acpi_memhotplug ac parport_pc lp parport joydev sg dcdbas ide_cd_mod
cdrom bnx2 serio_raw button rtc_cmos rtc_core rtc_lib i5000_edac edac_core
pcspkr dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod lpfc qla2xxx
scsi_transport_fc ata_piix libata shpchp megaraid_sas sd_mod scsi_mod ext3 jbd
uhci_hcd ohci_hcd ehci_hcd
Pid: 687, comm: lpfc_worker_0 Not tainted 2.6.30-rc4 #1 PowerEdge 2900
RIP: 0010:[<ffffffffa0137367>]  [<ffffffffa0137367>]
lpfc_mbox_timeout_handler+0x34/0x176 [lpfc]
RSP: 0018:ffff88007db83d80  EFLAGS: 00010282
RAX: ffff88007d830c38 RBX: 0000000000000000 RCX: ffff88007db83d30
RDX: ffff88007db83da0 RSI: ffff88007d9242c8 RDI: ffff88007f381000
RBP: ffff88007d924000 R08: ffff88007db83d30 R09: ffff88007db83d30
R10: ffff88007d924298 R11: ffffffff8027bd2c R12: ffff88007d924a90
R13: ffff88007d830c38 R14: ffffffff807f1fe0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880001063000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000011 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process lpfc_worker_0 (pid: 687, threadinfo ffff88007db82000, task
ffff88007f13e380)
Stack:
 ffff88007d924000 0000000000000000 000004007d830c38 ffff88007dd10000
 ffff88007d830c38 ffff88007d924a90 ffff88007d830c38 ffffffff807f1fe0
 0000000000000000 ffffffffa01471aa 0000000000000000 0000000000000000
Call Trace:
 [<ffffffffa01471aa>] ? lpfc_do_work+0x80d/0x126a [lpfc]
 [<ffffffff8022d3e6>] ? update_curr+0x6f/0xaa
 [<ffffffff804b6c76>] ? thread_return+0x3e/0x92
 [<ffffffff8024a4b6>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffffa014699d>] ? lpfc_do_work+0x0/0x126a [lpfc]
 [<ffffffffa014699d>] ? lpfc_do_work+0x0/0x126a [lpfc]
 [<ffffffff8024a385>] ? kthread+0x54/0x83
 [<ffffffff8020c93a>] ? child_rip+0xa/0x20
 [<ffffffff8024a331>] ? kthread+0x0/0x83
 [<ffffffff8020c930>] ? child_rip+0x0/0x20
Code: 48 89 fd 53 48 83 ec 18 8b 47 04 48 8b 9f 78 05 00 00 89 44 24 14 44 8b
bf 48 0c 00 00 48 8b 87 d8 10 00 00 48 8b bf 88 0a 00 00 <44> 0f b6 73 11 4c 8b
a7 90 00 00 00 48 83 ef 80 44 8b 68 1c e8
RIP  [<ffffffffa0137367>] lpfc_mbox_timeout_handler+0x34/0x176 [lpfc]
 RSP <ffff88007db83d80>
CR2: 0000000000000011
---[ end trace c69908409be07954 ]---

--- Comment #1 from James Smart <james.smart@emulex.com>  2009-05-06 15:07:29 ---
We resolved a similar panic with our 8.3.1 driver patch set. Please validate
that you are indeed using vanilla 2.6.30-rc4, and that the boot strings show
lpfc version 8.3.1.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
