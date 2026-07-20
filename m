Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A30299923;
	Mon, 20 Jul 2026 03:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784517868; cv=none; b=oanFAv3zENq83ycJJxKigfAMgGjbwAuwJGKGWFnHu1Rs4PnkI82jtq8fH0sC6QQZLsBmeCgOw8iw0eTDwLQ35TqR/tJbbr4jfiPNoReBOPkivaMlsq11N+uv58CyavEKRinl2CiWL12INV+puybmG52O2+Q2m2sxcu8e50pLCI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784517868; c=relaxed/simple;
	bh=Ue3DV4QUUZ4ljqrjSWAHXoqcy8Ogvs4mLZEys8j07I4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HadoWyafC+TrU0CqdZPMFygyf5/8TX3BamdqbH4QVsVxOMA1MB1S1NC4VniMUcHlZ1Efc0oi99p1KGHyRnnDgAAgAw4R/av000w7Nj8QST91zURZtDCIRlyrIxqzv2f0fNKXYb5Ucc0raz5+heohWh22tELsiE+oThZ+kgQhISk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=pBFiFkui; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="pBFiFkui"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=5G
	ZLmH9LnQCWSlRdWLB0LksgmcVa962p1jFapMPS7Bw=; b=pBFiFkui9dDZBTQkzH
	paXM4kxl0TlWaILDacAWkcXiTCRcnZqQfdLr0J8PX8CCiyoqFR9TnjatfOJk+zry
	G17pDMBAIg2P1uHABsUeLUqVkpVD1GwHvIJKgKnA30valsDrt+P5R6GrBmDp+Qrk
	/rpx3BefvlLlC9rudmSTzoFhA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAH9nK8lF1qF6ikKA--.13720S3;
	Mon, 20 Jul 2026 11:23:44 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: rc@rexion.ai,
	axboe@kernel.dk,
	fujita.tomonori@lab.ntt.co.jp,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org,
	stable@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 1/2] scsi: bsg: fix TOCTOU in io_uring passthrough command setup
Date: Mon, 20 Jul 2026 11:23:37 +0800
Message-Id: <20260720032338.461681-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260720032338.461681-1-yangxiuwei@kylinos.cn>
References: <20260720032338.461681-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAH9nK8lF1qF6ikKA--.13720S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxXr4DtF4ftw48Xr4kZF1DJrb_yoWrKr1fpF
	WYqw4SvrW5WF1IkFyDJFZ8Aay5twn7C3WxKFW3Ww43trWqyr909a1rXFyIqFyfAr97AFyF
	qr4qgFyDCr1jq3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjoGdUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gBH12pdlMDHgwAA3d

From: Rahul Chandelkar <rc@rexion.ai>

scsi_bsg_uring_cmd() reads bsg_uring_cmd fields from the shared mmap'd
SQE via io_uring_sqe128_cmd(). On the inline path the SQE is still
user-writable, so request_len can change between the bounds check and
copy_from_user(), overflowing scmd->cmnd.

Snapshot request/request_len and the transfer fields used for buffer
mapping with READ_ONCE before validation and reuse. Pass the stable
map arguments into scsi_bsg_map_user_buffer() so it does not re-read
the SQE.

Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260527105931.3950913-1-rc@rexion.ai
Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
Co-developed-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/scsi_bsg.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index e80dec53174e..c57ce01379de 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -76,12 +76,10 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct request *req,
 
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
 
@@ -104,21 +102,29 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
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
+	/* Snapshot SQE fields used for validation and buffer mapping. */
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
@@ -131,20 +137,20 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
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
@@ -158,8 +164,14 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 	scmd->sense_len = cmd->max_response_len ?
 		min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERSIZE;
 
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

