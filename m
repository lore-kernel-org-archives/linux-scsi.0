From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12195] New: "dd" make kernel panic
Date: Wed, 10 Dec 2008 18:07:18 -0800 (PST)
Message-ID: <bug-12195-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753496AbYLKCHV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2008 21:07:21 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBB27ICY029794
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2008 18:07:19 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12195

           Summary: "dd" make kernel panic
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.28-rc6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: alex.shi@intel.com


Latest working kernel version:2.6.27
Earliest failing kernel version:2.6.28-rc2
Distribution: RHEL 4u2
Hardware Environment: IA64
Software Environment: 
Problem Description: 
When we use dd tool to clear a SCSI disk. it may getinto a kernel panic like
below:
Unable to handle kernel NULL pointer dereference (address 0000000000000044)
ksoftirqd/1[6]: Oops 8813272891392 [1]
Modules linked in:

Pid: 6, CPU 1, comm:          ksoftirqd/1
psr : 00001010081a6010 ifs : 8000000000000289 ip  : [<a000000100391cf0>]    Not
tainted (2.6.28-rc6)
ip is at scsi_softirq_done+0x50/0x2e0
unat: 0000000000000000 pfs : 0000000000000184 rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 0000000000005a81
ldrs: 0000000000000000 ccv : 0000000000000002 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a00000010023f910 b6  : a000000100391ca0 b7  : a00000010000b220
f6  : 1003e0000000000001d4c f7  : 1003e0000000000200000
f8  : 1003e0000000080000000 f9  : 1003e0000054a28eb9332
f10 : 1003eb59a50a4dbb025f6 f11 : 1003e00000000000000c7
r1  : a000000100a1b720 r2  : e000000001105e48 r3  : e00000000cff9518
r8  : e00000000cff9510 r9  : ffffffffffff5e48 r10 : 0000000000000018
r11 : 0000000000000044 r12 : e000000008a97e10 r13 : e000000008a90000
r14 : e000000008a97e30 r15 : e000000008a97e38 r16 : 0000000000000020
r17 : 0000000000000030 r18 : e00000000cff9650 r19 : e00000000cff95e0
r20 : a00000010082eea8 r21 : a000000100391ca0 r22 : e000000001e9ab70
r23 : e000000001e9aac8 r24 : e00000000cff9540 r25 : e000000008a97e30
r26 : e000000008a97e30 r27 : e00000000cff9518 r28 : e000000008a97e38
r29 : 0000000000000000 r30 : 0000000000000000 r31 : 0000000000000000

Call Trace:
 [<a000000100012870>] show_stack+0x50/0xa0
                                sp=e000000008a979e0 bsp=e000000008a90eb0
 [<a000000100013150>] show_regs+0x830/0x860
                                sp=e000000008a97bb0 bsp=e000000008a90e68
 [<a000000100022a60>] die+0x1c0/0x2c0
                                sp=e000000008a97bb0 bsp=e000000008a90e20
 [<a000000100042350>] ia64_do_page_fault+0x830/0x960
                                sp=e000000008a97bb0 bsp=e000000008a90db8
 [<a00000010000ba20>] ia64_native_leave_kernel+0x0/0x270
                                sp=e000000008a97c40 bsp=e000000008a90db8
 [<a000000100391cf0>] scsi_softirq_done+0x50/0x2e0
                                sp=e000000008a97e10 bsp=e000000008a90d70
 [<a00000010023f910>] blk_done_softirq+0x170/0x1c0
                                sp=e000000008a97e20 bsp=e000000008a90d58
 [<a00000010006a8b0>] __do_softirq+0x110/0x2e0
                                sp=e000000008a97e30 bsp=e000000008a90cc8
 [<a00000010006aaf0>] do_softirq+0x70/0xc0
                                sp=e000000008a97e30 bsp=e000000008a90c68
 [<a00000010006c2d0>] ksoftirqd+0xf0/0x240
                                sp=e000000008a97e30 bsp=e000000008a90c40
 [<a00000010008df80>] kthread+0xa0/0x120
                                sp=e000000008a97e30 bsp=e000000008a90c10
 [<a000000100014430>] kernel_thread_helper+0x30/0x60
                                sp=e000000008a97e30 bsp=e000000008a90be0
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e000000008a97e30 bsp=e000000008a90be0
Kernel panic - not syncing: Aiee, killing interrupt handler!

Steps to reproduce:
while true; do echo "3">/proc/sys/vm/drop_caches; dd if=/dev/sdb2 of=/dev/zero
bs=1024k count=8900; done;


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
