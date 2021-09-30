Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B84DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 12:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37A0F617E5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 12:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350989AbhI3Mo2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 08:44:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:37546 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350993AbhI3Mo1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 08:44:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="205327587"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="205327587"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 05:42:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="479879799"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 30 Sep 2021 05:42:40 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
Subject: [PATCH V6 1/3] scsi: ufs: Fix error handler clear ua deadlock
Date:   Thu, 30 Sep 2021 15:42:22 +0300
Message-Id: <20210930124224.114031-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210930124224.114031-1-adrian.hunter@intel.com>
References: <20210930124224.114031-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no guarantee to be able to enter the queue if requests are
blocked. That is because freezing the queue will block entry to the
queue, but freezing also waits for outstanding requests which can make
no progress while the queue is blocked.

That situation can happen when the error handler issues requests to
clear unit attention condition. Requests are blocked if the ufshcd_state is
UFSHCD_STATE_EH_SCHEDULED_FATAL, which can happen as a result of
prior error handler activity. Requests cannot make progress when
ufshcd_state is UFSHCD_STATE_EH_SCHEDULED_FATAL, and only the error
handler can change that, so if the error handler is waiting to enter
the queue and blk_mq_freeze_queue() is waiting for outstanding requests,
they will deadlock.

Fix by issuing REQUEST_SENSE directly avoiding the SCSI queues, in
a similar fashion as other device commands.

Fixes: b294ff3e34490f ("scsi: ufs: core: Enable power management for wlun")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufs.h     |   3 +-
 drivers/scsi/ufs/ufshcd.c  | 242 +++++++++++++++++++++++++------------
 drivers/scsi/ufs/ufshcd.h  |  12 ++
 include/trace/events/ufs.h |   5 +-
 4 files changed, 180 insertions(+), 82 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 8c6b38b1b142..c60c6d7c62c1 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -612,7 +612,8 @@ struct ufs_dev_info {
 enum ufs_trace_str_t {
 	UFS_CMD_SEND, UFS_CMD_COMP, UFS_DEV_COMP,
 	UFS_QUERY_SEND, UFS_QUERY_COMP, UFS_QUERY_ERR,
-	UFS_TM_SEND, UFS_TM_COMP, UFS_TM_ERR
+	UFS_TM_SEND, UFS_TM_COMP, UFS_TM_ERR,
+	UFS_SENSE_SEND, UFS_SENSE_COMP, UFS_SENSE_ERR,
 };
 
 /*
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 029c9631ec2b..2ffeed53a851 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2486,9 +2486,10 @@ static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
  * @upiu_flags: flags
  */
 static
-void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8 upiu_flags)
+void __ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8 upiu_flags,
+					unsigned int tfr_len, const u8 *cmd,
+					unsigned short cmd_len)
 {
-	struct scsi_cmnd *cmd = lrbp->cmd;
 	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
 	unsigned short cdb_len;
 
@@ -2502,15 +2503,24 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8 upiu_flags)
 	/* Total EHS length and Data segment length will be zero */
 	ucd_req_ptr->header.dword_2 = 0;
 
-	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(cmd->sdb.length);
+	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(tfr_len);
 
-	cdb_len = min_t(unsigned short, cmd->cmd_len, UFS_CDB_SIZE);
+	cdb_len = min_t(unsigned short, cmd_len, UFS_CDB_SIZE);
 	memset(ucd_req_ptr->sc.cdb, 0, UFS_CDB_SIZE);
-	memcpy(ucd_req_ptr->sc.cdb, cmd->cmnd, cdb_len);
+	memcpy(ucd_req_ptr->sc.cdb, cmd, cdb_len);
 
 	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
 }
 
