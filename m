Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF0F29BDAC;
	Fri,  7 Nov 2025 23:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559653; cv=none; b=ZDbI5X8t+OQjWEpr0/VLLi65cd1yIFalMcXrP8C7RN5YtgL8CUUvyunmoxNK+TTk0sj6zPdtTDyM1x+fTWDohhCbjCXVi56tJOCDwUgd6In72PZqu81/MlUXKd4G+Zr1jn89k7NloJNAq0mVz6x71oqkIXiyONDeU63PWZbj/x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559653; c=relaxed/simple;
	bh=mGlnn1o6YLapV548JwL2K6O/Rr/8HZ0T9wexovuIjNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQcgLsa8Wo1POdVNxHO7hFOJw2qWvJcq9LJScM1AyrWPTahGBpnGc5s6VxcmHll2fpUUvdC1z3NyA48E84+CZ3x4++M/I9QvREuGaYqQJlkAUiWeSyZwU8TIyGuRve2lirj9VMaY3twoXrQ2ZqG6Rlfxcyl981hYqFfy+cE1UCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OxEKBeiY; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OxEKBeiY"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d3G9v2yDZzm17x3;
	Fri,  7 Nov 2025 23:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1762559650; x=1765151651; bh=omjJO
	+ZO76tkYuMwg5LVpQMjRiN3qbypVziG16YLON8=; b=OxEKBeiYihZ9TTpqENO/j
	97XLsuMXstFd5ToJJV5KVeGb3RTG/a2/1oTQqvak/8OFf7Z5mQcRy/vtPi05JLkj
	+nz+lSQqWba3TbkSCN9C/DrGunf3ZH0t8UNsYK+eRp15P6mdJ34KOh7ERNrqtlgy
	9hTzFfq1o5CFlBeaETHci+R4dxot1fh9pZ+0fPnuDi07hO3acNOZeESORUig0tji
	KGD4l6IsyahXpetFhb+N+ZXLKwzPTSVfaH7TeIod+Pfq40AVDNLarRmM08b47818
	r0EnRrOirhGSzCY+cLWLw61uDg6ehZZwJsub0Mi1PBz1V/1JEi/mu164c6uekIYx
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1dQBabV762ue; Fri,  7 Nov 2025 23:54:10 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d3G9p1H0hzm17wj;
	Fri,  7 Nov 2025 23:54:05 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v26 09/17] blk-zoned: Introduce a loop in blk_zone_wplug_bio_work()
Date: Fri,  7 Nov 2025 15:53:02 -0800
Message-ID: <20251107235310.2098676-10-bvanassche@acm.org>
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

Prepare for submitting multiple bios from inside a single
blk_zone_wplug_bio_work() call. No functionality has been changed.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 69 ++++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 7f85a424256f..ceb2b432e49e 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1731,44 +1731,47 @@ static void blk_zone_wplug_bio_work(struct work_s=
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
+		trace_blk_zone_wplug_bio(zwplug->disk->queue, zwplug->zone_no,
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
