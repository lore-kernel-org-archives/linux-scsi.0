Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961462D9EC5;
	Mon, 11 Aug 2025 20:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754943022; cv=none; b=EeaisIAm5PJf6VM94QVTRXufkfMBlhNb0EfhWNUd/YVUmksq2kpaCIL+ZZA/ER62UvAUEtnnJSsi56nvQcuq7pOli6qEWFlhAYfhJvThJiCjqqiRGtTiSrOfiiYKYKEvM/3whQbm/AVCnfg+K1kloIVaf9n0w/VPgLnAStIuyUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754943022; c=relaxed/simple;
	bh=szGttOV03ZKKQKnmh8TXD+7/QZL5QdYyK1A3Y9Qs1tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dubZmHvQe0Zg+7A4+51U5kLajYPsV/YQFSWbBBJkGss96JPxMaKuIDuYK+zPDmuP9IZQCvhGG2OFWxxif05H8+OrGBIAi6eeE3IcyDnioAlWXVdRPb3VsJLnNA4+a8pXD/zrUGHwomX+fyg6HEEPR8+WaQSFg/Sq8+htZRgzvWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NotYFw61; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NotYFw61"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c15NC5Vkgzm0ytg;
	Mon, 11 Aug 2025 20:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754943018; x=1757535019; bh=z6sTV
	yr/MzF/eIiwbmZOQLXV2Un7u092XQQbYXXcxSM=; b=NotYFw615cT/w/IjyM8PY
	l1PWb2UnQT9Z/7w/p+fWfFvpsjZxurGypOUiwdWZYzxpilBEwgEb6zz9wbwdRRRp
	EKbJf1CknFKhvPtAZPt5+TlZrAqZmJHzjLhvuw0EaR7vP00dRH2M4tfMof6AI+qp
	5A1s14jHQijTrBp/RxcQOUF12itpMK3dJIhTo75sUteY3PqBfypVAckgOpeQnphY
	1ZHUIGZwZWzome36CB0zAxbHw3GvcRfbh+KFgNFU2QOCL2W5SopvwWaAI9mMrHOP
	ZvCWj4ijVlElA1S15BD0Z/wYmdj88Nws/ZTTOSU1NiXIRzXICke7gIBdMJVaUD1o
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YWoO_NfYqBLW; Mon, 11 Aug 2025 20:10:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c15N63tbkzm0yVH;
	Mon, 11 Aug 2025 20:10:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v23 09/16] blk-zoned: Introduce a loop in blk_zone_wplug_bio_work()
Date: Mon, 11 Aug 2025 13:08:44 -0700
Message-ID: <20250811200851.626402-10-bvanassche@acm.org>
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

Prepare for submitting multiple bios from inside a single
blk_zone_wplug_bio_work() call. No functionality has been changed.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 66 +++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 564f6a279bde..5d91dc028246 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1300,44 +1300,48 @@ static void blk_zone_wplug_bio_work(struct work_s=
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
