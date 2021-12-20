Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6983CC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Dec 2021 14:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhLTOE4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhLTOEy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2021 09:04:54 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E82C061574
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:54 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id i12so8811194pfd.6
        for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2021 06:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=pO6TrcutOeYqNsNz6zU29zCYTcOU12Dvq4nH8oLOu50=;
        b=LvPfGOu8KJrkFT3wTvq5Zw9D1ZmybeCiiwIAdUq3GerMOKi3hqHPEAwFTD6P4n9opF
         sJlszvxZUVDqz3517mavhZfgTQ6NHOToAMhpZZ8XKRAgKWvUTo4kSmYo9HXNln9WGGCH
         DO7qhJyIpd5yEpozeH/FR58s+i9K+HHcD6XiU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=pO6TrcutOeYqNsNz6zU29zCYTcOU12Dvq4nH8oLOu50=;
        b=bhgsf3AOov0nRYDYBNrYKIARwjSi5uFKILor0El4t6ubAugfC7jYgeVH5F+4T9hDa1
         +5k39q7QbPgH5iStrw2FF4YZNQBPzlxkRoZNFIrtalsHGAVWsXsC0dvLr+e8eyWN5P4Q
         ZWG2VV2dnhbpszhLsjCjiS1YlMwPwZivgLGoErXWvunApw+ZO8XumORwOPPwMatmLYYL
         dgoiXAKhIonP4lz6pv8DrrDsse9xeypEbeH+qIDiGdTxvrX78tovOnUmPutDIT5pUrqZ
         LKDRvkwTUQTTB5VKNPFc5GgeckG0zw/xL1mZz+9OH0ua/xzbdKEvWmpSK5EopyRNnaej
         skuw==
X-Gm-Message-State: AOAM530Q1ML2Rfuxtg9xNHdZE0rZbzXySit12upYEkHQIiCDcHT41e/Q
        foWET48dOC8D/eTgSeMrKyJssqNDajju9SEtt2/Gkv0Hwpb0RfDzg8Nfwfzu+Xu9TNSDSXNw5Pe
        e68ag6W+iwhc1xX/AGhXRNQmiRXO06NfTxojUiCmnlxFTLKYFNWiLqlEU5CGkvPUV6ZxEnd0B56
        o0NCQ6+m6L
X-Google-Smtp-Source: ABdhPJy8yMiYRiEw5oKge5sCw8pWBxGUl8T+13wW1mp/NEkg5JcKaQ4ml4PyT7rgG7xQntgj8Fz83g==
X-Received: by 2002:a05:6a00:18a6:b0:4b1:386e:5af3 with SMTP id x38-20020a056a0018a600b004b1386e5af3mr16292004pfh.77.1640009093341;
        Mon, 20 Dec 2021 06:04:53 -0800 (PST)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b4sm5434180pjm.17.2021.12.20.06.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:04:52 -0800 (PST)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 23/25] mpi3mr: Enhanced Task Management Support Reply handling
Date:   Mon, 20 Dec 2021 19:41:57 +0530
Message-Id: <20211220141159.16117-24-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
References: <20211220141159.16117-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000078df2a05d3945fe2"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000078df2a05d3945fe2
Content-Transfer-Encoding: 8bit

The driver is enhanced to consider
MPI3_IOCSTATUS_SCSI_IOC_TERMINATED as a success for
TMs issued by it and check the pending I/Os to decide the
success or failure of the task management requests instead
of just considering the MPI3_IOCSTATUS_SCSI_IOC_TERMINATED
as a failure of the task management request.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |   6 +
 drivers/scsi/mpi3mr/mpi3mr_os.c | 217 ++++++++++++++++++++++++++------
 2 files changed, 185 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index e9e7a86..4ac1295 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -497,6 +497,8 @@ static inline void mpi3mr_tgtdev_put(struct mpi3mr_tgt_dev *s)
  * @dev_removedelay: Device is waiting to be removed in FW
  * @dev_type: Device type
  * @tgt_dev: Internal target device pointer
