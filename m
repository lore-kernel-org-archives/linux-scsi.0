Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D147E2D9EE2;
	Mon, 11 Aug 2025 20:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754943017; cv=none; b=EPTPRHx8gelWsdS9gxveg0hBRcNj7eNgWCfJ0/ohCXgb4tGH2WP4SvrMuQlzoAXedAuorwDkAic9jwKNG2MpnL26513DTx87NpKf8oUR4yTdjk4bLnQF6DML9bqXQQWb+cYMvFj6PzSXuinSHuOjlZIciMEAk0gJVs+8qCUk4x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754943017; c=relaxed/simple;
	bh=xB8MW3gQZoiymteJQPTx7IYj/zafuGfwQbPsYi1yotY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uk6TJb65nsTFrzMB987h6dv0szS2mg9Q9v9jfF7zNOZZdz+bEVH99PUR4X8KGYLsDNIiHATI8AsHCxj4pg0dv0EIRV8EyQLlwe97fpbbQMxCBByhk8teW05AiirAQtZG21/sPD0BlqeE2Y3CvfG/mBAkDNr0vcklhwktM3NhdGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Km+BN2De; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Km+BN2De"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c15N700vczm0ysg;
	Mon, 11 Aug 2025 20:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754943013; x=1757535014; bh=KlKjS
	DU9D2kFZOOgdlv9MG6zmjjKzCjpnQw33UZvGsU=; b=Km+BN2DeUW3QWZ0+6ssOk
	DpReOToLV6hTIYRSDAlVlTCp62PC0w+j0z0PToQCb3fQMNZ52UbQ7xqVyQQSKT7h
	4KNx/kc6fhbuelGA3aMRIdbEV8ckCGHHjX0qCQ+Yjp/njTMlLGpLSvAfc63NZ+T8
	7keMUBQxRss+m+OYOB1eirK+Y/i9F+2jKScfjAroHbO+qsidJgM6iAMU+CZw0OwP
	GMPkUyxNAXeqijuHFR7aZNB16aPe5FvjN9ZhldL6SzW42TslXn2GPI69H9PVPtuq
	y+EEsYOJETnV4hu9PrsyObHzWRjap9hJnAuzvYpUasFpPgvnEV4uXp474cZFPako
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GShHm8orIb8T; Mon, 11 Aug 2025 20:10:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c15N159PDzm0yTR;
	Mon, 11 Aug 2025 20:10:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v23 08/16] blk-zoned: Move code from disk_zone_wplug_add_bio() into its caller
Date: Mon, 11 Aug 2025 13:08:43 -0700
Message-ID: <20250811200851.626402-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811200851.626402-1-bvanassche@acm.org>
References: <20250811200851.626402-1-bvanassche@acm.org>
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
index 7420f83d104f..564f6a279bde 100644
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
