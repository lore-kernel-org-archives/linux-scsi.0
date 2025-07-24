Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B8921858A;
	Thu, 24 Jul 2025 21:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394283; cv=none; b=teLMzjowUxJ5wZ0GH3YqGnVFVvmeT2Dr6BYValqqXDe/8oV0K0rdJZj4fDIWjYgkd7Al32RFeYWU3bCzQMzayngf9yy3GAiBNEcvwnJZGDCXpe4CI2iBysyuzlv3ln3fAjZaVyjB5D77fd4sjBA+xZn0lleSKS56JDMel6ZqJlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394283; c=relaxed/simple;
	bh=r+uBhwDSoFGC+OFlsa1CBquF6c8RTwMje8AhOFICkic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWoIGacWv9ufLGHi0OMvSsb9+5k92iFdolcqzwFtxD3sD1vhnN6Emid1h2CXIu8LzIGGxl6lw/3V+TeSFqyrPTOpR7u6x8kvteMSXN6KH1rayQnPGA7LGv/hX7Efee1P8ZAEhb7qJmIiG9ICc4uOB2Hm03aHpMYhM+nnLPw9eMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=379Jcu6k; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="379Jcu6k"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bp4cm5ZzczlgqVB;
	Thu, 24 Jul 2025 21:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1753394279; x=1755986280; bh=KpKza
	GTbYOjqcKkWaKN+OhUtdr4kWAFVNyCF8EgZ778=; b=379Jcu6krpDfj2foxKyKl
	bhy+yRbV40SMcZebof19Ksk1LlaM6wZv4H0WxX6TijkFcovH/rh3t9S0quLqtByM
	aCvP7ukH0L1CYRvjNNQG17TolPpxXYrR8kQEiCwS2G67AtD5bvGi0pxdQdmdZKGr
	GGUltrALEOEnwgW4+7p1ONnph7jmYY/YjogRjjtu7UwAqPYF9LUOQ7SXdEGXlWYn
	vleUlxRpgJUn8bgcWmI+uE0Mh1x4ItbhY3eUonD1SZb1m4qfAsWT3+uWUphDWu3B
	Xk8Vzs3J4H7viOHvrRsfU28NNAWlJPMdVPFTyoq2ECJSlqvXqjyEDj+wKUOKGAqB
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pkslkPkwwQi9; Thu, 24 Jul 2025 21:57:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bp4cg15YFzlgqTv;
	Thu, 24 Jul 2025 21:57:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v22 02/14] blk-mq: Always insert sequential zoned writes into a software queue
Date: Thu, 24 Jul 2025 14:56:51 -0700
Message-ID: <20250724215703.2910510-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
In-Reply-To: <20250724215703.2910510-1-bvanassche@acm.org>
References: <20250724215703.2910510-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

One of the optimizations in the block layer is that the software queues
are bypassed if it is expected that the block driver will accept a
request. This can cause request reordering even for requests submitted
from the same CPU core.  This patch preserves the order for sequential
zoned writes submitted from a given CPU core by always inserting these
requests into the appropriate software queue.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c         | 27 +++++++++++++++++++++++++--
 include/linux/blk-mq.h | 11 +++++++++++
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b1d81839679f..445f2275eddb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1537,6 +1537,27 @@ void blk_mq_requeue_request(struct request *rq, bo=
ol kick_requeue_list)
 }
 EXPORT_SYMBOL(blk_mq_requeue_request);
=20
+/*
+ * Whether the block layer should preserve the order of @rq relative to =
other
+ * requests submitted to the same software queue.
+ */
+static bool blk_mq_preserve_order(struct request *rq)
+{
+	return rq->q->limits.features & BLK_FEAT_ORDERED_HWQ &&
+	       blk_rq_is_seq_zoned_write(rq);
+}
+
+static bool blk_mq_preserve_order_for_list(struct list_head *list)
+{
+	struct request *rq;
+
+	list_for_each_entry(rq, list, queuelist)
+		if (blk_mq_preserve_order(rq))
+			return true;
+
+	return false;
+}
+
 static void blk_mq_requeue_work(struct work_struct *work)
 {
 	struct request_queue *q =3D
@@ -2566,7 +2587,8 @@ static void blk_mq_insert_requests(struct blk_mq_hw=
_ctx *hctx,
 	 * Try to issue requests directly if the hw queue isn't busy to save an
 	 * extra enqueue & dequeue to the sw queue.
 	 */
-	if (!hctx->dispatch_busy && !run_queue_async) {
+	if (!hctx->dispatch_busy && !run_queue_async &&
+	    !blk_mq_preserve_order_for_list(list)) {
 		blk_mq_run_dispatch_ops(hctx->queue,
 			blk_mq_try_issue_list_directly(hctx, list));
 		if (list_empty(list))
@@ -3215,7 +3237,8 @@ void blk_mq_submit_bio(struct bio *bio)
=20
 	hctx =3D rq->mq_hctx;
 	if ((rq->rq_flags & RQF_USE_SCHED) ||
-	    (hctx->dispatch_busy && (q->nr_hw_queues =3D=3D 1 || !is_sync))) {
+	    (hctx->dispatch_busy && (q->nr_hw_queues =3D=3D 1 || !is_sync)) ||
+	    blk_mq_preserve_order(rq)) {
 		blk_mq_insert_request(rq, 0);
 		blk_mq_run_hw_queue(hctx, true);
 	} else {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2a5a828f19a0..30d7cd1b0484 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1191,4 +1191,15 @@ static inline int blk_rq_map_sg(struct request *rq=
, struct scatterlist *sglist)
 }
 void blk_dump_rq_flags(struct request *, char *);
=20
+static inline bool blk_rq_is_seq_zoned_write(struct request *rq)
+{
+	switch (req_op(rq)) {
+	case REQ_OP_WRITE:
+	case REQ_OP_WRITE_ZEROES:
+		return bdev_zone_is_seq(rq->q->disk->part0, blk_rq_pos(rq));
+	default:
+		return false;
+	}
+}
+
 #endif /* BLK_MQ_H */
