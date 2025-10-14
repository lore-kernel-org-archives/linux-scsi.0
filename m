Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A15F2DA776;
	Tue, 14 Oct 2025 21:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478960; cv=none; b=TpsPaCkliaoXCisAzHr2lmVgw1T3nHf6afdKXchpkDTieG/pXDT8mds/yq6biGzfo1CLVn/m+hr0bYWavlVc6F9cWhVnoFX4kH1rXKTq0YsjgUQr8L/GKsm3JUDCNWxbdANSawLxtEsLK64PeMYUHCR16v60gEqMHF6JqaGrGe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478960; c=relaxed/simple;
	bh=R0A3ehN6V5x8I1tVAlHsmK5y7QqAjVfnZEcnkx98OLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SH3ATrl7vuIfvT92F3hklA3kLbClzIwa8dc/L2RE5oHywDyPG3ZGjPp1NC1AxOe/7a4haWrHjgPF9bqfgTzafSPbsaKT/4Xo2e1GlUHjc6pc1AC8BtpfgqG7nsgDsxm0FWbLQdB5NJX/No/3hY8majGDDuscil9RU8zoODWKS6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1RnSFpi1; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1RnSFpi1"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmShZ4ry1zm0yVJ;
	Tue, 14 Oct 2025 21:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478957; x=1763070958; bh=RG113
	pRq2WyNaSE2Kk6Ep6MMa+H8gLZmgG3F1pKrHpc=; b=1RnSFpi1tydnq0s/KibN3
	NoV77cUePWrWk+xkRZ0wrYVWULN+qv5m8rOJP7xGyb6TLzR4Ia+Jjz099dwUr4rM
	cbOr95irD3gandndJNdJACrYMScr/ZBNkduuyxfQHNwbQeWc86kbU0bSCRNMx7SN
	3dRpojwNg40s9Lf7KuMDXA+93OxDKTSLXWPmcrGw5VDD3sRgBs4YGToHpys38hsn
	3ThghP8K5rmcojsyLo7C2YpuGU67+CrE6knKsKhDDFuWmTNQLwtojapaOPPTJVTV
	8GUBjlO09dtRHcB0wxYxSYA7wKt6Vt4A4cTKNNIf9F3nRGG3b4j/r4JCxU8h0VhT
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lyywrWJLMGsP; Tue, 14 Oct 2025 21:55:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmShS5C1Mzm0yVM;
	Tue, 14 Oct 2025 21:55:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 12/20] blk-zoned: Introduce a loop in blk_zone_wplug_bio_work()
Date: Tue, 14 Oct 2025 14:54:20 -0700
Message-ID: <20251014215428.3686084-13-bvanassche@acm.org>
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

Prepare for submitting multiple bios from inside a single
blk_zone_wplug_bio_work() call. No functionality has been changed.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 70 +++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 6f4ceb7f4f43..1df466167e55 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1305,44 +1305,48 @@ static void blk_zone_wplug_bio_work(struct work_s=
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
