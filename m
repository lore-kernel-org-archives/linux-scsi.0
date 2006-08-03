From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 3/4] aacraid: Check for unlikely errors
Date: Thu, 03 Aug 2006 08:03:07 -0700
Message-ID: <1154617387.31319.22.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:64740 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932436AbWHCPDK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2006 11:03:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

The enclosed patch cleans up some code fragments, adds some paranoia
(unproven causes of potential driver failures). 

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2006-07-31 14:33:27.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2006-07-31 14:33:51.000000000 -0700
@@ -489,6 +489,8 @@
 	unsigned instance;
 
 	fsa_dev_ptr = dev->fsa_dev;
+	if (!fsa_dev_ptr)
+		return -ENOMEM;
 	instance = dev->scsi_host_ptr->unique_id;
 
 	if (!(fibptr = aac_fib_alloc(dev)))
@@ -1392,6 +1394,7 @@
 	struct scsi_cmnd *cmd;
 	struct scsi_device *sdev = scsicmd->device;
 	int active = 0;
+	struct aac_dev *aac;
 	unsigned long flags;
 
 	/*
@@ -1413,11 +1416,11 @@
 	if (active)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 
+	aac = (struct aac_dev *)scsicmd->device->host->hostdata;
 	/*
 	 *	Allocate and initialize a Fib
 	 */
-	if (!(cmd_fibcontext = 
-	    aac_fib_alloc((struct aac_dev *)scsicmd->device->host->hostdata)))
+	if (!(cmd_fibcontext = aac_fib_alloc(aac)))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
 	aac_fib_init(cmd_fibcontext);
@@ -1470,6 +1473,8 @@
 	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
 	struct fsa_dev_info *fsa_dev_ptr = dev->fsa_dev;
 	
+	if (fsa_dev_ptr == NULL)
+		return -1;
 	/*
 	 *	If the bus, id or lun is out of range, return fail
 	 *	Test does not apply to ID 16, the pseudo id for the controller
@@ -1782,6 +1787,8 @@
 	struct fsa_dev_info *fsa_dev_ptr;
 
 	fsa_dev_ptr = dev->fsa_dev;
+	if (!fsa_dev_ptr)
+		return -ENODEV;
 	if (copy_from_user(&qd, arg, sizeof (struct aac_query_disk)))
 		return -EFAULT;
 	if (qd.cnum == -1)
@@ -1843,6 +1850,10 @@
 	struct fsa_dev_info *fsa_dev_ptr;
 
 	fsa_dev_ptr = dev->fsa_dev;
+	if (!fsa_dev_ptr)
+		return -ENODEV;
+	if (!fsa_dev_ptr)
+		return -ENODEV;
 
 	if (copy_from_user(&dd, arg, sizeof (struct aac_delete_disk)))
 		return -EFAULT;
--- scsi-misc-aac.orig/drivers/scsi/aacraid/comminit.c	2006-07-31 14:33:23.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/comminit.c	2006-07-31 14:33:51.000000000 -0700
@@ -180,7 +180,7 @@
 			  -2 /* Timeout silently */, 1,
 			  NULL, NULL);
 
-	if (status == 0)
+	if (status >= 0)
 		aac_fib_complete(fibctx);
 	aac_fib_free(fibctx);
 	return status;
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-07-31 14:33:23.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-07-31 14:33:51.000000000 -0700
@@ -1013,6 +1013,10 @@
 	list_del(&aac->entry);
 	scsi_host_put(shost);
 	pci_disable_device(pdev);
+	if (list_empty(&aac_devices)) {
+		unregister_chrdev(aac_cfg_major, "aac");
+		aac_cfg_major = -1;
+	}
 }
 
 static struct pci_driver aac_pci_driver = {

-- 
Mark Haverkamp <markh@osdl.org>

