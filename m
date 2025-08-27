Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7282D543E;
	Wed, 27 Aug 2025 21:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330220; cv=none; b=lTfmDPL3oOcHjksLry38wkeJMBvYXB5hXYecsnVu7UO2oj0M0Ut1fvp62ROgUqhnh3chQd2LCx+1sm9FTPWfQsE1Cw+CsbHVW/EQzGXJa2UoQPzSmwVvmoU7xvg+Kok5BAuBLbUVWXXSYX85CUhs86M9ilHGdnSxG28NIENwIn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330220; c=relaxed/simple;
	bh=m1brwcI+Mzxbkarll2Ls8adhVpmsQ9MX70kWbHdrWwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLimgPfRHMpYG1NXITolOhQFqNFA+0WTt+TYMjv7Iu9ZRVQWvhqmIEJRLJfh1ao450i8QlyIUb8Jc8q4AFVum3+wcspEpxvyi4conhiM5l2d+uOve4ncqF19plBpZCj3MtfJLSsf792EOsN6l3girhE/v8afMZg7tbmALwQB2pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0de7Jiw1; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0de7Jiw1"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByP56mkXzm174W;
	Wed, 27 Aug 2025 21:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330216; x=1758922217; bh=mrcmp
	jxOXhuQLumos9Sr/hdXyDBJNHQ1ajty86u13Tk=; b=0de7Jiw1r83P1aqC8qWpd
	Knb4fnZubrRtQkCssBfWVydhWbhdU+VLn8nyt59zPR7iHlhdkigUg+nVXVf3a3B1
	yADEwURraetDgcCwD3yYc1BAsAJYR0UZoNz1QUQ6E9Kk+MpGREiKCWZT/wYNBuve
	GtZmpyXw2OaoqTOV7MX3Jj/Eg3Ur04hH3s5unAdp3HV8nDYtT7pppQbtetcj/LhB
	JVfpUXby0aXBNQ5aGJd11KkZ/pdjfHu0gyxWdbLwPSRUQ7a2bxyUNP0Gc6LgPRls
	t8IJLWi9J6IsulE1kpWrpWgy1OsIpEK4j/d69rpEnJLg3LRll6v9rHz2pciC6oqr
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VLh5XTMqn0rf; Wed, 27 Aug 2025 21:30:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByNz0wDDzm174M;
	Wed, 27 Aug 2025 21:30:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v24 02/18] blk-mq: Always insert sequential zoned writes into a software queue
Date: Wed, 27 Aug 2025 14:29:21 -0700
Message-ID: <20250827212937.2759348-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
In-Reply-To: <20250827212937.2759348-1-bvanassche@acm.org>
References: <20250827212937.2759348-1-bvanassche@acm.org>
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
 block/blk-mq.c         | 30 ++++++++++++++++++++++++++++--
 block/blk-zoned.c      | 17 +++++++++++++++++
 block/elevator.h       |  1 +
 include/linux/blk-mq.h | 11 +++++++++++
 include/linux/blkdev.h |  7 +++++++
 5 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ba3a4b77f578..2af9c59ff2ad 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1537,6 +1537,30 @@ void blk_mq_requeue_request(struct request *rq, bo=
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
@@ -2566,7 +2590,8 @@ static void blk_mq_insert_requests(struct blk_mq_hw=
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
@@ -3215,7 +3240,8 @@ void blk_mq_submit_bio(struct bio *bio)
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
index 5e2a5788dc3b..1b5923c1a149 100644
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
+	return q->limits.features & BLK_FEAT_ORDERED_HWQ &&
+	       (!q->elevator ||
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
index 23bb2a407368..2c2579d4b7ed 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -854,6 +854,8 @@ static inline unsigned int disk_nr_zones(struct gendi=
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
@@ -932,6 +934,11 @@ static inline unsigned int disk_nr_zones(struct gend=
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
