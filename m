From: sumit.saxena@avagotech.com
Subject: [PATCH 02/12] megaraid_sas : Code optimization- remove PCI Ids
 based checks
Date: Thu, 15 Oct 2015 13:39:34 +0530
Message-ID: <201510150816.t9F8GqPJ029555@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([202.86.248.48]:60965 "EHLO
	rndsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbbJOIUm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 04:20:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Code optimization: remove PCI id based checks and instead of those use instance->ctrl_context to make call whether controller is MFI based OR fusion adapter.
fusion adapters further are also divided in two categories- 1)THUNDERBOLT SERIES and 2)INVADER SERIES.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |  152 ++++++++------------------
 drivers/scsi/megaraid/megaraid_sas_fp.c     |   24 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   40 ++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    6 +
 4 files changed, 76 insertions(+), 146 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d00d494..bc2bb13 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1797,10 +1797,7 @@ void megaraid_sas_kill_hba(struct megasas_instance *instance)
 	msleep(1000);
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
+		(instance->ctrl_context)) {
 		writel(MFI_STOP_ADP, &instance->reg_set->doorbell);
 		/* Flush */
 		readl(&instance->reg_set->doorbell);
@@ -2567,10 +2564,7 @@ static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
 	/*
 	 * First wait for all commands to complete
 	 */
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
-	    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
-	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-	    (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
+	if (instance->ctrl_context)
 		ret = megasas_reset_fusion(scmd->device->host, 1);
 	else
 		ret = megasas_generic_reset(scmd);
@@ -3431,22 +3425,14 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 				(instance->pdev->device ==
 				 PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
-				(instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_FUSION) ||
-				(instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_PLASMA) ||
-				(instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_INVADER) ||
-				(instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_FURY)) {
+				(instance->ctrl_context))
 				writel(
 				  MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
 				  &instance->reg_set->doorbell);
-			} else {
+			else
 				writel(
 				    MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
 					&instance->reg_set->inbound_doorbell);
-			}
 
 			max_wait = MEGASAS_RESET_WAIT_TIME;
 			cur_state = MFI_STATE_WAIT_HANDSHAKE;
@@ -3457,17 +3443,10 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 			     PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 				(instance->pdev->device ==
 				 PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
-			    (instance->pdev->device ==
-			     PCI_DEVICE_ID_LSI_FUSION) ||
-			    (instance->pdev->device ==
-			     PCI_DEVICE_ID_LSI_PLASMA) ||
-			    (instance->pdev->device ==
-			     PCI_DEVICE_ID_LSI_INVADER) ||
-			    (instance->pdev->device ==
-			     PCI_DEVICE_ID_LSI_FURY)) {
+				(instance->ctrl_context))
 				writel(MFI_INIT_HOTPLUG,
 				       &instance->reg_set->doorbell);
-			} else
+			else
 				writel(MFI_INIT_HOTPLUG,
 					&instance->reg_set->inbound_doorbell);
 
@@ -3484,24 +3463,11 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 				(instance->pdev->device ==
 				PCI_DEVICE_ID_LSI_SAS0071SKINNY)  ||
