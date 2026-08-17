Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37764B04B0;
	Mon, 17 Aug 2026 01:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786930857; cv=none; b=sRgJUn/xYSGR78GxTiLXnPUiPq/yUltpjvorxxETPv9dpDLxfH/2a93PY/2b9uHR876WyTkA0P+wptjM2RqFP0OaGbfDXaUOULOZaEVQu099+1vbkJ5N+1ngnKdFib4/MqI1jojS/N8MgmYkaaOzncNnOPuJgvpGx8cOtLKRGXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786930857; c=relaxed/simple;
	bh=xDxV8HvPbYiIxxD+F+3i0ieVYyg0iLE6P9eRQYfZ4Ds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EX8Wtp4B1sXT6MYYByuSmutH+ldAFhOoEZIEfaqiFStoUMvMXmLifDTfG5LT4E1a2lHRFVZPvHW4CPXwbFq+pWdCl4dfT7ml6R9wX8JIg+PuSqCuM5DmkAxDFIHdgi4pz3bB6L1JIv1Dm0AGwKGf/huk4gkYiyMExN5DeR6wlts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=cGVN6k4S; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="cGVN6k4S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Iy
	62jJnJvanNlfSuETRwbdXEYtC+67zl/MGdwf1PbH4=; b=cGVN6k4S6rj9a7YnV9
	K4ICh6vZ6yipZImRw0W+U6cLs465ncC9ix4RMABPUYuf4KDMdCdj7lSLs1UM4eFr
	n4mQdJuCVj4VaoIyQllm4eaJhiD4unDuDDPAb7kcTlpqseXJB2fZUscZ57gk3WGA
	YELs8vtRR8ZU2qEJTdYyT4Si8=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDH5w5yZoJqQVejLg--.13488S4;
	Mon, 17 Aug 2026 09:40:07 +0800 (CST)
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
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v3 2/2] scsi: bsg: map io_uring user buffers with GFP_KERNEL
Date: Mon, 17 Aug 2026 09:39:59 +0800
Message-Id: <20260817013959.165425-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817013959.165425-1-yangxiuwei@kylinos.cn>
References: <20260817013959.165425-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDH5w5yZoJqQVejLg--.13488S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF17JryDXw4fCrWfGr4Durg_yoW5JFWrpF
	W5t3ySvFW3XF48urWkJ39xZFWFya1kC34xKFW3u3yYyryDAr909F18ZFy8tFyFyryvya1v
	grn5KF1qy3WUt3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j2pB-UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6RfxgmqCZncL4gAA3d

IO_URING_F_NONBLOCK only needs BLK_MQ_REQ_NOWAIT for request
allocation. Mapping the user buffer may sleep, so use GFP_KERNEL
instead of GFP_NOWAIT.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/scsi_bsg.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 7758c5f22a7e..ddb33ae68483 100644
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
 	u64 request = READ_ONCE(cmd->request);
 	u32 request_len = READ_ONCE(cmd->request_len);
 	u64 dout_xferp = READ_ONCE(cmd->dout_xferp);
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

