Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B7938C2C6;
	Mon, 27 Jul 2026 01:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785116576; cv=none; b=bkwNwYfRHo1RfNL+zpnZsT0OHsrzfjptllL9F6b7Zxy6mW/fAK9lL6lHVk1cE0qJEuTTzTx9Xup+Z/pQErHAJ39GtMyxiqC5aHwhopFUZyq5mxG0u48YQqGXtC1R4PCUtGf2YcxiSjVbOUBivmnWtjmyrKyY4Ktj4Jts44qhbSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785116576; c=relaxed/simple;
	bh=aCw3Kp4Tnc468XM3tFsH3Urrd8/yPVaTXKtD5pf7b80=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GWNu9/Nnwf7vvPZ7e+zWBOQxHkEQdAk28bJHZjRUBCYNluZQ1qxfeM/9ZrUS2iomZQHTc7myOdXAePccvIs3PuKLhUbXVfagmdSq/u18izxAHM3r7ySDDjCZPXaR/JRQMXeDNJ5xULdE8fVBlmq8mYgAsYv8OjGHbrhbvJr2oSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=cQPj40bU; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="cQPj40bU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=04
	rZUZoZPczPB38M5BSr7+KtS5XoV3XNY4ncQIguXMU=; b=cQPj40bU5brCfjzd6u
	CyhsiU8kOS+ZJ4oNKXCsUbB6l36RYzPjDJQUpDpX9pQoa6xBqkw7v8URIDSbD2X0
	IJ1JoULgEWgRbK8MnysnFwRaexuaHhUIWZ5bwmk4NZOlKpfqdBiW0fIupDqDJE9j
	x8SOjwCUrdNojllT9U76PybFc=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDXnw0_t2Zq_LNqJw--.32185S3;
	Mon, 27 Jul 2026 09:41:22 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@hansenpartnership.com,
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
Subject: [PATCH v2 1/2] scsi: bsg: fix TOCTOU in io_uring passthrough command setup
Date: Mon, 27 Jul 2026 09:41:16 +0800
Message-Id: <20260727014117.1742202-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260727014117.1742202-1-yangxiuwei@kylinos.cn>
References: <20260727014117.1742202-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDXnw0_t2Zq_LNqJw--.32185S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxAr1kCr1UKr48Cw18Ww48WFg_yoWrKF1kpF
	WYqw4Svr45WF1IkFyDJFW5Zay5tw1kC3W7KFW3Ww43trWqvr909a18XFyIqFyfAr97AFyF
	qr4qgF1UCr1jq3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUzV8UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gIywmpmt0Ko3QAA3U

From: Rahul Chandelkar <rc@rexion.ai>

scsi_bsg_uring_cmd() reads bsg_uring_cmd from the shared mmap'd SQE.
On the inline path the SQE remains user-writable, so a field can change
between check and use (e.g. request_len vs copy_from_user() overflowing
scmd->cmnd).

READ_ONCE the fields we validate or consume into locals before use, and
pass stable map arguments into scsi_bsg_map_user_buffer().

Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20260527105931.3950913-1-rc@rexion.ai
Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
Co-developed-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/scsi_bsg.c | 44 ++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index e80dec53174e..7758c5f22a7e 100644
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
+	u64 request = READ_ONCE(cmd->request);
+	u32 request_len = READ_ONCE(cmd->request_len);
+	u64 dout_xferp = READ_ONCE(cmd->dout_xferp);
+	u32 dout_xfer_len = READ_ONCE(cmd->dout_xfer_len);
+	u64 din_xferp = READ_ONCE(cmd->din_xferp);
+	u32 din_xfer_len = READ_ONCE(cmd->din_xfer_len);
+	u32 max_response_len = READ_ONCE(cmd->max_response_len);
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
@@ -155,11 +161,17 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 	}
 
 	pdu->response_addr = cmd->response;
-	scmd->sense_len = cmd->max_response_len ?
-		min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERSIZE;
+	scmd->sense_len = max_response_len ?
+		min(max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERSIZE;
 
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

