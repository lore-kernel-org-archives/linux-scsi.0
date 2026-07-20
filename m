Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AB838D006;
	Mon, 20 Jul 2026 03:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784517861; cv=none; b=j3Ky+Fe5jWM1CfCd/iwblVbea30UeQh0MhwJCutQL0ztVHe8KM3MlZSIT2PGW56Xpnebi6SHVLQDzOTJsScSFzqpFaQCn4s2izgdDZsJ7/S6jxZ59ny9ueJeA1bxQsSNz6R6AU0dYbJRfSXU/N/nQhS1WdtT/fDuwCbhUg0fu68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784517861; c=relaxed/simple;
	bh=jWaWnUpsUlvcPTSBoaLwRehS4N8oQiZfhPMDreLdNfw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JjmVs5VEI1jVb1P9yD4/U6Q1o7wtRDizHk07ung+DcZcIoDn6u9s84KVNbUURNBF0T04MOs8wLah2NTwjI+mq19SCEjkG0QHJSnA+CX3bzlEMAzQeQabNGINfOQtYlwnp/upELEDiZPDgznJxDQCLoGBV6kfUu/Jiyj9bRjkEFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Riz0jqNz; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Riz0jqNz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=lK
	8HNOgQK+7+AseGMDmptHsfg+8r4+uvTA9Qyf3rwFU=; b=Riz0jqNzP/A14wFSfY
	9zAQnslRS+aC4RRDKsyAzIu62wV/1mHmc6RFxLZnXEvaBFmQfmG4BFkuGTpsee99
	D0C7WMV2XHP8RBIdNzKkk0sh5+6OHTUunO0xccRPGstv/9LVEzhj2wIOJURVQt6U
	v6Mw+oFGFE81EluXpzitaXQ2s=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAH9nK8lF1qF6ikKA--.13720S4;
	Mon, 20 Jul 2026 11:23:45 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: rc@rexion.ai,
	axboe@kernel.dk,
	fujita.tomonori@lab.ntt.co.jp,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 2/2] scsi: bsg: map io_uring user buffers with GFP_KERNEL
Date: Mon, 20 Jul 2026 11:23:38 +0800
Message-Id: <20260720032338.461681-3-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:_____wAH9nK8lF1qF6ikKA--.13720S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxCFWUXrWfJr4xAw4rGr15Jwb_yoW5Jw1fpF
	W5t3ySvFW3Xr48urWkt398ZFWFyw4kC34xKF43W3yYyryDAr90v3W8AFy0qFyYyryvyFWv
	gFn5KFn0yF1jywUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jxrcfUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QFH12pdlMG50AAA3z

IO_URING_F_NONBLOCK only needs BLK_MQ_REQ_NOWAIT for request
allocation. Mapping the user buffer may sleep, so use GFP_KERNEL
instead of GFP_NOWAIT.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/scsi_bsg.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index c57ce01379de..f90d19fdbd8e 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -76,9 +76,8 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct request *req,
 
 static int scsi_bsg_map_user_buffer(struct request *req,
 				    struct io_uring_cmd *ioucmd,
-				    unsigned int issue_flags, gfp_t gfp_mask,
-				    bool is_write, u64 buf_addr,
-				    unsigned long buf_len)
+				    unsigned int issue_flags, bool is_write,
+				    u64 buf_addr, unsigned long buf_len)
 {
 	struct iov_iter iter;
 	int ret;
@@ -89,10 +88,10 @@ static int scsi_bsg_map_user_buffer(struct request *req,
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
@@ -107,7 +106,6 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 	struct scsi_cmnd *scmd;
 	struct request *req;
 	blk_mq_req_flags_t blk_flags = 0;
-	gfp_t gfp_mask = GFP_KERNEL;
 	/* Snapshot SQE fields used for validation and buffer mapping. */
 	u64 request = READ_ONCE(cmd->request);
 	u32 request_len = READ_ONCE(cmd->request_len);
@@ -132,10 +130,8 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 	if (cmd->dout_iovec_count > 0 || cmd->din_iovec_count > 0)
 		return -EOPNOTSUPP;
 
-	if (issue_flags & IO_URING_F_NONBLOCK) {
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		blk_flags = BLK_MQ_REQ_NOWAIT;
-		gfp_mask = GFP_NOWAIT;
-	}
 
 	req = scsi_alloc_request(q, dout_xfer_len ?
 				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN, blk_flags);
@@ -170,8 +166,7 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
 		unsigned long buf_len = is_write ? dout_xfer_len : din_xfer_len;
 
 		ret = scsi_bsg_map_user_buffer(req, ioucmd, issue_flags,
-					       gfp_mask, is_write, buf_addr,
-					       buf_len);
+					       is_write, buf_addr, buf_len);
 		if (ret)
 			goto out_free_req;
 		pdu->bio = req->bio;
-- 
2.25.1

