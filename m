Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EC129BDAC;
	Fri,  7 Nov 2025 23:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762559643; cv=none; b=r/R397Y9vPWLhJIpfDaHDJMJZ/TujJvuST528rK5SaKiZJLp0070ZWIojtVezG9B2CwAUAVQcNuGO2pBA1QReaLuCjzOinwCh1rwVevn0Pk13k3sW7NhNOVhD82nwgIMkR11nTrCRUplwSrbNegQwJKW1SgPbogIFzLIaqpc2PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762559643; c=relaxed/simple;
	bh=U27dSWc0EcPzkhgrN50zeLUecxgHYAlvhVcLIsEhIbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFjn56mfeyWJpiOzks7nOHlTXPrVq6UIS88NE49RNjLXCzDxsnmNa987txcCcNPqT3xga+MpiLOitAJHizQpS0n9uynbgJLpY60A8dCTlWU2qBylkIwbwcS+XPXBJcLGjfpVGSMhVafTafuQspMhsp+Lo8Y1X0kQvYkFkDYw5rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Z87WCAC9; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Z87WCAC9"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d3G9j47g7zm17wZ;
	Fri,  7 Nov 2025 23:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1762559640; x=1765151641; bh=2Md7J
	RFm2RwovUL3ImeIrBuNwNt3s55qZmGqvovpbpI=; b=Z87WCAC93cSs/GH1SK+SS
	WFeBqv15gF/JF+Nhqy+ySnEX4shQmL/XpKnahQjKeg25v8zI8Dlql6tr2WuTxD3X
	PB/ubQqy1024Yoyms6F3ZwqJIIoLxkQ5shAH/jnsLWtTGbgurCDDEG/dChNzvbHB
	Jcv9v6bEgXHvIzdRgoyJu4XOJabwhvaBB4Naj6vFAO3ux7rCAHHCvZVMFTVf9M67
	ZzUp2aBnAHkGM6fHI1kCiTfbEYL+BmFVgmUf/AyIdGuQ1NWB70fD0G4nDpndI2VB
	mhdhNw5Yxt1tRwuMcW42njD9cqqGfZDkEHRljVs+7u27STznJlyZgmFdcghgeb0t
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id p2vpV8yMqEZt; Fri,  7 Nov 2025 23:54:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d3G9c4tm3zm17wx;
	Fri,  7 Nov 2025 23:53:55 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v26 07/17] blk-zoned: Split an if-statement
Date: Fri,  7 Nov 2025 15:53:00 -0800
Message-ID: <20251107235310.2098676-8-bvanassche@acm.org>
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

Split an if-statement and also the comment above that if-statement. This
patch prepares for moving code from disk_zone_wplug_add_bio() into its
caller. No functionality has been changed.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index b14604d9d7bd..c15ce570c7f6 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1459,13 +1459,14 @@ static bool blk_zone_wplug_handle_write(struct bi=
o *bio, unsigned int nr_segs)
 	bio_set_flag(bio, BIO_ZONE_WRITE_PLUGGING);
=20
 	/*
-	 * If the zone is already plugged, add the BIO to the plug BIO list.
-	 * Do the same for REQ_NOWAIT BIOs to ensure that we will not see a
+	 * Add REQ_NOWAIT BIOs to the plug list to ensure that we will not see =
a
 	 * BLK_STS_AGAIN failure if we let the BIO execute.
-	 * Otherwise, plug and let the BIO execute.
 	 */
-	if ((zwplug->flags & BLK_ZONE_WPLUG_PLUGGED) ||
-	    (bio->bi_opf & REQ_NOWAIT))
+	if (bio->bi_opf & REQ_NOWAIT)
+		goto plug;
+
+	/* If the zone is already plugged, add the BIO to the BIO plug list. */
+	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
 		goto plug;
=20
 	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
@@ -1474,6 +1475,7 @@ static bool blk_zone_wplug_handle_write(struct bio =
*bio, unsigned int nr_segs)
 		return true;
 	}
=20
+	/* Otherwise, plug and submit the BIO. */
 	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
=20
 	spin_unlock_irqrestore(&zwplug->lock, flags);
