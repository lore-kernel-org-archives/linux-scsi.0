From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: [PATCH] drivers: scsi: megaraid: Add "megaraid_sas_internal.h" for
 internal shared functions using
Date: Sun, 09 Nov 2014 18:16:58 +0800
Message-ID: <545F3F1A.5030902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:48778 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaKIKRE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2014 05:17:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com, "JBottomley@parallels.com" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

For shared inline functions acrossed source files, better to let it as
"static inline" in a header file. For extern functions, better to
declare them in header file.

For the latest upstream gcc/binutiles (gcc 5 with ld 2.25.51), it will
cause building break (although it might be the gcc's or ld's issue), the
related error (with allmodconfig under tile):

    MODPOST 4002 modules
  ERROR: "megasas_return_cmd" [drivers/scsi/megaraid/megaraid_sas.ko] undefined!
  ERROR: "megasas_is_ldio" [drivers/scsi/megaraid/megaraid_sas.ko] undefined!


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c     |  65 +----------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c   |  38 +---------
 drivers/scsi/megaraid/megaraid_sas_internal.h | 100 ++++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 101 deletions(-)
 create mode 100644 drivers/scsi/megaraid/megaraid_sas_internal.h

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f6a69a3..4a71c04 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -57,6 +57,7 @@
 #include <scsi/scsi_tcq.h>
 #include "megaraid_sas_fusion.h"
 #include "megaraid_sas.h"
+#include "megaraid_sas_internal.h"
 
 /*
  * Number of sectors per IO command
@@ -98,7 +99,6 @@ MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
 MODULE_DESCRIPTION("LSI MegaRAID SAS Driver");
 
-int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
 static int megasas_get_pd_list(struct megasas_instance *instance);
 static int megasas_ld_list_query(struct megasas_instance *instance,
 				 u8 query_type);
@@ -155,9 +155,6 @@ static u32 support_device_change;
 /* define lock for aen poll */
 spinlock_t poll_aen_lock;
 
-void
-megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
-		     u8 alt_status);
 static u32
 megasas_read_fw_status_reg_gen2(struct megasas_register_set __iomem *regs);
 static int
@@ -170,26 +167,8 @@ u32
 megasas_build_and_issue_cmd(struct megasas_instance *instance,
 			    struct scsi_cmnd *scmd);
 static void megasas_complete_cmd_dpc(unsigned long instance_addr);
-void
-megasas_release_fusion(struct megasas_instance *instance);
-int
-megasas_ioc_init_fusion(struct megasas_instance *instance);
-void
-megasas_free_cmds_fusion(struct megasas_instance *instance);
-u8
-megasas_get_map_info(struct megasas_instance *instance);
-int
-megasas_sync_map_info(struct megasas_instance *instance);
-int
-wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
-	int seconds);
-void megasas_reset_reply_desc(struct megasas_instance *instance);
-int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout);
-void megasas_fusion_ocr_wq(struct work_struct *work);
 static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
 					 int initial);
-int megasas_check_mpio_paths(struct megasas_instance *instance,
-			     struct scsi_cmnd *scmd);
 
 void
 megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
@@ -258,22 +237,6 @@ __megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 }
 
 /**
- * megasas_return_cmd -	Return a cmd to free command pool
- * @instance:		Adapter soft state
- * @cmd:		Command packet to be returned to free command pool
- */
-inline void
-megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&instance->mfi_pool_lock, flags);
-	__megasas_return_cmd(instance, cmd);
-	spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
-}
-
-
-/**
 *	The following functions are defined for xscale
 *	(deviceid : 1064R, PERC5) controllers
 */
@@ -1417,32 +1380,6 @@ megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	return cmd->frame_count;
 }
 
