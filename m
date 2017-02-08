From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v2 11/39] megaraid_sas: NVME interface target prop added
Date: Wed,  8 Feb 2017 01:29:05 -0800
Message-ID: <1486546173-20713-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:33007 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754105AbdBHJao (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 04:30:44 -0500
Received: by mail-pg0-f42.google.com with SMTP id 204so47589098pge.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 01:30:28 -0800 (PST)
In-Reply-To: <1486546173-20713-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

This patch fetch true values of NVME property from FW using New DCMD interface MR_DCMD_DEV_GET_TARGET_PROP

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  14 +++
 drivers/scsi/megaraid/megaraid_sas_base.c   | 144 +++++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   1 +
 3 files changed, 155 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index f9efddf..a45ff10 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -695,6 +695,18 @@ struct  MR_PD_INFO {
 	u8 reserved1[512-428];
 } __packed;
 
+/*
+ * Definition of structure used to expose attributes of VD or JBOD
+ * (this structure is to be filled by firmware when MR_DCMD_DRV_GET_TARGET_PROP
+ * is fired by driver)
+ */
+struct MR_TARGET_PROPERTIES {
+	u32    max_io_size_kb;
+	u32    device_qdepth;
+	u32    sector_size;
+	u8     reserved[500];
+} __packed;
+
  /*
  * defines the physical drive address structure
  */
@@ -2090,6 +2102,8 @@ struct megasas_instance {
 	dma_addr_t hb_host_mem_h;
 	struct MR_PD_INFO *pd_info;
 	dma_addr_t pd_info_h;
+	struct MR_TARGET_PROPERTIES *tgt_prop;
+	dma_addr_t tgt_prop_h;
 
 	__le32 *reply_queue;
 	dma_addr_t reply_queue_h;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f383bf2..51b35a6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -118,6 +118,8 @@ static int megasas_register_aen(struct megasas_instance *instance,
 				u32 seq_num, u32 class_locale_word);
 static void megasas_get_pd_info(struct megasas_instance *instance,
 				struct scsi_device *sdev);
+static int megasas_get_target_prop(struct megasas_instance *instance,
+				   struct scsi_device *sdev);
 /*
  * PCI ID table for all supported controllers
  */
@@ -1834,14 +1836,16 @@ megasas_set_nvme_device_properties(struct scsi_device *sdev, u32 max_io_size)
  * set nvme device properties. see - megasas_set_nvme_device_properties
  *
  * @sdev:				scsi device
- *
+ * @is_target_prop			true, if fw provided target properties.
  */
-static void megasas_set_static_target_properties(struct scsi_device *sdev)
+static void megasas_set_static_target_properties(struct scsi_device *sdev,
+						 bool is_target_prop)
 {
 	u16	target_index = 0;
 	u8 interface_type;
 	u32 device_qd = MEGASAS_DEFAULT_CMD_PER_LUN;
 	u32 max_io_size_kb = MR_DEFAULT_NVME_MDTS_KB;
+	u32 tgt_device_qd;
 	struct megasas_instance *instance;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 
@@ -1868,6 +1872,18 @@ static void megasas_set_static_target_properties(struct scsi_device *sdev)
 		break;
 	}
 
+	if (is_target_prop) {
+		tgt_device_qd = le32_to_cpu(instance->tgt_prop->device_qdepth);
+		if (tgt_device_qd &&
+		    (tgt_device_qd <= instance->host->can_queue))
+			device_qd = tgt_device_qd;
+
+		/* max_io_size_kb will be set to non zero for
+		 * nvme based vd and syspd.
+		 */
+		max_io_size_kb = le32_to_cpu(instance->tgt_prop->max_io_size_kb);
+	}
+
 	if (instance->nvme_page_size && max_io_size_kb)
 		megasas_set_nvme_device_properties(sdev, (max_io_size_kb << 10));
 
@@ -1880,6 +1896,8 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 {
 	u16 pd_index = 0;
 	struct megasas_instance *instance;
+	int ret_target_prop = DCMD_FAILED;
+	bool is_target_prop = false;
 
 	instance = megasas_lookup_instance(sdev->host->host_no);
 	if (instance->pd_list_not_supported) {
@@ -1897,7 +1915,14 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 	if ((instance->pd_info) && !MEGASAS_IS_LOGICAL(sdev))
 		megasas_get_pd_info(instance, sdev);
 
-	megasas_set_static_target_properties(sdev);
+	/* Some ventura firmware may not have instance->nvme_page_size set.
+	 * Do not send MR_DCMD_DRV_GET_TARGET_PROP
+	 */
+	if ((instance->tgt_prop) && (instance->nvme_page_size))
+		ret_target_prop = megasas_get_target_prop(instance, sdev);
+
+	is_target_prop = (ret_target_prop == DCMD_SUCCESS) ? true : false;
+	megasas_set_static_target_properties(sdev, is_target_prop);
 
 	mutex_unlock(&instance->hba_mutex);
 
@@ -5682,6 +5707,98 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 	return 0;
 }
 
+/* megasas_get_target_prop - Send DCMD with below details to firmware.
+ *
+ * This DCMD will fetch few properties of LD/system PD defined
+ * in MR_TARGET_DEV_PROPERTIES. eg. Queue Depth, MDTS value.
+ *
+ * DCMD send by drivers whenever new target is added to the OS.
+ *
+ * dcmd.opcode         - MR_DCMD_DEV_GET_TARGET_PROP
+ * dcmd.mbox.b[0]      - DCMD is to be fired for LD or system PD.
+ *                       0 = system PD, 1 = LD.
+ * dcmd.mbox.s[1]      - TargetID for LD/system PD.
+ * dcmd.sge IN         - Pointer to return MR_TARGET_DEV_PROPERTIES.
+ *
+ * @instance:		Adapter soft state
+ * @sdev:		OS provided scsi device
+ *
+ * Returns 0 on success non-zero on failure.
+ */
+static int
+megasas_get_target_prop(struct megasas_instance *instance,
+			struct scsi_device *sdev)
+{
+	int ret;
+	struct megasas_cmd *cmd;
+	struct megasas_dcmd_frame *dcmd;
+	u16 targetId = (sdev->channel % 2) + sdev->id;
+
+	cmd = megasas_get_cmd(instance);
+
+	if (!cmd) {
+		dev_err(&instance->pdev->dev,
+			"Failed to get cmd %s\n", __func__);
+		return -ENOMEM;
+	}
+
+	dcmd = &cmd->frame->dcmd;
+
+	memset(instance->tgt_prop, 0, sizeof(*instance->tgt_prop));
+	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+	dcmd->mbox.b[0] = MEGASAS_IS_LOGICAL(sdev);
+
+	dcmd->mbox.s[1] = cpu_to_le16(targetId);
+	dcmd->cmd = MFI_CMD_DCMD;
+	dcmd->cmd_status = 0xFF;
+	dcmd->sge_count = 1;
+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
+	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
+	dcmd->data_xfer_len =
+		cpu_to_le32(sizeof(struct MR_TARGET_PROPERTIES));
+	dcmd->opcode = cpu_to_le32(MR_DCMD_DRV_GET_TARGET_PROP);
+	dcmd->sgl.sge32[0].phys_addr =
+		cpu_to_le32(instance->tgt_prop_h);
+	dcmd->sgl.sge32[0].length =
+		cpu_to_le32(sizeof(struct MR_TARGET_PROPERTIES));
+
+	if (instance->ctrl_context && !instance->mask_interrupts)
+		ret = megasas_issue_blocked_cmd(instance,
+						cmd, MFI_IO_TIMEOUT_SECS);
+	else
+		ret = megasas_issue_polled(instance, cmd);
+
+	switch (ret) {
+	case DCMD_TIMEOUT:
+		switch (dcmd_timeout_ocr_possible(instance)) {
+		case INITIATE_OCR:
+			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
+			megasas_reset_fusion(instance->host,
+					     MFI_IO_TIMEOUT_OCR);
+			break;
+		case KILL_ADAPTER:
+			megaraid_sas_kill_hba(instance);
+			break;
+		case IGNORE_TIMEOUT:
+			dev_info(&instance->pdev->dev,
+				 "Ignore DCMD timeout: %s %d\n",
+				 __func__, __LINE__);
+			break;
+		}
+		break;
+
+	default:
+		megasas_return_cmd(instance, cmd);
+	}
+	if (ret != DCMD_SUCCESS)
+		dev_err(&instance->pdev->dev,
+			"return from %s %d return value %d\n",
+			__func__, __LINE__, ret);
+
+	return ret;
+}
+
 /**
  * megasas_start_aen -	Subscribes to AEN during driver load time
  * @instance:		Adapter soft state
@@ -5958,9 +6075,17 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		instance->pd_info = pci_alloc_consistent(pdev,
 			sizeof(struct MR_PD_INFO), &instance->pd_info_h);
 
+		instance->pd_info = pci_alloc_consistent(pdev,
+			sizeof(struct MR_PD_INFO), &instance->pd_info_h);
+		instance->tgt_prop = pci_alloc_consistent(pdev,
+			sizeof(struct MR_TARGET_PROPERTIES), &instance->tgt_prop_h);
+
 		if (!instance->pd_info)
 			dev_err(&instance->pdev->dev, "Failed to alloc mem for pd_info\n");
 
+		if (!instance->tgt_prop)
+			dev_err(&instance->pdev->dev, "Failed to alloc mem for tgt_prop\n");
+
 		instance->crash_dump_buf = pci_alloc_consistent(pdev,
 						CRASH_DMA_BUF_SIZE,
 						&instance->crash_dump_h);
@@ -6105,6 +6230,10 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		pci_free_consistent(pdev, sizeof(struct MR_PD_INFO),
 					instance->pd_info,
 					instance->pd_info_h);
+	if (instance->tgt_prop)
+		pci_free_consistent(pdev, sizeof(struct MR_TARGET_PROPERTIES),
+					instance->tgt_prop,
+					instance->tgt_prop_h);
 	if (instance->producer)
 		pci_free_consistent(pdev, sizeof(u32), instance->producer,
 				    instance->producer_h);
@@ -6377,6 +6506,10 @@ megasas_resume(struct pci_dev *pdev)
 		pci_free_consistent(pdev, sizeof(struct MR_PD_INFO),
 					instance->pd_info,
 					instance->pd_info_h);
+	if (instance->tgt_prop)
+		pci_free_consistent(pdev, sizeof(struct MR_TARGET_PROPERTIES),
+					instance->tgt_prop,
+					instance->tgt_prop_h);
 	if (instance->producer)
 		pci_free_consistent(pdev, sizeof(u32), instance->producer,
 				instance->producer_h);
@@ -6535,11 +6668,14 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	if (instance->evt_detail)
 		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
 				instance->evt_detail, instance->evt_detail_h);
-
 	if (instance->pd_info)
 		pci_free_consistent(pdev, sizeof(struct MR_PD_INFO),
 					instance->pd_info,
 					instance->pd_info_h);
+	if (instance->tgt_prop)
+		pci_free_consistent(pdev, sizeof(struct MR_TARGET_PROPERTIES),
+					instance->tgt_prop,
+					instance->tgt_prop_h);
 	if (instance->vf_affiliation)
 		pci_free_consistent(pdev, (MAX_LOGICAL_DRIVES + 1) *
 				    sizeof(struct MR_LD_VF_AFFILIATION),
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 9f19f00..9d02967 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -694,6 +694,7 @@ struct MPI2_IOC_INIT_REQUEST {
 #define MAX_RAIDMAP_PHYSICAL_DEVICES_DYN 512
 #define MR_DCMD_LD_MAP_GET_INFO             0x0300e101
 #define MR_DCMD_SYSTEM_PD_MAP_GET_INFO      0x0200e102
+#define MR_DCMD_DRV_GET_TARGET_PROP         0x0200e103
 #define MR_DCMD_CTRL_SHARED_HOST_MEM_ALLOC  0x010e8485   /* SR-IOV HB alloc*/
 #define MR_DCMD_LD_VF_MAP_GET_ALL_LDS_111   0x03200200
 #define MR_DCMD_LD_VF_MAP_GET_ALL_LDS       0x03150200
-- 
2.8.3
