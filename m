From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 9/13] qla2xxx: Add support for extended error logging.
Date: Fri, 23 Jun 2006 16:11:10 -0700
Message-ID: <11511042651454-git-send-email-andrew.vasquez@qlogic.com>
References: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:10161 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1752163AbWFWXLM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:11:12 -0400
In-Reply-To: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Similar in form to QLogic's standard offering -- via
the 'extended_error_logging' module parameter.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.h  |   50 +++++----------------------------------
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    2 ++
 drivers/scsi/qla2xxx/qla_os.c   |   12 +++++++--
 4 files changed, 19 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 2cea009..5334253 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -38,11 +38,7 @@ #endif
 * Macros use for debugging the driver.
 */
 
-#if  DEBUG_QLA2100
-#define DEBUG(x)	do {x;} while (0)
-#else
-#define DEBUG(x)	do {} while (0)
-#endif
+#define DEBUG(x)	do { if (extended_error_logging) { x; } } while (0)
 
 #if defined(QL_DEBUG_LEVEL_1)
 #define DEBUG1(x)	do {x;} while (0)
@@ -50,27 +46,18 @@ #else
 #define DEBUG1(x)	do {} while (0)
 #endif
 
-#if defined(QL_DEBUG_LEVEL_2)
-#define DEBUG2(x)       do {x;} while (0)
-#define DEBUG2_3(x)     do {x;} while (0)
-#define DEBUG2_3_11(x)  do {x;} while (0)
-#define DEBUG2_9_10(x)    do {x;} while (0)
-#define DEBUG2_11(x)    do {x;} while (0)
-#define DEBUG2_13(x)    do {x;} while (0)
-#else
-#define DEBUG2(x)	do {} while (0)
-#endif
+#define DEBUG2(x)	do { if (extended_error_logging) { x; } } while (0)
+#define DEBUG2_3(x)	do { if (extended_error_logging) { x; } } while (0)
+#define DEBUG2_3_11(x)	do { if (extended_error_logging) { x; } } while (0)
+#define DEBUG2_9_10(x)	do { if (extended_error_logging) { x; } } while (0)
+#define DEBUG2_11(x)	do { if (extended_error_logging) { x; } } while (0)
+#define DEBUG2_13(x)	do { if (extended_error_logging) { x; } } while (0)
 
 #if defined(QL_DEBUG_LEVEL_3)
 #define DEBUG3(x)	do {x;} while (0)
-#define DEBUG2_3(x)	do {x;} while (0)
-#define DEBUG2_3_11(x)	do {x;} while (0)
 #define DEBUG3_11(x)	do {x;} while (0)
 #else
 #define DEBUG3(x)	do {} while (0)
-  #if !defined(QL_DEBUG_LEVEL_2)
-  #define DEBUG2_3(x)	do {} while (0)
-  #endif
 #endif
 
 #if defined(QL_DEBUG_LEVEL_4)
@@ -94,20 +81,15 @@ #endif
 #if defined(QL_DEBUG_LEVEL_9)
 #define DEBUG9(x)       do {x;} while (0)
 #define DEBUG9_10(x)    do {x;} while (0)
-#define DEBUG2_9_10(x)	do {x;} while (0)
 #else
 #define DEBUG9(x)	do {} while (0)
 #endif
 
 #if defined(QL_DEBUG_LEVEL_10)
 #define DEBUG10(x)      do {x;} while (0)
-#define DEBUG2_9_10(x)	do {x;} while (0)
 #define DEBUG9_10(x)	do {x;} while (0)
 #else
 #define DEBUG10(x)	do {} while (0)
-  #if !defined(DEBUG2_9_10)
-  #define DEBUG2_9_10(x)	do {} while (0)
-  #endif
   #if !defined(DEBUG9_10)
   #define DEBUG9_10(x)	do {} while (0)
   #endif
@@ -115,23 +97,11 @@ #endif
 
 #if defined(QL_DEBUG_LEVEL_11)
 #define DEBUG11(x)      do{x;} while(0)
-#if !defined(DEBUG2_11)
-#define DEBUG2_11(x)    do{x;} while(0)
-#endif
-#if !defined(DEBUG2_3_11)
-#define DEBUG2_3_11(x)  do{x;} while(0)
-#endif
 #if !defined(DEBUG3_11)
 #define DEBUG3_11(x)    do{x;} while(0)
 #endif
 #else
 #define DEBUG11(x)	do{} while(0)
-  #if !defined(QL_DEBUG_LEVEL_2)
-  #define DEBUG2_11(x)	do{} while(0)
-    #if !defined(QL_DEBUG_LEVEL_3)
-    #define DEBUG2_3_11(x) do{} while(0)
-    #endif
-  #endif
   #if !defined(QL_DEBUG_LEVEL_3)
   #define DEBUG3_11(x)	do{} while(0)
   #endif
@@ -145,14 +115,8 @@ #endif
 
 #if defined(QL_DEBUG_LEVEL_13)
 #define DEBUG13(x)      do {x;} while (0)
-#if !defined(DEBUG2_13)
-#define DEBUG2_13(x)    do {x;} while(0)
-#endif
 #else
 #define DEBUG13(x)	do {} while (0)
-#if !defined(QL_DEBUG_LEVEL_2)
-#define DEBUG2_13(x)	do {} while(0)
-#endif
 #endif
 
 #if defined(QL_DEBUG_LEVEL_14)
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 9ff3298..750aef1 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -64,6 +64,7 @@ extern int ql2xplogiabsentdevice;
 extern int ql2xloginretrycount;
 extern int ql2xfdmienable;
 extern int ql2xallocfwdump;
+extern int extended_error_logging;
 
 extern void qla2x00_sp_compl(scsi_qla_host_t *, srb_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 101cf12..761dd1f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1642,6 +1642,8 @@ #endif
 	/*
 	 * Set host adapter parameters.
 	 */
+	if (nv->host_p[0] & BIT_7)
+		extended_error_logging = 1;
 	ha->flags.disable_risc_code_load = ((nv->host_p[0] & BIT_4) ? 1 : 0);
 	/* Always load RISC code on non ISP2[12]00 chips. */
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha))
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fedf2f1..a15b609 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -61,6 +61,12 @@ MODULE_PARM_DESC(ql2xallocfwdump,
 		"during HBA initialization.  Memory allocation requirements "
 		"vary by ISP type.  Default is 1 - allocate memory.");
 
+int extended_error_logging;
+module_param(extended_error_logging, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(extended_error_logging,
+		"Option to enable extended error logging, "
+		"Default is 0 - no logging. 1 - log errors.");
+
 static void qla2x00_free_device(scsi_qla_host_t *);
 
 static void qla2x00_config_dma_addressing(scsi_qla_host_t *ha);
@@ -2691,9 +2697,9 @@ qla2x00_module_init(void)
 
 	/* Derive version string. */
 	strcpy(qla2x00_version_str, QLA2XXX_VERSION);
-#if DEBUG_QLA2100
-	strcat(qla2x00_version_str, "-debug");
-#endif
+	if (extended_error_logging)
+		strcat(qla2x00_version_str, "-debug");
+
 	qla2xxx_transport_template =
 	    fc_attach_transport(&qla2xxx_transport_functions);
 	if (!qla2xxx_transport_template)
-- 
1.4.1.rc1.gf603


