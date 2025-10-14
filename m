Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7C12E8B7A;
	Tue, 14 Oct 2025 21:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478913; cv=none; b=LfzM/HvR4LiRtMuNv4CkA1PzqpCKYA103mSwIn6sAYH8he4t+1LKaKLb160x1jPaq0g0yXtHVKbz6DGqxqdb17OlmzD+JEJXl8fGyug7aB/zs9dPB+XWgxmOgXHDOeERxDVrphyoSKSJfdVRwtu9T19BORL8e3ZV3mtplZYHUxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478913; c=relaxed/simple;
	bh=4HELj6P09C32JztKmRUKOQYEzkxwsnDuCCd5TYp2mx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8oR1IydZB6eRaUzffOh5yZByzc+alc44Z/UzOgkj3GW3zab0C7ha9AFMHdoV/fyXGEKhG65eJeeKE+72BSVpZXdOW0xzbSsldaPkVmLFqO4CaPTSPv5Phhqun3BfqcR8wkTZ7bjNI63OQ8WLkk7ExkoDavJVN2U9ETHjv561uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=P0lZidvl; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="P0lZidvl"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmSgf6XKPzm0yVF;
	Tue, 14 Oct 2025 21:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478909; x=1763070910; bh=gGDZJ
	j0oirN1M7ZJycTDQfNyCQdhsSh2BiruTnLDD4s=; b=P0lZidvlI8ClmTlpMSI9u
	41Ha2DnPs2Kn+ujijk94gPWnyInl6WVs3dfUPiHok83+TgUswIY/WI+WjY83FHWr
	ZGoPwZ3GmY2bLiBIJ//JLBEqwN4L9iFA6XVZw/d0sQavYcDpHwQ5FrzzyzAWbpnW
	LIt9DZQEojNmZae2enTEhEtLB3kiJHrlopn4YGRELeX57a3UShNRah9k4PISb2Ta
	oiJM3mLYprIpCLbKPsrSIqY3ocpmvUC0BX5rABH0FzTS5qwjtiwz5EXSjGYiSoyR
	A95ruLKA228XSu7REK34sJJxLBACBiVtH3C6Fvg/puYoezcS3qd9+JhYpIvBFT3C
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hVbFfm7agLQG; Tue, 14 Oct 2025 21:55:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmSgY3HyTzm0ySn;
	Tue, 14 Oct 2025 21:55:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 03/20] blk-mq: Restore the zone write order when requeuing
Date: Tue, 14 Oct 2025 14:54:11 -0700
Message-ID: <20251014215428.3686084-4-bvanassche@acm.org>
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
index 4a8d3d96bfe4..4766c89491d1 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6259,6 +6259,8 @@ static void bfq_insert_request(struct blk_mq_hw_ctx=
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
index 0457aa6eef47..28d05b8846d7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1597,7 +1597,9 @@ static void blk_mq_requeue_work(struct work_struct =
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
@@ -2631,6 +2633,20 @@ static void blk_mq_insert_requests(struct blk_mq_h=
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
@@ -2685,6 +2701,8 @@ static void blk_mq_insert_request(struct request *r=
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
index af42dc018808..7a22d870b7b7 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -41,8 +41,10 @@ enum {
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
index 18efd6ef2a2b..c510db7f748d 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -590,6 +590,8 @@ static void kyber_insert_requests(struct blk_mq_hw_ct=
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
index 3e3719093aec..85806c73562a 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -676,7 +676,12 @@ static void dd_insert_request(struct blk_mq_hw_ctx *=
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
index 2c08a86b4ac3..a5dbab229d80 100644
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