+static
+void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8 upiu_flags)
+{
+	struct scsi_cmnd *cmd = lrbp->cmd;
+
+	__ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags, cmd->sdb.length,
+					   cmd->cmnd, cmd->cmd_len);
+}
+
 /**
  * ufshcd_prepare_utp_query_req_upiu() - fills the utp_transfer_req_desc,
  * for query requsts
@@ -2567,32 +2577,70 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
 }
 
+static void ufshcd_map_dev_cmd_buf(struct ufs_hba *hba, struct ufshcd_lrb *lrbp, u32 sz)
+{
+	struct ufshcd_sg_entry *prd_table;
+
+	/* Prepare PRD table */
+	if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN) {
+		lrbp->utr_descriptor_ptr->prd_table_length =
+				cpu_to_le16(sizeof(struct ufshcd_sg_entry));
+	} else {
+		lrbp->utr_descriptor_ptr->prd_table_length = cpu_to_le16(1);
+	}
+
+	prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
+
+	prd_table[0].size       = cpu_to_le32((sz - 1) | 3);
+	prd_table[0].base_addr  = cpu_to_le32(lower_32_bits(hba->dev_cmd.buf_dma_addr));
+	prd_table[0].upper_addr = cpu_to_le32(upper_32_bits(hba->dev_cmd.buf_dma_addr));
+	prd_table[0].reserved   = 0;
+}
+
+static void ufshcd_prepare_request_sense_upiu(struct ufs_hba *hba,
+					      struct ufshcd_lrb *lrbp,
+					      u8 upiu_flags)
+{
+	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, UFS_SENSE_SIZE, 0};
+
+	__ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags, UFS_SENSE_SIZE,
+					   cmd, ARRAY_SIZE(cmd));
+	ufshcd_map_dev_cmd_buf(hba, lrbp, UFS_SENSE_SIZE);
+}
+
 /**
  * ufshcd_compose_devman_upiu - UFS Protocol Information Unit(UPIU)
  *			     for Device Management Purposes
  * @hba: per adapter instance
  * @lrbp: pointer to local reference block
  */
-static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
-				      struct ufshcd_lrb *lrbp)
+static void ufshcd_compose_devman_upiu(struct ufs_hba *hba,
+				       struct ufshcd_lrb *lrbp)
 {
+	enum dma_data_direction dir;
+	int command_type;
 	u8 upiu_flags;
-	int ret = 0;
+
+	if (hba->dev_cmd.type == DEV_CMD_TYPE_SENSE) {
+		command_type = UTP_CMD_TYPE_SCSI;
+		dir = DMA_FROM_DEVICE;
+	} else {
+		command_type = UTP_CMD_TYPE_DEV_MANAGE;
+		dir = DMA_NONE;
+	}
 
 	if (hba->ufs_version <= ufshci_version(1, 1))
-		lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
+		lrbp->command_type = command_type;
 	else
 		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
 
-	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
+	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, dir);
 	if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
 		ufshcd_prepare_utp_query_req_upiu(hba, lrbp, upiu_flags);
 	else if (hba->dev_cmd.type == DEV_CMD_TYPE_NOP)
 		ufshcd_prepare_utp_nop_upiu(lrbp);
-	else
-		ret = -EINVAL;
-
-	return ret;
+	else if (hba->dev_cmd.type == DEV_CMD_TYPE_SENSE)
+		ufshcd_prepare_request_sense_upiu(hba, lrbp, upiu_flags);
 }
 
 /**
@@ -2769,19 +2817,19 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	return err;
 }
 
-static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
-		struct ufshcd_lrb *lrbp, enum dev_cmd_type cmd_type, int tag)
+static void ufshcd_compose_dev_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
+				   enum dev_cmd_type cmd_type, int tag, u8 lun)
 {
 	lrbp->cmd = NULL;
 	lrbp->sense_bufflen = 0;
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
-	lrbp->lun = 0; /* device management cmd is not specific to any LUN */
+	lrbp->lun = lun;
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
 	ufshcd_prepare_lrbp_crypto(NULL, lrbp);
 	hba->dev_cmd.type = cmd_type;
 
