Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4E930CDB2;
	Wed, 27 Aug 2025 21:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330238; cv=none; b=mWHw9MQLqKZVTB4EeJRDKbF5zR39XyM8vtlzFYvRefTqh7wwWhiocA8xkxKK8XktausdqKnVfzNKIaTRXyLe0VJO8moR1krf1X3lNto6SORgsXB4c4l3gkRWqNDBrjchQLW9ztUKX8Qr4LH1WcyYVACUki/fgs9XynreoPok6W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330238; c=relaxed/simple;
	bh=+kBiemRhSfRTzO+l+tDmsmab1TZZBZHeUyKvN87sB3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHSC0oOgvGlV+1aMXzyItBtQvKL6R0bZxrjuwA+gBLREJ1DjBV8bdy9CTO5dnWbnEt8L6T0Zy1eWPpPmioggvbLGOW/UFlSoz6MAXLaTIf6ss3MNoE9F1hjnmq3MSr0pdSe6SCEACKqPip3grB9zLHFaVT/s5qeJwlvHYwvsQz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rH4usMPn; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rH4usMPn"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByPS3G61zm174S;
	Wed, 27 Aug 2025 21:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330234; x=1758922235; bh=dgtQq
	plwbJiEfCTFp9vJWldTxwp1KQGEEjIGKDeJUiM=; b=rH4usMPnfBjgzjnPAE9KM
	C+jJ09+tNv7WQGiW3wixxU7lIEvay25DdQ/wDGd3/fwyNljvQlAGFti0fVFN2r6L
	CptCXkyhQ6QM9DbTBFt4f9tFulp6dOyDBac2Rku9TZ42Zj6hNvB+T5okzctShZ5O
	N/LIPH+jEeH316Mhecv+xxBLey5epsNbabd3h0e1gqenhiQ/giMiA903HEwQ/wfY
	azkg0/GaeW9BL3Z7KTtLRuC+mZV5i3UL5MePL/vB+QtWoOLal8+xAEzTPhcLnJD2
	rl0f02jogzZGH7vT6su1jg+TeRtNvkMh3p5p5WD7yr384GS2t4PXDIU6U5lR/bB/
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uYO6ZQsDBkLl; Wed, 27 Aug 2025 21:30:34 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByPM0wrZzm174W;
	Wed, 27 Aug 2025 21:30:30 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v24 06/18] block/mq-deadline: Enable zoned write pipelining
Date: Wed, 27 Aug 2025 14:29:25 -0700
Message-ID: <20250827212937.2759348-7-bvanassche@acm.org>
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

The hwq selected by blk_mq_run_hw_queues() for single-queue I/O scheduler=
s
depends on the CPU core that function has been called from. This may lead
to concurrent dispatching of I/O requests on different CPU cores and henc=
e
may cause I/O reordering. Prevent as follows that zoned writes are
reordered:
- Set the ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING flag. This disabl=
es
  the single hwq optimization in the block layer core.
- Modify dd_has_work() such that it only reports that any work is pending
  for zoned writes if the zoned writes have been submitted to the hwq tha=
t
  has been passed as argument to dd_has_work().
- Modify dd_dispatch_request() such that it only dispatches zoned writes
  if the hwq argument passed to this function matches the hwq of the
  pending zoned writes.

Because this patch introduces code that locks dd->lock from interrupt
context, make all dd->lock locking and unlocking calls IRQ-safe.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/mq-deadline.c | 100 ++++++++++++++++++++++++++++++++------------
 1 file changed, 74 insertions(+), 26 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 1226ad3876ab..a638d28ef8ab 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -310,11 +310,25 @@ static bool started_after(struct deadline_data *dd,=
 struct request *rq,
 	return time_after(start_time, latest_start);
 }
