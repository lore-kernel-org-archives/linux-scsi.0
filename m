Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69192D543E;
	Wed, 27 Aug 2025 21:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330253; cv=none; b=kVnvjEDBn7GhP/gyR0DL/eWYBUj83kMJOizD5XuRcWqPrJ4Gxm8PRUCGVPYyuJYSZmnNT4BbbNveYZXIpXfIY6Rxskz5RiqS0nb6nvyDm5M90eTw/cGNOCYmSqYbJse6wt74UuMAwmCKZKOMrv1sPJIDefx+CVHDeKB4A6iHaVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330253; c=relaxed/simple;
	bh=/A1ZRFZZTa0J5g/teGPGqPMXbmqEgfmJrWs9p3lacW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrp59MAJul3Y7jfdc5ycm7KMoPN9HnyHmkkgJnHoV+rUONQNr0wBvSo2SF1WV89l27gglP9vEo7jdl4ALHWWu1GMsGFJnwHlldhFLQO0Eyf/Dvj7pVbRab3NVF2WrJFPkdYg2E6OMcBiy8gPSl4D9nDjyyx8/Rpml7QBO6vUBEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Fdlvw/il; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Fdlvw/il"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByPk1PrNzm174H;
	Wed, 27 Aug 2025 21:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330248; x=1758922249; bh=yf71e
	BVLSKiRdockj1ypVmfgn7dQ0bl8cSp7zSSk39g=; b=Fdlvw/il4XTWckTj9XFM6
	XRtW1o6zEnQIYC4rAX2+fJ9IoN5WKGrmfr8QnP8Wtm63K7Lj1PZy7oPlv5eUi4hv
	CLoZIBm3XpfCM+v2tv/UrFTmcZwZvm5u0BmwSDwVrNSY1AVdNpONSfggnOyDQd7R
	6jBxnnvQHTo1bvBWcZknBlGgyaQXYqsIo7rmWiJMdRMtWmLLzBSpvzSe3lQsebgX
	Rpb8vg7SUyHVzLER0QvmySfO7R33kmA+KxOPncayt6m0a6jApx2IH4tlCgAyQ1bB
	zE7RHOrU/bOgkdBLVVBSksLKIhH2q/VIT79UGGR1tv8AaIgziWEKrmqKN/AkCHFB
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id N9s4Ke_GvG5T; Wed, 27 Aug 2025 21:30:48 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByPd0Wy3zm0ysl;
	Wed, 27 Aug 2025 21:30:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v24 09/18] blk-zoned: Move code from disk_zone_wplug_add_bio() into its caller
Date: Wed, 27 Aug 2025 14:29:28 -0700
Message-ID: <20250827212937.2759348-10-bvanassche@acm.org>
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

Move the following code into the only caller of disk_zone_wplug_add_bio()=
:
 - The code for clearing the REQ_NOWAIT flag.
 - The code that sets the BLK_ZONE_WPLUG_PLUGGED flag.
 - The disk_zone_wplug_schedule_bio_work() call.

No functionality has been changed.

This patch prepares for zoned write pipelining by removing the code from
disk_zone_wplug_add_bio() that does not apply to all zoned write pipelini=
ng
bio processing cases.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index f7f43b7e6f31..fb6e7407d173 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -799,8 +799,6 @@ static inline void disk_zone_wplug_add_bio(struct gen=
disk *disk,
 				struct blk_zone_wplug *zwplug,
 				struct bio *bio, unsigned int nr_segs)
 {
-	bool schedule_bio_work =3D false;
-
 	/*
 	 * Grab an extra reference on the BIO request queue usage counter.
 	 * This reference will be reused to submit a request for the BIO for
@@ -816,16 +814,6 @@ static inline void disk_zone_wplug_add_bio(struct ge=
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
@@ -841,11 +829,6 @@ static inline void disk_zone_wplug_add_bio(struct ge=
ndisk *disk,
 	bio_list_add(&zwplug->bio_list, bio);
 	trace_disk_zone_wplug_add_bio(zwplug->disk->queue, zwplug->zone_no,
 				      bio->bi_iter.bi_sector, bio_sectors(bio));
-
-	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
-
-	if (schedule_bio_work)
-		disk_zone_wplug_schedule_bio_work(disk, zwplug);
 }
=20
 /*
@@ -1010,6 +993,7 @@ static bool blk_zone_wplug_handle_write(struct bio *=
bio, unsigned int nr_segs)
 {
 	struct gendisk *disk =3D bio->bi_bdev->bd_disk;
 	sector_t sector =3D bio->bi_iter.bi_sector;
+	bool schedule_bio_work =3D false;
 	struct blk_zone_wplug *zwplug;
 	gfp_t gfp_mask =3D GFP_NOIO;
 	unsigned long flags;
@@ -1056,12 +1040,14 @@ static bool blk_zone_wplug_handle_write(struct bi=
o *bio, unsigned int nr_segs)
 	 * Add REQ_NOWAIT BIOs to the plug list to ensure that we will not see =
a
 	 * BLK_STS_AGAIN failure if we let the BIO execute.
 	 */
-	if (bio->bi_opf & REQ_NOWAIT)
-		goto plug;
+	if (bio->bi_opf & REQ_NOWAIT) {
+		bio->bi_opf &=3D ~REQ_NOWAIT;
+		goto add_to_bio_list;
+	}
=20
 	/* If the zone is already plugged, add the BIO to the plug BIO list. */
 	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
-		goto plug;
+		goto add_to_bio_list;
=20
 	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
 		spin_unlock_irqrestore(&zwplug->lock, flags);
@@ -1076,8 +1062,13 @@ static bool blk_zone_wplug_handle_write(struct bio=
 *bio, unsigned int nr_segs)
=20
 	return false;
=20
-plug:
+add_to_bio_list:
+	schedule_bio_work =3D !(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED);
+	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
+
 	disk_zone_wplug_add_bio(disk, zwplug, bio, nr_segs);
+	if (schedule_bio_work)
+		disk_zone_wplug_schedule_bio_work(disk, zwplug);
=20
 	spin_unlock_irqrestore(&zwplug->lock, flags);
=20
