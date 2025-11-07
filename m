Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535EB29BDAC;
	Fri,  7 Nov 2025 23:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559648; cv=none; b=V0tFAKM1peMG9Y9gKsl8rT7kWtKRS+Nk0rFDtntFAA8Phg6ZRPcrgHpAL6HWfPeLAR9zyV3OutU72XfE+i6n/2ZItk0R4iFpbNxPnZiOxjNaJgENodExsfwj9oNMAFLIO7buHMsqoQbTdfWqXhzSX0B7GDbrw5XB9kzl9Wv2L+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559648; c=relaxed/simple;
	bh=BkqPGq5WOQOHRSxnRs0Af1a510Uv89NIgMiouaYEdNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bako+5yy+UeAqc6GUd/yEyU+r/hPqH799galfBx40tfQAe0Dj/q86wCRwI/47uD6SUIikjHbYjZ7/HbhbYPjnmSvnOlkC4AccF0tY9NYrnSfvmTadA6LvHX1x7WIj2yLucP/OcddCj1XF6XkMiIJZ0cG3l4GytLVkfd6psWa8Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KNbOu/MR; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KNbOu/MR"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d3G9p4jtRzm17wr;
	Fri,  7 Nov 2025 23:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1762559645; x=1765151646; bh=RQnx5
	CkPt5xhlTnQSN1aRkP6eCpGCFqUAIPvMuqaaOU=; b=KNbOu/MRlV9jggvEeDLZX
	M5WF9J4NECYHQQwIBe+Xe5wN3w0ZUkOussv3KhEJVrS4WLDlZHYnU5OM99ebw9P/
	IqE1Dh7bTixtT6hiPenHjU3otvPmPmad74GHpXVo2F3CAURM98QB7lpLSKZm0rKa
	KN0m/KPz1h72EwsmXcSsmZ2CBFZ9dufPe7rmycLXU6xSwWhR/HOZ2/B9jHTvB5U0
	suDkHo4+V5RSN8eMHI3nXPq0UmB7WVRR5lVctK56SpWIktB/yP1+6WhmGwkc4fED
	LOgYlIi8ASeE7NxOkkunE72M0iHYNQb+e+CXnAApNj5fhJk9+6e8Ixxj1ZxNdcEG
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id o_UGI4KdcDiD; Fri,  7 Nov 2025 23:54:05 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d3G9j34dYzm17wV;
	Fri,  7 Nov 2025 23:54:00 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v26 08/17] blk-zoned: Move code from disk_zone_wplug_add_bio() into its caller
Date: Fri,  7 Nov 2025 15:53:01 -0800
Message-ID: <20251107235310.2098676-9-bvanassche@acm.org>
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
index c15ce570c7f6..7f85a424256f 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1202,8 +1202,6 @@ static inline void disk_zone_wplug_add_bio(struct g=
endisk *disk,
 				struct blk_zone_wplug *zwplug,
 				struct bio *bio, unsigned int nr_segs)
 {
-	bool schedule_bio_work =3D false;
-
 	/*
 	 * Grab an extra reference on the BIO request queue usage counter.
 	 * This reference will be reused to submit a request for the BIO for
@@ -1219,16 +1217,6 @@ static inline void disk_zone_wplug_add_bio(struct =
gendisk *disk,
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
@@ -1244,11 +1232,6 @@ static inline void disk_zone_wplug_add_bio(struct =
gendisk *disk,
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
@@ -1416,6 +1399,7 @@ static bool blk_zone_wplug_handle_write(struct bio =
*bio, unsigned int nr_segs)
 {
 	struct gendisk *disk =3D bio->bi_bdev->bd_disk;
 	sector_t sector =3D bio->bi_iter.bi_sector;
+	bool schedule_bio_work =3D false;
 	struct blk_zone_wplug *zwplug;
 	gfp_t gfp_mask =3D GFP_NOIO;
 	unsigned long flags;
@@ -1462,12 +1446,14 @@ static bool blk_zone_wplug_handle_write(struct bi=
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
@@ -1482,8 +1468,13 @@ static bool blk_zone_wplug_handle_write(struct bio=
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