=20
+/*
+ * If write pipelining is enabled, only dispatch sequential zoned writes=
 if
+ * rq->mq_hctx =3D=3D hctx.
+ */
+static bool dd_dispatch_from_hctx(struct blk_mq_hw_ctx *hctx,
+				  struct request *rq)
+{
+	struct request_queue *q =3D hctx->queue;
+
+	return !(q->limits.features & BLK_FEAT_ORDERED_HWQ) ||
+		rq->mq_hctx =3D=3D hctx || !blk_rq_is_seq_zoned_write(rq);
+}
+
 /*
  * deadline_dispatch_requests selects the best request according to
  * read/write expire, fifo_batch, etc and with a start time <=3D @latest=
_start.
  */
 static struct request *__dd_dispatch_request(struct deadline_data *dd,
+					     struct blk_mq_hw_ctx *hctx,
 					     struct dd_per_prio *per_prio,
 					     unsigned long latest_start)
 {
@@ -339,7 +353,8 @@ static struct request *__dd_dispatch_request(struct d=
eadline_data *dd,
 	 * batches are currently reads XOR writes
 	 */
 	rq =3D deadline_next_request(dd, per_prio, dd->last_dir);
-	if (rq && dd->batching < dd->fifo_batch) {
+	if (rq && dd->batching < dd->fifo_batch &&
+	    dd_dispatch_from_hctx(hctx, rq)) {
 		/* we have a next request and are still entitled to batch */
 		data_dir =3D rq_data_dir(rq);
 		goto dispatch_request;
@@ -399,7 +414,7 @@ static struct request *__dd_dispatch_request(struct d=
eadline_data *dd,
 		rq =3D next_rq;
 	}
=20
-	if (!rq)
+	if (!rq || !dd_dispatch_from_hctx(hctx, rq))
 		return NULL;
=20
 	dd->last_dir =3D data_dir;
@@ -427,8 +442,9 @@ static struct request *__dd_dispatch_request(struct d=
eadline_data *dd,
  * Check whether there are any requests with priority other than DD_RT_P=
RIO
  * that were inserted more than prio_aging_expire jiffies ago.
  */
-static struct request *dd_dispatch_prio_aged_requests(struct deadline_da=
ta *dd,
-						      unsigned long now)
+static struct request *
+dd_dispatch_prio_aged_requests(struct deadline_data *dd,
+			       struct blk_mq_hw_ctx *hctx, unsigned long now)
 {
 	struct request *rq;
 	enum dd_prio prio;
@@ -442,7 +458,7 @@ static struct request *dd_dispatch_prio_aged_requests=
(struct deadline_data *dd,
 		return NULL;
=20
 	for (prio =3D DD_BE_PRIO; prio <=3D DD_PRIO_MAX; prio++) {
-		rq =3D __dd_dispatch_request(dd, &dd->per_prio[prio],
+		rq =3D __dd_dispatch_request(dd, hctx, &dd->per_prio[prio],
 					   now - dd->prio_aging_expire);
 		if (rq)
 			return rq;
@@ -466,8 +482,8 @@ static struct request *dd_dispatch_request(struct blk=
_mq_hw_ctx *hctx)
 	struct request *rq;
 	enum dd_prio prio;
=20
-	spin_lock(&dd->lock);
-	rq =3D dd_dispatch_prio_aged_requests(dd, now);
+	spin_lock_irq(&dd->lock);
+	rq =3D dd_dispatch_prio_aged_requests(dd, hctx, now);
 	if (rq)
 		goto unlock;
=20
@@ -476,13 +492,13 @@ static struct request *dd_dispatch_request(struct b=
lk_mq_hw_ctx *hctx)
 	 * requests if any higher priority requests are pending.
 	 */
 	for (prio =3D 0; prio <=3D DD_PRIO_MAX; prio++) {
-		rq =3D __dd_dispatch_request(dd, &dd->per_prio[prio], now);
+		rq =3D __dd_dispatch_request(dd, hctx, &dd->per_prio[prio], now);
 		if (rq || dd_queued(dd, prio))
 			break;
 	}
=20
 unlock:
-	spin_unlock(&dd->lock);
+	spin_unlock_irq(&dd->lock);
=20
 	return rq;
 }
@@ -538,9 +554,9 @@ static void dd_exit_sched(struct elevator_queue *e)
 		WARN_ON_ONCE(!list_empty(&per_prio->fifo_list[DD_READ]));
 		WARN_ON_ONCE(!list_empty(&per_prio->fifo_list[DD_WRITE]));
=20
-		spin_lock(&dd->lock);
+		spin_lock_irq(&dd->lock);
 		queued =3D dd_queued(dd, prio);
-		spin_unlock(&dd->lock);
+		spin_unlock_irq(&dd->lock);
=20
 		WARN_ONCE(queued !=3D 0,
 			  "statistics for priority %d: i %u m %u d %u c %u\n",
@@ -586,6 +602,8 @@ static int dd_init_sched(struct request_queue *q, str=
uct elevator_queue *eq)
 	/* We dispatch from request queue wide instead of hw queue */
 	blk_queue_flag_set(QUEUE_FLAG_SQ_SCHED, q);
=20
+	set_bit(ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING, &eq->flags);
+
 	q->elevator =3D eq;
 	return 0;
 }
@@ -633,9 +651,9 @@ static bool dd_bio_merge(struct request_queue *q, str=
uct bio *bio,
 	struct request *free =3D NULL;
 	bool ret;
=20
-	spin_lock(&dd->lock);
+	spin_lock_irq(&dd->lock);
 	ret =3D blk_mq_sched_try_merge(q, bio, nr_segs, &free);
-	spin_unlock(&dd->lock);
+	spin_unlock_irq(&dd->lock);
=20
 	if (free)
 		blk_mq_free_request(free);
@@ -706,7 +724,7 @@ static void dd_insert_requests(struct blk_mq_hw_ctx *=
hctx,
 	struct deadline_data *dd =3D q->elevator->elevator_data;
 	LIST_HEAD(free);
=20
-	spin_lock(&dd->lock);
+	spin_lock_irq(&dd->lock);
 	while (!list_empty(list)) {
 		struct request *rq;
=20
@@ -714,7 +732,7 @@ static void dd_insert_requests(struct blk_mq_hw_ctx *=
hctx,
 		list_del_init(&rq->queuelist);
 		dd_insert_request(hctx, rq, flags, &free);
 	}
-	spin_unlock(&dd->lock);
+	spin_unlock_irq(&dd->lock);
=20
 	blk_mq_free_requests(&free);
 }
@@ -741,11 +759,41 @@ static void dd_finish_request(struct request *rq)
 		atomic_inc(&per_prio->stats.completed);
 }
=20
-static bool dd_has_work_for_prio(struct dd_per_prio *per_prio)
+/* May be called from interrupt context. */
+static bool dd_has_write_work(struct deadline_data *dd,
+			      struct blk_mq_hw_ctx *hctx,
+			      struct list_head *list)
+{
+	struct request_queue *q =3D hctx->queue;
+	unsigned long flags;
+	struct request *rq;
+	bool has_work =3D false;
+
+	if (list_empty_careful(list))
+		return false;
+
+	if (!(q->limits.features & BLK_FEAT_ORDERED_HWQ))
+		return true;
+
+	spin_lock_irqsave(&dd->lock, flags);
+	list_for_each_entry(rq, list, queuelist) {
+		if (rq->mq_hctx =3D=3D hctx) {
+			has_work =3D true;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&dd->lock, flags);
+
+	return has_work;
+}
+
+static bool dd_has_work_for_prio(struct deadline_data *dd,
+				 struct blk_mq_hw_ctx *hctx,
+				 struct dd_per_prio *per_prio)
 {
 	return !list_empty_careful(&per_prio->dispatch) ||
 		!list_empty_careful(&per_prio->fifo_list[DD_READ]) ||
-		!list_empty_careful(&per_prio->fifo_list[DD_WRITE]);
+		dd_has_write_work(dd, hctx, &per_prio->fifo_list[DD_WRITE]);
 }
=20
 static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
@@ -754,7 +802,7 @@ static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
 	enum dd_prio prio;
=20
 	for (prio =3D 0; prio <=3D DD_PRIO_MAX; prio++)
-		if (dd_has_work_for_prio(&dd->per_prio[prio]))
+		if (dd_has_work_for_prio(dd, hctx, &dd->per_prio[prio]))
 			return true;
=20
 	return false;
@@ -836,7 +884,7 @@ static void *deadline_##name##_fifo_start(struct seq_=
file *m,		\
 	struct deadline_data *dd =3D q->elevator->elevator_data;		\
 	struct dd_per_prio *per_prio =3D &dd->per_prio[prio];		\
 									\
-	spin_lock(&dd->lock);						\
+	spin_lock_irq(&dd->lock);						\
 	return seq_list_start(&per_prio->fifo_list[data_dir], *pos);	\
 }									\
 									\
@@ -856,7 +904,7 @@ static void deadline_##name##_fifo_stop(struct seq_fi=
le *m, void *v)	\
 	struct request_queue *q =3D m->private;				\
 	struct deadline_data *dd =3D q->elevator->elevator_data;		\
 									\
-	spin_unlock(&dd->lock);						\
+	spin_unlock_irq(&dd->lock);						\
 }									\
 									\
 static const struct seq_operations deadline_##name##_fifo_seq_ops =3D {	=
\
@@ -922,11 +970,11 @@ static int dd_queued_show(void *data, struct seq_fi=
le *m)
 	struct deadline_data *dd =3D q->elevator->elevator_data;
 	u32 rt, be, idle;
=20
-	spin_lock(&dd->lock);
+	spin_lock_irq(&dd->lock);
 	rt =3D dd_queued(dd, DD_RT_PRIO);
 	be =3D dd_queued(dd, DD_BE_PRIO);
 	idle =3D dd_queued(dd, DD_IDLE_PRIO);
-	spin_unlock(&dd->lock);
+	spin_unlock_irq(&dd->lock);
=20
 	seq_printf(m, "%u %u %u\n", rt, be, idle);
=20
@@ -950,11 +998,11 @@ static int dd_owned_by_driver_show(void *data, stru=
ct seq_file *m)
 	struct deadline_data *dd =3D q->elevator->elevator_data;
 	u32 rt, be, idle;
=20
-	spin_lock(&dd->lock);
+	spin_lock_irq(&dd->lock);
 	rt =3D dd_owned_by_driver(dd, DD_RT_PRIO);
 	be =3D dd_owned_by_driver(dd, DD_BE_PRIO);
 	idle =3D dd_owned_by_driver(dd, DD_IDLE_PRIO);
-	spin_unlock(&dd->lock);
+	spin_unlock_irq(&dd->lock);
=20
 	seq_printf(m, "%u %u %u\n", rt, be, idle);
=20
@@ -970,7 +1018,7 @@ static void *deadline_dispatch##prio##_start(struct =
seq_file *m,	\
 	struct deadline_data *dd =3D q->elevator->elevator_data;		\
 	struct dd_per_prio *per_prio =3D &dd->per_prio[prio];		\
 									\
-	spin_lock(&dd->lock);						\
+	spin_lock_irq(&dd->lock);					\
 	return seq_list_start(&per_prio->dispatch, *pos);		\
 }									\
 									\
@@ -990,7 +1038,7 @@ static void deadline_dispatch##prio##_stop(struct se=
q_file *m, void *v)	\
 	struct request_queue *q =3D m->private;				\
 	struct deadline_data *dd =3D q->elevator->elevator_data;		\
 									\
-	spin_unlock(&dd->lock);						\
+	spin_unlock_irq(&dd->lock);					\
 }									\
 									\
 static const struct seq_operations deadline_dispatch##prio##_seq_ops =3D=
 { \
