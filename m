Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837E52DA776;
	Tue, 14 Oct 2025 21:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478908; cv=none; b=ewE0FDMizpr//s+ern+Liy1htrcCgc1WIVVIG71077U41+1AtNoFGwbWA6FXO6FRv7xqOUId6pzVhUPVuRBfK3kBW00xiTjKT9xS9pZFcw+U1RtmMvu9apb+Rx9aV2vQoXWoQKo8tAiw+exBwKU32dO8+T3Mhbr+89jTUAsZiOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478908; c=relaxed/simple;
	bh=6ej6RxZdkeAUUjaEGwN/P3uQcXvNczDDZ7alvIbJkkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjhvTZHWIa+4Zr3XTZog9Pj3V1IsN9Sfy+JHtgmvnd6va3Fp0cOkyhaZH39uiEdM/rQ9pkyo4P6o5fks8dFanDMNtV10FcjK2GP3pTgRlrLrMP02SDziznaxqzJo2hAkTiOv/eFjFbJTm6+cAFt/1uc8tKyYOD1UVPK9+f/xoNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pR7X0h63; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pR7X0h63"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmSgY6DFnzm0yV3;
	Tue, 14 Oct 2025 21:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478904; x=1763070905; bh=XHxGX
	FKkDmO3buBhL2Vzn6wIHb9ktpmFx4FqMaoFOoE=; b=pR7X0h63IVOeUU1vvDeWM
	3WoQr9NvPQYE95PXOkJnTzI/uWCP/Lqov+tVzVLDfotlUrnAYWUN0BHIAdBg/hd9
	tUWvREN8v3CqkZ9Had1yoy8WcWhXOVLZXys+7LMYUp2Tk7ZEPBrmYw+OYnUMZ3Cj
	Nd7KZALDw7J0OqIUlLtjFK1z6Zv6R4hZoveG00Y3k+F7CwNBEdP2OsiVO0tfaGxZ
	2TlTowkHMbUc+jdMracEsbpyKIg473hULjSMkzqDjlTpu/BnTxRArzYN2VTXef6M
	pyTC+Je6b4pRJeL4LHEizl81lBNnoyCgIyIy3xtvAO3V15FQ40yswMJ3OGo5UZ/i
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZKsLjDVljtyv; Tue, 14 Oct 2025 21:55:04 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmSgS2qHZzm0yVS;
	Tue, 14 Oct 2025 21:54:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 02/20] blk-mq: Always insert sequential zoned writes into a software queue
Date: Tue, 14 Oct 2025 14:54:10 -0700
Message-ID: <20251014215428.3686084-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014215428.3686084-1-bvanassche@acm.org>
References: <20251014215428.3686084-1-bvanassche@acm.org>
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
 block/blk-zoned.c      | 21 +++++++++++++++++++++
 block/elevator.h       |  1 +
 include/linux/blk-mq.h | 11 +++++++++++
 include/linux/blkdev.h |  7 +++++++
 5 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 09f579414161..0457aa6eef47 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1546,6 +1546,35 @@ void blk_mq_requeue_request(struct request *rq, bo=
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
@@ -2575,7 +2604,8 @@ static void blk_mq_insert_requests(struct blk_mq_hw=
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
@@ -3225,7 +3255,8 @@ void blk_mq_submit_bio(struct bio *bio)
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
index 5e2a5788dc3b..f6bb4331eea6 100644
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
@@ -377,6 +378,26 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev=
, blk_mode_t mode,
 	return ret;
 }
=20
+/*
+ * blk_pipeline_zwr() - Whether or not sequential zoned writes will be
+ *	pipelined per zone.
+ * @q: request queue pointer.
+ *
+ * Return: %true if and only if zoned writes will be pipelined per zone.=
 Since
+ * running different hardware queues simultaneously on different CPU cor=
es may
+ * lead to I/O reordering if an I/O scheduler maintains a single dispatc=
h queue,
+ * only enable write pipelining if an I/O scheduler is active if the
+ * ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING flag has been set.
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
index c4d20155065e..41f28909a31c 100644
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
index b25d12545f46..2c08a86b4ac3 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1195,4 +1195,15 @@ static inline int blk_rq_map_sg(struct request *rq=
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
index 9af9d97e31af..85fca05bd5eb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -855,6 +855,8 @@ static inline unsigned int disk_nr_zones(struct gendi=
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
@@ -933,6 +935,11 @@ static inline unsigned int disk_nr_zones(struct gend=
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
