From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 4/7] aacraid: error return checking
Date: Tue, 20 Sep 2005 12:56:36 -0700
Message-ID: <1127246196.1891.35.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:32190 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965110AbVITT7t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2005 15:59:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn from Adaptec

This patch adds some additional error return checking and error return
value propagation during initialization. Also, the deprecation of
pci_module_init with pci_register_driver along with the change in return
values.

Updated from review comments since the last version of the patch.

Applies to the scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>



Index: scsi-misc-aac-2/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/linit.c	2005-09-20 09:08:01.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/linit.c	2005-09-20 09:12:05.000000000 -0700
@@ -748,7 +748,8 @@
 		unique_id++;
 	}
 
-	if (pci_enable_device(pdev))
+	error = pci_enable_device(pdev);
+	if (error)
 		goto out;
 
 	if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL) || 
@@ -800,7 +801,9 @@
 			goto out_free_fibs;
 
 	aac->maximum_num_channels = aac_drivers[index].channels;
-	aac_get_adapter_info(aac);
+	error = aac_get_adapter_info(aac);
+	if (error < 0)
+		goto out_deinit;
 
 	/*
  	 * Lets override negotiations and drop the maximum SG limit to 34
@@ -928,8 +931,8 @@
 	printk(KERN_INFO "Adaptec %s driver (%s)\n",
 	  AAC_DRIVERNAME, aac_driver_version);
 
-	error = pci_module_init(&aac_pci_driver);
-	if (error)
+	error = pci_register_driver(&aac_pci_driver);
+	if (error < 0)
 		return error;
 
 	aac_cfg_major = register_chrdev( 0, "aac", &aac_cfg_fops);

-- 
Mark Haverkamp <markh@osdl.org>

