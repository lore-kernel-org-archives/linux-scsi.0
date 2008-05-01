From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: [PATCH 4/4] dpt_i2o: sysfs code
Date: Fri, 2 May 2008 01:08:19 +0200
Message-ID: <20080501230815.GA19856@xs4all.net>
References: <20080501230211.GA19796@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2503 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbYEAXIV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 19:08:21 -0400
Received: from n2o.xs4all.nl (n2o.xs4all.nl [194.109.0.112])
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id m41N8JkB085742
	for <linux-scsi@vger.kernel.org>; Fri, 2 May 2008 01:08:19 +0200 (CEST)
	(envelope-from miquels@cistron.nl)
Received: from mikevs by n2o.xs4all.nl with local (Exim 4.69)
	(envelope-from <miquels@cistron.nl>)
	id 1Jrhsx-0005AP-6S
	for linux-scsi@vger.kernel.org; Fri, 02 May 2008 01:08:19 +0200
Content-Disposition: inline
In-Reply-To: <20080501230211.GA19796@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[PATCH 4/4] dpt_i2o: sysfs code

Create a /sys/class/dpt_i2o directory and populate it with
dptiN directories. Each dptiN directory contains a "dev" file
that makes udev create /dev/dptiN

Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>

diff -ruN linux-2.6.25-03/drivers/scsi/dpt_i2o.c linux-2.6.25-04/drivers/scsi/dpt_i2o.c
--- linux-2.6.25-03/drivers/scsi/dpt_i2o.c	2008-05-02 00:28:55.000000000 +0200
+++ linux-2.6.25-04/drivers/scsi/dpt_i2o.c	2008-05-02 00:27:12.000000000 +0200
@@ -111,6 +111,8 @@
 static adpt_hba* hba_chain = NULL;
 static int hba_count = 0;
 
+static struct class *adpt_sysfs_class;
+
 #ifdef CONFIG_COMPAT
 static long compat_adpt_ioctl(struct file *, unsigned int, unsigned long);
 #endif
@@ -254,6 +256,12 @@
 		adpt_inquiry(pHba);
 	}
 
+	adpt_sysfs_class = class_create(THIS_MODULE, "dpt_i2o");
+	if (IS_ERR(adpt_sysfs_class)) {
+		printk(KERN_WARNING"dpti: unable to create dpt_i2o class\n");
+		adpt_sysfs_class = NULL;
+	}
+
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
 		if (adpt_scsi_host_alloc(pHba, sht) < 0){
 			adpt_i2o_delete_hba(pHba);
@@ -261,6 +269,16 @@
 		}
 		pHba->initialized = TRUE;
 		pHba->state &= ~DPTI_STATE_RESET;
+		if (adpt_sysfs_class) {
+			struct device *dev = device_create(adpt_sysfs_class,
+				NULL, MKDEV(DPTI_I2O_MAJOR, pHba->unit),
+				"dpti%d", pHba->unit);
+			if (IS_ERR(dev)) {
+				printk(KERN_WARNING"dpti%d: unable to "
+					"create device in dpt_i2o class\n",
+					pHba->unit);
+			}
+		}
 	}
 
 	// Register our control device node
@@ -1212,8 +1230,16 @@
 	pci_dev_put(pHba->pDev);
 	kfree(pHba);
 
+	if (adpt_sysfs_class)
+		device_destroy(adpt_sysfs_class,
+				MKDEV(DPTI_I2O_MAJOR, pHba->unit));
+
 	if(hba_count <= 0){
 		unregister_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER);   
+		if (adpt_sysfs_class) {
+			class_destroy(adpt_sysfs_class);
+			adpt_sysfs_class = NULL;
+		}
 	}
 }
 
