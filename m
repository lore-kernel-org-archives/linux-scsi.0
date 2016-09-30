From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH 1/2] megaraid_sas: mark symbols static where possible
Date: Fri, 30 Sep 2016 17:41:32 +0800
Message-ID: <1475228492-21324-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn, han.fei@zte.com.cn, tang.qiang007@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

We get a few warnings when building kernel with W=1:
drivers/scsi/megaraid/megaraid_sas_base.c:200:1: warning: no previous prototype for 'megasas_issue_dcmd' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:2047:6: warning: no previous prototype for 'megasas_do_ocr' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_base.c:3972:1: warning: no previous declaration for 'dcmd_timeout_ocr_possible' [-Wmissing-declarations]
drivers/scsi/megaraid/megaraid_sas_fusion.c:106:1: warning: no previous prototype for 'megasas_enable_intr_fusion' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fusion.c:127:1: warning: no previous prototype for 'megasas_disable_intr_fusion' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fusion.c:166:35: warning: no previous declaration for 'megasas_get_cmd_fusion' [-Wmissing-declarations]
drivers/scsi/megaraid/megaraid_sas_fusion.c:388:1: warning: no previous prototype for 'megasas_alloc_cmdlist_fusion' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fusion.c:422:1: warning: no previous prototype for 'megasas_alloc_request_fusion' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fusion.c:460:1: warning: no previous prototype for 'megasas_alloc_reply_fusion' [-Wmissing-prototypes]
drivers/scsi/megaraid/megaraid_sas_fusion.c:502:1: warning: no previous prototype for 'megasas_alloc_rdpq_fusion' [-Wmissing-prototypes]

In fact, these functions are only used in the file in which they are
declared and don't need a declaration, but can be made static.
So this patch marks these functions with 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |  6 ++--
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 28 ++++++++-------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 53 +++++++++++++++--------------
 3 files changed, 47 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 9ff57de..3595f9d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -196,7 +196,7 @@ void megasas_fusion_ocr_wq(struct work_struct *work);
 static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
 					 int initial);
 
