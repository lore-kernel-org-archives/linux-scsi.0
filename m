From: brking@us.ibm.com
Subject: [PATCH 4/6] ipr: Remove dead code
Date: Tue, 14 Dec 2004 17:10:02 -0600
Message-ID: <200412142310.iBENA3r0003756@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37764 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261754AbULNXKI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Dec 2004 18:10:08 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id iBENA4Sn004153
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:10:04 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBENA4ls279456
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:10:04 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.12.11) with ESMTP id iBENA3Mt003784
	for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2004 18:10:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Removes some unused debug code.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.h |   15 ---------------
 1 files changed, 15 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_remove_dead_code drivers/scsi/ipr.h
--- linux-2.6.10-rc3-bk8/drivers/scsi/ipr.h~ipr_remove_dead_code	2004-12-14 17:06:38.000000000 -0600
+++ linux-2.6.10-rc3-bk8-bjking1/drivers/scsi/ipr.h	2004-12-14 17:06:38.000000000 -0600
@@ -32,9 +32,6 @@
 #include <linux/kref.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
-#ifdef CONFIG_KDB
-#include <linux/kdb.h>
-#endif
 
 /*
  * Literals
@@ -1085,18 +1082,6 @@ struct ipr_ucode_image_header {
 #define IPR_DBG_CMD(CMD)
 #endif
 
-#define ipr_breakpoint_data KERN_ERR IPR_NAME\
-": %s: %s: Line: %d ioa_cfg: %p\n", __FILE__, \
-__FUNCTION__, __LINE__, ioa_cfg
-
-#if defined(CONFIG_KDB) && !defined(CONFIG_PPC_ISERIES)
-#define ipr_breakpoint {printk(ipr_breakpoint_data); KDB_ENTER();}
-#define ipr_breakpoint_or_die {printk(ipr_breakpoint_data); KDB_ENTER();}
-#else
-#define ipr_breakpoint
-#define ipr_breakpoint_or_die panic(ipr_breakpoint_data)
-#endif
-
 #ifdef CONFIG_SCSI_IPR_TRACE
 #define ipr_create_trace_file(kobj, attr) sysfs_create_bin_file(kobj, attr)
 #define ipr_remove_trace_file(kobj, attr) sysfs_remove_bin_file(kobj, attr)
_
