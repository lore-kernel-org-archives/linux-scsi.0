From: mathieu.poirier@linaro.org
Subject: [PATCH v2] scsi/megaraid: fix sparse warnings
Date: Tue, 15 May 2012 15:29:32 -0600
Message-ID: <1337117372-29187-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: aradford@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, megaraidlinux@lsi.com, JBottomley@parallels.com, arnd@arndb.de, grant.likely@secretlab.ca
List-Id: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

And hiding driver's internal functions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/scsi/megaraid/megaraid_sas.h        |   39 ++++++++++
 drivers/scsi/megaraid/megaraid_sas_base.c   |   46 +++---------
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  105 ++++++++++++++-------------
 drivers/scsi/megaraid/megaraid_sas_fp.h     |   22 ++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   86 ++++++----------------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    9 +++
 6 files changed, 158 insertions(+), 149 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index e5f416f..4768794 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1489,4 +1489,43 @@ struct megasas_mgmt_info {
 #define msi_control_reg(base) (base + PCI_MSI_FLAGS)
 #define PCI_MSIX_FLAGS_ENABLE (1 << 15)
 
+extern u32 megasas_dbg_lvl;
+extern void megasas_free_cmds(struct megasas_instance *instance);
+extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
+					   *instance);
+extern void
+megasas_complete_cmd(struct megasas_instance *instance,
+		     struct megasas_cmd *cmd, u8 alt_status);
+int megasas_is_ldio(struct scsi_cmnd *cmd);
+
+void
+megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd);
+int megasas_alloc_cmds(struct megasas_instance *instance);
+int
+megasas_clear_intr_fusion(struct megasas_register_set __iomem *regs);
+int
+megasas_issue_polled(struct megasas_instance *instance,
+		     struct megasas_cmd *cmd);
+
+void
+megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
+
+int megasas_transition_to_ready(struct megasas_instance *instance);
+void megaraid_sas_kill_hba(struct megasas_instance *instance);
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
+u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
+		      struct LD_LOAD_BALANCE_INFO *lbInfo);
+int megasas_reset_fusion(struct Scsi_Host *shost);
+void megasas_fusion_ocr_wq(struct work_struct *work);
+
 #endif				/*LSI_MEGARAID_SAS_H */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8b300be..0e8386a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -76,7 +76,6 @@ MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
 MODULE_DESCRIPTION("LSI MegaRAID SAS Driver");
 
-int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
 static int megasas_get_pd_list(struct megasas_instance *instance);
 static int megasas_issue_init_mfi(struct megasas_instance *instance);
 static int megasas_register_aen(struct megasas_instance *instance,
@@ -113,6 +112,8 @@ static struct pci_device_id megasas_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, megasas_pci_table);
 
+u32 megasas_dbg_lvl;
+
 static int megasas_mgmt_majorno;
 static struct megasas_mgmt_info megasas_mgmt_info;
 static struct fasync_struct *megasas_async_queue;
@@ -121,15 +122,11 @@ static DEFINE_MUTEX(megasas_async_queue_mutex);
 static int megasas_poll_wait_aen;
 static DECLARE_WAIT_QUEUE_HEAD(megasas_poll_wait);
 static u32 support_poll_for_event;
-u32 megasas_dbg_lvl;
 static u32 support_device_change;
 
 /* define lock for aen poll */
-spinlock_t poll_aen_lock;
+static DEFINE_SPINLOCK(poll_aen_lock);
 
-void
-megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
-		     u8 alt_status);
 static u32
 megasas_read_fw_status_reg_gen2(struct megasas_register_set __iomem *regs);
 static int
@@ -138,29 +135,12 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 static irqreturn_t megasas_isr(int irq, void *devp);
 static u32
 megasas_init_adapter_mfi(struct megasas_instance *instance);
-u32
+static u32
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
-wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd);
-void megasas_reset_reply_desc(struct megasas_instance *instance);
-u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
-		      struct LD_LOAD_BALANCE_INFO *lbInfo);
-int megasas_reset_fusion(struct Scsi_Host *shost);
-void megasas_fusion_ocr_wq(struct work_struct *work);
 
