Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595E51FAC34;
	Mon, 11 Aug 2025 20:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754942988; cv=none; b=DqD41M9NsJEXImD5WkEzHkzFLPhUBbh0rvLEmAezFt3OX5OGQY2QiwXLAhz1QLiJJXqLTaf5h6BLGx7IFX3+XFtwchGziR1qWreXbYPow8A0jdxgmpx2bB/VO3rENzlH6GQ73Dr5SwC25XBET10KM/SUG35bdLwWYq2Myim5Uxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754942988; c=relaxed/simple;
	bh=zhJmGgHWjgfjlUdY7zH2qyGrXZH210vfslGw0mQ6AFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlvOYGR4HI+cmSg6E/FE0Rw24rDiS64ZinaFUPn4DtYg7ViqMWWDbZQEAw8voBWKYJwzZNqWffCYJS/BRW7uiie6T7Y8UaOobjD5+4FGQOWWjmuJ+O4o2xbwemW33Lf5Sl4tPcVvVj6tj+fyajRlfGeiRWcIhUW9ihFysDqt81w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kg3n23hC; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kg3n23hC"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c15MY4THLzm0ySq;
	Mon, 11 Aug 2025 20:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754942984; x=1757534985; bh=/f/gg
	6t1k8RZkpnufU4zz+i3NVYZ+L1lZ2vkd5vA6lc=; b=kg3n23hCkKOfczllwGAsg
	fiJtctqr2Pjv/ibtw705N1fieQILxEpP0X7F7F+g5ngrvZ+gZJRdXNG0IMZxNOJ4
	iCmpLBeY5wBhN0L+RcgKtXaLmh7MYGnExrg8R+JH/Mqghm9mDyKeg6axrzNoHfvj
	7OEvZkFiposDA+ueU40k+Gtvxx3A4ZSYQeqlezWOVZKyXGoy5OT57lSA/vt4CpPE
	simReka1H39ZDj3YLugio8awP71JxCHaIZ9mNnCMxugxHueF0vb/OxbwVIqX8EpQ
	gvF1RT8W4xTBBIjnPqMdB1cR26s6nqedGaU3mCdlWnxCkQf/aiqrmrwgVWWsuLaj
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id K6FpOxqnCqvS; Mon, 11 Aug 2025 20:09:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c15MS20wczm0yQD;
	Mon, 11 Aug 2025 20:09:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v23 02/16] blk-mq: Always insert sequential zoned writes into a software queue
Date: Mon, 11 Aug 2025 13:08:37 -0700
Message-ID: <20250811200851.626402-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811200851.626402-1-bvanassche@acm.org>
References: <20250811200851.626402-1-bvanassche@acm.org>
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
 block/blk-mq.c         | 26 ++++++++++++++++++++++++--
 block/blk-zoned.c      | 17 +++++++++++++++++
 block/elevator.h       |  1 +
 include/linux/blk-mq.h | 11 +++++++++++
 include/linux/blkdev.h |  7 +++++++
 5 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b67d6c02eceb..ab004837f4bb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1537,6 +1537,26 @@ void blk_mq_requeue_request(struct request *rq, bo=
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
@@ -2566,7 +2586,8 @@ static void blk_mq_insert_requests(struct blk_mq_hw=
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
@@ -3215,7 +3236,8 @@ void blk_mq_submit_bio(struct bio *bio)
=20
 	hctx =3D rq->mq_hctx;
 	if ((rq->rq_flags & RQF_USE_SCHED) ||
-	    (hctx->dispatch_busy && (q->nr_hw_queues =3D=3D 1 || !is_sync))) {
+	    (hctx->dispatch_busy && (q->nr_hw_queues =3D=3D 1 || !is_sync)) ||
+	    blk_mq_preserve_order(rq)) {
 		blk_mq_insert_request(rq, 0);
 		blk_mq_run_hw_queue(hctx, true);
 	} else {
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index ef43aaca49f4..b1bf240697ef 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -22,6 +22,7 @@
 #include "blk.h"
 #include "blk-mq-sched.h"
 #include "blk-mq-debugfs.h"
+#include "elevator.h"
=20
 #define ZONE_COND_NAME(name) [BLK_ZONE_COND_##name] =3D #name
 static const char *const zone_cond_name[] =3D {
@@ -377,6 +378,22 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev=
, blk_mode_t mode,
 	return ret;
 }
=20
+/*
+ * blk_pipeline_zwr() - Whether or not sequential zoned writes will be
+ *	pipelined per zone.
+ * @q: request queue pointer.
+ *
+ * Return: %true if and only if zoned writes will be pipelined per zone.
+ */
+bool blk_pipeline_zwr(struct request_queue *q)
+{
+	return q->limits.features & BLK_FEAT_PIPELINE_ZWR &&
+		(!q->elevator ||
+		test_bit(ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING,
+			 &q->elevator->flags));
+}
+EXPORT_SYMBOL(blk_pipeline_zwr);
+
 static bool disk_zone_is_last(struct gendisk *disk, struct blk_zone *zon=
e)
 {
 	return zone->start + zone->len >=3D get_capacity(disk);
diff --git a/block/elevator.h b/block/elevator.h
index adc5c157e17e..51311027fdb7 100644
--- a/block/elevator.h
+++ b/block/elevator.h
@@ -133,6 +133,7 @@ struct elevator_queue
 #define ELEVATOR_FLAG_REGISTERED	0
 #define ELEVATOR_FLAG_DYING		1
 #define ELEVATOR_FLAG_ENABLE_WBT_ON_EXIT	2
+#define ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING 3
=20
 /*
  * block elevator interface
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
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 79d14b3d3309..4388bbfe824f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -856,6 +856,8 @@ static inline unsigned int disk_nr_zones(struct gendi=
sk *disk)
 	return disk->nr_zones;
 }
=20
+bool blk_pipeline_zwr(struct request_queue *q);
+
 /**
  * bio_needs_zone_write_plugging - Check if a BIO needs to be handled wi=
th zone
  *				   write plugging
@@ -934,6 +936,11 @@ static inline unsigned int disk_nr_zones(struct gend=
isk *disk)
 	return 0;
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
