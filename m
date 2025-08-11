Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4427D2D97A1;
	Mon, 11 Aug 2025 20:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754942997; cv=none; b=emC+1eJgwylWCxuP2nn7QmZojHmgpJt+mimKl/IR94foSuxxW+7l4FT3Ke4eabbWXaEBgeSd7mBOKoImONcYo+hPQGcnkgUOnoyF+dhF6UoKH85REcdKXpEXDlzYuV8gTQtEorswPpqsKjEhRc0f1PMsU1IvszhxR9uc05q3Vbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754942997; c=relaxed/simple;
	bh=HBm1nCM3mmu7ipjzBQqTBLDrZMJdZEoFylJ8xnGzZi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcxTbtBBxSXYFZmEHKy5RVfy0Ndh5/OjZihacYkdySgWvnIPx3NwwdYC9Djc9Xiu0XSp/QluMV8ipjNJG5aQkaTwx2rUVS9ixKki15KDrn3r1sY6i3n4B2fXTSMFHXHWutFA3RIm2iC6Eu3wha+6V4kI+MMZyMo+Ks/jVbUBJcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xAS8g+6t; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xAS8g+6t"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c15Ml489szm0yVL;
	Mon, 11 Aug 2025 20:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754942994; x=1757534995; bh=/zLNi
	yePr/wLVz9pLhCNFceL/HIDn7l6WnSKXBP38Z0=; b=xAS8g+6tB5i9ZFRoX9dO+
	NNzb1qa+Uh2MbWXWWHYcDToN+DNKDlG+C9Y7Hvh4WCylJKdL/W3cPvQUu0D0yzsH
	O4+RZ4QFjjWjWsnLIt12X7+3uTLQwuF0k1aL9BdmUGei0S+64oq8fYNhqxRSsDsg
	OLsxHijHBw2te9ghWwjAP9vd8OoBXkLPRQovNPyR9Rz0g5fMeStL3Fjoz0RULLZ8
	Wtur3gFReQ7WJRjLrc9Yr9DcWtpZJUzD3vWcNEgcIKuvAIupkxEoTeviCvOjdRgy
	ZfstB7S1ElFspEI/1jOA99AxaC5ESyQhLRR8/lDVSAnfg9Rb9cdJu/qWJ6Xal9dK
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 46U0HdklCrJL; Mon, 11 Aug 2025 20:09:54 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c15Mf1XsTzm0yTR;
	Mon, 11 Aug 2025 20:09:49 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v23 04/16] blk-mq: Run all hwqs for sq scheds if write pipelining is enabled
Date: Mon, 11 Aug 2025 13:08:39 -0700
Message-ID: <20250811200851.626402-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811200851.626402-1-bvanassche@acm.org>
References: <20250811200851.626402-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

One of the optimizations in the block layer is that blk_mq_run_hw_queues(=
)
only calls blk_mq_run_hw_queue() for a single hardware queue for single
queue I/O schedulers instead of for all hardware queues. Disable this
optimization if ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING has been
set. This patch prepares for adding write pipelining support in the
mq-deadline I/O scheduler.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3d9e4b1fc5c7..fa9bfa25b920 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2383,12 +2383,23 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hc=
tx, bool async)
 EXPORT_SYMBOL(blk_mq_run_hw_queue);
=20
 /*
- * Return prefered queue to dispatch from (if any) for non-mq aware IO
- * scheduler.
+ * Return prefered queue to dispatch from for single-queue IO schedulers=
.
  */
 static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(struct request_queue *q)
 {
-	struct blk_mq_ctx *ctx =3D blk_mq_get_ctx(q);
+	struct blk_mq_hw_ctx *hctx;
+	struct blk_mq_ctx *ctx;
+
+	if (!blk_queue_sq_sched(q))
+		return NULL;
+
+	if (blk_queue_is_zoned(q) &&
+	    q->limits.features & BLK_FEAT_ORDERED_HWQ &&
+	    test_bit(ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING,
+		     &q->elevator->flags))
+		return NULL;
+
+	ctx =3D blk_mq_get_ctx(q);
 	/*
 	 * If the IO scheduler does not respect hardware queues when
 	 * dispatching, we just don't bother with multiple HW queues and
@@ -2396,7 +2407,7 @@ static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(str=
uct request_queue *q)
 	 * just causes lock contention inside the scheduler and pointless cache
 	 * bouncing.
 	 */
-	struct blk_mq_hw_ctx *hctx =3D ctx->hctxs[HCTX_TYPE_DEFAULT];
+	hctx =3D ctx->hctxs[HCTX_TYPE_DEFAULT];
=20
 	if (!blk_mq_hctx_stopped(hctx))
 		return hctx;
@@ -2413,9 +2424,7 @@ void blk_mq_run_hw_queues(struct request_queue *q, =
bool async)
 	struct blk_mq_hw_ctx *hctx, *sq_hctx;
 	unsigned long i;
=20
-	sq_hctx =3D NULL;
-	if (blk_queue_sq_sched(q))
-		sq_hctx =3D blk_mq_get_sq_hctx(q);
+	sq_hctx =3D blk_mq_get_sq_hctx(q);
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (blk_mq_hctx_stopped(hctx))
 			continue;
@@ -2441,9 +2450,7 @@ void blk_mq_delay_run_hw_queues(struct request_queu=
e *q, unsigned long msecs)
 	struct blk_mq_hw_ctx *hctx, *sq_hctx;
 	unsigned long i;
=20
-	sq_hctx =3D NULL;
-	if (blk_queue_sq_sched(q))
-		sq_hctx =3D blk_mq_get_sq_hctx(q);
+	sq_hctx =3D blk_mq_get_sq_hctx(q);
 	queue_for_each_hw_ctx(q, hctx, i) {
 		if (blk_mq_hctx_stopped(hctx))
 			continue;
