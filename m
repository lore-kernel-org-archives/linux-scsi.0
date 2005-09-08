From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 5/8] aacraid: error return checking
Date: Thu, 08 Sep 2005 13:50:24 -0700
Message-ID: <1126212624.7479.23.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:52397 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751394AbVIHUxg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2005 16:53:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn from Adaptec

This patch adds some additional error return checking and error return
value propagation during initialization. Also, the deprecation of
pci_module_init with pci_register_driver along with the change in return
values.

Applies to the scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>



Index: scsi-misc-aac-2/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/linit.c	2005-09-08 11:32:27.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/linit.c	2005-09-08 11:32:30.000000000 -0700
@@ -748,7 +748,8 @@
 		unique_id++;
 	}
 
-	if (pci_enable_device(pdev))
+	error = pci_enable_device(pdev);
+	if (error)
 		goto out;
 
 	if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL) || 
@@ -801,7 +802,9 @@
 			goto out_free_fibs;
 
 	aac->maximum_num_channels = aac_drivers[index].channels;
-	aac_get_adapter_info(aac);
+	error = aac_get_adapter_info(aac);
+	if (error < 0)
+		goto out_deinit;
 
 	/*
  	 * Lets override negotiations and drop the maximum SG limit to 34
@@ -929,9 +932,14 @@
 	printk(KERN_INFO "Adaptec %s driver (%s)\n",
 	  AAC_DRIVERNAME, aac_driver_version);
 
-	error = pci_module_init(&aac_pci_driver);
-	if (error)
+	error = pci_register_driver(&aac_pci_driver);
+	if (error < 0 || list_empty(&aac_devices)) {
+		if (error >= 0) {
+			pci_unregister_driver(&aac_pci_driver);
+			error = -ENODEV;
+		}
 		return error;
+	}
 
 	aac_cfg_major = register_chrdev( 0, "aac", &aac_cfg_fops);
 	if (aac_cfg_major < 0) {

-- 
Mark Haverkamp <markh@osdl.org>

