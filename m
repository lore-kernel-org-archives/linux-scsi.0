From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid: driver version updates
Date: Wed, 22 Jun 2005 13:43:11 -0700
Message-ID: <1119472992.18698.34.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:23749 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262234AbVFVUnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2005 16:43:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>


Received from Mark Salyzyn from Adaptec.

Fixes a bug in check_revision.  It should return the driver version not
the firmware version.  
Update driver version number.
Update driver version string.

Applies to scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

 aacraid.h  |    8 +++++---
 commctrl.c |   16 +++++++++++++---
 linit.c    |   21 ++++++++++++++++-----

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1488,11 +1488,12 @@ struct fib_ioctl
 
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
@@ -1713,3 +1714,4 @@ int aac_get_adapter_info(struct aac_dev*
 int aac_send_shutdown(struct aac_dev *dev);
 extern int numacb;
 extern int acbsize;
+extern char aac_driver_version[];
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -405,10 +405,20 @@ static int close_getadapter_fib(struct a
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
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
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
@@ -873,8 +884,8 @@ static int __init aac_init(void)
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

