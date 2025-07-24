Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D17221858A;
	Thu, 24 Jul 2025 21:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394288; cv=none; b=un6ZYVFItynq36KNtb3q4hUv30dyOIjvNYfCoxZ/D2Xv66ZEk1APAzuMzLE2zgz4/KPrCpJne6DSmTrdkDF1NdcpyrBa3Z2PzNwoGqa9Lh/iZs/ngebrhgGjdD16hrBGtv6ylUJqbOExcS+FHqESMI60qMdVghhebuaGgS5fuvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394288; c=relaxed/simple;
	bh=/FkI1/QDbNigB5e6s3EES4KE3Vtein/pqR08Ok6YAz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nfl48VFRCVymH+oyeaocp4yZep8saFwURX7aj9fdXlPiFZ2pyIDoeDP74n7G1BILpXcVg4snXD/Qc1V8YGYnhfsCYaxexFQobJqpompDiuUxQT9DLAp63u0zBbDtaMcAwrUhjLGp96m787PxNVSwYzn23w0Q2VxT8zWc17Egs7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EfFpvZ1R; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EfFpvZ1R"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bp4ct10ptzlgqVB;
	Thu, 24 Jul 2025 21:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1753394284; x=1755986285; bh=Plbgp
	nzeOYU9MrOUov8YQ8Wcdo6hyCzDGuC1Iy2Ey+s=; b=EfFpvZ1R6vtaQAL0Y3LQw
	wQKWJs2XCjtl+SWi09jyJhRXDBWDGiLaJLSJfDJ/amlvFU9+XotlXyJWA+w5pQUS
	MoY2egGRVBcZSqtNGbkJM8g/YZQhap0kuvB/U7qeIyDGGe45BIzGi2ljPFrmQ1ue
	ZReRmKfr62GUAPvSG7RFW+qaczRGjjDndJt02hQEpCUW2kLCIifi2Nu46jo1WsIP
	L9m1Qj9Y3QhiWZc8QFMYMD/isBXC5vfvEp9KjNh/kLdxRlPMAYKe/RvsRY4kxbw3
	izYdkbxuv00V1TPIK63RjMczIHNSZzmJQX9JZxmnTqEYXgP21bGlCnP63zPfv4PM
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id knRPPg7Pxb0s; Thu, 24 Jul 2025 21:58:04 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bp4cm24CWzlgqV4;
	Thu, 24 Jul 2025 21:57:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v22 03/14] blk-mq: Restore the zone write order when requeuing
Date: Thu, 24 Jul 2025 14:56:52 -0700
Message-ID: <20250724215703.2910510-4-bvanassche@acm.org>
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

