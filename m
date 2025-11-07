Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44D2207A22;
	Fri,  7 Nov 2025 23:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559639; cv=none; b=t1QsKROM+YPXJOg/Karrr7yfKdH9b8zijy7RCvSJSRZkU1KWaB41Y6ueTwLZQWVtBFdm6XovV+v8lbSBgSXvBoc1N55xRbTUrw4CR4zIvi2tLd/SoZxSybbOTVKCqFj0Mzq2dg6TAIk1OGxb8wf8tVyfSpz7n+RM6qzd8TKrQOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559639; c=relaxed/simple;
	bh=wtlBacsE+Gk4wElCpxF0/50Xb/iuSlvwddHOrfTAqIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkGa3SeC+1lFbhtbNLu0aJE5lWRVwGp8QUiV+51phfwOrbRzyQRT3fa29duhpmDxTpRzSQdL3x8OkvjILyoZZUGuYBj0azy6R6TAt/9mQIVb0KlrEO/XwCytO+KSQnHbb2k42oFapKkeSQe5DeYNle+lGUxth4rMnbMbkocsnm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cnnW9z02; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cnnW9z02"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d3G9d0tgMzm17wv;
	Fri,  7 Nov 2025 23:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1762559635; x=1765151636; bh=j2fl4
	6B6jYNqWLGzclp/63mlZM+y/r9XcNHAQlTmcvs=; b=cnnW9z02iwWGNXwU1cOdF
	FlhKvIbjqggORlfnES1q8N5xNJCNGdY0vNd5lOn8rruROcMwShEOWEmTYEoRNref
	g49FvmNDPvZv8oaQQBmmZyFDDAFUfpxOVXWXyoX18Ry+q9DvIyeTEsfPuOyeEeGN
	ySvM+HygX9XbHCaAOq0NJ2120o6B+sfB/JomJ+75DE88lQYtvzuibS/1KvGjyVUQ
	moa++kiWaunje0qVztwijOSOaVs8B2cXmC/JxHiueql6xC1xogTkSCVURJDgAGxl
	m+IklQEysw0yGgPLeMoZKKI4EzcOx8Q8XvJL0aADojE2CdAtrMoBgETAKZ6qj/LR
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2TmNll6Jhv_A; Fri,  7 Nov 2025 23:53:55 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d3G9W6jHJzm17wj;
	Fri,  7 Nov 2025 23:53:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v26 06/17] blk-zoned: Add an argument to blk_zone_plug_bio()
Date: Fri,  7 Nov 2025 15:52:59 -0800
Message-ID: <20251107235310.2098676-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107235310.2098676-1-bvanassche@acm.org>
References: <20251107235310.2098676-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Software that submits zoned writes, e.g. a filesystem, may submit zoned
writes from multiple CPU cores as long as the zoned writes are serialized
per zone. Submitting bios from different CPUs may cause bio reordering if
e.g. different bios reach the storage device through different queues.
Prepare for preserving the order of pipelined zoned writes per zone by
adding the 'rq_cpu` argument to blk_zone_plug_bio(). This argument tells
blk_zone_plug_bio() from which CPU a cached request has been allocated.
The cached request will only be used if it matches the CPU from which
zoned writes are being submitted for the zone associated with the bio.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c         | 7 +++----
 block/blk-zoned.c      | 5 ++++-
 drivers/md/dm.c        | 5 ++---
 include/linux/blkdev.h | 5 +++--
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 19857d2047cb..2ff46ef97917 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3236,10 +3236,9 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
 		goto queue_exit;
=20
-	if (bio_needs_zone_write_plugging(bio)) {
-		if (blk_zone_plug_bio(bio, nr_segs))
-			goto queue_exit;
-	}
+	if (bio_needs_zone_write_plugging(bio) &&
+	    blk_zone_plug_bio(bio, nr_segs, rq ? rq->mq_ctx->cpu : -1))
+		goto queue_exit;
=20
 new_request:
 	if (rq) {
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 57ab2b365c2d..b14604d9d7bd 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1560,6 +1560,9 @@ static bool blk_zone_wplug_handle_zone_mgmt(struct =
bio *bio)
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
@@ -1568,7 +1571,7 @@ static bool blk_zone_wplug_handle_zone_mgmt(struct =
bio *bio)
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
index f5e5e59b232b..b75b296aa79b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1802,9 +1802,8 @@ static inline bool dm_zone_bio_needs_split(struct b=
io *bio)
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
index f18523e841a4..5d9c110aacd3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -925,7 +925,7 @@ static inline bool bio_needs_zone_write_plugging(stru=
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
@@ -973,7 +973,8 @@ static inline bool bio_needs_zone_write_plugging(stru=
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
