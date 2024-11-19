Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EA485956;
	Tue, 19 Nov 2024 00:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976142; cv=none; b=DT0fQ5zvN8xHnybkSTt13aL0AMeuq+56NDdWX46Dx3s6kC7aW7qHSCHOck16R2XQwcgJdW3gDMx16JTEN6Y2JKPpcquSA9EZx2m29gG/MGQQeUFy22HmefJv+yzSJjMFaviokl5M2Dev8iFqxz5ZkeQBthcChmZ8r254qFPbeUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976142; c=relaxed/simple;
	bh=+xK2oaLrr8HO08NFs9MHzCcsEr4cVuqvKd/tWQ0+RvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHrE1acuEhFvFaQfUSPd4cJk6hviaabl2KXny7v91BLidUpcFhYpcnee8WqcyaViPv5dTBjXp51XdxeeHwhMi2BWjW7xcdLi3mrTRrekMhrokxn5FL3v0Sg/K1H9+cmVGbOP2jMIUbyyijJPoHkNUIpikiufwqpH1Lqs7kAZWK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=n15Isiem; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="n15Isiem"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljT1flxzlgMVc;
	Tue, 19 Nov 2024 00:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976137; x=1734568138; bh=SCPA9
	PUI3otf9aArN2z/q/hRgSOZLD5iRBbmbUow0HQ=; b=n15Isiemzh8xZkjuAiK+z
	4MvM9bSX+fhuvn2Ek81AgAELdJowsJZq1jgBbc6CCpDsx8QX867bFHjhOGeQayoV
	PDajjeEjIZvBaaabrcMHl3VwohRNA2TcKXkY9BP7u3SYafcZ4pWil2XgM67+O1Au
	PV/alWxwG7WzpgQOghu6osN9x+5NL1W1PpZ1B//0nZ2J3JNN5RhvsUmlCdvRjw5m
	qGpQ+owF6Bxh1AoldGZVUfnICn+sgcihGLasUMWFjya9CBom/hUvvUKqQd14fozv
	d4tVII+viHzKAyHJPeSdKgbJwmOFCCuKXtgRLqbvhiNpCELcPvoyGdrckaZvzwQF
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id esQLrL8NlFr4; Tue, 19 Nov 2024 00:28:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XsljN2THGzlgT1M;
	Tue, 19 Nov 2024 00:28:56 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 17/26] blk-zoned: Uninline functions that are not in the hot path
Date: Mon, 18 Nov 2024 16:28:06 -0800
Message-ID: <20241119002815.600608-18-bvanassche@acm.org>
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

Apply the convention that is followed elsewhere in the block layer: only
declare functions inline if these are in the hot path.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 17fe40db1888..2b4783026450 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -558,8 +558,8 @@ static struct blk_zone_wplug *disk_get_and_lock_zone_=
wplug(struct gendisk *disk,
 	return zwplug;
 }
=20
-static inline void blk_zone_wplug_bio_io_error(struct blk_zone_wplug *zw=
plug,
-					       struct bio *bio)
+static void blk_zone_wplug_bio_io_error(struct blk_zone_wplug *zwplug,
+					struct bio *bio)
 {
 	struct request_queue *q =3D zwplug->disk->queue;
=20
@@ -580,8 +580,8 @@ static void disk_zone_wplug_abort(struct blk_zone_wpl=
ug *zwplug)
 		blk_zone_wplug_bio_io_error(zwplug, bio);
 }
=20
-static inline void disk_zone_wplug_set_error(struct gendisk *disk,
-					     struct blk_zone_wplug *zwplug)
+static void disk_zone_wplug_set_error(struct gendisk *disk,
+				      struct blk_zone_wplug *zwplug)
 {
 	unsigned long flags;
=20
@@ -607,8 +607,8 @@ static inline void disk_zone_wplug_set_error(struct g=
endisk *disk,
 	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
 }
=20
-static inline void disk_zone_wplug_clear_error(struct gendisk *disk,
-					       struct blk_zone_wplug *zwplug)
+static void disk_zone_wplug_clear_error(struct gendisk *disk,
+					struct blk_zone_wplug *zwplug)
 {
 	unsigned long flags;
=20
@@ -1597,7 +1597,7 @@ void disk_free_zone_resources(struct gendisk *disk)
 	disk->nr_zones =3D 0;
 }
=20
-static inline bool disk_need_zone_resources(struct gendisk *disk)
+static bool disk_need_zone_resources(struct gendisk *disk)
 {
 	/*
 	 * All mq zoned devices need zone resources so that the block layer
