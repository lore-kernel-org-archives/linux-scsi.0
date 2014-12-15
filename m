From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH v2] drivers: scsi: megaraid: Add "megaraid_sas_internal.h"
 for internal shared functions using
Date: Mon, 15 Dec 2014 14:22:10 +0530
Message-ID: <57f45bd989345446ad63bf08908eef6e@mail.gmail.com>
References: <548DB542.7000400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <548DB542.7000400@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chen Gang <gang.chen.5i5j@gmail.com>, megaraidlinux@lsi.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>-----Original Message-----
>From: Chen Gang [mailto:gang.chen.5i5j@gmail.com]
>Sent: Sunday, December 14, 2014 9:35 PM
>To: megaraidlinux@lsi.com; JBottomley@parallels.com; Sumit Saxena
>Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: [PATCH v2] drivers: scsi: megaraid: Add "megaraid_sas_internal.h"
>for internal shared functions using
>
>For shared inline functions crossed source files, better to let it as
>"static inline"
>in a header file. For extern functions, better to declare them in header
>file.
>
>Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>---
> drivers/scsi/megaraid/megaraid_sas_base.c     |  76 +----------------
> drivers/scsi/megaraid/megaraid_sas_fusion.c   |  42 +---------
> drivers/scsi/megaraid/megaraid_sas_internal.h | 116
>++++++++++++++++++++++++++
> 3 files changed, 118 insertions(+), 116 deletions(-)  create mode 100644
>drivers/scsi/megaraid/megaraid_sas_internal.h
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index dc27598..474c39b 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -57,6 +57,7 @@
> #include <scsi/scsi_tcq.h>
> #include "megaraid_sas_fusion.h"
> #include "megaraid_sas.h"
>+#include "megaraid_sas_internal.h"
>
> /*
>  * Number of sectors per IO command
>@@ -127,9 +128,6 @@ static u32 support_device_change;
> /* define lock for aen poll */
> spinlock_t poll_aen_lock;
>
>-void
>-megasas_complete_cmd(struct megasas_instance *instance, struct
>megasas_cmd *cmd,
>-		     u8 alt_status);
> static u32
> megasas_read_fw_status_reg_gen2(struct megasas_register_set __iomem
>*regs);  static int @@ -142,23 +140,6 @@ u32
>megasas_build_and_issue_cmd(struct megasas_instance *instance,
> 			    struct scsi_cmnd *scmd);
> static void megasas_complete_cmd_dpc(unsigned long instance_addr); -void
>-megasas_release_fusion(struct megasas_instance *instance); -int -
>megasas_ioc_init_fusion(struct megasas_instance *instance); -void -
>megasas_free_cmds_fusion(struct megasas_instance *instance);
>-u8
>-megasas_get_map_info(struct megasas_instance *instance); -int -
>megasas_sync_map_info(struct megasas_instance *instance); -int -
>wait_and_poll(struct megasas_instance *instance, struct megasas_cmd
>*cmd); -void megasas_reset_reply_desc(struct megasas_instance *instance);
>-u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
>-		      struct LD_LOAD_BALANCE_INFO *lbInfo);
>-int megasas_reset_fusion(struct Scsi_Host *shost); -void
>megasas_fusion_ocr_wq(struct work_struct *work);
>
> void
> megasas_issue_dcmd(struct megasas_instance *instance, struct
>megasas_cmd *cmd) @@ -194,30 +175,6 @@ struct megasas_cmd
>*megasas_get_cmd(struct megasas_instance  }
>
> /**
>- * megasas_return_cmd -	Return a cmd to free command pool
>- * @instance:		Adapter soft state
>- * @cmd:		Command packet to be returned to free command
>pool
>- */
>-inline void
>-megasas_return_cmd(struct megasas_instance *instance, struct
>megasas_cmd *cmd) -{
>-	unsigned long flags;
>-
>-	spin_lock_irqsave(&instance->cmd_pool_lock, flags);
>-
>-	cmd->scmd = NULL;
>-	cmd->frame_count = 0;
>-	if ((instance->pdev->device != PCI_DEVICE_ID_LSI_FUSION) &&
>-	    (instance->pdev->device != PCI_DEVICE_ID_LSI_INVADER) &&
>-	    (reset_devices))
>-		cmd->frame->hdr.cmd = MFI_CMD_INVALID;
>-	list_add_tail(&cmd->list, &instance->cmd_pool);
>-
>-	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
>-}
>-
>-
>-/**
> *	The following functions are defined for xscale
> *	(deviceid : 1064R, PERC5) controllers
> */
>@@ -830,11 +787,6 @@ static struct megasas_instance_template
>megasas_instance_template_gen2 = {
> *       specific to gen2 (deviceid : 0x78, 0x79) controllers
> */
>
>-/*
>- * Template added for TB (Fusion)
>- */
>-extern struct megasas_instance_template
>megasas_instance_template_fusion;
>-
> /**
>  * megasas_issue_polled -	Issues a polling command
>  * @instance:			Adapter soft state
>@@ -1311,32 +1263,6 @@ megasas_build_ldio(struct megasas_instance
>*instance, struct scsi_cmnd *scp,  }
>
> /**
>- * megasas_is_ldio -		Checks if the cmd is for logical drive
>- * @scmd:			SCSI command
>- *
>- * Called by megasas_queue_command to find out if the command to be
>queued
>- * is a logical drive command
>- */
>-inline int megasas_is_ldio(struct scsi_cmnd *cmd) -{
>-	if (!MEGASAS_IS_LOGICAL(cmd))
>-		return 0;
>-	switch (cmd->cmnd[0]) {
>-	case READ_10:
>-	case WRITE_10:
>-	case READ_12:
>-	case WRITE_12:
>-	case READ_6:
>-	case WRITE_6:
>-	case READ_16:
>-	case WRITE_16:
>-		return 1;
>-	default:
>-		return 0;
>-	}
>-}
>-
>- /**
>  * megasas_dump_pending_frames -	Dumps the frame address of all
>pending cmds
>  *                              	in FW
>  * @instance:				Adapter soft state
>diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>index a610cf1..7760ad2 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>@@ -53,47 +53,7 @@
>
> #include "megaraid_sas_fusion.h"
> #include "megaraid_sas.h"
>-
>-extern void megasas_free_cmds(struct megasas_instance *instance); -
>extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
>-					   *instance);
>-extern void
>-megasas_complete_cmd(struct megasas_instance *instance,
>-		     struct megasas_cmd *cmd, u8 alt_status);
>-int megasas_is_ldio(struct scsi_cmnd *cmd); -int -wait_and_poll(struct
>megasas_instance *instance, struct megasas_cmd *cmd);
>-
>-void
>-megasas_return_cmd(struct megasas_instance *instance, struct
>megasas_cmd *cmd); -int megasas_alloc_cmds(struct megasas_instance
>*instance); -int -megasas_clear_intr_fusion(struct megasas_register_set
>__iomem *regs); -int -megasas_issue_polled(struct megasas_instance
>*instance,
>-		     struct megasas_cmd *cmd);
>-
>-u8
>-MR_BuildRaidContext(struct megasas_instance *instance,
>-		    struct IO_REQUEST_INFO *io_info,
>-		    struct RAID_CONTEXT *pRAID_Context,
>-		    struct MR_FW_RAID_MAP_ALL *map);
>-u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL
>*map); -struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct
>MR_FW_RAID_MAP_ALL *map);
>-
>-u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
>-
>-void
>-megasas_check_and_restore_queue_depth(struct megasas_instance
>*instance);
>-
>-u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
>-		      struct LD_LOAD_BALANCE_INFO *lbInfo);
>-u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
>-			   struct IO_REQUEST_INFO *in_info);
>-int megasas_transition_to_ready(struct megasas_instance *instance, int
>ocr); -void megaraid_sas_kill_hba(struct megasas_instance *instance);
>-
>-extern u32 megasas_dbg_lvl;
>+#include "megaraid_sas_internal.h"
>
> /**
>  * megasas_enable_intr_fusion -	Enables interrupts
>diff --git a/drivers/scsi/megaraid/megaraid_sas_internal.h
>b/drivers/scsi/megaraid/megaraid_sas_internal.h
>new file mode 100644
>index 0000000..b780f82
>--- /dev/null
>+++ b/drivers/scsi/megaraid/megaraid_sas_internal.h
>@@ -0,0 +1,116 @@
>+#ifndef LSI_MEGARAID_SAS_INTERNAL_H
>+#define LSI_MEGARAID_SAS_INTERNAL_H
>+
>+/***
>+ * From base.
>+ */
>+
>+extern void megasas_free_cmds(struct megasas_instance *instance);
>+extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
>+					   *instance);
>+extern void
>+megasas_complete_cmd(struct megasas_instance *instance,
>+		     struct megasas_cmd *cmd, u8 alt_status);
>+
>+/**
>+ * megasas_is_ldio -		Checks if the cmd is for logical drive
>+ * @scmd:			SCSI command
>+ *
>+ * Called by megasas_queue_command to find out if the command to be
>+queued
>+ * is a logical drive command
>+ */
>+static inline int megasas_is_ldio(struct scsi_cmnd *cmd) {
>+	if (!MEGASAS_IS_LOGICAL(cmd))
>+		return 0;
>+	switch (cmd->cmnd[0]) {
>+	case READ_10:
>+	case WRITE_10:
>+	case READ_12:
>+	case WRITE_12:
>+	case READ_6:
>+	case WRITE_6:
>+	case READ_16:
>+	case WRITE_16:
>+		return 1;
>+	default:
>+		return 0;
>+	}
>+}
>+
>+/**
>+ * megasas_return_cmd -	Return a cmd to free command pool
>+ * @instance:		Adapter soft state
>+ * @cmd:		Command packet to be returned to free command
>pool
>+ */
>+static inline void
>+megasas_return_cmd(struct megasas_instance *instance, struct
>+megasas_cmd *cmd) {
>+	unsigned long flags;
>+
>+	spin_lock_irqsave(&instance->cmd_pool_lock, flags);
>+
>+	cmd->scmd = NULL;
>+	cmd->frame_count = 0;
>+	if ((instance->pdev->device != PCI_DEVICE_ID_LSI_FUSION) &&
>+	    (instance->pdev->device != PCI_DEVICE_ID_LSI_INVADER) &&
>+	    (reset_devices))
>+		cmd->frame->hdr.cmd = MFI_CMD_INVALID;
>+	list_add_tail(&cmd->list, &instance->cmd_pool);
>+
>+	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags); }
>+
>+extern int megasas_alloc_cmds(struct megasas_instance *instance);
>+
>+extern int
>+megasas_issue_polled(struct megasas_instance *instance,
>+		     struct megasas_cmd *cmd);
>+extern void
>+megasas_check_and_restore_queue_depth(struct megasas_instance
>+*instance);
>+
>+extern int megasas_transition_to_ready(struct megasas_instance *instance,
>+				       int ocr);
>+extern void megaraid_sas_kill_hba(struct megasas_instance *instance);
>+
>+extern u32 megasas_dbg_lvl;
>+
>+/***
>+ * From fusion.
>+ */
>+
>+extern int
>+wait_and_poll(struct megasas_instance *instance, struct megasas_cmd
>+*cmd); extern void megasas_release_fusion(struct megasas_instance
>+*instance); extern int megasas_ioc_init_fusion(struct megasas_instance
>+*instance); extern void megasas_free_cmds_fusion(struct
>+megasas_instance *instance); extern u8 megasas_get_map_info(struct
>+megasas_instance *instance); extern int megasas_sync_map_info(struct
>+megasas_instance *instance); extern void
>+megasas_reset_reply_desc(struct megasas_instance *instance); extern int
>+megasas_reset_fusion(struct Scsi_Host *shost); extern void
>+megasas_fusion_ocr_wq(struct work_struct *work);
>+/*
>+ * Template added for TB (Fusion)
>+ */
>+extern struct megasas_instance_template
>+megasas_instance_template_fusion;
>+
>+
>+/***
>+ * From fp.
>+ */
>+
>+extern struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct
>+MR_FW_RAID_MAP_ALL *map); extern u16 MR_GetLDTgtId(u32 ld, struct
>+MR_FW_RAID_MAP_ALL *map); extern u16 MR_TargetIdToLdGet(u32
>ldTgtId,
>+struct MR_FW_RAID_MAP_ALL *map); extern u8
>MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
>+			     struct LD_LOAD_BALANCE_INFO *lbInfo); extern u8
>+MR_BuildRaidContext(struct megasas_instance *instance,
>+		    struct IO_REQUEST_INFO *io_info,
>+		    struct RAID_CONTEXT *pRAID_Context,
>+		    struct MR_FW_RAID_MAP_ALL *map);
>+extern u16
>+get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
>+		       struct IO_REQUEST_INFO *in_info);
>+
>+#endif /* LSI_MEGARAID_SAS_INTERNAL_H */

Acked-by: Sumit Saxena <sumit.saxena@avagotech.com>

>--
>1.9.3
