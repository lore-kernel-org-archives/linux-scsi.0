Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53A730C631;
	Wed, 27 Aug 2025 21:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330243; cv=none; b=JdbIaDfQTjOgQWSB5xnF/ltdgrHFwmFIKDIIyjDL64NkaDvHe8TolMTkE1hhQDVY9Wli9BMaJ64VajvHIF+VcXWgSbddNFznzNBOJST02oDG8KKYIs3Oc9NatC3X/O8MoFv6KaXDvrJoQCoNMxe8iqMR0lfQx0zep6Bo/s3/ZIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330243; c=relaxed/simple;
	bh=H0Qsm8JuwfJmGjx5FIsLZDPybDwwkGHcObVxzD5cH7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evSmIbt1q05dC02Zbku9wxkpzkrVquMpgOz7RjEoMO+siHuxjFzJUYsyBIZ1npaeLU3dCipPCB6fp2zIiPlS2MMCbWjLrKQR0/+OvOXYvCJy2ew5bk0oqBUHpIO4unSSinlQvVu2UQy2t+mLLN7UV7WUe5nWBb6Cr6jH++nhhqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=d8CxMyc/; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="d8CxMyc/"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cByPX5Hxhzm174D;
	Wed, 27 Aug 2025 21:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756330239; x=1758922240; bh=s9dXX
	xjcBw1WtTKxbcptIuhUlx+q+NwxPuDiIgNg5+k=; b=d8CxMyc/qF5QIcqNZ0D6B
	+ybUkDaAH5+awLazmgES3T2i1InL8pNZ+qCP6gXlgE6k26gOaNmgvkOBLkfaOYGS
	MqYIWc2dpdyAc35mFqA/uncU1xr08fzMif8n0Df5jI4oiiQ/UQzxeZSWGhYEE2wN
	AQ2rPp6n32ykp/HwMKLIE6C4XFsTaB0bAprdfszlUCBRtBpHLZZtDTUTWZAynj2c
	dJTYEDVhP26061DiUPUlim4cdSK1A3GRounlZN5uRVg9jgXtpJm0ximCTfnD9mdl
	Ccyk1Lc61XEEa/JfecOIU1PhJI8ySNZBW489InCas0eTIXjkNbmRc52i6FQ9OYZp
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zzYwfx5f5rI2; Wed, 27 Aug 2025 21:30:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cByPR4Xd3zm174P;
	Wed, 27 Aug 2025 21:30:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v24 07/18] blk-zoned: Add an argument to blk_zone_plug_bio()
Date: Wed, 27 Aug 2025 14:29:26 -0700
Message-ID: <20250827212937.2759348-8-bvanassche@acm.org>
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

Software that submits zoned writes, e.g. a filesystem, may submit zoned
writes from multiple CPU cores as long as the zoned writes are serialized
per zone. Submitting bios from different CPUs may cause bio reordering if
e.g. different bios reach the storage device through different queues.
Prepare for preserving the order of pipelined zoned writes per zone by
adding the 'rq_cpu` argument to blk_zone_plug_bio(). This argument tells
blk_zone_plug_bio() from which CPU a cached request has been allocated.
The cached request will only be used if it matches the CPU from which
zoned writes are being submitted for the zone associated with the bio.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c         | 7 +++----
 block/blk-zoned.c      | 5 ++++-
 drivers/md/dm.c        | 5 ++---
 include/linux/blkdev.h | 5 +++--
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 33b639653b5d..31c0db1fc217 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3219,10 +3219,9 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
 		goto queue_exit;
=20
-	if (bio_needs_zone_write_plugging(bio)) {
-		if (blk_zone_plug_bio(bio, nr_segs))
-			goto queue_exit;
-	}
+	if (bio_needs_zone_write_plugging(bio) &&
+	    blk_zone_plug_bio(bio, nr_segs, rq ? rq->mq_ctx->cpu : -1))
+		goto queue_exit;
=20
 new_request:
 	if (rq) {
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 1b5923c1a149..dfc77fc44837 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1127,6 +1127,9 @@ static void blk_zone_wplug_handle_native_zone_appen=
d(struct bio *bio)
  * blk_zone_plug_bio - Handle a zone write BIO with zone write plugging
  * @bio: The BIO being submitted
  * @nr_segs: The number of physical segments of @bio
+ * @rq_cpu: software queue onto which a request will be queued. -1 if th=
e caller
+ *	has not yet decided onto which software queue to queue the request or=
 if
+ *	the bio won't be converted into a request.
  *
  * Handle write, write zeroes and zone append operations requiring emula=
tion
  * using zone write plugging.
@@ -1135,7 +1138,7 @@ static void blk_zone_wplug_handle_native_zone_appen=
d(struct bio *bio)
  * write plug. Otherwise, return false to let the submission path proces=
s
  * @bio normally.
  */
-bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
+bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs, int rq_cpu=
)
 {
 	struct block_device *bdev =3D bio->bi_bdev;
=20
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a44e8c2dccee..cd0ec4a39b4d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1804,9 +1804,8 @@ static inline bool dm_zone_bio_needs_split(struct b=
io *bio)
=20
 static inline bool dm_zone_plug_bio(struct mapped_device *md, struct bio=
 *bio)
 {
-	if (!bio_needs_zone_write_plugging(bio))
-		return false;
-	return blk_zone_plug_bio(bio, 0);
+	return bio_needs_zone_write_plugging(bio) &&
+		blk_zone_plug_bio(bio, 0, -1);
 }
=20
 static blk_status_t __send_zone_reset_all_emulated(struct clone_info *ci=
,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2c2579d4b7ed..88fdbd6b1ac0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -904,7 +904,7 @@ static inline bool bio_needs_zone_write_plugging(stru=
ct bio *bio)
 	}
 }
=20
-bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs);
+bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs, int rq_cpu=
);
=20
 /**
  * disk_zone_capacity - returns the zone capacity of zone containing @se=
ctor
@@ -944,7 +944,8 @@ static inline bool bio_needs_zone_write_plugging(stru=
ct bio *bio)
 	return false;
 }
=20
-static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_se=
gs)
+static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_se=
gs,
+				     int rq_cpu)
 {
 	return false;
 }
