Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1077B190462;
	Mon, 17 Aug 2026 08:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786954231; cv=none; b=Reg3LjRSOcQPrrPOTHhqW0hllavWOY9NjuV1j90ln/xJwF4+lmaNHFGL3RcsclMoBBTopSvz6soPMQ/41XAFaZ4/acUiOblcKLRY2JdZ++3RMvxkt1EGHzjaKun+xMxm1vHWCa5/T/RtGoH5O6TYpAb5aCTqoSS0hyf8Yv9CP6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786954231; c=relaxed/simple;
	bh=bY4TCuOOw5IetSosG1NCHo6cbnBVS49n+Pmaj4zxxhw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d+mk34Fy3VGjNvFJjAcFBhhe9A5yO12fkn29TbjCChSWXNSa7yNJ0YVbmLEslKyH3hTYnyYltJyDqTAyHn/xk4O/47VSnp+obKPU4OxfE4/X81q6ck6K57m/Bdd/JigkoEDtdVMb8kCZaBbHZ0DPPTS4+HOpZ6vPTyAN4sP/EXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lGUpqhY4; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lGUpqhY4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=C/
	Ds0Ouy+iXpMEJIWkJQJBFzDXs1DtTbz9+QQw4wjHc=; b=lGUpqhY4rsR/O0EJus
	QvdX09cXPzSYkpzJ/bF3WfE/8jfOBRSG7c/UP1rg9GLOy2Wo0FWwC5zdPR++w1B0
	DELohYhgS/e4lMHnivDl0lImdZ48wOQxVPkYyeQuEYHA6m/UNrw/E1de361Bqx2r
	110xTfm9IXm8AN+rv5PT/OGJ8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wBnnvpFwYJqCVRqOA--.71S4;
	Mon, 17 Aug 2026 16:07:40 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: axboe@kernel.dk,
	bvanassche@acm.org,
	csander@purestorage.com,
	fujita.tomonori@lab.ntt.co.jp,
	io-uring@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	rc@rexion.ai,
	stable@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v4 2/3] scsi: bsg: fix TOCTOU in io_uring passthrough command setup
Date: Mon, 17 Aug 2026 16:07:29 +0800
Message-Id: <20260817080730.967879-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817080730.967879-1-yangxiuwei@kylinos.cn>
References: <20260817080730.967879-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnnvpFwYJqCVRqOA--.71S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxAr1kCr1fWr1xXw47WF43Awb_yoWrur18pF
	WYqw4Svr45WF1IkFyDJFZ8Aay5twn7C3WxKFW3Ww43trWDur909a18tFyIqF9xAr97AFy8
	Jr1qgF1DCr1jq3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U_73PUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwQy+T2qCwUwMgQAA3U

From: Rahul Chandelkar <rc@rexion.ai>

scsi_bsg_uring_cmd() reads bsg_uring_cmd from the shared mmap'd SQE.
Userspace can change a field after we check it and before we use it.
request_len is the sharp case: it can grow past sizeof(scmd->cmnd)
after the bound check and overflow scmd->cmnd in copy_from_user().

READ_ONCE() the SQE fields we check or use into locals before use.

Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260527105931.3950913-1-rc@rexion.ai
Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
Co-developed-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/scsi_bsg.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index b3c4b1063d6f..5eec248a77a6 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -77,12 +77,10 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct request *req,
 
 static int scsi_bsg_map_user_buffer(struct request *req,
 				    struct io_uring_cmd *ioucmd,
-				    unsigned int issue_flags, gfp_t gfp_mask)
+				    unsigned int issue_flags, gfp_t gfp_mask,
+				    bool is_write, u64 buf_addr,
+				    unsigned long buf_len)
 {
-	const struct bsg_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
-	bool is_write = cmd->dout_xfer_len > 0;
-	u64 buf_addr = is_write ? cmd->dout_xferp : cmd->din_xferp;
-	unsigned long buf_len = is_write ? cmd->dout_xfer_len : cmd->din_xfer_len;
 	struct iov_iter iter;
 	int ret;
 
@@ -105,21 +103,28 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 			       unsigned int issue_flags, bool open_for_write)
 {
 	struct scsi_bsg_uring_cmd_pdu *pdu = scsi_bsg_uring_cmd_pdu(ioucmd);
-	const struct bsg_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
+	const struct bsg_uring_cmd *cmd =
+		io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
 	struct scsi_cmnd *scmd;
 	struct request *req;
 	blk_mq_req_flags_t blk_flags = 0;
 	gfp_t gfp_mask = GFP_KERNEL;
+	u64 request = READ_ONCE(cmd->request);
+	u32 request_len = READ_ONCE(cmd->request_len);
+	u64 dout_xferp = READ_ONCE(cmd->dout_xferp);
+	u32 dout_xfer_len = READ_ONCE(cmd->dout_xfer_len);
+	u64 din_xferp = READ_ONCE(cmd->din_xferp);
+	u32 din_xfer_len = READ_ONCE(cmd->din_xfer_len);
 	int ret;
 
 	if (cmd->protocol != BSG_PROTOCOL_SCSI ||
 	    cmd->subprotocol != BSG_SUB_PROTOCOL_SCSI_CMD)
 		return -EINVAL;
 
-	if (!cmd->request || cmd->request_len == 0)
+	if (!request || request_len == 0)
 		return -EINVAL;
 
-	if (cmd->dout_xfer_len && cmd->din_xfer_len) {
+	if (dout_xfer_len && din_xfer_len) {
 		pr_warn_once("BIDI support in bsg has been removed.\n");
 		return -EOPNOTSUPP;
 	}
@@ -132,20 +137,20 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 		gfp_mask = GFP_NOWAIT;
 	}
 
-	req = scsi_alloc_request(q, cmd->dout_xfer_len ?
+	req = scsi_alloc_request(q, dout_xfer_len ?
 				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN, blk_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
 	scmd = blk_mq_rq_to_pdu(req);
-	if (cmd->request_len > sizeof(scmd->cmnd)) {
+	if (request_len > sizeof(scmd->cmnd)) {
 		ret = -EINVAL;
 		goto out_free_req;
 	}
-	scmd->cmd_len = cmd->request_len;
+	scmd->cmd_len = request_len;
 	scmd->allowed = SG_DEFAULT_RETRIES;
 
-	if (copy_from_user(scmd->cmnd, uptr64(cmd->request), cmd->request_len)) {
+	if (copy_from_user(scmd->cmnd, uptr64(request), request_len)) {
 		ret = -EFAULT;
 		goto out_free_req;
 	}
@@ -158,8 +163,14 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 	pdu->response_addr = cmd->response;
 	pdu->max_response_len = cmd->max_response_len;
 
-	if (cmd->dout_xfer_len || cmd->din_xfer_len) {
-		ret = scsi_bsg_map_user_buffer(req, ioucmd, issue_flags, gfp_mask);
+	if (dout_xfer_len || din_xfer_len) {
+		bool is_write = dout_xfer_len > 0;
+		u64 buf_addr = is_write ? dout_xferp : din_xferp;
+		unsigned long buf_len = is_write ? dout_xfer_len : din_xfer_len;
+
+		ret = scsi_bsg_map_user_buffer(req, ioucmd, issue_flags,
+					       gfp_mask, is_write, buf_addr,
+					       buf_len);
 		if (ret)
 			goto out_free_req;
 		pdu->bio = req->bio;
-- 
2.25.1

