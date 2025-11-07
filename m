Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C36729BDAC;
	Fri,  7 Nov 2025 23:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559630; cv=none; b=uaPwT5zsBkdignM0VLiAJ8ZRyA1n12oMLhtCtoOQKvwDGiBlJRVJGlqEIkpiXuHVoZWnRA1tKamuL/YzSPUocPiQ6d+oEnLX27Y7yRhOTPhQBzfxI32waDgHR6effaMkbD2oBc+j9qbeA7i4EKPt5vWlM2Gwu+S17+6z0GREMeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559630; c=relaxed/simple;
	bh=TKwq3QlCs5ZKRmSNelddooOqM3TZVziGcwfEeYdz+KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RY+jQqYKmOIt5vaC1Jh/7Clqpxlp8SNbE6sZfo/gIxFE3l6Viako5+GCalMZ4CksgJJWCD5qQ4ws03i8Tco2fa6FY1wxNHW5zrLCltET5ezXfzAyB+XFMRsm3c6yFWg910N0qI41HrXkMSCdvhjEIIa9YidDH4nFrQ4T53+mdMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LAkJAHqA; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LAkJAHqA"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d3G9R4P2Nzm17wZ;
	Fri,  7 Nov 2025 23:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1762559626; x=1765151627; bh=6DNCN
	ftGGSflZUAlZ/p9S/1WwP0Ggf0eRQ/z4XSPT/k=; b=LAkJAHqANbpYEiFlCl/Mu
	1cu/T1GWaKyO4PFtjOCkxo1ELV+ZlivvdGZ+kGYv1+cOsRKCY7mZYpLkF6zkyRgb
	8gLwch+peYcZNpvMXURSFaRVSJQDORHpzRs2avOpYA0WHSbcErO//7idPEorgSyT
	nqQeUhRK//bSCzUEGeUop1IvTlZ6bprVyQ04jEngvvEJvrhFMAcShLwQhvkatywl
	Jo/lPkP88OQTcK3wKcVBg/QDcY1zzLfEgyR0maCEUAXnl08XStsPIqAlVZ5CHvOj
	1C6s1yFsWc+JwIF8PSAux9HApEZDThX7MF9S0jMOIJNmw8Z3yUpufbzSOTuUfn/Q
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8jh_TvSnHjox; Fri,  7 Nov 2025 23:53:46 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d3G9L25q3zm17wj;
	Fri,  7 Nov 2025 23:53:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v26 04/17] blk-mq: Serialize dispatching for zoned write pipelining
Date: Fri,  7 Nov 2025 15:52:57 -0800
Message-ID: <20251107235310.2098676-5-bvanassche@acm.org>
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

Hardware queue runs (blk_mq_run_hw_queue()) may happen concurrently.
This may lead to request reordering as follows:

Context 1              Context 2
------------------     ------------------
dispatch request 1
                       dispatch request 2
                       queue request 2
queue request 1

Preserve the write order for zoned write pipelining by serializing
request dispatching if zoned write pipelining is enabled.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c         | 13 ++++++++-----
 block/blk-mq.h         | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h |  6 ++++++
 3 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4a1443ce9bc2..19857d2047cb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2398,7 +2398,7 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx=
, bool async)
 		return;
 	}
=20
-	blk_mq_run_dispatch_ops(hctx->queue,
+	blk_mq_run_dispatch_ops_serialized(hctx,
 				blk_mq_sched_dispatch_requests(hctx));
 }
 EXPORT_SYMBOL(blk_mq_run_hw_queue);
@@ -2574,7 +2574,7 @@ static void blk_mq_run_work_fn(struct work_struct *=
work)
 	struct blk_mq_hw_ctx *hctx =3D
 		container_of(work, struct blk_mq_hw_ctx, run_work.work);
=20
-	blk_mq_run_dispatch_ops(hctx->queue,
+	blk_mq_run_dispatch_ops_serialized(hctx,
 				blk_mq_sched_dispatch_requests(hctx));
 }
