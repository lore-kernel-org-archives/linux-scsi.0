Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FFF2D97A7;
	Mon, 11 Aug 2025 20:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754943013; cv=none; b=ug53FJOsic2+bZVR6YPGVRXV112MPyDcVp3Rg3iALLkZauTpxYDrgAkCsqFjGKRmaLVZXKyyOmD5aURBuNlK0BlMl46emlqtJvN+6PG5ur04sgJJKAoJKmrVYmFNSmKbbmdR93Z6W1/sfh4JvflwutZOSe9X6Z0Xb8gyaLwtr3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754943013; c=relaxed/simple;
	bh=o4ktZsYgCbcj1z+vgfc43dA7xTwSK9FqKrXoHT7HV50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcG/oaufg1uu8Ix1XUWCttVdZcIbQubxeMIPXLyn/rhBzYzG3J1WSIihC9QS0myKCBwK8AluGWalpq9HmwpWa1lr2iVOwTnJ5L8YKzNco5FgVkS27t9bsQsDgaBNNVqMcJqNygvKt5wu92d3payofXEgoyW85nqu4rrAH+f4ObE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VF7lNvZR; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VF7lNvZR"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c15N21fBxzm0ySc;
	Mon, 11 Aug 2025 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754943008; x=1757535009; bh=sDDtc
	2fu/tm/jW/ilhgqjhJOFwKb7FCXgrElasM75a0=; b=VF7lNvZRebfKkQWm1oZ9m
	MR/RM5TrWV6cgWv8gJSVJoEtYvldiEIwIhm9YQladFR4Ze5puieudSMLZjsDNcNk
	3+OOW7Xvz9mU5J0TZz3wojZ8nOZ8/vu+0tQ3k12YoctryVz0QR3iQXdmvWCkZUbf
	0sAnF4FhCjY31hD++DtywxPK1tcdI1Q5RDawdcUsC+hSpwc9O4xRtCE+PEs3ibDN
	OWxxg6S1wZMxiNQyGLMdj7uW3lyOEirtjc8r9Bo1DYkQH5clvJ/sWSTtlQR0cDaj
	u81Vr6ET5qdTiawtzOoIZXA3RKzL3cZbUE72UlE5yVx7ZMDZRNrrfYDcUkPgqz7i
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IbMf1jkYBakf; Mon, 11 Aug 2025 20:10:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c15Mw6PC9zm0yV6;
	Mon, 11 Aug 2025 20:10:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v23 07/16] blk-zoned: Split an if-statement
Date: Mon, 11 Aug 2025 13:08:42 -0700
Message-ID: <20250811200851.626402-8-bvanassche@acm.org>
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
index 158ad8629d43..7420f83d104f 100644
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
