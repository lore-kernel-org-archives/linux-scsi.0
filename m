From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 11/39] megaraid_sas: NVME interface target prop added
Date: Mon,  6 Feb 2017 01:59:44 -0800
Message-ID: <1486375212-17329-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34936 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751562AbdBFKBz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:01:55 -0500
Received: by mail-pf0-f180.google.com with SMTP id f144so23075020pfa.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:01:55 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

This patch depends on patch 0008.
This patch fetch true values of NVME property
from FW using New DCMD interface MR_DCMD_DEV_GET_TARGET_PROP

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  10 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  55 +++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 316 ++++++++++++++++++++++++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  14 +-
 4 files changed, 350 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index f3b3a84..fb3ee17 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2172,6 +2172,11 @@ struct megasas_instance {
 	atomic_t fw_outstanding;
 	atomic_t ldio_outstanding;
 	atomic_t fw_reset_no_pci_access;
+	atomic_t ieee_sgl;
+	atomic_t prp_sgl;
+	atomic_t sge_holes_type1;
+	atomic_t sge_holes_type2;
+	atomic_t sge_holes_type3;
 
 	struct megasas_instance_template *instancet;
 	struct tasklet_struct isr_tasklet;
@@ -2443,7 +2448,9 @@ __le16 MR_PdDevHandleGet(u32 pd, struct MR_DRV_RAID_MAP_ALL *map);
 u16 MR_GetLDTgtId(u32 ld, struct MR_DRV_RAID_MAP_ALL *map);
 
 __le16 get_updated_dev_handle(struct megasas_instance *instance,
-	struct LD_LOAD_BALANCE_INFO *lbInfo, struct IO_REQUEST_INFO *in_info);
+			      struct LD_LOAD_BALANCE_INFO *lbInfo,
+			      struct IO_REQUEST_INFO *in_info,
+			      struct MR_DRV_RAID_MAP_ALL *drv_map);
 void mr_update_load_balance_params(struct MR_DRV_RAID_MAP_ALL *map,
 	struct LD_LOAD_BALANCE_INFO *lbInfo);
 int megasas_get_ctrl_info(struct megasas_instance *instance);
@@ -2472,4 +2479,5 @@ void megasas_update_sdev_properties(struct scsi_device *sdev);
 int megasas_reset_fusion(struct Scsi_Host *shost, int reason);
 int megasas_task_abort_fusion(struct scsi_cmnd *scmd);
 int megasas_reset_target_fusion(struct scsi_cmnd *scmd);
+u32 mega_mod64(u64 dividend, u32 divisor);
 #endif				/*LSI_MEGARAID_SAS_H */
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 24258af..c3ef82d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -155,6 +155,11 @@ __le16 MR_PdDevHandleGet(u32 pd, struct MR_DRV_RAID_MAP_ALL *map)
 	return map->raidMap.devHndlInfo[pd].curDevHdl;
 }
 
