From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6.9 aacraid: aac_count fix (third try)
Date: Thu, 16 Sep 2004 13:10:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095365414.2440.73.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:4274 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S268183AbUIPUK1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 16:10:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

After Mark's recant, here is the patch with the scsi_add_host back where
it used to be.
--------------

Changed the managing of aac device structures to a linked list so that
there is no limit to how many adapters can be configured.

Applies to latest scsi-misc bk tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/aacraid.h 1.21 vs edited =====
--- 1.21/drivers/scsi/aacraid/aacraid.h	2004-08-16 11:28:35 -07:00
+++ edited/drivers/scsi/aacraid/aacraid.h	2004-09-14 16:04:25 -07:00
@@ -7,7 +7,6 @@
  *----------------------------------------------------------------------------*/
 
 #define MAXIMUM_NUM_CONTAINERS	32
-#define MAXIMUM_NUM_ADAPTERS	8
 
 #define AAC_NUM_FIB		(256 + 64)
 #define AAC_NUM_IO_FIB		100
@@ -772,7 +771,7 @@
 
 struct aac_dev
 {
-	struct aac_dev		*next;
+	struct list_head	entry;
 	const char		*name;
 	int			id;
 
===== drivers/scsi/aacraid/linit.c 1.38 vs edited =====
--- 1.38/drivers/scsi/aacraid/linit.c	2004-08-24 08:49:49 -07:00
+++ edited/drivers/scsi/aacraid/linit.c	2004-09-16 11:31:35 -07:00
@@ -65,8 +65,7 @@
 MODULE_LICENSE("GPL");
 MODULE_VERSION(AAC_DRIVER_VERSION);
 
-struct aac_dev *aac_devices[MAXIMUM_NUM_ADAPTERS];
-static unsigned aac_count;
+static LIST_HEAD(aac_devices);
 static int aac_cfg_major = -1;
 
 /*
@@ -452,11 +451,18 @@
 
 static int aac_cfg_open(struct inode *inode, struct file *file)
 {
+	struct aac_dev *aac;
 	unsigned minor = iminor(inode);
+	int err = -ENODEV;
+
+	list_for_each_entry(aac, &aac_devices, entry) {
+		if (aac->id == minor) {
+			file->private_data = aac;
+			err = 0;
+			break;
+		}
+	}
 
-	if (minor >= aac_count)
-		return -ENODEV;
-	file->private_data = aac_devices[minor];
 	return 0;
 }
 
@@ -517,8 +523,18 @@
 	struct Scsi_Host *shost;
 	struct fsa_scsi_hba *fsa_dev_ptr;
 	struct aac_dev *aac;
-	int container;
+	struct list_head *insert = &aac_devices;
 	int error = -ENODEV;
+	int unique_id = 0;
+	int container;
+
+	list_for_each_entry(aac, &aac_devices, entry) {
+		if (aac->id > unique_id) {
+			insert = &aac->entry;
+			break;
+		}
+		unique_id++;
+	}
 
 	if (pci_enable_device(pdev))
 		goto out;
@@ -537,16 +553,13 @@
 	
 	pci_set_master(pdev);
 
-	/* Increment the host adapter count */
-	aac_count++;
-
 	shost = scsi_host_alloc(&aac_driver_template, sizeof(struct aac_dev));
 	if (!shost)
 		goto out_disable_pdev;
 
 	shost->irq = pdev->irq;
 	shost->base = pci_resource_start(pdev, 0);
-	shost->unique_id = aac_count - 1;
+	shost->unique_id = unique_id;
 
 	aac = (struct aac_dev *)shost->hostdata;
 	aac->scsi_host_ptr = shost;	
@@ -554,6 +567,7 @@
 	aac->name = aac_driver_template.name;
 	aac->id = shost->unique_id;
 	aac->cardtype =  index;
+	INIT_LIST_HEAD(&aac->entry);
 
 	aac->fibs = kmalloc(sizeof(struct fib) * AAC_NUM_FIB, GFP_KERNEL);
 	if (!aac->fibs)
@@ -591,7 +605,7 @@
 
 	aac_get_config_status(aac);
 	aac_get_containers(aac);
-	aac_devices[aac_count-1] = aac;
+	list_add(&aac->entry, insert);
 
 	/*
 	 * dmb - we may need to move the setting of these parms somewhere else once
@@ -625,7 +639,6 @@
 	scsi_host_put(shost);
  out_disable_pdev:
 	pci_disable_device(pdev);
-	aac_count--;
  out:
 	return error;
 }
@@ -654,15 +667,7 @@
 	scsi_host_put(shost);
 	pci_disable_device(pdev);
 
-	/*
-	 * We don't decrement aac_count here because adapters can be unplugged
-	 * in a different order than they were detected.  If we're ever going
-	 * to overflow MAXIMUM_NUM_ADAPTERS we'll have to consider using a
-	 * bintmap of free aac_devices slots.
-	 */
-#if 0
-	aac_count--;
-#endif
+	list_del(&aac->entry);
 }
 
 static struct pci_driver aac_pci_driver = {

-- 
Mark Haverkamp <markh@osdl.org>

