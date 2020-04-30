Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E2EC8300F
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C142076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgD3NU3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:60706 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgD3NUL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 88CD0AF4D;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 26/41] megaraid_sas_fusion: rearrange mfi and mpt frame pools
Date:   Thu, 30 Apr 2020 15:18:49 +0200
Message-Id: <20200430131904.5847-27-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rearrange the mfi frame pool to start at the beginning of
the mpt frame pool. This means that the command index for
the mpt and the mfi frame pool is identical (up to the size
of the mfi frame pool, of course), and the 'sync_cmd_idx'
structure entry can be dropped.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |  6 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 28 +++++++++++-----------------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  5 -----
 3 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 45adfd4b6b07..306c6495f1da 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -345,7 +345,7 @@ megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 		return;
 
 	if (fusion) {
-		blk_tags = instance->max_scsi_cmds + cmd->index;
+		blk_tags = cmd->index;
 		cmd_fusion = fusion->cmd_list[blk_tags];
 		megasas_return_cmd_fusion(instance, cmd_fusion);
 	}
@@ -2123,8 +2123,8 @@ static void megasas_complete_outstanding_ioctls(struct megasas_instance *instanc
 	if (fusion) {
 		for (i = 0; i < instance->max_fw_cmds; i++) {
 			cmd_fusion = fusion->cmd_list[i];
-			if (cmd_fusion->sync_cmd_idx != (u32)ULONG_MAX) {
-				cmd_mfi = instance->cmd_list[cmd_fusion->sync_cmd_idx];
+			if (i < instance->max_mfi_cmds) {
+				cmd_mfi = instance->cmd_list[i];
 				if (cmd_mfi->sync_cmd &&
 				    (cmd_mfi->frame->hdr.cmd != MFI_CMD_ABORT)) {
 					cmd_mfi->frame->hdr.cmd_status =
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f5915c9f474c..8e2ae44ab1f8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -982,10 +982,6 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		memset(cmd, 0, sizeof(struct megasas_cmd_fusion));
 		cmd->index = i + 1;
 		cmd->scmd = NULL;
-		cmd->sync_cmd_idx =
-		(i >= instance->max_scsi_cmds && i < instance->max_fw_cmds) ?
-				(i - instance->max_scsi_cmds) :
-				(u32)ULONG_MAX; /* Set to Invalid */
 		cmd->instance = instance;
 		cmd->io_request =
 			(struct MPI2_RAID_SCSI_IO_REQUEST *)
@@ -3612,7 +3608,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 				megasas_complete_r1_command(instance, cmd_fusion);
 			break;
 		case MEGASAS_MPI2_FUNCTION_PASSTHRU_IO_REQUEST: /*MFI command */
-			cmd_mfi = instance->cmd_list[cmd_fusion->sync_cmd_idx];
+			cmd_mfi = instance->cmd_list[cmd_fusion->index - 1];
 			/* Poll mode. Dummy free.
 			 * In case of Interrupt mode, caller has reverse check.
 			 */
@@ -3836,8 +3832,7 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
 
 	fusion = instance->ctrl_context;
 
-	cmd = megasas_get_cmd_fusion(instance,
-			instance->max_scsi_cmds + mfi_cmd->index);
+	cmd = megasas_get_cmd_fusion(instance, mfi_cmd->index);
 
 	/*  Save the smid. To be used for returning the cmd */
 	mfi_cmd->context.smid = cmd->index;
@@ -4246,11 +4241,11 @@ static void megasas_refire_mgmt_cmd(struct megasas_instance *instance,
 	fusion = instance->ctrl_context;
 
 	/* Re-fire management commands.
-	 * Do not traverse complet MPT frame pool. Start from max_scsi_cmds.
+	 * Do not traverse complete MPT frame pool, only the MFI frame pool.
 	 */
-	for (j = instance->max_scsi_cmds ; j < instance->max_fw_cmds; j++) {
+	for (j = 0; j < instance->max_mfi_cmds; j++) {
 		cmd_fusion = fusion->cmd_list[j];
-		cmd_mfi = instance->cmd_list[cmd_fusion->sync_cmd_idx];
+		cmd_mfi = instance->cmd_list[j];
 		smid = le16_to_cpu(cmd_mfi->context.smid);
 		result = REFIRE_CMD;
 
@@ -4334,9 +4329,9 @@ megasas_return_polled_cmds(struct megasas_instance *instance)
 
 	fusion = instance->ctrl_context;
 
-	for (i = instance->max_scsi_cmds; i < instance->max_fw_cmds; i++) {
+	for (i = 0; i < instance->max_mfi_cmds; i++) {
 		cmd_fusion = fusion->cmd_list[i];
-		cmd_mfi = instance->cmd_list[cmd_fusion->sync_cmd_idx];
+		cmd_mfi = instance->cmd_list[i];
 
 		if (cmd_mfi->flags & DRV_DCMD_POLLED_MODE) {
 			if (megasas_dbg_lvl & OCR_DEBUG)
@@ -4367,7 +4362,7 @@ static int megasas_track_scsiio(struct megasas_instance *instance,
 	struct fusion_context *fusion;
 	fusion = instance->ctrl_context;
 
-	for (i = 0 ; i < instance->max_scsi_cmds; i++) {
+	for (i = instance->max_mfi_cmds; i < instance->max_fw_cmds; i++) {
 		cmd_fusion = fusion->cmd_list[i];
 		if (cmd_fusion->scmd &&
 			(cmd_fusion->scmd->device->id == id &&
@@ -4480,8 +4475,7 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
 		return -ENOMEM;
 	}
 
-	cmd_fusion = megasas_get_cmd_fusion(instance,
-			instance->max_scsi_cmds + cmd_mfi->index);
+	cmd_fusion = megasas_get_cmd_fusion(instance, cmd_mfi->index);
 
 	/*  Save the smid. To be used for returning the cmd */
 	cmd_mfi->context.smid = cmd_fusion->index;
@@ -4601,7 +4595,7 @@ static u16 megasas_fusion_smid_lookup(struct scsi_cmnd *scmd)
 
 	fusion = instance->ctrl_context;
 
-	for (i = 0; i < instance->max_scsi_cmds; i++) {
+	for (i = instance->max_mfi_cmds; i < instance->max_fw_cmds; i++) {
 		cmd_fusion = fusion->cmd_list[i];
 		if (cmd_fusion->scmd && (cmd_fusion->scmd == scmd)) {
 			scmd_printk(KERN_NOTICE, scmd, "Abort request is for"
@@ -4918,7 +4912,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 			dev_info(&instance->pdev->dev, "\nPending SCSI commands:\n");
 
 		/* Now return commands back to the OS */
-		for (i = 0 ; i < instance->max_scsi_cmds; i++) {
+		for (i = instance->max_mfi_cmds; i < instance->max_fw_cmds; i++) {
 			cmd_fusion = fusion->cmd_list[i];
 			/*check for extra commands issued by driver*/
 			if (instance->adapter_type >= VENTURA_SERIES) {
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index d57ecc7f88d8..7f0abc66dbb1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1105,11 +1105,6 @@ struct megasas_cmd_fusion {
 	u8 retry_for_fw_reset;
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION  *request_desc;
 
-	/*
-	 * Context for a MFI frame.
-	 * Used to get the mfi cmd from list when a MFI cmd is completed
-	 */
-	u32 sync_cmd_idx;
 	u32 index;
 	u8 pd_r1_lb;
 	struct completion done;
-- 
2.16.4

