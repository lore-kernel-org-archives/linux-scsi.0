Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC5D207A22;
	Fri,  7 Nov 2025 23:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559620; cv=none; b=FVpIRzYljQCtxwHqcq62aT4Y+vUK+kJBKbdtjjNfjkwDYp9hlApX2YdDMTy80QjCxmQ5/e3JDSbGsRaxTGJvo+LhSKab5keeG87iXkxmS+3sl8UBDg8LleIAKJyfEx+Odh3agPahfa9kMt1M3h7LaKrNQDz44x+LB+/9z5j/BYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559620; c=relaxed/simple;
	bh=kf42jntS3rKIAr0vOP0wvpzcz53xErEdtT8S2LbWfpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+YL2Pw2OgKB28hq8gtMe2exHui5eJSojK9PqMfA8WsMx3sE45figKCPa4HbNyEeEzNqhI9HFcge6T9wU37An7JvWMXATW5pnelpvz11NWY7LCAaisNbsVFgk6UNzf6AvHpjgJ3Fz55FvMfmtTV4OfFkuVOwzObTfflQ1JgY00Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Mz/ngTui; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Mz/ngTui"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d3G9F6vJKzm17wr;
	Fri,  7 Nov 2025 23:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1762559616; x=1765151617; bh=c2ptj
	/rcQh8lrqJUMj0i8dSC+qLrGT/76q2E/piHoJk=; b=Mz/ngTuie1gjZ5mPJHxr8
	CYmXLPQtbJFglEwhC/BFZmt/zKvXe8ttq8trqWSrFapz+/CLzYfoVmaYZI20OWVA
	2i+cTA0DICiAKGEossd1ccuAIvHXLkT6CUakTq+agjDkdTTueLIYlXlEGvZ0mcxm
	TkyFyFzvWbSoz3eJdD4EN/gfHJl6QyLUMZBFOzPf5zfujIg/r8ewNsibZmiDHEaj
	sfs4EJ5NxDTqRXv5pGJabJyC5XGEJxmSm4zcpZcJe/Vn1t+WzQtKh2L8GGoEyfT/
	kMhG1GP63dVu3scQOg0GCL4HjneJ3BY0gyyniKCkm1dXhkmce++OagpyAwVgT6Os
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JzexTQGVx7Af; Fri,  7 Nov 2025 23:53:36 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d3G984vvxzm17wZ;
	Fri,  7 Nov 2025 23:53:31 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v26 02/17] blk-mq: Always insert sequential zoned writes into a software queue
Date: Fri,  7 Nov 2025 15:52:55 -0800
Message-ID: <20251107235310.2098676-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107235310.2098676-1-bvanassche@acm.org>
References: <20251107235310.2098676-1-bvanassche@acm.org>
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
 block/blk-mq.c         | 35 +++++++++++++++++++++++++++++++++--
 include/linux/blk-mq.h | 11 +++++++++++
 include/linux/blkdev.h | 17 +++++++++++++++++
 3 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b2fdeaac0efb..e7958cfddfbf 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1549,6 +1549,35 @@ void blk_mq_requeue_request(struct request *rq, bo=
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
+	return blk_pipeline_zwr(rq->q) && blk_rq_is_seq_zoned_write(rq);
+}
+
+/*
+ * Whether the order should be preserved for any request in @list. Retur=
ns %true
+ * if and only if zoned write pipelining is enabled and if there are any
+ * sequential zoned writes in @list.
+ */
+static bool blk_mq_preserve_order_for_list(struct request_queue *q,
+					   struct list_head *list)
+{
+	struct request *rq;
+
+	if (!blk_pipeline_zwr(q))
+		return false;
+
+	list_for_each_entry(rq, list, queuelist)
+		if (blk_rq_is_seq_zoned_write(rq))
+			return true;
+
+	return false;
+}
+
 static void blk_mq_requeue_work(struct work_struct *work)
 {
 	struct request_queue *q =3D
@@ -2578,7 +2607,8 @@ static void blk_mq_insert_requests(struct blk_mq_hw=
_ctx *hctx,
 	 * Try to issue requests directly if the hw queue isn't busy to save an
 	 * extra enqueue & dequeue to the sw queue.
 	 */
-	if (!hctx->dispatch_busy && !run_queue_async) {
+	if (!hctx->dispatch_busy && !run_queue_async &&
+	    !blk_mq_preserve_order_for_list(hctx->queue, list)) {
 		blk_mq_run_dispatch_ops(hctx->queue,
 			blk_mq_try_issue_list_directly(hctx, list));
 		if (list_empty(list))
@@ -3230,7 +3260,8 @@ void blk_mq_submit_bio(struct bio *bio)
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
index b54506b3b76d..b88b870aaf8f 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1211,4 +1211,15 @@ static inline int blk_rq_map_sg(struct request *rq=
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
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b97132252ec2..f18523e841a4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -865,6 +865,18 @@ static inline unsigned int disk_nr_zones(struct gend=
isk *disk)
 	return disk->nr_zones;
 }
=20
+/*
+ * blk_pipeline_zwr() - Whether or not sequential zoned writes will be
+ *	pipelined per zone.
+ * @q: request queue pointer.
+ *
+ * Return: %true if and only if zoned writes will be pipelined per zone.
+ */
+static inline bool blk_pipeline_zwr(struct request_queue *q)
+{
+	return q->limits.features & BLK_FEAT_ORDERED_HWQ;
+}
+
 /**
  * bio_needs_zone_write_plugging - Check if a BIO needs to be handled wi=
th zone
  *				   write plugging
@@ -951,6 +963,11 @@ static inline bool bdev_zone_is_seq(struct block_dev=
ice *bdev, sector_t sector)
 	return false;
 }
=20
+static inline bool blk_pipeline_zwr(struct request_queue *q)
+{
+	return false;
+}
+
 static inline bool bio_needs_zone_write_plugging(struct bio *bio)
 {
 	return false;
