From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 1/4] megaraid_sas : Don't wait forever for non-IOCTL DCMDs
Date: Wed, 12 Feb 2014 23:36:15 +0530
Message-ID: <201402121236.s1CCa0Rm006000@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:31707
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751530AbaBLMgc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 07:36:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

Don't wait forever for firmware response for internal DCMDs sent from driver firmware. Such DCMDs will be posted to firmware with
timeout. Timeout is also introduced for DCMD sent to abort the commands. DCMD sent via IOCTL path will still be always blocking to
keep the IOCTL design intact.

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3b7ad10..9d1dc99 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -898,6 +898,7 @@ megasas_issue_polled(struct megasas_instance *instance, struct megasas_cmd *cmd)
  * megasas_issue_blocked_cmd -	Synchronous wrapper around regular FW cmds
  * @instance:			Adapter soft state
  * @cmd:			Command to be issued
+ * @timeout:			Timeout in seconds
  *
  * This function waits on an event for the command to be returned from ISR.
  * Max wait time is MEGASAS_INTERNAL_CMD_WAIT_TIME secs
@@ -905,13 +906,20 @@ megasas_issue_polled(struct megasas_instance *instance, struct megasas_cmd *cmd)
  */
 static int
 megasas_issue_blocked_cmd(struct megasas_instance *instance,
-			  struct megasas_cmd *cmd)
+			  struct megasas_cmd *cmd, int timeout)
 {
+	int ret = 0;
 	cmd->cmd_status = ENODATA;
 
 	instance->instancet->issue_dcmd(instance, cmd);
-
-	wait_event(instance->int_cmd_wait_q, cmd->cmd_status != ENODATA);
+	if (timeout) {
+		ret = wait_event_timeout(instance->int_cmd_wait_q,
+				cmd->cmd_status != ENODATA, timeout * HZ);
+		if (!ret)
+			return 1;
+	} else
+		wait_event(instance->int_cmd_wait_q,
+				cmd->cmd_status != ENODATA);
 
 	return 0;
 }
@@ -920,18 +928,20 @@ megasas_issue_blocked_cmd(struct megasas_instance *instance,
  * megasas_issue_blocked_abort_cmd -	Aborts previously issued cmd
  * @instance:				Adapter soft state
  * @cmd_to_abort:			Previously issued cmd to be aborted
+ * @timeout:				Timeout in seconds
  *
- * MFI firmware can abort previously issued AEN command (automatic event
+ * MFI firmware can abort previously issued AEN comamnd (automatic event
  * notification). The megasas_issue_blocked_abort_cmd() issues such abort
  * cmd and waits for return status.
  * Max wait time is MEGASAS_INTERNAL_CMD_WAIT_TIME secs
  */
 static int
 megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
-				struct megasas_cmd *cmd_to_abort)
+				struct megasas_cmd *cmd_to_abort, int timeout)
 {
 	struct megasas_cmd *cmd;
 	struct megasas_abort_frame *abort_fr;
+	int ret = 0;
 
 	cmd = megasas_get_cmd(instance);
 
@@ -957,10 +967,18 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
 
 	instance->instancet->issue_dcmd(instance, cmd);
 
-	/*
-	 * Wait for this cmd to complete
-	 */
-	wait_event(instance->abort_cmd_wait_q, cmd->cmd_status != 0xFF);
+	if (timeout) {
+		ret = wait_event_timeout(instance->abort_cmd_wait_q,
+				cmd->cmd_status != ENODATA, timeout * HZ);
+		if (!ret) {
+			dev_err(&instance->pdev->dev, "Command timedout"
+				"from %s\n", __func__);
+			return 1;
+		}
+	} else
+		wait_event(instance->abort_cmd_wait_q,
+				cmd->cmd_status != ENODATA);
+
 	cmd->sync_cmd = 0;
 
 	megasas_return_cmd(instance, cmd);
@@ -3933,16 +3951,19 @@ megasas_get_seq_num(struct megasas_instance *instance,
 	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(el_info_h);
 	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct megasas_evt_log_info));
 
