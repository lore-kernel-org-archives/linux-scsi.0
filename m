Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F27EEBB;
	Thu, 17 Jul 2025 20:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752785932; cv=none; b=Z/9CKJ6MuF5Y0kHM0ioB9EpaBv9jEkXtMyCwadQkBt+Akkdn6eiTmfTvdSdpP6iD2nCaOXMQenyf2TFqlTZ1L021RXszGccxRdNEmu7BMTHm3Q8kPIbPaMNg3SRYquIwHSxNe3AQ9PrY9Pz3G4ADKL4O5ToFzDCnWsYsBMLxd9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752785932; c=relaxed/simple;
	bh=DBGaAMiNi0cm39qGQMS8rxwvlORA80idPLg26ZkyohQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq+C5PcLTYFNN4TwtU4kCnoVQEsFR3ZtkMs7e/cIzkvlUa3oUv8i6oXhH+HuzduLjCV9heO01/yLRswKZ6rikGoX/dd6QWFS3AIR17xS1nJwXl1pgHq/kMIp07S3xN5HuYbJJdjaY8XmJWuSR4b2yw+QB09kZidKe0kX/8J/amM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ueYMeZZO; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ueYMeZZO"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bjldk1MWYzm0yVk;
	Thu, 17 Jul 2025 20:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752785928; x=1755377929; bh=JHJBg
	wzMER8NDQNsylbjwl22uGqNnJ/vOI5aZ0lbjCI=; b=ueYMeZZOn7ecrT7ij7rCT
	kNkDG0w3a+dn/jcpN/+oK16GlyhIkyq/Es3QaTGe62Fnv12eUOzDS3hd5nGtNl0n
	0B1jlXQySezRX5dOad/+O/roj12kX/6i4Vk9yQR/Sz/FZiSTsZ9ofM33Vq+DTi+s
	1ShF7br6SnsiZ8YsgqkYeb2acweT9pVdSG0N/Ml5ib3ndM/GKaavGj+2jBNNQa2+
	1gwjWVFMr/mbN+bxrkKnrUrxbRlhCXoVKOPXBbuUIG1srO7Qaup4wO6VGWDXRXnK
	S6aMFa6dJXFD7mhcV9Q6BjxuhW+DKsl4PyD/qBZI1U/0G9lZYhyUM7Oimp4ug+2I
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id w3ptTxUSbS8r; Thu, 17 Jul 2025 20:58:48 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bjldd20Bnzm0yTl;
	Thu, 17 Jul 2025 20:58:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v21 04/12] blk-zoned: Split an if-statement
Date: Thu, 17 Jul 2025 13:58:00 -0700
Message-ID: <20250717205808.3292926-5-bvanassche@acm.org>
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

Split an if-statement and also the comment above that if-statement. This
patch prepares for moving code from disk_zone_wplug_add_bio() into its
caller. No functionality has been changed.

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
