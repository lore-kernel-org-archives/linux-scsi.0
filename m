From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: race while bringing up scsi / mptspi?
Date: Tue, 18 Nov 2008 16:22:43 -0800
Message-ID: <49235C53.8060403@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw.goop.org ([64.81.55.164]:47593 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbYKSAXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2008 19:23:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

I'm seeing this sometimes when I boot. It looks like mempool_alloc is 
falling over calling pool->alloc() because it is null.  Other times it 
boots fine, and seems solid once it has got past this point.

This is a Xen dom0 kernel, so lots of the low-level interrupt and DMA 
stuff is new code, but this seems to be above all that, and I don't 
think its related to anything I've done.  And as I say, it seems pretty 
solid once it gets past this.

Thanks,
    J

ioc0: LSI53C1030 C0: Capabilities={Initiator,Target}
ioc0: LSI53C1030 C0, FwRev=01032300h, Ports=1, MaxQ=255, IRQ=31
scsi 0:0:0:0: Direct-Access     SEAGATE  ST373454LC       D402 PQ: 0 ANSI: 3
scsi target0:0:0: Beginning Domain Validation
scsi target0:0:0: Ending Domain Validation
scsi target0:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU RTI WRFLOW PCOMP (6.25 ns, offset 63)
sd 0:0:0:0: [sda] 143374650 512-byte hardware sectors: (73.4 GB/68.3 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: ab 00 10 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:0:0: [sda] 143374650 512-byte hardware sectors: (73.4 GB/68.3 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: ab 00 10 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<0000000000000000>] 0x0
PGD 2e1df067 PUD 2e1c0067 PMD 0 
Oops: 0010 [#1] SMP 
last sysfs file: /sys/class/firmware/timeout
CPU 0 
Modules linked in: mptspi(+) mptscsih mptbase scsi_transport_spi sd_mod scsi_mod
Pid: 413, comm: modprobe Not tainted 2.6.28-rc5-tip #282
RIP: e030:[<0000000000000000>]  [<0000000000000000>] 0x0
RSP: e02b:ffff88002e1e17c0  EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000011210 RCX: 0000000000000008
RDX: ffff880080bfe000 RSI: 0000000000000000 RDI: 0000000000011200
RBP: ffff88002e1e1838 R08: 0000000000000024 R09: ffff88002fbe2b40
R10: 0000000000000000 R11: ffffffff803a9fb5 R12: ffff88002e5d9200
R13: ffff88002e1e17d8 R14: ffff88002e1e17f0 R15: ffff88002e5d9240
FS:  00007fb4db72b6f0(0000) GS:ffffffff8063bf40(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000002e1c6000 CR4: 0000000000000660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 413, threadinfo ffff88002e1e0000, task ffff88002f0ce780)
Stack:
 ffffffff80274322 ffffffff805cf600 0001121000000010 0000000000000000
 ffffffff805cf608 ffff88002e1e1838 ffffffff8022637e ffff88002e1e1808
 00000001189e6a9b ffff88002e1e1828 ffff88002e2188f8 0000000000000000
Call Trace:
 [<ffffffff80274322>] ? mempool_alloc+0x4f/0x107
 [<ffffffff8022637e>] ? pvclock_clocksource_read+0x47/0x83
 [<ffffffff80322669>] get_request+0x20c/0x2fe
 [<ffffffff80322789>] get_request_wait+0x2e/0x132
 [<ffffffff8020eda2>] ? xen_clocksource_read+0x21/0x23
 [<ffffffff8020fd6a>] ? xen_spin_lock+0xc5/0xd8
 [<ffffffff80335021>] ? _raw_spin_lock+0x68/0x10b
 [<ffffffff80322cbb>] blk_get_request+0x41/0x76
 [<ffffffffa00068a5>] scsi_execute+0x42/0x124 [scsi_mod]
 [<ffffffff80298df9>] ? kmem_cache_alloc+0x83/0xaf
 [<ffffffff80298df9>] ? kmem_cache_alloc+0x83/0xaf
 [<ffffffffa0006a05>] scsi_execute_req+0x7e/0xb0 [scsi_mod]
 [<ffffffffa00079e0>] scsi_probe_and_add_lun+0x229/0x9e0 [scsi_mod]
 [<ffffffff8047e4c1>] ? __mutex_unlock_slowpath+0xf9/0x103
 [<ffffffff8032c000>] ? kobject_get+0x1a/0x22
 [<ffffffff803a36c5>] ? get_device+0x1c/0x24
 [<ffffffffa000841c>] __scsi_scan_target+0xc0/0x538 [scsi_mod]
 [<ffffffff8020eda2>] ? xen_clocksource_read+0x21/0x23
 [<ffffffff8047e0e5>] ? __mutex_lock_slowpath+0x231/0x240
 [<ffffffffa00088eb>] scsi_scan_channel+0x57/0x7d [scsi_mod]
 [<ffffffffa00089bb>] scsi_scan_host_selected+0xaa/0xec [scsi_mod]
 [<ffffffffa0008a6d>] do_scsi_scan_host+0x70/0x75 [scsi_mod]
 [<ffffffffa0008d7a>] scsi_scan_host+0x188/0x1a1 [scsi_mod]
 [<ffffffffa004a49b>] mptspi_probe+0x33f/0x364 [mptspi]
 [<ffffffff8047f598>] ? _spin_unlock+0xe/0x10
 [<ffffffff8033e84f>] pci_device_probe+0x51/0x77
 [<ffffffff803a7354>] driver_probe_device+0x176/0x286
 [<ffffffff803a74cb>] __driver_attach+0x67/0x91
 [<ffffffff803a7464>] ? __driver_attach+0x0/0x91
 [<ffffffff803a69bd>] bus_for_each_dev+0x54/0x8d
 [<ffffffff803a7023>] driver_attach+0x21/0x23
 [<ffffffff803a6217>] bus_add_driver+0xff/0x249
 [<ffffffff803a76dc>] driver_register+0xad/0x12d
 [<ffffffffa0050000>] ? mptspi_init+0x0/0xe3 [mptspi]
 [<ffffffff8033eb13>] __pci_register_driver+0x7b/0xb4
 [<ffffffffa0050000>] ? mptspi_init+0x0/0xe3 [mptspi]
 [<ffffffffa00500cb>] mptspi_init+0xcb/0xe3 [mptspi]
 [<ffffffff8020a05b>] do_one_initcall+0x5b/0x13d
 [<ffffffff802538e0>] ? __blocking_notifier_call_chain+0x5d/0x6f
 [<ffffffff80260c88>] sys_init_module+0xae/0x1bb
 [<ffffffff8021249a>] system_call_fastpath+0x16/0x1b
Code:  Bad RIP value.
RIP  [<0000000000000000>] 0x0
 RSP <ffff88002e1e17c0>
CR2: 0000000000000000
---[ end trace c844b43c46a26831 ]---


