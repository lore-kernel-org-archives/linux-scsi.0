Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E0415B569;
	Wed, 29 May 2024 05:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716959122; cv=none; b=b9MPHFgTCdJtE9HM59qTQITEL9jGn+op2QiEx44HBuwu24zkwT/woE9O17Dkur4BdmHX6aemZNRDabHd5BhojbufJJIM7ZYZDg7gbGiUh13jtW077IdboDh6Y3JKKJXiu9VoBZrWn0ge8Zf6miI+OYjpkBD9oTOhufJf1/FKpX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716959122; c=relaxed/simple;
	bh=BKqjRgAUBDAEkcY3F8nYF+/jiJdinAAzSez7/+1I6I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THXPqd3VQqmlNqvRF4SeGoCbSj28wzFXOLLBrUOtAjw81oYNKliUs+qCyE8pgVuZBhvdK7kww7gT8gt25IQL0g/Q5XxzFaFEQkcEvYItlaJzLGEcTA/vrOHtVju407da+MgQT1huYzFky4ZDv8LQZZGI9ZzGtchaWraVkP4hBWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OeadjJJG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OeadjJJG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/OLpY6jO6BGmZUZluvnHNfe+GDP4sT7VwC1y29SpC6U=; b=OeadjJJGioCa4ge9VNZLLPIeJ8
	O9S5rUx9FafsfCUd/nVJdDPOpkJsv/E9yKCxbOOv290nnhE62p3wpyYQNPmrOmNyU3hzVOzhGPQxa
	5a4T1lTIFSW+n3MtalzxAOCYtI3DQHhzspZ8bYnEdLFBuQ+bNkNK5b871ug/c8Zf1MXixhuq1fwcL
	BxKay23FFqMmNqBL5VSxy6HUEZFvyI7zrsX4GqEOmWHd2HuIc7ZktQuuiNYT9hnqC19jbRgfOjXtD
	KR9+Ssjbvj0F4kFxGdIepfLmbgfwNS35I/CDczeE6V2t2s7vUtO9/Gkm7F3aD4SXdu4zuGlpm8kbx
	t86dAPmA==;
Received: from 2a02-8389-2341-5b80-7775-b725-99f7-3344.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:7775:b725:99f7:3344] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCBUv-00000002pSP-1Lzk;
	Wed, 29 May 2024 05:05:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	linux-um@lists.infradead.org,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 01/12] ubd: untagle discard vs write zeroes not support handling
Date: Wed, 29 May 2024 07:04:03 +0200
Message-ID: <20240529050507.1392041-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240529050507.1392041-1-hch@lst.de>
References: <20240529050507.1392041-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Discard and Write Zeroes are different operation and implemented
by different fallocate opcodes for ubd.  If one fails the other one
can work and vice versa.

Split the code to disable the operations in ubd_handler to only
disable the operation that actually failed.

Fixes: 50109b5a03b4 ("um: Add support for DISCARD in the UBD Driver")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/um/drivers/ubd_kern.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index ef805eaa9e013d..a79a3b7c33a647 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -471,9 +471,14 @@ static void ubd_handler(void)
 		for (count = 0; count < n/sizeof(struct io_thread_req *); count++) {
 			struct io_thread_req *io_req = (*irq_req_buffer)[count];
 
-			if ((io_req->error == BLK_STS_NOTSUPP) && (req_op(io_req->req) == REQ_OP_DISCARD)) {
-				blk_queue_max_discard_sectors(io_req->req->q, 0);
-				blk_queue_max_write_zeroes_sectors(io_req->req->q, 0);
+			if (io_req->error == BLK_STS_NOTSUPP) {
+				struct request_queue *q = io_req->req->q;
+
+				if (req_op(io_req->req) == REQ_OP_DISCARD)
+					blk_queue_max_discard_sectors(q, 0);
+				if (req_op(io_req->req) == REQ_OP_WRITE_ZEROES)
+					blk_queue_max_write_zeroes_sectors(q,
+							0);
 			}
 			blk_mq_end_request(io_req->req, io_req->error);
 			kfree(io_req);
-- 
2.43.0