=20
@@ -2800,11 +2800,12 @@ static bool blk_mq_get_budget_and_tag(struct requ=
est *rq)
 static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 		struct request *rq)
 {
+	bool async =3D blk_pipeline_zwr(rq->q);
 	blk_status_t ret;
=20
 	if (blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(rq->q)) {
 		blk_mq_insert_request(rq, 0);
-		blk_mq_run_hw_queue(hctx, false);
+		blk_mq_run_hw_queue(hctx, async);
 		return;
 	}
=20
@@ -2821,7 +2822,7 @@ static void blk_mq_try_issue_directly(struct blk_mq=
_hw_ctx *hctx,
 	case BLK_STS_RESOURCE:
 	case BLK_STS_DEV_RESOURCE:
 		blk_mq_request_bypass_insert(rq, 0);
-		blk_mq_run_hw_queue(hctx, false);
+		blk_mq_run_hw_queue(hctx, async);
 		break;
 	default:
 		blk_mq_end_request(rq, ret);
@@ -2853,6 +2854,7 @@ static void blk_mq_issue_direct(struct rq_list *rqs=
)
=20
 	while ((rq =3D rq_list_pop(rqs))) {
 		bool last =3D rq_list_empty(rqs);
+		bool async =3D blk_pipeline_zwr(rq->q);
=20
 		if (hctx !=3D rq->mq_hctx) {
 			if (hctx) {
@@ -2870,7 +2872,7 @@ static void blk_mq_issue_direct(struct rq_list *rqs=
)
 		case BLK_STS_RESOURCE:
 		case BLK_STS_DEV_RESOURCE:
 			blk_mq_request_bypass_insert(rq, 0);
-			blk_mq_run_hw_queue(hctx, false);
+			blk_mq_run_hw_queue(hctx, async);
 			goto out;
 		default:
 			blk_mq_end_request(rq, ret);
@@ -4075,6 +4077,7 @@ blk_mq_alloc_hctx(struct request_queue *q, struct b=
lk_mq_tag_set *set,
 	INIT_LIST_HEAD(&hctx->dispatch);
 	INIT_HLIST_NODE(&hctx->cpuhp_dead);
 	INIT_HLIST_NODE(&hctx->cpuhp_online);
+	mutex_init(&hctx->zwp_mutex);
 	hctx->queue =3D q;
 	hctx->flags =3D set->flags & ~BLK_MQ_F_TAG_QUEUE_SHARED;
=20
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 625eaf459a55..4e8522a91477 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -458,6 +458,42 @@ do {								\
 #define blk_mq_run_dispatch_ops(q, dispatch_ops)		\
 	__blk_mq_run_dispatch_ops(q, true, dispatch_ops)	\
=20
+static inline struct mutex *blk_mq_zwp_mutex(struct blk_mq_hw_ctx *hctx)
+{
+	struct request_queue *q =3D hctx->queue;
+
+	/*
+	 * If pipelining zoned writes is disabled, do not serialize dispatch
+	 * operations.
+	 */
+	if (!blk_pipeline_zwr(q))
+		return NULL;
+
+	/*
+	 * If no I/O scheduler is active or if the selected I/O scheduler
+	 * uses multiple queues internally, serialize per hardware queue.
+	 */
+	if (!blk_queue_sq_sched(q))
+		return &hctx->zwp_mutex;
+
+	/* For single queue I/O schedulers, serialize per request queue. */
+	return &blk_mq_map_queue_type(q, HCTX_TYPE_DEFAULT, 0)->zwp_mutex;
+}
+
+#define blk_mq_run_dispatch_ops_serialized(hctx, dispatch_ops)	\
+do {								\
+	struct request_queue *q =3D hctx->queue;			\
+	struct mutex *m =3D blk_mq_zwp_mutex(hctx);		\
+								\
+	if (m) {						\
+		mutex_lock(m);					\
+		blk_mq_run_dispatch_ops(q, dispatch_ops);	\
+		mutex_unlock(m);				\
+	} else {						\
+		blk_mq_run_dispatch_ops(q, dispatch_ops);	\
+	}							\
+} while (0)
+
 static inline bool blk_mq_can_poll(struct request_queue *q)
 {
 	return (q->limits.features & BLK_FEAT_POLL) &&
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d8867c2084b8..5aac7bd94e97 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -430,6 +430,12 @@ struct blk_mq_hw_ctx {
 	/** @queue_num: Index of this hardware queue. */
 	unsigned int		queue_num;
=20
+	/**
+	 * @zwp_mutex: Mutex used for serializing dispatching of zoned writes
+	 * if zoned write pipelining is enabled.
+	 */
+	struct mutex		zwp_mutex;
+
 	/**
 	 * @nr_active: Number of active requests. Only used when a tag set is
 	 * shared across request queues.
