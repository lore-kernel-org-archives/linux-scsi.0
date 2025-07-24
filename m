Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1AA23ABB2;
	Thu, 24 Jul 2025 21:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394306; cv=none; b=qRXWS4xEi1Sv+jsyzSaEuX4ilm+25tDS20cwhZQ34mOULFyzCvwArOGdFiAhwgN24mioVc08RDsLJvYX2WQxsW1F0O3v0Exp36lfs+LS9IQeI6vqoPcJ4ZuF88aNFu/oHLAvQzldT8odfvw+VoRfqK82ztpCB+NXgtMV87SpcE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394306; c=relaxed/simple;
	bh=OVFKTZ1qhqTAxNtjNwrmmCqWDMzQyTCPwMyfF7wIPtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ER5DgZN780CkexdE/ExPVojOP4fo2buvGG/4bp+cybYG/wMfB01r6pbGeGu7nOeAJaJ7aBU+pMBpi7livLOkZaQhrOeB6d4ew7gtmD6aRPj0CvadA4HhkO0a969KZ0kmFSeeJ8YBBo47197RsWOP5zR0hKXs40MRzuL9eMD7qzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MTj/4SOQ; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MTj/4SOQ"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bp4dD2VhPzlgqVB;
	Thu, 24 Jul 2025 21:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1753394303; x=1755986304; bh=KqiRL
	3pZP6m4KY4ZOvYmnPS48XV9n3q2AbU9RgoR89g=; b=MTj/4SOQuwoJ8xVRNmTtS
	MBPoRSpCO3wuZTQypvWejX7nCLvdnqGDPikbCDCxbNohjWrxNNotN7UeloYr1sYd
	YtRvxJLGKy3XjmLavSP/lnyhA+Cfh4281q3Fra4mYgN0LzALuaFI3V1lYeg887no
	oXID8In045099+TKsopfsSNPQpii2WEEm1OQl/UNEriTN5Mzll6IT5oD2ToKclz5
	awVk451uSmz1NV7FJ1e6Ta5h2dVzQ4Du+fMAMwhZ26s+xHDcdw35MJFD7iWrY72m
	s1ktsqGZFE4eMDjSkpdgA+BPLhBpvUE7lUzmTuQ+OkTrqWLdPL+jtMgjHeEtKNWw
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MDxZ2Atq3aLv; Thu, 24 Jul 2025 21:58:23 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bp4d734vxzlgqV4;
	Thu, 24 Jul 2025 21:58:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v22 07/14] blk-zoned: Introduce a loop in blk_zone_wplug_bio_work()
Date: Thu, 24 Jul 2025 14:56:56 -0700
Message-ID: <20250724215703.2910510-8-bvanassche@acm.org>
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

Prepare for submitting multiple bios from inside a single
blk_zone_wplug_bio_work() call. No functionality has been changed.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 66 +++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 5ec71f53586f..1a41d45c74da 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1283,44 +1283,48 @@ static void blk_zone_wplug_bio_work(struct work_s=
truct *work)
 	unsigned long flags;
 	struct bio *bio;
=20
-	/*
-	 * Submit the next plugged BIO. If we do not have any, clear
-	 * the plugged flag.
-	 */
-	spin_lock_irqsave(&zwplug->lock, flags);
+	do {
+		/*
+		 * Submit the next plugged BIO. If we do not have any, clear
+		 * the plugged flag.
+		 */
+		spin_lock_irqsave(&zwplug->lock, flags);
=20
 again:
-	bio =3D bio_list_pop(&zwplug->bio_list);
-	if (!bio) {
-		zwplug->flags &=3D ~BLK_ZONE_WPLUG_PLUGGED;
-		spin_unlock_irqrestore(&zwplug->lock, flags);
-		goto put_zwplug;
-	}
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
-	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
-		blk_zone_wplug_bio_io_error(zwplug, bio);
-		goto again;
-	}
+		if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
+			blk_zone_wplug_bio_io_error(zwplug, bio);
+			goto again;
+		}
=20
-	spin_unlock_irqrestore(&zwplug->lock, flags);
+		spin_unlock_irqrestore(&zwplug->lock, flags);
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
