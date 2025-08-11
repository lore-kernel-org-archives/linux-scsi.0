Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8370F2D94B2;
	Mon, 11 Aug 2025 20:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754943003; cv=none; b=r75M315x32J2PnHDDPWVPFIFziByjv/BYzTcm3qPVoxZ+kZtERQTdrKpRou52fNbplX+sBuF6Gv7pkgeG6eTdg63XBq8JuRfi9wzK+Ns8t4Q4DLS72SvmWdkq7jV0enhXS+hUhE1kjOMuv1/OZ12FA9tocFY5alj/M68xqzZ3zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754943003; c=relaxed/simple;
	bh=aOpgY+C+vK7hT/6v0wQ5xDVnTKmdgxClde09BKMvo9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9ugykVwe08zEFnPntfFtVeF8lkGk4KQ1WxglQaRepq6X1Fx9IpKbYcIkax7sGEYW56bjHqwmSeRZcbyUOwWs4s2k2nf8+TOsLxCq7yH0CHl1PwSutA9Qk+WaFXAjQrvqY8gIaB+05T5GL+8+ZGrTflYHeNVtnT+PA8V5Ys6nEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BKDdErEK; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BKDdErEK"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c15Mr4krwzm1742;
	Mon, 11 Aug 2025 20:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754942999; x=1757535000; bh=I0uaR
	5D+H/BDksWj53ELaZTs+kxtrt2seTiuZsPhXs0=; b=BKDdErEKodGKZk2FRfJpd
	ql3Gz9eahILPa4GNFZgleVChE0GIHYNb+mD6pkugshEg0AnT+2GxW0uE9PNQwPmr
	GrzhyjK1s05HRpj1w0MvEScbZC88aujWJn0h1YyYuIRZZ5Vau9aXkIw1nooa+PM3
	ayy5wW7pVEk5AJniI5EiU8++aI6xBEXkIy34rSIwamjK2q+9binvV6I6UIu/nx5O
	t9H4Z2T4mNQffdrT7neLDtnh78gsbni2/UegpVnvgkHjRgzn1Qdr0Oqq8Jgc20T/
	OzLokHQd+89fEaQ/pdSca9WthYo8WA31PH8IT5+YB1pgkJI5Jqw7yZNKNqQvEzdB
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QWP352SG6nYI; Mon, 11 Aug 2025 20:09:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c15Ml0l0nzm0ysg;
	Mon, 11 Aug 2025 20:09:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v23 05/16] block/mq-deadline: Preserve the zwr order if zoned write plugging is enabled
Date: Mon, 11 Aug 2025 13:08:40 -0700
Message-ID: <20250811200851.626402-6-bvanassche@acm.org>
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

The hwq selected by blk_mq_run_hw_queues() for single-queue I/O scheduler=
s
depends on from which CPU core it has been called. This may lead to
concurrent dispatching of I/O requests on different CPU cores and hence
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

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/mq-deadline.c | 59 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 49 insertions(+), 10 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 1226ad3876ab..2a53a4d7a641 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -310,11 +310,24 @@ static bool started_after(struct deadline_data *dd,=
 struct request *rq,
 	return time_after(start_time, latest_start);
 }
