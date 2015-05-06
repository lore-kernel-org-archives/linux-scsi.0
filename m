From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH] megaraid_sas : Modify return value of
 megasas_issue_blocked_cmd() and wait_and_poll() to consider command status
 returned by firmware
Date: Wed, 6 May 2015 19:01:02 +0530
Message-ID: <201505061333.t46DXdcM032441@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:46471
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750808AbbEFNbU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 May 2015 09:31:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, thenzl@redhat.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch is rebased on top of recently sent 18 patches(submitted by me) for megaraid_sas driver.

Change the return value of wait_and_poll() and megsas_issue_blocked_cmd() based on MFI_STAT returned by firmware for that command. Earlier driver always
send return type based on command completion (but never check MFI_STAT_OK for that command), so even if command is failed by firmware still driver will
return SUCCESS status from these functions wait_and_poll() and megsas_issue_blocked_cmd() and if caller of these functions does not check command status
(MFI_STAT), then it may endup using invalid data returned in DMA buffers(one of the example is megasas_ld_list_query DCMD). Best thing to avoid this type
of issue is do error handling and set proper return type from caller function wait_and_poll() and megsas_issue_blocked_cmd().

The change proposed in this patch will fix the regression introduced in patch- "90dc9d9 megaraid_sas : MFI MPT linked list corruption fix" inside function
megasas_ld_list_query().
Prior to this MFI MPT linked list corruption fix patch, megasas_ld_list_query() function used to check DCMD status(returned by firmware) but with
this linked list corruption fix patch, DCMD status will not be checked inside function megasas_ld_list_query() and introduced this issue of wrong data
being used by function megasas_ld_list_query().

Cc: <stable@vger.kernel.org>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |    2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |   67 +++++++++++----------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    3 +-
 3 files changed, 30 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 53a3c3f..20c3754 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1894,7 +1894,7 @@ struct megasas_cmd {
 
 	u32 index;
 	u8 sync_cmd;
-	u8 cmd_status;
+	u8 cmd_status_drv;
 	u8 abort_aen;
 	u8 retry_for_fw_reset;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8309e01..f08d107 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -898,7 +898,7 @@ extern struct megasas_instance_template megasas_instance_template_fusion;
  * @instance:			Adapter soft state
  * @cmd:			Command packet to be issued
  *
- * For polling, MFI requires the cmd_status to be set to 0xFF before posting.
+ * For polling, MFI requires the cmd_status to be set to MFI_STAT_INVALID_STATUS before posting.
  */
 int
 megasas_issue_polled(struct megasas_instance *instance, struct megasas_cmd *cmd)
@@ -940,19 +940,20 @@ megasas_issue_blocked_cmd(struct megasas_instance *instance,
 			  struct megasas_cmd *cmd, int timeout)
 {
 	int ret = 0;
-	cmd->cmd_status = ENODATA;
+	cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
 
 	instance->instancet->issue_dcmd(instance, cmd);
 	if (timeout) {
 		ret = wait_event_timeout(instance->int_cmd_wait_q,
-				cmd->cmd_status != ENODATA, timeout * HZ);
+				cmd->cmd_status_drv != MFI_STAT_INVALID_STATUS, timeout * HZ);
 		if (!ret)
 			return 1;
 	} else
 		wait_event(instance->int_cmd_wait_q,
-				cmd->cmd_status != ENODATA);
+				cmd->cmd_status_drv != MFI_STAT_INVALID_STATUS);
 
-	return 0;
+	return (cmd->cmd_status_drv == MFI_STAT_OK) ?
+		0 : 1;
 }
 
 /**
@@ -985,7 +986,7 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
 	 * Prepare and issue the abort frame
 	 */
 	abort_fr->cmd = MFI_CMD_ABORT;
-	abort_fr->cmd_status = 0xFF;
+	abort_fr->cmd_status = MFI_STAT_INVALID_STATUS;
 	abort_fr->flags = cpu_to_le16(0);
 	abort_fr->abort_context = cpu_to_le32(cmd_to_abort->index);
 	abort_fr->abort_mfi_phys_addr_lo =
