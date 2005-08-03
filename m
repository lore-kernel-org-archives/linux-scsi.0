From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2/7] aacraid: driver version update
Date: Wed, 03 Aug 2005 15:38:55 -0700
Message-ID: <1123108735.24945.36.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:31202 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261512AbVHCWi7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2005 18:38:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>


Received from Mark Salyzyn from Adaptec.

Fixes a bug in check_revision.  It should return the driver version not
the firmware version.  
Update driver version number.
Update driver version string.

Applies to scsi-misc-2.6 git tree

Signed-off-by: Mark Haverkamp <markh@osdl.org>

Index: scsi-misc-aac-1/drivers/scsi/aacraid/aacraid.h
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/aacraid.h	2005-07-01 11:43:00.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/aacraid.h	2005-07-01 11:49:36.000000000 -0700
@@ -1512,11 +1512,12 @@
 
 struct revision
 {
-	u32 compat;
-	u32 version;
-	u32 build;
+	__le32 compat;
+	__le32 version;
+	__le32 build;
 };
 	
+
 /*
  * 	Ugly - non Linux like ioctl coding for back compat.
  */
@@ -1737,3 +1738,4 @@
 int aac_send_shutdown(struct aac_dev *dev);
 extern int numacb;
 extern int acbsize;
+extern char aac_driver_version[];
Index: scsi-misc-aac-1/drivers/scsi/aacraid/commctrl.c
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/commctrl.c	2005-07-01 11:43:00.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/commctrl.c	2005-07-01 11:49:36.000000000 -0700
@@ -405,10 +405,20 @@
 static int check_revision(struct aac_dev *dev, void __user *arg)
 {
 	struct revision response;
+	char *driver_version = aac_driver_version;
+	u32 version;
 
-	response.compat = 1;
-	response.version = le32_to_cpu(dev->adapter_info.kernelrev);
-	response.build = le32_to_cpu(dev->adapter_info.kernelbuild);
+	response.compat = cpu_to_le32(1);
+	version = (simple_strtol(driver_version, 
+				&driver_version, 10) << 24) | 0x00000400;
+	version += simple_strtol(driver_version + 1, &driver_version, 10) << 16;
+	version += simple_strtol(driver_version + 1, NULL, 10);
+	response.version = cpu_to_le32(version);
+#	if (defined(AAC_DRIVER_BUILD))
+		response.build = cpu_to_le32(AAC_DRIVER_BUILD);
+#	else
+		response.build = cpu_to_le32(9999);
+#	endif
 
 	if (copy_to_user(arg, &response, sizeof(response)))
 		return -EFAULT;
Index: scsi-misc-aac-1/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/linit.c	2005-07-01 11:43:01.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/linit.c	2005-07-01 11:49:36.000000000 -0700
@@ -27,8 +27,11 @@
  * Abstract: Linux Driver entry module for Adaptec RAID Array Controller
  */
 
-#define AAC_DRIVER_VERSION		"1.1.2-lk2"
-#define AAC_DRIVER_BUILD_DATE		__DATE__
+#define AAC_DRIVER_VERSION		"1.1-4"
+#ifndef AAC_DRIVER_BRANCH
+#define AAC_DRIVER_BRANCH		""
+#endif
+#define AAC_DRIVER_BUILD_DATE		__DATE__ " " __TIME__
 #define AAC_DRIVERNAME			"aacraid"
 
 #include <linux/compat.h>
@@ -58,16 +61,24 @@
 
 #include "aacraid.h"
 
+#ifdef AAC_DRIVER_BUILD
+#define _str(x) #x
+#define str(x) _str(x)
+#define AAC_DRIVER_FULL_VERSION	AAC_DRIVER_VERSION "[" str(AAC_DRIVER_BUILD) "]" AAC_DRIVER_BRANCH
+#else
+#define AAC_DRIVER_FULL_VERSION	AAC_DRIVER_VERSION AAC_DRIVER_BRANCH " " AAC_DRIVER_BUILD_DATE
+#endif
 
 MODULE_AUTHOR("Red Hat Inc and Adaptec");
 MODULE_DESCRIPTION("Dell PERC2, 2/Si, 3/Si, 3/Di, "
 		   "Adaptec Advanced Raid Products, "
 		   "and HP NetRAID-4M SCSI driver");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(AAC_DRIVER_VERSION);
+MODULE_VERSION(AAC_DRIVER_FULL_VERSION);
 
 static LIST_HEAD(aac_devices);
 static int aac_cfg_major = -1;
+char aac_driver_version[] = AAC_DRIVER_FULL_VERSION;
 
 /*
  * Because of the way Linux names scsi devices, the order in this table has
@@ -896,8 +907,8 @@
 {
 	int error;
 	
-	printk(KERN_INFO "Red Hat/Adaptec aacraid driver (%s %s)\n",
-			AAC_DRIVER_VERSION, AAC_DRIVER_BUILD_DATE);
+	printk(KERN_INFO "Adaptec %s driver (%s)\n",
+	  AAC_DRIVERNAME, aac_driver_version);
 
 	error = pci_module_init(&aac_pci_driver);
 	if (error)

-- 
Mark Haverkamp <markh@osdl.org>

