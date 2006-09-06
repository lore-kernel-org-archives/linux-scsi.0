From: Andrew Morton <akpm@osdl.org>
Subject: git-scsi-misc oops
Date: Tue, 5 Sep 2006 23:19:33 -0700
Message-ID: <20060905231933.3371cd8a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:43697 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932598AbWIFGTg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Sep 2006 02:19:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org


aic79xxx isn't happy.  Using
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git,
no other patches applied.



netconsole: network logging started
GSI 18 sharing vector 0xB9 and IRQ 18
ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 30 (level, low) -> IRQ 18
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec AIC7902 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs

scsi 0:0:5:0: Direct access     MAXTOR   ATLAS10K4_73WLS  DFV0 PQ: 0 ANSI: 3
 target0:0:5: asynchronous
scsi0:A:5:0: Tagged Queuing enabled.  Depth 64
Unable to handle kernel NULL pointer dereference at 0000000000000200 RIP: 
 [<ffffffff8024aed1>] module_refcount+0x11/0x27
PGD 0 
Oops: 0000 [1] PREEMPT SMP 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.18-rc6 #5
RIP: 0010:[<ffffffff8024aed1>]  [<ffffffff8024aed1>] module_refcount+0x11/0x27
RSP: 0000:ffff81017fc5d850  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81017f7a84d8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000213 RDI: 0000000000000000
RBP: ffff81017fc5d850 R08: ffff81017fc01610 R09: ffff81017f72e000
R10: ffff81017f72e000 R11: ffff81017f7aec98 R12: ffff81017f7a84c8
R13: ffff81017f7aeae0 R14: ffff81017f7a84c8 R15: 0000000000000213
FS:  0000000000000000(0000) GS:ffffffff80668000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000200 CR3: 0000000000201000 CR4: 00000000000006e0
Process swapper (pid: 1, threadinfo ffff81017fc5c000, task ffff81017fc53760)
Stack:  ffff81017fc5d870 ffffffff803ccb03 ffff81017f7a84d8 0000000000000000
 ffff81017fc5d8b0 ffffffff803cd65d ffff81017f7a84c8 ffff81017f7a84c8
 ffff81017f7acb08 ffff81017f7aeae0 ffffffff803d1439 0000000000000000
Call Trace:
 [<ffffffff803ccb03>] scsi_device_put+0x1c/0x9a
 [<ffffffff803cd65d>] __scsi_iterate_devices+0x67/0x77
 [<ffffffff803d1439>] device_quiesce_fn+0x0/0xb
 [<ffffffff803cd6ea>] starget_for_each_device+0x7d/0x93
 [<ffffffff803d0e91>] scsi_target_quiesce+0x12/0x14
 [<ffffffff803d6030>] spi_dv_device+0x62/0x520
 [<ffffffff803ccc59>] scsi_adjust_queue_depth+0xd8/0xe5
 [<ffffffff803f6f50>] ahd_linux_slave_configure+0x132/0x141
 [<ffffffff803d333a>] scsi_probe_and_add_lun+0x79b/0x901
 [<ffffffff803d3582>] __scsi_scan_target+0xe2/0x591
 [<ffffffff804c9de5>] _spin_unlock+0x13/0x2f
 [<ffffffff804c6952>] klist_next+0x5a/0x65
 [<ffffffff804c67c0>] klist_release+0x0/0x60
 [<ffffffff803d3a7e>] scsi_scan_channel+0x4d/0x79
 [<ffffffff803d3b2d>] scsi_scan_host_selected+0x83/0xc6
 [<ffffffff803d3b83>] scsi_scan_host+0x13/0x15
 [<ffffffff803f6b3c>] ahd_linux_register_host+0x2e3/0x2f7
 [<ffffffff803fa806>] ahd_pci_map_int+0x31/0x59
 [<ffffffff803f25e1>] ahd_pci_config+0xd2c/0xd5f
 [<ffffffff803faa22>] ahd_linux_pci_dev_probe+0x1e2/0x1fa
 [<ffffffff8033934d>] kobject_get+0x17/0x1e
 [<ffffffff8034469b>] pci_device_probe+0x4c/0x72
 [<ffffffff803a6fb4>] driver_probe_device+0x5a/0xaf
 [<ffffffff803a7111>] __driver_attach+0x87/0xc5
 [<ffffffff803a708a>] __driver_attach+0x0/0xc5
 [<ffffffff803a6402>] bus_for_each_dev+0x49/0x7a
 [<ffffffff803a6e44>] driver_attach+0x1c/0x1e
 [<ffffffff803a676c>] bus_add_driver+0x72/0x10f
 [<ffffffff803a758a>] driver_register+0x8d/0x91
 [<ffffffff8034426d>] __pci_register_driver+0x61/0x84
 [<ffffffff803fa7c1>] ahd_linux_pci_init+0x12/0x14
 [<ffffffff8069603b>] ahd_linux_init+0x6a/0x82
 [<ffffffff802071a0>] init+0x144/0x304
 [<ffffffff804c9eab>] _spin_unlock_irq+0x14/0x30
 [<ffffffff8022c1d6>] schedule_tail+0x43/0xb5
 [<ffffffff8020a8dc>] child_rip+0xa/0x12
 [<ffffffff8020705c>] init+0x0/0x304
 [<ffffffff8020a8d2>] child_rip+0x0/0x12


Code: 48 8b 80 00 02 00 00 01 c1 48 ff c2 48 83 fa 04 75 e5 89 c8 
RIP  [<ffffffff8024aed1>] module_refcount+0x11/0x27
 RSP <ffff81017fc5d850>
CR2: 0000000000000200
 <0>Kernel panic - not syncing: Attempted to kill init!
