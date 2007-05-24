From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH 2/8] qla4xxx: Resubmission: ql4_def.h log all AENs and
	cleanup
Date: Wed, 23 May 2007 17:50:55 -0700
Message-ID: <1179967855.16099.2.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4238 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbXEXAv6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 20:51:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Somayajulu <david.somayajulu@qlogic.com>, David Wagner <david.wagner@qlogic.com>

Add support for logging all AENs and clean up

Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

 drivers/scsi/qla4xxx/ql4_def.h |   78 ++++++++++++++++++++--------------------
 1 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 6f4cf2d..accaf69 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -122,8 +122,7 @@ #define MAX_REQS_SERVICED_PER_INTR	16
 
 #define ISCSI_IPADDR_SIZE		4	/* IP address size */
 #define ISCSI_ALIAS_SIZE		32	/* ISCSI Alais name size */
-#define ISCSI_NAME_SIZE			255	/* ISCSI Name size -
-						 * usually a string */
+#define ISCSI_NAME_SIZE			0xE0	/* ISCSI Name size */
 
 #define LSDW(x) ((u32)((u64)(x)))
 #define MSDW(x) ((u32)((((u64)(x)) >> 16) >> 16))
@@ -187,9 +186,21 @@ #define SRB_ERR_OTHER	   4
 	u_long u_start;		/* Time when we handed the cmd to F/W */
 };
 
-	/*
-	 * Device Database (DDB) structure
-	 */
+/*
+ * Asynchronous Event Queue structure
+ */
+struct aen {
+        uint32_t mbox_sts[MBOX_AEN_REG_COUNT];
+};
+
+struct ql4_aen_log {
+        int count;
+        struct aen entry[MAX_AEN_ENTRIES];
+};
+
+/*
+ * Device Database (DDB) structure
+ */
 struct ddb_entry {
 	struct list_head list;	/* ddb list */
 	struct scsi_qla_host *ha;
@@ -254,13 +265,6 @@ #define DF_NO_RELOGIN		1	/* Do not relog
 #define DF_ISNS_DISCOVERED	2	/* Device was discovered via iSNS */
 #define DF_FO_MASKED		3
 
-/*
- * Asynchronous Event Queue structure
- */
-struct aen {
-	uint32_t mbox_sts[MBOX_AEN_REG_COUNT];
-};
-
 
 #include "ql4_fw.h"
 #include "ql4_nvram.h"
@@ -270,31 +274,31 @@ #include "ql4_nvram.h"
  */
 struct scsi_qla_host {
 	/* Linux adapter configuration data */
-	struct Scsi_Host *host; /* pointer to host data */
-	uint32_t tot_ddbs;
 	unsigned long flags;
 
-#define AF_ONLINE		      0 /* 0x00000001 */
-#define AF_INIT_DONE		      1 /* 0x00000002 */
-#define AF_MBOX_COMMAND		      2 /* 0x00000004 */
-#define AF_MBOX_COMMAND_DONE	      3 /* 0x00000008 */
-#define AF_INTERRUPTS_ON	      6 /* 0x00000040 Not Used */
-#define AF_GET_CRASH_RECORD	      7 /* 0x00000080 */
-#define AF_LINK_UP		      8 /* 0x00000100 */
-#define AF_IRQ_ATTACHED		     10 /* 0x00000400 */
-#define AF_ISNS_CMD_IN_PROCESS	     12 /* 0x00001000 */
-#define AF_ISNS_CMD_DONE	     13 /* 0x00002000 */
+#define AF_ONLINE			0 /* 0x00000001 */
+#define AF_INIT_DONE			1 /* 0x00000002 */
+#define AF_MBOX_COMMAND			2 /* 0x00000004 */
+#define AF_MBOX_COMMAND_DONE		3 /* 0x00000008 */
+#define AF_INTERRUPTS_ON		6 /* 0x00000040 */
+#define AF_GET_CRASH_RECORD		7 /* 0x00000080 */
+#define AF_LINK_UP			8 /* 0x00000100 */
+#define AF_IRQ_ATTACHED			10 /* 0x00000400 */
+#define AF_DISABLE_ACB_COMPLETE		11 /* 0x00000800 */
 
 	unsigned long dpc_flags;
 
-#define DPC_RESET_HA		      1 /* 0x00000002 */
-#define DPC_RETRY_RESET_HA	      2 /* 0x00000004 */
-#define DPC_RELOGIN_DEVICE	      3 /* 0x00000008 */
-#define DPC_RESET_HA_DESTROY_DDB_LIST 4 /* 0x00000010 */
-#define DPC_RESET_HA_INTR	      5 /* 0x00000020 */
-#define DPC_ISNS_RESTART	      7 /* 0x00000080 */
-#define DPC_AEN			      9 /* 0x00000200 */
-#define DPC_GET_DHCP_IP_ADDR	     15 /* 0x00008000 */
+#define DPC_RESET_HA			1 /* 0x00000002 */
+#define DPC_RETRY_RESET_HA		2 /* 0x00000004 */
+#define DPC_RELOGIN_DEVICE		3 /* 0x00000008 */
+#define DPC_RESET_HA_DESTROY_DDB_LIST	4 /* 0x00000010 */
+#define DPC_RESET_HA_INTR		5 /* 0x00000020 */
+#define DPC_ISNS_RESTART		7 /* 0x00000080 */
+#define DPC_AEN				9 /* 0x00000200 */
+#define DPC_GET_DHCP_IP_ADDR		15 /* 0x00008000 */
+
+	struct Scsi_Host *host; /* pointer to host data */
+	uint32_t tot_ddbs;
 
 	uint16_t	iocb_cnt;
 	uint16_t	iocb_hiwat;
@@ -344,6 +348,7 @@ #define MIN_IOBASE_LEN		0x100
 	uint32_t firmware_version[2];
 	uint32_t patch_number;
 	uint32_t build_number;
+	uint32_t board_id;
 
 	/* --- From Init_FW --- */
 	/* init_cb_t *init_cb; */
@@ -363,7 +368,6 @@ #define MIN_IOBASE_LEN		0x100
 
 	/* --- From GetFwState --- */
 	uint32_t firmware_state;
-	uint32_t board_id;
 	uint32_t addl_fw_state;
 
 	/* Linux kernel thread */
@@ -414,6 +418,8 @@ #define MEM_ALIGN_VALUE \
 	uint16_t aen_out;
 	struct aen aen_q[MAX_AEN_ENTRIES];
 
+	struct ql4_aen_log aen_log;/* tracks all aens */
+
 	/* This mutex protects several threads to do mailbox commands
 	 * concurrently.
 	 */
@@ -585,10 +591,4 @@ #define PROCESS_ALL_AENS	 0
 #define FLUSH_DDB_CHANGED_AENS	 1
 #define RELOGIN_DDB_CHANGED_AENS 2
 
-#include "ql4_version.h"
-#include "ql4_glbl.h"
-#include "ql4_dbg.h"
-#include "ql4_inline.h"
-
-
 #endif	/*_QLA4XXX_H */