@@ -994,13 +995,13 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
 		cpu_to_le32(upper_32_bits(cmd_to_abort->frame_phys_addr));
 
 	cmd->sync_cmd = 1;
-	cmd->cmd_status = ENODATA;
+	cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
 
 	instance->instancet->issue_dcmd(instance, cmd);
 
 	if (timeout) {
 		ret = wait_event_timeout(instance->abort_cmd_wait_q,
-				cmd->cmd_status != ENODATA, timeout * HZ);
+				cmd->cmd_status_drv != MFI_STAT_INVALID_STATUS, timeout * HZ);
 		if (!ret) {
 			dev_err(&instance->pdev->dev, "Command timedout"
 				"from %s\n", __func__);
@@ -1008,7 +1009,7 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
 		}
 	} else
 		wait_event(instance->abort_cmd_wait_q,
-				cmd->cmd_status != ENODATA);
+				cmd->cmd_status_drv != MFI_STAT_INVALID_STATUS);
 
 	cmd->sync_cmd = 0;
 
@@ -1913,7 +1914,7 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
 
 	dcmd->cmd = MFI_CMD_DCMD;
-	dcmd->cmd_status = 0xFF;
+	dcmd->cmd_status = MFI_STAT_INVALID_STATUS;
 	dcmd->sge_count = 1;
 	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_BOTH);
 	dcmd->timeout = 0;
@@ -2026,7 +2027,7 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
 
 	dcmd->cmd = MFI_CMD_DCMD;
-	dcmd->cmd_status = 0xFF;
+	dcmd->cmd_status = MFI_STAT_INVALID_STATUS;
 	dcmd->sge_count = 1;
 	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_BOTH);
 	dcmd->timeout = 0;
@@ -2193,7 +2194,7 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 
 	dcmd->mbox.s[0] = cpu_to_le16(sizeof(struct MR_CTRL_HB_HOST_MEM));
 	dcmd->cmd = MFI_CMD_DCMD;
-	dcmd->cmd_status = 0xFF;
+	dcmd->cmd_status = MFI_STAT_INVALID_STATUS;
 	dcmd->sge_count = 1;
 	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_BOTH);
 	dcmd->timeout = 0;
@@ -2213,21 +2214,11 @@ int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 		retval = megasas_issue_polled(instance, cmd);
 
 	if (retval) {
-		printk(KERN_WARNING "megasas: SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
-		       "_MEM_ALLOC DCMD timed out for scsi%d\n",
-		       instance->host->host_no);
-		retval = 1;
-		goto out;
-	}
-
-
-	if (dcmd->cmd_status) {
-		printk(KERN_WARNING "megasas: SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
-		       "_MEM_ALLOC DCMD failed with status 0x%x for scsi%d\n",
-		       dcmd->cmd_status,
-		       instance->host->host_no);
+		dev_warn(&instance->pdev->dev, "SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
+			"_MEM_ALLOC DCMD %s for scsi%d\n",
+			(dcmd->cmd_status == MFI_STAT_INVALID_STATUS) ?
+			"timed out" : "failed", instance->host->host_no);
 		retval = 1;
-		goto out;
 	}
 
 out:
@@ -2323,7 +2314,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 						"reset queue\n",
 						reset_cmd);
 
-				reset_cmd->cmd_status = ENODATA;
+				reset_cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
 				instance->instancet->fire_cmd(instance,
 						reset_cmd->frame_phys_addr,
 						0, instance->reg_set);
@@ -2802,11 +2793,7 @@ static void
 megasas_complete_int_cmd(struct megasas_instance *instance,
 			 struct megasas_cmd *cmd)
 {
-	cmd->cmd_status = cmd->frame->io.cmd_status;
-
-	if (cmd->cmd_status == ENODATA) {
-		cmd->cmd_status = 0;
-	}
+	cmd->cmd_status_drv = cmd->frame->io.cmd_status;
 	wake_up(&instance->int_cmd_wait_q);
 }
 