Zoned writes may be requeued. This happens if a block driver returns
BLK_STS_RESOURCE, to handle SCSI unit attentions or by the SCSI error
handler after error handling has finished. A later patch enables write
pipelining and increases the number of pending writes per zone. If
multiple writes are pending per zone, write requests may be requeued in
another order than submitted. Restore the request order if requests are
requeued. Add RQF_DONTPREP to RQF_NOMERGE_FLAGS because this patch may
cause RQF_DONTPREP requests to be sent to the code that checks whether
a request can be merged. RQF_DONTPREP requests must not be merged.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/bfq-iosched.c    |  2 ++
 block/blk-mq.c         | 20 +++++++++++++++++++-
 block/blk-mq.h         |  2 ++
 block/kyber-iosched.c  |  2 ++
 block/mq-deadline.c    |  7 ++++++-
 include/linux/blk-mq.h |  2 +-
 6 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 0cb1e9873aab..1bd3afe5d779 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6276,6 +6276,8 @@ static void bfq_insert_request(struct blk_mq_hw_ctx=
 *hctx, struct request *rq,
=20
 	if (flags & BLK_MQ_INSERT_AT_HEAD) {
 		list_add(&rq->queuelist, &bfqd->dispatch);
+	} else if (flags & BLK_MQ_INSERT_ORDERED) {
+		blk_mq_insert_ordered(rq, &bfqd->dispatch);
 	} else if (!bfqq) {
 		list_add_tail(&rq->queuelist, &bfqd->dispatch);
 	} else {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 445f2275eddb..37217d1f19bb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1580,7 +1580,9 @@ static void blk_mq_requeue_work(struct work_struct =
*work)
 		 * already.  Insert it into the hctx dispatch list to avoid
 		 * block layer merges for the request.
 		 */
-		if (rq->rq_flags & RQF_DONTPREP)
+		if (blk_mq_preserve_order(rq))
+			blk_mq_insert_request(rq, BLK_MQ_INSERT_ORDERED);
+		else if (rq->rq_flags & RQF_DONTPREP)
 			blk_mq_request_bypass_insert(rq, 0);
 		else
 			blk_mq_insert_request(rq, BLK_MQ_INSERT_AT_HEAD);
@@ -2614,6 +2616,20 @@ static void blk_mq_insert_requests(struct blk_mq_h=
w_ctx *hctx,
 	blk_mq_run_hw_queue(hctx, run_queue_async);
 }
=20
+void blk_mq_insert_ordered(struct request *rq, struct list_head *list)
+{
+	struct request_queue *q =3D rq->q;
+	struct request *rq2;
+
+	list_for_each_entry(rq2, list, queuelist)
+		if (rq2->q =3D=3D q && blk_rq_pos(rq2) > blk_rq_pos(rq))
+			break;
+
+	/* Insert rq before rq2. If rq2 is the list head, append at the end. */
+	list_add_tail(&rq->queuelist, &rq2->queuelist);
+}
+EXPORT_SYMBOL_GPL(blk_mq_insert_ordered);
+
 static void blk_mq_insert_request(struct request *rq, blk_insert_t flags=
)
 {
 	struct request_queue *q =3D rq->q;
@@ -2668,6 +2684,8 @@ static void blk_mq_insert_request(struct request *r=
q, blk_insert_t flags)
 		spin_lock(&ctx->lock);
 		if (flags & BLK_MQ_INSERT_AT_HEAD)
 			list_add(&rq->queuelist, &ctx->rq_lists[hctx->type]);
+		else if (flags & BLK_MQ_INSERT_ORDERED)
+			blk_mq_insert_ordered(rq, &ctx->rq_lists[hctx->type]);
 		else
 			list_add_tail(&rq->queuelist,
 				      &ctx->rq_lists[hctx->type]);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index affb2e14b56e..393660311a56 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -40,8 +40,10 @@ enum {
=20
 typedef unsigned int __bitwise blk_insert_t;
 #define BLK_MQ_INSERT_AT_HEAD		((__force blk_insert_t)0x01)
+#define BLK_MQ_INSERT_ORDERED		((__force blk_insert_t)0x02)
=20
 void blk_mq_submit_bio(struct bio *bio);
+void blk_mq_insert_ordered(struct request *rq, struct list_head *list);
 int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, struct io_comp=
_batch *iob,
 		unsigned int flags);
 void blk_mq_exit_queue(struct request_queue *q);
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index 4dba8405bd01..051c05ceafd7 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -603,6 +603,8 @@ static void kyber_insert_requests(struct blk_mq_hw_ct=
x *hctx,
 		trace_block_rq_insert(rq);
 		if (flags & BLK_MQ_INSERT_AT_HEAD)
 			list_move(&rq->queuelist, head);
+		else if (flags & BLK_MQ_INSERT_ORDERED)
+			blk_mq_insert_ordered(rq, head);
 		else
 			list_move_tail(&rq->queuelist, head);
 		sbitmap_set_bit(&khd->kcq_map[sched_domain],
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 2edf1cac06d5..110fef65b829 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -710,7 +710,12 @@ static void dd_insert_request(struct blk_mq_hw_ctx *=
hctx, struct request *rq,
 		 * set expire time and add to fifo list
 		 */
 		rq->fifo_time =3D jiffies + dd->fifo_expire[data_dir];
-		list_add_tail(&rq->queuelist, &per_prio->fifo_list[data_dir]);
+		if (flags & BLK_MQ_INSERT_ORDERED)
+			blk_mq_insert_ordered(rq,
+					      &per_prio->fifo_list[data_dir]);
+		else
+			list_add_tail(&rq->queuelist,
+				      &per_prio->fifo_list[data_dir]);
 	}
 }
=20
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 30d7cd1b0484..1c516151fff0 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -86,7 +86,7 @@ enum rqf_flags {
=20
 /* flags that prevent us from merging requests: */
 #define RQF_NOMERGE_FLAGS \
-	(RQF_STARTED | RQF_FLUSH_SEQ | RQF_SPECIAL_PAYLOAD)
+	(RQF_STARTED | RQF_FLUSH_SEQ | RQF_DONTPREP | RQF_SPECIAL_PAYLOAD)
=20
 enum mq_rq_state {
 	MQ_RQ_IDLE		=3D 0,
