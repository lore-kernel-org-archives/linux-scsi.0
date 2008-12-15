From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12195] "dd" make kernel panic
Date: Mon, 15 Dec 2008 01:52:35 -0800 (PST)
Message-ID: <20081215095235.6A4EE108043@picon.linux-foundation.org>
References: <bug-12195-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753784AbYLOJwh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2008 04:52:37 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBF9qZa3015216
	for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2008 01:52:36 -0800
In-Reply-To: <bug-12195-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12195





------- Comment #11 from ming.m.lin@intel.com  2008-12-15 01:52 -------
kernel panic again with patch at #9 applied to 2.6.28-rc8
----------------------------------------------------------

mptbase: ioc0: WARNING - IOC is in FAULT state (000eh)!!!                       
mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
mptbase: ioc0: WARNING - IOC is in FAULT state!!!
mptbase: ioc0: WARNING -            FAULT code = 000eh
end_request: I/O error, dev sdb, sector 22968800
Buffer I/O error on device sdb, logical block 5742200
Buffer I/O error on device sdb, logical block 5742201
Buffer I/O error on device sdb, logical block 5742202
Buffer I/O error on device sdb, logical block 5742203
Buffer I/O error on device sdb, logical block 5742204
Buffer I/O error on device sdb, logical block 5742205
Buffer I/O error on device sdb, logical block 5742206
Buffer I/O error on device sdb, logical block 5742207
Buffer I/O error on device sdb, logical block 5742208
Buffer I/O error on device sdb, logical block 5742209
sd 0:0:1:0: rejecting I/O to offline device
end_request: I/O error, dev sdb, sector 22969056
mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000000!
Unable to handle kernel NULL pointer dereference (address 0000000000000044)
ksoftirqd/2[10]: Oops 8813272891392 [1]
Modules linked in:

Pid: 10, CPU 2, comm:          ksoftirqd/2
psr : 00001010081a6010 ifs : 8000000000000289 ip  : [<a000000100397190>]    Not
tainted (2.6.28-rc8-mlin)
ip is at scsi_softirq_done+0x50/0x2e0
unat: 0000000000000000 pfs : 0000000000000184 rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 0000000000005a81
ldrs: 0000000000000000 ccv : 0000000000000002 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a000000100244e90 b6  : a000000100397140 b7  : a00000010000b220
f6  : 1003e0000000000000000 f7  : 1003e0000000000200000
f8  : 1003e0000000080000000 f9  : 1003e000001de86495475
f10 : 1003e9277c68cf83c1120 f11 : 1003e0000000000000046
r1  : a000000100a2bf40 r2  : e000000001115ec8 r3  : e0000000402d6658
r8  : e0000000402d6650 r9  : ffffffffffff5ec8 r10 : 0000000000000018
r11 : 0000000000000044 r12 : e000000008b07e10 r13 : e000000008b00000
r14 : e000000008b07e30 r15 : e000000008b07e38 r16 : 0000000000000020
r17 : 0000000000000030 r18 : e0000000402d6790 r19 : e0000000402d6720
r20 : a00000010083fb20 r21 : a000000100397140 r22 : e00000004062b388
r23 : e00000004062b2e0 r24 : e0000000402d6680 r25 : e000000008b07e30
r26 : e000000040119700 r27 : e0000000402d6658 r28 : e000000040119708
r29 : 0000000000000000 r30 : 0000000000000000 r31 : 0000000000000000

Call Trace:
 [<a000000100012870>] show_stack+0x50/0xa0
                                sp=e000000008b079e0 bsp=e000000008b00ec8
 [<a000000100013150>] show_regs+0x830/0x860
                                sp=e000000008b07bb0 bsp=e000000008b00e80
 [<a000000100022a60>] die+0x1c0/0x2c0
                                sp=e000000008b07bb0 bsp=e000000008b00e38
 [<a000000100042350>] ia64_do_page_fault+0x830/0x960
                                sp=e000000008b07bb0 bsp=e000000008b00dd0
 [<a00000010000ba20>] ia64_native_leave_kernel+0x0/0x270
                                sp=e000000008b07c40 bsp=e000000008b00dd0
 [<a000000100397190>] scsi_softirq_done+0x50/0x2e0
                                sp=e000000008b07e10 bsp=e000000008b00d88
 [<a000000100244e90>] blk_done_softirq+0x170/0x1c0
                                sp=e000000008b07e20 bsp=e000000008b00d70
 [<a00000010006f050>] __do_softirq+0x110/0x2e0
                                sp=e000000008b07e30 bsp=e000000008b00ce0
 [<a00000010006f290>] do_softirq+0x70/0xc0
                                sp=e000000008b07e30 bsp=e000000008b00c80
 [<a000000100070a70>] ksoftirqd+0xf0/0x240
                                sp=e000000008b07e30 bsp=e000000008b00c58
 [<a000000100092720>] kthread+0xa0/0x120
                                sp=e000000008b07e30 bsp=e000000008b00c28
 [<a000000100014430>] kernel_thread_helper+0x30/0x60
                                sp=e000000008b07e30 bsp=e000000008b00c00
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e000000008b07e30 bsp=e000000008b00c00
Kernel panic - not syncing: Aiee, killing interrupt handler!


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