@@ -2825,7 +2812,7 @@ megasas_complete_abort(struct megasas_instance *instance,
 {
 	if (cmd->sync_cmd) {
 		cmd->sync_cmd = 0;
-		cmd->cmd_status = 0;
+		cmd->cmd_status_drv = 0;
 		wake_up(&instance->abort_cmd_wait_q);
 	}
 
@@ -3071,7 +3058,7 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 			printk(KERN_NOTICE "megasas: %p synchronous cmd"
 						"on the internal reset queue,"
 						"issue it again.\n", cmd);
-			cmd->cmd_status = ENODATA;
+			cmd->cmd_status_drv = MFI_STAT_INVALID_STATUS;
 			instance->instancet->fire_cmd(instance,
 							cmd->frame_phys_addr ,
 							0, instance->reg_set);
@@ -3811,7 +3798,7 @@ megasas_get_pd_list(struct megasas_instance *instance)
 	dcmd->mbox.b[0] = MR_PD_QUERY_TYPE_EXPOSED_TO_HOST;
 	dcmd->mbox.b[1] = 0;
 	dcmd->cmd = MFI_CMD_DCMD;
-	dcmd->cmd_status = 0xFF;
+	dcmd->cmd_status = MFI_STAT_INVALID_STATUS;
 	dcmd->sge_count = 1;
 	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
 	dcmd->timeout = 0;
@@ -3907,7 +3894,7 @@ megasas_get_ld_list(struct megasas_instance *instance)
 	if (instance->supportmax256vd)
 		dcmd->mbox.b[0] = 1;
 	dcmd->cmd = MFI_CMD_DCMD;
-	dcmd->cmd_status = 0xFF;
+	dcmd->cmd_status = MFI_STAT_INVALID_STATUS;
 	dcmd->sge_count = 1;
 	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
 	dcmd->timeout = 0;
@@ -3996,7 +3983,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 		dcmd->mbox.b[2] = 1;
 
 	dcmd->cmd = MFI_CMD_DCMD;
-	dcmd->cmd_status = 0xFF;
+	dcmd->cmd_status = MFI_STAT_INVALID_STATUS;
 	dcmd->sge_count = 1;
 	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
 	dcmd->timeout = 0;
@@ -4129,7 +4116,7 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
 
 	dcmd->cmd = MFI_CMD_DCMD;
-	dcmd->cmd_status = 0xFF;
+	dcmd->cmd_status = MFI_STAT_INVALID_STATUS;
 	dcmd->sge_count = 1;
 	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
 	dcmd->timeout = 0;
@@ -4201,7 +4188,7 @@ int megasas_set_crash_dump_params(struct megasas_instance *instance,
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
 	dcmd->mbox.b[0] = crash_buf_state;
 	dcmd->cmd = MFI_CMD_DCMD;
-	dcmd->cmd_status = 0xFF;
+	dcmd->cmd_status = MFI_STAT_INVALID_STATUS;
 	dcmd->sge_count = 1;
 	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_NONE);
 	dcmd->timeout = 0;
@@ -4268,7 +4255,7 @@ megasas_issue_init_mfi(struct megasas_instance *instance)
 	initq_info->consumer_index_phys_addr_lo = cpu_to_le32(instance->consumer_h);
 
 	init_frame->cmd = MFI_CMD_INIT;
-	init_frame->cmd_status = 0xFF;
+	init_frame->cmd_status = MFI_STAT_INVALID_STATUS;
 	init_frame->queue_info_new_phys_addr_lo =
 		cpu_to_le32(lower_32_bits(initq_info_h));
 	init_frame->queue_info_new_phys_addr_hi =
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 826ba1c..99ad5d7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -584,7 +584,8 @@ wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
 	if (frame_hdr->cmd_status == 0xff)
 		return -ETIME;
 
-	return 0;
+	return (frame_hdr->cmd_status == MFI_STAT_OK) ?
+		0 : 1;
 }
 
 /**
-- 
1.7.1

