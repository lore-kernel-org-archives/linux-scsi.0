Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C80A38C40B;
	Mon, 27 Jul 2026 01:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785116574; cv=none; b=s2hgeAnOSKM12g27kpOj5/QJVZfLxP3fmrjBGXNCQkFrXlKYhexzr+6fqbbrN/RyEskHE95rwXSf8Cun5+JJgr42vVMLmu8uKpQc77Eph13nMXDdbiU1nfLVnnNpLUPXd9ohmJWmNX8fpkd/ldTCWx6r8Am32ruYDQBCD6o2ycE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785116574; c=relaxed/simple;
	bh=xDxV8HvPbYiIxxD+F+3i0ieVYyg0iLE6P9eRQYfZ4Ds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oupnKJsH5RVTpXs6dA8j0bihqb0DcrRTz0/8lu9kmXKW7JpgWLPkT0NT5bpGv6TYrM/YTKko+1nnL+aww6my3X86W0Gxe1J6IxxrvmEdsu6ESMa5o5iaMksp/yKWmxKKt/SVJ8pei91m5fBb9n+2uKNDdxqPml8V8J6NsHEn/Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=b/qbl3QA; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="b/qbl3QA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Iy
	62jJnJvanNlfSuETRwbdXEYtC+67zl/MGdwf1PbH4=; b=b/qbl3QACb2eyxjj9+
	WwFmu7FABbnv27+kcUIEKRPJaeImy/cSYnma5acqIb/0Ma3XVhyHJp/SkAUYEdRX
	gwQrKvTo0AteKqXBjoz0N6sWbn32y01/J+0zXHADJpl4wQMgbypVl6gZoKDIOFFG
	fKFGEHfWKILrfZrgv4WHqAWUE=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDXnw0_t2Zq_LNqJw--.32185S4;
	Mon, 27 Jul 2026 09:41:24 +0800 (CST)
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
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v2 2/2] scsi: bsg: map io_uring user buffers with GFP_KERNEL
Date: Mon, 27 Jul 2026 09:41:17 +0800
Message-Id: <20260727014117.1742202-3-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:PigvCgDXnw0_t2Zq_LNqJw--.32185S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF17JryDXw4fCrWfGr4Durg_yoW5JFWrpF
	W5t3ySvFW3XF48urWkJ39xZFWFya1kC34xKFW3u3yYyryDAr909F18ZFy8tFyFyryvya1v
	grn5KF1qy3WUt3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j2pB-UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6QQzw2pmt0SUQAAA32

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

