Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3DF37FF40;
	Thu, 12 Mar 2026 09:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773307430; cv=none; b=rpVfAnKVHDo6wdWlvk9L5Ye0rQf0YfHUCvyo0MwJ+nN5hoc7kMjhD+aXD5aqYnJpbrOSrpH4VzUphXiPSNQIusrG8dffmy7gyG/GPfMfng9joWh78B/Ul55gFhGlZG0vjJumfw5UhF3yr+jcwDnD72wNWvU3kpiFlGes30ZeV4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773307430; c=relaxed/simple;
	bh=Kj/Y/yQQZ5BLFyUlx3xf4nEjuSnC3yVF2gJhCMqUvwE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bkRMfQ5GEUF6nI7IJFHVj3x18Vg2pn5eTYgIT4ZskzzOue6iHe1x3bhKZ0dB5cSBxrUqSCcMYtaCJuGknv78s0NAcAEhivC/3brEENEBl4v5/Gs59Ml+m5KI2RynufiYlUrdo+TfKGeZFmMOqonb+ymVhP1CqqoaSSS3bi4HYz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=V7dQzazl; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="V7dQzazl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=S9
	v7nWdhoHXfofkJyPk18O7W6VJpwd66E99N56vD11k=; b=V7dQzazlMbAgCHGHr1
	vvavaK9raaEdmCdvUf3BnKNGz746sHCoqDeSV4zzEdeYzJmBd941H13dAMNfYPv1
	FWsDc9WNjQ/jZqkqmGdNS65hcVjSYpHkk7vYhVS7l3qjyJR8i4zDFf2uKXhkcdq3
	WgOFYxGoOBJwFyfDgVE9XRU/Y=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDn0tbfhbJpu7uqAQ--.55S5;
	Thu, 12 Mar 2026 17:22:53 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk,
	fujita.tomonori@lab.ntt.co.jp,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	bvanassche@acm.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v7 3/3] scsi: bsg: add io_uring passthrough handler
Date: Thu, 12 Mar 2026 17:22:37 +0800
Message-Id: <20260312092237.2464560-4-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260312092237.2464560-1-yangxiuwei@kylinos.cn>
References: <20260312092237.2464560-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDn0tbfhbJpu7uqAQ--.55S5
X-Coremail-Antispam: 1Uf129KBjvJXoW3GrWfGrW3KFyUuFy5Gr47CFg_yoWxJFWfpF
	W5tw4YvrW5Wr1I9FZYy398uFWYvw4kC3W7KFW5uw43Ar1UCr9ag3W0kF10qFyfArWkAa42
	qr4vgFZ8Cr1jq37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jaeHDUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwg2jNGmyhe2hcQAA37

Implement the SCSI-specific io_uring command handler for BSG using
struct bsg_uring_cmd.

The handler builds a SCSI request from the io_uring command, maps user
buffers (including fixed buffers), and completes asynchronously via a
request end_io callback and task_work. Completion returns a 32-bit
status and packed residual/sense information via CQE res and res2, and
supports IO_URING_F_NONBLOCK.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/scsi_bsg.c | 173 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 172 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 4d57e524e141..da227fa890e0 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -10,10 +10,181 @@
 
 #define uptr64(val) ((void __user *)(uintptr_t)(val))
 
