From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of DCDB cmds
	with sense info
Date: Wed, 21 Nov 2007 08:40:56 +0000
Message-ID: <1195634456.5855.9.camel@dhcp-75-884.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53919 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbXKTUgP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 15:36:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, Bo.yang@lsi.com, Sumant.patro@lsi.com, neela.kolli@lsi.com

Sense buffer ptr data type in the ioctl path is reverted back to u32 *
for x86 and x86_64 as in previous versions of driver. For IA64 it will
be unsigned long *. Compile time flag added for ia64 for this.

Signed-off-by: Bo Yang <bo.yang@lsi.com>

---
Documentation/scsi/ChangeLog.megaraid_sas |   15 +++++++++++++++
drivers/scsi/megaraid/megaraid_sas.c      |   14 ++++++++++----
drivers/scsi/megaraid/megaraid_sas.h      |    6 +++---
 3 files changed, 28 insertions(+), 7 deletions(-)

diff -rupN linux-2.6.22_orig/Documentation/scsi/ChangeLog.megaraid_sas linux-2.6.22_new/Documentation/scsi/ChangeLog.megaraid_sas
--- linux-2.6.22_orig/Documentation/scsi/ChangeLog.megaraid_sas	2007-11-20 17:50:13.000000000 -0500
+++ linux-2.6.22_new/Documentation/scsi/ChangeLog.megaraid_sas	2007-11-20 21:37:16.000000000 -0500
@@ -1,3 +1,18 @@
+1 Release Date    : Thur. Nov. 19 16:30:43 PST 2007 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Sumant Patro
+			Bo Yang
+
+2 Current Version : 00.00.03.17-RC1
+3 Older Version   : 00.00.03.16
+
+1. Fix random failure of DCDB cmds with sense info.
+
+Fix: 	sense buffer ptr data type in the ioctl path is reverted back
+	to u32 * for x86, x86_64 as in previous versions of driver.
+	For IA64 it will be unsigned long *. Compile time flag added
+	for ia64 for this.
+
 1 Release Date    : Thur. Nov. 07 16:30:43 PST 2007 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Sumant Patro
diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-11-20 17:50:13.000000000 -0500
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-11-20 17:50:13.000000000 -0500
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_sas.c
- * Version	: v00.00.03.16-rc1
+ * Version	: v00.00.03.17-rc1
  *
  * Authors:
  *	(email-id : megaraidlinux@lsi.com)
@@ -3020,10 +3020,16 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 		 * sense buffer address
 		 */
 		sense_buff = (unsigned long *) ((unsigned long)ioc->frame.raw +
-								ioc->sense_off);
-
-		if (copy_to_user((void __user *)(unsigned long)(*sense_buff),
+					ioc->sense_off);
+		sense_ptr = (u32 *) ((unsigned long)ioc->frame.raw +
+					ioc->sense_off);
+#if defined(__ia64__)
+		if (copy_to_user((void __user *)((unsigned long)(*sense_buff)),
+				sense, ioc->sense_len)) {
+#else
+		if (copy_to_user((void __user *)((unsigned long)(*sense_ptr)),
 				sense, ioc->sense_len)) {
+#endif
 			printk(KERN_ERR "megasas: Failed to copy out to user "
 					"sense data\n");
 			error = -EFAULT;
diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h	2007-11-20 17:50:13.000000000 -0500
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h	2007-11-20 17:50:13.000000000 -0500
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.03.16-rc1"
-#define MEGASAS_RELDATE				"Nov. 07, 2007"
-#define MEGASAS_EXT_VERSION			"Thu. Nov. 07 10:09:32 PDT 2007"
+#define MEGASAS_VERSION				"00.00.03.17-rc1"
+#define MEGASAS_RELDATE				"Nov. 19, 2007"
+#define MEGASAS_EXT_VERSION			"Mon. Nov. 19 10:09:32 PDT 2007"
 
 /*
  * Device IDs

