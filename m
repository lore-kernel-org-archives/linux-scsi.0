From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 03/19] megaraid_sas: replace instance->ctrl_context checks with instance->adapter_type
Date: Thu, 19 Oct 2017 02:48:50 -0700
Message-ID: <1508406546-25944-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:49034 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752445AbdJSJuG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:50:06 -0400
Received: by mail-pg0-f66.google.com with SMTP id v78so6760387pgb.5
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:50:06 -0700 (PDT)
In-Reply-To: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Increase Code readability. No Functional Change

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 64 ++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index eba627ccd041..001b075d0dd6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2024,7 +2024,7 @@ void megaraid_sas_kill_hba(struct megasas_instance *instance)
 	msleep(1000);
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
-		(instance->ctrl_context)) {
+		(instance->adapter_type != MFI_SERIES)) {
 		writel(MFI_STOP_ADP, &instance->reg_set->doorbell);
 		/* Flush */
 		readl(&instance->reg_set->doorbell);
@@ -2495,7 +2495,8 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 	dev_warn(&instance->pdev->dev, "SR-IOV: Starting heartbeat for scsi%d\n",
 	       instance->host->host_no);
 
-	if (instance->ctrl_context && !instance->mask_interrupts)
+	if ((instance->adapter_type != MFI_SERIES) &&
+	    !instance->mask_interrupts)
 		retval = megasas_issue_blocked_cmd(instance, cmd,
 			MEGASAS_ROUTINE_WAIT_TIME_VF);
 	else
@@ -2791,7 +2792,9 @@ static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
 	/*
 	 * First wait for all commands to complete
 	 */
-	if (instance->ctrl_context) {
+	if (instance->adapter_type == MFI_SERIES) {
+		ret = megasas_generic_reset(scmd);
+	} else {
 		struct megasas_cmd_fusion *cmd;
 		cmd = (struct megasas_cmd_fusion *)scmd->SCp.ptr;
 		if (cmd)
@@ -2799,8 +2802,7 @@ static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
 				MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE);
 		ret = megasas_reset_fusion(scmd->device->host,
 				SCSIIO_TIMEOUT_OCR);
-	} else
-		ret = megasas_generic_reset(scmd);
+	}
 
 	return ret;
 }
@@ -2817,7 +2819,7 @@ static int megasas_task_abort(struct scsi_cmnd *scmd)
 
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 
-	if (instance->ctrl_context)
+	if (instance->adapter_type != MFI_SERIES)
 		ret = megasas_task_abort_fusion(scmd);
 	else {
 		sdev_printk(KERN_NOTICE, scmd->device, "TASK ABORT not supported\n");
@@ -2839,7 +2841,7 @@ static int megasas_reset_target(struct scsi_cmnd *scmd)
 
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 
-	if (instance->ctrl_context)
+	if (instance->adapter_type != MFI_SERIES)
 		ret = megasas_reset_target_fusion(scmd);
 	else {
 		sdev_printk(KERN_NOTICE, scmd->device, "TARGET RESET not supported\n");
@@ -3716,7 +3718,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 				(instance->pdev->device ==
 				 PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
-				(instance->ctrl_context))
+				(instance->adapter_type != MFI_SERIES))
 				writel(
 				  MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
 				  &instance->reg_set->doorbell);
@@ -3734,7 +3736,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 			     PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 				(instance->pdev->device ==
 				 PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
-				(instance->ctrl_context))
+				(instance->adapter_type != MFI_SERIES))
 				writel(MFI_INIT_HOTPLUG,
 				       &instance->reg_set->doorbell);
 			else
@@ -3754,11 +3756,11 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 				(instance->pdev->device ==
 				PCI_DEVICE_ID_LSI_SAS0071SKINNY)  ||