+/*
+ * Per-command BSG SCSI PDU stored in io_uring_cmd.pdu[32].
+ * Holds temporary state between submission, completion and task_work.
+ */
+struct scsi_bsg_uring_cmd_pdu {
+	struct bio *bio;		/* mapped user buffer, unmap in task work */
+	struct request *req;		/* block request, freed in task work */
+	u64 response_addr;		/* user space response buffer address */
+};
+
+static inline struct scsi_bsg_uring_cmd_pdu *scsi_bsg_uring_cmd_pdu(
+	struct io_uring_cmd *ioucmd)
+{
+	return io_uring_cmd_to_pdu(ioucmd, struct scsi_bsg_uring_cmd_pdu);
+}
+
+/* Task work: build res2 (layout in uapi/linux/bsg.h) and copy sense to user. */
+static void scsi_bsg_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t tw)
+{
+	struct scsi_bsg_uring_cmd_pdu *pdu;
+	struct io_uring_cmd *ioucmd = io_uring_cmd_from_tw(tw_req);
+	struct scsi_cmnd *scmd;
+	struct request *rq;
+	u64 res2;
+	int ret = 0;
+	u8 driver_status = 0;
+	u8 sense_len_wr = 0;
+
+	pdu = scsi_bsg_uring_cmd_pdu(ioucmd);
+	rq = pdu->req;
+	scmd = blk_mq_rq_to_pdu(rq);
+
+	if (pdu->bio)
+		blk_rq_unmap_user(pdu->bio);
+
+	if (scsi_status_is_check_condition(scmd->result)) {
+		driver_status = DRIVER_SENSE;
+		if (pdu->response_addr)
+			sense_len_wr = min_t(u8, scmd->sense_len,
+					     SCSI_SENSE_BUFFERSIZE);
+	}
+
+	if (sense_len_wr) {
+		if (copy_to_user(uptr64(pdu->response_addr), scmd->sense_buffer,
+				 sense_len_wr))
+			ret = -EFAULT;
+	}
+
+	res2 = BSG_SCSI_RES2_BUILD(status_byte(scmd->result), driver_status,
+				  host_byte(scmd->result), sense_len_wr,
+				  scmd->resid_len);
+
+	blk_mq_free_request(rq);
+	io_uring_cmd_done32(ioucmd, ret, res2,
+			    IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
+}
+
+static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct request *req,
+						  blk_status_t status,
+						  const struct io_comp_batch *iocb)
+{
+	struct io_uring_cmd *ioucmd = req->end_io_data;
+
+	io_uring_cmd_do_in_task_lazy(ioucmd, scsi_bsg_uring_task_cb);
+	return RQ_END_IO_NONE;
+}
+
+static int scsi_bsg_map_user_buffer(struct request *req,
+				    struct io_uring_cmd *ioucmd,
+				    unsigned int issue_flags, gfp_t gfp_mask)
+{
+	const struct bsg_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
+	struct iov_iter iter;
+	unsigned long buf_len;
+	bool is_write = cmd->dout_xfer_len > 0;
+	u64 buf_addr = is_write ? cmd->dout_xferp : cmd->din_xferp;
+	int ret;
+
+	buf_len = is_write ? cmd->dout_xfer_len : cmd->din_xfer_len;
+
+	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
+		ret = io_uring_cmd_import_fixed(buf_addr, buf_len,
+						is_write ? WRITE : READ,
+						&iter, ioucmd, issue_flags);
+		if (ret < 0)
+			return ret;
+		ret = blk_rq_map_user_iov(req->q, req, NULL, &iter, gfp_mask);
+	} else {
+		ret = blk_rq_map_user(req->q, req, NULL, uptr64(buf_addr),
+				      buf_len, gfp_mask);
+	}
+
+	return ret;
+}
+
 static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *ioucmd,
 			       unsigned int issue_flags, bool open_for_write)
 {
-	return -EOPNOTSUPP;
+	struct scsi_bsg_uring_cmd_pdu *pdu = scsi_bsg_uring_cmd_pdu(ioucmd);
+	const struct bsg_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
+	struct scsi_cmnd *scmd;
+	blk_mq_req_flags_t blk_flags = 0;
+	struct request *req;
+	gfp_t gfp_mask = GFP_KERNEL;
+	int ret = 0;
+
+	if (cmd->protocol != BSG_PROTOCOL_SCSI ||
+	    cmd->subprotocol != BSG_SUB_PROTOCOL_SCSI_CMD)
+		return -EINVAL;
+
+	if (!cmd->request || cmd->request_len == 0)
+		return -EINVAL;
+
+	if (cmd->dout_xfer_len && cmd->din_xfer_len) {
+		pr_warn_once("BIDI support in bsg has been removed.\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (cmd->dout_iovec_count > 0 || cmd->din_iovec_count > 0)
+		return -EOPNOTSUPP;
+
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		blk_flags = BLK_MQ_REQ_NOWAIT;
+		gfp_mask = GFP_NOWAIT;
+	}
+
+	req = scsi_alloc_request(q, cmd->dout_xfer_len ?
+				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN, blk_flags);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	scmd = blk_mq_rq_to_pdu(req);
+	scmd->cmd_len = cmd->request_len;
+	if (scmd->cmd_len > sizeof(scmd->cmnd)) {
+		ret = -EINVAL;
+		goto out_free_req;
+	}
+	scmd->allowed = SG_DEFAULT_RETRIES;
+
+	if (copy_from_user(scmd->cmnd, uptr64(cmd->request), cmd->request_len)) {
+		ret = -EFAULT;
+		goto out_free_req;
+	}
+
+	if (!scsi_cmd_allowed(scmd->cmnd, open_for_write)) {
+		ret = -EPERM;
+		goto out_free_req;
+	}
+
+	pdu->response_addr = cmd->response;
+	scmd->sense_len = cmd->max_response_len ?
+		min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERSIZE;
+
+	if (cmd->dout_xfer_len || cmd->din_xfer_len) {
+		ret = scsi_bsg_map_user_buffer(req, ioucmd, issue_flags, gfp_mask);
+		if (ret)
+			goto out_free_req;
+		pdu->bio = req->bio;
+	} else {
+		pdu->bio = NULL;
+	}
+
+	req->timeout = cmd->timeout_ms ?
+		msecs_to_jiffies(cmd->timeout_ms) : BLK_DEFAULT_SG_TIMEOUT;
+
+	req->end_io = scsi_bsg_uring_cmd_done;
+	req->end_io_data = ioucmd;
+	pdu->req = req;
+
+	blk_execute_rq_nowait(req, false);
+	return -EIOCBQUEUED;
+
+out_free_req:
+	blk_mq_free_request(req);
+	return ret;
 }
 
 static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
-- 
2.25.1