=20
+/*
+ * If write pipelining is enabled, only dispatch zoned writes if
+ * rq->mq_hctx =3D=3D hctx.
+ */
+static bool dd_check_hctx(struct blk_mq_hw_ctx *hctx, struct request *rq=
)
+{
+	struct request_queue *q =3D hctx->queue;
+
+	return !(q->limits.features & BLK_FEAT_PIPELINE_ZWR) ||
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
@@ -339,7 +352,7 @@ static struct request *__dd_dispatch_request(struct d=
eadline_data *dd,
 	 * batches are currently reads XOR writes
 	 */
 	rq =3D deadline_next_request(dd, per_prio, dd->last_dir);
-	if (rq && dd->batching < dd->fifo_batch) {
+	if (rq && dd->batching < dd->fifo_batch && dd_check_hctx(hctx, rq)) {
 		/* we have a next request and are still entitled to batch */
 		data_dir =3D rq_data_dir(rq);
 		goto dispatch_request;
@@ -399,7 +412,7 @@ static struct request *__dd_dispatch_request(struct d=
eadline_data *dd,
 		rq =3D next_rq;
 	}
=20
-	if (!rq)
+	if (!rq || !dd_check_hctx(hctx, rq))
 		return NULL;
=20
 	dd->last_dir =3D data_dir;
@@ -427,8 +440,9 @@ static struct request *__dd_dispatch_request(struct d=
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
@@ -442,7 +456,7 @@ static struct request *dd_dispatch_prio_aged_requests=
(struct deadline_data *dd,
 		return NULL;
=20
 	for (prio =3D DD_BE_PRIO; prio <=3D DD_PRIO_MAX; prio++) {
-		rq =3D __dd_dispatch_request(dd, &dd->per_prio[prio],
+		rq =3D __dd_dispatch_request(dd, hctx, &dd->per_prio[prio],
 					   now - dd->prio_aging_expire);
 		if (rq)
 			return rq;
@@ -467,7 +481,7 @@ static struct request *dd_dispatch_request(struct blk=
_mq_hw_ctx *hctx)
 	enum dd_prio prio;
=20
 	spin_lock(&dd->lock);
-	rq =3D dd_dispatch_prio_aged_requests(dd, now);
+	rq =3D dd_dispatch_prio_aged_requests(dd, hctx, now);
 	if (rq)
 		goto unlock;
=20
@@ -476,7 +490,7 @@ static struct request *dd_dispatch_request(struct blk=
_mq_hw_ctx *hctx)
 	 * requests if any higher priority requests are pending.
 	 */
 	for (prio =3D 0; prio <=3D DD_PRIO_MAX; prio++) {
-		rq =3D __dd_dispatch_request(dd, &dd->per_prio[prio], now);
+		rq =3D __dd_dispatch_request(dd, hctx, &dd->per_prio[prio], now);
 		if (rq || dd_queued(dd, prio))
 			break;
 	}
@@ -586,6 +600,8 @@ static int dd_init_sched(struct request_queue *q, str=
uct elevator_queue *eq)
 	/* We dispatch from request queue wide instead of hw queue */
 	blk_queue_flag_set(QUEUE_FLAG_SQ_SCHED, q);
=20
+	set_bit(ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING, &eq->flags);
+
 	q->elevator =3D eq;
 	return 0;
 }
@@ -741,11 +757,34 @@ static void dd_finish_request(struct request *rq)
 		atomic_inc(&per_prio->stats.completed);
 }
=20
-static bool dd_has_work_for_prio(struct dd_per_prio *per_prio)
+static bool dd_has_write_work(struct deadline_data *dd,
+			      struct blk_mq_hw_ctx *hctx,
+			      struct list_head *list)
+{
+	struct request_queue *q =3D hctx->queue;
+	struct request *rq;
+
+	if (list_empty_careful(list))
+		return false;
+
+	if (!(q->limits.features & BLK_FEAT_PIPELINE_ZWR))
+		return true;
+
+	guard(spinlock)(&dd->lock);
+	list_for_each_entry(rq, list, queuelist)
+		if (!blk_rq_is_seq_zoned_write(rq) || rq->mq_hctx =3D=3D hctx)
+			return true;
+
+	return false;
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
@@ -754,7 +793,7 @@ static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
 	enum dd_prio prio;
=20
 	for (prio =3D 0; prio <=3D DD_PRIO_MAX; prio++)
-		if (dd_has_work_for_prio(&dd->per_prio[prio]))
+		if (dd_has_work_for_prio(dd, hctx, &dd->per_prio[prio]))
 			return true;
=20
 	return false;
