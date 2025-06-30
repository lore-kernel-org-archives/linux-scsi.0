Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF081DFE26;
	Mon, 30 Jun 2025 22:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322644; cv=none; b=rsqrEBYVLVJexTzC65Zjuw6Zw1YPagZb3HM8b6XWOryEDeVN70QpRxLnD4f9d4juRa1REY8lUURQZKN7ya1kD04OIuVlITf08g8nfN8p+ywBK4sLdR/zkvtmhho6x3cJ/Y9iFcQ33h5EtdUcv1XEUrnd5/zJN5CbBO8I52n0pIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322644; c=relaxed/simple;
	bh=pDdMimvi11vMb/qZ30+RYPOupqmq54djOo5eaKjTP0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7UzKgcInoL8656pTRWa6tDIa+0bDUW5ukcstQnSgFJVgUE4KcdWotvkOka3CynzPw3UYIb8quyS4/Mf6JW54Tg58cY/jC6ydQOBFUA1eXFX0GmKakHxzPeB+aFFXjPQGUPfohuvcQgswrE+qWXEJpJhBtcif61TNm0pBF4ceB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Y2OPHmqt; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Y2OPHmqt"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bWLTY4Rgqzm0bg9;
	Mon, 30 Jun 2025 22:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1751322640; x=1753914641; bh=4BiSV
	es7Lr+8+gqNzbFYUn2Mn71NmtO7+AFGkRfwaTE=; b=Y2OPHmqteiAO72g0+lJp7
	0vZWvD4pEKIi9iYdONWJjC9jNfAcK8ftakV5tftwz/Fx9PBFOJGgIWLG7YQ1+KIw
	tYcld86bT/kSovBP0sJXH1gdqkj3sOSIcAhplSOw2mEOW6xf5R0NTYMDLH28TfAq
	TvVD2Cx7Xv7c2bgJWS1d4fiHTuVbBnzG8mHGDc6ZnxPOqnshUuI5b9qhTXfta2S6
	AMvMbe2WzsP5fcKk8xpdwQJ29Z9gbx8/qs0fuVXXgzsuBp0Kf9/obL3Hska0zLd3
	fsF4dYG0xWEBZrsWy/fZt+pRyPJKUgJ7Q7ZSh/hA19bqw+2pGvex/Bn92m41G/yg
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VNWV6tSJR_3r; Mon, 30 Jun 2025 22:30:40 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bWLTS44bdzm0bfr;
	Mon, 30 Jun 2025 22:30:35 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v19 02/11] block: Support allocating from a specific software queue
Date: Mon, 30 Jun 2025 15:29:54 -0700
Message-ID: <20250630223003.2642594-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250630223003.2642594-1-bvanassche@acm.org>
References: <20250630223003.2642594-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

A later patch will preserve the order of pipelined zoned writes by
submitting all zoned writes per zone to the same software queue as
previously submitted zoned writes. Hence support allocating a request
from a specific software queue.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c | 22 +++++++++++++++++++---
 block/blk-mq.h |  1 +
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0c61492724d2..7bbb4da6e168 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -485,6 +485,7 @@ __blk_mq_alloc_requests_batch(struct blk_mq_alloc_dat=
a *data)
 static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data =
