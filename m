From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 01/19] megaraid_sas: use adapter_type for all gen controllers
Date: Thu, 19 Oct 2017 02:48:48 -0700
Message-ID: <1508406546-25944-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:45687 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdJSJuB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:01 -0400
Received: by mail-pf0-f193.google.com with SMTP id d28so6204779pfe.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:00 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

No functional change.
Refactor adapter_type to set for all generation controllers, not
just for fusion controllers.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  8 +++
 drivers/scsi/megaraid/megaraid_sas_base.c   | 88 ++++++++++++++++++-----------
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 10 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 18 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  7 ---
 5 files changed, 76 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index a6722c93a295..90b9b5d7f0f8 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1504,6 +1504,13 @@ enum FW_BOOT_CONTEXT {
 
 #define MR_CAN_HANDLE_SYNC_CACHE_OFFSET		0X01000000
 
+enum MR_ADAPTER_TYPE {
+	MFI_SERIES = 1,
+	THUNDERBOLT_SERIES = 2,
+	INVADER_SERIES = 3,
+	VENTURA_SERIES = 4,
+};
+
 /*
 * register set for both 1068 and 1078 controllers
 * structure extended for 1078 registers
@@ -2242,6 +2249,7 @@ struct megasas_instance {
 	/* preffered count to send as LDIO irrspective of FP capable.*/
 	u8  r1_ldio_hint_default;
 	u32 nvme_page_size;
+	u8 adapter_type;
 };
 struct MR_LD_VF_MAP {
 	u32 size;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 518318491899..2f9955c6c2af 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5229,7 +5229,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			(&instance->reg_set->outbound_scratch_pad_2);
 		/* Check max MSI-X vectors */
 		if (fusion) {
-			if (fusion->adapter_type == THUNDERBOLT_SERIES) { /* Thunderbolt Series*/
+			if (instance->adapter_type == THUNDERBOLT_SERIES) {
+				/* Thunderbolt Series*/
 				instance->msix_vectors = (scratch_pad_2
 					& MR_MAX_REPLY_QUEUES_OFFSET) + 1;
 				fw_msix_count = instance->msix_vectors;
@@ -5965,6 +5966,46 @@ megasas_set_dma_mask(struct pci_dev *pdev)
 	return 1;
 }
 
+/*
+ * megasas_set_adapter_type -	Set adapter type.
+ *				Supported controllers can be divided in
+ *				4 categories-  enum MR_ADAPTER_TYPE {
+ *							MFI_SERIES = 1,
+ *							THUNDERBOLT_SERIES = 2,
+ *							INVADER_SERIES = 3,
+ *							VENTURA_SERIES = 4,
+ *						};
+ * @instance:			Adapter soft state
+ * return:			void
+ */
+static inline void megasas_set_adapter_type(struct megasas_instance *instance)
+{
+	switch (instance->pdev->device) {
+	case PCI_DEVICE_ID_LSI_VENTURA:
+	case PCI_DEVICE_ID_LSI_HARPOON:
+	case PCI_DEVICE_ID_LSI_TOMCAT:
+	case PCI_DEVICE_ID_LSI_VENTURA_4PORT:
+	case PCI_DEVICE_ID_LSI_CRUSADER_4PORT:
+		instance->adapter_type = VENTURA_SERIES;
+		break;
+	case PCI_DEVICE_ID_LSI_FUSION:
+	case PCI_DEVICE_ID_LSI_PLASMA:
+		instance->adapter_type = THUNDERBOLT_SERIES;
+		break;
+	case PCI_DEVICE_ID_LSI_INVADER:
+	case PCI_DEVICE_ID_LSI_INTRUDER:
+	case PCI_DEVICE_ID_LSI_INTRUDER_24:
+	case PCI_DEVICE_ID_LSI_CUTLASS_52:
+	case PCI_DEVICE_ID_LSI_CUTLASS_53:
+	case PCI_DEVICE_ID_LSI_FURY:
+		instance->adapter_type = INVADER_SERIES;
+		break;
+	default: /* For all other supported controllers */
+		instance->adapter_type = MFI_SERIES;
+		break;
+	}
+}
+
 /**
  * megasas_probe_one -	PCI hotplug entry point
  * @pdev:		PCI device structure
@@ -5977,7 +6018,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 	u16 control = 0;
-	struct fusion_context *fusion = NULL;
 
 	/* Reset MSI-X in the kdump kernel */
 	if (reset_devices) {
@@ -6022,39 +6062,10 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	atomic_set(&instance->fw_reset_no_pci_access, 0);
 	instance->pdev = pdev;
 
-	switch (instance->pdev->device) {
-	case PCI_DEVICE_ID_LSI_VENTURA:
-	case PCI_DEVICE_ID_LSI_HARPOON:
-	case PCI_DEVICE_ID_LSI_TOMCAT:
-	case PCI_DEVICE_ID_LSI_VENTURA_4PORT:
-	case PCI_DEVICE_ID_LSI_CRUSADER_4PORT:
-	     instance->is_ventura = true;
-	case PCI_DEVICE_ID_LSI_FUSION:
-	case PCI_DEVICE_ID_LSI_PLASMA:
-	case PCI_DEVICE_ID_LSI_INVADER:
-	case PCI_DEVICE_ID_LSI_FURY:
-	case PCI_DEVICE_ID_LSI_INTRUDER:
-	case PCI_DEVICE_ID_LSI_INTRUDER_24:
-	case PCI_DEVICE_ID_LSI_CUTLASS_52:
-	case PCI_DEVICE_ID_LSI_CUTLASS_53:
-	{
-		if (megasas_alloc_fusion_context(instance)) {
-			megasas_free_fusion_context(instance);
-			goto fail_alloc_dma_buf;
-		}
-		fusion = instance->ctrl_context;
-
-		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
-			(instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA))
-			fusion->adapter_type = THUNDERBOLT_SERIES;
-		else if (instance->is_ventura)
-			fusion->adapter_type = VENTURA_SERIES;
-		else
-			fusion->adapter_type = INVADER_SERIES;
-	}
-	break;
-	default: /* For all other supported controllers */
+	megasas_set_adapter_type(instance);
 
+	switch (instance->adapter_type) {
+	case MFI_SERIES:
 		instance->producer =
 			pci_alloc_consistent(pdev, sizeof(u32),
 					     &instance->producer_h);
@@ -6070,7 +6081,16 @@ static int megasas_probe_one(struct pci_dev *pdev,
 
 		*instance->producer = 0;
 		*instance->consumer = 0;
+
 		break;
+	case VENTURA_SERIES:
+		instance->is_ventura = 1;
+	case THUNDERBOLT_SERIES:
+	case INVADER_SERIES:
+		if (megasas_alloc_fusion_context(instance)) {
+			megasas_free_fusion_context(instance);
+			goto fail_alloc_dma_buf;
+		}
 	}
 
 	/* Crash dump feature related initialisation*/
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index ecc699a65bac..47af0e13b97a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -747,8 +747,8 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
 		}
 	} else {
 		if ((raid->level >= 5) &&
-			((fusion->adapter_type == THUNDERBOLT_SERIES)  ||
-			((fusion->adapter_type == INVADER_SERIES) &&
+			((instance->adapter_type == THUNDERBOLT_SERIES)  ||
+			((instance->adapter_type == INVADER_SERIES) &&
 			(raid->regTypeReqOnRead != REGION_TYPE_UNUSED))))
 			pRAID_Context->reg_lock_flags = REGION_TYPE_EXCLUSIVE;
 		else if (raid->level == 1) {
@@ -863,8 +863,8 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
 		}
 	} else {
 		if ((raid->level >= 5) &&
-			((fusion->adapter_type == THUNDERBOLT_SERIES)  ||
-			((fusion->adapter_type == INVADER_SERIES) &&
+			((instance->adapter_type == THUNDERBOLT_SERIES)  ||
+			((instance->adapter_type == INVADER_SERIES) &&
 			(raid->regTypeReqOnRead != REGION_TYPE_UNUSED))))
 			pRAID_Context->reg_lock_flags = REGION_TYPE_EXCLUSIVE;
 		else if (raid->level == 1) {
@@ -1088,7 +1088,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
 		cpu_to_le16(raid->fpIoTimeoutForLd ?
 			    raid->fpIoTimeoutForLd :
 			    map->raidMap.fpPdIoTimeoutSec);
-	if (fusion->adapter_type == INVADER_SERIES)
+	if (instance->adapter_type == INVADER_SERIES)
 		pRAID_Context->reg_lock_flags = (isRead) ?
 			raid->regTypeReqOnRead : raid->regTypeReqOnWrite;
 	else if (!instance->is_ventura)
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 11bd2e698b84..cd997ccf5ebf 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -845,7 +845,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	drv_ops = (MFI_CAPABILITIES *) &(init_frame->driver_operations);
 
 	/* driver support Extended MSIX */
-	if (fusion->adapter_type >= INVADER_SERIES)
+	if (instance->adapter_type >= INVADER_SERIES)
 		drv_ops->mfi_capabilities.support_additional_msix = 1;
 	/* driver supports HA / Remote LUN over Fast Path interface */
 	drv_ops->mfi_capabilities.support_fp_remote_lun = 1;
@@ -1803,7 +1803,7 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
 
 	fusion = instance->ctrl_context;
 
-	if (fusion->adapter_type >= INVADER_SERIES) {
+	if (instance->adapter_type >= INVADER_SERIES) {
 		struct MPI25_IEEE_SGE_CHAIN64 *sgl_ptr_end = sgl_ptr;
 		sgl_ptr_end += fusion->max_sge_in_main_msg - 1;
 		sgl_ptr_end->Flags = 0;
@@ -1813,7 +1813,7 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
 		sgl_ptr->Length = cpu_to_le32(sg_dma_len(os_sgl));
 		sgl_ptr->Address = cpu_to_le64(sg_dma_address(os_sgl));
 		sgl_ptr->Flags = 0;
-		if (fusion->adapter_type >= INVADER_SERIES)
+		if (instance->adapter_type >= INVADER_SERIES)
 			if (i == sge_count - 1)
 				sgl_ptr->Flags = IEEE_SGE_FLAGS_END_OF_LIST;
 		sgl_ptr++;
@@ -1823,7 +1823,7 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
 		    (sge_count > fusion->max_sge_in_main_msg)) {
 
 			struct MPI25_IEEE_SGE_CHAIN64 *sg_chain;
-			if (fusion->adapter_type >= INVADER_SERIES) {
+			if (instance->adapter_type >= INVADER_SERIES) {
 				if ((le16_to_cpu(cmd->io_request->IoFlags) &
 					MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH) !=
 					MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH)
@@ -1839,7 +1839,7 @@ megasas_make_sgl_fusion(struct megasas_instance *instance,
 			sg_chain = sgl_ptr;
 			/* Prepare chain element */
 			sg_chain->NextChainOffset = 0;
-			if (fusion->adapter_type >= INVADER_SERIES)
+			if (instance->adapter_type >= INVADER_SERIES)
 				sg_chain->Flags = IEEE_SGE_FLAGS_CHAIN_ELEMENT;
 			else
 				sg_chain->Flags =
@@ -2416,7 +2416,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MPI2_REQ_DESCRIPT_FLAGS_FP_IO
 			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
-		if (fusion->adapter_type == INVADER_SERIES) {
+		if (instance->adapter_type == INVADER_SERIES) {
 			if (io_request->RaidContext.raid_context.reg_lock_flags ==
 			    REGION_TYPE_UNUSED)
 				cmd->request_desc->SCSIIO.RequestFlags =
@@ -2481,7 +2481,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MEGASAS_REQ_DESCRIPT_FLAGS_LD_IO
 			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
-		if (fusion->adapter_type == INVADER_SERIES) {
+		if (instance->adapter_type == INVADER_SERIES) {
 			if (io_info.do_fp_rlbypass ||
 			(io_request->RaidContext.raid_context.reg_lock_flags
 					== REGION_TYPE_UNUSED))
@@ -2702,7 +2702,7 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
 		pRAID_Context->timeout_value =
 			cpu_to_le16((os_timeout_value > timeout_limit) ?
 			timeout_limit : os_timeout_value);
-		if (fusion->adapter_type >= INVADER_SERIES)
+		if (instance->adapter_type >= INVADER_SERIES)
 			io_request->IoFlags |=
 				cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
 
@@ -3315,7 +3315,7 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 
 	io_req = cmd->io_request;
 
-	if (fusion->adapter_type >= INVADER_SERIES) {
+	if (instance->adapter_type >= INVADER_SERIES) {
 		struct MPI25_IEEE_SGE_CHAIN64 *sgl_ptr_end =
 			(struct MPI25_IEEE_SGE_CHAIN64 *)&io_req->SGL;
 		sgl_ptr_end += fusion->max_sge_in_main_msg - 1;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index d78d76112501..7c1f7ccf031d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -104,12 +104,6 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
 #define RAID_1_PEER_CMDS 2
 #define JBOD_MAPS_COUNT	2
 
-enum MR_FUSION_ADAPTER_TYPE {
-	THUNDERBOLT_SERIES = 0,
-	INVADER_SERIES = 1,
-	VENTURA_SERIES = 2,
-};
-
 /*
  * Raid Context structure which describes MegaRAID specific IO Parameters
  * This resides at offset 0x60 where the SGL normally starts in MPT IO Frames
@@ -1319,7 +1313,6 @@ struct fusion_context {
 	struct LD_LOAD_BALANCE_INFO *load_balance_info;
 	u32 load_balance_info_pages;
 	LD_SPAN_INFO log_to_span[MAX_LOGICAL_DRIVES_EXT];
-	u8 adapter_type;
 	struct LD_STREAM_DETECT **stream_detect_by_ld;
 };
 
-- 
2.14.1.dirty
