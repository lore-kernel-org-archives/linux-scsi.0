From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 10/19] megaraid_sas: remove instance->ctrl_info
Date: Thu, 19 Oct 2017 02:48:57 -0700
Message-ID: <1508406546-25944-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:45779 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752313AbdJSJuZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:25 -0400
Received: by mail-pf0-f193.google.com with SMTP id d28so6205606pfe.2
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:24 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Re-use the pre-allocated ctrl_info DMA buffer.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |  1 -
 drivers/scsi/megaraid/megaraid_sas_base.c | 43 ++++++++++---------------------
 2 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 80ba77b4b9e2..83427b541629 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2231,7 +2231,6 @@ struct megasas_instance {
 
 	/* Ptr to hba specific information */
 	void *ctrl_context;
-	struct megasas_ctrl_info *ctrl_info;
 	unsigned int msix_vectors;
 	struct megasas_irq_context irq_context[MEGASAS_MAX_MSIX_QUEUES];
 	u64 map_id;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 16a91ce2b2cb..2a68c75b7c4e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4545,9 +4545,9 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 		return;
 
 	instance->supportmax256vd =
-		instance->ctrl_info->adapterOperations3.supportMaxExtLDs;
+		instance->ctrl_info_buf->adapterOperations3.supportMaxExtLDs;
 	/* Below is additional check to address future FW enhancement */
-	if (instance->ctrl_info->max_lds > 64)
+	if (instance->ctrl_info_buf->max_lds > 64)
 		instance->supportmax256vd = 1;
 
 	instance->drv_supported_vd_count = MEGASAS_MAX_LD_CHANNELS
@@ -4605,11 +4605,8 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
 	struct megasas_ctrl_info *ci;
-	struct megasas_ctrl_info *ctrl_info;
 	dma_addr_t ci_h = 0;
 
-	ctrl_info = instance->ctrl_info;
-
 	ci = instance->ctrl_info_buf;
 	ci_h = instance->ctrl_info_buf_h;
 
@@ -4645,14 +4642,13 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 
 	switch (ret) {
 	case DCMD_SUCCESS:
-		memcpy(ctrl_info, ci, sizeof(struct megasas_ctrl_info));
 		/* Save required controller information in
 		 * CPU endianness format.
 		 */
-		le32_to_cpus((u32 *)&ctrl_info->properties.OnOffProperties);
-		le32_to_cpus((u32 *)&ctrl_info->adapterOperations2);
-		le32_to_cpus((u32 *)&ctrl_info->adapterOperations3);
-		le16_to_cpus((u16 *)&ctrl_info->adapter_operations4);
+		le32_to_cpus((u32 *)&ci->properties.OnOffProperties);
+		le32_to_cpus((u32 *)&ci->adapterOperations2);
+		le32_to_cpus((u32 *)&ci->adapterOperations3);
+		le16_to_cpus((u16 *)&ci->adapter_operations4);
 
 		/* Update the latest Ext VD info.
 		 * From Init path, store current firmware details.
@@ -4661,21 +4657,21 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 		 */
 		megasas_update_ext_vd_details(instance);
 		instance->use_seqnum_jbod_fp =
-			ctrl_info->adapterOperations3.useSeqNumJbodFP;
+			ci->adapterOperations3.useSeqNumJbodFP;
 		instance->support_morethan256jbod =
-			ctrl_info->adapter_operations4.support_pd_map_target_id;
+			ci->adapter_operations4.support_pd_map_target_id;
 
 		/*Check whether controller is iMR or MR */
-		instance->is_imr = (ctrl_info->memory_size ? 0 : 1);
+		instance->is_imr = (ci->memory_size ? 0 : 1);
 		dev_info(&instance->pdev->dev,
 			"controller type\t: %s(%dMB)\n",
 			instance->is_imr ? "iMR" : "MR",
-			le16_to_cpu(ctrl_info->memory_size));
+			le16_to_cpu(ci->memory_size));
 
 		instance->disableOnlineCtrlReset =
-			ctrl_info->properties.OnOffProperties.disableOnlineCtrlReset;
+			ci->properties.OnOffProperties.disableOnlineCtrlReset;
 		instance->secure_jbod_support =
-			ctrl_info->adapterOperations3.supportSecurityonJBOD;
+			ci->adapterOperations3.supportSecurityonJBOD;
 		dev_info(&instance->pdev->dev, "Online Controller Reset(OCR)\t: %s\n",
 			instance->disableOnlineCtrlReset ? "Disabled" : "Enabled");
 		dev_info(&instance->pdev->dev, "Secure JBOD support\t: %s\n",
@@ -5063,7 +5059,7 @@ megasas_setup_jbod_map(struct megasas_instance *instance)
 		(sizeof(struct MR_PD_CFG_SEQ) * (MAX_PHYSICAL_DEVICES - 1));
 
 	if (reset_devices || !fusion ||
-		!instance->ctrl_info->adapterOperations3.useSeqNumJbodFP) {
+		!instance->ctrl_info_buf->adapterOperations3.useSeqNumJbodFP) {
 		dev_info(&instance->pdev->dev,
 			"Jbod map is not supported %s %d\n",
 			__func__, __LINE__);
@@ -5277,11 +5273,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
 		(unsigned long)instance);
 
-	instance->ctrl_info = kzalloc(sizeof(struct megasas_ctrl_info),
-				GFP_KERNEL);
-	if (instance->ctrl_info == NULL)
-		goto fail_init_adapter;
-
 	/*
 	 * Below are default value for legacy Firmware.
 	 * non-fusion based controllers
@@ -5370,7 +5361,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	 * to calculate max_sectors_1. So the number ended up as zero always.
 	 */
 	tmp_sectors = 0;
-	ctrl_info = instance->ctrl_info;
+	ctrl_info = instance->ctrl_info_buf;
 
 	max_sectors_1 = (1 << ctrl_info->stripe_sz_ops.min) *
 		le16_to_cpu(ctrl_info->max_strips_per_io);
@@ -5485,8 +5476,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		pci_free_irq_vectors(instance->pdev);
 	instance->msix_vectors = 0;
 fail_ready_state:
-	kfree(instance->ctrl_info);
-	instance->ctrl_info = NULL;
 	iounmap(instance->reg_set);
 
 fail_ioremap:
@@ -6341,8 +6330,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	instance->host = host;
 	instance->unique_id = pdev->bus->number << 8 | pdev->devfn;
 	instance->init_id = MEGASAS_DEFAULT_INIT_ID;
-	instance->ctrl_info = NULL;
-
 
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY))
@@ -6848,8 +6835,6 @@ static void megasas_detach_one(struct pci_dev *pdev)
 		megasas_release_mfi(instance);
 	}
 
-	kfree(instance->ctrl_info);
-
 	if (instance->vf_affiliation)
 		pci_free_consistent(pdev, (MAX_LOGICAL_DRIVES + 1) *
 				    sizeof(struct MR_LD_VF_AFFILIATION),
-- 
2.14.1.dirty
