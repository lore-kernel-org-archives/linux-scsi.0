Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700FA21858A;
	Thu, 24 Jul 2025 21:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394299; cv=none; b=h+5x6vp9k63y0MKRuohNfVJ4/KUsLxJ2abCdN0Bcaq8WbDGbE9Hqoq8kG9fkYZJq9bcMbHS0+oimP8gAbsMt5AaTKg4FU5T3KEvsQeli5JC5JGya2CCkUV77wR1qh7lVPT6lHN2ZMEUnxY32euEtOYeQ4Mqz00QiQ5x7mJZAAug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394299; c=relaxed/simple;
	bh=RsjlmtOJNPaADoddlLJafJzl2/JXQHQ5Iz6AdW9Y9Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7/k0T7+KiEssJTJ97dkwZ1GCfuAEs0S2GKrSBxwP51NJfuYZxwkQegPXfGIvYMK2b9QzlmxDMkTHNqWGbsGOkllaiUpk8/o9/2J8vMnid+1sE5KAYGKyLrn/K+gmiwWjjD8c7ktdZGkWPM+QqwzQRsLHhnzaD037KYJcQQ2LUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=O46O15Ir; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="O46O15Ir"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bp4d30jBRzlgqVB;
	Thu, 24 Jul 2025 21:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1753394293; x=1755986294; bh=EWv4p
	tzJPZw7YopJ496MlNf8PVAJVFs9YiBa9W6g//s=; b=O46O15IriXEUhvfokOnOE
	9qFE9tTmdxPf+Ytper9dvDVFV/Hlk5hZc5m5ByH6cmtJCi8wKIReXduTiSYjQpNW
	WRA1PJAJ3C+/hoQBCLf9+s5vzxuk5jQVFSCLgvneQKrvfKSw/1bYeueFmF08p9mJ
	PzYOQG+N3Bo66LPIYNSnm0UyPjKjOt0HP8JHTygf8ba+msaocgy32o5ppyJplUOU
	XAqjf6XUliS09ozT0vng5H8DE8FRDcIH/WZXfi3c0pmJM990Wi+khLul+9NTngAn
	2ydj7gRICENnTWfzbqPI4kkymc7v61g+XEVqFZV1FLJ6IiN1EpbFcOeV9iA9Dc0l
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gHKgPZhvvluq; Thu, 24 Jul 2025 21:58:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bp4cy0VLFzlgqV4;
	Thu, 24 Jul 2025 21:58:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v22 05/14] blk-zoned: Split an if-statement
Date: Thu, 24 Jul 2025 14:56:54 -0700
Message-ID: <20250724215703.2910510-6-bvanassche@acm.org>
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
index 7e0f90626459..d7bdc92bedae 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1036,13 +1036,14 @@ static bool blk_zone_wplug_handle_write(struct bi=
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
@@ -1051,6 +1052,7 @@ static bool blk_zone_wplug_handle_write(struct bio =
*bio, unsigned int nr_segs)
 		return true;
 	}
=20
+	/* Otherwise, plug and submit the BIO. */
 	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
=20
 	spin_unlock_irqrestore(&zwplug->lock, flags);
