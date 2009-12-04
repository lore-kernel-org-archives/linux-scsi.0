From: Michael Reed <mdr@sgi.com>
Subject: scsi-misc crash - WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0x150/0x180()
Date: Fri, 04 Dec 2009 11:27:55 -0600
Message-ID: <4B19469B.6000009@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:38000 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756546AbZLDR1t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Dec 2009 12:27:49 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A27633040D4
	for <linux-scsi@vger.kernel.org>; Fri,  4 Dec 2009 09:27:55 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jeremy Higdon <jeremy@sgi.com>

This is with scsi-misc pull from a couple days ago.  kernel is rc5 based.
(I added the kdb patches....)

I'll see what I can see with this, but thought I'd post here in case
someone else has fix / suggestions.


------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0x150/0x180()
sysfs: cannot create duplicate filename '/dev/block/259:913408'
Modules linked in: qla2xxx(+) mptfc(+) mptscsih shpchp lpfc mptbase ide_cd_mod pci_hotplug tg3 scsi_transport_fc button cdrom scsi_tgt sg qla1280 xfs exportfs fan thermal processor thermal_sys hwmon sgiioc4 ide_core ioc4

Call Trace:
 [<a000000100017a20>] show_stack+0x80/0xa0
  3 out of 4 cpus in kdb, waiting for the rest, timeout in 10 second(s)
                                sp=e0000030f47afb60 bsp=e0000030f47a1440
 [<a0000001008ba680>] dump_stack+0x30/0x50
                                sp=e0000030f47afd30 bsp=e0000030f47a1428
 [<a0000001000c6d40>] warn_slowpath_common+0xc0/0x120
                                sp=e0000030f47afd30 bsp=e0000030f47a13e8
 [<a0000001000c6e90>] warn_slowpath_fmt+0x90/0xc0
                                sp=e0000030f47afd30 bsp=e0000030f47a1388
 [<a0000001003082d0>] sysfs_add_one+0x150/0x180
                                sp=e0000030f47afd70 bsp=e0000030f47a1348
 [<a00000010030ac30>] sysfs_do_create_link+0x190/0x300
                                sp=e0000030f47afd70 bsp=e0000030f47a1308
 [<a00000010030ae30>] sysfs_create_link+0x30/0x60
                                sp=e0000030f47afd90 bsp=e0000030f47a12d8
 [<a0000001005b3ab0>] device_add+0x4f0/0xf60
                                sp=e0000030f47afd90 bsp=e0000030f47a1258
 [<a0000001002f3820>] register_disk+0x80/0x3a0
                                sp=e0000030f47afda0 bsp=e0000030f47a1220
 [<a0000001003dbbf0>] add_disk+0x250/0x300
                                sp=e0000030f47afdc0 bsp=e0000030f47a11e8
 [<a0000001006004b0>] sd_probe_async+0x410/0x4e0
                                sp=e0000030f47afdd0 bsp=e0000030f47a11a0
 [<a0000001001109e0>] async_thread+0x260/0x5a0
                                sp=e0000030f47afdd0 bsp=e0000030f47a1120
 [<a0000001001013c0>] kthread+0x100/0x140
                                sp=e0000030f47afe00 bsp=e0000030f47a10e8
 [<a000000100015530>] kernel_thread_helper+0xd0/0x100
                                sp=e0000030f47afe30 bsp=e0000030f47a10c0
 [<a00000010000a4c0>] start_kernel_thread+0x20/0x40
                                sp=e0000030f47afe30 bsp=e0000030f47a10c0
---[ end trace 88eefd1b748be9ab ]---
Unable to handle kernel NULL pointer dereference (address 0000000000000038)
async/93[1469]: Oops 8813272891392 [1]
Modules linked in: qla2xxx(+) mptfc(+) mptscsih shpchp lpfc mptbase ide_cd_mod pci_hotplug tg3 scsi_transport_fc button cdrom scsi_tgt sg qla1280 xfs exportfs fan thermal processor thermal_sys hwmon sgiioc4 ide_core ioc4

Pid: 1469, CPU 0, comm:             async/93
psr : 00001010095a6010 ifs : 800000000000030a ip  : [<a000000100308370>]    Tainted: G        W  (2.6.32-rc5-scsi-misc)
ip is at sysfs_addrm_start+0x70/0x1a0
unat: 0000000000000000 pfs : 000000000000030a rsc : 0000000000000003
rnat: 3734386265396162 bsps: 3838656566643162 pr  : 000000000000aa41
ldrs: 0000000000000000 ccv : 0000000000000001 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a000000100308350 b6  : a00000010043a9a0 b7  : a00000010000d170
f6  : 1003e0000000000000001 f7  : 1003e8888888888888889
f8  : 1003e0000000000000002 f9  : 1003e8888888888888889
f10 : 1003ee84a4815c0000000 f11 : 1003e0000000000000003
r1  : a0000001015b8220 r2  : a0000001013d86e8 r3  : 0000000000000038
r8  : e0000030f47a1070 r9  : 0000000000000078 r10 : 000000000000000f
r11 : 000000000000000f r12 : e0000030f47afd60 r13 : e0000030f47a0000
r14 : a0000001013d86e8 r15 : a0000001013a2718 r16 : e00000b00301b2a0
r17 : e0000030f47a1070 r18 : e00000b003020000 r19 : a0000001015056e0
r20 : e0000030f45b1060 r21 : a0000001012b6db8 r22 : a0000001013d62a0
r23 : a0000001013d62a0 r24 : e0000030f45b1060 r25 : e0000030f45b0000
r26 : 0000000000000000 r27 : e0000030f45b0000 r28 : 0000000000000000
r29 : 0000000000000000 r30 : 0000000000000053 r31 : 00000000000003c0

