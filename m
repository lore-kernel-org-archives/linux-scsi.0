From: Jan-Frode Myklebust <mykleb@no.ibm.com>
Subject: soft lockup with 2.6.14.4/ips
Date: Tue, 27 Dec 2005 15:31:36 +0100
Message-ID: <slrndr2k28.efu.mykleb@99RXZYP.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:62901 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S932314AbVL0Oko (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Dec 2005 09:40:44 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1ErG0H-0000uK-UQ
	for linux-scsi@vger.kernel.org; Tue, 27 Dec 2005 15:40:42 +0100
Received: from 232.80-202-203.nextgentel.com ([80.202.203.232])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 27 Dec 2005 15:40:41 +0100
Received: from mykleb by 232.80-202-203.nextgentel.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 27 Dec 2005 15:40:41 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I just tried booting 2.6.14.4 on a x345 with a IBM ServeRAID 6i adapter,
and got a ugly message during the initial load of the ips module. The system
looked OK afterwards, but we immediately booted back to the "working" 
2.6.10-1.771_FC2smp kernel.

 ACPI: PCI Interrupt 0000:08:02.0[A] -> GSI 18 (level, low) -> IRQ 18
 BUG: soft lockup detected on CPU#0!

 Pid: 1, comm:              swapper
 EIP: 0060:[<c01101b6>] CPU: 0
 EIP is at delay_pmtmr+0x16/0x20
  EFLAGS: 00000206    Not tainted  (2.6.14.4)
 EAX: 00112948 EBX: 002e5dd3 ECX: 46064654 EDX: 00000009
 ESI: f7cf0c00 EDI: 00000004 EBP: c2932e77 DS: 007b ES: 007b
 CR0: 8005003b CR2: ffecf000 CR3: 0046b000 CR4: 000006d0
  [<c01dbf49>] __delay+0x9/0x10
  [<c02ad48b>] ips_init_morpheus+0x2b/0x230
  [<c02ad7d1>] ips_reset_morpheus+0x61/0x80
  [<c02afc0b>] ips_init_phase1+0x3fb/0x680
  [<c02af7a0>] ips_insert_device+0x20/0x90
  [<c01e4e3a>] pci_call_probe+0xa/0x10
  [<c01e4e8c>] __pci_device_probe+0x4c/0x60
  [<c01e4ec6>] pci_device_probe+0x26/0x50
  [<c0252266>] driver_probe_device+0x36/0xb0
  [<c02523b9>] __driver_attach+0x59/0x60
  [<c0251925>] bus_for_each_dev+0x45/0x60
  [<c02523d6>] driver_attach+0x16/0x20
  [<c0252360>] __driver_attach+0x0/0x60
  [<c0251dbc>] bus_add_driver+0x7c/0xc0
  [<c0252813>] driver_register+0x73/0x80
  [<c01e5169>] pci_register_driver+0xb9/0xd0
  [<c045136a>] ips_module_init+0xa/0x50
  [<c04339cb>] do_initcalls+0x2b/0xc0
  [<c0100375>] init+0x75/0x1d0
  [<c0100300>] init+0x0/0x1d0
  [<c0101165>] kernel_thread_helper+0x5/0x10
 ips 0000:08:02.0: Warning ! ! ! ServeRAID Version Mismatch
 ips 0000:08:02.0: Bios = 7.00.14, Firmware = 7.00.14, Device Driver = 7.12.02
 ips 0000:08:02.0: These levels should match to avoid possible compatibility problems.
 scsi0 : IBM PCI ServeRAID 7.12.02  Build 761 <ServeRAID 6i>
   Vendor: IBM       Model: SERVERAID         Rev: 1.00
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: IBM       Model: SERVERAID         Rev: 1.00
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: IBM       Model: SERVERAID         Rev: 1.00
   Type:   Processor                          ANSI SCSI revision: 02
 SCSI device sda: 860239872 512-byte hdwr sectors (440443 MB)
 sda: got wrong page
 sda: assuming drive cache: write through
 SCSI device sda: 860239872 512-byte hdwr sectors (440443 MB)
 sda: got wrong page
 sda: assuming drive cache: write through
  sda: sda1
 Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
 SCSI device sdb: 71096320 512-byte hdwr sectors (36401 MB)
 sdb: got wrong page
 sdb: assuming drive cache: write through
 SCSI device sdb: 71096320 512-byte hdwr sectors (36401 MB)
 sdb: got wrong page
 sdb: assuming drive cache: write through
  sdb: sdb1 sdb2
 Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
 Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
 Attached scsi generic sg1 at scsi0, channel 0, id 1, lun 0,  type 0
 Attached scsi generic sg2 at scsi0, channel 0, id 15, lun 0,  type 3



  -jf

