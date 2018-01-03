From: Meelis Roos <mroos@linux.ee>
Subject: [PATCH] aacraid driver oops with dead battery
Date: Wed, 3 Jan 2018 11:11:09 +0200 (EET)
Message-ID: <alpine.LRH.2.21.1801031057510.4107@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:49636 "EHLO smtp2.it.da.ut.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751255AbeACJLN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Jan 2018 04:11:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@microsemi.com>

The battery in my HP NetRAID-4M died of old age, and the aacraid driver 
started oopsing with NULL pointer dereference on startup after that.

Fix it by reordering the init sequence to fill in function pointers 
before ioremapping memory, or dev->a_ops.adapter_ioremap pointer will be 
NULL.

Other subtypes of aacraid seem to have the order already correct.

This was the call trace:

 ? aac_probe_one+0x7a5/0xb30 [aacraid]
 pci_device_probe+0xc0/0x1a0
 driver_probe_device+0x1df/0x3b0
 __driver_attach+0xa9/0xe0
 ? driver_probe_device+0x3b0/0x3b0
 bus_for_each_dev+0x4c/0x90
 driver_attach+0x1d/0x40
 ? driver_probe_device+0x3b0/0x3b0
 bus_add_driver+0x1a7/0x2a0
 driver_register+0x6e/0x130
 __pci_register_driver+0x54/0x90
 ? 0xf81f4000
 aac_init+0x2b/0x1000 [aacraid]
 do_one_initcall+0x45/0x1e0
 ? kfree_skbmem+0x74/0xa0
 ? kfree+0x16d/0x240
 ? kvfree+0x45/0x50
 ? kvfree+0x45/0x50
 ? __vunmap+0x99/0x120
 ? do_init_module+0x1a/0x245
 do_init_module+0x83/0x245
 load_module+0x2764/0x34a0
 ? kernel_read_file+0x150/0x320
 SyS_finit_module+0x82/0xa0
 do_fast_syscall_32+0xba/0x340

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
index 553922fed524..882f40353b96 100644
--- a/drivers/scsi/aacraid/sa.c
+++ b/drivers/scsi/aacraid/sa.c
@@ -329,6 +329,22 @@ int aac_sa_init(struct aac_dev *dev)
 	instance = dev->id;
 	name     = dev->name;
 
+	/*
+	 *	Fill in the function dispatch table.
+	 */
+
+	dev->a_ops.adapter_interrupt = aac_sa_interrupt_adapter;
+	dev->a_ops.adapter_disable_int = aac_sa_disable_interrupt;
+	dev->a_ops.adapter_enable_int = aac_sa_enable_interrupt;
+	dev->a_ops.adapter_notify = aac_sa_notify_adapter;
+	dev->a_ops.adapter_sync_cmd = sa_sync_cmd;
+	dev->a_ops.adapter_check_health = aac_sa_check_health;
+	dev->a_ops.adapter_restart = aac_sa_restart_adapter;
+	dev->a_ops.adapter_start = aac_sa_start_adapter;
+	dev->a_ops.adapter_intr = aac_sa_intr;
+	dev->a_ops.adapter_deliver = aac_rx_deliver_producer;
+	dev->a_ops.adapter_ioremap = aac_sa_ioremap;
+
 	if (aac_sa_ioremap(dev, dev->base_size)) {
 		printk(KERN_WARNING "%s: unable to map adapter.\n", name);
 		goto error_iounmap;
@@ -362,22 +378,6 @@ int aac_sa_init(struct aac_dev *dev)
 		msleep(1);
 	}
 
-	/*
-	 *	Fill in the function dispatch table.
-	 */
-
-	dev->a_ops.adapter_interrupt = aac_sa_interrupt_adapter;
-	dev->a_ops.adapter_disable_int = aac_sa_disable_interrupt;
-	dev->a_ops.adapter_enable_int = aac_sa_enable_interrupt;
-	dev->a_ops.adapter_notify = aac_sa_notify_adapter;
-	dev->a_ops.adapter_sync_cmd = sa_sync_cmd;
-	dev->a_ops.adapter_check_health = aac_sa_check_health;
-	dev->a_ops.adapter_restart = aac_sa_restart_adapter;
-	dev->a_ops.adapter_start = aac_sa_start_adapter;
-	dev->a_ops.adapter_intr = aac_sa_intr;
-	dev->a_ops.adapter_deliver = aac_rx_deliver_producer;
-	dev->a_ops.adapter_ioremap = aac_sa_ioremap;
-
 	/*
 	 *	First clear out all interrupts.  Then enable the one's that 
 	 *	we can handle.


-- 
Meelis Roos (mroos@linux.ee)
