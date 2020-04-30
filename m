Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3494EC8300B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F4CA20870
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgD3NUR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:60972 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgD3NUM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B7542AF79;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 28/41] megaraid_sas: use scsi_host_busy_iter to traverse outstanding commands
Date:   Thu, 30 Apr 2020 15:18:51 +0200
Message-Id: <20200430131904.5847-29-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As the block layer now accounts for all outstanding commands we
can use scsi_host_busy_iter() to traverse all commands.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas.h        |   1 +
 drivers/scsi/megaraid/megaraid_sas_base.c   | 265 +++++++++++++---------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 329 +++++++++++++++-------------
 3 files changed, 334 insertions(+), 261 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index bb765e715011..2a089d2ba37b 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2406,6 +2406,7 @@ struct megasas_instance {
 	struct megasas_cmd *jbod_seq_cmd;
 	unsigned long bar;
 	long reset_flags;
+	unsigned int reset_count;
 	struct mutex reset_mutex;
 	struct timer_list sriov_heartbeat_timer;
 	char skip_heartbeat_timer_del;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 306c6495f1da..d889119e9c4d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1633,76 +1633,126 @@ inline int megasas_cmd_type(struct scsi_cmnd *cmd)
 	return ret;
 }
 
- /**
- * megasas_dump_pending_frames -	Dumps the frame address of all pending cmds
- *					in FW
- * @instance:				Adapter soft state
- */
-static inline void
-megasas_dump_pending_frames(struct megasas_instance *instance)
+static bool megasas_dump_scsi_frame_iter(struct scsi_cmnd *scmd, void *data,
+					 bool reserved)
 {
+	struct megasas_instance *instance = data;
 	struct megasas_cmd *cmd;
-	int i,n;
 	union megasas_sgl *mfi_sgl;
 	struct megasas_io_frame *ldio;
 	struct megasas_pthru_frame *pthru;
 	u32 sgcount;
-	u16 max_cmd = instance->max_fw_cmds;
+	u32 index = scmd->request->tag + 1;
 
-	dev_err(&instance->pdev->dev, "[%d]: Dumping Frame Phys Address of all pending cmds in FW\n",instance->host->host_no);
-	dev_err(&instance->pdev->dev, "[%d]: Total OS Pending cmds : %d\n",instance->host->host_no,atomic_read(&instance->fw_outstanding));
-	if (IS_DMA64)
-		dev_err(&instance->pdev->dev, "[%d]: 64 bit SGLs were sent to FW\n",instance->host->host_no);
-	else
-		dev_err(&instance->pdev->dev, "[%d]: 32 bit SGLs were sent to FW\n",instance->host->host_no);
+	if (reserved)
+		return true;
 
-	dev_err(&instance->pdev->dev, "[%d]: Pending OS cmds in FW : \n",instance->host->host_no);
-	for (i = 0; i < max_cmd; i++) {
-		cmd = instance->cmd_list[i];
-		if (!cmd->scmd)
-			continue;
-		dev_err(&instance->pdev->dev, "[%d]: Frame addr :0x%08lx : ",instance->host->host_no,(unsigned long)cmd->frame_phys_addr);
-		if (megasas_cmd_type(cmd->scmd) == READ_WRITE_LDIO) {
-			ldio = (struct megasas_io_frame *)cmd->frame;
-			mfi_sgl = &ldio->sgl;
-			sgcount = ldio->sge_count;
-			dev_err(&instance->pdev->dev, "[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x,"
-			" lba lo : 0x%x, lba_hi : 0x%x, sense_buf addr : 0x%x,sge count : 0x%x\n",
-			instance->host->host_no, cmd->frame_count, ldio->cmd, ldio->target_id,
-			le32_to_cpu(ldio->start_lba_lo), le32_to_cpu(ldio->start_lba_hi),
+	cmd = instance->cmd_list[index];
+	dev_err(&instance->pdev->dev,
+		"[%d]: Frame addr :0x%08lx : ",
+		instance->host->host_no,
+		(unsigned long)cmd->frame_phys_addr);
+	if (megasas_cmd_type(cmd->scmd) == READ_WRITE_LDIO) {
+		ldio = (struct megasas_io_frame *)cmd->frame;
+
+		mfi_sgl = &ldio->sgl;
+		sgcount = ldio->sge_count;
+		dev_err(&instance->pdev->dev,
+			"[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x,"
+			" lba lo : 0x%x, lba_hi : 0x%x, "
+			"sense_buf addr : 0x%x, sge count : 0x%x\n",
+			instance->host->host_no, cmd->frame_count,
+			ldio->cmd, ldio->target_id,
+			le32_to_cpu(ldio->start_lba_lo),
+			le32_to_cpu(ldio->start_lba_hi),
 			le32_to_cpu(ldio->sense_buf_phys_addr_lo), sgcount);
-		} else {
-			pthru = (struct megasas_pthru_frame *) cmd->frame;
-			mfi_sgl = &pthru->sgl;
-			sgcount = pthru->sge_count;
-			dev_err(&instance->pdev->dev, "[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, "
-			"lun : 0x%x, cdb_len : 0x%x, data xfer len : 0x%x, sense_buf addr : 0x%x,sge count : 0x%x\n",
-			instance->host->host_no, cmd->frame_count, pthru->cmd, pthru->target_id,
-			pthru->lun, pthru->cdb_len, le32_to_cpu(pthru->data_xfer_len),
+	} else {
+		pthru = (struct megasas_pthru_frame *) cmd->frame;
+		mfi_sgl = &pthru->sgl;
+		sgcount = pthru->sge_count;
+		dev_err(&instance->pdev->dev,
+			"[%d]: frame count : 0x%x, Cmd : 0x%x, Tgt id : 0x%x, "
+			"lun : 0x%x, cdb_len : 0x%x, data xfer len : 0x%x, "
+			"sense_buf addr : 0x%x, sge count : 0x%x\n",
+			instance->host->host_no, cmd->frame_count,
+			pthru->cmd, pthru->target_id, pthru->lun,
+			pthru->cdb_len, le32_to_cpu(pthru->data_xfer_len),
 			le32_to_cpu(pthru->sense_buf_phys_addr_lo), sgcount);
+	}
+	if (megasas_dbg_lvl & MEGASAS_DBG_LVL) {
+		int n;
+
+		for (n = 0; n < sgcount; n++) {
+			if (IS_DMA64)
+				dev_err(&instance->pdev->dev,
+					"sgl len : 0x%x, sgl addr : 0x%llx\n",
+					le32_to_cpu(mfi_sgl->sge64[n].length),
+					le64_to_cpu(mfi_sgl->sge64[n].phys_addr));
+			else
+				dev_err(&instance->pdev->dev,
+					"sgl len : 0x%x, sgl addr : 0x%x\n",
+					le32_to_cpu(mfi_sgl->sge32[n].length),
+					le32_to_cpu(mfi_sgl->sge32[n].phys_addr));
 		}
-		if (megasas_dbg_lvl & MEGASAS_DBG_LVL) {
-			for (n = 0; n < sgcount; n++) {
-				if (IS_DMA64)
-					dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%llx\n",
-						le32_to_cpu(mfi_sgl->sge64[n].length),
-						le64_to_cpu(mfi_sgl->sge64[n].phys_addr));
-				else
-					dev_err(&instance->pdev->dev, "sgl len : 0x%x, sgl addr : 0x%x\n",
-						le32_to_cpu(mfi_sgl->sge32[n].length),
-						le32_to_cpu(mfi_sgl->sge32[n].phys_addr));
-			}
-		}
-	} /*for max_cmd*/
-	dev_err(&instance->pdev->dev, "[%d]: Pending Internal cmds in FW : \n",instance->host->host_no);
-	for (i = 0; i < max_cmd; i++) {
+	}
+	return true;
+}
 
-		cmd = instance->cmd_list[i];
+static bool megasas_dump_fw_frame_iter(struct scsi_cmnd *scmd, void *data,
+				       bool reserved)
+{
+	struct megasas_instance *instance = data;
+	struct megasas_cmd *cmd;
+	u32 index = scmd->request->tag + 1;
 
-		if (cmd->sync_cmd == 1)
-			dev_err(&instance->pdev->dev, "0x%08lx : ", (unsigned long)cmd->frame_phys_addr);
-	}
-	dev_err(&instance->pdev->dev, "[%d]: Dumping Done\n\n",instance->host->host_no);
+	if (reserved)
+		return true;
+
+	cmd = instance->cmd_list[index];
+	if (cmd->sync_cmd == 1)
+		dev_err(&instance->pdev->dev,
+			"[%d]: Frame addr :0x%08lx : ",
+			instance->host->host_no,
+			(unsigned long)cmd->frame_phys_addr);
+	return true;
+}
+
+/**
+ * megasas_dump_pending_frames -	Dumps the frame address of all pending cmds
+ *					in FW
+ * @instance:				Adapter soft state
+ */
+static inline void
+megasas_dump_pending_frames(struct megasas_instance *instance)
+{
+	dev_err(&instance->pdev->dev,
+		"[%d]: Dumping Frame Phys Address of all pending cmds in FW\n",
+		instance->host->host_no);
+	dev_err(&instance->pdev->dev, "[%d]: Total OS Pending cmds : %d\n",
+		instance->host->host_no,
+		atomic_read(&instance->fw_outstanding));
+	if (IS_DMA64)
+		dev_err(&instance->pdev->dev,
+			"[%d]: 64 bit SGLs were sent to FW\n",
+			instance->host->host_no);
+	else
+		dev_err(&instance->pdev->dev,
+			"[%d]: 32 bit SGLs were sent to FW\n",
+			instance->host->host_no);
+
+	dev_err(&instance->pdev->dev,
+		"[%d]: Pending OS cmds in FW : \n",
+		instance->host->host_no);
+	scsi_host_busy_iter(instance->host, megasas_dump_scsi_frame_iter,
+			    instance);
+
+	dev_err(&instance->pdev->dev,
+		"[%d]: Pending Internal cmds in FW : \n",
+		instance->host->host_no);
+	scsi_host_busy_iter(instance->host, megasas_dump_fw_frame_iter,
+			    instance);
+	dev_err(&instance->pdev->dev,
+		"[%d]: Dumping Done\n\n", instance->host->host_no);
 }
 
 u32
@@ -2106,6 +2156,24 @@ static void megasas_slave_destroy(struct scsi_device *sdev)
 	sdev->hostdata = NULL;
 }
 
+static bool megasas_complete_cmd_iter(struct scsi_cmnd *scmd,
+				      void *data, bool reserved)
+{
+	struct megasas_instance *instance = data;
+	struct megasas_cmd *cmd_mfi;
+	u32 index = scmd->request->tag + 1;
+
+	cmd_mfi = instance->cmd_list[index];
+	if (cmd_mfi->sync_cmd &&
+	    cmd_mfi->frame->hdr.cmd != MFI_CMD_ABORT) {
+		if (instance->ctrl_context)
+			cmd_mfi->frame->hdr.cmd_status =
+				MFI_STAT_WRONG_STATE;
+		megasas_complete_cmd(instance, cmd_mfi, DID_OK);
+	}
+	return true;
+}
+
 /*
 * megasas_complete_outstanding_ioctls - Complete outstanding ioctls after a
 *                                       kill adapter
@@ -2114,34 +2182,9 @@ static void megasas_slave_destroy(struct scsi_device *sdev)
 */
 static void megasas_complete_outstanding_ioctls(struct megasas_instance *instance)
 {
-	int i;
-	struct megasas_cmd *cmd_mfi;
-	struct megasas_cmd_fusion *cmd_fusion;
-	struct fusion_context *fusion = instance->ctrl_context;
-
 	/* Find all outstanding ioctls */
-	if (fusion) {
-		for (i = 0; i < instance->max_fw_cmds; i++) {
-			cmd_fusion = fusion->cmd_list[i];
-			if (i < instance->max_mfi_cmds) {
-				cmd_mfi = instance->cmd_list[i];
-				if (cmd_mfi->sync_cmd &&
-				    (cmd_mfi->frame->hdr.cmd != MFI_CMD_ABORT)) {
-					cmd_mfi->frame->hdr.cmd_status =
-							MFI_STAT_WRONG_STATE;
-					megasas_complete_cmd(instance,
-							     cmd_mfi, DID_OK);
-				}
-			}
-		}
-	} else {
-		for (i = 0; i < instance->max_fw_cmds; i++) {
-			cmd_mfi = instance->cmd_list[i];
-			if (cmd_mfi->sync_cmd && cmd_mfi->frame->hdr.cmd !=
-				MFI_CMD_ABORT)
-				megasas_complete_cmd(instance, cmd_mfi, DID_OK);
-		}
-	}
+	scsi_host_busy_iter(instance->host, megasas_complete_cmd_iter,
+			    instance);
 }
 
 
@@ -3759,6 +3802,33 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 	megasas_register_aen(instance, seq_num, class_locale.word);
 }
 
