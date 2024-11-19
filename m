Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C75610B;
	Tue, 19 Nov 2024 00:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976124; cv=none; b=oGOOKlO6clDWBYYsM6nYubmiEZcvmGdMMzHmQkEIAkOYI6DigyEEqpU8l9jz8S0JxTPWeTkuJY/Ku5fiUDFC/YL54Y0tg3EcbWRnB9dr9Dt4Q1cwK7Yq+2TZ9hpIt+g6WxVIIUU+t10NNLrSlLYlZO7DLLmNq8F5rJVqvYhGiVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976124; c=relaxed/simple;
	bh=dx+OfJ7J7hMc9ed8wbmXnUYBuEtk3Cw23r4yFfCtulA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ti/nuy3GsCNdiEK1LBLz80fNTBZwMcGRNlZu8qmfLjhYXMVGF0XdCO/gTfPNmWjO/1vyoJ0MbewR+GfiryJxlsuR+CImv3B9qnoAH5TJfgeaEKOLUYWcYuFYybNzhwzWFWtYB7flw4mTt2A0RVJ/PMZSxWtzzdD8zJ4ssCAU51U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aNrbEK3d; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aNrbEK3d"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xslj71ZxdzlgVnN;
	Tue, 19 Nov 2024 00:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976119; x=1734568120; bh=mI8SH
	BvMkiBxhT++X6Sv40oLp6cQRq+UeWcjKu1tp9I=; b=aNrbEK3dwBafDI9vRt3ZC
	e22roAu06AEDefe/e4tQM6RkTBaRaDJ0HyWJSm37faiv5XKuDfDoTgHOf2utrwPS
	k469Dz7TA68o84QHoVp/Y6wBpkPNPHRbKqpcuJbQkxAuvE9/tFWrgSgC2j8gwbOn
	6z4UZs4AlcCMc323GJHOtjOIgEL5e2EMvsImcfvjWSoO+rI2uOphAVdtPaQqC48T
	lLdVO+mC6CFWfqFcg/akXl8UOoLlTkGJHO2G2RGlyz82Bo4B0CCnS2ot9tGQ7b9g
	/1aVj6wLjSjkwBlNI6mpi+RzCNRYs0eK3wa3hIVVoX+KB2L3rKPwYZBNW2Rx/eqi
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RgX2fBwLongY; Tue, 19 Nov 2024 00:28:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xslj16gFvzlgTWQ;
	Tue, 19 Nov 2024 00:28:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 06/26] blk-zoned: Fix requeuing of zoned writes
Date: Mon, 18 Nov 2024 16:27:55 -0800
Message-ID: <20241119002815.600608-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
In-Reply-To: <20241119002815.600608-1-bvanassche@acm.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make sure that unaligned writes are sent to the block driver. This
allows the block driver to limit the number of retries of unaligned
writes. Remove disk_zone_wplug_abort_unaligned() because it only examines
the bio plug list. Pending writes can occur either on the bio plug list
or on the request queue requeue list.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 284820b29285..ded38fa9ae3d 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -577,33 +577,6 @@ static void disk_zone_wplug_abort(struct blk_zone_wp=
lug *zwplug)
 		blk_zone_wplug_bio_io_error(zwplug, bio);
 }
=20
-/*
- * Abort (fail) all plugged BIOs of a zone write plug that are not align=
ed
- * with the assumed write pointer location of the zone when the BIO will
- * be unplugged.
- */
-static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
-					    struct blk_zone_wplug *zwplug)
-{
-	unsigned int wp_offset =3D zwplug->wp_offset;
-	struct bio_list bl =3D BIO_EMPTY_LIST;
-	struct bio *bio;
-
-	while ((bio =3D bio_list_pop(&zwplug->bio_list))) {
-		if (disk_zone_is_full(disk, zwplug->zone_no, wp_offset) ||
-		    (bio_op(bio) !=3D REQ_OP_ZONE_APPEND &&
-		     bio_offset_from_zone_start(bio) !=3D wp_offset)) {
-			blk_zone_wplug_bio_io_error(zwplug, bio);
-			continue;
-		}
-
-		wp_offset +=3D bio_sectors(bio);
-		bio_list_add(&bl, bio);
-	}
-
-	bio_list_merge(&zwplug->bio_list, &bl);
-}
-
 static inline void disk_zone_wplug_set_error(struct gendisk *disk,
 					     struct blk_zone_wplug *zwplug)
 {
@@ -982,14 +955,6 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zo=
ne_wplug *zwplug,
 		 * so that we can restore its operation code on completion.
 		 */
 		bio_set_flag(bio, BIO_EMULATES_ZONE_APPEND);
-	} else {
-		/*
-		 * Check for non-sequential writes early because we avoid a
-		 * whole lot of error handling trouble if we don't send it off
-		 * to the driver.
-		 */
-		if (bio_offset_from_zone_start(bio) !=3D zwplug->wp_offset)
-			goto err;
 	}
=20
 	/* Advance the zone write pointer offset. */
@@ -1425,7 +1390,6 @@ static void disk_zone_wplug_handle_error(struct gen=
disk *disk,
=20
 	/* Update the zone write pointer offset. */
 	zwplug->wp_offset =3D zwplug->wp_offset_compl;
-	disk_zone_wplug_abort_unaligned(disk, zwplug);
=20
 	/* Restart BIO submission if we still have any BIO left. */
 	if (!bio_list_empty(&zwplug->bio_list)) {
