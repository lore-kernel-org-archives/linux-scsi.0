Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147AC1CA81;
	Tue, 19 Nov 2024 00:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976137; cv=none; b=n9gRfcoa/kf+zXo83tQ5P1exnIHniC+5co7K/gXhWRfvIKUSmevKvnEW/uorq20UxSZ1dbDnzZc3wO3EE19biEZgvJ8j88cUHDcDVcDc7XZuHWzFB4JP2lyePC9FRmauq1v9umtHZzXuyLL+B817oCgi0FSAT56GMyCLOItZxD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976137; c=relaxed/simple;
	bh=rKdB9eAJuqecXPJ1Ip+TFvZjsbRzDHsvQKGOfrBPXSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAL+WzIoq3arpWvsVUoX7BLEgGqtVeZGWBxUu7HZqqI9DASP3WudUjuaGD714u8yfySe0WPbJEw9cb6n6G6m9zmR7LquxYneAVQdkHNGSmj2J8R/i0hZQGXYxtP8fJieyMny64vL1UqbifZw62sje36OAFAtMpI1NlZH7IhNUCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nVWwhhCA; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nVWwhhCA"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljM5slyzlgMVX;
	Tue, 19 Nov 2024 00:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976131; x=1734568132; bh=mRFhE
	hPfN0g3PDtdjUeIsCcBOXYtmEpeE7xYsQ1hmxs=; b=nVWwhhCAwcKDxDG+iQNRU
	zgerqZrXl5obg1jAvS5PXpKE37mGFGYuM9xrauFZtSHSq8kAm4mouqUnkTu/lslh
	HPtWjjKQq6qBr6C/Hg/FOqm4jB+wri1xn7hASjj8YZIkT3uee/glrGpYenf1DXLe
	4H2asKTfoa/YlfSXcIk8ZfUVtk3c5+VhHngDUQl63zTDwPvMAzO89bIyIPRiB4k+
	uthqW93F0atMQsXI09Gdj+i6AJ4K1pq+iW2SFVpdHC7tfrMe9eFgyTihqHL60kr2
	jSO1vor6Hl6wNMYM5R+n33vKmhylQYwgFrCLp1oINiVaSW5Vd9EF2gOaRgy8UElR
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8O4LOpz5ytuX; Tue, 19 Nov 2024 00:28:51 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XsljF68b2zlgT1M;
	Tue, 19 Nov 2024 00:28:49 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 13/26] block: Support allocating from a specific software queue
Date: Mon, 18 Nov 2024 16:28:02 -0800
Message-ID: <20241119002815.600608-14-bvanassche@acm.org>
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

A later patch will preserve the order of pipelined zoned writes by
submitting all zoned writes per zone to the same queue as previously
submitted zoned writes. Hence support allocating a request from a
specific queue.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c | 18 ++++++++++++++----
 block/blk-mq.h |  1 +
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5ff124fbc17c..f134d5e1c4a1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -493,6 +493,7 @@ __blk_mq_alloc_requests_batch(struct blk_mq_alloc_dat=
a *data)
 static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data =
