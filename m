From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12195] "dd" make kernel panic
Date: Mon, 15 Dec 2008 02:39:58 -0800 (PST)
Message-ID: <20081215103958.4801D108042@picon.linux-foundation.org>
References: <bug-12195-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752791AbYLOKkB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2008 05:40:01 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBFAdwDL017231
	for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2008 02:39:59 -0800
In-Reply-To: <bug-12195-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12195





------- Comment #12 from ming.m.lin@intel.com  2008-12-15 02:39 -------
(In reply to comment #7)
> If you have time for another re-create it would be good to set some scsi
> logging.
> sysctl -w dev.scsi.logging_level=4100 # mlcomplete 1 and error 4
> echo "1" > /proc/sys/kernel/sysrq # If needed
> echo 9 > /proc/sysrq-trigger # Raise console log level
> 

mptscsih: ioc0: attempting task abort! (sc=e000000037a36980)
sd 0:0:1:0: [sdb] CDB: cdb[0]=0x28: 28 00 01 3b 4e a0 00 01 00 00
mptbase: ioc0: WARNING - IOC is in FAULT state (000eh)!!!
mptbase: ioc0: WARNING - Issuing HardReset from mpt_fault_reset_work!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - IOC is in FAULT state!!!
mptbase: ioc0: WARNING -            FAULT code = 000eh
mptscsih: ioc0: Issue of TaskMgmt failed!
mptscsih: ioc0: task abort: FAILED (sc=e000000037a36980)
mptscsih: ioc0: attempting task abort! (sc=e000000037a35f80)
sd 0:0:1:0: [sdb] CDB: cdb[0]=0x28: 28 00 01 3b 4f a0 00 01 00 00
mptscsih: ioc0: task abort: FAILED (sc=e000000037a35f80)
mptscsih: ioc0: attempting target reset! (sc=e000000037a36980)
sd 0:0:1:0: [sdb] CDB: cdb[0]=0x28: 28 00 01 3b 4e a0 00 01 00 00
mptscsih: ioc0: target reset: FAILED (sc=e000000037a36980)
mptscsih: ioc0: attempting bus reset! (sc=e000000037a36980)
sd 0:0:1:0: [sdb] CDB: cdb[0]=0x28: 28 00 01 3b 4e a0 00 01 00 00
mptscsih: ioc0: bus reset: FAILED (sc=e000000037a36980)
mptscsih: ioc0: attempting host reset! (sc=e000000037a36980)
mptscsih: ioc0: host reset: SUCCESS (sc=e000000037a36980)
sd 0:0:1:0: Device offlined - not ready after error recovery
sd 0:0:1:0: Device offlined - not ready after error recovery
sd 0:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x06
end_request: I/O error, dev sdb, sector 20663968
Buffer I/O error on device sdb, logical block 5165992
Buffer I/O error on device sdb, logical block 5165993
Buffer I/O error on device sdb, logical block 5165994
Buffer I/O error on device sdb, logical block 5165995
Buffer I/O error on device sdb, logical block 5165996
Buffer I/O error on device sdb, logical block 5165997
Buffer I/O error on device sdb, logical block 5165998
Buffer I/O error on device sdb, logical block 5165999
Buffer I/O error on device sdb, logical block 5166000
Buffer I/O error on device sdb, logical block 5166001
sd 0:0:1:0: rejecting I/O to offline device
sd 0:0:1:0: [sdb] Result: hostbyte=0x00 driverbyte=0x06
end_request: I/O error, dev sdb, sector 20664224
mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999), IntStatus=80000000!
sd 0:0:1:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 1,
sc=e000000037a36980, mf = e0000000406847e0, idx=55
sd 0:0:1:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 1,
sc=e000000037a35f80, mf = e0000000406883e0, idx=f5
Unable to handle kernel NULL pointer dereference (address 0000000000000044)
mpt_poll_0[378]: Oops 8813272891392 [1]
Modules linked in:

Pid: 378, CPU 1, comm:           mpt_poll_0
psr : 0000101008026018 ifs : 8000000000000289 ip  : [<a0000001003988b0>]    Not
tainted (2.6.28-rc8-mlin)
ip is at scsi_softirq_done+0x50/0x2e0
unat: 0000000000000000 pfs : 0000000000000184 rsc : 0000000000000003
rnat: 5555555555555555 bsps: 5555555555555555 pr  : 000002a1491599a5
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a000000100245310 b6  : a000000100398860 b7  : a000000100011ec0
f6  : 1003e0000000000000000 f7  : 1003e0000000000200802
f8  : 1003e0000000080000000 f9  : 1003e00000000000001d3
f10 : 1003e392baaf0b5995995 f11 : 1003e0000000000000030
r1  : a000000100a2c6c0 r2  : e000000001105ec8 r3  : e000000035e2d688
r8  : e000000035e2d680 r9  : ffffffffffff5ec8 r10 : 0000000000000018
r11 : 0000000000000044 r12 : e0000000405c7830 r13 : e0000000405c0000
r14 : e0000000405c7850 r15 : e0000000405c7858 r16 : 0000000000000020
r17 : 0000000000000030 r18 : e000000035e2d7c0 r19 : e000000035e2d750
r20 : 0000000000000001 r21 : a000000100398860 r22 : e000000040599ac0
r23 : e000000040599a18 r24 : e000000035e2d6b0 r25 : e0000000405c7850
r26 : e0000000405c7850 r27 : e000000035e2d688 r28 : e0000000405c7858
r29 : a000000100011ec0 r30 : 0000000000000000 r31 : e000000008a78000

