From: adam radford <aradford@gmail.com>
Subject: [PATCH 7/10] megaraid_sas: Add support for MegaRAID 9360/9380 12GB/s controllers
Date: Sat, 8 Oct 2011 18:15:06 -0700
Message-ID: <CAHtARFHZCGBbaHEQOOydB7J8DeYgKgT=9FwHmiP7h7THcWMF=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6de03a4a16dea04aed36718
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62149 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1JIBPH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2011 21:15:07 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so4924347wyg.19
        for <linux-scsi@vger.kernel.org>; Sat, 08 Oct 2011 18:15:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e6de03a4a16dea04aed36718
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas adds support for MegaRAID
9360/9380 12GB/s SAS-RAID controllers.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-08
14:16:11.739236563 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-08
13:32:11.415175492 -0700
@@ -114,6 +114,8 @@
 	/* xscale IOP */
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FUSION)},
 	/* Fusion */
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_INVADER)},
+	/* Invader */
 	{}
 };

@@ -1583,7 +1585,8 @@
 {
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 	    (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
-	    (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION)) {
+	    (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
+	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER)) {
 		writel(MFI_STOP_ADP, &instance->reg_set->doorbell);
 	} else {
 		writel(MFI_STOP_ADP, &instance->reg_set->inbound_doorbell);
@@ -1957,7 +1960,8 @@
 	/*
 	 * First wait for all commands to complete
 	 */
-	if (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION)
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
+	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER))
 		ret = megasas_reset_fusion(scmd->device->host);
 	else
 		ret = megasas_generic_reset(scmd);
@@ -2656,7 +2660,9 @@
 				(instance->pdev->device ==
 				 PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
 				(instance->pdev->device ==
-				 PCI_DEVICE_ID_LSI_FUSION)) {
+				 PCI_DEVICE_ID_LSI_FUSION) ||
+				(instance->pdev->device ==
+				PCI_DEVICE_ID_LSI_INVADER)) {
 				writel(
 				  MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
 				  &instance->reg_set->doorbell);
@@ -2676,7 +2682,9 @@
 				(instance->pdev->device ==
 				 PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
 			    (instance->pdev->device ==
-			     PCI_DEVICE_ID_LSI_FUSION)) {
+			     PCI_DEVICE_ID_LSI_FUSION) ||
+			    (instance->pdev->device ==
+			     PCI_DEVICE_ID_LSI_INVADER)) {
 				writel(MFI_INIT_HOTPLUG,
 				       &instance->reg_set->doorbell);
 			} else
