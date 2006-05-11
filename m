From: Erik Mouw <erik@harddisk-recovery.com>
Subject: [BUG 2.6.17-git] kmem_cache_create: duplicate cache scsi_cmd_cache
Date: Thu, 11 May 2006 17:14:57 +0200
Message-ID: <20060511151456.GD3755@harddisk-recovery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.126.206.180]:15188 "HELO abra2.bitwizard.nl")
	by vger.kernel.org with SMTP id S1030220AbWEKPO7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 11:14:59 -0400
Received: from erik by zurix.bitwizard.nl with local (Exim 3.36 #1 (Debian))
	id 1FeCsT-0002Yv-00
	for <linux-scsi@vger.kernel.org>; Thu, 11 May 2006 17:14:57 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

While playing with libata in 2.6.17-git from today, I got this bug:

SCSI subsystem initialized
libata version 1.20 loaded.
sata_promise 0000:02:05.0: version 1.04
kmem_cache_create: duplicate cache scsi_cmd_cache
 <c0159591> kmem_cache_create+0x331/0x390
 <e0924371> scsi_setup_command_freelist+0x71/0xf0 [scsi_mod]
 <e092588e> scsi_host_alloc+0x17e/0x270 [scsi_mod]
 <e08fd061> ata_host_add+0x41/0xc0 [libata]
 <c0148c9f> __kzalloc+0x1f/0x50
 <e08fd190> ata_device_add+0xb0/0x240 [libata]
 <e0839baf> pdc_ata_init_one+0x27f/0x330 [sata_promise]
 <c01dd1a9> pci_call_probe+0x19/0x20
 <c01dd20e> __pci_device_probe+0x5e/0x70
 <c01dd24f> pci_device_probe+0x2f/0x50
 <c0220977> driver_probe_device+0xb7/0xe0
 <c02b338a> klist_dec_and_del+0x1a/0x20
 <c0220a30> __driver_attach+0x0/0x90
 <c0220aa1>__driver_attach+0x71/0x90
 <c021fd49> bus_for_each_dev+0x69/0x80
 <c0220ae6> driver_attach+0x26/0x30
 <c0220a30> __driver_attach+0x0/0x90
 <c02202a3> bus_add_driver+0x83/0xc0
 <c01dd4ed> __pci_register_driver+0x4d/0x70
 <e0880017> pdc_ata_init+0x17/0x1b [sata_promise]
 <c013a1a0> sys_init_module+0x120/0x1b0
 <c0102f27> syscall_call+0x7/0xb

How to recreate:

- fully modular scsi and libata
- modprobe sata_promise ; modprobe sd_mod
- rmmod sd_mod ; rmmod sata_promise ; rmmod libata ; rmmod scsi_mod
- modprobe sata_promise

At first glance Looks to me like scsi_mod forgot to delete the
scsi_cmd_cache at module unload. Note that I can only trigger the bug
when there are devices connected to the SATA controller.

It doesn't look libata related, cause I can also trigger it using the
sym53c8xx driver:

SCSI subsystem initialized
sym0: <895> rev 0x1 at pci 0000:02:06.0 irq 17
kmem_cache_create: duplicate cache scsi_cmd_cache
 <c0159591> kmem_cache_create+0x331/0x390
 <e0924371> scsi_setup_command_freelist+0x71/0xf0 [scsi_mod]
 <e092588e> scsi_host_alloc+0x17e/0x270 [scsi_mod]
 <c011e697> printk+0x17/0x20
 <e09493e5> sym_attach+0x75/0x3d0 [sym53c8xx]
 <e0949d99> sym2_probe+0xc9/0x130 [sym53c8xx]
 <c01dd1a9> pci_call_probe+0x19/0x20
 <c01dd20e> __pci_device_probe+0x5e/0x70
 <c01dd24f> pci_device_probe+0x2f/0x50
 <c0220977> driver_probe_device+0xb7/0xe0
 <c02b338a> klist_dec_and_del+0x1a/0x20
 <c0220a30> __driver_attach+0x0/0x90
 <c0220aa1> __driver_attach+0x71/0x90
 <c021fd49> bus_for_each_dev+0x69/0x80
 <c0220ae6> driver_attach+0x26/0x30
 <c0220a30> __driver_attach+0x0/0x90
 <c02202a3> bus_add_driver+0x83/0xc0
 <c01dd4ed> __pci_register_driver+0x4d/0x70
 <e083903a> sym2_init+0x3a/0x5b [sym53c8xx]
 <c013a1a0> sys_init_module+0x120/0x1b0
 <c0102f27> syscall_call+0x7/0xb


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
