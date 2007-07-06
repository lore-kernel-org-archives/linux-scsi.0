From: Joshua Daniel Franklin <joshuadfranklin@yahoo.com>
Subject: [PATCH] 3w-xxxx: Add tw_sysfs_init() so udev will create /dev/twe* devices.
Date: Fri, 6 Jul 2007 16:11:03 -0700 (PDT)
Message-ID: <589382.9788.qm@web37906.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1994528713-1183763463=:9788"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web37906.mail.mud.yahoo.com ([209.191.91.168]:37508 "HELO
	web37906.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751473AbXGFXRo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jul 2007 19:17:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linuxraid@amcc.com

--0-1994528713-1183763463=:9788
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

Add tw_sysfs_init() to register 3w-xxxx driver with sysfs. This
also causes udev to create /dev/twe* devices with the correct
SELinux security context.

Signed-off-by: Joshua Daniel Franklin <joshuadfranklin@yahoo.com>
---



       
____________________________________________________________________________________
Be a better Heartthrob. Get better relationship answers from someone who knows. Yahoo! Answers - Check it out. 
http://answers.yahoo.com/dir/?link=list&sid=396545433
--0-1994528713-1183763463=:9788
Content-Type: text/x-patch; name="3w-xxxx.patch"
Content-Description: 174087252-3w-xxxx.patch
Content-Disposition: inline; filename="3w-xxxx.patch"

--- 3w-xxxx.c.orig	2007-07-05 13:01:16.000000000 -0700
+++ 3w-xxxx.c	2007-07-06 15:32:08.000000000 -0700
@@ -194,6 +194,7 @@
    1.26.02.002 - Free irq handler in __tw_shutdown().
                  Turn on RCD bit for caching mode page.
                  Serialize reset code.
+   1.26.02.003 - Add tw_sysfs_init() so udev will create /dev/twe* devices.
 */
 
 #include <linux/module.h>
@@ -217,11 +218,13 @@
 #include "3w-xxxx.h"
 
 /* Globals */
-#define TW_DRIVER_VERSION "1.26.02.002"
+#define TW_DRIVER_VERSION "1.26.02.003"
 static TW_Device_Extension *tw_device_extension_list[TW_MAX_SLOT];
 static int tw_device_extension_count = 0;
 static int twe_major = -1;
 
+static struct class *tw_sysfs_class;
+
 /* Module parameters */
 MODULE_AUTHOR("AMCC");
 MODULE_DESCRIPTION("3ware Storage Controller Linux Driver");
@@ -1047,6 +1050,33 @@ static const struct file_operations tw_f
 	.release	= NULL
 };
 
+/* This function will create the twe* sysfs entries */
+static int tw_sysfs_init(void) {
+	int i;
+	struct class_device *tw_class_member;
+
+	twe_major = register_chrdev(0, "twe", &tw_fops);
+	if (twe_major < 0) {
+		printk(KERN_WARNING "3w-xxxx: Failed to register character device.\n");
+		return twe_major;
+	}
+	/* register twe* devices with sysfs */
+	tw_sysfs_class = class_create(THIS_MODULE, "twe");
+	if (IS_ERR(tw_sysfs_class)) {
+		printk(KERN_WARNING "3w-xxxx: Failed to create sysfs class.\n");
+		return PTR_ERR(tw_sysfs_class);
+	}
+
+	for(i = 0; i < TW_MAX_UNITS; i++) {
+		tw_class_member = class_device_create(tw_sysfs_class, NULL, MKDEV(twe_major,i), NULL, "twe%d",i);
+		if (IS_ERR(tw_class_member)) {
+			printk(KERN_WARNING "3w-xxxx: Unable to add sysfs class member twe%d\n", i);
+			return PTR_ERR(tw_class_member);
+		}
+	}
+	return 0;
+} /* End tw_sysfs_init() */
+
 /* This function will free up device extension resources */
 static void tw_free_device_extension(TW_Device_Extension *tw_dev)
 {
@@ -2420,8 +2450,9 @@ static int __devinit tw_probe(struct pci
 	scsi_scan_host(host);
 
 	if (twe_major == -1) {
-		if ((twe_major = register_chrdev (0, "twe", &tw_fops)) < 0)
-			printk(KERN_WARNING "3w-xxxx: Failed to register character device.");
+		if (tw_sysfs_init() < 0) {
+			printk(KERN_WARNING "3w-xxxx: Failed to initialize sysfs for device.");
+		}
 	}
 	return 0;
 
@@ -2449,6 +2480,7 @@ static void tw_remove(struct pci_dev *pd
 	/* Unregister character device */
 	if (twe_major >= 0) {
 		unregister_chrdev(twe_major, "twe");
+		class_destroy(tw_sysfs_class);
 		twe_major = -1;
 	}
 

--0-1994528713-1183763463=:9788--
