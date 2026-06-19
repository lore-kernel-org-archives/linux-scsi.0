Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F5931F9B5
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2026 01:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781833165; cv=none; b=mGR/Uqaq/jrBnkB7Xlch9ULxa4Obk38kCZvAfobIzLorwwaPYt1/QR5yrZTjLgHhLEyZibg/vXZXPxNdVrFmnB0X/68vhcbhvTWODaTR8pMmMjTP+yoH7/arfC3xyqMuocASZG1H4oL2LD6hG4hSsb3gn4T4+jGUcg4GeR7DXHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781833165; c=relaxed/simple;
	bh=ZtLLI0O9oWowYP7KZukfV29Ep8xm7OJwJpQDOTG6t4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lxkl3b1X68NutUu1tSn4M2LWp5gqahMMc0tY4qBKWD0pBe8gw9YZvXCEODCoyeq8rhzb64kzgbwQ2vv9yeAK1XS+P+xng7wl16/LUbTCEZxsIonbHeX90m4INxLXF4IaK8xOVK6hTTQuvQ17z40/+H5NJUO4DoQxRqe/ZAzlkxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=FJiaUg9A; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="FJiaUg9A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Jl
	EVi2Y4SsG1RfvXekeDzI3otSX5jjsyzmh6kDiK0FU=; b=FJiaUg9AKP+2zc3n3F
	m6Q4Dz/0M6dIfK9oQx2suL+oH8lxtkymuHPXRsnUZHTVC9xJJC9RyksSSsJX3iKm
	kK2k449uj3uHZibmlwwnfbMb5rB+g3o7N9PDNhttll/dcJtGIM6funv+pzH6WVZL
	D/hdUjPcQTjr7rWA9Ip1vipN0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wDnT5KcnTRqDRhJEA--.51271S2;
	Fri, 19 Jun 2026 09:38:38 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	Martin.Petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	bvanassche@acm.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH] scsi: bsg: do not use GFP_NOWAIT for uring_cmd user buffer mapping
Date: Fri, 19 Jun 2026 09:38:33 +0800
Message-Id: <20260619013833.2312908-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnT5KcnTRqDRhJEA--.51271S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFW5WF13KFW5uF45WF1DGFg_yoW5Aw4kpF
	W5tw43ZFW5Wr48uFWqy398CFyFvw4kCa4xGFWruw4YyryDAr9I9F18KFyFqF93Aryvya4v
	qrnYka4qy3WUt37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j573kUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwR42xmo0nZ7JWAAA3j

IO_URING_F_NONBLOCK is only meant to make request allocation
non-blocking via BLK_MQ_REQ_NOWAIT. Propagating it
to blk_rq_map_user() by using GFP_NOWAIT for bio allocation
is a separate, stricter limitation. bio_alloc_bioset() gives up
without using the bio mempool when GFP_NOWAIT is passed and
the initial slab allocation fails. That can cause user
buffer mapping to fail with -ENOMEM even when memory and
request tags are otherwise available, which is not what NONBLOCK
submission is supposed to mean.

Always map uring_cmd user buffers with GFP_KERNEL and keep NOWAIT
limited to scsi_alloc_request().

Fixes: 7b6d3255e7f8 ("scsi: bsg: add io_uring passthrough handler")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/scsi_bsg.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index e80dec53174e..0fdc13d67c89 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -76,7 +76,7 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct request *req,
 
 static int scsi_bsg_map_user_buffer(struct request *req,
 				    struct io_uring_cmd *ioucmd,
-				    unsigned int issue_flags, gfp_t gfp_mask)
+				    unsigned int issue_flags)
 {
 	const struct bsg_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
 	bool is_write = cmd->dout_xfer_len > 0;
@@ -91,10 +91,10 @@ static int scsi_bsg_map_user_buffer(struct request *req,
 						&iter, ioucmd, issue_flags);
 		if (ret < 0)
 			return ret;
-		ret = blk_rq_map_user_iov(req->q, req, NULL, &iter, gfp_mask);
+		ret = blk_rq_map_user_iov(req->q, req, NULL, &iter, GFP_KERNEL);
 	} else {
 		ret = blk_rq_map_user(req->q, req, NULL, uptr64(buf_addr),
-				      buf_len, gfp_mask);
+				      buf_len, GFP_KERNEL);
 	}
 
 	return ret;
@@ -108,7 +108,6 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 	struct scsi_cmnd *scmd;
 	struct request *req;
 	blk_mq_req_flags_t blk_flags = 0;
-	gfp_t gfp_mask = GFP_KERNEL;
 	int ret;
 
 	if (cmd->protocol != BSG_PROTOCOL_SCSI ||
@@ -126,10 +125,8 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 	if (cmd->dout_iovec_count > 0 || cmd->din_iovec_count > 0)
 		return -EOPNOTSUPP;
 
-	if (issue_flags & IO_URING_F_NONBLOCK) {
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		blk_flags = BLK_MQ_REQ_NOWAIT;
-		gfp_mask = GFP_NOWAIT;
-	}
 
 	req = scsi_alloc_request(q, cmd->dout_xfer_len ?
 				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN, blk_flags);
@@ -159,7 +156,7 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 		min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERSIZE;
 
 	if (cmd->dout_xfer_len || cmd->din_xfer_len) {
-		ret = scsi_bsg_map_user_buffer(req, ioucmd, issue_flags, gfp_mask);
+		ret = scsi_bsg_map_user_buffer(req, ioucmd, issue_flags);
 		if (ret)
 			goto out_free_req;
 		pdu->bio = req->bio;
-- 
2.25.1

