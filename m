Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADBEEEBB;
	Thu, 17 Jul 2025 20:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752785941; cv=none; b=uYvEfcXrLMcinnFSXrEX6FSs7RYcfHE/D2E6VNq3R+QZrx7d9EkPjlL0UzHs87Ktig9eyAucHhTm/DA3Ag0w+trQkC4DqRVrffo1sWxo1z2PRc/p6PSkYpom6nywBj95drybmF1gKKJj3shrypVOr6L0A2sNhXt8edc/qdf8ZyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752785941; c=relaxed/simple;
	bh=BGUBhXlGNLvGsEsARcE+oY3+Tbj3zTRFrdxrtIA/Et8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiBslnJMVb4f8W0lqOu89IoTkhL4YuNGp98rh1VgvpBYp6LwNGa4QaYGqmoLYdibwbtzAZAMu52lA9JhXuupIkfjh0QUl93+ySQSwhaiEu0E0GYmOpBYPicBnGASltJwd6IgDdxONW9gmVjZHpZnwZJBkyybjVH/GSrAJrNhx3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nHmvba5I; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nHmvba5I"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bjldt60s3zm0yt4;
	Thu, 17 Jul 2025 20:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752785937; x=1755377938; bh=kUcyi
	cRKUfO7q5N8AmqigeGicCT/rlU/Twe2Sy4sf5Y=; b=nHmvba5IDDmmYCM/Igpey
	wiMpJbu2oZsa+cwfmQXHbPKPo1UUkw7Uhm/tQSki33UKFM2CbhsJVl1DN3iuUwj4
	uKTPlDIE1Bn3F6Ojd2ZUF6jifznPQQIn7+rcfS8rLUOcX1oRppLjkmHIyN/7+KeG
	BfcfBC4gTulhX9CJ6FVLzLJQmdRUcYh1VDENwW2g3S9E0xHQRBDUojrn2vre8VMm
	45MsDg2ty20ZPDsoWZNsPYReeKpc0hO3gznG0i0+wW7VqpY0tlhqgX1nTqUq7hSx
	c65UEtilOqNUVmM21VthCai+alsl4enmckxQwSGj9QHn/8tv9i8UEc+cx+mMZMlo
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UoS_X6zB1_iV; Thu, 17 Jul 2025 20:58:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bjldn6Fk3zm1742;
	Thu, 17 Jul 2025 20:58:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v21 06/12] blk-zoned: Introduce a loop in blk_zone_wplug_bio_work()
Date: Thu, 17 Jul 2025 13:58:02 -0700
Message-ID: <20250717205808.3292926-7-bvanassche@acm.org>
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

Prepare for submitting multiple bios from inside a single
blk_zone_wplug_bio_work() call. No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 72 +++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 8fe6e545f300..6ef53f78fa3b 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1283,47 +1283,47 @@ static void blk_zone_wplug_bio_work(struct work_s=
truct *work)
 	struct blk_zone_wplug *zwplug =3D
 		container_of(work, struct blk_zone_wplug, bio_work);
 	struct block_device *bdev;
-	unsigned long flags;
 	struct bio *bio;
=20
-	/*
-	 * Submit the next plugged BIO. If we do not have any, clear
-	 * the plugged flag.
-	 */
-	spin_lock_irqsave(&zwplug->lock, flags);
-
+	do {
 again:
-	bio =3D bio_list_pop(&zwplug->bio_list);
-	if (!bio) {
-		zwplug->flags &=3D ~BLK_ZONE_WPLUG_PLUGGED;
-		spin_unlock_irqrestore(&zwplug->lock, flags);
-		goto put_zwplug;
-	}
-
-	trace_blk_zone_wplug_bio(zwplug->disk->queue, zwplug->zone_no,
-				 bio->bi_iter.bi_sector, bio_sectors(bio));
-
-	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
-		blk_zone_wplug_bio_io_error(zwplug, bio);
-		goto again;
-	}
-
-	spin_unlock_irqrestore(&zwplug->lock, flags);
+		/*
+		 * Submit the next plugged BIO. If we do not have any, clear
+		 * the plugged flag.
+		 */
+		scoped_guard(spinlock_irqsave, &zwplug->lock) {
+			bio =3D bio_list_pop(&zwplug->bio_list);
+			if (!bio) {
+				zwplug->flags &=3D ~BLK_ZONE_WPLUG_PLUGGED;
+				goto put_zwplug;
+			}
+
+			trace_blk_zone_wplug_bio(zwplug->disk->queue,
+						 zwplug->zone_no,
+						 bio->bi_iter.bi_sector,
+						 bio_sectors(bio));
+
+			if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
+				blk_zone_wplug_bio_io_error(zwplug, bio);
+				goto again;
+			}
+		}
=20
-	bdev =3D bio->bi_bdev;
+		bdev =3D bio->bi_bdev;
=20
-	/*
-	 * blk-mq devices will reuse the extra reference on the request queue
-	 * usage counter we took when the BIO was plugged, but the submission
-	 * path for BIO-based devices will not do that. So drop this extra
-	 * reference here.
-	 */
-	if (bdev_test_flag(bdev, BD_HAS_SUBMIT_BIO)) {
-		bdev->bd_disk->fops->submit_bio(bio);
-		blk_queue_exit(bdev->bd_disk->queue);
-	} else {
-		blk_mq_submit_bio(bio);
-	}
+		/*
+		 * blk-mq devices will reuse the extra reference on the request
+		 * queue usage counter we took when the BIO was plugged, but the
+		 * submission path for BIO-based devices will not do that. So
+		 * drop this extra reference here.
+		 */
+		if (bdev_test_flag(bdev, BD_HAS_SUBMIT_BIO)) {
+			bdev->bd_disk->fops->submit_bio(bio);
+			blk_queue_exit(bdev->bd_disk->queue);
+		} else {
+			blk_mq_submit_bio(bio);
+		}
+	} while (0);
=20
 put_zwplug:
 	/* Drop the reference we took in disk_zone_wplug_schedule_bio_work(). *=
/