Call Trace:
 [<a000000100017a20>] show_stack+0x80/0xa0
                                sp=e0000030f47af920 bsp=e0000030f47a14d8
 [<a000000100018080>] show_regs+0x640/0x920
                                sp=e0000030f47afaf0 bsp=e0000030f47a1480
 [<a000000100041d10>] die+0x190/0x2a0
                                sp=e0000030f47afb00 bsp=e0000030f47a1440
 [<a0000001008c7dc0>] ia64_do_page_fault+0x840/0xba0
                                sp=e0000030f47afb00 bsp=e0000030f47a13d8
 [<a00000010000cb60>] ia64_native_leave_kernel+0x0/0x270
                                sp=e0000030f47afb90 bsp=e0000030f47a13d8
 [<a000000100308370>] sysfs_addrm_start+0x70/0x1a0
                                sp=e0000030f47afd60 bsp=e0000030f47a1388
 [<a000000100309310>] create_dir+0x70/0x100
                                sp=e0000030f47afd60 bsp=e0000030f47a1350
 [<a000000100309410>] sysfs_create_dir+0x70/0x100
                                sp=e0000030f47afd80 bsp=e0000030f47a1330
 [<a00000010042b8c0>] kobject_add_internal+0x200/0x5c0
                                sp=e0000030f47afd90 bsp=e0000030f47a12e8
 [<a00000010042be80>] kobject_add_varg+0x60/0xc0
                                sp=e0000030f47afd90 bsp=e0000030f47a12b0
 [<a00000010042c030>] kobject_add+0x90/0x140
                                sp=e0000030f47afd90 bsp=e0000030f47a1250
 [<a0000001003cfe30>] blk_register_queue+0x70/0x180
                                sp=e0000030f47afdc0 bsp=e0000030f47a1220
 [<a0000001003dbc00>] add_disk+0x260/0x300
                                sp=e0000030f47afdc0 bsp=e0000030f47a11e8
 [<a0000001006004b0>] sd_probe_async+0x410/0x4e0
                                sp=e0000030f47afdd0 bsp=e0000030f47a11a0
 [<a0000001001109e0>] async_thread+0x260/0x5a0
                                sp=e0000030f47afdd0 bsp=e0000030f47a1120
 [<a0000001001013c0>] kthread+0x100/0x140
.                                sp=e0000030f47afe00 bsp=e0000030f47a10e8
 [<a000000100015530>] kernel_thread_helper+0xd0/0x100
                                sp=e0000030f47afe30 bsp=e0000030f47a10c0
 [<a00000010000a4c0>] start_kernel_thread+0x20/0x40
                                sp=e0000030f47afe30 bsp=e0000030f47a10c0
Disabling lock debugging due to kernel taint
All cpus are now in kdb

Entering kdb (current=0xe0000030f47a0000, pid 1469) on processor 0 Oops: <NULL>
due to oops @ 0xa000000100308370
 psr: 0x00001010095a6010   ifs: 0x800000000000030a    ip: 0xa000000100308370
unat: 0x0000000000000000   pfs: 0x000000000000030a   rsc: 0x0000000000000003
rnat: 0x3734386265396162  bsps: 0x3838656566643162    pr: 0x000000000000aa41
ldrs: 0x0000000000000000   ccv: 0x0000000000000001  fpsr: 0x0009804c8a70433f
  b0: 0xa000000100308350    b6: 0xa00000010043a9a0    b7: 0xa00000010000d170
  r1: 0xa0000001015b8220    r2: 0xa0000001013d86e8    r3: 0x0000000000000038
  r8: 0xe0000030f47a1070    r9: 0x0000000000000078   r10: 0x000000000000000f
 r11: 0x000000000000000f   r12: 0xe0000030f47afd60   r13: 0xe0000030f47a0000
 r14: 0xa0000001013d86e8   r15: 0xa0000001013a2718   r16: 0xe00000b00301b2a0
 r17: 0xe0000030f47a1070   r18: 0xe00000b003020000   r19: 0xa0000001015056e0
 r20: 0xe0000030f45b1060   r21: 0xa0000001012b6db8   r22: 0xa0000001013d62a0
 r23: 0xa0000001013d62a0   r24: 0xe0000030f45b1060   r25: 0xe0000030f45b0000
 r26: 0x0000000000000000   r27: 0xe0000030f45b0000   r28: 0x0000000000000000
 r29: 0x0000000000000000   r30: 0x0000000000000053   r31: 0x00000000000003c0
&regs = e0000030f47afba0
[0]kdb>
