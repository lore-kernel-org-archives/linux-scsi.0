Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1DC18E25;
	Tue, 19 Nov 2024 00:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976135; cv=none; b=LQWwxarQi409gUjiDdIqyFwsTAoNhATERG5EfAt2SAsVwGFvdo8Iik5rpIoue7i8Ujk4HFxYNFGJ7FtPa5pFqG3uIQq7jm3RtammUf6Q8zDjDiEW6mOq2Fih2PkpmqQpB5NhRlUqOxu0y+X/L3dAqaG6vjZ9sVSYMh9Uv6yi298=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976135; c=relaxed/simple;
	bh=JF9Y4w5Y21BZ0tYaraMKaxOwF1n2S/yIW/HnTfzVa3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDHNmms6HsE6SFX5ix+Am5MBcilAJIDoa2hWVE6POvBVM8/5LncEGto3pqZhGB+ZFGnv9qM5qbqoqyqpo+jPyd9uQ3L42Nh2yttIOq2W3xXyFc3C+Y8RXvmkbhJHGaReQaTxkcQxuZbE5D0tc0hgv6JPs16PjR10xxOpJ9bOFP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tYTbZE/l; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tYTbZE/l"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljK4zm3zlgMVW;
	Tue, 19 Nov 2024 00:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976129; x=1734568130; bh=dpl9r
	r8l6Vc6TiIGWK8Lw33yEmOF46WSghV+C95ot2c=; b=tYTbZE/lEIbcCsVI+D7+8
	KmiZVZyGtMZxgsO5a74mROsHhk1vnUFNtvFw1lOlB9uXvxKsLIoByT1jt9u54kUm
	vz4n1USrrc4dxnG83OqqsKz3ZJv+kZyD/TOn2szuosbC4klNd2+K3IzJXWKLQpBo
	2g8Su+ffKtnaohXZAInfX9O6E9moUAut1jnj1f/xdIl+Un8s1a0TY1TPkWbIx5fF
	CHk6dcbJMFrAi+pAKuwlooA8144o+wJ9Vckbnsa7qEQ5Hrfw+jWK8NZeUdRt/hr1
	B4SUTIAgEYk5OuL6cuBmO9MPOOALywenXcZyyLZk4YR90Rh0cLny+9VYf33shS7N
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ue1ddAi4XD_O; Tue, 19 Nov 2024 00:28:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XsljD1pT7zlgVXv;
	Tue, 19 Nov 2024 00:28:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 12/26] block: Rework request allocation in blk_mq_submit_bio()
Date: Mon, 18 Nov 2024 16:28:01 -0800
Message-ID: <20241119002815.600608-13-bvanassche@acm.org>
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

Prepare for allocating a request from a specific hctx by making
blk_mq_submit_bio() allocate a request later.

The performance impact of this patch on the hot path is small: if a
request is cached, one percpu_ref_get(&q->q_usage_counter) call and one
percpu_ref_put(&q->q_usage_counter) call are added to the hot path.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 56a6b5bef39f..5ff124fbc17c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3071,11 +3071,6 @@ void blk_mq_submit_bio(struct bio *bio)
 	struct request *rq;
 	blk_status_t ret;
=20
-	/*
-	 * If the plug has a cached request for this queue, try to use it.
-	 */
-	rq =3D blk_mq_peek_cached_request(plug, q, bio->bi_opf);
-
 	/*
 	 * A BIO that was released from a zone write plug has already been
 	 * through the preparation in this function, already holds a reference
@@ -3084,26 +3079,19 @@ void blk_mq_submit_bio(struct bio *bio)
 	 */
 	if (bio_zone_write_plugging(bio)) {
 		nr_segs =3D bio->__bi_nr_segments;
-		if (rq)
-			blk_queue_exit(q);
 		goto new_request;
 	}
=20
 	bio =3D blk_queue_bounce(bio, q);
=20
 	/*
-	 * The cached request already holds a q_usage_counter reference and we
-	 * don't have to acquire a new one if we use it.
+	 * Increment the queue usage counter before performing any checks
+	 * based on queue properties that may change if the queue is frozen,
+	 * e.g. the logical block size.
 	 */
-	if (!rq) {
-		if (unlikely(bio_queue_enter(bio)))
-			return;
-	}
+	if (unlikely(bio_queue_enter(bio)))
+		return;
=20
-	/*
-	 * Device reconfiguration may change logical block size, so alignment
-	 * check has to be done with queue usage counter held
-	 */
 	if (unlikely(bio_unaligned(bio, q))) {
 		bio_io_error(bio);
 		goto queue_exit;
@@ -3123,8 +3111,15 @@ void blk_mq_submit_bio(struct bio *bio)
 		goto queue_exit;
=20
 new_request:
+	rq =3D blk_mq_peek_cached_request(plug, q, bio->bi_opf);
 	if (rq) {
 		blk_mq_use_cached_rq(rq, plug, bio);
+		/*
+		 * Here we hold two references: one because of the
+		 * bio_queue_enter() call and a second one as the result of
+		 * request allocation. Drop one.
+		 */
+		blk_queue_exit(q);
 	} else {
 		rq =3D blk_mq_get_new_requests(q, plug, bio, nr_segs);
 		if (unlikely(!rq))
@@ -3167,12 +3162,7 @@ void blk_mq_submit_bio(struct bio *bio)
 	return;
=20
 queue_exit:
-	/*
-	 * Don't drop the queue reference if we were trying to use a cached
-	 * request and thus didn't acquire one.
-	 */
-	if (!rq)
-		blk_queue_exit(q);
+	blk_queue_exit(q);
 }
=20
 #ifdef CONFIG_BLK_MQ_STACKING
