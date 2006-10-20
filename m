From: akpm@osdl.org
Subject: [patch 33/45] Maintain module-parameter name consistency with qla2xxx/qla4xxx
Date: Fri, 20 Oct 2006 14:48:31 -0700
Message-ID: <200610202148.k9KLmVVm004174@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:6023 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992863AbWJTVtH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:49:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, andrew.vasquez@qlogic.com

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

The recently added the iSCSI qla4xxx driver contains a global (non-static)
variable that clashes with a pre-existing variable present in qla2xxx.

Commit d7a297baa6edea94167163bed808c6a8933bd5aa added a 'qla2_' and 'qla4_'
prefix to the offending variable name.  Replace the 'qla2_/qla4_' prefixes
with 'ql2x/ql4x' to maintain consistency with other module-parameters.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/qla2xxx/qla_dbg.h  |   14 +++++++-------
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +-
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_os.c   |    8 ++++----
 drivers/scsi/qla4xxx/ql4_dbg.h  |    4 ++--
 drivers/scsi/qla4xxx/ql4_glbl.h |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c  |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c   |    8 ++++----
 8 files changed, 21 insertions(+), 21 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_dbg.h~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx drivers/scsi/qla2xxx/qla_dbg.h
--- a/drivers/scsi/qla2xxx/qla_dbg.h~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx
+++ a/drivers/scsi/qla2xxx/qla_dbg.h
@@ -38,7 +38,7 @@
 * Macros use for debugging the driver.
 */
 
-#define DEBUG(x)	do { if (qla2_extended_error_logging) { x; } } while (0)
+#define DEBUG(x)	do { if (ql2xextended_error_logging) { x; } } while (0)
 
 #if defined(QL_DEBUG_LEVEL_1)
 #define DEBUG1(x)	do {x;} while (0)
@@ -46,12 +46,12 @@
 #define DEBUG1(x)	do {} while (0)
 #endif
 
-#define DEBUG2(x)	do { if (qla2_extended_error_logging) { x; } } while (0)
-#define DEBUG2_3(x)	do { if (qla2_extended_error_logging) { x; } } while (0)
-#define DEBUG2_3_11(x)	do { if (qla2_extended_error_logging) { x; } } while (0)
-#define DEBUG2_9_10(x)	do { if (qla2_extended_error_logging) { x; } } while (0)
-#define DEBUG2_11(x)	do { if (qla2_extended_error_logging) { x; } } while (0)
-#define DEBUG2_13(x)	do { if (qla2_extended_error_logging) { x; } } while (0)
+#define DEBUG2(x)	do { if (ql2xextended_error_logging) { x; } } while (0)
+#define DEBUG2_3(x)	do { if (ql2xextended_error_logging) { x; } } while (0)
+#define DEBUG2_3_11(x)	do { if (ql2xextended_error_logging) { x; } } while (0)
+#define DEBUG2_9_10(x)	do { if (ql2xextended_error_logging) { x; } } while (0)
+#define DEBUG2_11(x)	do { if (ql2xextended_error_logging) { x; } } while (0)
+#define DEBUG2_13(x)	do { if (ql2xextended_error_logging) { x; } } while (0)
 
 #if defined(QL_DEBUG_LEVEL_3)
 #define DEBUG3(x)	do {x;} while (0)
diff -puN drivers/scsi/qla2xxx/qla_gbl.h~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx
+++ a/drivers/scsi/qla2xxx/qla_gbl.h
@@ -60,7 +60,7 @@ extern int ql2xplogiabsentdevice;
 extern int ql2xloginretrycount;
 extern int ql2xfdmienable;
 extern int ql2xallocfwdump;
-extern int qla2_extended_error_logging;
+extern int ql2xextended_error_logging;
 
 extern void qla2x00_sp_compl(scsi_qla_host_t *, srb_t *);
 