+ * @pend_count: Counter to track pending I/Os during error
+ *		handling
  */
 struct mpi3mr_stgt_priv_data {
 	struct scsi_target *starget;
@@ -508,6 +510,7 @@ struct mpi3mr_stgt_priv_data {
 	u8 dev_removedelay;
 	u8 dev_type;
 	struct mpi3mr_tgt_dev *tgt_dev;
+	u32 pend_count;
 };
 
 /**
@@ -516,11 +519,14 @@ struct mpi3mr_stgt_priv_data {
  * @tgt_priv_data: Scsi_target private data pointer
  * @lun_id: LUN ID of the device
  * @ncq_prio_enable: NCQ priority enable for SATA device
+ * @pend_count: Counter to track pending I/Os during error
+ *		handling
  */
 struct mpi3mr_sdev_priv_data {
 	struct mpi3mr_stgt_priv_data *tgt_priv_data;
 	u32 lun_id;
 	u8 ncq_prio_enable;
+	u32 pend_count;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index b2f1c6a..284117d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -420,6 +420,74 @@ out:
 	return(true);
 }
 
+/**
+ * mpi3mr_count_dev_pending - Count commands pending for a lun
+ * @rq: Block request
+ * @data: SCSI device reference
+ * @reserved: Unused
+ *
+ * This is an iterator function called for each SCSI command in
+ * a host and if the command is pending in the LLD for the
+ * specific device(lun) then device specific pending I/O counter
+ * is updated in the device structure.
+ *
+ * Return: true always.
+ */
+
+static bool mpi3mr_count_dev_pending(struct request *rq,
+	void *data, bool reserved)
+{
+	struct scsi_device *sdev = (struct scsi_device *)data;
+	struct mpi3mr_sdev_priv_data *sdev_priv_data = sdev->hostdata;
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
+	struct scmd_priv *priv;
+
+	if (scmd) {
+		priv = scsi_cmd_priv(scmd);
+		if (!priv->in_lld_scope)
+			goto out;
+		if (scmd->device == sdev)
+			sdev_priv_data->pend_count++;
+	}
+
+out:
+	return true;
+}
+
+/**
+ * mpi3mr_count_tgt_pending - Count commands pending for target
+ * @rq: Block request
+ * @data: SCSI target reference
+ * @reserved: Unused
+ *
+ * This is an iterator function called for each SCSI command in
+ * a host and if the command is pending in the LLD for the
+ * specific target then target specific pending I/O counter is
+ * updated in the target structure.
+ *
+ * Return: true always.
+ */
+
+static bool mpi3mr_count_tgt_pending(struct request *rq,
+	void *data, bool reserved)
+{
+	struct scsi_target *starget = (struct scsi_target *)data;
+	struct mpi3mr_stgt_priv_data *stgt_priv_data = starget->hostdata;
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
+	struct scmd_priv *priv;
+
+	if (scmd) {
+		priv = scsi_cmd_priv(scmd);
+		if (!priv->in_lld_scope)
+			goto out;
+		if (scmd->device && (scsi_target(scmd->device) == starget))
+			stgt_priv_data->pend_count++;
+	}
+
+out:
+	return true;
+}
+
 /**
  * mpi3mr_flush_host_io -  Flush host I/Os
  * @mrioc: Adapter instance reference
@@ -2847,6 +2915,17 @@ static const char *mpi3mr_tm_response_name(u8 resp_code)
 	return desc;
 }
 
+inline void mpi3mr_poll_pend_io_completions(struct mpi3mr_ioc *mrioc)
+{
+	int i;
+	int num_of_reply_queues =
+	    mrioc->num_op_reply_q + mrioc->op_reply_q_offset;
+
+	for (i = mrioc->op_reply_q_offset; i < num_of_reply_queues; i++)
+		mpi3mr_process_op_reply_q(mrioc,
+		    mrioc->intr_info[i].op_reply_q);
+}
+
 /**
  * mpi3mr_issue_tm - Issue Task Management request
  * @mrioc: Adapter instance reference
@@ -2854,9 +2933,10 @@ static const char *mpi3mr_tm_response_name(u8 resp_code)
  * @handle: Device handle
  * @lun: lun ID
  * @htag: Host tag of the TM request
+ * @timeout: TM timeout value
  * @drv_cmd: Internal command tracker
  * @resp_code: Response code place holder
- * @cmd_priv: SCSI command private data
+ * @scmd: SCSI command
  *
  * Issues a Task Management Request to the controller for a
  * specified target, lun and command and wait for its completion
@@ -2868,14 +2948,16 @@ static const char *mpi3mr_tm_response_name(u8 resp_code)
 static int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 	u16 handle, uint lun, u16 htag, ulong timeout,
 	struct mpi3mr_drv_cmd *drv_cmd,
-	u8 *resp_code, struct scmd_priv *cmd_priv)
+	u8 *resp_code, struct scsi_cmnd *scmd)
 {
 	struct mpi3_scsi_task_mgmt_request tm_req;
 	struct mpi3_scsi_task_mgmt_reply *tm_reply = NULL;
 	int retval = 0;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
-	struct op_req_qinfo *op_req_q = NULL;
+	struct scmd_priv *cmd_priv = NULL;
+	struct scsi_device *sdev = NULL;
+	struct mpi3mr_sdev_priv_data *sdev_priv_data = NULL;
 
 	ioc_info(mrioc, "%s :Issue TM: TM type (0x%x) for devhandle 0x%04x\n",
 	     __func__, tm_type, handle);
@@ -2912,16 +2994,21 @@ static int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 	tm_req.function = MPI3_FUNCTION_SCSI_TASK_MGMT;
 
 	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
-	if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata) {
-		scsi_tgt_priv_data = (struct mpi3mr_stgt_priv_data *)
-		    tgtdev->starget->hostdata;
-		atomic_inc(&scsi_tgt_priv_data->block_io);
-	}
-	if (cmd_priv) {
-		op_req_q = &mrioc->req_qinfo[cmd_priv->req_q_idx];
-		tm_req.task_host_tag = cpu_to_le16(cmd_priv->host_tag);
-		tm_req.task_request_queue_id = cpu_to_le16(op_req_q->qid);
+
+	if (scmd) {
+		sdev = scmd->device;
+		sdev_priv_data = sdev->hostdata;
+		scsi_tgt_priv_data = ((sdev_priv_data) ?
+		    sdev_priv_data->tgt_priv_data : NULL);
+	} else {
+		if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata)
+			scsi_tgt_priv_data = (struct mpi3mr_stgt_priv_data *)
+			    tgtdev->starget->hostdata;
 	}
+
+	if (scsi_tgt_priv_data)
+		atomic_inc(&scsi_tgt_priv_data->block_io);
+
 	if (tgtdev && (tgtdev->dev_type == MPI3_DEVICE_DEVFORM_PCIE)) {
 		if (cmd_priv && tgtdev->dev_spec.pcie_inf.abort_to)
 			timeout = tgtdev->dev_spec.pcie_inf.abort_to;
@@ -2938,35 +3025,44 @@ static int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 	wait_for_completion_timeout(&drv_cmd->done, (timeout * HZ));
 
 	if (!(drv_cmd->state & MPI3MR_CMD_COMPLETE)) {
-		ioc_err(mrioc, "%s :Issue TM: command timed out\n", __func__);
 		drv_cmd->is_waiting = 0;
 		retval = -1;
-		if (!(drv_cmd->state & MPI3MR_CMD_RESET))
+		if (!(drv_cmd->state & MPI3MR_CMD_RESET)) {
+			dprint_tm(mrioc,
+			    "task management request timed out after %ld seconds\n",
+			    timeout);
+			if (mrioc->logging_level & MPI3_DEBUG_TM)
+				dprint_dump_req(&tm_req, sizeof(tm_req)/4);
 			mpi3mr_soft_reset_handler(mrioc,
 			    MPI3MR_RESET_FROM_TM_TIMEOUT, 1);
+		}
 		goto out_unlock;
 	}
 
-	if (drv_cmd->state & MPI3MR_CMD_REPLY_VALID)
-		tm_reply = (struct mpi3_scsi_task_mgmt_reply *)drv_cmd->reply;
-
-	if (drv_cmd->ioc_status != MPI3_IOCSTATUS_SUCCESS) {
-		ioc_err(mrioc,
-		    "%s :Issue TM: handle(0x%04x) Failed ioc_status(0x%04x) Loginfo(0x%08x)\n",
-		    __func__, handle, drv_cmd->ioc_status,
-		    drv_cmd->ioc_loginfo);
+	if (!(drv_cmd->state & MPI3MR_CMD_REPLY_VALID)) {
+		dprint_tm(mrioc, "invalid task management reply message\n");
 		retval = -1;
 		goto out_unlock;
 	}
 
-	if (!tm_reply) {
-		ioc_err(mrioc, "%s :Issue TM: No TM Reply message\n", __func__);
+	tm_reply = (struct mpi3_scsi_task_mgmt_reply *)drv_cmd->reply;
+
+	switch (drv_cmd->ioc_status) {
+	case MPI3_IOCSTATUS_SUCCESS:
+		*resp_code = le32_to_cpu(tm_reply->response_data) &
+			MPI3MR_RI_MASK_RESPCODE;
+		break;
+	case MPI3_IOCSTATUS_SCSI_IOC_TERMINATED:
+		*resp_code = MPI3_SCSITASKMGMT_RSPCODE_TM_COMPLETE;
+		break;
+	default:
+		dprint_tm(mrioc,
+		    "task management request to handle(0x%04x) is failed with ioc_status(0x%04x) log_info(0x%08x)\n",
+		    handle, drv_cmd->ioc_status, drv_cmd->ioc_loginfo);
 		retval = -1;
 		goto out_unlock;
 	}
 
-	*resp_code = le32_to_cpu(tm_reply->response_data) &
-	    MPI3MR_RI_MASK_RESPCODE;
 	switch (*resp_code) {
 	case MPI3_SCSITASKMGMT_RSPCODE_TM_SUCCEEDED:
 	case MPI3_SCSITASKMGMT_RSPCODE_TM_COMPLETE:
@@ -2986,6 +3082,32 @@ static int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
 	    le32_to_cpu(tm_reply->termination_count),
 	    mpi3mr_tm_response_name(*resp_code), *resp_code);
 
+	if (!retval) {
+		mpi3mr_ioc_disable_intr(mrioc);
+		mpi3mr_poll_pend_io_completions(mrioc);
+		mpi3mr_ioc_enable_intr(mrioc);
+		mpi3mr_poll_pend_io_completions(mrioc);
+	}
+	switch (tm_type) {
+	case MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
+		if (!scsi_tgt_priv_data)
+			break;
+		scsi_tgt_priv_data->pend_count = 0;
+		blk_mq_tagset_busy_iter(&mrioc->shost->tag_set,
+		    mpi3mr_count_tgt_pending,
+		    (void *)scsi_tgt_priv_data->starget);
+		break;
+	case MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET:
+		if (!sdev_priv_data)
+			break;
+		sdev_priv_data->pend_count = 0;
+		blk_mq_tagset_busy_iter(&mrioc->shost->tag_set,
+		    mpi3mr_count_dev_pending, (void *)sdev);
+		break;
+	default:
+		break;
+	}
+
 out_unlock:
 	drv_cmd->state = MPI3MR_CMD_NOTUSED;
 	mutex_unlock(&drv_cmd->mutex);
@@ -2993,14 +3115,6 @@ out_unlock:
 		atomic_dec_if_positive(&scsi_tgt_priv_data->block_io);
 	if (tgtdev)
 		mpi3mr_tgtdev_put(tgtdev);
-	if (!retval) {
-		/*
-		 * Flush all IRQ handlers by calling synchronize_irq().
-		 * mpi3mr_ioc_disable_intr() takes care of it.
-		 */
-		mpi3mr_ioc_disable_intr(mrioc);
-		mpi3mr_ioc_enable_intr(mrioc);
-	}
 out:
 	return retval;
 }