-	return ufshcd_compose_devman_upiu(hba, lrbp);
+	ufshcd_compose_devman_upiu(hba, lrbp);
 }
 
 static int
@@ -2818,6 +2866,29 @@ ufshcd_check_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	return query_res->response;
 }
 
+static int
+ufshcd_check_sense_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	int scsi_status;
+	int resp;
+
+	resp = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
+	if (resp != UPIU_TRANSACTION_RESPONSE) {
+		dev_err(hba->dev, "%s: Invalid cmd response: %#x\n",
+			__func__, resp);
+		return -EINVAL;
+	}
+
+	resp = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
+	scsi_status = resp & MASK_SCSI_STATUS;
+	if (scsi_status != SAM_STAT_GOOD) {
+		dev_err(hba->dev, "%s: REQUEST_SENSE failed, status %#x\n",
+			__func__, scsi_status);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /**
  * ufshcd_dev_cmd_completion() - handles device management command responses
  * @hba: per adapter instance
@@ -2851,6 +2922,12 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		dev_err(hba->dev, "%s: Reject UPIU not fully implemented\n",
 				__func__);
 		break;
+	case UPIU_TRANSACTION_RESPONSE:
+		if (hba->dev_cmd.type == DEV_CMD_TYPE_SENSE) {
+			err = ufshcd_check_sense_response(hba, lrbp);
+			break;
+		}
+		fallthrough;
 	default:
 		err = -EINVAL;
 		dev_err(hba->dev, "%s: Invalid device management cmd response: %x\n",
@@ -2884,6 +2961,8 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		err = -ETIMEDOUT;
 		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
 			__func__, lrbp->task_tag);
+		if (hba->dev_cmd.type == DEV_CMD_TYPE_SENSE)
+			ufshcd_try_to_abort_task(hba, lrbp->task_tag);
 		if (!ufshcd_clear_cmd(hba, lrbp->task_tag))
 			/* successfully cleared the command, retry if needed */
 			err = -EAGAIN;
@@ -2939,9 +3018,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
-	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
-	if (unlikely(err))
-		goto out;
+	ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag, 0);
 
 	hba->dev_cmd.complete = &wait;
 
@@ -2951,8 +3028,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
-
-out:
 	blk_put_request(req);
 out_unlock:
 	up_read(&hba->clk_scaling_lock);
@@ -3557,6 +3632,7 @@ static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
 static int ufshcd_memory_alloc(struct ufs_hba *hba)
 {
 	size_t utmrdl_size, utrdl_size, ucdl_size;
+	size_t extra, dev_cmd_buf_offs;
 
 	/* Allocate memory for UTP command descriptors */
 	ucdl_size = (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
@@ -3594,13 +3670,16 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 		goto out;
 	}
 
+	/* Double for alignment */
+	extra = UFS_DEV_CMD_BUF_SZ * 2;
+
 	/*
 	 * Allocate memory for UTP Task Management descriptors
 	 * UFSHCI requires 1024 byte alignment of UTMRD
 	 */
 	utmrdl_size = sizeof(struct utp_task_req_desc) * hba->nutmrs;
 	hba->utmrdl_base_addr = dmam_alloc_coherent(hba->dev,
-						    utmrdl_size,
+						    utmrdl_size + extra,
 						    &hba->utmrdl_dma_addr,
 						    GFP_KERNEL);
 	if (!hba->utmrdl_base_addr ||
@@ -3610,6 +3689,10 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 		goto out;
 	}
 
+	dev_cmd_buf_offs = round_up(utmrdl_size, UFS_DEV_CMD_BUF_SZ);
+	hba->dev_cmd.buf = (void *)hba->utmrdl_base_addr + dev_cmd_buf_offs;
+	hba->dev_cmd.buf_dma_addr = hba->utmrdl_dma_addr + dev_cmd_buf_offs;
+
 	/* Allocate memory for local reference block */
 	hba->lrb = devm_kcalloc(hba->dev,
 				hba->nutrs, sizeof(struct ufshcd_lrb),
@@ -5267,14 +5350,14 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			cmd->scsi_done(cmd);
 			ufshcd_release(hba);
 			update_scaling = true;
-		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
-			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
-			if (hba->dev_cmd.complete) {
-				ufshcd_add_command_trace(hba, index,
-							 UFS_DEV_COMP);
-				complete(hba->dev_cmd.complete);
-				update_scaling = true;
-			}
+		} else if ((lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
+			    lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE ||
+			    (lrbp->command_type == UTP_CMD_TYPE_SCSI &&
+			     hba->dev_cmd.type == DEV_CMD_TYPE_SENSE)) &&
+			   hba->dev_cmd.complete) {
+			ufshcd_add_command_trace(hba, index, UFS_DEV_COMP);
+			complete(hba->dev_cmd.complete);
+			update_scaling = true;
 		}
 		if (update_scaling)
 			ufshcd_clk_scaling_update_busy(hba);
@@ -7922,60 +8005,57 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	return ret;
 }
 