@@ -2697,11 +2705,15 @@
 				(instance->pdev->device ==
 				PCI_DEVICE_ID_LSI_SAS0071SKINNY)  ||
 				(instance->pdev->device
-					== PCI_DEVICE_ID_LSI_FUSION)) {
+					== PCI_DEVICE_ID_LSI_FUSION) ||
+				(instance->pdev->device
+					== PCI_DEVICE_ID_LSI_INVADER)) {
 				writel(MFI_RESET_FLAGS,
 					&instance->reg_set->doorbell);
-				if (instance->pdev->device ==
-				    PCI_DEVICE_ID_LSI_FUSION) {
+				if ((instance->pdev->device ==
+				    PCI_DEVICE_ID_LSI_FUSION) ||
+				    (instance->pdev->device ==
+				     PCI_DEVICE_ID_LSI_INVADER)) {
 					for (i = 0; i < (10 * 1000); i += 20) {
 						if (readl(
 							    &instance->
@@ -3498,6 +3510,7 @@

 	switch (instance->pdev->device) {
 	case PCI_DEVICE_ID_LSI_FUSION:
+	case PCI_DEVICE_ID_LSI_INVADER:
 		instance->instancet = &megasas_instance_template_fusion;
 		break;
 	case PCI_DEVICE_ID_LSI_SAS1078R:
@@ -3894,7 +3907,8 @@
 	host->max_cmd_len = 16;

 	/* Fusion only supports host reset */
-	if (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) {
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
+	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER)) {
 		host->hostt->eh_device_reset_handler = NULL;
 		host->hostt->eh_bus_reset_handler = NULL;
 	}
@@ -4004,6 +4018,7 @@

 	switch (instance->pdev->device) {
 	case PCI_DEVICE_ID_LSI_FUSION:
+	case PCI_DEVICE_ID_LSI_INVADER:
 	{
 		struct fusion_context *fusion;

@@ -4096,7 +4111,8 @@
 	instance->last_time = 0;
 	instance->disableOnlineCtrlReset = 1;

-	if (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION)
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
+	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER))
 		INIT_WORK(&instance->work_init, megasas_fusion_ocr_wq);
 	else
 		INIT_WORK(&instance->work_init, process_fw_state_change_wq);
@@ -4161,7 +4177,8 @@
 	free_irq(instance->msi_flag ? instance->msixentry.vector :
 		 instance->pdev->irq, instance);
 fail_irq:
-	if (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION)
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
+	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER))
 		megasas_release_fusion(instance);
 	else
 		megasas_release_mfi(instance);
@@ -4368,6 +4385,7 @@

 	switch (instance->pdev->device) {
 	case PCI_DEVICE_ID_LSI_FUSION:
+	case PCI_DEVICE_ID_LSI_INVADER:
 	{
 		megasas_reset_reply_desc(instance);
 		if (megasas_ioc_init_fusion(instance)) {
@@ -4501,6 +4519,7 @@

 	switch (instance->pdev->device) {
 	case PCI_DEVICE_ID_LSI_FUSION:
+	case PCI_DEVICE_ID_LSI_INVADER:
 		megasas_release_fusion(instance);
 		for (i = 0; i < 2 ; i++)
 			if (fusion->ld_map[i])
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fp.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fp.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fp.c	2011-10-08
14:16:11.739236563 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fp.c	2011-10-08
13:38:06.168176264 -0700
@@ -52,6 +52,7 @@
 #include <scsi/scsi_host.h>

 #include "megaraid_sas_fusion.h"
+#include "megaraid_sas.h"
 #include <asm/div64.h>

 #define ABS_DIFF(a, b)   (((a) > (b)) ? ((a) - (b)) : ((b) - (a)))
@@ -226,8 +227,9 @@
 *    span          - Span number
 *    block         - Absolute Block number in the physical disk
 */
-u8 MR_GetPhyParams(u32 ld, u64 stripRow, u16 stripRef, u64 *pdBlock,
-		   u16 *pDevHandle, struct RAID_CONTEXT *pRAID_Context,
+u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
+		   u16 stripRef, u64 *pdBlock, u16 *pDevHandle,
+		   struct RAID_CONTEXT *pRAID_Context,
 		   struct MR_FW_RAID_MAP_ALL *map)
 {
 	struct MR_LD_RAID  *raid = MR_LdRaidGet(ld, map);
@@ -279,7 +281,8 @@
 		*pDevHandle = MR_PdDevHandleGet(pd, map);
 	else {
 		*pDevHandle = MR_PD_INVALID; /* set dev handle as invalid. */
-		if (raid->level >= 5)
+		if ((raid->level >= 5) &&
+		    (instance->pdev->device != PCI_DEVICE_ID_LSI_INVADER))
 			pRAID_Context->regLockFlags = REGION_TYPE_EXCLUSIVE;
 		else if (raid->level == 1) {
 			/* Get alternate Pd. */
@@ -306,7 +309,8 @@
 * This function will return 0 if region lock was acquired OR return num strips
 */
 u8
-MR_BuildRaidContext(struct IO_REQUEST_INFO *io_info,
+MR_BuildRaidContext(struct megasas_instance *instance,
+		    struct IO_REQUEST_INFO *io_info,
 		    struct RAID_CONTEXT *pRAID_Context,
 		    struct MR_FW_RAID_MAP_ALL *map)
 {
@@ -394,8 +398,12 @@
 	}

 	pRAID_Context->timeoutValue     = map->raidMap.fpPdIoTimeoutSec;
-	pRAID_Context->regLockFlags     = (isRead) ? REGION_TYPE_SHARED_READ :
-		raid->regTypeReqOnWrite;
+	if (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER)
+		pRAID_Context->regLockFlags = (isRead) ?
+			raid->regTypeReqOnRead : raid->regTypeReqOnWrite;
+	else
+		pRAID_Context->regLockFlags = (isRead) ?
+			REGION_TYPE_SHARED_READ : raid->regTypeReqOnWrite;
 	pRAID_Context->VirtualDiskTgtId = raid->targetId;
 	pRAID_Context->regLockRowLBA    = regStart;
 	pRAID_Context->regLockLength    = regSize;
@@ -404,7 +412,8 @@
 	/*Get Phy Params only if FP capable, or else leave it to MR firmware
 	  to do the calculation.*/
 	if (io_info->fpOkForIo) {
-		retval = MR_GetPhyParams(ld, start_strip, ref_in_start_stripe,
+		retval = MR_GetPhyParams(instance, ld, start_strip,
+					 ref_in_start_stripe,
 					 &io_info->pdBlock,
 					 &io_info->devHandle, pRAID_Context,
 					 map);
@@ -415,7 +424,8 @@
 	} else if (isRead) {
 		uint stripIdx;
 		for (stripIdx = 0; stripIdx < num_strips; stripIdx++) {
-			if (!MR_GetPhyParams(ld, start_strip + stripIdx,
+			if (!MR_GetPhyParams(instance, ld,
+					     start_strip + stripIdx,
 					     ref_in_start_stripe,
 					     &io_info->pdBlock,
 					     &io_info->devHandle,
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-08
14:16:11.740236506 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-08
14:15:52.176174272 -0700
@@ -74,7 +74,8 @@
 		     struct megasas_cmd *cmd);

 u8
-MR_BuildRaidContext(struct IO_REQUEST_INFO *io_info,
+MR_BuildRaidContext(struct megasas_instance *instance,
+		    struct IO_REQUEST_INFO *io_info,
 		    struct RAID_CONTEXT *pRAID_Context,
 		    struct MR_FW_RAID_MAP_ALL *map);
 u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map);
@@ -1038,7 +1039,9 @@
 	case MFI_STAT_DEVICE_NOT_FOUND:
 		cmd->scmd->result = DID_BAD_TARGET << 16;
 		break;
-
+	case MFI_STAT_CONFIG_SEQ_MISMATCH:
+		cmd->scmd->result = DID_IMM_RETRY << 16;
+		break;
 	default:
 		printk(KERN_DEBUG "megasas: FW status %#x\n", status);
 		cmd->scmd->result = DID_ERROR << 16;
@@ -1061,14 +1064,17 @@
 			struct MPI25_IEEE_SGE_CHAIN64 *sgl_ptr,
 			struct megasas_cmd_fusion *cmd)
 {
-	int i, sg_processed;
-	int sge_count, sge_idx;
+	int i, sg_processed, sge_count;
 	struct scatterlist *os_sgl;
 	struct fusion_context *fusion;

 	fusion = instance->ctrl_context;

-	cmd->io_request->ChainOffset = 0;
+	if (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) {
+		struct MPI25_IEEE_SGE_CHAIN64 *sgl_ptr_end = sgl_ptr;
+		sgl_ptr_end += fusion->max_sge_in_main_msg - 1;
+		sgl_ptr_end->Flags = 0;
+	}

 	sge_count = scsi_dma_map(scp);

@@ -1077,16 +1083,14 @@
 	if (sge_count > instance->max_num_sge || !sge_count)
 		return sge_count;

-	if (sge_count > fusion->max_sge_in_main_msg) {
-		/* One element to store the chain info */
-		sge_idx = fusion->max_sge_in_main_msg - 1;
-	} else
-		sge_idx = sge_count;
-
 	scsi_for_each_sg(scp, os_sgl, sge_count, i) {
 		sgl_ptr->Length = sg_dma_len(os_sgl);
 		sgl_ptr->Address = sg_dma_address(os_sgl);
 		sgl_ptr->Flags = 0;
+		if (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) {
+			if (i == sge_count - 1)
+				sgl_ptr->Flags = IEEE_SGE_FLAGS_END_OF_LIST;
+		}
 		sgl_ptr++;

 		sg_processed = i + 1;
@@ -1095,13 +1099,30 @@
 		    (sge_count > fusion->max_sge_in_main_msg)) {

 			struct MPI25_IEEE_SGE_CHAIN64 *sg_chain;
-			cmd->io_request->ChainOffset =
-				fusion->chain_offset_io_request;
+			if (instance->pdev->device ==
+			    PCI_DEVICE_ID_LSI_INVADER) {
+				if ((cmd->io_request->IoFlags &
+				MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH) !=
+				MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH)
+					cmd->io_request->ChainOffset =
+						fusion->
+						chain_offset_io_request;
+				else
+					cmd->io_request->ChainOffset = 0;
+			} else
+				cmd->io_request->ChainOffset =
+					fusion->chain_offset_io_request;
+
 			sg_chain = sgl_ptr;
 			/* Prepare chain element */
 			sg_chain->NextChainOffset = 0;
-			sg_chain->Flags = (IEEE_SGE_FLAGS_CHAIN_ELEMENT |
-					   MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR);
+			if (instance->pdev->device ==
+			    PCI_DEVICE_ID_LSI_INVADER)
+				sg_chain->Flags = IEEE_SGE_FLAGS_CHAIN_ELEMENT;
+			else
+				sg_chain->Flags =
+					(IEEE_SGE_FLAGS_CHAIN_ELEMENT |
+					 MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR);
 			sg_chain->Length =  (sizeof(union MPI2_SGE_IO_UNION)
 					     *(sge_count - sg_processed));
 			sg_chain->Address = cmd->sg_frame_phys_addr;
@@ -1394,7 +1415,8 @@
 		io_request->RaidContext.regLockFlags  = 0;
 		fp_possible = 0;
 	} else {
-		if (MR_BuildRaidContext(&io_info, &io_request->RaidContext,
+		if (MR_BuildRaidContext(instance, &io_info,
+					&io_request->RaidContext,
 					local_map_ptr))
 			fp_possible = io_info.fpOkForIo;
 	}
@@ -1407,6 +1429,20 @@
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY
 			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+		if (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) {
+			if (io_request->RaidContext.regLockFlags ==
+			    REGION_TYPE_UNUSED)
+				cmd->request_desc->SCSIIO.RequestFlags =
+					(MEGASAS_REQ_DESCRIPT_FLAGS_NO_LOCK <<
+					MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+			io_request->RaidContext.Type = MPI2_TYPE_CUDA;
+			io_request->RaidContext.nseg = 0x1;
+			io_request->IoFlags |=
+			  MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH;
+			io_request->RaidContext.regLockFlags |=
+			  (MR_RL_FLAGS_GRANT_DESTINATION_CUDA |
+			   MR_RL_FLAGS_SEQ_NUM_ENABLE);
+		}
 		if ((fusion->load_balance_info[device_id].loadBalanceFlag) &&
 		    (io_info.isRead)) {
 			io_info.devHandle =
@@ -1421,11 +1457,23 @@
 	} else {
 		io_request->RaidContext.timeoutValue =
 			local_map_ptr->raidMap.fpPdIoTimeoutSec;
-		io_request->Function = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
-		io_request->DevHandle = device_id;
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MEGASAS_REQ_DESCRIPT_FLAGS_LD_IO
 			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+		if (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) {
+			if (io_request->RaidContext.regLockFlags ==
+			    REGION_TYPE_UNUSED)
+				cmd->request_desc->SCSIIO.RequestFlags =
+					(MEGASAS_REQ_DESCRIPT_FLAGS_NO_LOCK <<
+					MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+			io_request->RaidContext.Type = MPI2_TYPE_CUDA;
+			io_request->RaidContext.regLockFlags |=
+				(MR_RL_FLAGS_GRANT_DESTINATION_CPU0 |
+				 MR_RL_FLAGS_SEQ_NUM_ENABLE);
+			io_request->RaidContext.nseg = 0x1;
+		}
+		io_request->Function = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
+		io_request->DevHandle = device_id;
 	} /* Not FP */
 }

@@ -1508,8 +1556,10 @@
 	io_request->EEDPFlags = 0;
 	io_request->Control = 0;
 	io_request->EEDPBlockSize = 0;
-	io_request->IoFlags = 0;
+	io_request->ChainOffset = 0;
 	io_request->RaidContext.RAIDFlags = 0;
+	io_request->RaidContext.Type = 0;
+	io_request->RaidContext.nseg = 0;

 	memcpy(io_request->CDB.CDB32, scp->cmnd, scp->cmd_len);
 	/*
@@ -1863,6 +1913,14 @@

 	fusion = instance->ctrl_context;
 	io_req = cmd->io_request;
+
+	if (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) {
+		struct MPI25_IEEE_SGE_CHAIN64 *sgl_ptr_end =
+			(struct MPI25_IEEE_SGE_CHAIN64 *)&io_req->SGL;
+		sgl_ptr_end += fusion->max_sge_in_main_msg - 1;
+		sgl_ptr_end->Flags = 0;
+	}
+
 	mpi25_ieee_chain =
 	  (struct MPI25_IEEE_SGE_CHAIN64 *)&io_req->SGL.IeeeChain;

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.h
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.h
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.h	2011-10-08
14:16:11.741236471 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.h	2011-10-08
13:54:41.306174922 -0700
@@ -44,6 +44,14 @@
 #define HOST_DIAG_RESET_ADAPTER			    0x4
 #define MEGASAS_FUSION_MAX_RESET_TRIES		    3

+/* Invader defines */
+#define MPI2_TYPE_CUDA				    0x2
+#define MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH   0x4000
+#define	MR_RL_FLAGS_GRANT_DESTINATION_CPU0	    0x00
+#define	MR_RL_FLAGS_GRANT_DESTINATION_CPU1	    0x10
+#define	MR_RL_FLAGS_GRANT_DESTINATION_CUDA	    0x80
+#define MR_RL_FLAGS_SEQ_NUM_ENABLE		    0x8
+
 /* T10 PI defines */
 #define MR_PROT_INFO_TYPE_CONTROLLER                0x8
 #define MEGASAS_SCSI_VARIABLE_LENGTH_CMD            0x7f
@@ -70,7 +78,7 @@
  */
 #define MEGASAS_REQ_DESCRIPT_FLAGS_LD_IO           0x7
 #define MEGASAS_REQ_DESCRIPT_FLAGS_MFA             0x1
-
+#define MEGASAS_REQ_DESCRIPT_FLAGS_NO_LOCK	   0x2
 #define MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT      1

 #define MEGASAS_FP_CMD_LEN	16
@@ -82,7 +90,9 @@
  */

 struct RAID_CONTEXT {
-	u16     resvd0;
+	u8	Type:4;
+	u8	nseg:4;
+	u8	resvd0;
 	u16     timeoutValue;
 	u8      regLockFlags;
 	u8      resvd1;
@@ -527,7 +537,7 @@
 	u8      ldState;
 	u8      regTypeReqOnWrite;
 	u8      modFactor;
-	u8      reserved2[1];
+	u8	regTypeReqOnRead;
 	u16     seqNum;

 	struct {
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h	2011-10-08
14:16:11.742236470 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2011-10-08
13:55:57.919176024 -0700
@@ -48,6 +48,7 @@
 #define	PCI_DEVICE_ID_LSI_SAS0073SKINNY		0x0073
 #define	PCI_DEVICE_ID_LSI_SAS0071SKINNY		0x0071
 #define	PCI_DEVICE_ID_LSI_FUSION		0x005b
+#define PCI_DEVICE_ID_LSI_INVADER		0x005d

 /*
  * =====================================
@@ -221,6 +222,7 @@
 	MFI_STAT_RESERVATION_IN_PROGRESS = 0x36,
 	MFI_STAT_I2C_ERRORS_DETECTED = 0x37,
 	MFI_STAT_PCI_ERRORS_DETECTED = 0x38,
+	MFI_STAT_CONFIG_SEQ_MISMATCH = 0x67,

 	MFI_STAT_INVALID_STATUS = 0xFF
 };

--0016e6de03a4a16dea04aed36718
Content-Type: application/octet-stream; name="megaraid_sas.patch7"
Content-Disposition: attachment; filename="megaraid_sas.patch7"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtjbzufz0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMTAtMDggMTQ6MTY6MTEuNzM5MjM2NTYzIC0wNzAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTEwLTA4IDEzOjMyOjExLjQxNTE3NTQ5MiAtMDcwMApAQCAtMTE0LDYgKzExNCw4IEBA
CiAJLyogeHNjYWxlIElPUCAqLwogCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfTFNJX0xPR0lD
LCBQQ0lfREVWSUNFX0lEX0xTSV9GVVNJT04pfSwKIAkvKiBGdXNpb24gKi8KKwl7UENJX0RFVklD
RShQQ0lfVkVORE9SX0lEX0xTSV9MT0dJQywgUENJX0RFVklDRV9JRF9MU0lfSU5WQURFUil9LAor
CS8qIEludmFkZXIgKi8KIAl7fQogfTsKIApAQCAtMTU4Myw3ICsxNTg1LDggQEAKIHsKIAlpZiAo
KGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3M1NLSU5O
WSkgfHwKIAkgICAgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lf
U0FTMDA3MVNLSU5OWSkgfHwKLQkgICAgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RF
VklDRV9JRF9MU0lfRlVTSU9OKSkgeworCSAgICAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQ
Q0lfREVWSUNFX0lEX0xTSV9GVVNJT04pIHx8CisJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNl
ID09IFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIpKSB7CiAJCXdyaXRlbChNRklfU1RPUF9BRFAs
ICZpbnN0YW5jZS0+cmVnX3NldC0+ZG9vcmJlbGwpOwogCX0gZWxzZSB7CiAJCXdyaXRlbChNRklf
U1RPUF9BRFAsICZpbnN0YW5jZS0+cmVnX3NldC0+aW5ib3VuZF9kb29yYmVsbCk7CkBAIC0xOTU3
LDcgKzE5NjAsOCBAQAogCS8qCiAJICogRmlyc3Qgd2FpdCBmb3IgYWxsIGNvbW1hbmRzIHRvIGNv
bXBsZXRlCiAJICovCi0JaWYgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9J
RF9MU0lfRlVTSU9OKQorCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNF
X0lEX0xTSV9GVVNJT04pIHx8CisJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9E
RVZJQ0VfSURfTFNJX0lOVkFERVIpKQogCQlyZXQgPSBtZWdhc2FzX3Jlc2V0X2Z1c2lvbihzY21k
LT5kZXZpY2UtPmhvc3QpOwogCWVsc2UKIAkJcmV0ID0gbWVnYXNhc19nZW5lcmljX3Jlc2V0KHNj
bWQpOwpAQCAtMjY1Niw3ICsyNjYwLDkgQEAKIAkJCQkoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9
PQogCQkJCSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5ZKSB8fAogCQkJCShpbnN0YW5j
ZS0+cGRldi0+ZGV2aWNlID09Ci0JCQkJIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTikpIHsKKwkJ
CQkgUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKSB8fAorCQkJCShpbnN0YW5jZS0+cGRldi0+ZGV2
aWNlID09CisJCQkJUENJX0RFVklDRV9JRF9MU0lfSU5WQURFUikpIHsKIAkJCQl3cml0ZWwoCiAJ
CQkJICBNRklfSU5JVF9DTEVBUl9IQU5EU0hBS0V8TUZJX0lOSVRfSE9UUExVRywKIAkJCQkgICZp
bnN0YW5jZS0+cmVnX3NldC0+ZG9vcmJlbGwpOwpAQCAtMjY3Niw3ICsyNjgyLDkgQEAKIAkJCQko
aW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQogCQkJCSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDcx
U0tJTk5ZKSB8fAogCQkJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09Ci0JCQkgICAgIFBD
SV9ERVZJQ0VfSURfTFNJX0ZVU0lPTikpIHsKKwkJCSAgICAgUENJX0RFVklDRV9JRF9MU0lfRlVT
SU9OKSB8fAorCQkJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09CisJCQkgICAgIFBDSV9E
RVZJQ0VfSURfTFNJX0lOVkFERVIpKSB7CiAJCQkJd3JpdGVsKE1GSV9JTklUX0hPVFBMVUcsCiAJ
CQkJICAgICAgICZpbnN0YW5jZS0+cmVnX3NldC0+ZG9vcmJlbGwpOwogCQkJfSBlbHNlCkBAIC0y
Njk3LDExICsyNzA1LDE1IEBACiAJCQkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0KIAkJCQlQ
Q0lfREVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5ZKSAgfHwKIAkJCQkoaW5zdGFuY2UtPnBkZXYt
PmRldmljZQotCQkJCQk9PSBQQ0lfREVWSUNFX0lEX0xTSV9GVVNJT04pKSB7CisJCQkJCT09IFBD
SV9ERVZJQ0VfSURfTFNJX0ZVU0lPTikgfHwKKwkJCQkoaW5zdGFuY2UtPnBkZXYtPmRldmljZQor
CQkJCQk9PSBQQ0lfREVWSUNFX0lEX0xTSV9JTlZBREVSKSkgewogCQkJCXdyaXRlbChNRklfUkVT
RVRfRkxBR1MsCiAJCQkJCSZpbnN0YW5jZS0+cmVnX3NldC0+ZG9vcmJlbGwpOwotCQkJCWlmIChp
bnN0YW5jZS0+cGRldi0+ZGV2aWNlID09Ci0JCQkJICAgIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lP
TikgeworCQkJCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQorCQkJCSAgICBQQ0lfREVW
SUNFX0lEX0xTSV9GVVNJT04pIHx8CisJCQkJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09
CisJCQkJICAgICBQQ0lfREVWSUNFX0lEX0xTSV9JTlZBREVSKSkgewogCQkJCQlmb3IgKGkgPSAw
OyBpIDwgKDEwICogMTAwMCk7IGkgKz0gMjApIHsKIAkJCQkJCWlmIChyZWFkbCgKIAkJCQkJCQkg
ICAgJmluc3RhbmNlLT4KQEAgLTM0OTgsNiArMzUxMCw3IEBACiAKIAlzd2l0Y2ggKGluc3RhbmNl
LT5wZGV2LT5kZXZpY2UpIHsKIAljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTjoKKwljYXNl
IFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVI6CiAJCWluc3RhbmNlLT5pbnN0YW5jZXQgPSAmbWVn
YXNhc19pbnN0YW5jZV90ZW1wbGF0ZV9mdXNpb247CiAJCWJyZWFrOwogCWNhc2UgUENJX0RFVklD
RV9JRF9MU0lfU0FTMTA3OFI6CkBAIC0zODk0LDcgKzM5MDcsOCBAQAogCWhvc3QtPm1heF9jbWRf
bGVuID0gMTY7CiAKIAkvKiBGdXNpb24gb25seSBzdXBwb3J0cyBob3N0IHJlc2V0ICovCi0JaWYg
KGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKSB7CisJ
aWYgKChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTikg
fHwKKwkgICAgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfSU5W
QURFUikpIHsKIAkJaG9zdC0+aG9zdHQtPmVoX2RldmljZV9yZXNldF9oYW5kbGVyID0gTlVMTDsK
IAkJaG9zdC0+aG9zdHQtPmVoX2J1c19yZXNldF9oYW5kbGVyID0gTlVMTDsKIAl9CkBAIC00MDA0
LDYgKzQwMTgsNyBAQAogCiAJc3dpdGNoIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlKSB7CiAJY2Fz
ZSBQQ0lfREVWSUNFX0lEX0xTSV9GVVNJT046CisJY2FzZSBQQ0lfREVWSUNFX0lEX0xTSV9JTlZB
REVSOgogCXsKIAkJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CiAKQEAgLTQwOTYsNyAr
NDExMSw4IEBACiAJaW5zdGFuY2UtPmxhc3RfdGltZSA9IDA7CiAJaW5zdGFuY2UtPmRpc2FibGVP
bmxpbmVDdHJsUmVzZXQgPSAxOwogCi0JaWYgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJ
X0RFVklDRV9JRF9MU0lfRlVTSU9OKQorCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQ
Q0lfREVWSUNFX0lEX0xTSV9GVVNJT04pIHx8CisJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNl
ID09IFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIpKQogCQlJTklUX1dPUksoJmluc3RhbmNlLT53
b3JrX2luaXQsIG1lZ2FzYXNfZnVzaW9uX29jcl93cSk7CiAJZWxzZQogCQlJTklUX1dPUksoJmlu
c3RhbmNlLT53b3JrX2luaXQsIHByb2Nlc3NfZndfc3RhdGVfY2hhbmdlX3dxKTsKQEAgLTQxNjEs
NyArNDE3Nyw4IEBACiAJZnJlZV9pcnEoaW5zdGFuY2UtPm1zaV9mbGFnID8gaW5zdGFuY2UtPm1z
aXhlbnRyeS52ZWN0b3IgOgogCQkgaW5zdGFuY2UtPnBkZXYtPmlycSwgaW5zdGFuY2UpOwogZmFp
bF9pcnE6Ci0JaWYgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lf
RlVTSU9OKQorCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xT
SV9GVVNJT04pIHx8CisJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0Vf
SURfTFNJX0lOVkFERVIpKQogCQltZWdhc2FzX3JlbGVhc2VfZnVzaW9uKGluc3RhbmNlKTsKIAll
bHNlCiAJCW1lZ2FzYXNfcmVsZWFzZV9tZmkoaW5zdGFuY2UpOwpAQCAtNDM2OCw2ICs0Mzg1LDcg
QEAKIAogCXN3aXRjaCAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSkgewogCWNhc2UgUENJX0RFVklD
RV9JRF9MU0lfRlVTSU9OOgorCWNhc2UgUENJX0RFVklDRV9JRF9MU0lfSU5WQURFUjoKIAl7CiAJ
CW1lZ2FzYXNfcmVzZXRfcmVwbHlfZGVzYyhpbnN0YW5jZSk7CiAJCWlmIChtZWdhc2FzX2lvY19p
bml0X2Z1c2lvbihpbnN0YW5jZSkpIHsKQEAgLTQ1MDEsNiArNDUxOSw3IEBACiAKIAlzd2l0Y2gg
KGluc3RhbmNlLT5wZGV2LT5kZXZpY2UpIHsKIAljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lP
TjoKKwljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVI6CiAJCW1lZ2FzYXNfcmVsZWFzZV9m
dXNpb24oaW5zdGFuY2UpOwogCQlmb3IgKGkgPSAwOyBpIDwgMiA7IGkrKykKIAkJCWlmIChmdXNp
b24tPmxkX21hcFtpXSkKZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfZnAuYyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVn
YXJhaWQvbWVnYXJhaWRfc2FzX2ZwLmMKLS0tIHNjc2ktbWlzYy0yLjYvZHJpdmVycy9zY3NpL21l
Z2FyYWlkL21lZ2FyYWlkX3Nhc19mcC5jCTIwMTEtMTAtMDggMTQ6MTY6MTEuNzM5MjM2NTYzIC0w
NzAwCisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzX2ZwLmMJMjAxMS0xMC0wOCAxMzozODowNi4xNjgxNzYyNjQgLTA3MDAKQEAgLTUyLDYgKzUy
LDcgQEAKICNpbmNsdWRlIDxzY3NpL3Njc2lfaG9zdC5oPgogCiAjaW5jbHVkZSAibWVnYXJhaWRf
c2FzX2Z1c2lvbi5oIgorI2luY2x1ZGUgIm1lZ2FyYWlkX3Nhcy5oIgogI2luY2x1ZGUgPGFzbS9k
aXY2NC5oPgogCiAjZGVmaW5lIEFCU19ESUZGKGEsIGIpICAgKCgoYSkgPiAoYikpID8gKChhKSAt
IChiKSkgOiAoKGIpIC0gKGEpKSkKQEAgLTIyNiw4ICsyMjcsOSBAQAogKiAgICBzcGFuICAgICAg
ICAgIC0gU3BhbiBudW1iZXIKICogICAgYmxvY2sgICAgICAgICAtIEFic29sdXRlIEJsb2NrIG51
bWJlciBpbiB0aGUgcGh5c2ljYWwgZGlzawogKi8KLXU4IE1SX0dldFBoeVBhcmFtcyh1MzIgbGQs
IHU2NCBzdHJpcFJvdywgdTE2IHN0cmlwUmVmLCB1NjQgKnBkQmxvY2ssCi0JCSAgIHUxNiAqcERl
dkhhbmRsZSwgc3RydWN0IFJBSURfQ09OVEVYVCAqcFJBSURfQ29udGV4dCwKK3U4IE1SX0dldFBo
eVBhcmFtcyhzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHUzMiBsZCwgdTY0IHN0
cmlwUm93LAorCQkgICB1MTYgc3RyaXBSZWYsIHU2NCAqcGRCbG9jaywgdTE2ICpwRGV2SGFuZGxl
LAorCQkgICBzdHJ1Y3QgUkFJRF9DT05URVhUICpwUkFJRF9Db250ZXh0LAogCQkgICBzdHJ1Y3Qg
TVJfRldfUkFJRF9NQVBfQUxMICptYXApCiB7CiAJc3RydWN0IE1SX0xEX1JBSUQgICpyYWlkID0g
TVJfTGRSYWlkR2V0KGxkLCBtYXApOwpAQCAtMjc5LDcgKzI4MSw4IEBACiAJCSpwRGV2SGFuZGxl
ID0gTVJfUGREZXZIYW5kbGVHZXQocGQsIG1hcCk7CiAJZWxzZSB7CiAJCSpwRGV2SGFuZGxlID0g
TVJfUERfSU5WQUxJRDsgLyogc2V0IGRldiBoYW5kbGUgYXMgaW52YWxpZC4gKi8KLQkJaWYgKHJh
aWQtPmxldmVsID49IDUpCisJCWlmICgocmFpZC0+bGV2ZWwgPj0gNSkgJiYKKwkJICAgIChpbnN0
YW5jZS0+cGRldi0+ZGV2aWNlICE9IFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIpKQogCQkJcFJB
SURfQ29udGV4dC0+cmVnTG9ja0ZsYWdzID0gUkVHSU9OX1RZUEVfRVhDTFVTSVZFOwogCQllbHNl
IGlmIChyYWlkLT5sZXZlbCA9PSAxKSB7CiAJCQkvKiBHZXQgYWx0ZXJuYXRlIFBkLiAqLwpAQCAt
MzA2LDcgKzMwOSw4IEBACiAqIFRoaXMgZnVuY3Rpb24gd2lsbCByZXR1cm4gMCBpZiByZWdpb24g
bG9jayB3YXMgYWNxdWlyZWQgT1IgcmV0dXJuIG51bSBzdHJpcHMKICovCiB1OAotTVJfQnVpbGRS
YWlkQ29udGV4dChzdHJ1Y3QgSU9fUkVRVUVTVF9JTkZPICppb19pbmZvLAorTVJfQnVpbGRSYWlk
Q29udGV4dChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsCisJCSAgICBzdHJ1Y3Qg
SU9fUkVRVUVTVF9JTkZPICppb19pbmZvLAogCQkgICAgc3RydWN0IFJBSURfQ09OVEVYVCAqcFJB
SURfQ29udGV4dCwKIAkJICAgIHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCkKIHsKQEAg
LTM5NCw4ICszOTgsMTIgQEAKIAl9CiAKIAlwUkFJRF9Db250ZXh0LT50aW1lb3V0VmFsdWUgICAg
ID0gbWFwLT5yYWlkTWFwLmZwUGRJb1RpbWVvdXRTZWM7Ci0JcFJBSURfQ29udGV4dC0+cmVnTG9j
a0ZsYWdzICAgICA9IChpc1JlYWQpID8gUkVHSU9OX1RZUEVfU0hBUkVEX1JFQUQgOgotCQlyYWlk
LT5yZWdUeXBlUmVxT25Xcml0ZTsKKwlpZiAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lf
REVWSUNFX0lEX0xTSV9JTlZBREVSKQorCQlwUkFJRF9Db250ZXh0LT5yZWdMb2NrRmxhZ3MgPSAo
aXNSZWFkKSA/CisJCQlyYWlkLT5yZWdUeXBlUmVxT25SZWFkIDogcmFpZC0+cmVnVHlwZVJlcU9u
V3JpdGU7CisJZWxzZQorCQlwUkFJRF9Db250ZXh0LT5yZWdMb2NrRmxhZ3MgPSAoaXNSZWFkKSA/
CisJCQlSRUdJT05fVFlQRV9TSEFSRURfUkVBRCA6IHJhaWQtPnJlZ1R5cGVSZXFPbldyaXRlOwog
CXBSQUlEX0NvbnRleHQtPlZpcnR1YWxEaXNrVGd0SWQgPSByYWlkLT50YXJnZXRJZDsKIAlwUkFJ
RF9Db250ZXh0LT5yZWdMb2NrUm93TEJBICAgID0gcmVnU3RhcnQ7CiAJcFJBSURfQ29udGV4dC0+
cmVnTG9ja0xlbmd0aCAgICA9IHJlZ1NpemU7CkBAIC00MDQsNyArNDEyLDggQEAKIAkvKkdldCBQ
aHkgUGFyYW1zIG9ubHkgaWYgRlAgY2FwYWJsZSwgb3IgZWxzZSBsZWF2ZSBpdCB0byBNUiBmaXJt
d2FyZQogCSAgdG8gZG8gdGhlIGNhbGN1bGF0aW9uLiovCiAJaWYgKGlvX2luZm8tPmZwT2tGb3JJ
bykgewotCQlyZXR2YWwgPSBNUl9HZXRQaHlQYXJhbXMobGQsIHN0YXJ0X3N0cmlwLCByZWZfaW5f
c3RhcnRfc3RyaXBlLAorCQlyZXR2YWwgPSBNUl9HZXRQaHlQYXJhbXMoaW5zdGFuY2UsIGxkLCBz
dGFydF9zdHJpcCwKKwkJCQkJIHJlZl9pbl9zdGFydF9zdHJpcGUsCiAJCQkJCSAmaW9faW5mby0+
cGRCbG9jaywKIAkJCQkJICZpb19pbmZvLT5kZXZIYW5kbGUsIHBSQUlEX0NvbnRleHQsCiAJCQkJ
CSBtYXApOwpAQCAtNDE1LDcgKzQyNCw4IEBACiAJfSBlbHNlIGlmIChpc1JlYWQpIHsKIAkJdWlu
dCBzdHJpcElkeDsKIAkJZm9yIChzdHJpcElkeCA9IDA7IHN0cmlwSWR4IDwgbnVtX3N0cmlwczsg
c3RyaXBJZHgrKykgewotCQkJaWYgKCFNUl9HZXRQaHlQYXJhbXMobGQsIHN0YXJ0X3N0cmlwICsg
c3RyaXBJZHgsCisJCQlpZiAoIU1SX0dldFBoeVBhcmFtcyhpbnN0YW5jZSwgbGQsCisJCQkJCSAg
ICAgc3RhcnRfc3RyaXAgKyBzdHJpcElkeCwKIAkJCQkJICAgICByZWZfaW5fc3RhcnRfc3RyaXBl
LAogCQkJCQkgICAgICZpb19pbmZvLT5wZEJsb2NrLAogCQkJCQkgICAgICZpb19pbmZvLT5kZXZI
YW5kbGUsCmRpZmYgLU5hdXIgc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzX2Z1c2lvbi5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFp
ZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMKLS0tIHNjc2ktbWlzYy0yLjYvZHJpdmVycy9zY3NpL21l
Z2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uYwkyMDExLTEwLTA4IDE0OjE2OjExLjc0MDIzNjUw
NiAtMDcwMAorKysgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhc19mdXNpb24uYwkyMDExLTEwLTA4IDE0OjE1OjUyLjE3NjE3NDI3MiAtMDcwMApAQCAt
NzQsNyArNzQsOCBAQAogCQkgICAgIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kKTsKIAogdTgKLU1S
X0J1aWxkUmFpZENvbnRleHQoc3RydWN0IElPX1JFUVVFU1RfSU5GTyAqaW9faW5mbywKK01SX0J1
aWxkUmFpZENvbnRleHQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAorCQkgICAg
c3RydWN0IElPX1JFUVVFU1RfSU5GTyAqaW9faW5mbywKIAkJICAgIHN0cnVjdCBSQUlEX0NPTlRF
WFQgKnBSQUlEX0NvbnRleHQsCiAJCSAgICBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXAp
OwogdTE2IE1SX1RhcmdldElkVG9MZEdldCh1MzIgbGRUZ3RJZCwgc3RydWN0IE1SX0ZXX1JBSURf
TUFQX0FMTCAqbWFwKTsKQEAgLTEwMzgsNyArMTAzOSw5IEBACiAJY2FzZSBNRklfU1RBVF9ERVZJ
Q0VfTk9UX0ZPVU5EOgogCQljbWQtPnNjbWQtPnJlc3VsdCA9IERJRF9CQURfVEFSR0VUIDw8IDE2
OwogCQlicmVhazsKLQorCWNhc2UgTUZJX1NUQVRfQ09ORklHX1NFUV9NSVNNQVRDSDoKKwkJY21k
LT5zY21kLT5yZXN1bHQgPSBESURfSU1NX1JFVFJZIDw8IDE2OworCQlicmVhazsKIAlkZWZhdWx0
OgogCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogRlcgc3RhdHVzICUjeFxuIiwgc3RhdHVz
KTsKIAkJY21kLT5zY21kLT5yZXN1bHQgPSBESURfRVJST1IgPDwgMTY7CkBAIC0xMDYxLDE0ICsx
MDY0LDE3IEBACiAJCQlzdHJ1Y3QgTVBJMjVfSUVFRV9TR0VfQ0hBSU42NCAqc2dsX3B0ciwKIAkJ
CXN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gKmNtZCkKIHsKLQlpbnQgaSwgc2dfcHJvY2Vzc2Vk
OwotCWludCBzZ2VfY291bnQsIHNnZV9pZHg7CisJaW50IGksIHNnX3Byb2Nlc3NlZCwgc2dlX2Nv
dW50OwogCXN0cnVjdCBzY2F0dGVybGlzdCAqb3Nfc2dsOwogCXN0cnVjdCBmdXNpb25fY29udGV4
dCAqZnVzaW9uOwogCiAJZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKIAotCWNtZC0+
aW9fcmVxdWVzdC0+Q2hhaW5PZmZzZXQgPSAwOworCWlmIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNl
ID09IFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIpIHsKKwkJc3RydWN0IE1QSTI1X0lFRUVfU0dF
X0NIQUlONjQgKnNnbF9wdHJfZW5kID0gc2dsX3B0cjsKKwkJc2dsX3B0cl9lbmQgKz0gZnVzaW9u
LT5tYXhfc2dlX2luX21haW5fbXNnIC0gMTsKKwkJc2dsX3B0cl9lbmQtPkZsYWdzID0gMDsKKwl9
CiAKIAlzZ2VfY291bnQgPSBzY3NpX2RtYV9tYXAoc2NwKTsKIApAQCAtMTA3NywxNiArMTA4Mywx
NCBAQAogCWlmIChzZ2VfY291bnQgPiBpbnN0YW5jZS0+bWF4X251bV9zZ2UgfHwgIXNnZV9jb3Vu
dCkKIAkJcmV0dXJuIHNnZV9jb3VudDsKIAotCWlmIChzZ2VfY291bnQgPiBmdXNpb24tPm1heF9z
Z2VfaW5fbWFpbl9tc2cpIHsKLQkJLyogT25lIGVsZW1lbnQgdG8gc3RvcmUgdGhlIGNoYWluIGlu
Zm8gKi8KLQkJc2dlX2lkeCA9IGZ1c2lvbi0+bWF4X3NnZV9pbl9tYWluX21zZyAtIDE7Ci0JfSBl
bHNlCi0JCXNnZV9pZHggPSBzZ2VfY291bnQ7Ci0KIAlzY3NpX2Zvcl9lYWNoX3NnKHNjcCwgb3Nf
c2dsLCBzZ2VfY291bnQsIGkpIHsKIAkJc2dsX3B0ci0+TGVuZ3RoID0gc2dfZG1hX2xlbihvc19z
Z2wpOwogCQlzZ2xfcHRyLT5BZGRyZXNzID0gc2dfZG1hX2FkZHJlc3Mob3Nfc2dsKTsKIAkJc2ds
X3B0ci0+RmxhZ3MgPSAwOworCQlpZiAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVW
SUNFX0lEX0xTSV9JTlZBREVSKSB7CisJCQlpZiAoaSA9PSBzZ2VfY291bnQgLSAxKQorCQkJCXNn
bF9wdHItPkZsYWdzID0gSUVFRV9TR0VfRkxBR1NfRU5EX09GX0xJU1Q7CisJCX0KIAkJc2dsX3B0
cisrOwogCiAJCXNnX3Byb2Nlc3NlZCA9IGkgKyAxOwpAQCAtMTA5NSwxMyArMTA5OSwzMCBAQAog
CQkgICAgKHNnZV9jb3VudCA+IGZ1c2lvbi0+bWF4X3NnZV9pbl9tYWluX21zZykpIHsKIAogCQkJ
c3RydWN0IE1QSTI1X0lFRUVfU0dFX0NIQUlONjQgKnNnX2NoYWluOwotCQkJY21kLT5pb19yZXF1
ZXN0LT5DaGFpbk9mZnNldCA9Ci0JCQkJZnVzaW9uLT5jaGFpbl9vZmZzZXRfaW9fcmVxdWVzdDsK
KwkJCWlmIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09CisJCQkgICAgUENJX0RFVklDRV9JRF9M
U0lfSU5WQURFUikgeworCQkJCWlmICgoY21kLT5pb19yZXF1ZXN0LT5Jb0ZsYWdzICYKKwkJCQlN
UEkyNV9TQVNfREVWSUNFMF9GTEFHU19FTkFCTEVEX0ZBU1RfUEFUSCkgIT0KKwkJCQlNUEkyNV9T
QVNfREVWSUNFMF9GTEFHU19FTkFCTEVEX0ZBU1RfUEFUSCkKKwkJCQkJY21kLT5pb19yZXF1ZXN0
LT5DaGFpbk9mZnNldCA9CisJCQkJCQlmdXNpb24tPgorCQkJCQkJY2hhaW5fb2Zmc2V0X2lvX3Jl
cXVlc3Q7CisJCQkJZWxzZQorCQkJCQljbWQtPmlvX3JlcXVlc3QtPkNoYWluT2Zmc2V0ID0gMDsK
KwkJCX0gZWxzZQorCQkJCWNtZC0+aW9fcmVxdWVzdC0+Q2hhaW5PZmZzZXQgPQorCQkJCQlmdXNp
b24tPmNoYWluX29mZnNldF9pb19yZXF1ZXN0OworCiAJCQlzZ19jaGFpbiA9IHNnbF9wdHI7CiAJ
CQkvKiBQcmVwYXJlIGNoYWluIGVsZW1lbnQgKi8KIAkJCXNnX2NoYWluLT5OZXh0Q2hhaW5PZmZz
ZXQgPSAwOwotCQkJc2dfY2hhaW4tPkZsYWdzID0gKElFRUVfU0dFX0ZMQUdTX0NIQUlOX0VMRU1F
TlQgfAotCQkJCQkgICBNUEkyX0lFRUVfU0dFX0ZMQUdTX0lPQ1BMQk5UQV9BRERSKTsKKwkJCWlm
IChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09CisJCQkgICAgUENJX0RFVklDRV9JRF9MU0lfSU5W
QURFUikKKwkJCQlzZ19jaGFpbi0+RmxhZ3MgPSBJRUVFX1NHRV9GTEFHU19DSEFJTl9FTEVNRU5U
OworCQkJZWxzZQorCQkJCXNnX2NoYWluLT5GbGFncyA9CisJCQkJCShJRUVFX1NHRV9GTEFHU19D
SEFJTl9FTEVNRU5UIHwKKwkJCQkJIE1QSTJfSUVFRV9TR0VfRkxBR1NfSU9DUExCTlRBX0FERFIp
OwogCQkJc2dfY2hhaW4tPkxlbmd0aCA9ICAoc2l6ZW9mKHVuaW9uIE1QSTJfU0dFX0lPX1VOSU9O
KQogCQkJCQkgICAgICooc2dlX2NvdW50IC0gc2dfcHJvY2Vzc2VkKSk7CiAJCQlzZ19jaGFpbi0+
QWRkcmVzcyA9IGNtZC0+c2dfZnJhbWVfcGh5c19hZGRyOwpAQCAtMTM5NCw3ICsxNDE1LDggQEAK
IAkJaW9fcmVxdWVzdC0+UmFpZENvbnRleHQucmVnTG9ja0ZsYWdzICA9IDA7CiAJCWZwX3Bvc3Np
YmxlID0gMDsKIAl9IGVsc2UgewotCQlpZiAoTVJfQnVpbGRSYWlkQ29udGV4dCgmaW9faW5mbywg
JmlvX3JlcXVlc3QtPlJhaWRDb250ZXh0LAorCQlpZiAoTVJfQnVpbGRSYWlkQ29udGV4dChpbnN0
YW5jZSwgJmlvX2luZm8sCisJCQkJCSZpb19yZXF1ZXN0LT5SYWlkQ29udGV4dCwKIAkJCQkJbG9j
YWxfbWFwX3B0cikpCiAJCQlmcF9wb3NzaWJsZSA9IGlvX2luZm8uZnBPa0ZvcklvOwogCX0KQEAg
LTE0MDcsNiArMTQyOSwyMCBAQAogCQljbWQtPnJlcXVlc3RfZGVzYy0+U0NTSUlPLlJlcXVlc3RG
bGFncyA9CiAJCQkoTVBJMl9SRVFfREVTQ1JJUFRfRkxBR1NfSElHSF9QUklPUklUWQogCQkJIDw8
IE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZMQUdTX1RZUEVfU0hJRlQpOworCQlpZiAoaW5zdGFuY2Ut
PnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9JTlZBREVSKSB7CisJCQlpZiAoaW9f
cmVxdWVzdC0+UmFpZENvbnRleHQucmVnTG9ja0ZsYWdzID09CisJCQkgICAgUkVHSU9OX1RZUEVf
VU5VU0VEKQorCQkJCWNtZC0+cmVxdWVzdF9kZXNjLT5TQ1NJSU8uUmVxdWVzdEZsYWdzID0KKwkJ
CQkJKE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZMQUdTX05PX0xPQ0sgPDwKKwkJCQkJTUVHQVNBU19S
RVFfREVTQ1JJUFRfRkxBR1NfVFlQRV9TSElGVCk7CisJCQlpb19yZXF1ZXN0LT5SYWlkQ29udGV4
dC5UeXBlID0gTVBJMl9UWVBFX0NVREE7CisJCQlpb19yZXF1ZXN0LT5SYWlkQ29udGV4dC5uc2Vn
ID0gMHgxOworCQkJaW9fcmVxdWVzdC0+SW9GbGFncyB8PQorCQkJICBNUEkyNV9TQVNfREVWSUNF
MF9GTEFHU19FTkFCTEVEX0ZBU1RfUEFUSDsKKwkJCWlvX3JlcXVlc3QtPlJhaWRDb250ZXh0LnJl
Z0xvY2tGbGFncyB8PQorCQkJICAoTVJfUkxfRkxBR1NfR1JBTlRfREVTVElOQVRJT05fQ1VEQSB8
CisJCQkgICBNUl9STF9GTEFHU19TRVFfTlVNX0VOQUJMRSk7CisJCX0KIAkJaWYgKChmdXNpb24t
PmxvYWRfYmFsYW5jZV9pbmZvW2RldmljZV9pZF0ubG9hZEJhbGFuY2VGbGFnKSAmJgogCQkgICAg
KGlvX2luZm8uaXNSZWFkKSkgewogCQkJaW9faW5mby5kZXZIYW5kbGUgPQpAQCAtMTQyMSwxMSAr
MTQ1NywyMyBAQAogCX0gZWxzZSB7CiAJCWlvX3JlcXVlc3QtPlJhaWRDb250ZXh0LnRpbWVvdXRW
YWx1ZSA9CiAJCQlsb2NhbF9tYXBfcHRyLT5yYWlkTWFwLmZwUGRJb1RpbWVvdXRTZWM7Ci0JCWlv
X3JlcXVlc3QtPkZ1bmN0aW9uID0gTUVHQVNBU19NUEkyX0ZVTkNUSU9OX0xEX0lPX1JFUVVFU1Q7
Ci0JCWlvX3JlcXVlc3QtPkRldkhhbmRsZSA9IGRldmljZV9pZDsKIAkJY21kLT5yZXF1ZXN0X2Rl
c2MtPlNDU0lJTy5SZXF1ZXN0RmxhZ3MgPQogCQkJKE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZMQUdT
X0xEX0lPCiAJCQkgPDwgTUVHQVNBU19SRVFfREVTQ1JJUFRfRkxBR1NfVFlQRV9TSElGVCk7CisJ
CWlmIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIp
IHsKKwkJCWlmIChpb19yZXF1ZXN0LT5SYWlkQ29udGV4dC5yZWdMb2NrRmxhZ3MgPT0KKwkJCSAg
ICBSRUdJT05fVFlQRV9VTlVTRUQpCisJCQkJY21kLT5yZXF1ZXN0X2Rlc2MtPlNDU0lJTy5SZXF1
ZXN0RmxhZ3MgPQorCQkJCQkoTUVHQVNBU19SRVFfREVTQ1JJUFRfRkxBR1NfTk9fTE9DSyA8PAor
CQkJCQlNRUdBU0FTX1JFUV9ERVNDUklQVF9GTEFHU19UWVBFX1NISUZUKTsKKwkJCWlvX3JlcXVl
c3QtPlJhaWRDb250ZXh0LlR5cGUgPSBNUEkyX1RZUEVfQ1VEQTsKKwkJCWlvX3JlcXVlc3QtPlJh
aWRDb250ZXh0LnJlZ0xvY2tGbGFncyB8PQorCQkJCShNUl9STF9GTEFHU19HUkFOVF9ERVNUSU5B
VElPTl9DUFUwIHwKKwkJCQkgTVJfUkxfRkxBR1NfU0VRX05VTV9FTkFCTEUpOworCQkJaW9fcmVx
dWVzdC0+UmFpZENvbnRleHQubnNlZyA9IDB4MTsKKwkJfQorCQlpb19yZXF1ZXN0LT5GdW5jdGlv
biA9IE1FR0FTQVNfTVBJMl9GVU5DVElPTl9MRF9JT19SRVFVRVNUOworCQlpb19yZXF1ZXN0LT5E
ZXZIYW5kbGUgPSBkZXZpY2VfaWQ7CiAJfSAvKiBOb3QgRlAgKi8KIH0KIApAQCAtMTUwOCw4ICsx
NTU2LDEwIEBACiAJaW9fcmVxdWVzdC0+RUVEUEZsYWdzID0gMDsKIAlpb19yZXF1ZXN0LT5Db250
cm9sID0gMDsKIAlpb19yZXF1ZXN0LT5FRURQQmxvY2tTaXplID0gMDsKLQlpb19yZXF1ZXN0LT5J
b0ZsYWdzID0gMDsKKwlpb19yZXF1ZXN0LT5DaGFpbk9mZnNldCA9IDA7CiAJaW9fcmVxdWVzdC0+
UmFpZENvbnRleHQuUkFJREZsYWdzID0gMDsKKwlpb19yZXF1ZXN0LT5SYWlkQ29udGV4dC5UeXBl
ID0gMDsKKwlpb19yZXF1ZXN0LT5SYWlkQ29udGV4dC5uc2VnID0gMDsKIAogCW1lbWNweShpb19y
ZXF1ZXN0LT5DREIuQ0RCMzIsIHNjcC0+Y21uZCwgc2NwLT5jbWRfbGVuKTsKIAkvKgpAQCAtMTg2
Myw2ICsxOTEzLDE0IEBACiAKIAlmdXNpb24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OwogCWlv
X3JlcSA9IGNtZC0+aW9fcmVxdWVzdDsKKworCWlmIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09
IFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIpIHsKKwkJc3RydWN0IE1QSTI1X0lFRUVfU0dFX0NI
QUlONjQgKnNnbF9wdHJfZW5kID0KKwkJCShzdHJ1Y3QgTVBJMjVfSUVFRV9TR0VfQ0hBSU42NCAq
KSZpb19yZXEtPlNHTDsKKwkJc2dsX3B0cl9lbmQgKz0gZnVzaW9uLT5tYXhfc2dlX2luX21haW5f
bXNnIC0gMTsKKwkJc2dsX3B0cl9lbmQtPkZsYWdzID0gMDsKKwl9CisKIAltcGkyNV9pZWVlX2No
YWluID0KIAkgIChzdHJ1Y3QgTVBJMjVfSUVFRV9TR0VfQ0hBSU42NCAqKSZpb19yZXEtPlNHTC5J
ZWVlQ2hhaW47CiAKZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFp
ZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmggc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21l
Z2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uaAotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Nj
c2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5oCTIwMTEtMTAtMDggMTQ6MTY6MTEuNzQx
MjM2NDcxIC0wNzAwCisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5oCTIwMTEtMTAtMDggMTM6NTQ6NDEuMzA2MTc0OTIyIC0wNzAw
CkBAIC00NCw2ICs0NCwxNCBAQAogI2RlZmluZSBIT1NUX0RJQUdfUkVTRVRfQURBUFRFUgkJCSAg
ICAweDQKICNkZWZpbmUgTUVHQVNBU19GVVNJT05fTUFYX1JFU0VUX1RSSUVTCQkgICAgMwogCisv
KiBJbnZhZGVyIGRlZmluZXMgKi8KKyNkZWZpbmUgTVBJMl9UWVBFX0NVREEJCQkJICAgIDB4Mgor
I2RlZmluZSBNUEkyNV9TQVNfREVWSUNFMF9GTEFHU19FTkFCTEVEX0ZBU1RfUEFUSCAgIDB4NDAw
MAorI2RlZmluZQlNUl9STF9GTEFHU19HUkFOVF9ERVNUSU5BVElPTl9DUFUwCSAgICAweDAwCisj
ZGVmaW5lCU1SX1JMX0ZMQUdTX0dSQU5UX0RFU1RJTkFUSU9OX0NQVTEJICAgIDB4MTAKKyNkZWZp
bmUJTVJfUkxfRkxBR1NfR1JBTlRfREVTVElOQVRJT05fQ1VEQQkgICAgMHg4MAorI2RlZmluZSBN
Ul9STF9GTEFHU19TRVFfTlVNX0VOQUJMRQkJICAgIDB4OAorCiAvKiBUMTAgUEkgZGVmaW5lcyAq
LwogI2RlZmluZSBNUl9QUk9UX0lORk9fVFlQRV9DT05UUk9MTEVSICAgICAgICAgICAgICAgIDB4
OAogI2RlZmluZSBNRUdBU0FTX1NDU0lfVkFSSUFCTEVfTEVOR1RIX0NNRCAgICAgICAgICAgIDB4
N2YKQEAgLTcwLDcgKzc4LDcgQEAKICAqLwogI2RlZmluZSBNRUdBU0FTX1JFUV9ERVNDUklQVF9G
TEFHU19MRF9JTyAgICAgICAgICAgMHg3CiAjZGVmaW5lIE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZM
QUdTX01GQSAgICAgICAgICAgICAweDEKLQorI2RlZmluZSBNRUdBU0FTX1JFUV9ERVNDUklQVF9G
TEFHU19OT19MT0NLCSAgIDB4MgogI2RlZmluZSBNRUdBU0FTX1JFUV9ERVNDUklQVF9GTEFHU19U
WVBFX1NISUZUICAgICAgMQogCiAjZGVmaW5lIE1FR0FTQVNfRlBfQ01EX0xFTgkxNgpAQCAtODIs
NyArOTAsOSBAQAogICovCiAKIHN0cnVjdCBSQUlEX0NPTlRFWFQgewotCXUxNiAgICAgcmVzdmQw
OworCXU4CVR5cGU6NDsKKwl1OAluc2VnOjQ7CisJdTgJcmVzdmQwOwogCXUxNiAgICAgdGltZW91
dFZhbHVlOwogCXU4ICAgICAgcmVnTG9ja0ZsYWdzOwogCXU4ICAgICAgcmVzdmQxOwpAQCAtNTI3
LDcgKzUzNyw3IEBACiAJdTggICAgICBsZFN0YXRlOwogCXU4ICAgICAgcmVnVHlwZVJlcU9uV3Jp
dGU7CiAJdTggICAgICBtb2RGYWN0b3I7Ci0JdTggICAgICByZXNlcnZlZDJbMV07CisJdTgJcmVn
VHlwZVJlcU9uUmVhZDsKIAl1MTYgICAgIHNlcU51bTsKIAogCXN0cnVjdCB7CmRpZmYgLU5hdXIg
c2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmggc2NzaS1t
aXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCi0tLSBzY3Np
LW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAkyMDExLTEwLTA4
IDE0OjE2OjExLjc0MjIzNjQ3MCAtMDcwMAorKysgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9z
Y3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTEtMTAtMDggMTM6NTU6NTcuOTE5MTc2MDI0
IC0wNzAwCkBAIC00OCw2ICs0OCw3IEBACiAjZGVmaW5lCVBDSV9ERVZJQ0VfSURfTFNJX1NBUzAw
NzNTS0lOTlkJCTB4MDA3MwogI2RlZmluZQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5Z
CQkweDAwNzEKICNkZWZpbmUJUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OCQkweDAwNWIKKyNkZWZp
bmUgUENJX0RFVklDRV9JRF9MU0lfSU5WQURFUgkJMHgwMDVkCiAKIC8qCiAgKiA9PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09CkBAIC0yMjEsNiArMjIyLDcgQEAKIAlNRklfU1RB
VF9SRVNFUlZBVElPTl9JTl9QUk9HUkVTUyA9IDB4MzYsCiAJTUZJX1NUQVRfSTJDX0VSUk9SU19E
RVRFQ1RFRCA9IDB4MzcsCiAJTUZJX1NUQVRfUENJX0VSUk9SU19ERVRFQ1RFRCA9IDB4MzgsCisJ
TUZJX1NUQVRfQ09ORklHX1NFUV9NSVNNQVRDSCA9IDB4NjcsCiAKIAlNRklfU1RBVF9JTlZBTElE
X1NUQVRVUyA9IDB4RkYKIH07Cg==
--0016e6de03a4a16dea04aed36718--