-				(instance->ctrl_context)) {
+				(instance->adapter_type != MFI_SERIES)) {
 				writel(MFI_RESET_FLAGS,
 					&instance->reg_set->doorbell);
 
-				if (instance->ctrl_context) {
+				if (instance->adapter_type != MFI_SERIES) {
 					for (i = 0; i < (10 * 1000); i += 20) {
 						if (readl(
 							    &instance->
@@ -3925,7 +3927,8 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 	 * max_sge_sz  = 12 byte (sizeof  megasas_sge64)
 	 * Total 192 byte (3 MFI frame of 64 byte)
 	 */
-	frame_count = instance->ctrl_context ? (3 + 1) : (15 + 1);
+	frame_count = (instance->adapter_type == MFI_SERIES) ?
+			(15 + 1) : (3 + 1);
 	instance->mfi_frame_size = MEGAMFI_FRAME_SIZE * frame_count;
 	/*
 	 * Use DMA pool facility provided by PCI layer
@@ -3980,7 +3983,7 @@ static int megasas_create_frame_pool(struct megasas_instance *instance)
 		memset(cmd->frame, 0, instance->mfi_frame_size);
 		cmd->frame->io.context = cpu_to_le32(cmd->index);
 		cmd->frame->io.pad_0 = 0;
-		if (!instance->ctrl_context && reset_devices)
+		if ((instance->adapter_type == MFI_SERIES) && reset_devices)
 			cmd->frame->hdr.cmd = MFI_CMD_INVALID;
 	}
 
@@ -4100,7 +4103,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 inline int
 dcmd_timeout_ocr_possible(struct megasas_instance *instance) {
 
-	if (!instance->ctrl_context)
+	if (instance->adapter_type == MFI_SERIES)
 		return KILL_ADAPTER;
 	else if (instance->unload ||
 			test_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags))
@@ -4144,7 +4147,8 @@ megasas_get_pd_info(struct megasas_instance *instance, struct scsi_device *sdev)
 	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(instance->pd_info_h);
 	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct MR_PD_INFO));
 
-	if (instance->ctrl_context && !instance->mask_interrupts)
+	if ((instance->adapter_type != MFI_SERIES) &&
+	    !instance->mask_interrupts)
 		ret = megasas_issue_blocked_cmd(instance, cmd, MFI_IO_TIMEOUT_SECS);
 	else
 		ret = megasas_issue_polled(instance, cmd);
@@ -4241,7 +4245,8 @@ megasas_get_pd_list(struct megasas_instance *instance)
 	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(ci_h);
 	dcmd->sgl.sge32[0].length = cpu_to_le32(MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST));
 
-	if (instance->ctrl_context && !instance->mask_interrupts)
+	if ((instance->adapter_type != MFI_SERIES) &&
+	    !instance->mask_interrupts)
 		ret = megasas_issue_blocked_cmd(instance, cmd,
 			MFI_IO_TIMEOUT_SECS);
 	else
@@ -4252,7 +4257,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 		dev_info(&instance->pdev->dev, "MR_DCMD_PD_LIST_QUERY "
 			"failed/not supported by firmware\n");
 
-		if (instance->ctrl_context)
+		if (instance->adapter_type != MFI_SERIES)
 			megaraid_sas_kill_hba(instance);
 		else
 			instance->pd_list_not_supported = 1;
@@ -4373,7 +4378,8 @@ megasas_get_ld_list(struct megasas_instance *instance)
 	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct MR_LD_LIST));
 	dcmd->pad_0  = 0;
 
-	if (instance->ctrl_context && !instance->mask_interrupts)
+	if ((instance->adapter_type != MFI_SERIES) &&
+	    !instance->mask_interrupts)
 		ret = megasas_issue_blocked_cmd(instance, cmd,
 			MFI_IO_TIMEOUT_SECS);
 	else
@@ -4492,7 +4498,8 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct MR_LD_TARGETID_LIST));
 	dcmd->pad_0  = 0;
 
-	if (instance->ctrl_context && !instance->mask_interrupts)
+	if ((instance->adapter_type != MFI_SERIES) &&
+	    !instance->mask_interrupts)
 		ret = megasas_issue_blocked_cmd(instance, cmd, MFI_IO_TIMEOUT_SECS);
 	else
 		ret = megasas_issue_polled(instance, cmd);
@@ -4665,7 +4672,8 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct megasas_ctrl_info));
 	dcmd->mbox.b[0] = 1;
 
-	if (instance->ctrl_context && !instance->mask_interrupts)
+	if ((instance->adapter_type != MFI_SERIES) &&
+	    !instance->mask_interrupts)
 		ret = megasas_issue_blocked_cmd(instance, cmd, MFI_IO_TIMEOUT_SECS);
 	else
 		ret = megasas_issue_polled(instance, cmd);
@@ -4784,7 +4792,8 @@ int megasas_set_crash_dump_params(struct megasas_instance *instance,
 	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(instance->crash_dump_h);
 	dcmd->sgl.sge32[0].length = cpu_to_le32(CRASH_DMA_BUF_SIZE);
 
-	if (instance->ctrl_context && !instance->mask_interrupts)
+	if ((instance->adapter_type != MFI_SERIES) &&
+	    !instance->mask_interrupts)
 		ret = megasas_issue_blocked_cmd(instance, cmd, MFI_IO_TIMEOUT_SECS);
 	else
 		ret = megasas_issue_polled(instance, cmd);
@@ -5171,7 +5180,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	reg_set = instance->reg_set;
 
-	if (fusion)
+	if (instance->adapter_type != MFI_SERIES)
 		instance->instancet = &megasas_instance_template_fusion;
 	else {
 		switch (instance->pdev->device) {
@@ -5806,7 +5815,8 @@ megasas_get_target_prop(struct megasas_instance *instance,
 	dcmd->sgl.sge32[0].length =
 		cpu_to_le32(sizeof(struct MR_TARGET_PROPERTIES));
 
-	if (instance->ctrl_context && !instance->mask_interrupts)
+	if ((instance->adapter_type != MFI_SERIES) &&
+	    !instance->mask_interrupts)
 		ret = megasas_issue_blocked_cmd(instance,
 						cmd, MFI_IO_TIMEOUT_SECS);
 	else
@@ -6193,7 +6203,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	instance->disableOnlineCtrlReset = 1;
 	instance->UnevenSpanSupport = 0;
 
-	if (instance->ctrl_context) {
+	if (instance->adapter_type != MFI_SERIES) {
 		INIT_WORK(&instance->work_init, megasas_fusion_ocr_wq);
 		INIT_WORK(&instance->crash_init, megasas_fusion_crash_dump_wq);
 	} else
@@ -6273,7 +6283,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	instance->instancet->disable_intr(instance);
 	megasas_destroy_irqs(instance);
 
-	if (instance->ctrl_context)
+	if (instance->adapter_type != MFI_SERIES)
 		megasas_release_fusion(instance);
 	else
 		megasas_release_mfi(instance);
@@ -6507,7 +6517,7 @@ megasas_resume(struct pci_dev *pdev)
 	if (rval < 0)
 		goto fail_reenable_msix;
 
-	if (instance->ctrl_context) {
+	if (instance->adapter_type != MFI_SERIES) {
 		megasas_reset_reply_desc(instance);
 		if (megasas_ioc_init_fusion(instance)) {
 			megasas_free_cmds(instance);
@@ -6691,7 +6701,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	}
 
 
-	if (instance->ctrl_context) {
+	if (instance->adapter_type != MFI_SERIES) {
 		megasas_release_fusion(instance);
 			pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
 				(sizeof(struct MR_PD_CFG_SEQ) *
-- 
2.14.1.dirty
