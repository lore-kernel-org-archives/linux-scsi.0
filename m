Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB8CDDD9;
	Tue, 19 Nov 2024 00:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976146; cv=none; b=UI/vo0YFrwjy+UYY3Y0YTpekZGftpo1h7nzxQIs1vm2+5tWBUf7EFuea32s4a060+07vu9AGlNot49BKs3mTbHz/Ebhrbn6kaEUCkM+cHfMO+8rqhhc5fh68RhspnJm3XdwVzhJEh4b4jFAmYjYki9zsanzNkP88xTfZDjsnYoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976146; c=relaxed/simple;
	bh=nH7YAVHzBh202POY8G4tJIN0Gy33p/of5ZpcPsHrbZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnbHZyeaTETKmBOwLsu+Cmqj9JABtP/OQ8Cgtnq9B8tIrWBOtWCCK2i4pZJaTq13/1oBt5RcQOyysJNzEtQY1iN6cLjcy8Dfjsg9+utsszoIrpgF0LVcSDezVXhge/9csDi9nkaGxl1Iuk1Q/94eThCyf9ehdYijIRoDQeKqWUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LKrJoeBD; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LKrJoeBD"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljY1vpFzlgMVg;
	Tue, 19 Nov 2024 00:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976140; x=1734568141; bh=icrDL
	w2/tDGWLUCZD68srtLa4ZCNc3u6D6f3ezs2BU8=; b=LKrJoeBDbcKpF2LVaseQR
	euGezVCZGdu7tBSqPDfntcgTBOgZFd+9lMZm+TQ/zoR3XftAiXppGJdjtUQHu023
	TfXnVxAfSWUcqx3e1lwQWrahGQKN7woLpBK2e/AxFMxJnwRoH3z8Di29fim7jwu7
	RagnfaN+9mgnuzu67FeZndkztWbKVXsG7b3shJK/ESRSQP9mbtGBI7jHzzLV0ieR
	8vuP4nM24AOdONf4qq7ptB5fQj4yE/Pty1MBhkkLELLKb1mbYXTRsK6Y76BhFAtu
	tr9gxoRIsKpeh+725BS6SX4u+xLl5uAhtLBeFZ3k/smh83qTpvbL/Q+C5bgTAEaL
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tRdbjoKXvXAK; Tue, 19 Nov 2024 00:29:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XsljR3wzKzlgVXv;
	Tue, 19 Nov 2024 00:28:59 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 19/26] blk-zoned: Add an argument to blk_zone_plug_bio()
Date: Mon, 18 Nov 2024 16:28:08 -0800
Message-ID: <20241119002815.600608-20-bvanassche@acm.org>
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

Prepare for preserving the order of pipelined zoned writes per zone.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c         | 2 +-
 block/blk-zoned.c      | 3 ++-
 drivers/md/dm.c        | 2 +-
 include/linux/blkdev.h | 6 ++++--
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1302ccbf2a7d..b396ddfe7165 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3135,7 +3135,7 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
 		goto queue_exit;
=20
-	if (blk_queue_is_zoned(q) && blk_zone_plug_bio(bio, nr_segs))
+	if (blk_queue_is_zoned(q) && blk_zone_plug_bio(bio, nr_segs, &swq_cpu))
 		goto queue_exit;
=20
 new_request:
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 59f6559b94da..8d0fac14c837 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1049,6 +1049,7 @@ static bool blk_zone_wplug_handle_write(struct bio =
*bio, unsigned int nr_segs)
  * blk_zone_plug_bio - Handle a zone write BIO with zone write plugging
  * @bio: The BIO being submitted
  * @nr_segs: The number of physical segments of @bio
+ * @swq_cpu: [out] CPU of the software queue to which the bio should be =
queued
  *
  * Handle write, write zeroes and zone append operations requiring emula=
tion
  * using zone write plugging.
@@ -1057,7 +1058,7 @@ static bool blk_zone_wplug_handle_write(struct bio =
*bio, unsigned int nr_segs)
  * write plug. Otherwise, return false to let the submission path proces=
s
  * @bio normally.
  */
-bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
+bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs, int *swq_c=
pu)
 {
 	struct block_device *bdev =3D bio->bi_bdev;
=20
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 19230404d8c2..cd85c9b6a463 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1796,7 +1796,7 @@ static inline bool dm_zone_bio_needs_split(struct m=
apped_device *md,
 }
 static inline bool dm_zone_plug_bio(struct mapped_device *md, struct bio=
 *bio)
 {
-	return dm_emulate_zone_append(md) && blk_zone_plug_bio(bio, 0);
+	return dm_emulate_zone_append(md) && blk_zone_plug_bio(bio, 0, NULL);
 }
=20
 static blk_status_t __send_zone_reset_all_emulated(struct clone_info *ci=
,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 72be33d02d1f..1c28ec5b75ce 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -694,13 +694,15 @@ static inline unsigned int disk_nr_zones(struct gen=
disk *disk)
 {
 	return disk->nr_zones;
 }
-bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs);
+struct blk_mq_ctx;
+bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs, int *swq_c=
pu);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline unsigned int disk_nr_zones(struct gendisk *disk)
 {
 	return 0;
 }
-static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_se=
gs)
+static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_se=
gs,
+				     int *swq_cpu)
 {
 	return false;
 }
