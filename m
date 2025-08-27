Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5901ACEDA;
	Wed, 27 Aug 2025 21:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330225; cv=none; b=nx2V3vxpLI5sXVdNrQqLcfpixHHgQgB4JH0ss+GVIDZ7/MJX6N+vdA88EwrNW1dQKRorQ7JJHlxrdmhCM6jUaHTHbNo6vYqZ0zbgaOsmXzq6DKsqnhOFy/0Drlb0jpvNgiqBomYB0nF6hsyvQSw93FXVTecMoJ3T4hoQAbd9wW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330225; c=relaxed/simple;
	bh=x7UlLS2kpv2ShyvKGeNBEd1rhv9yQK+mKJX9BumHHtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjF1PAcdhXSxFrfPilVEuo1V2+art05nIGEOemTcxEuQoAKPYd+tCDcMQ2Hy47zPpiMI2db2f6zzlHnuE6ZXhlBpowHz+YwtmNbhbw2hqCgzltZskP+VJAowRIeCfh5L3t5MWmz6BT9GCARNO53g6GPNeW1P8DwUEJ6oXHPjmGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Oe3kwnag; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Oe3kwnag"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByPB6QWFzm174H;
	Wed, 27 Aug 2025 21:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330221; x=1758922222; bh=1lxqq
	htgP28V7P56IgKgh90Wgykv+JxQLBCrctX2jmo=; b=Oe3kwnagnJxZ/hBqkrFEA
	LleCjNJ+Fpsn7uReALWx8ccAT2IuXTIx1R7PvppfmMY1qNI4tAKh/QUSYcm7vBRa
	TP7VucRVs3IWhUTzvJ5KN3X46QxjjVmIeHOHRzLUs9FiSaMJyNReu2gySiD1ivTS
	zHQNB2GtKnZ6AcHsyl76OdnlmaGsgjEaND4QpNJuwgDB/o9W3fp/bMtX8jMDn5j+
	1CCieW3GusOpWel+rf8vlgPwg6c3IcieiwbR+pOo2LRTvlCXmYssDONXreuzEmZd
	F0OrXsDFdq/hxcmXT1ZTW1p8zY4CsTt9AhQNq1vkuZvRgeXstO7Dr5a+7QQiAGey
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id S9-FC5hXvziN; Wed, 27 Aug 2025 21:30:21 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByP51W7Nzm174B;
	Wed, 27 Aug 2025 21:30:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v24 03/18] blk-mq: Restore the zone write order when requeuing
Date: Wed, 27 Aug 2025 14:29:22 -0700
Message-ID: <20250827212937.2759348-4-bvanassche@acm.org>
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
index 50e51047e1fe..297a37b38bbb 100644
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
index 2af9c59ff2ad..7f43138f8a09 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1583,7 +1583,9 @@ static void blk_mq_requeue_work(struct work_struct =
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
@@ -2617,6 +2619,20 @@ static void blk_mq_insert_requests(struct blk_mq_h=
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
@@ -2671,6 +2687,8 @@ static void blk_mq_insert_request(struct request *r=
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
index 70cbc7b2deb4..e1ed9e9206fe 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -591,6 +591,8 @@ static void kyber_insert_requests(struct blk_mq_hw_ct=
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
index b9b7cdf1d3c9..1226ad3876ab 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -686,7 +686,12 @@ static void dd_insert_request(struct blk_mq_hw_ctx *=
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
