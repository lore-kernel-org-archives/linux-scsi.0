Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2795C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F75D2310D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 10:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgLVKNu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 05:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgLVKNt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 05:13:49 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8A6C0613D6
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:13:00 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id m5so1090121pjv.5
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 02:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dKbtNyordOTgwmT51hd+ydja5f09qxenne5A95trFa0=;
        b=M2Cu+LfYI7bUZjP9TBk9H/3Nv+Y9OSYtA0RVhZMyI95Kjpec4BvDvLBjWFoI9KZ3yt
         Z7LG1zWReFfqS3mJrl4u0+zMvC8dYX6G9//J3eJYY/RuEQlSfWaqMXbblY4+ThPRO/x8
         P+HfQCbmTkA+7tdsD7UKp+Awf3oIjarwnfBB8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=dKbtNyordOTgwmT51hd+ydja5f09qxenne5A95trFa0=;
        b=rgAt30oYEQMnLEOT3Pj4IZvzB2d87vBmMHQn6GH+Ue6Gu1X+84OBwHdehTD8+soffo
         dAl6OopfiJR3+DChyz0mfmfWE67wp1d/QvP7L/9ocBtjj4bsZAzGFBEooARXT2rAnJxW
         LqcNwKryaNgUxLITPN3nSqNnoYBudKh9WRnI3xTS1VCzZhelYZNjDJlfhp4yPU2GzP3K
         aB6qG6R75J0s8LNtKJRHXeue2idc/wEx/uTXjl692CTG+evPKs1CWTjKIhv8QIzx9/fK
         R9iuNU6p7G/Ki52p0JbDrfiw5LtNxs0HcAZ9tt2SQolGTWxil6AI3Js5GreXr9Ton+5N
         i/Ww==
X-Gm-Message-State: AOAM532e/Z2DKpg8RSgIF7I6UZi46MIy5n3Q1rBYLqvUYz17JSsvSY1R
        S0AGf/pztu8r5XVcoMa8RUQJbbNeM12lRwuuHyf4MsfRFZRNICdlnM2+4tCeXTAbjemoDXyLnMV
        QoBGnSElm6XWl0f1gBuTsl7HfmLA0pajXlAEaa67WN42c98/3rr3Vbv26WWgMn5ZIbg/CnOBq59
        v/T3asdRHf
MIME-Version: 1.0
X-Google-Smtp-Source: ABdhPJxrLeZyUmFogAEOixrpIqPPjWjfmGlfspZAho4dkMxEHfskWq5hmFhjLoDpwSnJGFJWbgcZpA==
X-Received: by 2002:a17:90a:db08:: with SMTP id g8mr21349509pjv.163.1608631978836;
        Tue, 22 Dec 2020 02:12:58 -0800 (PST)
Received: from drv-bst-rhel8.static.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p16sm19148624pju.47.2020.12.22.02.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 02:12:58 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 13/24] mpi3mr: implement scsi error handler hooks
Date:   Tue, 22 Dec 2020 15:41:45 +0530
Message-Id: <20201222101156.98308-14-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201222101156.98308-1-kashyap.desai@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b5efd705b70ad12f"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000b5efd705b70ad12f
Content-Type: text/plain; charset="US-ASCII"

SCSI EH hook is added.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/mpi3mr.h    |   3 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c |  51 ++++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 431 +++++++++++++++++++++++++++++++-
 3 files changed, 484 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 24e2337466dc..a677a4b57a2c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -97,6 +97,7 @@ extern struct list_head mrioc_list;
 /* command/controller interaction timeout definitions in seconds */
 #define MPI3MR_INTADMCMD_TIMEOUT		10
 #define MPI3MR_PORTENABLE_TIMEOUT		300
+#define MPI3MR_ABORTTM_TIMEOUT			30
 #define MPI3MR_RESETTM_TIMEOUT			30
 #define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
 #define MPI3MR_TSUPDATE_INTERVAL		900
