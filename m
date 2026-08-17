Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EFA3BCD2E;
	Mon, 17 Aug 2026 08:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786954134; cv=none; b=G+/BGcsJx+D4J8O28u7Hl1JQsB00xKBICNthXm/TXMCTVfeSsaOwBWIewyI0gsaj3p2tZrs5iBvnl2K7zAexKxyFEVpy/tDA1bDnLkiysyaQU3/j3nSy03/imxbUajk+mpk/LXLV8+44UrkH9nHWDZwob2ctzntFOgoYkjCACbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786954134; c=relaxed/simple;
	bh=ypRqXIafqmlLVDAELOdExtIPwNUfgwV7LX/Ct93od6k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fAFVYXdBqMmVOhyWHx4fjSu+doc3m+Hgm5+DsPXHhV0riWExqXOSFRCFuYG2NY2ZaCLucdsC14Z8TlDNVfasQFiIbjii8xv6KvgPsaE8NtLQP2MMk77dQsdaQMyDiNB9mBA/oQnrZHEQ+n04ZBpYGtyJfksKGozGPy0u7e/UcP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=R21QcNsy; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="R21QcNsy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ik
	CSBwsPoi7gT87NQayaNTfXrH0ZudxuNCPkNxKEeiI=; b=R21QcNsyhGjIgZB4Eb
	/kbO+CoqXMUgnJMsbuWsC6kX6i+vjZc/dyRK7NMPItISrJSl+M1xP8jSFTUxsfQI
	uT10HSbIy9KHO+aNrz8OhD1sQOZlBTukqirJOyRoB+0v8ncPS4xtKPy4GMBjmp6m
	Ez/SKFTV98M7MgBTm6uVosqzg=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wBnnvpFwYJqCVRqOA--.71S5;
	Mon, 17 Aug 2026 16:07:41 +0800 (CST)
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
Subject: [PATCH v4 3/3] scsi: bsg: map io_uring user buffers with GFP_KERNEL
Date: Mon, 17 Aug 2026 16:07:30 +0800
Message-Id: <20260817080730.967879-4-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:_____wBnnvpFwYJqCVRqOA--.71S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF17JrW7urWUuFyUCw4rKrg_yoW5JFWrpF
	W5t3ySvFW3Xr48urWkt398ZFWFyw4kC34xKFW3u3yYyryDArZ09F18ZFy8tFyFyryvyFWv
	grn5KFyqy3WUt3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jgPEfUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6g2+T2qCwU1PKgAA3X

IO_URING_F_NONBLOCK only needs BLK_MQ_REQ_NOWAIT for request
allocation. Mapping the user buffer may sleep, so use GFP_KERNEL
instead of GFP_NOWAIT.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/scsi_bsg.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 5eec248a77a6..d5c64e7a0df4 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -77,9 +77,8 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struct request *req,
 
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
@@ -90,10 +89,10 @@ static int scsi_bsg_map_user_buffer(struct request *req,
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
@@ -108,7 +107,6 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
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
@@ -169,8 +165,7 @@ static int scsi_bsg_uring_cmd(struct request_queue *q, struct io_uring_cmd *iouc
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