diff -puN drivers/scsi/qla2xxx/qla_init.c~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx
+++ a/drivers/scsi/qla2xxx/qla_init.c
@@ -1644,7 +1644,7 @@ qla2x00_nvram_config(scsi_qla_host_t *ha
 	 * Set host adapter parameters.
 	 */
 	if (nv->host_p[0] & BIT_7)
-		qla2_extended_error_logging = 1;
+		ql2xextended_error_logging = 1;
 	ha->flags.disable_risc_code_load = ((nv->host_p[0] & BIT_4) ? 1 : 0);
 	/* Always load RISC code on non ISP2[12]00 chips. */
 	if (!IS_QLA2100(ha) && !IS_QLA2200(ha))
diff -puN drivers/scsi/qla2xxx/qla_os.c~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx
+++ a/drivers/scsi/qla2xxx/qla_os.c
@@ -61,9 +61,9 @@ MODULE_PARM_DESC(ql2xallocfwdump,
 		"during HBA initialization.  Memory allocation requirements "
 		"vary by ISP type.  Default is 1 - allocate memory.");
 
-int qla2_extended_error_logging;
-module_param(qla2_extended_error_logging, int, S_IRUGO|S_IRUSR);
-MODULE_PARM_DESC(qla2_extended_error_logging,
+int ql2xextended_error_logging;
+module_param(ql2xextended_error_logging, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xextended_error_logging,
 		"Option to enable extended error logging, "
 		"Default is 0 - no logging. 1 - log errors.");
 
@@ -2697,7 +2697,7 @@ qla2x00_module_init(void)
 
 	/* Derive version string. */
 	strcpy(qla2x00_version_str, QLA2XXX_VERSION);
-	if (qla2_extended_error_logging)
+	if (ql2xextended_error_logging)
 		strcat(qla2x00_version_str, "-debug");
 
 	qla2xxx_transport_template =
diff -puN drivers/scsi/qla4xxx/ql4_dbg.h~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx drivers/scsi/qla4xxx/ql4_dbg.h
--- a/drivers/scsi/qla4xxx/ql4_dbg.h~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx
+++ a/drivers/scsi/qla4xxx/ql4_dbg.h
@@ -22,14 +22,14 @@
 #endif
 
 #if defined(QL_DEBUG_LEVEL_2)
-#define DEBUG2(x)      do {if(qla4_extended_error_logging == 2) x;} while (0);
+#define DEBUG2(x)      do {if(ql4xextended_error_logging == 2) x;} while (0);
 #define DEBUG2_3(x)   do {x;} while (0);
 #else				/*  */
 #define DEBUG2(x)	do {} while (0);
 #endif				/*  */
 
 #if defined(QL_DEBUG_LEVEL_3)
-#define DEBUG3(x)      do {if(qla4_extended_error_logging == 3) x;} while (0);
+#define DEBUG3(x)      do {if(ql4xextended_error_logging == 3) x;} while (0);
 #else				/*  */
 #define DEBUG3(x)	do {} while (0);
 #if !defined(QL_DEBUG_LEVEL_2)
diff -puN drivers/scsi/qla4xxx/ql4_glbl.h~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx drivers/scsi/qla4xxx/ql4_glbl.h
--- a/drivers/scsi/qla4xxx/ql4_glbl.h~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx
+++ a/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -72,7 +72,7 @@ int qla4xxx_reinitialize_ddb_list(struct
 int qla4xxx_process_ddb_changed(struct scsi_qla_host * ha,
 				uint32_t fw_ddb_index, uint32_t state);
 
-extern int qla4_extended_error_logging;
+extern int ql4xextended_error_logging;
 extern int ql4xdiscoverywait;
 extern int ql4xdontresethba;
 #endif				/* _QLA4x_GBL_H */
diff -puN drivers/scsi/qla4xxx/ql4_mbx.c~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx drivers/scsi/qla4xxx/ql4_mbx.c
--- a/drivers/scsi/qla4xxx/ql4_mbx.c~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx
+++ a/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -701,7 +701,7 @@ void qla4xxx_get_conn_event_log(struct s
 	DEBUG3(printk("scsi%ld: Connection Event Log Dump (%d entries):\n",
 		      ha->host_no, num_valid_entries));
 
-	if (qla4_extended_error_logging == 3) {
+	if (ql4xextended_error_logging == 3) {
 		if (oldest_entry == 0) {
 			/* Circular Buffer has not wrapped around */
 			for (i=0; i < num_valid_entries; i++) {
diff -puN drivers/scsi/qla4xxx/ql4_os.c~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx drivers/scsi/qla4xxx/ql4_os.c
--- a/drivers/scsi/qla4xxx/ql4_os.c~maintain-module-parameter-name-consistency-with-qla2xxx-qla4xxx
+++ a/drivers/scsi/qla4xxx/ql4_os.c
@@ -34,9 +34,9 @@ MODULE_PARM_DESC(ql4xdontresethba,
 		 " default it will reset hba :0"
 		 " set to 1 to avoid resetting HBA");
 
-int qla4_extended_error_logging = 0; /* 0 = off, 1 = log errors */
-module_param(qla4_extended_error_logging, int, S_IRUGO | S_IRUSR);
-MODULE_PARM_DESC(qla4_extended_error_logging,
+int ql4xextended_error_logging = 0; /* 0 = off, 1 = log errors */
+module_param(ql4xextended_error_logging, int, S_IRUGO | S_IRUSR);
+MODULE_PARM_DESC(ql4xextended_error_logging,
 		 "Option to enable extended error logging, "
 		 "Default is 0 - no logging, 1 - debug logging");
 
@@ -1714,7 +1714,7 @@ static int __init qla4xxx_module_init(vo
 
 	/* Derive version string. */
 	strcpy(qla4xxx_version_str, QLA4XXX_DRIVER_VERSION);
-	if (qla4_extended_error_logging)
+	if (ql4xextended_error_logging)
 		strcat(qla4xxx_version_str, "-debug");
 
 	qla4xxx_scsi_transport =
_