@@ -628,6 +629,7 @@ struct scmd_priv {
  * @chain_bitmap_sz: Chain buffer allocator bitmap size
  * @chain_bitmap: Chain buffer allocator bitmap
  * @chain_buf_lock: Chain buffer list lock
+ * @host_tm_cmds: Command tracker for task management commands
  * @dev_rmhs_cmds: Command tracker for device removal commands
  * @devrem_bitmap_sz: Device removal bitmap size
  * @devrem_bitmap: Device removal bitmap
@@ -750,6 +752,7 @@ struct mpi3mr_ioc {
 	void *chain_bitmap;
 	spinlock_t chain_buf_lock;
 
+	struct mpi3mr_drv_cmd host_tm_cmds;
 	struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
 	u16 devrem_bitmap_sz;
 	void *devrem_bitmap;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index aad0a2bd06b9..ba4bfcc17809 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -167,9 +167,13 @@ static struct mpi3mr_drv_cmd *
 mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 host_tag,
 	Mpi3DefaultReply_t *def_reply)
 {
+	u16 idx;
+
 	switch (host_tag) {
 	case MPI3MR_HOSTTAG_INITCMDS:
 		return &mrioc->init_cmds;
+	case MPI3MR_HOSTTAG_BLK_TMS:
+		return &mrioc->host_tm_cmds;
 	case MPI3MR_HOSTTAG_INVALID:
 		if (def_reply && def_reply->Function ==
 		    MPI3_FUNCTION_EVENT_NOTIFICATION)
@@ -178,6 +182,11 @@ mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 host_tag,
 	default:
 		break;
 	}
+	if (host_tag >= MPI3MR_HOSTTAG_DEVRMCMD_MIN &&
+	    host_tag <= MPI3MR_HOSTTAG_DEVRMCMD_MAX) {
+		idx = host_tag - MPI3MR_HOSTTAG_DEVRMCMD_MIN;
+		return &mrioc->dev_rmhs_cmds[idx];
+	}
 
 	return NULL;
 }
@@ -2035,6 +2044,31 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	if (!mrioc->init_cmds.reply)
 		goto out_failed;
 
+	mrioc->host_tm_cmds.reply = kzalloc(mrioc->facts.reply_sz, GFP_KERNEL);
+	if (!mrioc->host_tm_cmds.reply)
+		goto out_failed;
+
+	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
+		mrioc->dev_rmhs_cmds[i].reply = kzalloc(mrioc->facts.reply_sz,
+		    GFP_KERNEL);
+		if (!mrioc->dev_rmhs_cmds[i].reply)
+			goto out_failed;
+	}
+	mrioc->dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
+	if (mrioc->facts.max_devhandle % 8)
+		mrioc->dev_handle_bitmap_sz++;
+	mrioc->removepend_bitmap = kzalloc(mrioc->dev_handle_bitmap_sz,
+	    GFP_KERNEL);
+	if (!mrioc->removepend_bitmap)
+		goto out_failed;
+
+	mrioc->devrem_bitmap_sz = MPI3MR_NUM_DEVRMCMD / 8;
+	if (MPI3MR_NUM_DEVRMCMD % 8)
+		mrioc->devrem_bitmap_sz++;
+	mrioc->devrem_bitmap = kzalloc(mrioc->devrem_bitmap_sz,
+	    GFP_KERNEL);
+	if (!mrioc->devrem_bitmap)
+		goto out_failed;
 
 	mrioc->num_reply_bufs = mrioc->facts.max_reqs + MPI3MR_NUM_EVT_REPLIES;
 	mrioc->reply_free_qsz = mrioc->num_reply_bufs + 1;
@@ -3021,6 +3055,8 @@ static void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 	memset(mrioc->admin_reply_base, 0, mrioc->admin_reply_q_sz);
 
 	memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
+	memset(mrioc->host_tm_cmds.reply, 0,
+		    sizeof(*mrioc->host_tm_cmds.reply));
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
 		memset(mrioc->dev_rmhs_cmds[i].reply, 0,
 		    sizeof(*mrioc->dev_rmhs_cmds[i].reply));
