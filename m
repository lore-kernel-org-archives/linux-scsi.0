Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 831F3C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 09:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63AB3610A1
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 09:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbhIVJjl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 05:39:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:35896 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234405AbhIVJjj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 05:39:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="287225664"
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="287225664"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 02:38:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="474496261"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.84])
  by fmsmga007.fm.intel.com with ESMTP; 22 Sep 2021 02:38:05 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
Subject: [PATCH V5 1/3] scsi: ufs: Fix error handler clear ua deadlock
Date:   Wed, 22 Sep 2021 12:38:40 +0300
Message-Id: <20210922093842.18025-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210922093842.18025-1-adrian.hunter@intel.com>
References: <20210922093842.18025-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
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
 drivers/scsi/ufs/ufshcd.c  | 203 +++++++++++++++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h  |   9 ++
 include/trace/events/ufs.h |   5 +-
 4 files changed, 162 insertions(+), 58 deletions(-)

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
index 1f97818aa0bf..d725390aea99 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2818,6 +2818,29 @@ ufshcd_check_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
@@ -2851,6 +2874,12 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
@@ -2884,6 +2913,8 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		err = -ETIMEDOUT;
 		dev_dbg(hba->dev, "%s: dev_cmd request timedout, tag %d\n",
 			__func__, lrbp->task_tag);
+		if (hba->dev_cmd.type == DEV_CMD_TYPE_SENSE)
+			ufshcd_try_to_abort_task(hba, lrbp->task_tag);
 		if (!ufshcd_clear_cmd(hba, lrbp->task_tag))
 			/* successfully cleared the command, retry if needed */
 			err = -EAGAIN;
@@ -3557,6 +3588,7 @@ static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
 static int ufshcd_memory_alloc(struct ufs_hba *hba)
 {
 	size_t utmrdl_size, utrdl_size, ucdl_size;
+	size_t extra, dev_cmd_buf_offs;
 
 	/* Allocate memory for UTP command descriptors */
 	ucdl_size = (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
@@ -3594,13 +3626,16 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
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
@@ -3610,6 +3645,10 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 		goto out;
 	}
 
+	dev_cmd_buf_offs = round_up(utmrdl_size, UFS_DEV_CMD_BUF_SZ);
+	hba->dev_cmd.buf = (void *)hba->utmrdl_base_addr + dev_cmd_buf_offs;
+	hba->dev_cmd.buf_dma_addr = hba->utmrdl_dma_addr + dev_cmd_buf_offs;
+
 	/* Allocate memory for local reference block */
 	hba->lrb = devm_kcalloc(hba->dev,
 				hba->nutrs, sizeof(struct ufshcd_lrb),
@@ -5267,14 +5306,14 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
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
@@ -7908,60 +7947,110 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
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
 	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, UFS_SENSE_SIZE, 0};
-	struct scsi_request *rq;
+	struct request_queue *q = hba->cmd_queue;
+	struct ufshcd_sg_entry *prd_table;
+	struct utp_upiu_req *ucd_req_ptr;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct ufshcd_lrb *lrbp;
+	int timeout_ms = 1000;
 	struct request *req;
-	char *buffer;
-	int ret;
+	u8 upiu_flags;
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
+	lrbp->cmd = NULL;
+	lrbp->sense_bufflen = 0;
+	lrbp->sense_buffer = NULL;
+	lrbp->task_tag = tag;
+	lrbp->lun = wlun;
+	lrbp->intr_cmd = true;
+	ufshcd_prepare_lrbp_crypto(NULL, lrbp);
+	hba->dev_cmd.type = DEV_CMD_TYPE_SENSE;
+
+	if (hba->ufs_version <= ufshci_version(1, 1))
+		lrbp->command_type = UTP_CMD_TYPE_SCSI;
+	else
+		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
+
+	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_FROM_DEVICE);
+
+	/* Prepare UPIU */
+	ucd_req_ptr = lrbp->ucd_req_ptr;
+
+	/* command descriptor fields */
+	ucd_req_ptr->header.dword_0 =
+		UPIU_HEADER_DWORD(UPIU_TRANSACTION_COMMAND, upiu_flags,
+				  lrbp->lun, lrbp->task_tag);
+	ucd_req_ptr->header.dword_1 =
+		UPIU_HEADER_DWORD(UPIU_COMMAND_SET_TYPE_SCSI, 0, 0, 0);
+
+	/* Total EHS length and Data segment length will be zero */
+	ucd_req_ptr->header.dword_2 = 0;
+
+	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(UFS_SENSE_SIZE);
 
-out_put:
+	memset(ucd_req_ptr->sc.cdb, 0, UFS_CDB_SIZE);
+	memcpy(ucd_req_ptr->sc.cdb, cmd, ARRAY_SIZE(cmd));
+
+	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
+	memset(hba->dev_cmd.buf, 0, UFS_DEV_CMD_BUF_SZ);
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
+	prd_table[0].size       = cpu_to_le32(UFS_SENSE_SIZE - 1);
+	prd_table[0].base_addr  = cpu_to_le32(lower_32_bits(hba->dev_cmd.buf_dma_addr));
+	prd_table[0].upper_addr = cpu_to_le32(upper_32_bits(hba->dev_cmd.buf_dma_addr));
+	prd_table[0].reserved   = 0;
+
+	hba->dev_cmd.complete = &wait;
+
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
@@ -7990,7 +8079,7 @@ static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
 	if (ret)
 		goto out_err;
 
-	ret = ufshcd_request_sense_async(hba, sdp);
+	ret = ufshcd_request_sense_direct(hba, wlun);
 	scsi_device_put(sdp);
 out_err:
 	if (ret)
@@ -8068,8 +8157,10 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
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
index 41f6e06f9185..06e743a5937a 100644
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
@@ -236,17 +238,24 @@ struct ufs_query {
 	struct ufs_query_res response;
 };
 
+/* UFS_DEV_CMD_BUF_SZ must be a power of 2 and bigger than UFS_SENSE_SIZE */
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
2.17.1

