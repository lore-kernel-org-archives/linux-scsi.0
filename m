Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E37630CD85;
	Wed, 27 Aug 2025 21:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330248; cv=none; b=Ojw2nCxQaRFM4ChrksZNzOvePNmxetALFkhiLeZdXaIFzuozNzP8OkvGfZ57FpQFyaacAARPFLQrpHufZkM6BEZAkbOfe6hkdC4uCDqlo58oryElVrE6ZfluJFXpXr64Fzdpt21y7UlfTHp370PP6m+BOtcWkeq6hD1GcU/+/WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330248; c=relaxed/simple;
	bh=PRYqRDTBtpuSNp0zOaFcLyfe1G/51JW5kj3hp2N+l7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buDlZoyVx2fr60kAcS9KxBvZAjDqgSoV3mWawF1avloy0HT7Fil1lPlDPyNXbTKFLcLloqMj02fRGOTRPsMMJu+ufqIijVNnAskcCZWjO3ej+OVF3HkE7399/bSuO/cOByJGdC9JZD3x0Yvy5l2ZQBDNAb1ybNA8KGRGxWr9ajs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KP+kmm1U; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KP+kmm1U"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByPd550mzm174B;
	Wed, 27 Aug 2025 21:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330244; x=1758922245; bh=SoMaE
	HuVl+m+bEMvK/4KKl1vZxG3WwHpf1V7GGL51dE=; b=KP+kmm1UUBNR9Zc63truW
	jNJdnZ5+c2adxOxQsDUvnPERjUcofa872qhBFYJsFsVsYuqU/8dY9nprUrwjIkBA
	m0KFDZEADuxNFfOU+TymNzRCzCqQyneY9VFzKDI5nIzQcLK0pe3yFqwbt91eqou2
	ybg0urpNTl3JAAxt8xttcKpg3G7MQkK8MLL6dRQ4q2oG1zpuwxbZwYwOM6aN4utQ
	WjBsnLBlt3yhenW8iYPt6EE5T/8PTRLvVNHdiqd6Avln+ETiMDYdwCtEOD3eATRW
	wc/rtimhuR5rWrFujhXUR9xCxo91YgbfhmcxB415cUw6/nPsdurOTLPFiRUDmSL4
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DT14YQHjcIgX; Wed, 27 Aug 2025 21:30:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByPX0Yhzzm0ySh;
	Wed, 27 Aug 2025 21:30:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v24 08/18] blk-zoned: Split an if-statement
Date: Wed, 27 Aug 2025 14:29:27 -0700
Message-ID: <20250827212937.2759348-9-bvanassche@acm.org>
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
index dfc77fc44837..f7f43b7e6f31 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1053,13 +1053,14 @@ static bool blk_zone_wplug_handle_write(struct bi=
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
+	/* If the zone is already plugged, add the BIO to the plug BIO list. */
+	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
 		goto plug;
=20
 	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
@@ -1068,6 +1069,7 @@ static bool blk_zone_wplug_handle_write(struct bio =
*bio, unsigned int nr_segs)
 		return true;
 	}
=20
+	/* Otherwise, plug and submit the BIO. */
 	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
=20
 	spin_unlock_irqrestore(&zwplug->lock, flags);
