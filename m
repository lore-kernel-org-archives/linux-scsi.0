From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13936] Megaraid_mbox kernel panic at initialization
Date: Sat, 8 Aug 2009 22:56:55 GMT
Message-ID: <200908082256.n78MusKY017652@demeter.kernel.org>
References: <bug-13936-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42273 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbZHHW4y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2009 18:56:54 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n78Mut9J017653
	for <linux-scsi@vger.kernel.org>; Sat, 8 Aug 2009 22:56:55 GMT
In-Reply-To: <bug-13936-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13936


Joe Feise <jfeise@feise.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jfeise@feise.com




--- Comment #1 from Joe Feise <jfeise@feise.com>  2009-08-08 22:56:54 ---
Slackware 12.2, using kernel 2.6.29.6
causes a kernel panic when udev initializes the SCSI devices.
Call Trace:
[<c012e307>] tasklet_action+0x85/0x10d
[<c012dde9>] __do_softirq+0x8f/0x12a
[<c01139ba>] ack_apic_level+0x5b/0x1ae
[<c012dedb>] do_softirq+0x57/0x59
[<c012e0b7>] irq_exit+0x43/0x45
[<c0104b17>] do_IRQ+0x61/0xba
[<c0167d56>] shmem_get_iode+0xa1/0x199
[<c05a75f3>] _spin_lock+0x14/0x17
[<c01037a7>] common_interrupt+0x27/0x2c
[<c01900d8>] fifo_open+0xda/0x212
[<c017efaf>] kmem_cache_free+0x3a/0x54
[<c018c3b2>] sys_mkdirat+0xa8/0xd0
[<c018c3f9>] sys_kndir+0x1f/0x23
[<c0103222>] syscall_call+0x7/0xb
Code: 0f b6 82 4c 46 00 00 d3 f8 a8 01 0f 84 cd fe ff ff 8b 44 24 34 8b 70 34
8b
 06 83 e0 fc 0f 84 68 01 00 00 e8 37 eb cf ff 8b 56 04 <f6> 04 10 1f 0f 85 a9
fe
 ff ff 0f b7 4b 24 0f b7 43 26 c1 e1 04
EIP: [<c046d1b9>] megaraid_mbox_dpc+0x24d/0x561 SS:ESP 0068:f59e1e00
---[ end trace bd6fcd56a304a4d0 ]---
Kernel panic - not syncing: Fatal exception in interrupt

The same kernel worked with Slackware 12.0.
The environment:
- Kernel 2.6.29.6, megaraid_mm and megaraid_mbox in the kernel (not modules,
since I boot from the raid disk.)
- Distribution: Slackware 12.2
- LSI Megaraid 320-2 2-channel SCSI RAID PCI card, firmware 1L49
- Attached to channel 1: 1 RAID 1, 1 RAID 0 disks
- Attached to channel 2: 1 DVD drive using a SCSI-to-IDE adapter
- Megaraid boot option: unconf_disks=1
- udevd version 135

It works when I don't start udev.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
