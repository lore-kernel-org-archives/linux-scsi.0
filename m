Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332D4223DD5;
	Mon, 16 Jun 2025 22:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750113257; cv=none; b=SyqMyxAgCu9ud1spjXI9SLt/AYYs9vrM3tiOLicf+/a4KlGsRIfL1SBA5JQW9G8z1/mHH0HRLqZOznM/2Ww22/Cz1z55KbxIakdP7LwAcVW/LvqoDQ+A9YeejdcarF7l0+TrgLJ4g71EZWrQdFiECSXaa1ENnSISpKjst+9rmRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750113257; c=relaxed/simple;
	bh=oB+FK6wc34qj/05XQvy9U02kNtN4u4syv+paBEBkuLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmJFcr83zSolMbG5X31RYZm8f9H8LYRsC2+D6XDGU2oj42SGuucNbPEHwyTRXAKqjz6z7trprJjIrRXof5Fiarv2vOpyjY4wjGiHfJRY8DG4pD/F1tASjgE4m4GoUORu3BMhbFWxUdzaMogXhjjmPqawNTszqaMgxCWbEpyKlRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ydmj6C+h; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ydmj6C+h"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bLlD65BBszlgqxn;
	Mon, 16 Jun 2025 22:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1750113253; x=1752705254; bh=VPQ7Z
	DSVFj8W8B/TtqF1oUfcWbdyfa+IDng6PBfMreU=; b=Ydmj6C+hOA2Qf/2THz5qk
	URZyeFTTVQ4gtWa1MPv6tsusezRnDVxruB17cCWVFig7IgHPV0NorCq01/DhZDvp
	hngTx+qOiaqH0FwQL8pqhLPyLJU69QTtsCumexIFz1Mo2/okG2mwJoRxVMpzdEZB
	7RCpmO9FD4YD2XzAVjMwpz/QSD4QpXCDYQuruHQmsvoDLJsp3mIieOShk9cXbo2N
	JCxOU2DvQ5kFLUHOTTiw2hWSaPkye5kbmhJt52afwaOx3eclkPYjZ1n5Bt0+6wnv
	xzEp8mxFzKHxeOMrZJzi2Ijo1PId3s/B9m6p1lNT8z1tpOONnj901tkrov8iLM6P
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3ivdfYr48WcO; Mon, 16 Jun 2025 22:34:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bLlD12BbHzlgqVy;
	Mon, 16 Jun 2025 22:34:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v18 03/12] block: Support allocating from a specific software queue
Date: Mon, 16 Jun 2025 15:33:03 -0700
Message-ID: <20250616223312.1607638-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
In-Reply-To: <20250616223312.1607638-1-bvanassche@acm.org>
References: <20250616223312.1607638-1-bvanassche@acm.org>
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
 block/blk-mq.c | 18 ++++++++++++++----
 block/blk-mq.h |  1 +
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b22b56042e91..9dab1caf750a 100644
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
@@ -3046,7 +3053,7 @@ static struct request *blk_mq_get_new_requests(stru=
ct request_queue *q,
  * Check if there is a suitable cached request and return it.
  */
 static struct request *blk_mq_peek_cached_request(struct blk_plug *plug,
-		struct request_queue *q, blk_opf_t opf)
+		struct request_queue *q, int from_cpu, blk_opf_t opf)
 {
 	enum hctx_type type =3D blk_mq_get_hctx_type(opf);
 	struct request *rq;
@@ -3056,6 +3063,8 @@ static struct request *blk_mq_peek_cached_request(s=
truct blk_plug *plug,
 	rq =3D rq_list_peek(&plug->cached_rqs);
 	if (!rq || rq->q !=3D q)
 		return NULL;
+	if (from_cpu >=3D 0 && rq->mq_ctx->cpu !=3D from_cpu)
+		return NULL;
 	if (type !=3D rq->mq_hctx->type &&
 	    (type !=3D HCTX_TYPE_READ || rq->mq_hctx->type !=3D HCTX_TYPE_DEFAU=
LT))
 		return NULL;
@@ -3114,6 +3123,7 @@ void blk_mq_submit_bio(struct bio *bio)
 	struct blk_mq_hw_ctx *hctx;
 	unsigned int nr_segs;
 	struct request *rq;
+	int from_cpu =3D -1;
 	blk_status_t ret;
=20
 	/*
@@ -3160,7 +3170,7 @@ void blk_mq_submit_bio(struct bio *bio)
 		goto queue_exit;
=20
 new_request:
-	rq =3D blk_mq_peek_cached_request(plug, q, bio->bi_opf);
+	rq =3D blk_mq_peek_cached_request(plug, q, from_cpu, bio->bi_opf);
 	if (rq) {
 		blk_mq_use_cached_rq(rq, plug, bio);
 		/*
@@ -3170,7 +3180,7 @@ void blk_mq_submit_bio(struct bio *bio)
 		 */
 		blk_queue_exit(q);
 	} else {
-		rq =3D blk_mq_get_new_requests(q, plug, bio);
+		rq =3D blk_mq_get_new_requests(q, from_cpu, plug, bio);
 		if (unlikely(!rq)) {
 			if (bio->bi_opf & REQ_NOWAIT)
 				bio_wouldblock_error(bio);
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
