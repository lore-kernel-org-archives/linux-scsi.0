Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6476324A046;
	Tue, 14 Oct 2025 21:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478950; cv=none; b=tKvEJOIWz94P18L0r0ZQur7O2WFp391T6uJo+zOjG11CbHLZ80m/etSFMMgJRT9zGdob5Ffv6pbMdoHIy7b+2v0TATPo9CuOOM5+u0evssuJK/mQQEADJHEgpZEZiXVYPmqBZNvVrULDQSqcMCaxfIQ8GEVOvLj1AOXUVq0mwKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478950; c=relaxed/simple;
	bh=RS9M7l1yNLm6MY5NwCxYz6Ea/Rw4/bl5PIshJbHj9FE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hl9YV2gnR4uF/OqaJNJXlrjfW9TnXWkNw6+x84rZggkUmDfsFb9In3UcfsxGDQjJ3tOBFYhPNy/HOl/9psA9SyOf/kYy/pMIJzPvzZkmxp+Ax+VEcvhtvWmWBlo8jl7dMpP6uHMZYSxE1/WxNj44Zq+93uhpe/Q2bEFX9F+bT80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vJPZPTQ3; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vJPZPTQ3"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmShM5kstzm0yVD;
	Tue, 14 Oct 2025 21:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478946; x=1763070947; bh=mLGt6
	eEgi9oOcOUMdpDihAfvXF3oaHg1sdZui/JibnE=; b=vJPZPTQ3WYGj3MqMSFJQ2
	dVYqNf1K9jNkgfj6ummM4RtSSsn/w+nGZPFaWuqoQ6cB8eHfVXqwCY/NlMAWoNJB
	RW9aACDdEayM+kpqzTZZWre4p0vyRTqY3dyVZq1MxUwUB1Ls4Bji47RpDJKm1kbI
	kAtVs4IZEyYcQYH9b5cwwhrfWzRms8Jrfgim1dg0wYCdyjdeYQ6q84j66lbyR4ER
	iVEQJJ+Y5+SnwgXkULVzT9VhVdgLlvn9IZYamjj5eSZZsy76VjdsZAyR2o2m3pT6
	qmulCocQt+smbFQdZ3THQU85uliNT2jF+9YnuNJwm5aQ4uN2QdyrnojEpyefcMZ2
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 12mKK1XnLR2e; Tue, 14 Oct 2025 21:55:46 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmShF3yjpzm0yVJ;
	Tue, 14 Oct 2025 21:55:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 10/20] blk-zoned: Split an if-statement
Date: Tue, 14 Oct 2025 14:54:18 -0700
Message-ID: <20251014215428.3686084-11-bvanassche@acm.org>
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
index aff7ab5487cd..063b7b9459dd 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1057,13 +1057,14 @@ static bool blk_zone_wplug_handle_write(struct bi=
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
@@ -1072,6 +1073,7 @@ static bool blk_zone_wplug_handle_write(struct bio =
*bio, unsigned int nr_segs)
 		return true;
 	}
=20
+	/* Otherwise, plug and submit the BIO. */
 	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
=20
 	spin_unlock_irqrestore(&zwplug->lock, flags);
