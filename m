Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511401ACEDA;
	Wed, 27 Aug 2025 21:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330229; cv=none; b=MsTwfLhX0j9BPFyyBrcz8pqIcmAUkaNsYhSfI5XByP/4iHqt3NAMsLvXwill4PrqoJ9SPxIUnzBD0Uy48g0avlmLvucpvlqYGBkxNMCz6ohj/dZIXjmzrfAQhDWlRUnWktMqkxPr0gGm+sBWqtZ4Zk3Lx/b/gy/v136rVSaOfcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330229; c=relaxed/simple;
	bh=QSLfxjEg6Hnk9pgrxIs0G6cLCB41STNV7HqN9w+gMts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaE6026AtAKJEsIAQGRUokTU5RyukB+/lt8qNSXDuLxhVKFXegQims5sE+OmYkGowQYr58InldKvInATgxD3ofZsVvsgUu6Py7gBjPCce+LDWBqBsoqGYzu7mD3cJr0pkD7/iXQwAZqv0OXv14bWwtW4XVJACCzpP5iPLXt4LCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Z7/tcc48; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Z7/tcc48"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByPH31zWzm174d;
	Wed, 27 Aug 2025 21:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330225; x=1758922226; bh=jMuf3
	ocXAzkvDM2o3MnfhOgfqP+de+h/Gmt0GCeL8P8=; b=Z7/tcc48UOOWbFpBxQFcc
	szCbB3TqTfINx+r/SrmIb15avCJQujwlTY3C1SmiOGUUuTPlNcIpsa7cdf7N8KmM
	0u7Yb4YH8LcknyCjFDNn2a3RfnEktZ6eAel2PRUcbfWK9l98QvBUtaBcY13OHHLw
	X4iLN2/Q2wkDxM1ygi2lJxVR/5BRTPaBDsciuJElAFC9SPcLIhmZGQW7paVg8RVt
	66bZTm30Gof8udIsC9K8UC3rYYIXVocdQmP94DKlKQI3zWp+uVfP8IzbT0qUra6P
	w2N8MQRU3zqI0xdq1mRv3eLoUVFVsru80jnfcBc9+GjZKui7cNvxTFgm5HVRpeQz
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TR6v7e6oQbG3; Wed, 27 Aug 2025 21:30:25 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByPB1scTzm174D;
	Wed, 27 Aug 2025 21:30:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v24 04/18] blk-mq: Move the blk_queue_sq_sched() calls
Date: Wed, 27 Aug 2025 14:29:23 -0700
Message-ID: <20250827212937.2759348-5-bvanassche@acm.org>
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

Prepare for running all hardware queues for single-queue I/O schedulers
if write pipelining is enabled. No functionality has been changed.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7f43138f8a09..e2d3239aacbc 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2392,7 +2392,13 @@ EXPORT_SYMBOL(blk_mq_run_hw_queue);
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
+	ctx =3D blk_mq_get_ctx(q);
 	/*
 	 * If the IO scheduler does not respect hardware queues when
 	 * dispatching, we just don't bother with multiple HW queues and
@@ -2400,8 +2406,7 @@ static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(str=
uct request_queue *q)
 	 * just causes lock contention inside the scheduler and pointless cache
 	 * bouncing.
 	 */
-	struct blk_mq_hw_ctx *hctx =3D ctx->hctxs[HCTX_TYPE_DEFAULT];
-
+	hctx =3D ctx->hctxs[HCTX_TYPE_DEFAULT];
 	if (!blk_mq_hctx_stopped(hctx))
 		return hctx;
 	return NULL;
@@ -2417,9 +2422,7 @@ void blk_mq_run_hw_queues(struct request_queue *q, =
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
@@ -2445,9 +2448,7 @@ void blk_mq_delay_run_hw_queues(struct request_queu=
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