@@ -3250,6 +3364,13 @@ static int mpi3mr_eh_target_reset(struct scsi_cmnd *scmd)
 
 	stgt_priv_data = sdev_priv_data->tgt_priv_data;
 	dev_handle = stgt_priv_data->dev_handle;
+	if (stgt_priv_data->dev_removed) {
+		sdev_printk(KERN_INFO, scmd->device,
+		    "%s:target(handle = 0x%04x) is removed, target reset is not issued\n",
+		    mrioc->name, dev_handle);
+		retval = FAILED;
+		goto out;
+	}
 	sdev_printk(KERN_INFO, scmd->device,
 	    "Target Reset is issued to handle(0x%04x)\n",
 	    dev_handle);
@@ -3257,15 +3378,22 @@ static int mpi3mr_eh_target_reset(struct scsi_cmnd *scmd)
 	ret = mpi3mr_issue_tm(mrioc,
 	    MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET, dev_handle,
 	    sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
-	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, NULL);
+	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, scmd);
 
 	if (ret)
 		goto out;
 
+	if (stgt_priv_data->pend_count) {
+		sdev_printk(KERN_INFO, scmd->device,
+		    "%s: target has %d pending commands, target reset is failed\n",
+		    mrioc->name, sdev_priv_data->pend_count);
+		goto out;
+	}
+
 	retval = SUCCESS;
 out:
 	sdev_printk(KERN_INFO, scmd->device,
-	    "Target reset is %s for scmd(%p)\n",
+	    "%s: target reset is %s for scmd(%p)\n", mrioc->name,
 	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
 
 	return retval;
@@ -3304,21 +3432,34 @@ static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
 
 	stgt_priv_data = sdev_priv_data->tgt_priv_data;
 	dev_handle = stgt_priv_data->dev_handle;
+	if (stgt_priv_data->dev_removed) {
+		sdev_printk(KERN_INFO, scmd->device,
+		    "%s: device(handle = 0x%04x) is removed, device(LUN) reset is not issued\n",
+		    mrioc->name, dev_handle);
+		retval = FAILED;
+		goto out;
+	}
 	sdev_printk(KERN_INFO, scmd->device,
 	    "Device(lun) Reset is issued to handle(0x%04x)\n", dev_handle);
 
 	ret = mpi3mr_issue_tm(mrioc,
 	    MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, dev_handle,
 	    sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
-	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, NULL);
+	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, scmd);
 
 	if (ret)
 		goto out;
 
