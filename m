From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v3 2/18] megaraid_sas : Add separate function for refiring MFI commands
Date: Thu, 23 Apr 2015 16:30:24 +0530
Message-ID: <201504231102.t3NB2eZU029452@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:6560
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933092AbbDWLAa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 07:00:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch will add separate function for refiring MFI commands in Fusion adapters's OCR code.

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   80 +++++++++++++--------------
 1 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 5a0800d..58b96f9 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2511,6 +2511,43 @@ void  megasas_reset_reply_desc(struct megasas_instance *instance)
 		reply_desc->Words = ULLONG_MAX;
 }
 
+/*
+ * megasas_refire_mgmt_cmd :	Re-fire management commands
+ * @instance:				Controller's soft instance
+*/
+void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
+{
+	int j;
+	struct megasas_cmd_fusion *cmd_fusion;
+	struct fusion_context *fusion;
+	struct megasas_cmd *cmd_mfi;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	u16 smid;
+
+	fusion = instance->ctrl_context;
+
+	/* Re-fire management commands.
+	 * Do not traverse complet MPT frame pool. Start from max_scsi_cmds.
+	 */
+	for (j = instance->max_scsi_cmds ; j < instance->max_fw_cmds; j++) {
+		cmd_fusion = fusion->cmd_list[j];
+		cmd_mfi = instance->cmd_list[cmd_fusion->sync_cmd_idx];
+		smid = le16_to_cpu(cmd_mfi->context.smid);
+
+		if (!smid)
+			continue;
+		req_desc = megasas_get_request_descriptor
+					(instance, smid - 1);
+		if (req_desc && (cmd_mfi->frame->dcmd.opcode !=
+				cpu_to_le32(MR_DCMD_LD_MAP_GET_INFO))) {
+			instance->instancet->fire_cmd(instance,
+				req_desc->u.low, req_desc->u.high,
+				instance->reg_set);
+		} else
+			megasas_return_cmd(instance, cmd_mfi);
+	}
+}
+
 /* Check for a second path that is currently UP */
 int megasas_check_mpio_paths(struct megasas_instance *instance,
 	struct scsi_cmnd *scmd)
@@ -2538,12 +2575,10 @@ out:
 /* Core fusion reset function */
 int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 {
-	int retval = SUCCESS, i, j, retry = 0, convert = 0;
+	int retval = SUCCESS, i, retry = 0, convert = 0;
 	struct megasas_instance *instance;
 	struct megasas_cmd_fusion *cmd_fusion;
 	struct fusion_context *fusion;
-	struct megasas_cmd *cmd_mfi;
-	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
 	u32 host_diag, abs_state, status_reg, reset_adapter;
 	u32 io_timeout_in_crash_mode = 0;
 
@@ -2790,44 +2825,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 				continue;
 			}
 
-			/* Re-fire management commands */
-			for (j = 0 ; j < instance->max_fw_cmds; j++) {
-				cmd_fusion = fusion->cmd_list[j];
-				if (cmd_fusion->sync_cmd_idx !=
-				    (u32)ULONG_MAX) {
-					cmd_mfi =
-					instance->
-					cmd_list[cmd_fusion->sync_cmd_idx];
-					if (cmd_mfi->frame->dcmd.opcode ==
-					    cpu_to_le32(MR_DCMD_LD_MAP_GET_INFO)) {
-						megasas_return_mfi_mpt_pthr(instance, cmd_mfi, cmd_fusion);
-					} else  {
-						req_desc =
-						megasas_get_request_descriptor(
-							instance,
-							cmd_mfi->context.smid
-							-1);
-						if (!req_desc) {
-							printk(KERN_WARNING
-							       "req_desc NULL"
-							       " for scsi%d\n",
-								instance->host->host_no);
-							/* Return leaked MPT
-							   frame */
-							megasas_return_cmd_fusion(instance, cmd_fusion);
-						} else {
-							instance->instancet->
-							fire_cmd(instance,
-								 req_desc->
-								 u.low,
-								 req_desc->
-								 u.high,
-								 instance->
-								 reg_set);
-						}
-					}
-				}
-			}
+			megasas_refire_mgmt_cmd(instance);
 
 			if (megasas_get_ctrl_info(instance)) {
 				dev_info(&instance->pdev->dev,
-- 
1.7.1