@@ -3114,6 +3150,19 @@ static void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 	kfree(mrioc->init_cmds.reply);
 	mrioc->init_cmds.reply = NULL;
 
+	kfree(mrioc->host_tm_cmds.reply);
+	mrioc->host_tm_cmds.reply = NULL;
+
+	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
+		kfree(mrioc->dev_rmhs_cmds[i].reply);
+		mrioc->dev_rmhs_cmds[i].reply = NULL;
+	}
+	kfree(mrioc->removepend_bitmap);
+	mrioc->removepend_bitmap = NULL;
+
+	kfree(mrioc->devrem_bitmap);
+	mrioc->devrem_bitmap = NULL;
+
 	kfree(mrioc->chain_bitmap);
 	mrioc->chain_bitmap = NULL;
 
@@ -3289,6 +3338,8 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
 
 	cmdptr = &mrioc->init_cmds;
 	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
+	cmdptr = &mrioc->host_tm_cmds;
+	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
 
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
 		cmdptr = &mrioc->dev_rmhs_cmds[i];
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 7e0eacf45d84..80de597f8ccf 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2078,6 +2078,212 @@ static int mpi3mr_build_sg_scmd(struct mpi3mr_ioc *mrioc,
 	return ret;
 }
 
+/**
+ * mpi3mr_print_response_code - print TM response as a string
+ * @mrioc: Adapter instance reference
+ * @resp_code: TM response code
+ *
+ * Print TM response code as a readable string.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_print_response_code(struct mpi3mr_ioc *mrioc, u8 resp_code)
+{
+	char *desc;
+
+	switch (resp_code) {
+	case MPI3MR_RSP_TM_COMPLETE:
+		desc = "task management request completed";
+		break;
+	case MPI3MR_RSP_INVALID_FRAME:
+		desc = "invalid frame";
+		break;
+	case MPI3MR_RSP_TM_NOT_SUPPORTED:
+		desc = "task management request not supported";
+		break;
+	case MPI3MR_RSP_TM_FAILED:
+		desc = "task management request failed";
+		break;
+	case MPI3MR_RSP_TM_SUCCEEDED:
+		desc = "task management request succeeded";
+		break;
+	case MPI3MR_RSP_TM_INVALID_LUN:
+		desc = "invalid lun";
+		break;
+	case MPI3MR_RSP_TM_OVERLAPPED_TAG:
+		desc = "overlapped tag attempted";
+		break;
+	case MPI3MR_RSP_IO_QUEUED_ON_IOC:
+		desc = "task queued, however not sent to target";
+		break;
+	default:
+		desc = "unknown";
+		break;
+	}
+	ioc_info(mrioc, "%s :response_code(0x%01x): %s\n", __func__,
+	    resp_code, desc);
+}
+
+/**
+ * mpi3mr_issue_tm - Issue Task Management request
+ * @mrioc: Adapter instance reference
+ * @tm_type: Task Management type
+ * @handle: Device handle
+ * @lun: LUN ID
+ * @htag: Host tag of the TM request
+ * @drv_cmd: Internal command tracker
+ * @resp_code: Response code place holder
+ * @cmd_priv: SCSI command private data
+ *
+ * Issues a Task Management Request to the controller for a
+ * specified target, LUN and command and wait for its completion
+ * and check TM response. Recover the TM if it timed out by
+ * issuing controller reset.
+ *
+ * Return: 0 on success, non-zero on errors
+ */
+static int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
+	u16 handle, uint lun, u16 htag, ulong timeout,
+	struct mpi3mr_drv_cmd *drv_cmd,
+	u8 *resp_code, struct scmd_priv *cmd_priv)
+{
+	Mpi3SCSITaskMgmtRequest_t tm_req;
+	Mpi3SCSITaskMgmtReply_t *tm_reply = NULL;
+	int retval = 0;
+	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
+	struct op_req_qinfo *op_req_q = NULL;
+
+	ioc_info(mrioc, "%s :Issue TM: TM Type (0x%x) for devhandle 0x%04x\n",
+	    __func__, tm_type, handle);
+	if (mrioc->unrecoverable) {
+		retval = -1;
+		ioc_err(mrioc, "%s :Issue TM: Unrecoverable controller\n",
+		    __func__);
+		goto out;
+	}
+
+	memset(&tm_req, 0, sizeof(tm_req));
+	mutex_lock(&drv_cmd->mutex);
+	if (drv_cmd->state & MPI3MR_CMD_PENDING) {
+		retval = -1;
+		ioc_err(mrioc, "%s :Issue TM: Command is in use\n", __func__);
+		mutex_unlock(&drv_cmd->mutex);
+		goto out;
+	}
+	if (mrioc->reset_in_progress) {
+		retval = -1;
+		ioc_err(mrioc, "%s :Issue TM: Reset in progress\n", __func__);
+		mutex_unlock(&drv_cmd->mutex);
+		goto out;
+	}
+
+	drv_cmd->state = MPI3MR_CMD_PENDING;
+	drv_cmd->is_waiting = 1;
+	drv_cmd->callback = NULL;
+	tm_req.DevHandle = cpu_to_le16(handle);
+	tm_req.TaskType = tm_type;
+	tm_req.HostTag = cpu_to_le16(htag);
+
+	int_to_scsilun(lun, (struct scsi_lun *)tm_req.LUN);
+	tm_req.Function = MPI3_FUNCTION_SCSI_TASK_MGMT;
+
+	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
+	if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata) {
+		scsi_tgt_priv_data = (struct mpi3mr_stgt_priv_data *)
+		    tgtdev->starget->hostdata;
+		atomic_inc(&scsi_tgt_priv_data->block_io);
+	}
+	if (cmd_priv) {
+		op_req_q = &mrioc->req_qinfo[cmd_priv->req_q_idx];
+		tm_req.TaskHostTag = cpu_to_le16(cmd_priv->host_tag);
+		tm_req.TaskRequestQueueID = cpu_to_le16(op_req_q->qid);
+	}
+	if (tgtdev && (tgtdev->dev_type == MPI3_DEVICE_DEVFORM_PCIE)) {
+		if (cmd_priv && tgtdev->dev_spec.pcie_inf.abort_to)
+			timeout = tgtdev->dev_spec.pcie_inf.abort_to;
+		else if (!cmd_priv && tgtdev->dev_spec.pcie_inf.reset_to)
+			timeout = tgtdev->dev_spec.pcie_inf.reset_to;
+	}
+
+	init_completion(&drv_cmd->done);
+	retval = mpi3mr_admin_request_post(mrioc, &tm_req, sizeof(tm_req), 1);
+	if (retval) {
+		ioc_err(mrioc, "%s :Issue TM: Admin Post failed\n", __func__);
+		goto out_unlock;
+	}
+	wait_for_completion_timeout(&drv_cmd->done, (timeout * HZ));
+
+	if (!(drv_cmd->state & MPI3MR_CMD_COMPLETE)) {
+		ioc_err(mrioc, "%s :Issue TM: command timed out\n", __func__);
+		drv_cmd->is_waiting = 0;
+		retval = -1;
+		mpi3mr_soft_reset_handler(mrioc,
+		    MPI3MR_RESET_FROM_TM_TIMEOUT, 1);
+		goto out_unlock;
+	}
+
+	if (drv_cmd->state & MPI3MR_CMD_REPLY_VALID)
+		tm_reply = (Mpi3SCSITaskMgmtReply_t *)drv_cmd->reply;
+
+	if (drv_cmd->ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		ioc_err(mrioc,
+		    "%s :Issue TM: handle(0x%04x) Failed IOCStatus(0x%04x) Loginfo(0x%08x)\n",
+		    __func__, handle, drv_cmd->ioc_status,
+		    drv_cmd->ioc_loginfo);
+		retval = -1;
+		goto out_unlock;
+	}
+
+	if (!tm_reply) {
+		ioc_err(mrioc, "%s :Issue TM: No TM Reply message\n", __func__);
+		retval = -1;
+		goto out_unlock;
+	}
+
+	*resp_code = le32_to_cpu(tm_reply->ResponseData) &
+	    MPI3MR_RI_MASK_RESPCODE;
+	switch (*resp_code) {
+	case MPI3MR_RSP_TM_SUCCEEDED:
+	case MPI3MR_RSP_TM_COMPLETE:
+		break;
+	case MPI3MR_RSP_IO_QUEUED_ON_IOC:
+		if (tm_type != MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK)
+			retval = -1;
+		break;
+	default:
+		retval = -1;
+		break;
+	}
+
+	ioc_info(mrioc,
+	    "%s :Issue TM: Completed TM Type (0x%x) handle(0x%04x) ",
+	    __func__, tm_type, handle);
+	ioc_info(mrioc,
+	    "with ioc_status(0x%04x), loginfo(0x%08x), term_count(0x%08x)\n",
+	    drv_cmd->ioc_status, drv_cmd->ioc_loginfo,
+	    le32_to_cpu(tm_reply->TerminationCount));
+	mpi3mr_print_response_code(mrioc, *resp_code);
+
+out_unlock:
+	drv_cmd->state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&drv_cmd->mutex);
+	if (scsi_tgt_priv_data)
+		atomic_dec_if_positive(&scsi_tgt_priv_data->block_io);
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
+	if (!retval) {
+		/*
+		 * Flush all IRQ handlers by calling synchronize_irq().
+		 * mpi3mr_ioc_disable_intr() takes care of it.
+		 */
+		mpi3mr_ioc_disable_intr(mrioc);
+		mpi3mr_ioc_enable_intr(mrioc);
+	}
+out:
+	return retval;
+}
+
 /**
  * mpi3mr_bios_param - BIOS param callback
  * @sdev: SCSI device reference
@@ -2135,6 +2341,221 @@ static int mpi3mr_map_queues(struct Scsi_Host *shost)
 	    mrioc->pdev, mrioc->op_reply_q_offset);
 }
 
+/**
+ * mpi3mr_eh_host_reset - Host reset error handling callback
+ * @scmd: SCSI command reference
+ *
+ * Issue controller reset if the scmd is for a Physical Device,
+ * if the scmd is for RAID volume, then wait for
+ * MPI3MR_RAID_ERRREC_RESET_TIMEOUT and checke whether any
+ * pending I/Os prior to issuing reset to the controller.
+ *
+ * Return: SUCCESS of successful reset else FAILED
+ */
+static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
+{
+	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
+	struct mpi3mr_stgt_priv_data *stgt_priv_data;
+	struct mpi3mr_sdev_priv_data *sdev_priv_data;
+	u8 dev_type = MPI3_DEVICE_DEVFORM_VD;
+	int retval = FAILED, ret;
+
+	sdev_priv_data = scmd->device->hostdata;
+	if (sdev_priv_data && sdev_priv_data->tgt_priv_data) {
+		stgt_priv_data = sdev_priv_data->tgt_priv_data;
+		dev_type = stgt_priv_data->dev_type;
+	}
+
+	ret = mpi3mr_soft_reset_handler(mrioc,
+	    MPI3MR_RESET_FROM_EH_HOS, 1);
+	if (ret)
+		goto out;
+
+	retval = SUCCESS;
+out:
+	sdev_printk(KERN_INFO, scmd->device,
+	    "Host reset is %s for scmd(%p)\n",
+	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+
+	return retval;
+}
+
+/**
+ * mpi3mr_eh_target_reset - Target reset error handling callback
+ * @scmd: SCSI command reference
+ *
+ * Issue Target reset Task Management and verify the scmd is
+ * terminated successfully and return status accordingly.
+ *
+ * Return: SUCCESS of successful termination of the scmd else
+ *         FAILED
+ */
+static int mpi3mr_eh_target_reset(struct scsi_cmnd *scmd)
+{
+	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
+	struct mpi3mr_stgt_priv_data *stgt_priv_data;
+	struct mpi3mr_sdev_priv_data *sdev_priv_data;
+	u16 dev_handle;
+	u8 resp_code = 0;
+	int retval = FAILED, ret = 0;
+
+
+	sdev_printk(KERN_INFO, scmd->device,
+	    "Attempting Target Reset! scmd(%p)\n", scmd);
+	scsi_print_command(scmd);
+
+	sdev_priv_data = scmd->device->hostdata;
+	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
+		sdev_printk(KERN_INFO, scmd->device,
+		    "SCSI device is not available\n");
+		retval = SUCCESS;
+		goto out;
+	}
+
+	stgt_priv_data = sdev_priv_data->tgt_priv_data;
+	dev_handle = stgt_priv_data->dev_handle;
+	sdev_printk(KERN_INFO, scmd->device,
+	    "Target Reset is issued to handle(0x%04x)\n",
+	    dev_handle);
+
+	ret = mpi3mr_issue_tm(mrioc,
+	    MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET, dev_handle,
+	    sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
+	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, NULL);
+
+	if (ret)
+		goto out;
+
+	retval = SUCCESS;
+out:
+	sdev_printk(KERN_INFO, scmd->device,
+	    "Target reset is %s for scmd(%p)\n",
+	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+
+	return retval;
+}
+
+/**
+ * mpi3mr_eh_dev_reset- Device reset error handling callback
+ * @scmd: SCSI command reference
+ *
+ * Issue LUN reset Task Management and verify the scmd is
+ * terminated successfully and return status accordingly.
+ *
+ * Return: SUCCESS of successful termination of the scmd else
+ *         FAILED
+ */
+static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
+{
+	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
+	struct mpi3mr_stgt_priv_data *stgt_priv_data;
+	struct mpi3mr_sdev_priv_data *sdev_priv_data;
+	u16 dev_handle;
+	u8 resp_code = 0;
+	int retval = FAILED, ret = 0;
+
+	sdev_printk(KERN_INFO, scmd->device,
+	    "Attempting Device(LUN) Reset! scmd(%p)\n", scmd);
+	scsi_print_command(scmd);
+
+	sdev_priv_data = scmd->device->hostdata;
+	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
+		sdev_printk(KERN_INFO, scmd->device,
+		    "SCSI device is not available\n");
+		retval = SUCCESS;
+		goto out;
+	}
+
+	stgt_priv_data = sdev_priv_data->tgt_priv_data;
+	dev_handle = stgt_priv_data->dev_handle;
+	sdev_printk(KERN_INFO, scmd->device,
+	    "Device(LUN) Reset is issued to handle(0x%04x)\n", dev_handle);
+
+	ret = mpi3mr_issue_tm(mrioc,
+	    MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, dev_handle,
+	    sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
+	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, NULL);
+
+	if (ret)
+		goto out;
+
+	retval = SUCCESS;
+out:
+	sdev_printk(KERN_INFO, scmd->device,
+	    "Device(LUN) reset is %s for scmd(%p)\n",
+	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+
+	return retval;
+}
+
+/**
+ * mpi3mr_eh_abort- Abort error handling callback
+ * @scmd: SCSI command reference
+ *
+ * Issue Abort Task Management if the command is in LLD scope
+ * and verify if it is aborted successfully and return status
+ * accordingly.
+ *
+ * Return: SUCCESS of successful abort the scmd else FAILED
+ */
+static int mpi3mr_eh_abort(struct scsi_cmnd *scmd)
+{
+	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
+	struct mpi3mr_stgt_priv_data *stgt_priv_data;
+	struct mpi3mr_sdev_priv_data *sdev_priv_data;
+	struct scmd_priv *cmd_priv;
+	u16 dev_handle;
+	u8 resp_code = 0;
+	int retval = FAILED, ret = 0;
+
+	sdev_printk(KERN_INFO, scmd->device,
+	    "Attempting Task Abort! scmd(%p)\n", scmd);
+	scsi_print_command(scmd);
+
+	sdev_priv_data = scmd->device->hostdata;
+	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
+		sdev_printk(KERN_INFO, scmd->device,
+		    "SCSI device is not available\n");
+		retval = SUCCESS;
+		goto out;
+	}
+
+	stgt_priv_data = sdev_priv_data->tgt_priv_data;
+	dev_handle = stgt_priv_data->dev_handle;
+	sdev_printk(KERN_INFO, scmd->device,
+	    "Timedout scmd (%p) is issued to handle(0x%04x)\n", scmd,
+	    dev_handle);
+
+	cmd_priv = scsi_cmd_priv(scmd);
+	if (!cmd_priv->in_lld_scope ||
+	    cmd_priv->host_tag == MPI3MR_HOSTTAG_INVALID) {
+		sdev_printk(KERN_INFO, scmd->device,
+		    "SCSI command not in LLD scope\n");
+		retval = SUCCESS;
+		goto out;
+	}
+
+	ret = mpi3mr_issue_tm(mrioc, MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
+	    dev_handle, sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
+	    MPI3MR_ABORTTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code,
+	    cmd_priv);
+
+	if (ret)
+		goto out;
+
+	if (cmd_priv->in_lld_scope) {
+		sdev_printk(KERN_INFO, scmd->device,
+		    "SCSI command(%p) is still not aborted\n", scmd);
+		goto out;
+	}
+	retval = SUCCESS;
+out:
+	sdev_printk(KERN_INFO, scmd->device, "Task Abort is %s for scmd(%p)\n",
+	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+
+	return retval;
+}
+
 /**
  * mpi3mr_scan_start - Scan start callback handler
  * @shost: SCSI host reference
@@ -2550,6 +2971,10 @@ static struct scsi_host_template mpi3mr_driver_template = {
 	.slave_destroy			= mpi3mr_slave_destroy,
 	.scan_finished			= mpi3mr_scan_finished,
 	.scan_start			= mpi3mr_scan_start,
+	.eh_abort_handler		= mpi3mr_eh_abort,
+	.eh_device_reset_handler	= mpi3mr_eh_dev_reset,
+	.eh_target_reset_handler	= mpi3mr_eh_target_reset,
+	.eh_host_reset_handler		= mpi3mr_eh_host_reset,
 	.bios_param			= mpi3mr_bios_param,
 	.map_queues			= mpi3mr_map_queues,
 	.no_write_same			= 1,
@@ -2605,7 +3030,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct mpi3mr_ioc *mrioc = NULL;
 	struct Scsi_Host *shost = NULL;
-	int retval = 0;
+	int retval = 0, i;
 
 	shost = scsi_host_alloc(&mpi3mr_driver_template,
 	    sizeof(struct mpi3mr_ioc));
@@ -2637,7 +3062,11 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	mutex_init(&mrioc->reset_mutex);
 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
+	mpi3mr_init_drv_cmd(&mrioc->host_tm_cmds, MPI3MR_HOSTTAG_BLK_TMS);
 
+	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
+		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
+		    MPI3MR_HOSTTAG_DEVRMCMD_MIN + i);
 	if (pdev->revision)
 		mrioc->enable_segqueue = true;
 
-- 
2.18.1


-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000b5efd705b70ad12f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg6Kzef9Y5
g9jJ4PE38R4Av5ArA1P1354VQF+Fxe1pZ3cwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMjIyMTAxMjU5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFLBaMiyhf1MVPMDS3Xq3d0j2wbH
Z3iveIp/m7EiCLpYH09GBucls875CbzEtAavmnjZolrvLzurFdA7aq8fPOKrZJWLsvRS5LXqneRr
U2ip9ckF4YKlCvl5bhmG0RpkQxBfJ9/usU97PZjFReVz4axgdGBIN99ezjiNGa/eFCndrwqyXDVx
05KrtGHqJio4g04B2QbYlt4zeNCL/9WxA0msvD1n5qF1J8/U+3RuPQWwB8RkeYuKqj0Phb9nQWr+
Ylu4ACvyIAg+jPxyU0yaIqEG7Zc8Skt29QetUi31w8fJJChOCYK0r9Ddl+8dC5MPWnbw7rt8nOT/
Cb2Ykt/CWrw=
--000000000000b5efd705b70ad12f--
