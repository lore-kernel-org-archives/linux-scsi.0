From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 11/11] aacraid: Driver version update
Date: Mon, 27 Mar 2006 09:44:37 -0800
Message-ID: <1143481477.21975.46.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:50111 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751027AbWC0Rok (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 12:44:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

Fix module param
Update driver version.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.


--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2006-03-22 12:45:07.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2006-03-24 09:08:52.000000000 -0800
@@ -148,20 +148,20 @@
 
 static int commit = -1;
 
-module_param(nondasd, int, 0);
+module_param(nondasd, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(nondasd, "Control scanning of hba for nondasd devices. 0=off, 1=on");
-module_param(dacmode, int, 0);
+module_param(dacmode, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(dacmode, "Control whether dma addressing is using 64 bit DAC. 0=off, 1=on");
-module_param(commit, int, 0);
+module_param(commit, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(commit, "Control whether a COMMIT_CONFIG is issued to the adapter for foreign arrays.\nThis is typically needed in systems that do not have a BIOS. 0=off, 1=on");
 
 int numacb = -1;
 module_param(numacb, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(numacb, "Request a limit to the number of adapter control blocks (FIB) allocated. Valid\nvalues are 512 and down. Default is to use suggestion from Firmware.");
+MODULE_PARM_DESC(numacb, "Request a limit to the number of adapter control blocks (FIB) allocated. Valid values are 512 and down. Default is to use suggestion from Firmware.");
 
 int acbsize = -1;
 module_param(acbsize, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(acbsize, "Request a specific adapter control block (FIB) size. Valid values are 512,\n2048, 4096 and 8192. Default is to use suggestion from Firmware.");
+MODULE_PARM_DESC(acbsize, "Request a specific adapter control block (FIB) size. Valid values are 512, 2048, 4096 and 8192. Default is to use suggestion from Firmware.");
 /**
  *	aac_get_config_status	-	check the adapter configuration
  *	@common: adapter to query
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-03-22 12:47:49.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-03-24 09:08:52.000000000 -0800
@@ -10,6 +10,10 @@
  *              D E F I N E S
  *----------------------------------------------------------------------------*/
 
+#ifndef AAC_DRIVER_BUILD
+# define AAC_DRIVER_BUILD 2409
+# define AAC_DRIVER_BRANCH "-mh1"
+#endif
 #define MAXIMUM_NUM_CONTAINERS	32
 
 #define AAC_NUM_MGT_FIB         8
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-03-23 13:36:33.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-03-24 10:38:34.000000000 -0800
@@ -27,12 +27,6 @@
  * Abstract: Linux Driver entry module for Adaptec RAID Array Controller
  */
 
-#define AAC_DRIVER_VERSION		"1.1-4"
-#ifndef AAC_DRIVER_BRANCH
-#define AAC_DRIVER_BRANCH		""
-#endif
-#define AAC_DRIVER_BUILD_DATE		__DATE__ " " __TIME__
-#define AAC_DRIVERNAME			"aacraid"
 
 #include <linux/compat.h>
 #include <linux/blkdev.h>
@@ -61,6 +55,13 @@
 
 #include "aacraid.h"
 
+#define AAC_DRIVER_VERSION		"1.1-5"
+#ifndef AAC_DRIVER_BRANCH
+#define AAC_DRIVER_BRANCH		""
+#endif
+#define AAC_DRIVER_BUILD_DATE		__DATE__ " " __TIME__
+#define AAC_DRIVERNAME			"aacraid"
+
 #ifdef AAC_DRIVER_BUILD
 #define _str(x) #x
 #define str(x) _str(x)

-- 
Mark Haverkamp <markh@osdl.org>

