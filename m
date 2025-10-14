Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220AB30C361;
	Tue, 14 Oct 2025 21:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478955; cv=none; b=SlerGheGgYmxy4FwopZVmbKz+RwPv/83RXURmeDbzvDmGUJgZW12Of5+jN02cblG7jVhNGqOD3w6wae5OT8j6Ii7tYAKdoqxpbpV7y5i12wWOHBQKGLN5YbgdxcVt02TqWCGH9M+S7zCrbPr6aBvHw1gnqCtRhp+K4B/xpkvlTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478955; c=relaxed/simple;
	bh=SvljJ+dEb876zm6K11JWKmQlkHVcuRoI0LiOYHxhnN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ok5+VEwtKmJATmC9FzR/DrsufLaGWcm1XS3PW8JGyZbY5196gMLKMl7ylWHuR6FAXgXuPFOWy/X/K0/FWzkMjrMegY23PhqtJDRTFEJLyAVGwbNuulh4EHMKGTdxynn3x7OLEEUh2dXt/VcR20yMpH0d1o5wlezf2oQLhcB91Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ETQnIvJi; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ETQnIvJi"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmShT1XFDzm0yVS;
	Tue, 14 Oct 2025 21:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478951; x=1763070952; bh=0hYdt
	DFEqfwjvuomaRBMXOXaIf/eyzoPc9r+/qeh3iM=; b=ETQnIvJiBVv+yzDsoWM7G
	WeIvV7GCtmFPJfcL8+pUlehcpOl1f1MyvrZTof4ocSndj8EJVYbuHHoL6r6zhL5+
	HJ6H/jUCmiGnuFTqGsA5EWfH1BkCltVBJY2vW6QTjTBV3jMZO5RIf7BW5xzJKJxm
	fFUQpHdfF0jU5IsZvWz/Jf3BjzpiZIAIXqUCy1gjary9CDIn2qIclweajhqtCmN2
	E+s5vllqGdyARxCHbok46SM95ZBhYbJTcT/pBIv9cHAOJ4D1f6Gaygss470RNhBg
	roB9Y+j/1Niamfr4Z1/DtR5EdGsmZRREXovnEvSE1+X41Nr6KGwcTPtT9hnZ3yzK
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Fb9-S9l0JBbb; Tue, 14 Oct 2025 21:55:51 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmShM1Z4Lzm0ySn;
	Tue, 14 Oct 2025 21:55:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 11/20] blk-zoned: Move code from disk_zone_wplug_add_bio() into its caller
Date: Tue, 14 Oct 2025 14:54:19 -0700
Message-ID: <20251014215428.3686084-12-bvanassche@acm.org>
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
index 063b7b9459dd..6f4ceb7f4f43 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -803,8 +803,6 @@ static inline void disk_zone_wplug_add_bio(struct gen=
disk *disk,
 				struct blk_zone_wplug *zwplug,
 				struct bio *bio, unsigned int nr_segs)
 {
-	bool schedule_bio_work =3D false;
-
 	/*
 	 * Grab an extra reference on the BIO request queue usage counter.
 	 * This reference will be reused to submit a request for the BIO for
@@ -820,16 +818,6 @@ static inline void disk_zone_wplug_add_bio(struct ge=
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
@@ -845,11 +833,6 @@ static inline void disk_zone_wplug_add_bio(struct ge=
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
@@ -1014,6 +997,7 @@ static bool blk_zone_wplug_handle_write(struct bio *=
bio, unsigned int nr_segs)
 {
 	struct gendisk *disk =3D bio->bi_bdev->bd_disk;
 	sector_t sector =3D bio->bi_iter.bi_sector;
+	bool schedule_bio_work =3D false;
 	struct blk_zone_wplug *zwplug;
 	gfp_t gfp_mask =3D GFP_NOIO;
 	unsigned long flags;
@@ -1060,12 +1044,14 @@ static bool blk_zone_wplug_handle_write(struct bi=
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
 	/* If the zone is already plugged, add the BIO to the BIO plug list. */
 	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
-		goto plug;
+		goto add_to_bio_list;
=20
 	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
 		spin_unlock_irqrestore(&zwplug->lock, flags);
@@ -1080,8 +1066,13 @@ static bool blk_zone_wplug_handle_write(struct bio=
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