*data)
 {
 	struct request_queue *q =3D data->q;
+	int swq_cpu =3D data->swq_cpu;
 	u64 alloc_time_ns =3D 0;
 	struct request *rq;
 	unsigned int tag;
@@ -505,7 +506,8 @@ static struct request *__blk_mq_alloc_requests(struct=
 blk_mq_alloc_data *data)
 		data->flags |=3D BLK_MQ_REQ_NOWAIT;
=20
 retry:
-	data->ctx =3D blk_mq_get_ctx(q);
+	data->swq_cpu =3D swq_cpu >=3D 0 ? swq_cpu : raw_smp_processor_id();
+	data->ctx =3D __blk_mq_get_ctx(q, data->swq_cpu);
 	data->hctx =3D blk_mq_map_queue(q, data->cmd_flags, data->ctx);
=20
 	if (q->elevator) {
@@ -585,6 +587,7 @@ static struct request *blk_mq_rq_cache_fill(struct re=
quest_queue *q,
 		.cmd_flags	=3D opf,
 		.nr_tags	=3D plug->nr_ios,
 		.cached_rqs	=3D &plug->cached_rqs,
+		.swq_cpu	=3D -1,
 	};
 	struct request *rq;
=20
@@ -646,6 +649,7 @@ struct request *blk_mq_alloc_request(struct request_q=
ueue *q, blk_opf_t opf,
 			.flags		=3D flags,
 			.cmd_flags	=3D opf,
 			.nr_tags	=3D 1,
+			.swq_cpu	=3D -1,
 		};
 		int ret;
=20
@@ -2969,12 +2973,14 @@ static bool blk_mq_attempt_bio_merge(struct reque=
st_queue *q,
 }
=20
 static struct request *blk_mq_get_new_requests(struct request_queue *q,
+					       int swq_cpu,
 					       struct blk_plug *plug,
 					       struct bio *bio,
 					       unsigned int nsegs)
 {
 	struct blk_mq_alloc_data data =3D {
 		.q		=3D q,
+		.swq_cpu	=3D swq_cpu,
 		.nr_tags	=3D 1,
 		.cmd_flags	=3D bio->bi_opf,
 	};
@@ -3001,7 +3007,8 @@ static struct request *blk_mq_get_new_requests(stru=
ct request_queue *q,
  * Check if there is a suitable cached request and return it.
  */
 static struct request *blk_mq_peek_cached_request(struct blk_plug *plug,
-		struct request_queue *q, blk_opf_t opf)
+						  struct request_queue *q,
+						  int swq_cpu, blk_opf_t opf)
 {
 	enum hctx_type type =3D blk_mq_get_hctx_type(opf);
 	struct request *rq;
@@ -3011,6 +3018,8 @@ static struct request *blk_mq_peek_cached_request(s=
truct blk_plug *plug,
 	rq =3D rq_list_peek(&plug->cached_rqs);
 	if (!rq || rq->q !=3D q)
 		return NULL;
+	if (swq_cpu >=3D 0 && rq->mq_ctx->cpu !=3D swq_cpu)
+		return NULL;
 	if (type !=3D rq->mq_hctx->type &&
 	    (type !=3D HCTX_TYPE_READ || rq->mq_hctx->type !=3D HCTX_TYPE_DEFAU=
LT))
 		return NULL;
@@ -3069,6 +3078,7 @@ void blk_mq_submit_bio(struct bio *bio)
 	struct blk_mq_hw_ctx *hctx;
 	unsigned int nr_segs;
 	struct request *rq;
+	int swq_cpu =3D -1;
 	blk_status_t ret;
=20
 	/*
@@ -3111,7 +3121,7 @@ void blk_mq_submit_bio(struct bio *bio)
 		goto queue_exit;
=20
 new_request:
-	rq =3D blk_mq_peek_cached_request(plug, q, bio->bi_opf);
+	rq =3D blk_mq_peek_cached_request(plug, q, swq_cpu, bio->bi_opf);
 	if (rq) {
 		blk_mq_use_cached_rq(rq, plug, bio);
 		/*
@@ -3121,7 +3131,7 @@ void blk_mq_submit_bio(struct bio *bio)
 		 */
 		blk_queue_exit(q);
 	} else {
-		rq =3D blk_mq_get_new_requests(q, plug, bio, nr_segs);
+		rq =3D blk_mq_get_new_requests(q, swq_cpu, plug, bio, nr_segs);
 		if (unlikely(!rq))
 			goto queue_exit;
 	}
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 89a20fffa4b1..309db553aba6 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -158,6 +158,7 @@ struct blk_mq_alloc_data {
 	struct rq_list *cached_rqs;
=20
 	/* input & output parameter */
+	int swq_cpu;
 	struct blk_mq_ctx *ctx;
 	struct blk_mq_hw_ctx *hctx;
 };
