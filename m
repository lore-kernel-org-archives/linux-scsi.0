Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9042E8DF0;
	Mon, 30 Jun 2025 22:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322653; cv=none; b=ZHKEr/YtwIslmy/I81qyEp9MzBQqupIberZDtWK0D8iE3A09geU13UeEnVRFw+/u+V85+6HL/OpVlsxo0xHmAzEAonmuH58zs4vs+TImXtsrV7kEKLRtNuebanjJLnVWPmISbq249ZOPR9fpqfTh3/KN8jkBWq8LyZrWUAdWdTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322653; c=relaxed/simple;
	bh=KdX9cLUfgM6frLm7SJng/TUBkQvhSUKjfg9Y9AnuFWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkGUud1P2NkmscXcbrm8f8gX3KWW09MGH3kgMzEO4jIninaGrxD3rCUQ9kBOAAv8YBs/AUwSAOPF+PwXuLOJzKSsIzj++LS9U9SJkJRy4TJPhAmyUMx97pozzwFcyEReVyUEVic3gEw3eNmobn8VyQr5UGiHHT6V1Op1HEIgXPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HZ9FQUO3; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HZ9FQUO3"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bWLTl03N8zm0bfy;
	Mon, 30 Jun 2025 22:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1751322649; x=1753914650; bh=oFNxZ
	UCBGIQmIDYLY5q6YPBaXjSdbY5bb2a2ffrdkVI=; b=HZ9FQUO3DKf1Jtp392MjH
	P/DMEm1PC8qjqeGXBVHC01j/SsCdiT029LuQYyv/NEryn9wQsnGzfhBSI4ogxzNc
	nbsptYTySQzR72MwmyB7AA9wz/rpyeELpffNsRp5R8unJ8MYaU3f20PejUslyD1I
	RhAhxMPqy7q/9ulc294uaBQvT6faFWRpOWOf3IzYCL0HQfdLmjpGvDmWIkuB21xF
	G5IxzNgoPEXoaQZJKfSFbPFQhBZuLoLmKBslvOaHYTY6HvjytOdLt+0J83uObKSY
	5Z4jf/I22vgeL8UkLNUMKz2JtXMxNn8H8e1bvjl8IGOIV5NZV426E13He3x2nbEa
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oIhyI1asSFXs; Mon, 30 Jun 2025 22:30:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bWLTf01DXzm0c30;
	Mon, 30 Jun 2025 22:30:45 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v19 04/11] blk-zoned: Add an argument to blk_zone_plug_bio()
Date: Mon, 30 Jun 2025 15:29:56 -0700
Message-ID: <20250630223003.2642594-5-bvanassche@acm.org>
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

Zoned writes may be submitted from multiple CPUs as long as these are
serialized per zone. Prepare for preserving the order of pipelined zoned
writes per zone by adding the 'from_cpu` argument to blk_zone_plug_bio().
This argument will be used to preserve the write order per zone by
submitting all zoned writes per zone from the same CPU as long as any
zoned writes are pending for that zone.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c         | 7 +++----
 block/blk-zoned.c      | 4 +++-
 drivers/md/dm.c        | 5 ++---
 include/linux/blkdev.h | 5 +++--
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7935f6adda71..34304b6ac29e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3195,10 +3195,9 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
 		goto queue_exit;
=20
-	if (bio_needs_zone_write_plugging(bio)) {
-		if (blk_zone_plug_bio(bio, nr_segs))
-			goto queue_exit;
-	}
+	if (bio_needs_zone_write_plugging(bio) &&
+	    blk_zone_plug_bio(bio, nr_segs, &from_cpu))
+		goto queue_exit;
=20
 new_request:
 	if (rq && (from_cpu =3D=3D -1 || from_cpu =3D=3D rq->mq_ctx->cpu)) {
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index efe71b1a1da1..91a59bf54547 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1104,6 +1104,8 @@ static void blk_zone_wplug_handle_native_zone_appen=
d(struct bio *bio)
  * blk_zone_plug_bio - Handle a zone write BIO with zone write plugging
  * @bio: The BIO being submitted
  * @nr_segs: The number of physical segments of @bio
+ * @from_cpu: [out] CPU of the software queue to which the bio should be
+ *	queued
  *
  * Handle write, write zeroes and zone append operations requiring emula=
tion
  * using zone write plugging.
@@ -1112,7 +1114,7 @@ static void blk_zone_wplug_handle_native_zone_appen=
d(struct bio *bio)
  * write plug. Otherwise, return false to let the submission path proces=
s
  * @bio normally.
  */
-bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
+bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs, int *from_=
cpu)
 {
 	struct block_device *bdev =3D bio->bi_bdev;
=20
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ca889328fdfe..76c5eada7d03 100644
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
+		blk_zone_plug_bio(bio, 0, NULL);
 }
=20
 static blk_status_t __send_zone_reset_all_emulated(struct clone_info *ci=
,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aa1990d94130..46fe8d97b31f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -891,7 +891,7 @@ static inline bool bio_needs_zone_write_plugging(stru=
ct bio *bio)
 	}
 }
=20
-bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs);
+bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs, int *from_=
cpu);
=20
 /**
  * disk_zone_capacity - returns the zone capacity of zone containing @se=
ctor
@@ -926,7 +926,8 @@ static inline bool bio_needs_zone_write_plugging(stru=
ct bio *bio)
 	return false;
 }
=20
-static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_se=
gs)
+static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_se=
gs,
+				     int *from_cpu)
 {
 	return false;
 }
