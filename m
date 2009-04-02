From: Nikola Ciprich <extmaillist@linuxbox.cz>
Subject: sym53c8xx: WARNING on module unload, crashes on further usage
Date: Thu, 2 Apr 2009 09:54:04 +0200
Message-ID: <20090402075404.GA9784@develbox.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw3.lbox.cz ([62.245.111.133]:60533 "EHLO develbox.linuxbox.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759089AbZDBIKw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Apr 2009 04:10:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>
Cc: nikola.ciprich@linuxbox.cz

Hi,
we're experiencing problems using changer connected on LSI Logic / Symbios Logic 53c875 adaptor (using sym53c8xx module).
Sometimes changer gets stuck, and reloading sym53c8xx module is the only way to help. But it alwas issues following warning,
and on subsequent mtx usage, the whole machine usually crashes...

the warning issued on module unload:

WARNING: at /home/src/redhat/BUILD/linux-2.6.29/arch/x86/include/asm/dma-mapping.h:297 ___free_dma_mem_cluster+0xba/0xc0 [sym53c8xx]()
Hardware name: PDSM4+
Modules linked in: ipmi_si ipmi_devintf ipmi_msghandler nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ipv6 reiserfs dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod sbs sbshc fan battery ac parport_pc lp parport nvram st osst joydev sg usbhid container piix pata_acpi ide_pci_generic sym53c8xx(-) scsi_transport_spi arcmsr thermal processor thermal_sys buttone1000e rng_core i2c_i801 ata_piix i3000_edac iTCO_wdt ata_generic i2c_core shpchp edac_core pci_hotplug pcspkr rtc ide_gd_mod ide_core ahci libata sd_mod scsi_mod raid456 async_xor async_memcpy async_tx xor raid1 ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: freq_tabl
e]

Pid: 5495, comm: rmmod Not tainted 2.6.29lb.00_01_PRE09 #1
Call Trace:
 [<c022e7d6>] warn_slowpath+0x86/0xa0
 [<c02e312f>] ? free_proc_entry+0x5f/0x80
 [<c02e312f>] ? free_proc_entry+0x5f/0x80
 [<f80ae38a>] ___free_dma_mem_cluster+0xba/0xc0 [sym53c8xx]
 [<f80ae231>] __sym_mfree+0x91/0xe0 [sym53c8xx]
 [<c046d82c>] ? _spin_lock_irqsave+0x4c/0x60
 [<f80ae741>] __sym_mfree_dma+0x51/0x80 [sym53c8xx]
 [<f80a7851>] sym_hcb_free+0x51/0x190 [sym53c8xx]
 [<f80a5659>] sym_free_resources+0x39/0x80 [sym53c8xx]
 [<c03352b9>] ? __delay+0x9/0x10
 [<f80a5735>] sym_detach+0x95/0xb0 [sym53c8xx]
 [<f80a5775>] sym2_remove+0x25/0x50 [sym53c8xx]
 [<c0340c99>] pci_device_remove+0x19/0x40
 [<c03954e9>] __device_release_driver+0x49/0x80
 [<c03955b7>] driver_detach+0x97/0xa0
 [<c03948b3>] bus_remove_driver+0x73/0x90
 [<c0395a5f>] driver_unregister+0x2f/0x40
 [<c0340ef1>] pci_unregister_driver+0x21/0x80
 [<f80af0dd>] sym2_exit+0xd/0x20 [sym53c8xx]
 [<c0258b06>] sys_delete_module+0x126/0x1f0
 [<c021aa76>] ? do_page_fault+0x1f6/0x630
 [<c0268da0>] ? audit_syscall_exit+0x310/0x380
 [<c028d699>] ? sys_munmap+0x39/0x50
 [<c0203415>] sysenter_do_call+0x12/0x2c

We're having those problems on 2.6.29, but it was happening also on older kernels (2.6.26, ...)
Could somebody have a look on this?
Should more information be needed, I'll gladly provide it.
thanks a lot in advance.
best regards
nik

-- 
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
