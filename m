From: "Patrick Monnerat" <Patrick.Monnerat@datasphere.ch>
Subject: [PATCH 1/1] Create megaraid ioctl device node
Date: Mon, 6 May 2013 15:58:31 +0200
Message-ID: <AB5E58B87EB73C46A38073D8F459F113D9FBA4@dataspheresrv01>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Patrick Monnerat <pm@datasphere.ch>

  Create ioctl device node for megaraid_sas driver. Let this node be
managed by udev. Fix a typo.

Reported-by: pm@datasphere.ch
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Patrick Monnerat <pm@datasphere.ch>
---
diff -uprN
linux-3.8.11-200.1pm.fc18.x86_64.orig/drivers/scsi/megaraid/megaraid_sas
_base.c
linux-3.8.11-200.1pm.fc18.x86_64.new/drivers/scsi/megaraid/megaraid_sas_
base.c
---
linux-3.8.11-200.1pm.fc18.x86_64.orig/drivers/scsi/megaraid/megaraid_sas
_base.c	2013-02-19 00:58:34.000000000 +0100
+++
linux-3.8.11-200.1pm.fc18.x86_64.new/drivers/scsi/megaraid/megaraid_sas_
base.c	2013-05-06 13:39:27.903234426 +0200
@@ -49,6 +49,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
+#include <linux/device.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -127,6 +128,8 @@ static struct pci_device_id megasas_pci_
 
 MODULE_DEVICE_TABLE(pci, megasas_pci_table);
 
+static struct class *megasas_mgmt_class;
+static struct device *megasas_mgmt_device;
 static int megasas_mgmt_majorno;
 static struct megasas_mgmt_info megasas_mgmt_info;
 static struct fasync_struct *megasas_async_queue;
@@ -5450,7 +5453,7 @@ static int __init megasas_init(void)
 	rval = pci_register_driver(&megasas_pci_driver);
 
 	if (rval) {
-		printk(KERN_DEBUG "megasas: PCI hotplug regisration
failed \n");
+		printk(KERN_DEBUG "megasas: PCI hotplug registration
failed\n");
 		goto err_pcidrv;
 	}
 
@@ -5477,8 +5480,28 @@ static int __init megasas_init(void)
 	if (rval)
 		goto err_dcf_support_device_change;
 
-	return rval;
+	/*
+	 * Register as an udev-controlled device.
+	 */
+	megasas_mgmt_class = class_create(THIS_MODULE, "megaraid");
+	rval = PTR_ERR(megasas_mgmt_class);
+	if (IS_ERR(megasas_mgmt_class))
+		goto err_class;
+
+	megasas_mgmt_device = device_create(megasas_mgmt_class, NULL,
+					    MKDEV(megasas_mgmt_majorno,
0),
+					    NULL, "megaraid_sas_ioctl");
+	rval = PTR_ERR(megasas_mgmt_device);
+	if (IS_ERR(megasas_mgmt_device))
+		goto err_create_device;
 
+	return 0;
+
+err_create_device:
+	class_destroy(megasas_mgmt_class);
+err_class:
+	driver_remove_file(&megasas_pci_driver.driver,
+			   &driver_attr_support_device_change);
 err_dcf_support_device_change:
 	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_dbg_lvl);
@@ -5504,6 +5527,9 @@ err_pcidrv:
  */
 static void __exit megasas_exit(void)
 {
+	device_destroy(megasas_mgmt_class, MKDEV(megasas_mgmt_majorno,
0));
+	class_destroy(megasas_mgmt_class);
+
 	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_dbg_lvl);
 	driver_remove_file(&megasas_pci_driver.driver,
