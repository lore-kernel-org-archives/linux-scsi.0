From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6.9 aacraid: aac_count fix
Date: Tue, 14 Sep 2004 13:12:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095192761.25727.7.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:54463 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S269766AbUINUMp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 16:12:45 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

>From Mark Salyzyn at Adaptec:

This patch permits hot add and removal with backfilling; and ensures
that if no cards are discovered, the driver fails the insmod and that we
can in fact handle the maximum number of aac based adapters (32) in a
hot add and remove situation.

Applies to latest scsi-misc bk tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/linit.c 1.38 vs edited =====
--- 1.38/drivers/scsi/aacraid/linit.c	2004-08-24 08:49:49 -07:00
+++ edited/drivers/scsi/aacraid/linit.c	2004-09-14 10:32:41 -07:00
@@ -519,6 +519,12 @@
 	struct aac_dev *aac;
 	int container;
 	int error = -ENODEV;
+	int unique_id = 0;
+
+	for (; (unique_id < aac_count) && aac_devices[unique_id]; ++unique_id)
+		continue;
+	if (unique_id >= MAXIMUM_NUM_ADAPTERS)
+		goto out;
 
 	if (pci_enable_device(pdev))
 		goto out;
@@ -538,7 +544,8 @@
 	pci_set_master(pdev);
 
 	/* Increment the host adapter count */
-	aac_count++;
+	if (unique_id >= aac_count)
+		aac_count = unique_id + 1;
 
 	shost = scsi_host_alloc(&aac_driver_template, sizeof(struct aac_dev));
 	if (!shost)
@@ -546,7 +553,8 @@
 
 	shost->irq = pdev->irq;
 	shost->base = pci_resource_start(pdev, 0);
-	shost->unique_id = aac_count - 1;
+	scsi_set_device(shost, &pdev->dev);
+	shost->unique_id = unique_id;
 
 	aac = (struct aac_dev *)shost->hostdata;
 	aac->scsi_host_ptr = shost;	
@@ -591,7 +599,7 @@
 
 	aac_get_config_status(aac);
 	aac_get_containers(aac);
-	aac_devices[aac_count-1] = aac;
+	aac_devices[unique_id] = aac;
 
 	/*
 	 * dmb - we may need to move the setting of these parms somewhere else once
@@ -625,7 +633,9 @@
 	scsi_host_put(shost);
  out_disable_pdev:
 	pci_disable_device(pdev);
-	aac_count--;
+	aac_devices[unique_id] = NULL;
+	if (unique_id == (aac_count - 1))
+		aac_count--;
  out:
 	return error;
 }
@@ -634,6 +644,7 @@
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
+	int index;
 
 	scsi_remove_host(shost);
 
@@ -654,15 +665,15 @@
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
+	for (index = 0; index < aac_count; ++index) {
+		if (aac_devices[index] == aac) {
+			aac_devices[index] = NULL;
+			if (index == (aac_count - 1))
+				--aac_count;
+			break;
+		}
+	}
+
 }
 
 static struct pci_driver aac_pci_driver = {
@@ -682,6 +693,8 @@
 	error = pci_module_init(&aac_pci_driver);
 	if (error)
 		return error;
+	if (!aac_count)
+		return -ENODEV;
 
 	aac_cfg_major = register_chrdev( 0, "aac", &aac_cfg_fops);
 	if (aac_cfg_major < 0) {

-- 
Mark Haverkamp <markh@osdl.org>