-				(instance->pdev->device
-					== PCI_DEVICE_ID_LSI_FUSION) ||
-				(instance->pdev->device
-					== PCI_DEVICE_ID_LSI_PLASMA) ||
-				(instance->pdev->device
-					== PCI_DEVICE_ID_LSI_INVADER) ||
-				(instance->pdev->device
-					== PCI_DEVICE_ID_LSI_FURY)) {
+				(instance->ctrl_context)) {
 				writel(MFI_RESET_FLAGS,
 					&instance->reg_set->doorbell);
-				if ((instance->pdev->device ==
-					PCI_DEVICE_ID_LSI_FUSION) ||
-					(instance->pdev->device ==
-					PCI_DEVICE_ID_LSI_PLASMA) ||
-					(instance->pdev->device ==
-					PCI_DEVICE_ID_LSI_INVADER) ||
-					(instance->pdev->device ==
-					PCI_DEVICE_ID_LSI_FURY)) {
+
+				if (instance->ctrl_context) {
 					for (i = 0; i < (10 * 1000); i += 20) {
 						if (readl(
 							    &instance->
@@ -3722,11 +3688,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 		memset(cmd->frame, 0, total_sz);
 		cmd->frame->io.context = cpu_to_le32(cmd->index);
 		cmd->frame->io.pad_0 = 0;
-		if ((instance->pdev->device != PCI_DEVICE_ID_LSI_FUSION) &&
-		    (instance->pdev->device != PCI_DEVICE_ID_LSI_PLASMA) &&
-		    (instance->pdev->device != PCI_DEVICE_ID_LSI_INVADER) &&
-			(instance->pdev->device != PCI_DEVICE_ID_LSI_FURY) &&
-		    (reset_devices))
+		if (!instance->ctrl_context && reset_devices)
 			cmd->frame->hdr.cmd = MFI_CMD_INVALID;
 	}
 
@@ -4639,6 +4601,9 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	unsigned long bar_list;
 	int i, loop, fw_msix_count = 0;
 	struct IOV_111 *iovPtr;
+	struct fusion_context *fusion;
+
+	fusion = instance->ctrl_context;
 
 	/* Find first memory bar */
 	bar_list = pci_select_bars(instance->pdev, IORESOURCE_MEM);
@@ -4716,37 +4681,32 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		scratch_pad_2 = readl
 			(&instance->reg_set->outbound_scratch_pad_2);
 		/* Check max MSI-X vectors */
-		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
-		    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA)) {
-			instance->msix_vectors = (scratch_pad_2
-				& MR_MAX_REPLY_QUEUES_OFFSET) + 1;
-			fw_msix_count = instance->msix_vectors;
-			if (msix_vectors)
-				instance->msix_vectors =
-					min(msix_vectors,
-					    instance->msix_vectors);
-		} else if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER)
-			|| (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
-			/* Invader/Fury supports more than 8 MSI-X */
-			instance->msix_vectors = ((scratch_pad_2
-				& MR_MAX_REPLY_QUEUES_EXT_OFFSET)
-				>> MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT) + 1;
-			fw_msix_count = instance->msix_vectors;
-			/* Save 1-15 reply post index address to local memory
-			 * Index 0 is already saved from reg offset
-			 * MPI2_REPLY_POST_HOST_INDEX_OFFSET
-			 */
-			for (loop = 1; loop < MR_MAX_MSIX_REG_ARRAY; loop++) {
-				instance->reply_post_host_index_addr[loop] =
-					(u32 __iomem *)
-					((u8 __iomem *)instance->reg_set +
-					MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET
-					+ (loop * 0x10));
+		if (fusion) {
+			if (fusion->adapter_type == THUNDERBOLT_SERIES) { /* Thunderbolt Series*/
+				instance->msix_vectors = (scratch_pad_2
+					& MR_MAX_REPLY_QUEUES_OFFSET) + 1;
+				fw_msix_count = instance->msix_vectors;
+			} else { /* Invader series supports more than 8 MSI-x vectors*/
+				instance->msix_vectors = ((scratch_pad_2
+					& MR_MAX_REPLY_QUEUES_EXT_OFFSET)
+					>> MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT) + 1;
+				fw_msix_count = instance->msix_vectors;
+				/* Save 1-15 reply post index address to local memory
+				 * Index 0 is already saved from reg offset
+				 * MPI2_REPLY_POST_HOST_INDEX_OFFSET
+				 */
+				for (loop = 1; loop < MR_MAX_MSIX_REG_ARRAY; loop++) {
+					instance->reply_post_host_index_addr[loop] =
+						(u32 __iomem *)
+						((u8 __iomem *)instance->reg_set +
+						MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET
+						+ (loop * 0x10));
+				}
 			}
 			if (msix_vectors)
 				instance->msix_vectors = min(msix_vectors,
 					instance->msix_vectors);
-		} else
+		} else /* MFI adapters */
 			instance->msix_vectors = 1;
 		/* Don't bother allocating more MSI-X vectors than cpus */
 		instance->msix_vectors = min(instance->msix_vectors,
@@ -5241,10 +5201,7 @@ static int megasas_io_attach(struct megasas_instance *instance)
 	host->max_cmd_len = 16;
 
 	/* Fusion only supports host reset */
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
-	    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
-	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-	    (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
+	if (instance->ctrl_context) {
 		host->hostt->eh_device_reset_handler = NULL;
 		host->hostt->eh_bus_reset_handler = NULL;
 	}
@@ -5380,6 +5337,11 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		fusion = instance->ctrl_context;
 		memset(fusion, 0,
 			((1 << PAGE_SHIFT) << instance->ctrl_context_pages));
+		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
+			(instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA))
+			fusion->adapter_type = THUNDERBOLT_SERIES;
+		else
+			fusion->adapter_type = INVADER_SERIES;
 	}
 	break;
 	default: /* For all other supported controllers */
@@ -5482,10 +5444,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	instance->disableOnlineCtrlReset = 1;
 	instance->UnevenSpanSupport = 0;
 
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
-	    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
-	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-	    (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
+	if (instance->ctrl_context) {
 		INIT_WORK(&instance->work_init, megasas_fusion_ocr_wq);
 		INIT_WORK(&instance->crash_init, megasas_fusion_crash_dump_wq);
 	} else
@@ -5565,10 +5524,7 @@ fail_io_attach:
 	instance->instancet->disable_intr(instance);
 	megasas_destroy_irqs(instance);
 
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
-	    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
-	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-	    (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
+	if (instance->ctrl_context)
 		megasas_release_fusion(instance);
 	else
 		megasas_release_mfi(instance);
@@ -5781,12 +5737,7 @@ megasas_resume(struct pci_dev *pdev)
 				  instance->msix_vectors))
 		goto fail_reenable_msix;
 
-	switch (instance->pdev->device) {
-	case PCI_DEVICE_ID_LSI_FUSION:
-	case PCI_DEVICE_ID_LSI_PLASMA:
-	case PCI_DEVICE_ID_LSI_INVADER:
-	case PCI_DEVICE_ID_LSI_FURY:
-	{
+	if (instance->ctrl_context) {
 		megasas_reset_reply_desc(instance);
 		if (megasas_ioc_init_fusion(instance)) {
 			megasas_free_cmds(instance);
@@ -5795,14 +5746,11 @@ megasas_resume(struct pci_dev *pdev)
 		}
 		if (!megasas_get_map_info(instance))
 			megasas_sync_map_info(instance);
-	}
-	break;
-	default:
+	} else {
 		*instance->producer = 0;
 		*instance->consumer = 0;
 		if (megasas_issue_init_mfi(instance))
 			goto fail_init_mfi;
-		break;
 	}
 
 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
@@ -5924,11 +5872,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);
 
-	switch (instance->pdev->device) {
-	case PCI_DEVICE_ID_LSI_FUSION:
-	case PCI_DEVICE_ID_LSI_PLASMA:
-	case PCI_DEVICE_ID_LSI_INVADER:
-	case PCI_DEVICE_ID_LSI_FURY:
+	if (instance->ctrl_context) {
 		megasas_release_fusion(instance);
 			pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
 				(sizeof(struct MR_PD_CFG_SEQ) *
@@ -5950,8 +5894,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 		}
 		free_pages((ulong)instance->ctrl_context,
 			instance->ctrl_context_pages);
-		break;
-	default:
+	} else {
 		megasas_release_mfi(instance);
 		pci_free_consistent(pdev, sizeof(u32),
 				    instance->producer,
@@ -5959,7 +5902,6 @@ static void megasas_detach_one(struct pci_dev *pdev)
 		pci_free_consistent(pdev, sizeof(u32),
 				    instance->consumer,
 				    instance->consumer_h);
-		break;
 	}
 
 	kfree(instance->ctrl_info);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index be57b18..ce5b832 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -741,14 +741,12 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 	u8      physArm, span;
 	u64     row;
 	u8	retval = TRUE;
-	u8	do_invader = 0;
 	u64	*pdBlock = &io_info->pdBlock;
 	__le16	*pDevHandle = &io_info->devHandle;
 	u32	logArm, rowMod, armQ, arm;
+	struct fusion_context *fusion;
 
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER ||
-		instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
-		do_invader = 1;
+	fusion = instance->ctrl_context;
 
 	/*Get row and span from io_info for Uneven Span IO.*/
 	row	    = io_info->start_row;
@@ -779,7 +777,8 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 	else {
 		*pDevHandle = cpu_to_le16(MR_PD_INVALID);
 		if ((raid->level >= 5) &&
-			(!do_invader  || (do_invader &&
+			((fusion->adapter_type == THUNDERBOLT_SERIES)  ||
+			((fusion->adapter_type == INVADER_SERIES) &&
 			(raid->regTypeReqOnRead != REGION_TYPE_UNUSED))))
 			pRAID_Context->regLockFlags = REGION_TYPE_EXCLUSIVE;
 		else if (raid->level == 1) {
@@ -823,13 +822,12 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 	u8          physArm, span;
 	u64         row;
 	u8	    retval = TRUE;
-	u8          do_invader = 0;
 	u64	    *pdBlock = &io_info->pdBlock;
 	__le16	    *pDevHandle = &io_info->devHandle;
+	struct fusion_context *fusion;
+
+	fusion = instance->ctrl_context;
 
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER ||
-		instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
-		do_invader = 1;
 
 	row =  mega_div64_32(stripRow, raid->rowDataSize);
 
@@ -875,7 +873,8 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 		/* set dev handle as invalid. */
 		*pDevHandle = cpu_to_le16(MR_PD_INVALID);
 		if ((raid->level >= 5) &&
-			(!do_invader  || (do_invader &&
+			((fusion->adapter_type == THUNDERBOLT_SERIES)  ||
+			((fusion->adapter_type == INVADER_SERIES) &&
 			(raid->regTypeReqOnRead != REGION_TYPE_UNUSED))))
 			pRAID_Context->regLockFlags = REGION_TYPE_EXCLUSIVE;
 		else if (raid->level == 1) {
@@ -909,6 +908,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 		    struct RAID_CONTEXT *pRAID_Context,
 		    struct MR_DRV_RAID_MAP_ALL *map, u8 **raidLUN)
 {
+	struct fusion_context *fusion;
 	struct MR_LD_RAID  *raid;
 	u32         ld, stripSize, stripe_mask;
 	u64         endLba, endStrip, endRow, start_row, start_strip;
@@ -929,6 +929,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 	isRead = io_info->isRead;
 	io_info->IoforUnevenSpan = 0;
 	io_info->start_span	= SPAN_INVALID;
+	fusion = instance->ctrl_context;
 
 	ld = MR_TargetIdToLdGet(ldTgtId, map);
 	raid = MR_LdRaidGet(ld, map);
@@ -1092,8 +1093,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 		cpu_to_le16(raid->fpIoTimeoutForLd ?
 			    raid->fpIoTimeoutForLd :
 			    map->raidMap.fpPdIoTimeoutSec);
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
+	if (fusion->adapter_type == INVADER_SERIES)
 		pRAID_Context->regLockFlags = (isRead) ?
 			raid->regTypeReqOnRead : raid->regTypeReqOnWrite;
 	else
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 1398950..365ec52 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -653,8 +653,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	drv_ops = (MFI_CAPABILITIES *) &(init_frame->driver_operations);
 
 	/* driver support Extended MSIX */
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
+	if (fusion->adapter_type == INVADER_SERIES)
 		drv_ops->mfi_capabilities.support_additional_msix = 1;
 	/* driver supports HA / Remote LUN over Fast Path interface */
 	drv_ops->mfi_capabilities.support_fp_remote_lun = 1;
@@ -1288,8 +1287,7 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
 
 	fusion = instance->ctrl_context;
 
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
+	if (fusion->adapter_type == INVADER_SERIES) {
 		struct MPI25_IEEE_SGE_CHAIN64 *sgl_ptr_end = sgl_ptr;
 		sgl_ptr_end += fusion->max_sge_in_main_msg - 1;
 		sgl_ptr_end->Flags = 0;
@@ -1306,11 +1304,9 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
 		sgl_ptr->Length = cpu_to_le32(sg_dma_len(os_sgl));
 		sgl_ptr->Address = cpu_to_le64(sg_dma_address(os_sgl));
 		sgl_ptr->Flags = 0;
-		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-			(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
+		if (fusion->adapter_type == INVADER_SERIES)
 			if (i == sge_count - 1)
 				sgl_ptr->Flags = IEEE_SGE_FLAGS_END_OF_LIST;
-		}
 		sgl_ptr++;
 
 		sg_processed = i + 1;
@@ -1319,10 +1315,7 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
 		    (sge_count > fusion->max_sge_in_main_msg)) {
 
 			struct MPI25_IEEE_SGE_CHAIN64 *sg_chain;
-			if ((instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_INVADER) ||
-				(instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_FURY)) {
+			if (fusion->adapter_type == INVADER_SERIES) {
 				if ((le16_to_cpu(cmd->io_request->IoFlags) &
 					MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH) !=
 					MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH)
@@ -1338,10 +1331,7 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
 			sg_chain = sgl_ptr;
 			/* Prepare chain element */
 			sg_chain->NextChainOffset = 0;
-			if ((instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_INVADER) ||
-				(instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_FURY))
+			if (fusion->adapter_type == INVADER_SERIES)
 				sg_chain->Flags = IEEE_SGE_FLAGS_CHAIN_ELEMENT;
 			else
 				sg_chain->Flags =
@@ -1658,8 +1648,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY
 			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
-		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-			(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
+		if (fusion->adapter_type == INVADER_SERIES) {
 			if (io_request->RaidContext.regLockFlags ==
 			    REGION_TYPE_UNUSED)
 				cmd->request_desc->SCSIIO.RequestFlags =
@@ -1700,8 +1689,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MEGASAS_REQ_DESCRIPT_FLAGS_LD_IO
 			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
-		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-			(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
+		if (fusion->adapter_type == INVADER_SERIES) {
 			if (io_request->RaidContext.regLockFlags ==
 			    REGION_TYPE_UNUSED)
 				cmd->request_desc->SCSIIO.RequestFlags =
@@ -1890,8 +1878,7 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 		pRAID_Context->timeoutValue =
 			cpu_to_le16((os_timeout_value > timeout_limit) ?
 			timeout_limit : os_timeout_value);
-		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-			(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
+		if (fusion->adapter_type == INVADER_SERIES) {
 			pRAID_Context->Type = MPI2_TYPE_CUDA;
 			pRAID_Context->nseg = 0x1;
 			io_request->IoFlags |=
@@ -2209,10 +2196,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 		 * pending to be completed
 		 */
 		if (threshold_reply_count >= THRESHOLD_REPLY_COUNT) {
-			if ((instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_INVADER) ||
-				(instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_FURY))
+			if (fusion->adapter_type == INVADER_SERIES)
 				writel(((MSIxIndex & 0x7) << 24) |
 					fusion->last_reply_idx[MSIxIndex],
 					instance->reply_post_host_index_addr[MSIxIndex/8]);
@@ -2228,8 +2212,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 		return IRQ_NONE;
 
 	wmb();
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
+	if (fusion->adapter_type == INVADER_SERIES)
 		writel(((MSIxIndex & 0x7) << 24) |
 			fusion->last_reply_idx[MSIxIndex],
 			instance->reply_post_host_index_addr[MSIxIndex/8]);
@@ -2352,8 +2335,7 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 
 	io_req = cmd->io_request;
 
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
+	if (fusion->adapter_type == INVADER_SERIES) {
 		struct MPI25_IEEE_SGE_CHAIN64 *sgl_ptr_end =
 			(struct MPI25_IEEE_SGE_CHAIN64 *)&io_req->SGL;
 		sgl_ptr_end += fusion->max_sge_in_main_msg - 1;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 7d89c1c..473005c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -96,6 +96,11 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
 #define THRESHOLD_REPLY_COUNT 50
 #define JBOD_MAPS_COUNT	2
 
+enum MR_FUSION_ADAPTER_TYPE {
+	THUNDERBOLT_SERIES = 0,
+	INVADER_SERIES = 1,
+};
+
 /*
  * Raid Context structure which describes MegaRAID specific IO Parameters
  * This resides at offset 0x60 where the SGL normally starts in MPT IO Frames
@@ -857,6 +862,7 @@ struct fusion_context {
 	u8 fast_path_io;
 	struct LD_LOAD_BALANCE_INFO load_balance_info[MAX_LOGICAL_DRIVES_EXT];
 	LD_SPAN_INFO log_to_span[MAX_LOGICAL_DRIVES_EXT];
+	u8 adapter_type;
 };
 
 union desc_value {
-- 
1.7.1

