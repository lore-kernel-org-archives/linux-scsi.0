Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D4B23ED69;
	Tue,  8 Jul 2025 22:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012478; cv=none; b=pP7dk2TjDTHrt5Qrf0dkgkGVdGOABh23ogkNpq5nRKV/cvIKofagV2QHXqZ0MuvaQOElPRS2sKduSAEKfm0cAPYwxJGZazsP+j+90/qZcP+WLcnGunowW3x7Zihj5d0CJm7KOKTyijOOCDLeaJWXweLlA0cYNuKfkxX5b5JK49k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012478; c=relaxed/simple;
	bh=5Uc21a1zTcc+QbM+dkXJ/gKtDvj880U2kS/ztnJDTzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUyH4PGFExe1p/H0kcxDJY9gyekplLFanbQN6PEJWLv+R3j3BQv0lK1mm5nX8bdfHSgPeyB5YfjQScBRcRtx/l4bgBFr2/YO6BZDxFzPsLrYZolXfNJ3gVW+Z50foGGZXU477hHJDs2HBREiSqFxylvnmQ215rjqx5iKlvQiIe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2Kzc9Aeg; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2Kzc9Aeg"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bcFbc02SYzltKGK;
	Tue,  8 Jul 2025 22:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752012474; x=1754604475; bh=w0l9b
	SMloZCkX71dfFubC77PSL5v7PUFdiWMO9W+X1I=; b=2Kzc9Aeg6co1BQcG4P+pz
	uKCO6Z7RmdCBEbVybwJXnFFlZIQWZ2uho5HtoK1ZMKtcSNfdKTHQ5ZpSCrBgb93s
	8XY1d1DLbXmPgJBBX94O2wpkU4vUsYuMHV0pR3OOefDxJo2ob+VB9yF3efv1hSEQ
	m4Q9j+PJ9Sqe634XTqHZcF9xzALuRQoD1reuLoQaD70CZtbfwKu9k6og5OExA+IZ
	RKXccnik9UUT2opfiFnNpDyBUYtyGXeA5G525Uo9+N5XIYI+XHleHQ/pFPengGPH
	ZhWmxDeKxRKiqODsuRuL62/mJvmKm+i2G7YSjkw8IGxTUUwZLfIM1fgl1tP8RxG/
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gAuEMwadQqaf; Tue,  8 Jul 2025 22:07:54 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bcFbV6BV4zlgqVk;
	Tue,  8 Jul 2025 22:07:50 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v20 03/13] blk-zoned: Add an argument to blk_zone_plug_bio()
Date: Tue,  8 Jul 2025 15:07:00 -0700
Message-ID: <20250708220710.3897958-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250708220710.3897958-1-bvanassche@acm.org>
References: <20250708220710.3897958-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Software that submits zoned writes, e.g. a filesystem, may submit zoned
writes from multiple CPUs as long as the zoned writes are serialized per
zone. Submitting bios from different CPUs may cause bio reordering if
e.g. different bios reach the storage device through different queues.
Prepare for preserving the order of pipelined zoned writes per zone by
adding the 'rq_cpu` argument to blk_zone_plug_bio(). This argument tells
blk_zone_plug_bio() from which CPU a cached request has been allocated.
The cached request will only be used if it matches the CPU from which
zoned writes are being submitted for the zone associated with the bio.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c         | 10 ++++++----
 block/blk-zoned.c      |  5 ++++-
 drivers/md/dm.c        |  5 ++---
 include/linux/blkdev.h |  5 +++--
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index aa81526ad531..c02cf4140717 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3133,11 +3133,14 @@ void blk_mq_submit_bio(struct bio *bio)
 	unsigned int nr_segs;
 	struct request *rq;
 	blk_status_t ret;
+	int rq_cpu =3D -1;
=20
 	/*
 	 * If the plug has a cached request for this queue, try to use it.
 	 */
 	rq =3D blk_mq_peek_cached_request(plug, q, bio->bi_opf);
+	if (rq)
+		rq_cpu =3D rq->mq_ctx->cpu;
=20
 	/*
 	 * A BIO that was released from a zone write plug has already been
@@ -3187,10 +3190,9 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
 		goto queue_exit;
=20
-	if (bio_needs_zone_write_plugging(bio)) {
-		if (blk_zone_plug_bio(bio, nr_segs))
-			goto queue_exit;
-	}
+	if (bio_needs_zone_write_plugging(bio) &&
+	    blk_zone_plug_bio(bio, nr_segs, rq_cpu))
+		goto queue_exit;
=20
 new_request:
 	if (rq) {
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index efe71b1a1da1..3f285e372460 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1104,6 +1104,9 @@ static void blk_zone_wplug_handle_native_zone_appen=
d(struct bio *bio)
  * blk_zone_plug_bio - Handle a zone write BIO with zone write plugging
  * @bio: The BIO being submitted
  * @nr_segs: The number of physical segments of @bio
+ * @rq_cpu: software queue onto which a request will be queued. -1 if th=
e caller
+ *	has not yet decided onto which software queue to queue the request or=
 if
+ *	the bio won't be converted into a request.
  *
  * Handle write, write zeroes and zone append operations requiring emula=
tion
  * using zone write plugging.
@@ -1112,7 +1115,7 @@ static void blk_zone_wplug_handle_native_zone_appen=
d(struct bio *bio)
  * write plug. Otherwise, return false to let the submission path proces=
s
  * @bio normally.
  */
-bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
+bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs, int rq_cpu=
)
 {
 	struct block_device *bdev =3D bio->bi_bdev;
=20
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ca889328fdfe..5033af6d687c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1814,9 +1814,8 @@ static inline bool dm_zone_bio_needs_split(struct m=
apped_device *md,
=20
 static inline bool dm_zone_plug_bio(struct mapped_device *md, struct bio=
 *bio)
 {
-	if (!bio_needs_zone_write_plugging(bio))
-		return false;
-	return blk_zone_plug_bio(bio, 0);
+	return bio_needs_zone_write_plugging(bio) &&
+		blk_zone_plug_bio(bio, 0, -1);
 }
=20
 static blk_status_t __send_zone_reset_all_emulated(struct clone_info *ci=
,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4dec1d91b7f2..3cdb4f7c602d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -896,7 +896,7 @@ static inline bool bio_needs_zone_write_plugging(stru=
ct bio *bio)
 	}
 }
=20
-bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs);
+bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs, int rq_cpu=
);
=20
 /**
  * disk_zone_capacity - returns the zone capacity of zone containing @se=
ctor
@@ -931,7 +931,8 @@ static inline bool bio_needs_zone_write_plugging(stru=
ct bio *bio)
 	return false;
 }
=20
-static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_se=
gs)
+static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_se=
gs,
+				     int rq_cpu)
 {
 	return false;
 }