-void
+static void
 megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 {
 	instance->instancet->fire_cmd(instance,
@@ -744,8 +724,8 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 {
 	u32			retry = 0 ;
 	u32			HostDiag;
-	u32			*seq_offset = &reg_set->seq_offset;
-	u32			*hostdiag_offset = &reg_set->host_diag;
+	u32 __iomem		*seq_offset = &reg_set->seq_offset;
+	u32 __iomem		*hostdiag_offset = &reg_set->host_diag;
 
 	if (instance->instancet == &megasas_instance_template_skinny) {
 		seq_offset = &reg_set->fusion_seq_offset;
@@ -830,11 +810,6 @@ static struct megasas_instance_template megasas_instance_template_gen2 = {
 *       specific to gen2 (deviceid : 0x78, 0x79) controllers
 */
 
-/*
- * Template added for TB (Fusion)
- */
-extern struct megasas_instance_template megasas_instance_template_fusion;
-
 /**
  * megasas_issue_polled -	Issues a polling command
  * @instance:			Adapter soft state
@@ -859,7 +834,7 @@ megasas_issue_polled(struct megasas_instance *instance, struct megasas_cmd *cmd)
 	/*
 	 * Wait for cmd_status to change
 	 */
-	return wait_and_poll(instance, cmd);
+	return megaraid_wait_and_poll(instance, cmd);
 }
 
 /**
@@ -1399,7 +1374,7 @@ megasas_dump_pending_frames(struct megasas_instance *instance)
 	printk(KERN_ERR "megasas[%d]: Dumping Done.\n\n",instance->host->host_no);
 }
 
-u32
+static u32
 megasas_build_and_issue_cmd(struct megasas_instance *instance,
 			    struct scsi_cmnd *scmd)
 {
@@ -1673,7 +1648,7 @@ megasas_internal_reset_defer_cmds(struct megasas_instance *instance);
 static void
 process_fw_state_change_wq(struct work_struct *work);
 
-void megasas_do_ocr(struct megasas_instance *instance)
+static void megasas_do_ocr(struct megasas_instance *instance)
 {
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1064R) ||
 	(instance->pdev->device == PCI_DEVICE_ID_DELL_PERC5) ||
@@ -4066,7 +4041,6 @@ megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&instance->cmd_pool_lock);
 	spin_lock_init(&instance->hba_lock);
 	spin_lock_init(&instance->completion_lock);
-	spin_lock_init(&poll_aen_lock);
 
 	mutex_init(&instance->aen_mutex);
 	mutex_init(&instance->reset_mutex);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 294abb0..34a1ebd 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -53,6 +53,8 @@
 
 #include "megaraid_sas_fusion.h"
 #include "megaraid_sas.h"
+#include "megaraid_sas_fp.h"
+
 #include <asm/div64.h>
 
 #define ABS_DIFF(a, b)   (((a) > (b)) ? ((a) - (b)) : ((b) - (a)))
@@ -61,11 +63,11 @@
 #define TRUE 1
 
 /* Prototypes */
-void
+static void
 mr_update_load_balance_params(struct MR_FW_RAID_MAP_ALL *map,
 			      struct LD_LOAD_BALANCE_INFO *lbInfo);
 
-u32 mega_mod64(u64 dividend, u32 divisor)
+static u32 mega_mod64(u64 dividend, u32 divisor)
 {
 	u64 d;
 	u32 remainder;
@@ -83,7 +85,7 @@ u32 mega_mod64(u64 dividend, u32 divisor)
  *
  * @return quotient
  **/
-u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
+static u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
 {
 	u32 remainder;
 	u64 d;
@@ -145,10 +147,54 @@ static struct MR_LD_SPAN *MR_LdSpanPtrGet(u32 ld, u32 span,
 	return &map->raidMap.ldSpanMap[ld].spanBlock[span].span;
 }
 
+static void
+mr_update_load_balance_params(struct MR_FW_RAID_MAP_ALL *map,
+			      struct LD_LOAD_BALANCE_INFO *lbInfo)
+{
+	int ldCount;
+	u16 ld;
+	struct MR_LD_RAID *raid;
+
+	for (ldCount = 0; ldCount < MAX_LOGICAL_DRIVES; ldCount++) {
+		ld = MR_TargetIdToLdGet(ldCount, map);
+		if (ld >= MAX_LOGICAL_DRIVES) {
+			lbInfo[ldCount].loadBalanceFlag = 0;
+			continue;
+		}
+
+		raid = MR_LdRaidGet(ld, map);
+
+		/* Two drive Optimal RAID 1 */
+		if ((raid->level == 1)  &&  (raid->rowSize == 2) &&
+		    (raid->spanDepth == 1) && raid->ldState ==
+		    MR_LD_STATE_OPTIMAL) {
+			u32 pd, arRef;
+
+			lbInfo[ldCount].loadBalanceFlag = 1;
+
+			/* Get the array on which this span is present */
+			arRef = MR_LdSpanArrayGet(ld, 0, map);
+
+			/* Get the Pd */
+			pd = MR_ArPdGet(arRef, 0, map);
+			/* Get dev handle from Pd */
+			lbInfo[ldCount].raid1DevHandle[0] =
+				MR_PdDevHandleGet(pd, map);
+			/* Get the Pd */
+			pd = MR_ArPdGet(arRef, 1, map);
+
+			/* Get the dev handle from Pd */
+			lbInfo[ldCount].raid1DevHandle[1] =
+				MR_PdDevHandleGet(pd, map);
+		} else
+			lbInfo[ldCount].loadBalanceFlag = 0;
+	}
+}
+
 /*
  * This function will validate Map info data provided by FW
  */
-u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
+static u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
 		      struct LD_LOAD_BALANCE_INFO *lbInfo)
 {
 	struct MR_FW_RAID_MAP *pFwRaidMap = &map->raidMap;
@@ -227,7 +273,8 @@ u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
 *    span          - Span number
 *    block         - Absolute Block number in the physical disk
 */
-u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
+static u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld,
+		   u64 stripRow,
 		   u16 stripRef, u64 *pdBlock, u16 *pDevHandle,
 		   struct RAID_CONTEXT *pRAID_Context,
 		   struct MR_FW_RAID_MAP_ALL *map)
@@ -438,52 +485,8 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 	return TRUE;
 }
 
-void
-mr_update_load_balance_params(struct MR_FW_RAID_MAP_ALL *map,
-			      struct LD_LOAD_BALANCE_INFO *lbInfo)
-{
-	int ldCount;
-	u16 ld;
-	struct MR_LD_RAID *raid;
-
-	for (ldCount = 0; ldCount < MAX_LOGICAL_DRIVES; ldCount++) {
-		ld = MR_TargetIdToLdGet(ldCount, map);
-		if (ld >= MAX_LOGICAL_DRIVES) {
-			lbInfo[ldCount].loadBalanceFlag = 0;
-			continue;
-		}
-
-		raid = MR_LdRaidGet(ld, map);
-
-		/* Two drive Optimal RAID 1 */
-		if ((raid->level == 1)  &&  (raid->rowSize == 2) &&
-		    (raid->spanDepth == 1) && raid->ldState ==
-		    MR_LD_STATE_OPTIMAL) {
-			u32 pd, arRef;
-
-			lbInfo[ldCount].loadBalanceFlag = 1;
-
-			/* Get the array on which this span is present */
-			arRef = MR_LdSpanArrayGet(ld, 0, map);
-
-			/* Get the Pd */
-			pd = MR_ArPdGet(arRef, 0, map);
-			/* Get dev handle from Pd */
-			lbInfo[ldCount].raid1DevHandle[0] =
-				MR_PdDevHandleGet(pd, map);
-			/* Get the Pd */
-			pd = MR_ArPdGet(arRef, 1, map);
-
-			/* Get the dev handle from Pd */
-			lbInfo[ldCount].raid1DevHandle[1] =
-				MR_PdDevHandleGet(pd, map);
-		} else
-			lbInfo[ldCount].loadBalanceFlag = 0;
-	}
-}
-
-u8 megasas_get_best_arm(struct LD_LOAD_BALANCE_INFO *lbInfo, u8 arm, u64 block,
-			u32 count)
+static u8 megasas_get_best_arm(struct LD_LOAD_BALANCE_INFO *lbInfo, u8 arm,
+							u64 block, u32 count)
 {
 	u16     pend0, pend1;
 	u64     diff0, diff1;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.h b/drivers/scsi/megaraid/megaraid_sas_fp.h
new file mode 100644
index 0000000..48557c8
--- /dev/null
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.h
@@ -0,0 +1,22 @@
+#ifndef MEGARAID_SAS_FP_H
+#define MEGARAID_SAS_FP_H
+
+struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
+
+u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
+
+u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map);
+
+u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
+		      struct LD_LOAD_BALANCE_INFO *lbInfo);
+
+u8
+MR_BuildRaidContext(struct megasas_instance *instance,
+		    struct IO_REQUEST_INFO *io_info,
+		    struct RAID_CONTEXT *pRAID_Context,
+		    struct MR_FW_RAID_MAP_ALL *map);
+
+u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
+			   struct IO_REQUEST_INFO *in_info);
+
+#endif
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index bfd87fa..5c8350b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -53,53 +53,13 @@
 
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
-wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd);
-
-void
-megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd);
-int megasas_alloc_cmds(struct megasas_instance *instance);
-int
-megasas_clear_intr_fusion(struct megasas_register_set __iomem *regs);
-int
-megasas_issue_polled(struct megasas_instance *instance,
-		     struct megasas_cmd *cmd);
-
-u8
-MR_BuildRaidContext(struct megasas_instance *instance,
-		    struct IO_REQUEST_INFO *io_info,
-		    struct RAID_CONTEXT *pRAID_Context,
-		    struct MR_FW_RAID_MAP_ALL *map);
-u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map);
-struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
-
-u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
-
-void
-megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
-
-u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
-		      struct LD_LOAD_BALANCE_INFO *lbInfo);
-u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
-			   struct IO_REQUEST_INFO *in_info);
-int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
-void megaraid_sas_kill_hba(struct megasas_instance *instance);
-
-extern u32 megasas_dbg_lvl;
+#include "megaraid_sas_fp.h"
 
 /**
  * megasas_enable_intr_fusion -	Enables interrupts
  * @regs:			MFI register set
  */
