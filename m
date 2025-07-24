Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9084721858A;
	Thu, 24 Jul 2025 21:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394293; cv=none; b=N4BVD3Gy8FxY/iFy9VIiNKeh5Luz3D0AvAJ6MLRFwoCkSSQGEwFd4p1LLmYpDLFkHariNcQMy/RBAxrd1aYgD8xxneFCNHBFnMIcR2LjYVys+zPbqupjQUdLT4nVPrNgvcuLiSkU3dLuY3wLuOZUre11TrKHng6ZRq8eBUW1Eu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394293; c=relaxed/simple;
	bh=MqljC3xGqzS3yr6VYc5z4Fs4CyR5Io2a/GMpsVqyJNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PML792fOawuZRL4MQBOXS8A9I42c3WXnOeu2bMnsoUAdPIf9tNo+GD7/YjWdilKI/vbhopFeqMWEBtwt0m1vk/8+8kxb+j4IrT6WXmACGa/Ln4NfWEclDhcXyjW4dZWt7WyolA43t3MFFvnMbVImea81LZzDPvbePJ51Fhy21zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pwtQK+l/; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pwtQK+l/"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bp4cy4Wr5zlgqVS;
	Thu, 24 Jul 2025 21:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1753394289; x=1755986290; bh=sKHLo
	FyRs9fs+VrZ3cYIncuRh/KQvO5I8ZqsW8LC1Eo=; b=pwtQK+l/xuYiWVhNz0Lla
	NoABCC78uD+HCjKtvToFzQCuUJi0GrSpB98p/KK8sXDkcl2g0Z1h01LuSMAoqabc
	jApFTaSD3iFM396tLafx9lhSxkkp4oFydXz4Av9OJhSiZ8A/O5/IPkYglHT994Na
	c+UH4Weqc/JGQlziRp+EHv93mZr918zqD4P7GT50sj0c3S7Vi8f6zhwPX6tSK/KE
	lV3aYevx/MJdPWHSMwe6J6ho2YzTFvppjyAKl0RsE3e3MNCtJlH5oUuktlLVaUdG
	iRIVyvUm4E1IF9mwK6JqUWD1vpAQqdFVSA4Uj2vPwnDR4gh+AI/DvPmPDN89WhYC
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tDLrTgKkAZOl; Thu, 24 Jul 2025 21:58:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bp4cs40G4zlgqTv;
	Thu, 24 Jul 2025 21:58:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v22 04/14] blk-zoned: Add an argument to blk_zone_plug_bio()
Date: Thu, 24 Jul 2025 14:56:53 -0700
Message-ID: <20250724215703.2910510-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
In-Reply-To: <20250724215703.2910510-1-bvanassche@acm.org>
References: <20250724215703.2910510-1-bvanassche@acm.org>
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
index 37217d1f19bb..7f917eacf66f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3211,10 +3211,9 @@ void blk_mq_submit_bio(struct bio *bio)
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
index abfe0392b5a4..86f792806ca5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1811,9 +1811,8 @@ static inline bool dm_zone_bio_needs_split(struct b=
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
