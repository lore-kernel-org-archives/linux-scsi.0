From: Tejun Heo <htejun@gmail.com>
Subject: htejun@gmail.com: sym53c8xx: gfp flag bug
Date: Wed, 30 Mar 2005 12:25:43 +0900
Message-ID: <20050330032543.GA23533@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.198]:1522 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261723AbVC3DZx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 22:25:53 -0500
Received: by wproxy.gmail.com with SMTP id 68so10229wra
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2005 19:25:49 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

 (This is re-post, I mistyped linux-scsi address in the first mail.
  Sorry, Matthew.)

 Hello, Matthew Wilcox.

 The following might_sleep() message appears during booting on
scsi-misc-2.6.  Quick glance shows that sym_alloc_lcb_tags() uses
GFP_KERNEL blindly.

sym0: <1010-33> rev 0x1 at pci 0000:01:06.0 irq 29
sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: open drain IRQ line driver
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
sym0: SCSI BUS has been reset.
scsi2 : sym-2.2.0
  Vendor: FUJITSU   Model: MAJ3182MP         Rev: 0114
  Type:   Direct-Access                      ANSI SCSI revision: 04
 target2:0:2: tagged command queuing enabled, command queue depth 16.
 target2:0:2: Beginning Domain Validation
Debug: sleeping function called from invalid context at mm/slab.c:2084
in_atomic():1, irqs_disabled():1
 [<c0103d7e>] dump_stack+0x1e/0x20
 [<c0117b04>] __might_sleep+0xa4/0xb0
 [<c01450b5>] __kmalloc+0x95/0xa0
 [<c014521c>] kcalloc+0x3c/0x70
 [<f8a5f4cd>] sym_alloc_lcb_tags+0x7d/0x130 [sym53c8xx]
 [<f8a5ee0d>] sym_get_ccb+0x21d/0x2b0 [sym53c8xx]
 [<f8a56d07>] sym_queue_command+0xb7/0xf0 [sym53c8xx]
 [<f8a57117>] sym53c8xx_queue_command+0x77/0xa0 [sym53c8xx]
 [<c02704c6>] scsi_dispatch_cmd+0x1a6/0x2a0
 [<c0276db0>] scsi_request_fn+0x210/0x410
 [<c023cf73>] blk_insert_request+0xa3/0xd0
 [<c027593b>] scsi_insert_special_req+0x3b/0x40
 [<c0275bc1>] scsi_wait_req+0x91/0xd0
 [<c027cb3a>] spi_dv_device_compare_inquiry+0xaa/0x130
 [<c027ce76>] spi_dv_device_internal+0x56/0x2e0
 [<c027d1eb>] spi_dv_device+0xeb/0x160
 [<f8a579cd>] sym53c8xx_slave_configure+0x10d/0x110 [sym53c8xx]
 [<c027874c>] scsi_add_lun+0x2fc/0x360
 [<c027888d>] scsi_probe_and_add_lun+0xdd/0x210
 [<c0279211>] scsi_scan_target+0xe1/0x180
 [<c0279343>] scsi_scan_channel+0x93/0xb0
 [<c0279430>] scsi_scan_host_selected+0xd0/0x110
 [<c02794a1>] scsi_scan_host+0x31/0x40
 [<f8a58ee9>] sym2_probe+0xf9/0x140 [sym53c8xx]
 [<c01dd57b>] pci_device_probe_static+0x4b/0x60
 [<c01dd5cc>] __pci_device_probe+0x3c/0x50
 [<c01dd60c>] pci_device_probe+0x2c/0x50
 [<c023525e>] driver_probe_device+0x2e/0x80
 [<c02353aa>] driver_attach+0x5a/0x90
 [<c02358e7>] bus_add_driver+0xa7/0xe0
 [<c0235f42>] driver_register+0x62/0x70
 [<c01dd87b>] pci_register_driver+0x8b/0xb0
 [<f89a2034>] sym2_init+0x34/0x52 [sym53c8xx]
 [<c01368ee>] sys_init_module+0x1be/0x290
 [<c0102f05>] syscall_call+0x7/0xb
 target2:0:2: asynchronous.
 target2:0:2: wide asynchronous.
 target2:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 target2:0:2: Ending Domain Validation
SCSI device sdb: 35694904 512-byte hdwr sectors (18276 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 35694904 512-byte hdwr sectors (18276 MB)
SCSI device sdb: drive cache: write back
 sdb: sdb1 sdb2
Attached scsi disk sdb at scsi2, channel 0, id 2, lun 0


 Thanks.

-- 
tejun

