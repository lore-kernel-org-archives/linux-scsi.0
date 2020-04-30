Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB13BC83010
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 931132076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgD3NUd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:60752 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgD3NUJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 73ACBAF41;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 27/41] megaraid_sas_fusion: sanitize command lookup
Date:   Thu, 30 Apr 2020 15:18:50 +0200
Message-Id: <20200430131904.5847-28-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use megasas_get_cmd_fusion() to lookup a command from a scsi command,
and use direct array lookup whenever we already have an index.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 56 +++++++++--------------------
 1 file changed, 17 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 8e2ae44ab1f8..6c62c7f647f2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -231,14 +231,20 @@ megasas_clear_intr_fusion(struct megasas_instance *instance)
 /**
  * megasas_get_cmd_fusion -	Get a command from the free pool
  * @instance:		Adapter soft state
+ * @scmd:		SCSI command
+ * @is_raid:		true if the command is a RAID1 fastpath command
  *
  * Returns a blk_tag indexed mpt frame
  */
-inline struct megasas_cmd_fusion *megasas_get_cmd_fusion(struct megasas_instance
-						  *instance, u32 blk_tag)
+inline struct megasas_cmd_fusion *
+megasas_get_cmd_fusion(struct megasas_instance *instance,
+		       struct scsi_cmnd *scmd, bool is_raid)
 {
 	struct fusion_context *fusion;
+	u32 blk_tag = scmd->request->tag;
 
+	if (is_raid)
+		blk_tag += instance->max_fw_cmds;
 	fusion = instance->ctrl_context;
 	return fusion->cmd_list[blk_tag];
 }
@@ -3396,7 +3402,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
-	cmd = megasas_get_cmd_fusion(instance, scmd->request->tag);
+	cmd = megasas_get_cmd_fusion(instance, scmd, false);
 
 	if (!cmd) {
 		atomic_dec(&instance->fw_outstanding);
@@ -3436,8 +3442,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 	 *	to get new command
 	 */
 	if (cmd->r1_alt_dev_handle != MR_DEVHANDLE_INVALID) {
-		r1_cmd = megasas_get_cmd_fusion(instance,
-				(scmd->request->tag + instance->max_fw_cmds));
+		r1_cmd = megasas_get_cmd_fusion(instance, scmd, true);
 		megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
 	}
 
@@ -3832,7 +3837,7 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 
 	fusion = instance->ctrl_context;
 
-	cmd = megasas_get_cmd_fusion(instance, mfi_cmd->index);
+	cmd = fusion->cmd_list[mfi_cmd->index];
 
 	/*  Save the smid. To be used for returning the cmd */
 	mfi_cmd->context.smid = cmd->index;
@@ -4475,7 +4480,7 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
 		return -ENOMEM;
 	}
 
-	cmd_fusion = megasas_get_cmd_fusion(instance, cmd_mfi->index);
+	cmd_fusion = fusion->cmd_list[cmd_mfi->index];
 
 	/*  Save the smid. To be used for returning the cmd */
 	cmd_mfi->context.smid = cmd_fusion->index;
@@ -4578,36 +4583,6 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
 
 }
 
-/*
- * megasas_fusion_smid_lookup : Look for fusion command correpspodning to SCSI
- * @instance: per adapter struct
- *
- * Return Non Zero index, if SMID found in outstanding commands
- */
-static u16 megasas_fusion_smid_lookup(struct scsi_cmnd *scmd)
-{
-	int i, ret = 0;
-	struct megasas_instance *instance;
-	struct megasas_cmd_fusion *cmd_fusion;
-	struct fusion_context *fusion;
-
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
-
-	fusion = instance->ctrl_context;
-
-	for (i = instance->max_mfi_cmds; i < instance->max_fw_cmds; i++) {
-		cmd_fusion = fusion->cmd_list[i];
-		if (cmd_fusion->scmd && (cmd_fusion->scmd == scmd)) {
-			scmd_printk(KERN_NOTICE, scmd, "Abort request is for"
-				" SMID: %d\n", cmd_fusion->index);
-			ret = cmd_fusion->index;
-			break;
-		}
-	}
-
-	return ret;
-}
-
 /*
 * megasas_get_tm_devhandle - Get devhandle for TM request
 * @sdev-		     OS provided scsi device
@@ -4655,7 +4630,8 @@ static u16 megasas_get_tm_devhandle(struct scsi_device *sdev)
 int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 {
 	struct megasas_instance *instance;
-	u16 smid, devhandle;
+	struct megasas_cmd_fusion *cmd_fusion;
+	u16 smid = 0, devhandle;
 	int ret;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
 	mr_device_priv_data = scmd->device->hostdata;
@@ -4684,7 +4660,9 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 
 	mutex_lock(&instance->reset_mutex);
 
-	smid = megasas_fusion_smid_lookup(scmd);
+	cmd_fusion = megasas_get_cmd_fusion(instance, scmd, false);
+	if (cmd_fusion)
+		smid = cmd_fusion->index;
 
 	if (!smid) {
 		ret = SUCCESS;
-- 
2.16.4