+static bool
+megasas_reset_defer_cmds_iter(struct scsi_cmnd *scmd, void *data, bool rsvd)
+{
+	struct megasas_instance *instance = data;
+	struct megasas_cmd *cmd;
+	u32 index = scmd->request->tag + 1;
+
+	cmd = instance->cmd_list[index];
+	if (cmd->sync_cmd == 1 || cmd->scmd) {
+		dev_notice(&instance->pdev->dev, "moving cmd[%d]:%p:%d:%p"
+			   "on the defer queue as internal\n",
+			   index, cmd, cmd->sync_cmd, cmd->scmd);
+
+		if (!list_empty(&cmd->list)) {
+			dev_notice(&instance->pdev->dev, "ERROR while"
+				   " moving this cmd:%p, %d %p, it was"
+				   "discovered on some list?\n",
+				   cmd, cmd->sync_cmd, cmd->scmd);
+
+			list_del_init(&cmd->list);
+		}
+		list_add_tail(&cmd->list,
+			      &instance->internal_reset_pending_q);
+	}
+	return true;
+}
+
 /**
  * Move the internal reset pending commands to a deferred queue.
  *
@@ -3771,34 +3841,11 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 static void
 megasas_internal_reset_defer_cmds(struct megasas_instance *instance)
 {
-	struct megasas_cmd *cmd;
-	int i;
-	u16 max_cmd = instance->max_fw_cmds;
-	u32 defer_index;
 	unsigned long flags;
 
-	defer_index = 0;
 	spin_lock_irqsave(&instance->mfi_pool_lock, flags);
-	for (i = 0; i < max_cmd; i++) {
-		cmd = instance->cmd_list[i];
-		if (cmd->sync_cmd == 1 || cmd->scmd) {
-			dev_notice(&instance->pdev->dev, "moving cmd[%d]:%p:%d:%p"
-					"on the defer queue as internal\n",
-				defer_index, cmd, cmd->sync_cmd, cmd->scmd);
-
-			if (!list_empty(&cmd->list)) {
-				dev_notice(&instance->pdev->dev, "ERROR while"
-					" moving this cmd:%p, %d %p, it was"
-					"discovered on some list?\n",
-					cmd, cmd->sync_cmd, cmd->scmd);
-
-				list_del_init(&cmd->list);
-			}
-			defer_index++;
-			list_add_tail(&cmd->list,
-				&instance->internal_reset_pending_q);
-		}
-	}
+	scsi_host_busy_iter(instance->host, megasas_reset_defer_cmds_iter,
+			    instance);
 	spin_unlock_irqrestore(&instance->mfi_pool_lock, flags);
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 6c62c7f647f2..413890ef52ce 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4227,96 +4227,122 @@ void  megasas_reset_reply_desc(struct megasas_instance *instance)
 }
 
 /*
- * megasas_refire_mgmt_cmd :	Re-fire management commands
- * @instance:				Controller's soft instance
-*/
-static void megasas_refire_mgmt_cmd(struct megasas_instance *instance,
-			     bool return_ioctl)
+ * Re-fire management commands.
+ * Do not traverse complet MPT frame pool, only the MFI frame pool.
+ */
+static bool megasas_refire_mgmt_cmd_iter(struct scsi_cmnd *scmd,
+					 void *data, bool reserved)
 {
-	int j;
-	struct megasas_cmd_fusion *cmd_fusion;
-	struct fusion_context *fusion;
 	struct megasas_cmd *cmd_mfi;
+	struct megasas_instance *instance = data;
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
 	u16 smid;
 	bool refire_cmd = 0;
 	u8 result;
 	u32 opcode = 0;
 
-	fusion = instance->ctrl_context;
-
-	/* Re-fire management commands.
-	 * Do not traverse complete MPT frame pool, only the MFI frame pool.
-	 */
-	for (j = 0; j < instance->max_mfi_cmds; j++) {
-		cmd_fusion = fusion->cmd_list[j];
-		cmd_mfi = instance->cmd_list[j];
-		smid = le16_to_cpu(cmd_mfi->context.smid);
-		result = REFIRE_CMD;
+	if (!reserved)
+		return true;
 
-		if (!smid)
-			continue;
+	cmd_mfi = instance->cmd_list[scmd->request->tag];
+	smid = le16_to_cpu(cmd_mfi->context.smid);
+	result = REFIRE_CMD;
 
-		req_desc = megasas_get_request_descriptor(instance, smid - 1);
-
-		switch (cmd_mfi->frame->hdr.cmd) {
-		case MFI_CMD_DCMD:
-			opcode = le32_to_cpu(cmd_mfi->frame->dcmd.opcode);
-			 /* Do not refire shutdown command */
-			if (opcode == MR_DCMD_CTRL_SHUTDOWN) {
-				cmd_mfi->frame->dcmd.cmd_status = MFI_STAT_OK;
-				result = COMPLETE_CMD;
-				break;
-			}
+	if (!smid)
+		return true;
 
-			refire_cmd = ((opcode != MR_DCMD_LD_MAP_GET_INFO)) &&
-				      (opcode != MR_DCMD_SYSTEM_PD_MAP_GET_INFO) &&
-				      !(cmd_mfi->flags & DRV_DCMD_SKIP_REFIRE);
+	req_desc = megasas_get_request_descriptor(instance, smid - 1);
 
-			if (!refire_cmd)
-				result = RETURN_CMD;
+	switch (cmd_mfi->frame->hdr.cmd) {
+	case MFI_CMD_DCMD:
+		opcode = le32_to_cpu(cmd_mfi->frame->dcmd.opcode);
+		/* Do not refire shutdown command */
+		if (opcode == MR_DCMD_CTRL_SHUTDOWN) {
+			cmd_mfi->frame->dcmd.cmd_status = MFI_STAT_OK;
+			result = COMPLETE_CMD;
+			return true;
+		}
 
-			break;
-		case MFI_CMD_NVME:
-			if (!instance->support_nvme_passthru) {
-				cmd_mfi->frame->hdr.cmd_status = MFI_STAT_INVALID_CMD;
-				result = COMPLETE_CMD;
-			}
+		refire_cmd = ((opcode != MR_DCMD_LD_MAP_GET_INFO)) &&
+			(opcode != MR_DCMD_SYSTEM_PD_MAP_GET_INFO) &&
+			!(cmd_mfi->flags & DRV_DCMD_SKIP_REFIRE);
 
-			break;
-		case MFI_CMD_TOOLBOX:
-			if (!instance->support_pci_lane_margining) {
-				cmd_mfi->frame->hdr.cmd_status = MFI_STAT_INVALID_CMD;
-				result = COMPLETE_CMD;
-			}
+		if (!refire_cmd)
+			result = RETURN_CMD;
 
-			break;
-		default:
-			break;
+		break;
+	case MFI_CMD_NVME:
+		if (!instance->support_nvme_passthru) {
+			cmd_mfi->frame->hdr.cmd_status = MFI_STAT_INVALID_CMD;
+			result = COMPLETE_CMD;
 		}
 
-		if (return_ioctl && cmd_mfi->sync_cmd &&
-		    cmd_mfi->frame->hdr.cmd != MFI_CMD_ABORT) {
-			dev_err(&instance->pdev->dev,
-				"return -EBUSY from %s %d cmd 0x%x opcode 0x%x\n",
-				__func__, __LINE__, cmd_mfi->frame->hdr.cmd,
-				le32_to_cpu(cmd_mfi->frame->dcmd.opcode));
-			cmd_mfi->cmd_status_drv = DCMD_BUSY;
+		break;
+	case MFI_CMD_TOOLBOX:
+		if (!instance->support_pci_lane_margining) {
+			cmd_mfi->frame->hdr.cmd_status = MFI_STAT_INVALID_CMD;
 			result = COMPLETE_CMD;
 		}
 
-		switch (result) {
-		case REFIRE_CMD:
-			megasas_fire_cmd_fusion(instance, req_desc);
-			break;
-		case RETURN_CMD:
-			megasas_return_cmd(instance, cmd_mfi);
-			break;
-		case COMPLETE_CMD:
-			megasas_complete_cmd(instance, cmd_mfi, DID_OK);
-			break;
-		}
+		break;
+	default:
+		break;
+	}
+
+	if (!instance->reset_count && cmd_mfi->sync_cmd &&
+	    cmd_mfi->frame->hdr.cmd != MFI_CMD_ABORT) {
+		dev_err(&instance->pdev->dev,
+			"return -EBUSY from %s %d cmd 0x%x opcode 0x%x\n",
+			__func__, __LINE__, cmd_mfi->frame->hdr.cmd,
+			le32_to_cpu(cmd_mfi->frame->dcmd.opcode));
+		cmd_mfi->cmd_status_drv = DCMD_BUSY;
+		result = COMPLETE_CMD;
+	}
+
+	switch (result) {
+	case REFIRE_CMD:
+		megasas_fire_cmd_fusion(instance, req_desc);
+		break;
+	case RETURN_CMD:
+		megasas_return_cmd(instance, cmd_mfi);
+		break;
+	case COMPLETE_CMD:
+		megasas_complete_cmd(instance, cmd_mfi, DID_OK);
+		break;
+	}
+	return true;
+}
+
+/*
+ * megasas_refire_mgmt_cmd :	Re-fire management commands
+ * @instance:				Controller's soft instance
+*/
+static void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
+{
+	scsi_host_busy_iter(instance->host, megasas_refire_mgmt_cmd_iter,
+			    instance);
+}
+
+static bool megasas_polled_cmds_iter(struct scsi_cmnd *scmd, void *data,
+				     bool reserved)
+{
+	struct megasas_instance *instance = data;
+	u32 index = scmd->request->tag;
+	struct megasas_cmd *cmd_mfi;
+
+	if (!reserved)
+		return true;
+	cmd_mfi = instance->cmd_list[index];
+	if (cmd_mfi->flags & DRV_DCMD_POLLED_MODE) {
+		if (megasas_dbg_lvl & OCR_DEBUG)
+			dev_info(&instance->pdev->dev,
+				 "%s %d return cmd 0x%x opcode 0x%x\n",
+				 __func__, __LINE__, cmd_mfi->frame->hdr.cmd,
+				 le32_to_cpu(cmd_mfi->frame->dcmd.opcode));
+		cmd_mfi->flags &= ~DRV_DCMD_POLLED_MODE;
+		megasas_return_cmd(instance, cmd_mfi);
 	}
+	return true;
 }
 
 /*
@@ -4327,27 +4353,36 @@ static void megasas_refire_mgmt_cmd(struct megasas_instance *instance,
 static void
 megasas_return_polled_cmds(struct megasas_instance *instance)
 {
-	int i;
-	struct megasas_cmd_fusion *cmd_fusion;
-	struct fusion_context *fusion;
-	struct megasas_cmd *cmd_mfi;
-
-	fusion = instance->ctrl_context;
+	scsi_host_busy_iter(instance->host, megasas_polled_cmds_iter, instance);
+}
 
-	for (i = 0; i < instance->max_mfi_cmds; i++) {
-		cmd_fusion = fusion->cmd_list[i];
-		cmd_mfi = instance->cmd_list[i];
+struct megasas_track_scsiio_data {
+	struct megasas_instance *instance;
+	unsigned int id;
+	unsigned int channel;
+	bool io_pending;
+};
 
-		if (cmd_mfi->flags & DRV_DCMD_POLLED_MODE) {
-			if (megasas_dbg_lvl & OCR_DEBUG)
-				dev_info(&instance->pdev->dev,
-					 "%s %d return cmd 0x%x opcode 0x%x\n",
-					 __func__, __LINE__, cmd_mfi->frame->hdr.cmd,
-					 le32_to_cpu(cmd_mfi->frame->dcmd.opcode));
-			cmd_mfi->flags &= ~DRV_DCMD_POLLED_MODE;
-			megasas_return_cmd(instance, cmd_mfi);
-		}
+static bool megasas_track_scsiio_iter(struct scsi_cmnd *scmd, void *data,
+				      bool reserved)
+{
+	struct megasas_track_scsiio_data *iter_data = data;
+	u32 index = scmd->request->tag;
+
+	if (reserved)
+		return true;
+
+	if (scmd->device->id == iter_data->id &&
+	    scmd->device->channel == iter_data->channel) {
+		dev_info(&iter_data->instance->pdev->dev,
+			 "SCSI commands pending to target"
+			 "channel %d id %d \tSMID: 0x%x\n",
+			 iter_data->channel, iter_data->id, index);
+		scsi_print_command(scmd);
+		iter_data->io_pending = true;
+		return false;
 	}
+	return true;
 }
 
 /*
@@ -4362,27 +4397,16 @@ megasas_return_polled_cmds(struct megasas_instance *instance)
 static int megasas_track_scsiio(struct megasas_instance *instance,
 		int id, int channel)
 {
-	int i, found = 0;
-	struct megasas_cmd_fusion *cmd_fusion;
-	struct fusion_context *fusion;
-	fusion = instance->ctrl_context;
-
-	for (i = instance->max_mfi_cmds; i < instance->max_fw_cmds; i++) {
-		cmd_fusion = fusion->cmd_list[i];
-		if (cmd_fusion->scmd &&
-			(cmd_fusion->scmd->device->id == id &&
-			cmd_fusion->scmd->device->channel == channel)) {
-			dev_info(&instance->pdev->dev,
-				"SCSI commands pending to target"
-				"channel %d id %d \tSMID: 0x%x\n",
-				channel, id, cmd_fusion->index);
-			scsi_print_command(cmd_fusion->scmd);
-			found = 1;
-			break;
-		}
-	}
-
-	return found ? FAILED : SUCCESS;
+	struct megasas_track_scsiio_data iter_data = {
+		.instance = instance,
+		.id = id,
+		.channel = channel,
+		.io_pending = false,
+	};
+
+	scsi_host_busy_iter(instance->host, megasas_track_scsiio_iter,
+			    &iter_data);
+	return iter_data.io_pending ? FAILED : SUCCESS;
 }
 
 /**
@@ -4804,24 +4828,58 @@ int megasas_check_mpio_paths(struct megasas_instance *instance,
 	return retval;
 }
 
+static bool megasas_return_cmd_iter(struct scsi_cmnd *scmd, void *data,
+				    bool reserved)
+{
+	struct megasas_instance *instance = data;
+	struct fusion_context *fusion = instance->ctrl_context;
+	struct megasas_cmd_fusion *cmd_fusion;
+	u32 index = scmd->request->tag;
+
+	if (reserved)
+		return true;
+
+	cmd_fusion = fusion->cmd_list[index];
+	/* check for extra commands issued by driver*/
+	if (instance->adapter_type >= VENTURA_SERIES) {
+		struct megasas_cmd_fusion *r1_cmd;
+
+		r1_cmd = fusion->cmd_list[index + instance->max_fw_cmds];
+		megasas_return_cmd_fusion(instance, r1_cmd);
+	}
+	if (megasas_dbg_lvl & OCR_DEBUG) {
+		sdev_printk(KERN_INFO,
+			    scmd->device, "SMID: 0x%x\n",
+			    cmd_fusion->index);
+		megasas_dump_fusion_io(scmd);
+	}
+
+	scmd->result = megasas_check_mpio_paths(instance, scmd);
+	if (instance->ldio_threshold &&
+	    megasas_cmd_type(scmd) == READ_WRITE_LDIO)
+		atomic_dec(&instance->ldio_outstanding);
+	megasas_return_cmd_fusion(instance, cmd_fusion);
+	scsi_dma_unmap(scmd);
+	scmd->scsi_done(scmd);
+	return true;
+}
+
 /* Core fusion reset function */
 int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 {
-	int retval = SUCCESS, i, j, convert = 0;
+	int retval = SUCCESS, j, convert = 0;
 	struct megasas_instance *instance;
-	struct megasas_cmd_fusion *cmd_fusion, *r1_cmd;
 	struct fusion_context *fusion;
-	u32 abs_state, status_reg, reset_adapter, fpio_count = 0;
+	u32 abs_state, status_reg, reset_adapter;
 	u32 io_timeout_in_crash_mode = 0;
-	struct scsi_cmnd *scmd_local = NULL;
 	struct scsi_device *sdev;
 	int ret_target_prop = DCMD_FAILED;
 	bool is_target_prop = false;
 	bool do_adp_reset = true;
-	int max_reset_tries = MEGASAS_FUSION_MAX_RESET_TRIES;
 
 	instance = (struct megasas_instance *)shost->hostdata;
 	fusion = instance->ctrl_context;
+	instance->reset_count = MEGASAS_FUSION_MAX_RESET_TRIES;
 
 	mutex_lock(&instance->reset_mutex);
 
@@ -4890,40 +4948,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 			dev_info(&instance->pdev->dev, "\nPending SCSI commands:\n");
 
 		/* Now return commands back to the OS */
-		for (i = instance->max_mfi_cmds; i < instance->max_fw_cmds; i++) {
-			cmd_fusion = fusion->cmd_list[i];
-			/*check for extra commands issued by driver*/
-			if (instance->adapter_type >= VENTURA_SERIES) {
-				r1_cmd = fusion->cmd_list[i + instance->max_fw_cmds];
-				megasas_return_cmd_fusion(instance, r1_cmd);
-			}
-			scmd_local = cmd_fusion->scmd;
-			if (cmd_fusion->scmd) {
-				if (megasas_dbg_lvl & OCR_DEBUG) {
-					sdev_printk(KERN_INFO,
-						cmd_fusion->scmd->device, "SMID: 0x%x\n",
-						cmd_fusion->index);
-					megasas_dump_fusion_io(cmd_fusion->scmd);
-				}
-
-				if (cmd_fusion->io_request->Function ==
-					MPI2_FUNCTION_SCSI_IO_REQUEST)
-					fpio_count++;
-
-				scmd_local->result =
-					megasas_check_mpio_paths(instance,
-							scmd_local);
-				if (instance->ldio_threshold &&
-					megasas_cmd_type(scmd_local) == READ_WRITE_LDIO)
-					atomic_dec(&instance->ldio_outstanding);
-				megasas_return_cmd_fusion(instance, cmd_fusion);
-				scsi_dma_unmap(scmd_local);
-				scmd_local->scsi_done(scmd_local);
-			}
-		}
-
-		dev_info(&instance->pdev->dev, "Outstanding fastpath IOs: %d\n",
-			fpio_count);
+		scsi_host_busy_iter(instance->host, megasas_return_cmd_iter,
+				    instance);
 
 		atomic_set(&instance->fw_outstanding, 0);
 
@@ -4943,11 +4969,12 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 		if (instance->requestorId && !reason) {
 			msleep(MEGASAS_OCR_SETTLE_TIME_VF);
 			do_adp_reset = false;
-			max_reset_tries = MEGASAS_SRIOV_MAX_RESET_TRIES_VF;
+			instance->reset_count = MEGASAS_SRIOV_MAX_RESET_TRIES_VF;
 		}
 
 		/* Now try to reset the chip */
-		for (i = 0; i < max_reset_tries; i++) {
+		while (instance->reset_count) {
+			instance->reset_count--;
 			/*
 			 * Do adp reset and wait for
 			 * controller to transition to ready
@@ -4977,9 +5004,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 				goto kill_hba;
 			}
 
-			megasas_refire_mgmt_cmd(instance,
-						(i == (MEGASAS_FUSION_MAX_RESET_TRIES - 1)
-							? 1 : 0));
+			megasas_refire_mgmt_cmd(instance);
 
 			/* Reset load balance info */
 			if (fusion->load_balance_info)
-- 
2.16.4

