Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BC01798C;
	Tue, 19 Nov 2024 00:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976140; cv=none; b=ramtTgxlrg5isWFt9x7kyqGva5oT8r62VjKx12IysYE+vDFKiPwo7n/rp+VFoeb4nRmXywgHcHB2lbYvfy0mSGdip3manBjFWmOL0Gh+BBh8cy1Ka1afZzQyusGGfVuclUst5+EgF4IQckVSCehgcz+FgIq4pqlv5w9ZNt8Y3hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976140; c=relaxed/simple;
	bh=uJbIK0PotaTTcRtYuAvkSM7875tnTVV1J8UYYFYHMtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxURig3hL1EbFclOo7Q9sA4v/uxdXDDa17Y069M6GqsfJ7lszkvnyDRm/PHMIxIElrTRWqw2AaH2+jxU/vYhT/NCIOHRv+GUBHrD7vTpCHNQhrGn7dj22bZxlYfGIS+6pj26RgQ8flD5lTKQhxxQvIqDPWT8/wKr6HvBAr1gVmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SsYqyPX6; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SsYqyPX6"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljQ3rzBzlgMVZ;
	Tue, 19 Nov 2024 00:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976132; x=1734568133; bh=+JzvP
	Rq8XzCgGi53f83c3kpTmMgFQVQtENNrxDRXm14=; b=SsYqyPX6j7a7ZM87atznG
	j0urHLk7aNC4Le/tH8NoZY+7WeePHB7OgJJ2q2Me0ANb69ShdPXhgv6Kfplc0vZW
	yv6btHAQKzJn+QIvuyoDT29lUULKkjq8gg53y7G3TaM0hZAHQjmbza8f3XDjqHCV
	f2ZilnoIC86u/R+Prqzi1h/teCa8DlgDeXePEMCYKk/dRY5MmbwsVNfLpvAgg5lw
	z+efcBgPog8xlJ02vsYZtiy2V2eRJXCy3M8ymSek2TUMUd+QakCCm8OM29/7rBUY
	TzjCUU3d3rYXogs8ORmNR4MJn9fCSeJm4FIXovwy3iQoO8YdXo3Xx5in80UuvgwP
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id c9EfC0iEQDgu; Tue, 19 Nov 2024 00:28:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XsljH3Q46zlgT1K;
	Tue, 19 Nov 2024 00:28:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 14/26] blk-mq: Restore the zoned write order when requeuing
Date: Mon, 18 Nov 2024 16:28:03 -0800
Message-ID: <20241119002815.600608-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
In-Reply-To: <20241119002815.600608-1-bvanassche@acm.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Zoned writes may be requeued, e.g. if a block driver returns
BLK_STS_RESOURCE. Requests may be requeued in another order than
submitted. Restore the request order if requests are requeued.

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
index 0747d9d0e48c..13bedbf03bd2 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6265,6 +6265,8 @@ static void bfq_insert_request(struct blk_mq_hw_ctx=
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
index f134d5e1c4a1..1302ccbf2a7d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1564,7 +1564,9 @@ static void blk_mq_requeue_work(struct work_struct =
*work)
 		 * already.  Insert it into the hctx dispatch list to avoid
 		 * block layer merges for the request.
 		 */
-		if (rq->rq_flags & RQF_DONTPREP)
+		if (blk_rq_is_seq_zoned_write(rq))
+			blk_mq_insert_request(rq, BLK_MQ_INSERT_ORDERED);
+		else if (rq->rq_flags & RQF_DONTPREP)
 			blk_mq_request_bypass_insert(rq, 0);
 		else
 			blk_mq_insert_request(rq, BLK_MQ_INSERT_AT_HEAD);
@@ -2599,6 +2601,20 @@ static void blk_mq_insert_requests(struct blk_mq_h=
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
@@ -2653,6 +2669,8 @@ static void blk_mq_insert_request(struct request *r=
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
index 309db553aba6..10b9fb3ca762 100644
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
index 4155594aefc6..77bb41bab68d 100644
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
index 2edf84b1bc2a..200e5a2928ce 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -711,7 +711,12 @@ static void dd_insert_request(struct blk_mq_hw_ctx *=
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
index ac05974f08f9..f7514eefccfd 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -85,7 +85,7 @@ enum {
=20
 /* flags that prevent us from merging requests: */
 #define RQF_NOMERGE_FLAGS \
-	(RQF_STARTED | RQF_FLUSH_SEQ | RQF_SPECIAL_PAYLOAD)
+	(RQF_STARTED | RQF_FLUSH_SEQ | RQF_DONTPREP | RQF_SPECIAL_PAYLOAD)
=20
 enum mq_rq_state {
 	MQ_RQ_IDLE		=3D 0,
