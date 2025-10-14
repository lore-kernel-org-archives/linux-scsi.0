Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641602DA776;
	Tue, 14 Oct 2025 21:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478934; cv=none; b=VR0cfTv/5nmlYPgU426j28ACda7qhQH/D8lhy9NH4OITmNmGpE28lOpJQCnp74CFj+h9S9nl96Q3nRc3FtmWGl8lcW/CRUtqWLTcB+4dokd5HdCRRvjp2/8WyDrULSg1vVa868VpyPgLSeR3zKEEQN1TWZR7meCBOh2mpzLwlqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478934; c=relaxed/simple;
	bh=mPXE7SmgQNVExiW76aFCWdobZlVQwBb6tFT/s8kCC9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eagb7xgBiGFg+XEKFwnukw27Kxz30iJoB+VUjh8A7BE134UqJ+rM4q0SS/CIfBnnfslKAZWWiiegxNeGJUD4jUWF9IjII52aTHh/wuyUsDSGRSOWdZhrrxOpA3pXzP1p8AEHcSMU5WUH8My64LIQwcqpfzKocNIf/kxmEZ1cmKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=quDSeR9E; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="quDSeR9E"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmSh33WTVzm0yVJ;
	Tue, 14 Oct 2025 21:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478930; x=1763070931; bh=yTwB9
	idHWVhyCNkmM4nkGaOhDhNFOHLITVuEGtCmsvo=; b=quDSeR9EK3OVDumHvrE+L
	Cnt7h7pDUEemhcADas2n2MjUBEbw7nLNeACNznDgO21C+ff3y4OwQk8eDT7jejMK
	Y0BRScr4plyy95mDhB4JtpDsD1HSRRjZM8IVmyiJZ3YYPKlrd46U5uXyQl25b4HP
	Dd9gjFgWZVEx3BQv8gcEcD3/Lnn2gLIpcoh/3NCzmsnAcqvwprAxCUouUe8xDfM7
	Ri/lGCXgoSn3bGzGyii3z3DSSorYlY7PZNSafhPfionnH/bBT9RDk9oS1o0p5UDo
	d+x9mhbCk23qDmsXBNCNuLl6p2VNUsKwjOz94iPXYZ1uy9PI5pGDeNFPqeKf8YGx
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JQPMjU2YEDvD; Tue, 14 Oct 2025 21:55:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmSgx2lYzzm0yVF;
	Tue, 14 Oct 2025 21:55:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 07/20] block/mq-deadline: Enable zoned write pipelining
Date: Tue, 14 Oct 2025 14:54:15 -0700
Message-ID: <20251014215428.3686084-8-bvanassche@acm.org>
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

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/mq-deadline.c | 68 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 10 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 0a46d0f06f72..be6ed3d8fa36 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -319,11 +319,25 @@ static struct request *dd_start_request(struct dead=
line_data *dd,
 	return rq;
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
@@ -336,7 +350,8 @@ static struct request *__dd_dispatch_request(struct d=
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
@@ -396,7 +411,7 @@ static struct request *__dd_dispatch_request(struct d=
eadline_data *dd,
 		rq =3D next_rq;
 	}
=20
-	if (!rq)
+	if (!rq || !dd_dispatch_from_hctx(hctx, rq))
 		return NULL;
=20
 	dd->last_dir =3D data_dir;
@@ -418,8 +433,9 @@ static struct request *__dd_dispatch_request(struct d=
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
@@ -433,7 +449,7 @@ static struct request *dd_dispatch_prio_aged_requests=
(struct deadline_data *dd,
 		return NULL;
=20
 	for (prio =3D DD_BE_PRIO; prio <=3D DD_PRIO_MAX; prio++) {
-		rq =3D __dd_dispatch_request(dd, &dd->per_prio[prio],
+		rq =3D __dd_dispatch_request(dd, hctx, &dd->per_prio[prio],
 					   now - dd->prio_aging_expire);
 		if (rq)
 			return rq;
@@ -466,7 +482,7 @@ static struct request *dd_dispatch_request(struct blk=
_mq_hw_ctx *hctx)
 		goto unlock;
 	}
=20
-	rq =3D dd_dispatch_prio_aged_requests(dd, now);
+	rq =3D dd_dispatch_prio_aged_requests(dd, hctx, now);
 	if (rq)
 		goto unlock;
=20
@@ -475,7 +491,7 @@ static struct request *dd_dispatch_request(struct blk=
_mq_hw_ctx *hctx)
 	 * requests if any higher priority requests are pending.
 	 */
 	for (prio =3D 0; prio <=3D DD_PRIO_MAX; prio++) {
-		rq =3D __dd_dispatch_request(dd, &dd->per_prio[prio], now);
+		rq =3D __dd_dispatch_request(dd, hctx, &dd->per_prio[prio], now);
 		if (rq || dd_queued(dd, prio))
 			break;
 	}
@@ -575,6 +591,8 @@ static int dd_init_sched(struct request_queue *q, str=
uct elevator_queue *eq)
 	/* We dispatch from request queue wide instead of hw queue */
 	blk_queue_flag_set(QUEUE_FLAG_SQ_SCHED, q);
=20
+	set_bit(ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING, &eq->flags);
+
 	q->elevator =3D eq;
 	dd_depth_updated(q);
 	return 0;
@@ -731,10 +749,40 @@ static void dd_finish_request(struct request *rq)
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
 	return !list_empty_careful(&per_prio->fifo_list[DD_READ]) ||
-		!list_empty_careful(&per_prio->fifo_list[DD_WRITE]);
+		dd_has_write_work(dd, hctx, &per_prio->fifo_list[DD_WRITE]);
 }
=20
 static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
@@ -746,7 +794,7 @@ static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
 		return true;
=20
 	for (prio =3D 0; prio <=3D DD_PRIO_MAX; prio++)
-		if (dd_has_work_for_prio(&dd->per_prio[prio]))
+		if (dd_has_work_for_prio(dd, hctx, &dd->per_prio[prio]))
 			return true;
=20
 	return false;