-int
+static int
 megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 {
 	instance->instancet->fire_cmd(instance,
@@ -2044,7 +2044,7 @@ megasas_internal_reset_defer_cmds(struct megasas_instance *instance);
 static void
 process_fw_state_change_wq(struct work_struct *work);
 
-void megasas_do_ocr(struct megasas_instance *instance)
+static void megasas_do_ocr(struct megasas_instance *instance)
 {
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1064R) ||
 	(instance->pdev->device == PCI_DEVICE_ID_DELL_PERC5) ||
@@ -3968,7 +3968,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
  * Return 0 for only Fusion adapter, if driver load/unload is not in progress
  * or FW is not under OCR.
  */
-inline int
+static inline int
 dcmd_timeout_ocr_possible(struct megasas_instance *instance) {
 
 	if (!instance->ctrl_context)
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index e413113..3702d3d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -91,7 +91,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 static u64 get_row_from_strip(struct megasas_instance *instance, u32 ld,
 	u64 strip, struct MR_DRV_RAID_MAP_ALL *map);
 
-u32 mega_mod64(u64 dividend, u32 divisor)
+static u32 mega_mod64(u64 dividend, u32 divisor)
 {
 	u64 d;
 	u32 remainder;
@@ -109,7 +109,7 @@ u32 mega_mod64(u64 dividend, u32 divisor)
  *
  * @return quotient
  **/
-u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
+static u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
 {
 	u32 remainder;
 	u64 d;
@@ -174,7 +174,7 @@ static struct MR_LD_SPAN *MR_LdSpanPtrGet(u32 ld, u32 span,
 /*
  * This function will Populate Driver Map using firmware raid map
  */
-void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
+static void MR_PopulateDrvRaidMap(struct megasas_instance *instance)
 {
 	struct fusion_context *fusion = instance->ctrl_context;
 	struct MR_FW_RAID_MAP_ALL     *fw_map_old    = NULL;
@@ -312,8 +312,8 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance)
 	return 1;
 }
 
-u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
-		    struct MR_DRV_RAID_MAP_ALL *map)
+static u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
+			   struct MR_DRV_RAID_MAP_ALL *map)
 {
 	struct MR_SPAN_BLOCK_INFO *pSpanBlock = MR_LdSpanInfoGet(ld, map);
 	struct MR_QUAD_ELEMENT    *quad;
@@ -448,8 +448,9 @@ static int getSpanInfo(struct MR_DRV_RAID_MAP_ALL *map,
 *    div_error	   - Devide error code.
 */
 
-u32 mr_spanset_get_span_block(struct megasas_instance *instance,
-		u32 ld, u64 row, u64 *span_blk, struct MR_DRV_RAID_MAP_ALL *map)
+static u32 mr_spanset_get_span_block(struct megasas_instance *instance,
+				     u32 ld, u64 row, u64 *span_blk,
+				     struct MR_DRV_RAID_MAP_ALL *map)
 {
 	struct fusion_context *fusion = instance->ctrl_context;
 	struct MR_LD_RAID         *raid = MR_LdRaidGet(ld, map);
@@ -689,8 +690,9 @@ static u32 get_arm_from_strip(struct megasas_instance *instance,
 }
 
 /* This Function will return Phys arm */
-u8 get_arm(struct megasas_instance *instance, u32 ld, u8 span, u64 stripe,
-		struct MR_DRV_RAID_MAP_ALL *map)
+static u8
+get_arm(struct megasas_instance *instance, u32 ld, u8 span, u64 stripe,
+	struct MR_DRV_RAID_MAP_ALL *map)
 {
 	struct MR_LD_RAID  *raid = MR_LdRaidGet(ld, map);
 	/* Need to check correct default value */
@@ -812,7 +814,8 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 *    span          - Span number
 *    block         - Absolute Block number in the physical disk
 */
-u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
+static u8
+MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 		u16 stripRef, struct IO_REQUEST_INFO *io_info,
 		struct RAID_CONTEXT *pRAID_Context,
 		struct MR_DRV_RAID_MAP_ALL *map)
@@ -1290,8 +1293,9 @@ void mr_update_load_balance_params(struct MR_DRV_RAID_MAP_ALL *drv_map,
 	}
 }
 
-u8 megasas_get_best_arm_pd(struct megasas_instance *instance,
-	struct LD_LOAD_BALANCE_INFO *lbInfo, struct IO_REQUEST_INFO *io_info)
+static u8 megasas_get_best_arm_pd(struct megasas_instance *instance,
+				  struct LD_LOAD_BALANCE_INFO *lbInfo,
+				  struct IO_REQUEST_INFO *io_info)
 {
 	struct fusion_context *fusion;
 	struct MR_LD_RAID  *raid;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 52d8bbf..730b525 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -102,7 +102,7 @@ static void megasas_free_reply_fusion(struct megasas_instance *instance);
  * megasas_enable_intr_fusion -	Enables interrupts
  * @regs:			MFI register set
  */
-void
+static void
 megasas_enable_intr_fusion(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *regs;
@@ -123,7 +123,7 @@ megasas_enable_intr_fusion(struct megasas_instance *instance)
  * megasas_disable_intr_fusion - Disables interrupt
  * @regs:			 MFI register set
  */
-void
+static void
 megasas_disable_intr_fusion(struct megasas_instance *instance)
 {
 	u32 mask = 0xFFFFFFFF;
@@ -163,8 +163,9 @@ megasas_clear_intr_fusion(struct megasas_register_set __iomem *regs)
  *
  * Returns a blk_tag indexed mpt frame
  */
-inline struct megasas_cmd_fusion *megasas_get_cmd_fusion(struct megasas_instance
-						  *instance, u32 blk_tag)
+static inline struct megasas_cmd_fusion *
+megasas_get_cmd_fusion(struct megasas_instance
+		       *instance, u32 blk_tag)
 {
 	struct fusion_context *fusion;
 
@@ -384,7 +385,7 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 	return 0;
 }
 
-int
+static int
 megasas_alloc_cmdlist_fusion(struct megasas_instance *instance)
 {
 	u32 max_cmd, i;
@@ -418,7 +419,7 @@ megasas_alloc_cmdlist_fusion(struct megasas_instance *instance)
 	}
 	return 0;
 }
-int
+static int
 megasas_alloc_request_fusion(struct megasas_instance *instance)
 {
 	struct fusion_context *fusion;
@@ -456,7 +457,7 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
 	return 0;
 }
 
-int
+static int
 megasas_alloc_reply_fusion(struct megasas_instance *instance)
 {
 	int i, count;
@@ -498,7 +499,7 @@ megasas_alloc_reply_fusion(struct megasas_instance *instance)
 	return 0;
 }
 
-int
+static int
 megasas_alloc_rdpq_fusion(struct megasas_instance *instance)
 {
 	int i, j, count;
@@ -606,7 +607,7 @@ megasas_free_reply_fusion(struct megasas_instance *instance) {
  * and is used as SMID of the cmd.
  * SMID value range is from 1 to max_fw_cmds.
  */
-int
+static int
 megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 {
 	int i;
@@ -1210,7 +1211,7 @@ megasas_display_intel_branding(struct megasas_instance *instance)
  *
  * This is the main function for initializing firmware.
  */
-u32
+static u32
 megasas_init_adapter_fusion(struct megasas_instance *instance)
 {
 	struct megasas_register_set __iomem *reg_set;
@@ -1382,7 +1383,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
  * @ext_status :	ext status of cmd returned by FW
  */
 
-void
+static void
 map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8 ext_status)
 {
 
@@ -1514,7 +1515,7 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
  *
  * Used to set the PD LBA in CDB for FP IOs
  */
-void
+static void
 megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
 		   struct IO_REQUEST_INFO *io_info, struct scsi_cmnd *scp,
 		   struct MR_DRV_RAID_MAP_ALL *local_map_ptr, u32 ref_tag)
@@ -1691,7 +1692,7 @@ megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
  * Prepares the io_request and chain elements (sg_frame) for IO
  * The IO can be for PD (Fast Path) or LD
  */
-void
+static void
 megasas_build_ldio_fusion(struct megasas_instance *instance,
 			  struct scsi_cmnd *scp,
 			  struct megasas_cmd_fusion *cmd)
@@ -2056,7 +2057,7 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
  * Invokes helper functions to prepare request frames
  * and sets flags appropriate for IO/Non-IO cmd
  */
-int
+static int
 megasas_build_io_fusion(struct megasas_instance *instance,
 			struct scsi_cmnd *scp,
 			struct megasas_cmd_fusion *cmd)
@@ -2144,7 +2145,7 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 	return 0;
 }
 
-union MEGASAS_REQUEST_DESCRIPTOR_UNION *
+static union MEGASAS_REQUEST_DESCRIPTOR_UNION *
 megasas_get_request_descriptor(struct megasas_instance *instance, u16 index)
 {
 	u8 *p;
@@ -2229,7 +2230,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
  * @instance:			Adapter soft state
  * Completes all commands that is in reply descriptor queue
  */
-int
+static int
 complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 {
 	union MPI2_REPLY_DESCRIPTORS_UNION *desc;
@@ -2405,7 +2406,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
  *
  * Tasklet to complete cmds
  */
-void
+static void
 megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
 {
 	struct megasas_instance *instance =
@@ -2430,7 +2431,7 @@ megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
 /**
  * megasas_isr_fusion - isr entry point
  */
-irqreturn_t megasas_isr_fusion(int irq, void *devp)
+static irqreturn_t megasas_isr_fusion(int irq, void *devp)
 {
 	struct megasas_irq_context *irq_context = devp;
 	struct megasas_instance *instance = irq_context->instance;
@@ -2481,7 +2482,7 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
  * mfi_cmd:			megasas_cmd pointer
  *
  */
-u8
+static u8
 build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 			struct megasas_cmd *mfi_cmd)
 {
@@ -2541,7 +2542,7 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
  * @cmd:			mfi cmd to build
  *
  */
-union MEGASAS_REQUEST_DESCRIPTOR_UNION *
+static union MEGASAS_REQUEST_DESCRIPTOR_UNION *
 build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 {
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
@@ -2574,7 +2575,7 @@ build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
  * @cmd:			mfi cmd pointer
  *
  */
-int
+static int
 megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 			  struct megasas_cmd *cmd)
 {
@@ -2748,8 +2749,9 @@ megasas_check_reset_fusion(struct megasas_instance *instance,
 }
 
 /* This function waits for outstanding commands on fusion to complete */
-int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
-					int reason, int *convert)
+static int
+megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
+				    int reason, int *convert)
 {
 	int i, outstanding, retval = 0, hb_seconds_missed = 0;
 	u32 fw_state;
@@ -2849,7 +2851,7 @@ void  megasas_reset_reply_desc(struct megasas_instance *instance)
  * megasas_refire_mgmt_cmd :	Re-fire management commands
  * @instance:				Controller's soft instance
 */
-void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
+static void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 {
 	int j;
 	struct megasas_cmd_fusion *cmd_fusion;
@@ -3332,7 +3334,8 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 }
 
 /*SRIOV get other instance in cluster if any*/
-struct megasas_instance *megasas_get_peer_instance(struct megasas_instance *instance)
+static struct megasas_instance *
+megasas_get_peer_instance(struct megasas_instance *instance)
 {
 	int i;
 
-- 
2.7.4