-	megasas_issue_blocked_cmd(instance, cmd);
-
-	/*
-	 * Copy the data back into callers buffer
-	 */
-	eli->newest_seq_num = le32_to_cpu(el_info->newest_seq_num);
-	eli->oldest_seq_num = le32_to_cpu(el_info->oldest_seq_num);
-	eli->clear_seq_num = le32_to_cpu(el_info->clear_seq_num);
-	eli->shutdown_seq_num = le32_to_cpu(el_info->shutdown_seq_num);
-	eli->boot_seq_num = le32_to_cpu(el_info->boot_seq_num);
+	if (megasas_issue_blocked_cmd(instance, cmd, 30))
+		dev_err(&instance->pdev->dev, "Command timedout"
+			"from %s\n", __func__);
+	else {
+		/*
+		 * Copy the data back into callers buffer
+		 */
+		eli->newest_seq_num = le32_to_cpu(el_info->newest_seq_num);
+		eli->oldest_seq_num = le32_to_cpu(el_info->oldest_seq_num);
+		eli->clear_seq_num = le32_to_cpu(el_info->clear_seq_num);
+		eli->shutdown_seq_num = le32_to_cpu(el_info->shutdown_seq_num);
+		eli->boot_seq_num = le32_to_cpu(el_info->boot_seq_num);
+	}
 
 	pci_free_consistent(instance->pdev, sizeof(struct megasas_evt_log_info),
 			    el_info, el_info_h);
@@ -4018,7 +4039,7 @@ megasas_register_aen(struct megasas_instance *instance, u32 seq_num,
 			instance->aen_cmd->abort_aen = 1;
 			ret_val = megasas_issue_blocked_abort_cmd(instance,
 								  instance->
-								  aen_cmd);
+								  aen_cmd, 30);
 
 			if (ret_val) {
 				printk(KERN_DEBUG "megasas: Failed to abort "
@@ -4522,7 +4543,9 @@ static void megasas_flush_cache(struct megasas_instance *instance)
 	dcmd->opcode = cpu_to_le32(MR_DCMD_CTRL_CACHE_FLUSH);
 	dcmd->mbox.b[0] = MR_FLUSH_CTRL_CACHE | MR_FLUSH_DISK_CACHE;
 
-	megasas_issue_blocked_cmd(instance, cmd);
+	if (megasas_issue_blocked_cmd(instance, cmd, 30))
+		dev_err(&instance->pdev->dev, "Command timedout"
+			" from %s\n", __func__);
 
 	megasas_return_cmd(instance, cmd);
 
@@ -4549,10 +4572,11 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 		return;
 
 	if (instance->aen_cmd)
-		megasas_issue_blocked_abort_cmd(instance, instance->aen_cmd);
+		megasas_issue_blocked_abort_cmd(instance,
+			instance->aen_cmd, 30);
 	if (instance->map_update_cmd)
 		megasas_issue_blocked_abort_cmd(instance,
-						instance->map_update_cmd);
+			instance->map_update_cmd, 30);
 	dcmd = &cmd->frame->dcmd;
 
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
@@ -4566,7 +4590,9 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 	dcmd->data_xfer_len = 0;
 	dcmd->opcode = cpu_to_le32(opcode);
 
-	megasas_issue_blocked_cmd(instance, cmd);
+	if (megasas_issue_blocked_cmd(instance, cmd, 30))
+		dev_err(&instance->pdev->dev, "Command timedout"
+			"from %s\n", __func__);
 
 	megasas_return_cmd(instance, cmd);
 
@@ -4793,6 +4819,9 @@ static void megasas_detach_one(struct pci_dev *pdev)
 		instance->ev = NULL;
 	}
 
+	/* cancel all wait events */
+	wake_up_all(&instance->int_cmd_wait_q);
+
 	tasklet_kill(&instance->isr_tasklet);
 
 	/*
@@ -5045,7 +5074,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	 * cmd to the SCSI mid-layer
 	 */
 	cmd->sync_cmd = 1;
-	megasas_issue_blocked_cmd(instance, cmd);
+	megasas_issue_blocked_cmd(instance, cmd, 0);
 	cmd->sync_cmd = 0;
 
 	/*
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f655592..2d292de 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2469,6 +2469,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost)
 		printk(KERN_WARNING "megaraid_sas: Reset failed, killing "
 		       "adapter.\n");
 		megaraid_sas_kill_hba(instance);
+		instance->adprecovery = MEGASAS_HW_CRITICAL_ERROR;
 		retval = FAILED;
 	} else {
 		clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
