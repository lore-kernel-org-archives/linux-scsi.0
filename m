From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 12/14] megaraid_sas: re-work DCMD refire code
Date: Fri,  5 Jan 2018 05:27:47 -0800
Message-ID: <1515158869-26693-13-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:41677 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbeAEN3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:40 -0500
Received: by mail-pl0-f65.google.com with SMTP id g2so3039380pli.8
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:40 -0800 (PST)
In-Reply-To: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

No functional changes.
This patch is a re-work of DCMD refire code to better manage
all the different cases to decide whether to REFIRE or SKIP
or COMPLETE certain DCMD.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |  6 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 55 ++++++++++++++++++++---------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  6 ++++
 3 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 40775408c222..d92279eec8f8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4694,10 +4694,12 @@ megasas_get_ctrl_info(struct megasas_instance *instance)
 				 sizeof(struct megasas_ctrl_info));
 
 	if ((instance->adapter_type != MFI_SERIES) &&
-	    !instance->mask_interrupts)
+	    !instance->mask_interrupts) {
 		ret = megasas_issue_blocked_cmd(instance, cmd, MFI_IO_TIMEOUT_SECS);
-	else
+	} else {
 		ret = megasas_issue_polled(instance, cmd);
+		cmd->flags |= DRV_DCMD_SKIP_REFIRE;
+	}
 
 	switch (ret) {
 	case DCMD_SUCCESS:
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index ef36f2ac7cb6..0a85f3c48ef6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3957,6 +3957,8 @@ void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
 	u16 smid;
 	bool refire_cmd = 0;
+	u8 result;
+	u32 opcode = 0;
 
 	fusion = instance->ctrl_context;
 
@@ -3967,29 +3969,47 @@ void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
 		cmd_fusion = fusion->cmd_list[j];
 		cmd_mfi = instance->cmd_list[cmd_fusion->sync_cmd_idx];
 		smid = le16_to_cpu(cmd_mfi->context.smid);
+		result = REFIRE_CMD;
 
 		if (!smid)
 			continue;
 
-		/* Do not refire shutdown command */
-		if (le32_to_cpu(cmd_mfi->frame->dcmd.opcode) ==
-			MR_DCMD_CTRL_SHUTDOWN) {
-			cmd_mfi->frame->dcmd.cmd_status = MFI_STAT_OK;
-			megasas_complete_cmd(instance, cmd_mfi, DID_OK);
-			continue;
+		req_desc = megasas_get_request_descriptor(instance, smid - 1);
+
+		switch (cmd_mfi->frame->hdr.cmd) {
+		case MFI_CMD_DCMD:
+			opcode = le32_to_cpu(cmd_mfi->frame->dcmd.opcode);
+			 /* Do not refire shutdown command */
+			if (opcode == MR_DCMD_CTRL_SHUTDOWN) {
+				cmd_mfi->frame->dcmd.cmd_status = MFI_STAT_OK;
+				result = COMPLETE_CMD;
+				break;
+			}
+
+			refire_cmd = ((opcode != MR_DCMD_LD_MAP_GET_INFO)) &&
+				      (opcode != MR_DCMD_SYSTEM_PD_MAP_GET_INFO) &&
+				      !(cmd_mfi->flags & DRV_DCMD_SKIP_REFIRE);
+
+			if (!refire_cmd)
+				result = RETURN_CMD;
+
+			break;
+
+		default:
+			break;
 		}
 
-		req_desc = megasas_get_request_descriptor
-					(instance, smid - 1);
-		refire_cmd = req_desc && ((cmd_mfi->frame->dcmd.opcode !=
-				cpu_to_le32(MR_DCMD_LD_MAP_GET_INFO)) &&
-				 (cmd_mfi->frame->dcmd.opcode !=
-				cpu_to_le32(MR_DCMD_SYSTEM_PD_MAP_GET_INFO)))
-				&& !(cmd_mfi->flags & DRV_DCMD_SKIP_REFIRE);
-		if (refire_cmd)
+		switch (result) {
+		case REFIRE_CMD:
 			megasas_fire_cmd_fusion(instance, req_desc);
-		else
+			break;
+		case RETURN_CMD:
 			megasas_return_cmd(instance, cmd_mfi);
+			break;
+		case COMPLETE_CMD:
+			megasas_complete_cmd(instance, cmd_mfi, DID_OK);
+			break;
+		}
 	}
 }
 
@@ -4629,8 +4649,6 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 					continue;
 			}
 
-			megasas_refire_mgmt_cmd(instance);
-
 			if (megasas_get_ctrl_info(instance)) {
 				dev_info(&instance->pdev->dev,
 					"Failed from %s %d\n",
@@ -4639,6 +4657,9 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 				retval = FAILED;
 				goto out;
 			}
+
+			megasas_refire_mgmt_cmd(instance);
+
 			/* Reset load balance info */
 			if (fusion->load_balance_info)
 				memset(fusion->load_balance_info, 0,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 1814d79cb98d..8e5ebee6517f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1344,6 +1344,12 @@ union desc_value {
 	} u;
 };
 
+enum CMD_RET_VALUES {
+	REFIRE_CMD = 1,
+	COMPLETE_CMD = 2,
+	RETURN_CMD = 3,
+};
+
 void megasas_free_cmds_fusion(struct megasas_instance *instance);
 int megasas_ioc_init_fusion(struct megasas_instance *instance);
 u8 megasas_get_map_info(struct megasas_instance *instance);
-- 
2.14.1
