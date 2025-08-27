Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654F72D543E;
	Wed, 27 Aug 2025 21:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330256; cv=none; b=GGipRRfYGTjiufPwCh5F0ri5wu+FuliPZWgh1c7DWlkByvfduZjJw4iXy1tHht80f97FCNrj9drbtcTpGVInz0j21NPpPAM5v8ENyJoO3G9BcW/g9w1MxzhLUrSfDYuBjyPp2kH2pKJwvSPIdIEx2clCjyE/d1e8XAPuFTF9/jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330256; c=relaxed/simple;
	bh=Qbit1reNcjJwLP9HvSab/afXg0cVTbSURsagBSJqvXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVtWvgbqDTXFCbStVRJVL8doPTndJsf9BXmOsFG3WpxFAk7Yw2c9KNh0xRrOoFhgJeYEKqfZC4MTxamUbups6YnJZra/QSkEl+MiNblMCyosd+DU+8K/DPXG9IyWRtuRvM+ENcRIhQ5MR/i/LWp+CYyE0WMjJvYt/owz7v/1M0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Q/ekqeOY; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Q/ekqeOY"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByPp3xBKzm0yQk;
	Wed, 27 Aug 2025 21:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330253; x=1758922254; bh=oBOn5
	cdoH3AM1JwqepVBxfR5iDUJjyLJiAzYoRH9K1A=; b=Q/ekqeOYQJQ+myMNypgja
	qqcassBaOejMwsmFgVHdAdFy76b/vvyWKpa33fLN+k97zfp+vjsQ9GC+pRh1GsVV
	St0om6Yl64doUDMZDuW55Cdxb/Tqw6os6uf2hEbuNjDuscBoeXR6uY++YGdlIo65
	bSFGUyAh3Gs1tB6B8jWyclzbzOz6ydm75H8fXCdWe0aFxnUr9tZlJhvYsK5DCyzB
	If61UWG0E6IMUYsFIokk/eHgGZEceW/8wGQsU+SY/tDE0tlsU8DNaPj9x34nHvBF
	74lJ+h1EgFU3Ywd8JTaYgDqhXSbDJm9vZxfhsBmXN94yR7vVg4MppVukSAhRFbzg
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3F1u4hiRI1yO; Wed, 27 Aug 2025 21:30:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByPj3dGJzm174D;
	Wed, 27 Aug 2025 21:30:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v24 10/18] blk-zoned: Introduce a loop in blk_zone_wplug_bio_work()
Date: Wed, 27 Aug 2025 14:29:29 -0700
Message-ID: <20250827212937.2759348-11-bvanassche@acm.org>
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

Prepare for submitting multiple bios from inside a single
blk_zone_wplug_bio_work() call. No functionality has been changed.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 70 +++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index fb6e7407d173..eb81278acb38 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1301,44 +1301,48 @@ static void blk_zone_wplug_bio_work(struct work_s=
truct *work)
 	struct bio *bio;
 	bool prepared;
=20
-	/*
-	 * Submit the next plugged BIO. If we do not have any, clear
-	 * the plugged flag.
-	 */
-again:
-	spin_lock_irqsave(&zwplug->lock, flags);
-	bio =3D bio_list_pop(&zwplug->bio_list);
-	if (!bio) {
-		zwplug->flags &=3D ~BLK_ZONE_WPLUG_PLUGGED;
-		spin_unlock_irqrestore(&zwplug->lock, flags);
-		goto put_zwplug;
-	}
+	do {
+		/*
+		 * Submit the next plugged BIO. If we do not have any, clear
+		 * the plugged flag.
+		 */
+		spin_lock_irqsave(&zwplug->lock, flags);
+		bio =3D bio_list_pop(&zwplug->bio_list);
+		if (!bio) {
+			zwplug->flags &=3D ~BLK_ZONE_WPLUG_PLUGGED;
+			spin_unlock_irqrestore(&zwplug->lock, flags);
+			goto put_zwplug;
+		}
=20
-	trace_blk_zone_wplug_bio(zwplug->disk->queue, zwplug->zone_no,
-				 bio->bi_iter.bi_sector, bio_sectors(bio));
+		trace_blk_zone_wplug_bio(zwplug->disk->queue,
+					 zwplug->zone_no,
+					 bio->bi_iter.bi_sector,
+					 bio_sectors(bio));
=20
-	prepared =3D blk_zone_wplug_prepare_bio(zwplug, bio);
-	spin_unlock_irqrestore(&zwplug->lock, flags);
+		prepared =3D blk_zone_wplug_prepare_bio(zwplug, bio);
+		spin_unlock_irqrestore(&zwplug->lock, flags);
=20
-	if (!prepared) {
-		blk_zone_wplug_bio_io_error(zwplug, bio);
-		goto again;
-	}
+		if (!prepared) {
+			blk_zone_wplug_bio_io_error(zwplug, bio);
+			continue;
+		}
=20
-	bdev =3D bio->bi_bdev;
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
+		bdev =3D bio->bi_bdev;
+
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
