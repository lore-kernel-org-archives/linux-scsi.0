Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0962264CD;
	Thu, 17 Jul 2025 20:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752785928; cv=none; b=fh4A02j0CnHrk0ns18O5ZGbVWKb60cUbIL24KhwJQPAwRLYbF/7xjZNFyfbNa7cBYFplphj9vIqAbsHAV6NJmJ7qNwBtVSU57uWeevU6E9ibkZGru3R7vtKESWVH0Ad4/Isns2vwQVR6KOSI2+GFx2TcBQphyo3JjGxeyj/oFOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752785928; c=relaxed/simple;
	bh=5aKNrr3hQR611zjQ6h8pB04uR8ErCwRihXhWTJyDpw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WP9slUCY9yFZ3U7j4UFXzrGw0G0RAUNjr/tfdVt3yrmmK3Up5Su+seWx2I2I0UBpv+zSPhhsOa5T1/lhjYY6rHdMuEAqcy2rOOApOwNgfLcBsYAdXlksknOZyCDSB9eJ4fRG8iGZGfMu0hgIJsjKnSpiluRTR6IIECsIX0yddWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Aytv5HTT; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Aytv5HTT"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bjldd6zx2zm0yTN;
	Thu, 17 Jul 2025 20:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752785924; x=1755377925; bh=HaTP4
	RMwTkR9Z8H4LYpKE6njCelfLmnoEKYyYS48LQc=; b=Aytv5HTTSXFrpwBFLzuUY
	O5Dq+81bq+hcMBcu6vTAVyxbAHYjSYdwI42Wz46NeoGAfcAarWWrbd13Na8ZW5GP
	y/uI2LlSjr6MrC03nt7UMgfCnSLGfKA7aqgTwS84+jPMNUXvd35eZvnNm1Qa4AWF
	n0hpjcKd+iO/PUSzdW3+TDfQrdvdLjbqIa8sb/8Q8eePR7JgoPHj4obI1eh6uEEB
	ucKSUiVQAHAllqJdg1V+0ns+hNEk14Aa5N+5Y9WxGm2aDzXu4K+6zyUPKGsa9Ts2
	Go9U2wKpCA6TA1ED0YD7p/n3xAHhH0kKsb55r8sS0iVbJ48+aPFR5VChbndHnjYM
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IiSSxAnzjmUr; Thu, 17 Jul 2025 20:58:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bjldW4KpBzm0ysn;
	Thu, 17 Jul 2025 20:58:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v21 03/12] blk-zoned: Add an argument to blk_zone_plug_bio()
Date: Thu, 17 Jul 2025 13:57:59 -0700
Message-ID: <20250717205808.3292926-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250717205808.3292926-1-bvanassche@acm.org>
References: <20250717205808.3292926-1-bvanassche@acm.org>
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
 block/blk-mq.c         | 7 +++----
 block/blk-zoned.c      | 5 ++++-
 drivers/md/dm.c        | 5 ++---
 include/linux/blkdev.h | 5 +++--
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 58d3d0e724cb..c1035a2bbda8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3190,10 +3190,9 @@ void blk_mq_submit_bio(struct bio *bio)
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
index ef43aaca49f4..7e0f90626459 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1110,6 +1110,9 @@ static void blk_zone_wplug_handle_native_zone_appen=
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
@@ -1118,7 +1121,7 @@ static void blk_zone_wplug_handle_native_zone_appen=
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
index 3ea6c77746c5..904e2bb1e5fc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -897,7 +897,7 @@ static inline bool bio_needs_zone_write_plugging(stru=
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
@@ -932,7 +932,8 @@ static inline bool bio_needs_zone_write_plugging(stru=
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
