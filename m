From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH v3 01/10] libfcoe: move logging macros into the local
	libfcoe.h header file
Date: Wed, 12 Jan 2011 18:19:43 -0800
Message-ID: <20110113021938.12798.23948.stg.yi.zou@intel.com>
References: <20110113021649.12798.71742.stg.yi.zou@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35145 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361Ab1AMCWi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2011 21:22:38 -0500
In-Reply-To: <20110113021649.12798.71742.stg.yi.zou@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: bprakash@broadcom.com, linux-scsi@vger.kernel.org

libfcoe kernel module debug macros will used by the fcoe transport code
as well when later it gets added.

Signed-off-by: Yi Zou <yi.zou@intel.com>
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