*data)
 {
 	struct request_queue *q =3D data->q;
+	int from_cpu =3D data->from_cpu;
 	u64 alloc_time_ns =3D 0;
 	struct request *rq;
 	unsigned int tag;
@@ -497,7 +498,8 @@ static struct request *__blk_mq_alloc_requests(struct=
 blk_mq_alloc_data *data)
 		data->flags |=3D BLK_MQ_REQ_NOWAIT;
=20
 retry:
-	data->ctx =3D blk_mq_get_ctx(q);
+	data->from_cpu =3D from_cpu >=3D 0 ? from_cpu : raw_smp_processor_id();
+	data->ctx =3D __blk_mq_get_ctx(q, data->from_cpu);
 	data->hctx =3D blk_mq_map_queue(data->cmd_flags, data->ctx);
=20
 	if (q->elevator) {
@@ -579,6 +581,7 @@ static struct request *blk_mq_rq_cache_fill(struct re=
quest_queue *q,
 		.rq_flags	=3D 0,
 		.nr_tags	=3D plug->nr_ios,
 		.cached_rqs	=3D &plug->cached_rqs,
+		.from_cpu	=3D -1,
 		.ctx		=3D NULL,
 		.hctx		=3D NULL
 	};
@@ -644,6 +647,7 @@ struct request *blk_mq_alloc_request(struct request_q=
ueue *q, blk_opf_t opf,
 			.cmd_flags	=3D opf,
 			.rq_flags	=3D 0,
 			.nr_tags	=3D 1,
+			.from_cpu	=3D -1,
 			.cached_rqs	=3D NULL,
 			.ctx		=3D NULL,
 			.hctx		=3D NULL
@@ -678,6 +682,7 @@ struct request *blk_mq_alloc_request_hctx(struct requ=
est_queue *q,
 		.cmd_flags	=3D opf,
 		.rq_flags	=3D 0,
 		.nr_tags	=3D 1,
+		.from_cpu	=3D -1,
 		.cached_rqs	=3D NULL,
 		.ctx		=3D NULL,
 		.hctx		=3D NULL
@@ -3012,6 +3017,7 @@ static bool blk_mq_attempt_bio_merge(struct request=
_queue *q,
 }
=20
 static struct request *blk_mq_get_new_requests(struct request_queue *q,
+					       int from_cpu,
 					       struct blk_plug *plug,
 					       struct bio *bio)
 {
@@ -3021,6 +3027,7 @@ static struct request *blk_mq_get_new_requests(stru=
ct request_queue *q,
 		.shallow_depth	=3D 0,
 		.cmd_flags	=3D bio->bi_opf,
 		.rq_flags	=3D 0,
+		.from_cpu	=3D from_cpu,
 		.nr_tags	=3D 1,
 		.cached_rqs	=3D NULL,
 		.ctx		=3D NULL,
@@ -3114,6 +3121,7 @@ void blk_mq_submit_bio(struct bio *bio)
 	struct blk_mq_hw_ctx *hctx;
 	unsigned int nr_segs;
 	struct request *rq;
+	int from_cpu =3D -1;
 	blk_status_t ret;
=20
 	/*
@@ -3175,10 +3183,17 @@ void blk_mq_submit_bio(struct bio *bio)
 	}
=20
 new_request:
-	if (rq) {
+	if (rq && (from_cpu =3D=3D -1 || from_cpu =3D=3D rq->mq_ctx->cpu)) {
 		blk_mq_use_cached_rq(rq, plug, bio);
+	} else if (rq) {
+		/*
+		 * We are not using the cached request, we know that
+		 * q_usage_counter !=3D 0 and have not yet called
+		 * bio_queue_enter(). Increase q_usage_counter.
+		 */
+		percpu_ref_get(&q->q_usage_counter);
 	} else {
-		rq =3D blk_mq_get_new_requests(q, plug, bio);
+		rq =3D blk_mq_get_new_requests(q, from_cpu, plug, bio);
 		if (unlikely(!rq)) {
 			if (bio->bi_opf & REQ_NOWAIT)
 				bio_wouldblock_error(bio);
@@ -3190,6 +3205,7 @@ void blk_mq_submit_bio(struct bio *bio)
=20
 	rq_qos_track(q, rq, bio);
=20
+	/* Transfer the ownership of the q_usage_counter increase to 'rq'. */
 	blk_mq_bio_to_request(rq, bio, nr_segs);
=20
 	ret =3D blk_crypto_rq_get_keyslot(rq);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index affb2e14b56e..52e907547b55 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -156,6 +156,7 @@ struct blk_mq_alloc_data {
 	struct rq_list *cached_rqs;
=20
 	/* input & output parameter */
+	int from_cpu;
 	struct blk_mq_ctx *ctx;
 	struct blk_mq_hw_ctx *hctx;
 };
