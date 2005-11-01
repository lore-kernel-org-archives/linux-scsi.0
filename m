From: brking@us.ibm.com
Subject: [PATCH 13/26] ipr: Runtime debugging options
Date: Tue, 01 Nov 2005 17:01:34 -0600
Message-ID: <200511012301.jA1N1Y2X015090@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33261 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751409AbVKAXBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:01:36 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N1Zhp030283
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:35 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N1Z5c108710
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:35 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N1ZDd015113
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:01:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Make some compile time debugging options runtime module options.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ipr.c |    3 +++
 drivers/scsi/ipr.h |   30 +++---------------------------
 2 files changed, 6 insertions(+), 27 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_debug_options drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_debug_options	2005-10-15 17:36:31.593065040 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-10-15 17:37:24.007096896 -0500
@@ -92,6 +92,7 @@ static int ipr_testmode = 0;
 static unsigned int ipr_fastfail = 0;
 static unsigned int ipr_transop_timeout = IPR_OPERATIONAL_TIMEOUT;
 static unsigned int ipr_enable_cache = 1;
+static unsigned int ipr_debug = 0;
 static DEFINE_SPINLOCK(ipr_driver_lock);
 
 /* This table describes the differences between DMA controller chips */
@@ -153,6 +154,8 @@ module_param_named(transop_timeout, ipr_
 MODULE_PARM_DESC(transop_timeout, "Time in seconds to wait for adapter to come operational (default: 300)");
 module_param_named(enable_cache, ipr_enable_cache, int, 0);
 MODULE_PARM_DESC(enable_cache, "Enable adapter's non-volatile write cache (default: 1)");
+module_param_named(debug, ipr_debug, int, 0);
+MODULE_PARM_DESC(debug, "Enable device driver debugging logging. Set to 1 to enable. (default: 0)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IPR_DRIVER_VERSION);
 
diff -puN drivers/scsi/ipr.h~ipr_debug_options drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_debug_options	2005-10-15 17:36:31.595064736 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-10-15 17:36:31.658055160 -0500
@@ -40,21 +40,6 @@
 #define IPR_DRIVER_DATE "(May 2, 2005)"
 
 /*
- * IPR_DBG_TRACE: Setting this to 1 will turn on some general function tracing
- *			resulting in a bunch of extra debugging printks to the console
- *
- * IPR_DEBUG:	Setting this to 1 will turn on some error path tracing.
- *			Enables the ipr_trace macro.
- */
-#ifdef IPR_DEBUG_ALL
-#define IPR_DEBUG				1
-#define IPR_DBG_TRACE			1
-#else
-#define IPR_DEBUG				0
-#define IPR_DBG_TRACE			0
-#endif
-
-/*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
  *	ops per device for devices not running tagged command queuing.
  *	This can be adjusted at runtime through sysfs device attributes.
@@ -1090,11 +1075,7 @@ struct ipr_ucode_image_header {
 /*
  * Macros
  */
-#if IPR_DEBUG
-#define IPR_DBG_CMD(CMD) do { CMD; } while (0)
-#else
-#define IPR_DBG_CMD(CMD)
-#endif
+#define IPR_DBG_CMD(CMD) if (ipr_debug) { CMD; }
 
 #ifdef CONFIG_SCSI_IPR_TRACE
 #define ipr_create_trace_file(kobj, attr) sysfs_create_bin_file(kobj, attr)
@@ -1157,13 +1138,8 @@ struct ipr_ucode_image_header {
 #define ipr_trace ipr_dbg("%s: %s: Line: %d\n",\
 	__FILE__, __FUNCTION__, __LINE__)
 
-#if IPR_DBG_TRACE
-#define ENTER printk(KERN_INFO IPR_NAME": Entering %s\n", __FUNCTION__)
-#define LEAVE printk(KERN_INFO IPR_NAME": Leaving %s\n", __FUNCTION__)
-#else
-#define ENTER
-#define LEAVE
-#endif
+#define ENTER IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Entering %s\n", __FUNCTION__))
+#define LEAVE IPR_DBG_CMD(printk(KERN_INFO IPR_NAME": Leaving %s\n", __FUNCTION__))
 
 #define ipr_err_separator \
 ipr_err("----------------------------------------------------------\n")
_
