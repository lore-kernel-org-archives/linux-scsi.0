From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 2/5] libfcoe: Add fcoe_sysfs debug logging level
Date: Wed, 26 Sep 2012 19:01:53 -0700
Message-ID: <20120927020153.20592.10023.stgit@fritz>
References: <20120927020142.20592.56661.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24181 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab2I0CBz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2012 22:01:55 -0400
In-Reply-To: <20120927020142.20592.56661.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, bvanassche@acm.org, bprakash@broadcom.com
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

Add a macro to print fcoe_sysfs debug statements.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_sysfs.c |    7 +++++++
 drivers/scsi/fcoe/libfcoe.h    |   11 ++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 2bc1631..f207bbd 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -24,6 +24,13 @@
 
 #include <scsi/fcoe_sysfs.h>
 
+/*
+ * OK to include local libfcoe.h for debug_logging, but cannot include
+ * <scsi/libfcoe.h> otherwise non-netdev based fcoe solutions would have
+ * have to include more than fcoe_sysfs.h.
+ */
+#include "libfcoe.h"
+
 static atomic_t ctlr_num;
 static atomic_t fcf_num;
 
diff --git a/drivers/scsi/fcoe/libfcoe.h b/drivers/scsi/fcoe/libfcoe.h
index 3a758c2..d3bb16d 100644
--- a/drivers/scsi/fcoe/libfcoe.h
+++ b/drivers/scsi/fcoe/libfcoe.h
@@ -2,9 +2,10 @@
 #define _FCOE_LIBFCOE_H_
 
 extern unsigned int libfcoe_debug_logging;
-#define LIBFCOE_LOGGING	    0x01 /* General logging, not categorized */
-#define LIBFCOE_FIP_LOGGING 0x02 /* FIP logging */
-#define LIBFCOE_TRANSPORT_LOGGING	0x04 /* FCoE transport logging */
+#define LIBFCOE_LOGGING	          0x01 /* General logging, not categorized */
+#define LIBFCOE_FIP_LOGGING       0x02 /* FIP logging */
+#define LIBFCOE_TRANSPORT_LOGGING 0x04 /* FCoE transport logging */
+#define LIBFCOE_SYSFS_LOGGING     0x08 /* fcoe_sysfs logging */
 
 #define LIBFCOE_CHECK_LOGGING(LEVEL, CMD)		\
 do {							\
@@ -27,4 +28,8 @@ do {							\
 	LIBFCOE_CHECK_LOGGING(LIBFCOE_TRANSPORT_LOGGING,		\
 			      pr_info("%s: " fmt, __func__, ##args);)
 
+#define LIBFCOE_SYSFS_DBG(cdev, fmt, args...)				\
+	LIBFCOE_CHECK_LOGGING(LIBFCOE_SYSFS_LOGGING,			\
+			      pr_info("ctlr_%d: " fmt, cdev->id, ##args);)
+
 #endif /* _FCOE_LIBFCOE_H_ */

