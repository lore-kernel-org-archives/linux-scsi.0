Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71F22E8B7A;
	Tue, 14 Oct 2025 21:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478918; cv=none; b=Gd3WqlkJo/wYy++k8P8wc8ud8yC1EUsow4FXmO8xoJU31D15uTIq0ncXXIdrS4o/FLI9TO6OYqOvaiT8O4tAYBdlZS9nDWB1chxmOQlAio5pAj6BjB1Uu1dt+/Zh2GjAMczOdj+QelgJhjwc6HSDtf0stNE3WUcdZZzIXRunoXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478918; c=relaxed/simple;
	bh=63QIMj2l/N6+b8kvO1RBuBAxjXlPpObMSb2Cbt/aahY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvqqZqiS+vvLBDqoQkyVtSThoBccRGCjAePmH9KwZtP2hjbvbisoII/N7pxNbt0W5fjtbCk1pdoJug/L3dJs/WsTntrV1VJ4BBaDVKAkKLtoxQGb2cVuiDMdBpfOQMuVXEQobhvDRavU2BEtUpzS24dNg/ROXDvxW8qH1lCwPOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SHBLsfiz; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SHBLsfiz"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmSgl6m3Gzm0yVS;
	Tue, 14 Oct 2025 21:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478914; x=1763070915; bh=xqEwE
	sIoTg4R5q2LDbXSZtPI0qahtpWfGzBBWHMqyks=; b=SHBLsfizMDkeSffxoZ2K7
	pBzYL4AYTg6FQXVoMbXnLo2u0iZF536muuuEq01P8Yylp860FyBBjXRiI7i9dIBb
	E1mN9FMAxFgnKdnD90FFSm5+CRlBuy/x33/jsdtdDhN7VKkmYlt6hLanT5aaS8PJ
	csebDqA4FT1rrugXpCc+zXl/VBUP95mrPxXw0GG7OK0J5xLXHq6Y/CL0aiO7kxrL
	ho16iEnDrrEhFK35riinAoVCEO9pFMTEqP37BI14j0mDaMxR/yRe9K8B6yUoJ8nl
	bP9DZEc1pv1lHXYYT+pxd0pfATIWhOQAXcqFGRmJNt8I9FdxCQrMWQdDvHJvCQYT
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Rx756RXOQk8D; Tue, 14 Oct 2025 21:55:14 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmSgf3BbKzm0yV3;
	Tue, 14 Oct 2025 21:55:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 04/20] blk-mq: Move the blk_queue_sq_sched() calls
Date: Tue, 14 Oct 2025 14:54:12 -0700
Message-ID: <20251014215428.3686084-5-bvanassche@acm.org>
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

Move the blk_queue_sq_sched() calls from blk_mq_run_hw_queues() and
blk_mq_delay_run_hw_queues() into blk_mq_get_sq_hctx(). Prepare for runni=
ng
all hardware queues for single-queue I/O schedulers if write pipelining i=
s
enabled. No functionality has been changed.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 28d05b8846d7..81952d0ae544 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2406,7 +2406,13 @@ EXPORT_SYMBOL(blk_mq_run_hw_queue);
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
@@ -2414,8 +2420,7 @@ static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(str=
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
@@ -2431,9 +2436,7 @@ void blk_mq_run_hw_queues(struct request_queue *q, =
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
@@ -2459,9 +2462,7 @@ void blk_mq_delay_run_hw_queues(struct request_queu=
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
