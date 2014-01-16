From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/6] megaraid_sas: Do not wait forever
Date: Thu, 16 Jan 2014 11:25:31 +0100
Message-ID: <1389867936-118685-2-git-send-email-hare@suse.de>
References: <1389867936-118685-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbaAPKZi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 05:25:38 -0500
In-Reply-To: <1389867936-118685-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Kashyap Desai <kashyap.desai@lsi.com>, Adam Radford <aradford@gmail.com>

If the firmware is incommunicado for whatever reason the driver
will wait forever during initialisation, causing all sorts
of hangcheck timers to trigger.
We should rather wait for a defined time, and give up on the
command if no response was received.

Cc: Kashyap Desai <kashyap.desai@lsi.com>
Cc: Adam Radford <aradford@gmail.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 43 ++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3b7ad10..95d4e5c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -911,9 +911,11 @@ megasas_issue_blocked_cmd(struct megasas_instance *instance,
 
 	instance->instancet->issue_dcmd(instance, cmd);
 
-	wait_event(instance->int_cmd_wait_q, cmd->cmd_status != ENODATA);
+	wait_event_timeout(instance->int_cmd_wait_q,
+			   cmd->cmd_status != ENODATA,
+			   MEGASAS_INTERNAL_CMD_WAIT_TIME * HZ);
 
-	return 0;
+	return cmd->cmd_status == ENODATA ? -ENODATA : 0;
 }
 
 /**
@@ -932,11 +934,12 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
 {
 	struct megasas_cmd *cmd;
 	struct megasas_abort_frame *abort_fr;
+	int status;
 
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd)
-		return -1;
+		return -ENOMEM;
 
 	abort_fr = &cmd->frame->abort;
 
@@ -960,11 +963,14 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
 	/*
 	 * Wait for this cmd to complete
 	 */
-	wait_event(instance->abort_cmd_wait_q, cmd->cmd_status != 0xFF);
+	wait_event_timeout(instance->abort_cmd_wait_q,
+			   cmd->cmd_status != 0xFF,
+			   MEGASAS_INTERNAL_CMD_WAIT_TIME * HZ);
 	cmd->sync_cmd = 0;
+	status = cmd->cmd_status;
 
 	megasas_return_cmd(instance, cmd);
-	return 0;
+	return status == 0xFF ? -ENODATA : 0;
 }
 
 /**
@@ -3902,6 +3908,7 @@ megasas_get_seq_num(struct megasas_instance *instance,
 	struct megasas_dcmd_frame *dcmd;
 	struct megasas_evt_log_info *el_info;
 	dma_addr_t el_info_h = 0;
+	int rc;
 
 	cmd = megasas_get_cmd(instance);
 
@@ -3933,23 +3940,23 @@ megasas_get_seq_num(struct megasas_instance *instance,
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
-
+	rc = megasas_issue_blocked_cmd(instance, cmd);
+	if (!rc) {
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
 
 	megasas_return_cmd(instance, cmd);
 
-	return 0;
+	return rc;
 }
 
 /**
@@ -5045,7 +5052,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	 * cmd to the SCSI mid-layer
 	 */
 	cmd->sync_cmd = 1;
-	megasas_issue_blocked_cmd(instance, cmd);
+	error = megasas_issue_blocked_cmd(instance, cmd);
 	cmd->sync_cmd = 0;
 
 	/*
-- 
1.7.12.4