-void
+static void
 megasas_enable_intr_fusion(struct megasas_register_set __iomem *regs)
 {
 	/* For Thunderbolt/Invader also clear intr on enable */
@@ -116,7 +76,7 @@ megasas_enable_intr_fusion(struct megasas_register_set __iomem *regs)
  * megasas_disable_intr_fusion - Disables interrupt
  * @regs:			 MFI register set
  */
-void
+static void
 megasas_disable_intr_fusion(struct megasas_register_set __iomem *regs)
 {
 	u32 mask = 0xFFFFFFFF;
@@ -153,7 +113,7 @@ megasas_clear_intr_fusion(struct megasas_register_set __iomem *regs)
  *
  * Returns a free command from the pool
  */
-struct megasas_cmd_fusion *megasas_get_cmd_fusion(struct megasas_instance
+static struct megasas_cmd_fusion *megasas_get_cmd_fusion(struct megasas_instance
 						  *instance)
 {
 	unsigned long flags;
@@ -382,7 +342,7 @@ static int megasas_create_frame_pool_fusion(struct megasas_instance *instance)
  * and is used as SMID of the cmd.
  * SMID value range is from 1 to max_fw_cmds.
  */
-int
+static int
 megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 {
 	int i, j, count;
@@ -551,14 +511,15 @@ fail_req_desc:
 }
 
 /**
- * wait_and_poll -	Issues a polling command
+ * megaraid_wait_and_poll -	Issues a polling command
  * @instance:			Adapter soft state
  * @cmd:			Command packet to be issued
  *
  * For polling, MFI requires the cmd_status to be set to 0xFF before posting.
  */
 int
-wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd)
+megaraid_wait_and_poll(struct megasas_instance *instance,
+					struct megasas_cmd *cmd)
 {
 	int i;
 	struct megasas_header *frame_hdr = &cmd->frame->hdr;
@@ -673,7 +634,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	instance->instancet->fire_cmd(instance, req_desc->u.low,
 				      req_desc->u.high, instance->reg_set);
 
-	wait_and_poll(instance, cmd);
+	megaraid_wait_and_poll(instance, cmd);
 
 	frame_hdr = &cmd->frame->hdr;
 	if (frame_hdr->cmd_status != 0) {
@@ -874,7 +835,7 @@ megasas_sync_map_info(struct megasas_instance *instance)
  *
  * This is the main function for initializing firmware.
  */
-u32
+static u32
 megasas_init_adapter_fusion(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *reg_set;
@@ -990,7 +951,7 @@ fail_alloc_mfi_cmds:
  * @frame_count :		Number of frames for the command
  * @regs :			MFI register set
  */
-void
+static void
 megasas_fire_cmd_fusion(struct megasas_instance *instance,
 			dma_addr_t req_desc_lo,
 			u32 req_desc_hi,
@@ -1013,7 +974,7 @@ megasas_fire_cmd_fusion(struct megasas_instance *instance,
  * @ext_status :	ext status of cmd returned by FW
  */
 
-void
+static void
 map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8 ext_status)
 {
 
@@ -1148,7 +1109,7 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
  *
  * Used to set the PD LBA in CDB for FP IOs
  */
-void
+static void
 megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
 		   struct IO_REQUEST_INFO *io_info, struct scsi_cmnd *scp,
 		   struct MR_FW_RAID_MAP_ALL *local_map_ptr, u32 ref_tag)
@@ -1327,7 +1288,7 @@ megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
  * Prepares the io_request and chain elements (sg_frame) for IO
  * The IO can be for PD (Fast Path) or LD
  */
-void
+static void
 megasas_build_ldio_fusion(struct megasas_instance *instance,
 			  struct scsi_cmnd *scp,
 			  struct megasas_cmd_fusion *cmd)
@@ -1550,7 +1511,7 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
  * Invokes helper functions to prepare request frames
  * and sets flags appropriate for IO/Non-IO cmd
  */
-int
+static int
 megasas_build_io_fusion(struct megasas_instance *instance,
 			struct scsi_cmnd *scp,
 			struct megasas_cmd_fusion *cmd)
@@ -1621,7 +1582,7 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 	return 0;
 }
 
-union MEGASAS_REQUEST_DESCRIPTOR_UNION *
+static union MEGASAS_REQUEST_DESCRIPTOR_UNION *
 megasas_get_request_descriptor(struct megasas_instance *instance, u16 index)
 {
 	u8 *p;
@@ -1701,7 +1662,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
  * @instance:			Adapter soft state
  * Completes all commands that is in reply descriptor queue
  */
-int
+static int
 complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 {
 	union MPI2_REPLY_DESCRIPTORS_UNION *desc;
@@ -1841,7 +1802,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
  *
  * Tasklet to complete cmds
  */
-void
+static void
 megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
 {
 	struct megasas_instance *instance =
@@ -1868,7 +1829,7 @@ megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
 /**
  * megasas_isr_fusion - isr entry point
  */
-irqreturn_t megasas_isr_fusion(int irq, void *devp)
+static irqreturn_t megasas_isr_fusion(int irq, void *devp)
 {
 	struct megasas_irq_context *irq_context = devp;
 	struct megasas_instance *instance = irq_context->instance;
@@ -1904,7 +1865,7 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
  * mfi_cmd:			megasas_cmd pointer
  *
  */
-u8
+static u8
 build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 			struct megasas_cmd *mfi_cmd)
 {
@@ -1966,7 +1927,7 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
  * @cmd:			mfi cmd to build
  *
  */
-union MEGASAS_REQUEST_DESCRIPTOR_UNION *
+static union MEGASAS_REQUEST_DESCRIPTOR_UNION *
 build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 {
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
@@ -1999,7 +1960,7 @@ build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
  * @cmd:			mfi cmd pointer
  *
  */
-void
+static void
 megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 			  struct megasas_cmd *cmd)
 {
@@ -2062,7 +2023,8 @@ megasas_check_reset_fusion(struct megasas_instance *instance,
 }
 
 /* This function waits for outstanding commands on fusion to complete */
-int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance)
+static int
+megasas_wait_for_outstanding_fusion(struct megasas_instance *instance)
 {
 	int i, outstanding, retval = 0;
 	u32 fw_state, wait_time = MEGASAS_RESET_WAIT_TIME;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 088c9f9..c5e8b27 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -703,4 +703,13 @@ union desc_value {
 	} u;
 };
 
+struct megasas_cmd;
+int
+megaraid_wait_and_poll(struct megasas_instance *instance,
+					 struct megasas_cmd *cmd);
+/*
+ * Template added for TB (Fusion)
+ */
+extern struct megasas_instance_template megasas_instance_template_fusion;
+
 #endif /* _MEGARAID_SAS_FUSION_H_ */
-- 
1.7.5.4