Call Trace:
 [<a000000100012870>] show_stack+0x50/0xa0
                                sp=e0000000405c7400 bsp=e0000000405c1368
 [<a000000100013150>] show_regs+0x830/0x860
                                sp=e0000000405c75d0 bsp=e0000000405c1320
 [<a000000100022a60>] die+0x1c0/0x2c0
                                sp=e0000000405c75d0 bsp=e0000000405c12d8
 [<a000000100042350>] ia64_do_page_fault+0x830/0x960
                                sp=e0000000405c75d0 bsp=e0000000405c1278
 [<a00000010000ba20>] ia64_native_leave_kernel+0x0/0x270
                                sp=e0000000405c7660 bsp=e0000000405c1278
 [<a0000001003988b0>] scsi_softirq_done+0x50/0x2e0
                                sp=e0000000405c7830 bsp=e0000000405c1230
 [<a000000100245310>] blk_done_softirq+0x170/0x1c0
                                sp=e0000000405c7840 bsp=e0000000405c1218
 [<a00000010006f3d0>] __do_softirq+0x110/0x2e0
                                sp=e0000000405c7850 bsp=e0000000405c1180
 [<a00000010006f610>] do_softirq+0x70/0xc0
                                sp=e0000000405c7850 bsp=e0000000405c1120
 [<a00000010006fa50>] irq_exit+0x70/0xa0
                                sp=e0000000405c7850 bsp=e0000000405c1108
 [<a000000100011c70>] ia64_handle_irq+0x350/0x380
                                sp=e0000000405c7850 bsp=e0000000405c10d0
 [<a00000010000ba20>] ia64_native_leave_kernel+0x0/0x270
                                sp=e0000000405c7850 bsp=e0000000405c10d0
 [<a0000001000662e0>] vprintk+0x660/0x6a0
                                sp=e0000000405c7a20 bsp=e0000000405c1000
 [<a0000001000663a0>] printk+0x80/0xc0
                                sp=e0000000405c7a90 bsp=e0000000405c0f98
 [<a0000001003d4c50>] mptscsih_ioc_reset+0x250/0x420
                                sp=e0000000405c7ad0 bsp=e0000000405c0f30
 [<a0000001003d9c50>] mptspi_ioc_reset+0x30/0xa0
                                sp=e0000000405c7ae0 bsp=e0000000405c0f08
 [<a0000001003c1d30>] mpt_signal_reset+0x150/0x180
                                sp=e0000000405c7ae0 bsp=e0000000405c0ed8
 [<a0000001003c53c0>] KickStart+0x680/0x1000
                                sp=e0000000405c7ae0 bsp=e0000000405c0e70
 [<a0000001003c5f50>] MakeIocReady+0x210/0x500
                                sp=e0000000405c7ae0 bsp=e0000000405c0e18
 [<a0000001003c86f0>] mpt_do_ioc_recovery+0x150/0x2840
                                sp=e0000000405c7ae0 bsp=e0000000405c0d48
 [<a0000001003caf80>] mpt_HardResetHandler+0x1a0/0x2a0
                                sp=e0000000405c7dd0 bsp=e0000000405c0d00
 [<a0000001003cb190>] mpt_fault_reset_work+0x110/0x260
                                sp=e0000000405c7dd0 bsp=e0000000405c0cc0
 [<a00000010008a310>] run_workqueue+0x1f0/0x340
                                sp=e0000000405c7dd0 bsp=e0000000405c0c80
 [<a00000010008a5a0>] worker_thread+0x140/0x180
                                sp=e0000000405c7dd0 bsp=e0000000405c0c58
 [<a000000100092aa0>] kthread+0xa0/0x120
                                sp=e0000000405c7e30 bsp=e0000000405c0c28
 [<a000000100014430>] kernel_thread_helper+0x30/0x60
                                sp=e0000000405c7e30 bsp=e0000000405c0c00
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e0000000405c7e30 bsp=e0000000405c0c00
Kernel panic - not syncing: Aiee, killing interrupt handler!


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