+	if (sdev_priv_data->pend_count) {
+		sdev_printk(KERN_INFO, scmd->device,
+		    "%s: device has %d pending commands, device(LUN) reset is failed\n",
+		    mrioc->name, sdev_priv_data->pend_count);
+		goto out;
+	}
 	retval = SUCCESS;
 out:
 	sdev_printk(KERN_INFO, scmd->device,
-	    "Device(lun) reset is %s for scmd(%p)\n",
+	    "%s: device(LUN) reset is %s for scmd(%p)\n", mrioc->name,
 	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
 
 	return retval;
-- 
2.27.0


--00000000000078df2a05d3945fe2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKttIYg0/KdBub3ebBy4
P1Eq918uKZ+qpOkKRpgRV4gQMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIxMTIyMDE0MDQ1M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAtctMr1Flg2GdhpeJatPahjQnQ5Z72+0k3uE2W
CrN+sK8yx6qjI08txdc5aYQbRSdfNm2LoaszJ8CIlSiTmC4Jd+z8n7S3+vfkFpwFIcdkZGnl825L
zg8UAJU7R4+OIEVJyMMhbTUCJMJmAQN/jV9jCmJ3sd32ySuLpO9Q348eDrg7UO6lJZqHZ0FXuN6E
GhDgJNH7QftmtzHpWN7c2h4F0llaUUFRGupg8iyIPyB20yo55mzmvhB0nNQ1lYGirX7BrtTP2lnm
11Zc/2jZtj0j5JoYMR9gSAJcJ4EH1QqjMFIDf7O1+qrEw9UHWIoHmcCbd829p/at9d4V+KFxNtq6
--00000000000078df2a05d3945fe2--
