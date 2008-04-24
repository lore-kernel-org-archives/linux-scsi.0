From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: [PATCH 2/2] dpt_i2o: 64 bit support (take 3)
Date: Thu, 24 Apr 2008 17:08:15 +0200
Message-ID: <20080424150811.GA21457@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1522 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYDXPIU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 11:08:20 -0400
Received: from n2o.xs4all.nl (n2o.xs4all.nl [194.109.0.112])
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id m3OF8IIc019036
	for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2008 17:08:19 +0200 (CEST)
	(envelope-from miquels@cistron.nl)
Received: from mikevs by n2o.xs4all.nl with local (Exim 4.67)
	(envelope-from <miquels@cistron.nl>)
	id 1Jp33X-0005aF-EQ
	for linux-scsi@vger.kernel.org; Thu, 24 Apr 2008 17:08:15 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-Scsi <linux-scsi@vger.kernel.org>

As requested, patch split in two. Part 1 is the 64 bit stuff,
part 2 is the sysfs stuff.

This patch is an update for drivers/scsi/dpt_i2o.c.
It applies to both 2.6.24.4 and 2.6.25

It contains the following changes:

* 64 bit code based on unofficial Adaptec 64 bit driver
* removes scsi_module.c dependency, adds module_init / module_exit
  this is needed because we need to pass the proper device to
  scsi_add_host(), and the scsi_module.c passes NULL. With NULL,
  code like arch/x64/kernel/pci-gart_64.c::need_iommu() crashes
  because the dev pointer it is passed is NULL.
* adds sysfs entry for /sys/class/dpt_i2o/dptiX so that udev
  can create /dev/dptiX dynamically

Obviously there are more cleanups that can be done to this code,
but we need to start somewhere. Patch has been tested heavily on
both 32 and 64 bit x86 platforms.

Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>

diff -ruN linux-2.6.25/drivers/scsi/dpt_i2o.c linux-2.6.25-sysfs/drivers/scsi/dpt_i2o.c
--- linux-2.6.25/drivers/scsi/dpt_i2o.c	2008-04-24 16:48:38.000000000 +0200
+++ linux-2.6.25-sysfs/drivers/scsi/dpt_i2o.c	2008-04-19 21:04:44.000000000 +0200
@@ -116,6 +116,8 @@
 static adpt_hba* hba_chain = NULL;
 static int hba_count = 0;
 
+static struct class *adpt_sysfs_class;
+
 #ifdef CONFIG_COMPAT
 static long compat_adpt_ioctl(struct file *, unsigned int, unsigned long);
 #endif
@@ -268,6 +270,10 @@
 		adpt_inquiry(pHba);
 	}
 
+	adpt_sysfs_class = class_create(THIS_MODULE, "dpt_i2o");
+	if (IS_ERR(adpt_sysfs_class))
+		adpt_sysfs_class = NULL;
+
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
 		if (adpt_scsi_host_alloc(pHba, sht) < 0){
 			adpt_i2o_delete_hba(pHba);
@@ -275,6 +281,11 @@
 		}
 		pHba->initialized = TRUE;
 		pHba->state &= ~DPTI_STATE_RESET;
+		if (adpt_sysfs_class) {
+			class_device_create(adpt_sysfs_class,
+				NULL, MKDEV(DPTI_I2O_MAJOR, pHba->unit),
+				NULL, "dpti%d", pHba->unit);
+		}
 	}
 
 	// Register our control device node
@@ -1250,8 +1261,17 @@
 	pci_dev_put(pHba->pDev);
 	kfree(pHba);
 
-	if(hba_count <= 0)
+	if (adpt_sysfs_class)
+		class_device_destroy(adpt_sysfs_class,
+				MKDEV(DPTI_I2O_MAJOR, pHba->unit));
+
+	if(hba_count <= 0){
 		unregister_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER);   
+		if (adpt_sysfs_class) {
+			class_destroy(adpt_sysfs_class);
+			adpt_sysfs_class = NULL;
+		}
+	}
 }
 
 static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u32 lun)