-static void ufshcd_request_sense_done(struct request *rq, blk_status_t error)
+static int ufshcd_request_sense_direct(struct ufs_hba *hba, u8 wlun)
 {
-	if (error != BLK_STS_OK)
-		pr_err("%s: REQUEST SENSE failed (%d)\n", __func__, error);
-	kfree(rq->end_io_data);
-	blk_put_request(rq);
-}
-
-static int
-ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
-{
-	/*
-	 * Some UFS devices clear unit attention condition only if the sense
-	 * size used (UFS_SENSE_SIZE in this case) is non-zero.
-	 */
-	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, UFS_SENSE_SIZE, 0};
-	struct scsi_request *rq;
+	struct request_queue *q = hba->cmd_queue;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct ufshcd_lrb *lrbp;
+	int timeout_ms = 1000;
 	struct request *req;
-	char *buffer;
-	int ret;
+	int err = 0;
+	int tag;
 
-	buffer = kzalloc(UFS_SENSE_SIZE, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
+	ufshcd_hold(hba, false);
+	mutex_lock(&hba->dev_cmd.lock);
+	down_read(&hba->clk_scaling_lock);
 
-	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN,
-			      /*flags=*/BLK_MQ_REQ_PM);
+	/* The command queue cannot be frozen */
+	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(req)) {
-		ret = PTR_ERR(req);
-		goto out_free;
+		err = PTR_ERR(req);
+		goto out_unlock;
+	}
+	tag = req->tag;
+	if (WARN_ONCE(tag < 0, "Invalid tag %d\n", tag) ||
+	    unlikely(test_bit(tag, &hba->outstanding_reqs))) {
+		err = -EBUSY;
+		goto out;
 	}
 
-	ret = blk_rq_map_kern(sdev->request_queue, req,
-			      buffer, UFS_SENSE_SIZE, GFP_NOIO);
-	if (ret)
-		goto out_put;
-
-	rq = scsi_req(req);
-	rq->cmd_len = ARRAY_SIZE(cmd);
-	memcpy(rq->cmd, cmd, rq->cmd_len);
-	rq->retries = 3;
-	req->timeout = 1 * HZ;
-	req->rq_flags |= RQF_PM | RQF_QUIET;
-	req->end_io_data = buffer;
-
-	blk_execute_rq_nowait(/*bd_disk=*/NULL, req, /*at_head=*/true,
-			      ufshcd_request_sense_done);
-	return 0;
+	lrbp = &hba->lrb[tag];
+	WARN_ON(lrbp->cmd);
+
+	ufshcd_compose_dev_cmd(hba, lrbp, DEV_CMD_TYPE_SENSE, tag, wlun);
+
+	hba->dev_cmd.complete = &wait;
 
