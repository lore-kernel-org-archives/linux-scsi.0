Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B554E221F39;
	Mon, 16 Jun 2025 22:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750113252; cv=none; b=fdFgDcydsH9E/UBrsRR+uhmalNYUTBRJhoXtFOcQsDL9XOIM8drrN6OvF+T61EzOKN8kuLIZrHUtyw1iNmnsj+luzgeKYhAcVUnem6EKa31DAaPcr1sDwX2pzQ3YyLgnuAwHfzRpE2wvTKcboLPCYQiognrq6HcfuPy9ypULf+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750113252; c=relaxed/simple;
	bh=WkspTtZktCrVVhYMViyuXOzCPzrEE+4QyKqMe0hyo8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pF/tZc8xMOAVCfxh8zd4/iY4qEuoo6OnVTWiuCttjMtQ+orizgJq7HZZgoHXqJC+e+ATYxAWSfrtjSr/prUHmhRjMMd/TpvigavFW3/5AQDpYai7nQ/DfOTc9T31huTBE1C7N23p7Z8OSQ6Yf5DAcC9IvftEDFwb/J3nFGep/tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4jPPS6F+; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4jPPS6F+"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bLlD15WThzlgqxn;
	Mon, 16 Jun 2025 22:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1750113248; x=1752705249; bh=NDbe3
	yo4MseCqIsSuJwry3J82K0MgPm+dnsCV0z82NI=; b=4jPPS6F+Z/6a03CIobuYC
	FyF626RXcHp8idwf3Fk+VEBiWOv6ZPX//Lk4CgjPhzD2ULaqWx5qRNAspVqVHgaE
	606E84zJR7cE0ae6NnuZIXz2+YL2MytqMBfhzyMzsbTUjKLi/nY9NXjiHh6XV5Hr
	ZSrJx7hlmc/b+3M0tyVlFJ/MiKLTWcXnojukOSbiZRr+uYP4XWhZGCQU2f24uPub
	uU61o2oaCFqLuGE/xvYpIeeqeL/sX4/PlB8VScX+uRydRXUUTEbN2O17mphJMkjo
	8MxCk04dOt2gevS9z18DtsuxGtW/JBhxM4BIONUEnsa5fKLqBsCk5mxMIba4zOn3
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id a5HpaHXybln9; Mon, 16 Jun 2025 22:34:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bLlCw38khzlgqVx;
	Mon, 16 Jun 2025 22:34:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v18 02/12] block: Rework request allocation in blk_mq_submit_bio()
Date: Mon, 16 Jun 2025 15:33:02 -0700
Message-ID: <20250616223312.1607638-3-bvanassche@acm.org>
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

Prepare for allocating a request from a specific hctx by making
blk_mq_submit_bio() allocate a request later.

The performance impact of this patch on the hot path is small: if a
request is cached, one percpu_ref_get(&q->q_usage_counter) call and one
percpu_ref_put(&q->q_usage_counter) call are added to the hot path.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4806b867e37d..b22b56042e91 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3116,11 +3116,6 @@ void blk_mq_submit_bio(struct bio *bio)
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
@@ -3129,19 +3124,11 @@ void blk_mq_submit_bio(struct bio *bio)
 	 */
 	if (bio_zone_write_plugging(bio)) {
 		nr_segs =3D bio->__bi_nr_segments;
-		if (rq)
-			blk_queue_exit(q);
 		goto new_request;
 	}
=20
-	/*
-	 * The cached request already holds a q_usage_counter reference and we
-	 * don't have to acquire a new one if we use it.
-	 */
-	if (!rq) {
-		if (unlikely(bio_queue_enter(bio)))
-			return;
-	}
+	if (unlikely(bio_queue_enter(bio)))
+		return;
=20
 	/*
 	 * Device reconfiguration may change logical block size or reduce the
@@ -3173,8 +3160,15 @@ void blk_mq_submit_bio(struct bio *bio)
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
 		rq =3D blk_mq_get_new_requests(q, plug, bio);
 		if (unlikely(!rq)) {
@@ -3220,12 +3214,7 @@ void blk_mq_submit_bio(struct bio *bio)
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