-/**
- * megasas_is_ldio -		Checks if the cmd is for logical drive
- * @scmd:			SCSI command
- *
- * Called by megasas_queue_command to find out if the command to be queued
- * is a logical drive command
- */
-inline int megasas_is_ldio(struct scsi_cmnd *cmd)
-{
-	if (!MEGASAS_IS_LOGICAL(cmd))
-		return 0;
-	switch (cmd->cmnd[0]) {
-	case READ_10:
-	case WRITE_10:
-	case READ_12:
-	case WRITE_12:
-	case READ_6:
-	case WRITE_6:
-	case READ_16:
-	case WRITE_16:
-		return 1;
-	default:
-		return 0;
-	}
-}
-
  /**
  * megasas_dump_pending_frames -	Dumps the frame address of all pending cmds
  *                              	in FW
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f37eed6..c2b8782 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -54,43 +54,7 @@
 
 #include "megaraid_sas_fusion.h"
 #include "megaraid_sas.h"
-
-extern void megasas_free_cmds(struct megasas_instance *instance);
-extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
-					   *instance);
-extern void
-megasas_complete_cmd(struct megasas_instance *instance,
-		     struct megasas_cmd *cmd, u8 alt_status);
-int megasas_is_ldio(struct scsi_cmnd *cmd);
-int
-wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
-	      int seconds);
-
-void
-megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd);
-int megasas_alloc_cmds(struct megasas_instance *instance);
-int
-megasas_clear_intr_fusion(struct megasas_register_set __iomem *regs);
-int
-megasas_issue_polled(struct megasas_instance *instance,
-		     struct megasas_cmd *cmd);
-void
-megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
-
-int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
-void megaraid_sas_kill_hba(struct megasas_instance *instance);
-
-extern u32 megasas_dbg_lvl;
-void megasas_sriov_heartbeat_handler(unsigned long instance_addr);
-int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
-				  int initial);
-void megasas_start_timer(struct megasas_instance *instance,
-			struct timer_list *timer,
-			 void *fn, unsigned long interval);
-extern struct megasas_mgmt_info megasas_mgmt_info;
-extern int resetwaittime;
-
-
+#include "megaraid_sas_internal.h"
 
 /**
  * megasas_enable_intr_fusion -	Enables interrupts
diff --git a/drivers/scsi/megaraid/megaraid_sas_internal.h b/drivers/scsi/megaraid/megaraid_sas_internal.h
new file mode 100644
index 0000000..b2b0a55
--- /dev/null
+++ b/drivers/scsi/megaraid/megaraid_sas_internal.h
@@ -0,0 +1,100 @@
+#ifndef LSI_MEGARAID_SAS_INTERNAL_H
+#define LSI_MEGARAID_SAS_INTERNAL_H
+
+/*
+ * From base.
+ */
+
+extern void megasas_free_cmds(struct megasas_instance *instance);
+extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
+					   *instance);
+
+extern void
+megasas_complete_cmd(struct megasas_instance *instance,
+		     struct megasas_cmd *cmd, u8 alt_status);
+/**
+ * megasas_is_ldio -		Checks if the cmd is for logical drive
+ * @scmd:			SCSI command
+ *
+ * Called by megasas_queue_command to find out if the command to be queued
+ * is a logical drive command
+ */
+static inline int megasas_is_ldio(struct scsi_cmnd *cmd)
+{
+	if (!MEGASAS_IS_LOGICAL(cmd))
+		return 0;
+	switch (cmd->cmnd[0]) {
+	case READ_10:
+	case WRITE_10:
+	case READ_12:
+	case WRITE_12:
+	case READ_6:
+	case WRITE_6:
+	case READ_16:
+	case WRITE_16:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+/**
+ * megasas_return_cmd -	Return a cmd to free command pool
+ * @instance:		Adapter soft state
+ * @cmd:		Command packet to be returned to free command pool
+ */
+static inline void
+megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&instance->mfi_pool_lock, flags);
+	__megasas_return_cmd(instance, cmd);
+	spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
+}
+
+int megasas_alloc_cmds(struct megasas_instance *instance);
+
+int
+megasas_issue_polled(struct megasas_instance *instance,
+		     struct megasas_cmd *cmd);
+void
+megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
+
+int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
+void megaraid_sas_kill_hba(struct megasas_instance *instance);
+
+extern u32 megasas_dbg_lvl;
+void megasas_sriov_heartbeat_handler(unsigned long instance_addr);
+int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
+				  int initial);
+void megasas_start_timer(struct megasas_instance *instance,
+			struct timer_list *timer,
+			 void *fn, unsigned long interval);
+extern struct megasas_mgmt_info megasas_mgmt_info;
+extern int resetwaittime;
+
+/*
+ * From fusion.
+ */
+
+int megasas_check_mpio_paths(struct megasas_instance *instance,
+			     struct scsi_cmnd *scmd);
+int
+wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
+	      int seconds);
+void
+megasas_release_fusion(struct megasas_instance *instance);
+int
+megasas_ioc_init_fusion(struct megasas_instance *instance);
+void
+megasas_free_cmds_fusion(struct megasas_instance *instance);
+u8
+megasas_get_map_info(struct megasas_instance *instance);
+int
+megasas_sync_map_info(struct megasas_instance *instance);
+void megasas_reset_reply_desc(struct megasas_instance *instance);
+int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout);
+void megasas_fusion_ocr_wq(struct work_struct *work);
+
+#endif /* LSI_MEGARAID_SAS_INTERNAL_H */
-- 
1.9.3
