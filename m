From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 18/28] libfcoe: move logging macros into the local libfcoe.h
	header file
Date: Fri, 28 Jan 2011 16:04:45 -0800
Message-ID: <20110129000445.1784.69756.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56051 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab1A2AEp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:04:45 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

libfcoe kernel module debug macros will used by the fcoe transport code
as well when later it gets added.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   22 ++--------------------
 drivers/scsi/fcoe/libfcoe.h |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 20 deletions(-)
 create mode 100644 drivers/scsi/fcoe/libfcoe.h

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 625c6be..a4757ca 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -44,6 +44,8 @@
 #include <scsi/libfc.h>
 #include <scsi/libfcoe.h>
 
+#include "libfcoe.h"
+
 MODULE_AUTHOR("Open-FCoE.org");
 MODULE_DESCRIPTION("FIP discovery protocol support for FCoE HBAs");
 MODULE_LICENSE("GPL v2");
@@ -70,26 +72,6 @@ unsigned int libfcoe_debug_logging;
 module_param_named(debug_logging, libfcoe_debug_logging, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
 
-#define LIBFCOE_LOGGING	    0x01 /* General logging, not categorized */
-#define LIBFCOE_FIP_LOGGING 0x02 /* FIP logging */
-
-#define LIBFCOE_CHECK_LOGGING(LEVEL, CMD)		\
-do {							\
-	if (unlikely(libfcoe_debug_logging & LEVEL))	\
-		do {					\
-			CMD;				\
-		} while (0);				\
-} while (0)
-
-#define LIBFCOE_DBG(fmt, args...)					\
-	LIBFCOE_CHECK_LOGGING(LIBFCOE_LOGGING,				\
-			      printk(KERN_INFO "libfcoe: " fmt, ##args);)
-
-#define LIBFCOE_FIP_DBG(fip, fmt, args...)				\
-	LIBFCOE_CHECK_LOGGING(LIBFCOE_FIP_LOGGING,			\
-			      printk(KERN_INFO "host%d: fip: " fmt, 	\
-				     (fip)->lp->host->host_no, ##args);)
-
 static const char *fcoe_ctlr_states[] = {
 	[FIP_ST_DISABLED] =	"DISABLED",
 	[FIP_ST_LINK_WAIT] =	"LINK_WAIT",
diff --git a/drivers/scsi/fcoe/libfcoe.h b/drivers/scsi/fcoe/libfcoe.h
new file mode 100644
index 0000000..c3fe316
--- /dev/null
+++ b/drivers/scsi/fcoe/libfcoe.h
@@ -0,0 +1,25 @@
+#ifndef _FCOE_LIBFCOE_H_
+#define _FCOE_LIBFCOE_H_
+
+extern unsigned int libfcoe_debug_logging;
+#define LIBFCOE_LOGGING	    0x01 /* General logging, not categorized */
+#define LIBFCOE_FIP_LOGGING 0x02 /* FIP logging */
+
+#define LIBFCOE_CHECK_LOGGING(LEVEL, CMD)		\
+do {							\
+	if (unlikely(libfcoe_debug_logging & LEVEL))	\
+		do {					\
+			CMD;				\
+		} while (0);				\
+} while (0)
+
+#define LIBFCOE_DBG(fmt, args...)					\
+	LIBFCOE_CHECK_LOGGING(LIBFCOE_LOGGING,				\
+			      printk(KERN_INFO "libfcoe: " fmt, ##args);)
+
+#define LIBFCOE_FIP_DBG(fip, fmt, args...)				\
+	LIBFCOE_CHECK_LOGGING(LIBFCOE_FIP_LOGGING,			\
+			      printk(KERN_INFO "host%d: fip: " fmt,	\
+				     (fip)->lp->host->host_no, ##args);)
+
+#endif /* _FCOE_LIBFCOE_H_ */

