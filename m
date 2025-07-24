Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF5523F422;
	Thu, 24 Jul 2025 21:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394301; cv=none; b=uWkciB/TgoDt9TiO9DueqmpnrsAp1Gfa+5VY93PTEEcvP7NHKu9fcdqYDlXzbdH6IsnALAT4q2QeKY9C3RMmDFsY1943LzXv/aw5kTgZdqzgJS3CQIOqb/Nxn2+vBkAnwUz3dkoUJGqFg3YNSscRaEvlM0mVdCIj+WvFd4XKYJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394301; c=relaxed/simple;
	bh=ahxLk5vCttXqr261fdmK0KmS4Ang26KDOO9bfEFx808=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqnCbWv2plFo5m1AQIZjO/8XyXkl2UnMjyaNUGdviNdS5OpQpDa57K03XZFXGuRJ5V5VRlTtmbEsn7H0Kv1XVma6Em0Mj0Td4Stc+8r+dF2zdn44iWYOIO59hnds+ElQQeQVljC6u8gYHXqVv/10l/hbmcIArIuzIz+SRMpF6Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=psHd93ZI; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="psHd93ZI"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bp4d745SvzlgqVS;
	Thu, 24 Jul 2025 21:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1753394298; x=1755986299; bh=oN4vf
	a7BgsXwJNIb8QRRIlbjsoKP0s3kB/tBzFGJ8so=; b=psHd93ZIJOGj2HUFFrsT/
	GbA6kXa9Al8HgiCVYW1KohHQOpqKBmD1miV/LZIs7Y+czNinlbuxSfE6JfAU/qAI
	TW1fDQwjUYzr/YZ0Z24+8C3zR8rRHsg6qdT3xU0R3rlK/U/2vJFseLuJlq9dgiaX
	umvym8Yxf2kiKhZEam15A+gpgmjJWNvtq4zBUdLlxVtpIPY05xUCwsbS74Odw0c4
	6M9jFhPCoCsXD8MKJo2sKsjxIhDeUiCars9g0vFGpX/w7zs4SiaFMDJn6GflSaA4
	QOScHSlINA5UHBPC2JwFdSAC5q61fMtDm3qV6iGEOoymjgc6ncMoxFnSzS4ERqZ3
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id R6__I02muJQB; Thu, 24 Jul 2025 21:58:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bp4d23t8FzlgqTv;
	Thu, 24 Jul 2025 21:58:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v22 06/14] blk-zoned: Move code from disk_zone_wplug_add_bio() into its caller
Date: Thu, 24 Jul 2025 14:56:55 -0700
Message-ID: <20250724215703.2910510-7-bvanassche@acm.org>
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
index d7bdc92bedae..5ec71f53586f 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -782,8 +782,6 @@ static inline void disk_zone_wplug_add_bio(struct gen=
disk *disk,
 				struct blk_zone_wplug *zwplug,
 				struct bio *bio, unsigned int nr_segs)
 {
-	bool schedule_bio_work =3D false;
-
 	/*
 	 * Grab an extra reference on the BIO request queue usage counter.
 	 * This reference will be reused to submit a request for the BIO for
@@ -799,16 +797,6 @@ static inline void disk_zone_wplug_add_bio(struct ge=
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
@@ -824,11 +812,6 @@ static inline void disk_zone_wplug_add_bio(struct ge=
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
@@ -993,6 +976,7 @@ static bool blk_zone_wplug_handle_write(struct bio *b=
io, unsigned int nr_segs)
 {
 	struct gendisk *disk =3D bio->bi_bdev->bd_disk;
 	sector_t sector =3D bio->bi_iter.bi_sector;
+	bool schedule_bio_work =3D false;
 	struct blk_zone_wplug *zwplug;
 	gfp_t gfp_mask =3D GFP_NOIO;
 	unsigned long flags;
@@ -1039,12 +1023,14 @@ static bool blk_zone_wplug_handle_write(struct bi=
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
@@ -1059,8 +1045,13 @@ static bool blk_zone_wplug_handle_write(struct bio=
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
