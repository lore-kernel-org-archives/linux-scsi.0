From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11302] New: I get a kernel OOPS! If I try to attach an usb card reader, SD, MMC, ecc.. to my Slamd64
Date: Sun, 10 Aug 2008 13:45:49 -0700 (PDT)
Message-ID: <bug-11302-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754508AbYHJUpv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Aug 2008 16:45:51 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7AKjnn5027444
	for <linux-scsi@vger.kernel.org>; Sun, 10 Aug 2008 13:45:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11302

           Summary: I get a kernel OOPS! If I try to attach an usb card
                    reader, SD, MMC, ecc.. to my Slamd64
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.26.2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: pinc_o@yahoo.it


Latest working kernel version: 2.6.25.x
Earliest failing kernel version:
Distribution: SLAMD64 12.1
Hardware Environment: Asus A7 deluxe
Software Environment: KDE/command line
Problem Description:

If attach my usb card reader, without load mmc_block an mmc_core modules, then
the follow OOPS appear(If first load them, simply doesn't mount the SD. Please
note: I always use "automatic loading kernel modules" compiled in "my" kernelS.
But from many time, the recent kernelS not load the mmc_block module):

==========================================================================
usb 1-6: new high speed USB device using ehci_hcd and address 6
usb 1-6: configuration #1 chosen from 1 choice
scsi5 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
scsi 5:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
usb 1-6: reset high speed USB device using ehci_hcd and address 6
usb 1-6: reset high speed USB device using ehci_hcd and address 6
usb 1-6: reset high speed USB device using ehci_hcd and address 6
usb 1-6: can't restore configuration #1 (error=-71)
sd 5:0:0:0: Device offlined - not ready after error recovery
sd 5:0:0:0: rejecting I/O to offline device
sd 5:0:0:0: rejecting I/O to offline device
sd 5:0:0:0: rejecting I/O to offline device
sd 5:0:0:0: [sdd] READ CAPACITY failed
sd 5:0:0:0: [sdd] Result: hostbyte=0x01 driverbyte=0x00
sd 5:0:0:0: [sdd] Sense not available.
sd 5:0:0:0: rejecting I/O to offline device
sd 5:0:0:0: [sdd] Write Protect is off
sd 5:0:0:0: [sdd] Mode Sense: 00 00 00 00
sd 5:0:0:0: [sdd] Assuming drive cache: write through
sd 5:0:0:0: [sdd] Attached SCSI removable disk
sd 5:0:0:0: Attached scsi generic sg3 type 0
usb 1-6: USB disconnect, address 6
BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
IP: [<ffffffff8039bea1>] slave_alloc+0x33/0x5b
PGD be142067 PUD aab0e067 PMD 0
Oops: 0000 [1] PREEMPT SMP
CPU 1
Modules linked in: nvidia(P) [last unloaded: nvidia]
Pid: 6201, comm: usb-stor-scan Tainted: P          2.6.26.2 #2
RIP: 0010:[<ffffffff8039bea1>]  [<ffffffff8039bea1>] slave_alloc+0x33/0x5b
RSP: 0018:ffff8100aa969c20  EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff8100a29745c8 RCX: 0000000000000000
RDX: ffff810026abd000 RSI: 0000000000000202 RDI: ffff8100bed14100
RBP: ffff8100a2977800 R08: 00000000ffffffff R09: ffff8100a2977c30
R10: 0000000000000000 R11: 0000000000000000 R12: ffff810099d46428
R13: ffff8100a2974000 R14: 0000000000000000 R15: ffff810099d46400
FS:  00007f5f94bd26f0(0000) GS:ffff8100bf806480(0000) knlGS:00000000f714e6c0
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000004 CR3: 00000000aa9ec000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process usb-stor-scan (pid: 6201, threadinfo ffff8100aa968000, task
ffff8100864e85c0)
Stack:  ffff810099d46428 ffff8100a2977800 ffff810099d46400 ffffffff80366082
 ffff8100a2974000 0000000000000000 0000000000000000 0000000000000000
 0000000000000000 ffffffff80366348 ffff81000000157c ffff810000000003
Call Trace:
 [<ffffffff80366082>] ? scsi_alloc_sdev+0x1b6/0x1fd
 [<ffffffff80366348>] ? scsi_probe_and_add_lun+0xef/0x926
 [<ffffffff80343032>] ? attribute_container_add_device+0x27/0x124
 [<ffffffff802ed533>] ? kobject_get+0x12/0x17
 [<ffffffff8033ea29>] ? get_device+0x17/0x20
 [<ffffffff80365e66>] ? scsi_alloc_target+0x225/0x28b
 [<ffffffff80366e1c>] ? __scsi_scan_target+0xb1/0x4f6
 [<ffffffff80234b1b>] ? process_timeout+0x0/0x5
 [<ffffffff8039d3e9>] ? usb_stor_scan_thread+0x0/0x12e
 [<ffffffff8046bc98>] ? wait_for_common+0x126/0x138
 [<ffffffff80224fbb>] ? default_wake_function+0x0/0xe
 [<ffffffff803672af>] ? scsi_scan_channel+0x4e/0x81
 [<ffffffff80367373>] ? scsi_scan_host_selected+0x91/0xd3
 [<ffffffff8039d4fb>] ? usb_stor_scan_thread+0x112/0x12e
 [<ffffffff8023e3bc>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8039d3e9>] ? usb_stor_scan_thread+0x0/0x12e
 [<ffffffff8023e29f>] ? kthread+0x47/0x74
 [<ffffffff80227e8b>] ? schedule_tail+0x28/0x5d
 [<ffffffff8020c008>] ? child_rip+0xa/0x12
 [<ffffffff8023e258>] ? kthread+0x0/0x74
 [<ffffffff8020bffe>] ? child_rip+0x0/0x12


Code: 08 48 8b 1f c6 87 93 00 00 00 24 48 8b 7f 08 48 81 c3 c8 05 00 00 8b 43
3c 48 8b 53 18 c1 e8 0f 83 e0 0f 48 8b 84 c2 d0 02 00 00 <0f> b7 70 04 ff ce e8
26 86 f4 ff 80 7b 64 04 75 11 48 8b 85 c0
RIP  [<ffffffff8039bea1>] slave_alloc+0x33/0x5b
 RSP <ffff8100aa969c20>
CR2: 0000000000000004
---[ end trace d443c8e181da42c1 ]---

========================================================================

Dual Core AMD Opteron(tm) Processor 185
3GB of memory
SLAMD64 12.1

Best Regards


Steps to reproduce:


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
