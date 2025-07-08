Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8464A1C5F13;
	Tue,  8 Jul 2025 22:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012487; cv=none; b=QPZoWq13pyoEkWholuWDeqUN9A9dzq0KEQpj1JnXtTpxPWC+x0kbFUYSCwUcSA0k3YkvIHfJKKzznN5kzenGYBtSt4l59JJaKWTMYx5zhXHbHwHjowNiIjOFAomxzn9exmSx75rGbXjnFekaagsx5vgbJQNwBy+ihQysQ4sz7wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012487; c=relaxed/simple;
	bh=l7f9XBpyXMKy+ZsHxVQ9DjxSk4vT0eRjzH5ou++fot4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOkzhA7CA9LVqE8WpmWeBjIosz1fDr6yTWHTf5Xl3suDPceRbuKBrTV3TY5+pxZgG+hA4N8HvJLaYLHJuu7Y1Xf/J8DmRJiLKmwHxbPEdPcxa0SlKJia8bXQYDwWlu0BFCFX0LwpSJ/AhFXYqDOHb8RFFoW7sTaaD9auP0BhvwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SNRDeI6P; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SNRDeI6P"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bcFbm4xYTzlh3sX;
	Tue,  8 Jul 2025 22:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752012483; x=1754604484; bh=dRL9K
	XBiBQec22Jk2ouHxywRFN6wtBOIpqnS0ckU1OQ=; b=SNRDeI6PpIpGlKzevePkY
	yXbukMHnPiv2aj77gSAKeNdHGYAmnRKqLRjujUo8/BOsRsCEvtJZMlDoX6jfYxn0
	iRDsXcy6m4DEFLu5O2VDGzivvYPexvZsK5bXIXDe7tHFNyTbAnEYYqCKSi8ZNWSj
	ips5gcoPCNzFowvaw9s5X0bMZYdKf5g3ThFTA+uR5JRGHkJnhO2+tXnagYq648wN
	MAvd2SmdBSXTms06FPQ6uGFJxQ5SusBB6DzADqPbVW26hvIjNhmjcR9UeV6YL2dL
	JOB/bgO/v9JucSszkSsgaCrWrspqSq26GUSIyILngFYj8q2fT5+VjWxzOINXhfDA
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YUsqDLPBCkCu; Tue,  8 Jul 2025 22:08:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bcFbg4pYkzlgqVq;
	Tue,  8 Jul 2025 22:07:58 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v20 05/13] blk-zoned: Move code from disk_zone_wplug_add_bio() into its caller
Date: Tue,  8 Jul 2025 15:07:02 -0700
Message-ID: <20250708220710.3897958-6-bvanassche@acm.org>
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

Move the following code into the only caller of disk_zone_wplug_add_bio()=
:
 - bio->bi_opf &=3D ~REQ_NOWAIT
 - wplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED
 - The disk_zone_wplug_schedule_bio_work() call.

No functionality has been changed.

This patch prepares for zoned write pipelining by removing the code from
disk_zone_wplug_add_bio() that does not apply to all zoned write pipelini=
ng
bio processing cases.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 089f106fd82e..2a85e3b7b081 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -778,8 +778,6 @@ static inline void disk_zone_wplug_add_bio(struct gen=
disk *disk,
 				struct blk_zone_wplug *zwplug,
 				struct bio *bio, unsigned int nr_segs)
 {
-	bool schedule_bio_work =3D false;
-
 	/*
 	 * Grab an extra reference on the BIO request queue usage counter.
 	 * This reference will be reused to submit a request for the BIO for
@@ -795,16 +793,6 @@ static inline void disk_zone_wplug_add_bio(struct ge=
ndisk *disk,
 	 */
 	bio_clear_polled(bio);
=20
-	/*
-	 * REQ_NOWAIT BIOs are always handled using the zone write plug BIO
-	 * work, which can block. So clear the REQ_NOWAIT flag and schedule the
-	 * work if this is the first BIO we are plugging.
-	 */
-	if (bio->bi_opf & REQ_NOWAIT) {
-		schedule_bio_work =3D !(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED);
-		bio->bi_opf &=3D ~REQ_NOWAIT;
-	}
-
 	/*
 	 * Reuse the poll cookie field to store the number of segments when
 	 * split to the hardware limits.
@@ -818,11 +806,6 @@ static inline void disk_zone_wplug_add_bio(struct ge=
ndisk *disk,
 	 * at the tail of the list to preserve the sequential write order.
 	 */
 	bio_list_add(&zwplug->bio_list, bio);
-
-	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
-
-	if (schedule_bio_work)
-		disk_zone_wplug_schedule_bio_work(disk, zwplug);
 }
=20
 /*
@@ -987,6 +970,7 @@ static bool blk_zone_wplug_handle_write(struct bio *b=
io, unsigned int nr_segs)
 {
 	struct gendisk *disk =3D bio->bi_bdev->bd_disk;
 	sector_t sector =3D bio->bi_iter.bi_sector;
+	bool schedule_bio_work =3D false;
 	struct blk_zone_wplug *zwplug;
 	gfp_t gfp_mask =3D GFP_NOIO;
 	unsigned long flags;
@@ -1031,13 +1015,17 @@ static bool blk_zone_wplug_handle_write(struct bi=
o *bio, unsigned int nr_segs)
=20
 	/* If the zone is already plugged, add the BIO to the plug BIO list. */
 	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
-		goto plug;
+		goto queue_bio;
 	/*
 	 * Do the same for REQ_NOWAIT BIOs to ensure that we will not see a
 	 * BLK_STS_AGAIN failure if we let the BIO execute.
 	 */
-	if (bio->bi_opf & REQ_NOWAIT)
-		goto plug;
+	if (bio->bi_opf & REQ_NOWAIT) {
+		bio->bi_opf &=3D ~REQ_NOWAIT;
+		if (!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED))
+			goto plug;
+		goto queue_bio;
+	}
=20
 	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
 		spin_unlock_irqrestore(&zwplug->lock, flags);
@@ -1053,7 +1041,13 @@ static bool blk_zone_wplug_handle_write(struct bio=
 *bio, unsigned int nr_segs)
 	return false;
=20
 plug:
+	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
+	schedule_bio_work =3D true;
+
+queue_bio:
 	disk_zone_wplug_add_bio(disk, zwplug, bio, nr_segs);
+	if (schedule_bio_work)
+		disk_zone_wplug_schedule_bio_work(disk, zwplug);
=20
 	spin_unlock_irqrestore(&zwplug->lock, flags);
=20