+static u8 MR_PdInterfaceTypeGet(u32 pd, struct MR_DRV_RAID_MAP_ALL *map)
+{
+	return map->raidMap.devHndlInfo[pd].interfaceType;
+}
+
 u16 MR_GetLDTgtId(u32 ld, struct MR_DRV_RAID_MAP_ALL *map)
 {
 	return le16_to_cpu(map->raidMap.ldSpanMap[ld].ldRaid.targetId);
@@ -929,6 +934,7 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 	u8	retval = TRUE;
 	u64	*pdBlock = &io_info->pdBlock;
 	__le16	*pDevHandle = &io_info->devHandle;
+	u8	*pPdInterface = &io_info->pd_interface;
 	u32	logArm, rowMod, armQ, arm;
 	struct fusion_context *fusion;
 
@@ -960,15 +966,18 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 
 	if (pd != MR_PD_INVALID) {
 		*pDevHandle = MR_PdDevHandleGet(pd, map);
+		*pPdInterface = MR_PdInterfaceTypeGet(pd, map);
 		/* get second pd also for raid 1/10 fast path writes*/
-		if (raid->level == 1) {
+		if (instance->is_ventura &&
+		    (raid->level == 1) &&
+		    !io_info->isRead) {
 			r1_alt_pd = MR_ArPdGet(arRef, physArm + 1, map);
 			if (r1_alt_pd != MR_PD_INVALID)
 				io_info->r1_alt_dev_handle =
 				MR_PdDevHandleGet(r1_alt_pd, map);
 		}
 	} else {
-		*pDevHandle = cpu_to_le16(MR_PD_INVALID);
+		*pDevHandle = cpu_to_le16(MR_DEVHANDLE_INVALID);
 		if ((raid->level >= 5) &&
 			((fusion->adapter_type == THUNDERBOLT_SERIES)  ||
 			((fusion->adapter_type == INVADER_SERIES) &&
@@ -977,8 +986,10 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 		else if (raid->level == 1) {
 			physArm = physArm + 1;
 			pd = MR_ArPdGet(arRef, physArm, map);
-			if (pd != MR_PD_INVALID)
+			if (pd != MR_PD_INVALID) {
 				*pDevHandle = MR_PdDevHandleGet(pd, map);
+				*pPdInterface = MR_PdInterfaceTypeGet(pd, map);
+			}
 		}
 	}
 
@@ -1025,6 +1036,7 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 	u8	    retval = TRUE;
 	u64	    *pdBlock = &io_info->pdBlock;
 	__le16	    *pDevHandle = &io_info->devHandle;
+	u8	    *pPdInterface = &io_info->pd_interface;
 	struct fusion_context *fusion;
 
 	fusion = instance->ctrl_context;
@@ -1070,16 +1082,19 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 	if (pd != MR_PD_INVALID) {
 		/* Get dev handle from Pd. */
 		*pDevHandle = MR_PdDevHandleGet(pd, map);
+		*pPdInterface = MR_PdInterfaceTypeGet(pd, map);
 		/* get second pd also for raid 1/10 fast path writes*/
-		if (raid->level == 1) {
+		if (instance->is_ventura &&
+		    (raid->level == 1) &&
+		    !io_info->isRead) {
 			r1_alt_pd = MR_ArPdGet(arRef, physArm + 1, map);
 			if (r1_alt_pd != MR_PD_INVALID)
 				io_info->r1_alt_dev_handle =
-				MR_PdDevHandleGet(r1_alt_pd, map);
+					MR_PdDevHandleGet(r1_alt_pd, map);
 		}
 	} else {
 		/* set dev handle as invalid. */
-		*pDevHandle = cpu_to_le16(MR_PD_INVALID);
+		*pDevHandle = cpu_to_le16(MR_DEVHANDLE_INVALID);
 		if ((raid->level >= 5) &&
 			((fusion->adapter_type == THUNDERBOLT_SERIES)  ||
 			((fusion->adapter_type == INVADER_SERIES) &&
@@ -1089,9 +1104,11 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 			/* Get alternate Pd. */
 			physArm = physArm + 1;
 			pd = MR_ArPdGet(arRef, physArm, map);
-			if (pd != MR_PD_INVALID)
+			if (pd != MR_PD_INVALID) {
 				/* Get dev handle from Pd */
 				*pDevHandle = MR_PdDevHandleGet(pd, map);
+				*pPdInterface = MR_PdInterfaceTypeGet(pd, map);
+			}
 		}
 	}
 
@@ -1509,11 +1526,11 @@ void mr_update_load_balance_params(struct MR_DRV_RAID_MAP_ALL *drv_map,
 }
 
 u8 megasas_get_best_arm_pd(struct megasas_instance *instance,
-	struct LD_LOAD_BALANCE_INFO *lbInfo, struct IO_REQUEST_INFO *io_info)
+			   struct LD_LOAD_BALANCE_INFO *lbInfo,
+			   struct IO_REQUEST_INFO *io_info,
+			   struct MR_DRV_RAID_MAP_ALL *drv_map)
 {
-	struct fusion_context *fusion;
 	struct MR_LD_RAID  *raid;
-	struct MR_DRV_RAID_MAP_ALL *drv_map;
 	u16	pd1_dev_handle;
 	u16     pend0, pend1, ld;
 	u64     diff0, diff1;
@@ -1527,9 +1544,6 @@ u8 megasas_get_best_arm_pd(struct megasas_instance *instance,
 			>> RAID_CTX_SPANARM_SPAN_SHIFT);
 	arm = (io_info->span_arm & RAID_CTX_SPANARM_ARM_MASK);
 
-
-	fusion = instance->ctrl_context;
-	drv_map = fusion->ld_drv_map[(instance->map_id & 1)];
 	ld = MR_TargetIdToLdGet(io_info->ldTgtId, drv_map);
 	raid = MR_LdRaidGet(ld, drv_map);
 	span_row_size = instance->UnevenSpanSupport ?
@@ -1544,7 +1558,7 @@ u8 megasas_get_best_arm_pd(struct megasas_instance *instance,
 
 	pd1_dev_handle = MR_PdDevHandleGet(pd1, drv_map);
 
-	if (pd1_dev_handle == MR_PD_INVALID) {
+	if (pd1_dev_handle == MR_DEVHANDLE_INVALID) {
 		bestArm = arm;
 	} else {
 		/* get the pending cmds for the data and mirror arms */
@@ -1581,19 +1595,18 @@ u8 megasas_get_best_arm_pd(struct megasas_instance *instance,
 }
 
 __le16 get_updated_dev_handle(struct megasas_instance *instance,
-	struct LD_LOAD_BALANCE_INFO *lbInfo, struct IO_REQUEST_INFO *io_info)
+			      struct LD_LOAD_BALANCE_INFO *lbInfo,
+			      struct IO_REQUEST_INFO *io_info,
+			      struct MR_DRV_RAID_MAP_ALL *drv_map)
 {
 	u8 arm_pd;
 	__le16 devHandle;
-	struct fusion_context *fusion;
-	struct MR_DRV_RAID_MAP_ALL *drv_map;
-
-	fusion = instance->ctrl_context;
-	drv_map = fusion->ld_drv_map[(instance->map_id & 1)];
 
 	/* get best new arm (PD ID) */
-	arm_pd  = megasas_get_best_arm_pd(instance, lbInfo, io_info);
+	arm_pd  = megasas_get_best_arm_pd(instance, lbInfo, io_info, drv_map);
 	devHandle = MR_PdDevHandleGet(arm_pd, drv_map);
+	io_info->pd_interface = MR_PdInterfaceTypeGet(arm_pd, drv_map);
 	atomic_inc(&lbInfo->scsi_pending_cmds[arm_pd]);
+
 	return devHandle;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index d87483e..80bfb11 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1479,21 +1479,261 @@ map_cmd_status(struct fusion_context *fusion,
 }
 
 /**
+ * megasas_is_prp_possible -
+ * Checks if native NVMe PRPs can be built for the IO
+ *
+ * @instance:		Adapter soft state
+ * @scmd:		SCSI command from the mid-layer
+ * @sge_count:		scatter gather element count.
+ *
+ * Returns:		true: PRPs can be built
+ *			false: IEEE SGLs needs to be built
+ */
+static bool
+megasas_is_prp_possible(struct megasas_instance *instance,
+			struct scsi_cmnd *scmd, int sge_count)
+{
+	struct fusion_context *fusion;
+	int i;
+	u32 data_length = 0;
+	struct scatterlist *sg_scmd;
+	bool build_prp = false;
+	u32 mr_nvme_pg_size;
+
+	mr_nvme_pg_size = max_t(u32, instance->nvme_page_size,
+				MR_DEFAULT_NVME_PAGE_SIZE);
+	fusion = instance->ctrl_context;
+	data_length = scsi_bufflen(scmd);
+	sg_scmd = scsi_sglist(scmd);
+
+	/*
+	 * NVMe uses one PRP for each page (or part of a page)
+	 * look at the data length - if 4 pages or less then IEEE is OK
+	 * if  > 5 pages then we need to build a native SGL
+	 * if > 4 and <= 5 pages, then check physical address of 1st SG entry
+	 * if this first size in the page is >= the residual beyond 4 pages
+	 * then use IEEE, otherwise use native SGL
+	 */
+
+	if (data_length > (mr_nvme_pg_size * 5)) {
+		build_prp = true;
+	} else if ((data_length > (mr_nvme_pg_size * 4)) &&
+			(data_length <= (mr_nvme_pg_size * 5)))  {
+		/* check if 1st SG entry size is < residual beyond 4 pages */
+		if (sg_dma_len(sg_scmd) < (data_length - (mr_nvme_pg_size * 4)))
+			build_prp = true;
+	}
+
+/*
+ * Below code detects gaps/holes in IO data buffers.
+ * What does holes/gaps mean?
+ * Any SGE except first one in a SGL starts at non NVME page size
+ * aligned address OR Any SGE except last one in a SGL ends at
+ * non NVME page size boundary.
+ *
+ * Driver has already informed block layer by setting boundary rules for
+ * bio merging done at NVME page size boundary calling kernel API
+ * blk_queue_virt_boundary inside slave_config.
+ * Still there is possibility of IO coming with holes to driver because of
+ * IO merging done by IO scheduler.
+ *
+ * With SCSI BLK MQ enabled, there will be no IO with holes as there is no
+ * IO scheduling so no IO merging.
+ *
+ * With SCSI BLK MQ disabled, IO scheduler may attempt to merge IOs and
+ * then sending IOs with holes.
+ *
+ * Though driver can request block layer to disable IO merging by calling-
+ * queue_flag_set_unlocked(QUEUE_FLAG_NOMERGES, sdev->request_queue) but
+ * user may tune sysfs parameter- nomerges again to 0 or 1.
+ *
+ * If in future IO scheduling is enabled with SCSI BLK MQ,
+ * this algorithm to detect holes will be required in driver
+ * for SCSI BLK MQ enabled case as well.
+ *
+ *
+ */
+	scsi_for_each_sg(scmd, sg_scmd, sge_count, i) {
+		if ((i != 0) && (i != (sge_count - 1))) {
+			if (mega_mod64(sg_dma_len(sg_scmd), mr_nvme_pg_size) ||
+			    mega_mod64(sg_dma_address(sg_scmd),
+				       mr_nvme_pg_size)) {
+				build_prp = false;
+				atomic_inc(&instance->sge_holes_type1);
+				break;
+			}
+		}
+
+		if ((sge_count > 1) && (i == 0)) {
+			if ((mega_mod64((sg_dma_address(sg_scmd) +
+					sg_dma_len(sg_scmd)),
+					mr_nvme_pg_size))) {
+				build_prp = false;
+				atomic_inc(&instance->sge_holes_type2);
+				break;
+			}
+		}
+
+		if ((sge_count > 1) && (i == (sge_count - 1))) {
+			if (mega_mod64(sg_dma_address(sg_scmd),
+				       mr_nvme_pg_size)) {
+				build_prp = false;
+				atomic_inc(&instance->sge_holes_type3);
+				break;
+			}
+		}
+	}
+
+	return build_prp;
+}
+
+/**
+ * megasas_make_prp_nvme -
+ * Prepare PRPs(Physical Region Page)- SGLs specific to NVMe drives only
+ *
+ * @instance:		Adapter soft state
+ * @scmd:		SCSI command from the mid-layer
+ * @sgl_ptr:		SGL to be filled in
+ * @cmd:		Fusion command frame
+ * @sge_count:		scatter gather element count.
+ *
+ * Returns:		true: PRPs are built
+ *			false: IEEE SGLs needs to be built
+ */
+static bool
+megasas_make_prp_nvme(struct megasas_instance *instance, struct scsi_cmnd *scmd,
+		      struct MPI25_IEEE_SGE_CHAIN64 *sgl_ptr,
+		      struct megasas_cmd_fusion *cmd, int sge_count)
+{
+	int sge_len, offset, num_prp_in_chain = 0;
+	struct MPI25_IEEE_SGE_CHAIN64 *main_chain_element, *ptr_first_sgl;
+	u64 *ptr_sgl, *ptr_sgl_phys;
+	u64 sge_addr;
+	u32 page_mask, page_mask_result;
+	struct scatterlist *sg_scmd;
+	u32 first_prp_len;
+	bool build_prp = false;
+	int data_len = scsi_bufflen(scmd);
+	struct fusion_context *fusion;
+	u32 mr_nvme_pg_size = max_t(u32, instance->nvme_page_size,
+					MR_DEFAULT_NVME_PAGE_SIZE);
+
+	fusion = instance->ctrl_context;
+
+	build_prp = megasas_is_prp_possible(instance, scmd, sge_count);
+
+	if (!build_prp)
+		return false;
+
+	/*
+	 * Nvme has a very convoluted prp format.  One prp is required
+	 * for each page or partial page. Driver need to split up OS sg_list
+	 * entries if it is longer than one page or cross a page
+	 * boundary.  Driver also have to insert a PRP list pointer entry as
+	 * the last entry in each physical page of the PRP list.
+	 *
+	 * NOTE: The first PRP "entry" is actually placed in the first
+	 * SGL entry in the main message as IEEE 64 format.  The 2nd
+	 * entry in the main message is the chain element, and the rest
+	 * of the PRP entries are built in the contiguous pcie buffer.
+	 */
+	page_mask = mr_nvme_pg_size - 1;
+	ptr_sgl = (u64 *)cmd->sg_frame;
+	ptr_sgl_phys = (u64 *)cmd->sg_frame_phys_addr;
+	memset(ptr_sgl, 0, instance->max_chain_frame_sz);
+
+	/* Build chain frame element which holds all prps except first*/
+	main_chain_element = (struct MPI25_IEEE_SGE_CHAIN64 *)
+	    ((u8 *)sgl_ptr + sizeof(struct MPI25_IEEE_SGE_CHAIN64));
+
+	main_chain_element->Address = cpu_to_le64((uintptr_t)ptr_sgl_phys);
+	main_chain_element->NextChainOffset = 0;
+	main_chain_element->Flags = IEEE_SGE_FLAGS_CHAIN_ELEMENT |
+					IEEE_SGE_FLAGS_SYSTEM_ADDR |
+					MPI26_IEEE_SGE_FLAGS_NSF_NVME_PRP;
+
+	/* Build first prp, sge need not to be page aligned*/
+	ptr_first_sgl = sgl_ptr;
+	sg_scmd = scsi_sglist(scmd);
+	sge_addr = sg_dma_address(sg_scmd);
+	sge_len = sg_dma_len(sg_scmd);
+
+	offset = (u32)(sge_addr & page_mask);
+	first_prp_len = mr_nvme_pg_size - offset;
+
+	ptr_first_sgl->Address = cpu_to_le64(sge_addr);
+	ptr_first_sgl->Length = cpu_to_le32(first_prp_len);
+
+	data_len -= first_prp_len;
+
+	if (sge_len > first_prp_len) {
+		sge_addr += first_prp_len;
+		sge_len -= first_prp_len;
+	} else if (sge_len == first_prp_len) {
+		sg_scmd = sg_next(sg_scmd);
+		sge_addr = sg_dma_address(sg_scmd);
+		sge_len = sg_dma_len(sg_scmd);
+	}
+
+	for (;;) {
+		offset = (u32)(sge_addr & page_mask);
+
+		/* Put PRP pointer due to page boundary*/
+		page_mask_result = (uintptr_t)(ptr_sgl + 1) & page_mask;
+		if (unlikely(!page_mask_result)) {
+			scmd_printk(KERN_NOTICE,
+				    scmd, "page boundary ptr_sgl: 0x%p\n",
+				    ptr_sgl);
+			ptr_sgl_phys++;
+			*ptr_sgl =
+				cpu_to_le64((uintptr_t)ptr_sgl_phys);
+			ptr_sgl++;
+			num_prp_in_chain++;
+		}
+
+		*ptr_sgl = cpu_to_le64(sge_addr);
+		ptr_sgl++;
+		ptr_sgl_phys++;
+		num_prp_in_chain++;
+
+		sge_addr += mr_nvme_pg_size;
+		sge_len -= mr_nvme_pg_size;
+		data_len -= mr_nvme_pg_size;
+
+		if (data_len <= 0)
+			break;
+
+		if (sge_len > 0)
+			continue;
+
+		sg_scmd = sg_next(sg_scmd);
+		sge_addr = sg_dma_address(sg_scmd);
+		sge_len = sg_dma_len(sg_scmd);
+	}
+
+	main_chain_element->Length =
+			cpu_to_le32(num_prp_in_chain * sizeof(u64));
+
+	atomic_inc(&instance->prp_sgl);
+	return build_prp;
+}
+
+/**
  * megasas_make_sgl_fusion -	Prepares 32-bit SGL
  * @instance:		Adapter soft state
  * @scp:		SCSI command from the mid-layer
  * @sgl_ptr:		SGL to be filled in
  * @cmd:		cmd we are working on
+ * @sge_count		sge count
  *
- * If successful, this function returns the number of SG elements.
  */
-static int
+static void
 megasas_make_sgl_fusion(struct megasas_instance *instance,
 			struct scsi_cmnd *scp,
 			struct MPI25_IEEE_SGE_CHAIN64 *sgl_ptr,
-			struct megasas_cmd_fusion *cmd)
+			struct megasas_cmd_fusion *cmd, int sge_count)
 {
-	int i, sg_processed, sge_count;
+	int i, sg_processed;
 	struct scatterlist *os_sgl;
 	struct fusion_context *fusion;
 
@@ -1505,13 +1745,6 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
 		sgl_ptr_end->Flags = 0;
 	}
 
-	sge_count = scsi_dma_map(scp);
-
-	BUG_ON(sge_count < 0);
-
-	if (sge_count > instance->max_num_sge || !sge_count)
-		return sge_count;
-
 	scsi_for_each_sg(scp, os_sgl, sge_count, i) {
 		sgl_ptr->Length = cpu_to_le32(sg_dma_len(os_sgl));
 		sgl_ptr->Address = cpu_to_le64(sg_dma_address(os_sgl));
@@ -1520,7 +1753,6 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
 			if (i == sge_count - 1)
 				sgl_ptr->Flags = IEEE_SGE_FLAGS_END_OF_LIST;
 		sgl_ptr++;
-
 		sg_processed = i + 1;
 
 		if ((sg_processed ==  (fusion->max_sge_in_main_msg - 1)) &&
@@ -1557,6 +1789,45 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
 			memset(sgl_ptr, 0, instance->max_chain_frame_sz);
 		}
 	}
+	atomic_inc(&instance->ieee_sgl);
+}
+
+/**
+ * megasas_make_sgl -	Build Scatter Gather List(SGLs)
+ * @scp:		SCSI command pointer
+ * @instance:		Soft instance of controller
+ * @cmd:		Fusion command pointer
+ *
+ * This function will build sgls based on device type.
+ * For nvme drives, there is different way of building sgls in nvme native
+ * format- PRPs(Physical Region Page).
+ *
+ * Returns the number of sg lists actually used, zero if the sg lists
+ * is NULL, or -ENOMEM if the mapping failed
+ */
+static
+int megasas_make_sgl(struct megasas_instance *instance, struct scsi_cmnd *scp,
+		     struct megasas_cmd_fusion *cmd)
+{
+	int sge_count;
+	bool build_prp = false;
+	struct MPI25_IEEE_SGE_CHAIN64 *sgl_chain64;
+
+	sge_count = scsi_dma_map(scp);
+
+	if ((sge_count > instance->max_num_sge) || (sge_count <= 0))
+		return sge_count;
+
+	sgl_chain64 = (struct MPI25_IEEE_SGE_CHAIN64 *)&cmd->io_request->SGL;
+	if ((le16_to_cpu(cmd->io_request->IoFlags) &
+	    MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH) &&
+	    (cmd->pd_interface == NVME_PD))
+		build_prp = megasas_make_prp_nvme(instance, scp, sgl_chain64,
+						  cmd, sge_count);
+
+	if (!build_prp)
+		megasas_make_sgl_fusion(instance, scp, sgl_chain64,
+					cmd, sge_count);
 
 	return sge_count;
 }
@@ -2081,7 +2352,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 			io_info.devHandle =
 				get_updated_dev_handle(instance,
 					&fusion->load_balance_info[device_id],
-					&io_info);
+					&io_info, local_map_ptr);
 			scp->SCp.Status |= MEGASAS_LOAD_BALANCE_FLAG;
 			cmd->pd_r1_lb = io_info.pd_after_lb;
 			if (instance->is_ventura)
@@ -2108,6 +2379,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 
 		cmd->request_desc->SCSIIO.DevHandle = io_info.devHandle;
 		io_request->DevHandle = io_info.devHandle;
+		cmd->pd_interface = io_info.pd_interface;
 		/* populate the LUN field */
 		memcpy(io_request->LUN, raidLUN, 8);
 	} else {
@@ -2250,12 +2522,15 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 	struct RAID_CONTEXT	*pRAID_Context;
 	struct MR_PD_CFG_SEQ_NUM_SYNC *pd_sync;
+	struct MR_PRIV_DEVICE *mr_device_priv_data;
 	struct fusion_context *fusion = instance->ctrl_context;
 	pd_sync = (void *)fusion->pd_seq_sync[(instance->pd_seq_map_id - 1) & 1];
 
 	device_id = MEGASAS_DEV_INDEX(scmd);
 	pd_index = MEGASAS_PD_INDEX(scmd);
 	os_timeout_value = scmd->request->timeout / HZ;
+	mr_device_priv_data = scmd->device->hostdata;
+	cmd->pd_interface = mr_device_priv_data->interface_type;
 
 	io_request = cmd->io_request;
 	/* get RAID_Context pointer */
@@ -2349,7 +2624,7 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 			struct scsi_cmnd *scp,
 			struct megasas_cmd_fusion *cmd)
 {
-	u16 sge_count;
+	int sge_count;
 	u8  cmd_type;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request = cmd->io_request;
 
@@ -2395,15 +2670,12 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 	 * Construct SGL
 	 */
 
-	sge_count =
-		megasas_make_sgl_fusion(instance, scp,
-					(struct MPI25_IEEE_SGE_CHAIN64 *)
-					&io_request->SGL, cmd);
+	sge_count = megasas_make_sgl(instance, scp, cmd);
 
-	if (sge_count > instance->max_num_sge) {
-		dev_err(&instance->pdev->dev, "Error. sge_count (0x%x) exceeds "
-		       "max (0x%x) allowed\n", sge_count,
-		       instance->max_num_sge);
+	if (sge_count > instance->max_num_sge || (sge_count < 0)) {
+		dev_err(&instance->pdev->dev,
+			"%s %d sge_count (%d) is out of range. Range is:  0-%d\n",
+			__func__, __LINE__, sge_count, instance->max_num_sge);
 		return 1;
 	}
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 9d02967..c606ca0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -702,7 +702,7 @@ struct MPI2_IOC_INIT_REQUEST {
 struct MR_DEV_HANDLE_INFO {
 	__le16	curDevHdl;
 	u8      validHandles;
-	u8      reserved;
+	u8      interfaceType;
 	__le16	devHandle[2];
 };
 
@@ -914,6 +914,7 @@ struct IO_REQUEST_INFO {
 	u16 ldTgtId;
 	u8 isRead;
 	__le16 devHandle;
+	u8 pd_interface;
 	u64 pdBlock;
 	u8 fpOkForIo;
 	u8 IoforUnevenSpan;
@@ -1025,6 +1026,16 @@ struct MR_FW_RAID_MAP_DYNAMIC {
 #define IEEE_SGE_FLAGS_CHAIN_ELEMENT        (0x80)
 #define IEEE_SGE_FLAGS_END_OF_LIST          (0x40)
 
+#define MPI2_SGE_FLAGS_SHIFT                (0x02)
+#define IEEE_SGE_FLAGS_FORMAT_MASK          (0xC0)
+#define IEEE_SGE_FLAGS_FORMAT_IEEE          (0x00)
+#define IEEE_SGE_FLAGS_FORMAT_NVME          (0x02)
+
+#define MPI26_IEEE_SGE_FLAGS_NSF_MASK           (0x1C)
+#define MPI26_IEEE_SGE_FLAGS_NSF_MPI_IEEE       (0x00)
+#define MPI26_IEEE_SGE_FLAGS_NSF_NVME_PRP       (0x08)
+#define MPI26_IEEE_SGE_FLAGS_NSF_NVME_SGL       (0x10)
+
 struct megasas_register_set;
 struct megasas_instance;
 
@@ -1061,6 +1072,7 @@ struct megasas_cmd_fusion {
 	u32 index;
 	u8 pd_r1_lb;
 	struct completion done;
+	u8 pd_interface;
 	u16 r1_alt_dev_handle; /* raid 1/10 only*/
 	bool cmd_completed;  /* raid 1/10 fp writes status holder */
 
-- 
2.8.3
