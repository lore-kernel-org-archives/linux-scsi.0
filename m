Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B439F303C88;
	Tue, 14 Oct 2025 21:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478928; cv=none; b=Iv25GiZSLpPca1cSKwKNxiP8m+5vU4JnqOqyMg8CdutcSqkf2hdPnRlBweWmuDln57SdzUgFAFn7FGseaaB8PlOkmbJrtilr/F7KhXHoDpm1atbX9jTtGeiomN/zEdG7NZvvuxxvzXFxaSUpO/9mDzcU9e4oOnAg23UNxFwXcVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478928; c=relaxed/simple;
	bh=pVG8kXtQFtQ4C4ICX0EWhJW/NTDMF7IfPv9IJpsUdLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pB1UM2koBRimYpHO33BioFj2Dbla5BtpOwgDU9eETwRkE0C3+sDrU4Ji/4Q6mKbtXsQMVR+AzQSBEhzNTKqUjsXHSVyHPfgGReX9bi4uIr/p/a05mRW7+kvBK9BRX3zOQ2NRv5AVnbNkuaLusZsrTrPK4HzmIyNnWl0O4KDFBGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0drNPn1B; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0drNPn1B"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmSgx6wKVzm0yV3;
	Tue, 14 Oct 2025 21:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478924; x=1763070925; bh=Av35k
	rEiZSoaFeQjew2xDcEHTOIqmnvt006flNZUHFw=; b=0drNPn1B9eE/ISSm9LsuO
	fXSaezHOUoQF899ZM0DGETUh2mjOaSj/cr+2/kumz+J+NVYsuKaukqeRjtKsl9jH
	ZTs6RemUsgjDkUG+uM3orZ7By+KhKxf+X6TAYD1Yblvin+bLztrozaJ2JsujR4sH
	5IvxA9veNHjnXdNRut8zuLD3SXioAGn25nBqrgUa4rXjEDoBr/Kn8KmkJGEbQr0I
	SDsHQ9ISMLQNPhDAiPhT7GWg+Jtq/Wx9bGUqRWxofmbYDuHhgeGwB6ykw4o+C1dU
	tVhF1NVg/VNtwOfdxOAqGPy8quHz1NFElk0OJR3z5zsIa+CP7SCWSTSEXH/BqEJe
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YjetWKenD1pd; Tue, 14 Oct 2025 21:55:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmSgr2LgXzm0yVM;
	Tue, 14 Oct 2025 21:55:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 06/20] block/mq-deadline: Make locking IRQ-safe
Date: Tue, 14 Oct 2025 14:54:14 -0700
Message-ID: <20251014215428.3686084-7-bvanassche@acm.org>
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

Prepare for locking dd->lock in dd_has_write_work(). That function may
be called from interrupt context.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/mq-deadline.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 85806c73562a..0a46d0f06f72 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -457,7 +457,7 @@ static struct request *dd_dispatch_request(struct blk=
_mq_hw_ctx *hctx)
 	struct request *rq;
 	enum dd_prio prio;
=20
-	spin_lock(&dd->lock);
+	spin_lock_irq(&dd->lock);
=20
 	if (!list_empty(&dd->dispatch)) {
 		rq =3D list_first_entry(&dd->dispatch, struct request, queuelist);
@@ -481,7 +481,7 @@ static struct request *dd_dispatch_request(struct blk=
_mq_hw_ctx *hctx)
 	}
=20
 unlock:
-	spin_unlock(&dd->lock);
+	spin_unlock_irq(&dd->lock);
=20
 	return rq;
 }
@@ -527,9 +527,9 @@ static void dd_exit_sched(struct elevator_queue *e)
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
@@ -623,9 +623,9 @@ static bool dd_bio_merge(struct request_queue *q, str=
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
@@ -696,7 +696,7 @@ static void dd_insert_requests(struct blk_mq_hw_ctx *=
hctx,
 	struct deadline_data *dd =3D q->elevator->elevator_data;
 	LIST_HEAD(free);
=20
-	spin_lock(&dd->lock);
+	spin_lock_irq(&dd->lock);
 	while (!list_empty(list)) {
 		struct request *rq;
=20
@@ -704,7 +704,7 @@ static void dd_insert_requests(struct blk_mq_hw_ctx *=
hctx,
 		list_del_init(&rq->queuelist);
 		dd_insert_request(hctx, rq, flags, &free);
 	}
-	spin_unlock(&dd->lock);
+	spin_unlock_irq(&dd->lock);
=20
 	blk_mq_free_requests(&free);
 }
@@ -828,7 +828,7 @@ static void *deadline_##name##_fifo_start(struct seq_=
file *m,		\
 	struct deadline_data *dd =3D q->elevator->elevator_data;		\
 	struct dd_per_prio *per_prio =3D &dd->per_prio[prio];		\
 									\
-	spin_lock(&dd->lock);						\
+	spin_lock_irq(&dd->lock);					\
 	return seq_list_start(&per_prio->fifo_list[data_dir], *pos);	\
 }									\
 									\
@@ -848,7 +848,7 @@ static void deadline_##name##_fifo_stop(struct seq_fi=
le *m, void *v)	\
 	struct request_queue *q =3D m->private;				\
 	struct deadline_data *dd =3D q->elevator->elevator_data;		\
 									\
-	spin_unlock(&dd->lock);						\
+	spin_unlock_irq(&dd->lock);					\
 }									\
 									\
 static const struct seq_operations deadline_##name##_fifo_seq_ops =3D {	=
\
@@ -914,11 +914,11 @@ static int dd_queued_show(void *data, struct seq_fi=
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
@@ -942,11 +942,11 @@ static int dd_owned_by_driver_show(void *data, stru=
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
@@ -959,7 +959,7 @@ static void *deadline_dispatch_start(struct seq_file =
*m, loff_t *pos)
 	struct request_queue *q =3D m->private;
 	struct deadline_data *dd =3D q->elevator->elevator_data;
=20
-	spin_lock(&dd->lock);
+	spin_lock_irq(&dd->lock);
 	return seq_list_start(&dd->dispatch, *pos);
 }
=20
@@ -977,7 +977,7 @@ static void deadline_dispatch_stop(struct seq_file *m=
, void *v)
 	struct request_queue *q =3D m->private;
 	struct deadline_data *dd =3D q->elevator->elevator_data;
=20
-	spin_unlock(&dd->lock);
+	spin_unlock_irq(&dd->lock);
 }
=20
 static const struct seq_operations deadline_dispatch_seq_ops =3D {