-out_put:
+	ufshcd_add_query_upiu_trace(hba, UFS_SENSE_SEND, lrbp->ucd_req_ptr);
+
+	ufshcd_send_command(hba, tag);
+
+	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout_ms);
+
+	ufshcd_add_query_upiu_trace(hba, err ? UFS_SENSE_ERR : UFS_SENSE_COMP,
+				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
+out:
 	blk_put_request(req);
-out_free:
-	kfree(buffer);
-	return ret;
+out_unlock:
+	/* Invalidate dev_cmd.type for safety */
+	hba->dev_cmd.type = DEV_CMD_TYPE_INVALID;
+	up_read(&hba->clk_scaling_lock);
+	mutex_unlock(&hba->dev_cmd.lock);
+	ufshcd_release(hba);
+	return err;
 }
 
 static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
@@ -8004,7 +8084,7 @@ static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
 	if (ret)
 		goto out_err;
 
-	ret = ufshcd_request_sense_async(hba, sdp);
+	ret = ufshcd_request_sense_direct(hba, wlun);
 	scsi_device_put(sdp);
 out_err:
 	if (ret)
@@ -8082,8 +8162,10 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 	/* UFS device is also active now */
 	ufshcd_set_ufs_dev_active(hba);
 	ufshcd_force_reset_auto_bkops(hba);
-	hba->wlun_dev_clr_ua = true;
-	hba->wlun_rpmb_clr_ua = true;
+	hba->wlun_dev_clr_ua =
+		!!ufshcd_request_sense_direct(hba, UFS_UPIU_UFS_DEVICE_WLUN);
+	hba->wlun_rpmb_clr_ua =
+		!!ufshcd_request_sense_direct(hba, UFS_UPIU_RPMB_WLUN);
 
 	/* Gear up to HS gear if supported */
 	if (hba->max_pwr_info.is_valid) {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f0da5d3db1fa..723e8af85682 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -56,6 +56,8 @@ struct ufs_hba;
 enum dev_cmd_type {
 	DEV_CMD_TYPE_NOP		= 0x0,
 	DEV_CMD_TYPE_QUERY		= 0x1,
+	DEV_CMD_TYPE_SENSE		= 0x2,
+	DEV_CMD_TYPE_INVALID		= 0xff,
 };
 
 enum ufs_event_type {
@@ -236,17 +238,27 @@ struct ufs_query {
 	struct ufs_query_res response;
 };
 
+/*
+ * UFS_DEV_CMD_BUF_SZ must be a power of 2 and bigger than UFS_SENSE_SIZE
+ * rounded up to a multiple of 4.
+ */
+#define UFS_DEV_CMD_BUF_SZ 32
+
 /**
  * struct ufs_dev_cmd - all assosiated fields with device management commands
  * @type: device management command type - Query, NOP OUT
  * @lock: lock to allow one command at a time
  * @complete: internal commands completion
+ * @buf: buffer for data
+ * @buf_dma_addr: DMA address of @buf
  */
 struct ufs_dev_cmd {
 	enum dev_cmd_type type;
 	struct mutex lock;
 	struct completion *complete;
 	struct ufs_query query;
+	void *buf;
+	dma_addr_t buf_dma_addr;
 };
 
 /**
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index 599739ee7b20..efa2af4a3a5b 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -46,7 +46,10 @@
 	EM(UFS_QUERY_ERR,	"query_complete_err")		\
 	EM(UFS_TM_SEND,		"tm_send")			\
 	EM(UFS_TM_COMP,		"tm_complete")			\
-	EMe(UFS_TM_ERR,		"tm_complete_err")
+	EM(UFS_TM_ERR,		"tm_complete_err")		\
+	EM(UFS_SENSE_SEND,	"sense_send")			\
+	EM(UFS_SENSE_COMP,	"sense_complete")		\
+	EMe(UFS_SENSE_ERR,	"sense_complete_err")
 
 #define UFS_CMD_TRACE_TSF_TYPES					\
 	EM(UFS_TSF_CDB,		"CDB")		                \
-- 
2.25.1

