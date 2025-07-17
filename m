Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB1D1A314E;
	Thu, 17 Jul 2025 20:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752785945; cv=none; b=M93QQ2JNuBTtSXLoDvutVRuSHBKjbALniHSTtIfAjQRZ17CxZkbhM4ECDFYqZlIH1uFSZPCpIX5PCZ4w1ehR1iZXRwzwyXE5AUkHByetPkdqxPemtRcX7pItuBkJJhXqvRkJngpNq2oJ3eDHTK28MJaktqAn0ahRLpT5Kl3ky9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752785945; c=relaxed/simple;
	bh=+IY3QD27Fa9Z8VDjClVSGyZ94royiDG5ifjQhbjvSto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ed7s6HLY22aWPjA4CFIgsx/rX857vjZOcvUK4lIL80hCYb7mYzHGbS5GyiWEbiQVKaNU5lT9as+z5A865S9t+yKuxPS7z6Gl92bwSFO/D9Jragmm7D/1b12g5nSGkQeNDHz46FCx6oAkAjjHF3RsFoX5NelDqCvczmNPlfQv+hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bLSf32rd; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bLSf32rd"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bjldz02Wnzm0yTw;
	Thu, 17 Jul 2025 20:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752785941; x=1755377942; bh=fG2mC
	yyKgm/+vGr+zhfLIQe1/Erj5zoQ+daLWBd0Yag=; b=bLSf32rdChFqTmx12Ya1d
	5QWlu4KR9+HOFgq5FG1Xe5jVltODG4KoG0sGT1+mkzIXs3d4/evAfdB5ELEqXQAX
	KWa+jjoHU6QJfGYF1ooFPWkQH4HlyA9KdBf6dpHlgXwtnYZx/VTQSq1fUNg3YqmJ
	20rO3Ru49+ab/LgyRoyIziOdkPCllHAE27937voEsYeMmbLB1inBumIMLDhv834o
	SfobnYVspFQSP4si5pk7iSq9E57iTS2GAc9BE5X/UMC7z5MN7VUIBQp3YwQbJoIc
	4lEmRbQUwK05H8Koc/SUxUqodVrQUWzLXrydKaXjUE8maWvbvFlRfkr4dG2hpSGu
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xqxKmVdfBj46; Thu, 17 Jul 2025 20:59:01 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bjldt1Dnvzm0ysn;
	Thu, 17 Jul 2025 20:58:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v21 07/12] blk-zoned: Support pipelining of zoned writes
Date: Thu, 17 Jul 2025 13:58:03 -0700
Message-ID: <20250717205808.3292926-8-bvanassche@acm.org>
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

Support pipelining of zoned writes if the block driver preserves the writ=
e
order per hardware queue. Track per zone to which software queue writes
have been queued. If zoned writes are pipelined, submit new writes to the
same software queue as the writes that are already in progress. This
prevents reordering by submitting requests for the same zone to different
software or hardware queues.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c    |  4 +--
 block/blk-zoned.c | 66 ++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c1035a2bbda8..56384b4aadd9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3145,8 +3145,8 @@ void blk_mq_submit_bio(struct bio *bio)
 	/*
 	 * A BIO that was released from a zone write plug has already been
 	 * through the preparation in this function, already holds a reference
-	 * on the queue usage counter, and is the only write BIO in-flight for
-	 * the target zone. Go straight to preparing a request for it.
+	 * on the queue usage counter. Go straight to preparing a request for
+	 * it.
 	 */
 	if (bio_zone_write_plugging(bio)) {
 		nr_segs =3D bio->__bi_nr_segments;
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 6ef53f78fa3b..3813e4bc8b0b 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -53,6 +53,8 @@ static const char *const zone_cond_name[] =3D {
  * @zone_no: The number of the zone the plug is managing.
  * @wp_offset: The zone write pointer location relative to the start of =
the zone
  *             as a number of 512B sectors.
+ * @from_cpu: Software queue to submit writes from for drivers that pres=
erve
+ *	the write order.
  * @bio_list: The list of BIOs that are currently plugged.
  * @bio_work: Work struct to handle issuing of plugged BIOs
  * @rcu_head: RCU head to free zone write plugs with an RCU grace period=
.
@@ -65,6 +67,7 @@ struct blk_zone_wplug {
 	unsigned int		flags;
 	unsigned int		zone_no;
 	unsigned int		wp_offset;
+	int			from_cpu;
 	struct bio_list		bio_list;
 	struct work_struct	bio_work;
 	struct rcu_head		rcu_head;
@@ -74,8 +77,7 @@ struct blk_zone_wplug {
 /*
  * Zone write plug flags bits:
  *  - BLK_ZONE_WPLUG_PLUGGED: Indicates that the zone write plug is plug=
ged,
- *    that is, that write BIOs are being throttled due to a write BIO al=
ready
- *    being executed or the zone write plug bio list is not empty.
+ *    that is, that write BIOs are being throttled.
  *  - BLK_ZONE_WPLUG_NEED_WP_UPDATE: Indicates that we lost track of a z=
one
  *    write pointer offset and need to update it.
  *  - BLK_ZONE_WPLUG_UNHASHED: Indicates that the zone write plug was re=
moved
@@ -572,6 +574,7 @@ static struct blk_zone_wplug *disk_get_and_lock_zone_=
wplug(struct gendisk *disk,
 	zwplug->flags =3D 0;
 	zwplug->zone_no =3D zno;
 	zwplug->wp_offset =3D bdev_offset_from_zone_start(disk->part0, sector);
+	zwplug->from_cpu =3D -1;
 	bio_list_init(&zwplug->bio_list);
 	INIT_WORK(&zwplug->bio_work, blk_zone_wplug_bio_work);
 	zwplug->disk =3D disk;
@@ -768,14 +771,19 @@ static bool blk_zone_wplug_handle_reset_all(struct =
bio *bio)
 static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
 					      struct blk_zone_wplug *zwplug)
 {
+	lockdep_assert_held(&zwplug->lock);
+
 	/*
 	 * Take a reference on the zone write plug and schedule the submission
 	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the
 	 * reference we take here.
 	 */
-	WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
 	refcount_inc(&zwplug->ref);
-	queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
+	if (zwplug->from_cpu >=3D 0)
+		queue_work_on(zwplug->from_cpu, disk->zone_wplugs_wq,
+			      &zwplug->bio_work);
+	else
+		queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
 }
=20
 static inline void disk_zone_wplug_add_bio(struct gendisk *disk,
@@ -972,9 +980,12 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zo=
ne_wplug *zwplug,
 	return true;
 }
=20
-static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr=
_segs)
+static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr=
_segs,
+					int from_cpu)
 {
 	struct gendisk *disk =3D bio->bi_bdev->bd_disk;
+	const bool ordered_hwq =3D bio_op(bio) !=3D REQ_OP_ZONE_APPEND &&
+		disk->queue->limits.features & BLK_FEAT_ORDERED_HWQ;
 	sector_t sector =3D bio->bi_iter.bi_sector;
 	bool schedule_bio_work =3D false;
 	struct blk_zone_wplug *zwplug;
@@ -1034,15 +1045,38 @@ static bool blk_zone_wplug_handle_write(struct bi=
o *bio, unsigned int nr_segs)
 	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
 		goto add_to_bio_list;
=20
+	if (ordered_hwq && zwplug->from_cpu < 0) {
+		/* No zoned writes are in progress. Select the current CPU. */
+		zwplug->from_cpu =3D raw_smp_processor_id();
+	}
+
+	if (ordered_hwq && zwplug->from_cpu =3D=3D from_cpu) {
+		/*
+		 * The block driver preserves the write order, zoned writes have
+		 * not been plugged and the zoned write will be submitted from
+		 * zwplug->from_cpu. Let the caller submit the bio.
+		 */
+	} else if (ordered_hwq) {
+		/*
+		 * The block driver preserves the write order but the caller
+		 * allocated a request from another CPU. Submit the bio from
+		 * zwplug->from_cpu.
+		 */
+		goto plug;
+	} else {
+		/*
+		 * The block driver does not preserve the write order. Plug and
+		 * let the caller submit the BIO.
+		 */
+		zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
+	}
+
 	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
 		spin_unlock_irqrestore(&zwplug->lock, flags);
 		bio_io_error(bio);
 		return true;
 	}
=20
-	/* Otherwise, plug and submit the BIO. */
-	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
-
 	spin_unlock_irqrestore(&zwplug->lock, flags);
=20
 	return false;
@@ -1150,7 +1184,7 @@ bool blk_zone_plug_bio(struct bio *bio, unsigned in=
t nr_segs, int rq_cpu)
 		fallthrough;
 	case REQ_OP_WRITE:
 	case REQ_OP_WRITE_ZEROES:
-		return blk_zone_wplug_handle_write(bio, nr_segs);
+		return blk_zone_wplug_handle_write(bio, nr_segs, rq_cpu);
 	case REQ_OP_ZONE_RESET:
 		return blk_zone_wplug_handle_reset_or_finish(bio, 0);
 	case REQ_OP_ZONE_FINISH:
@@ -1182,6 +1216,9 @@ static void disk_zone_wplug_unplug_bio(struct gendi=
sk *disk,
=20
 	zwplug->flags &=3D ~BLK_ZONE_WPLUG_PLUGGED;
=20
+	if (refcount_read(&zwplug->ref) =3D=3D 2)
+		zwplug->from_cpu =3D -1;
+
 	/*
 	 * If the zone is full (it was fully written or finished, or empty
 	 * (it was reset), remove its zone write plug from the hash table.
@@ -1283,6 +1320,8 @@ static void blk_zone_wplug_bio_work(struct work_str=
uct *work)
 	struct blk_zone_wplug *zwplug =3D
 		container_of(work, struct blk_zone_wplug, bio_work);
 	struct block_device *bdev;
+	bool ordered_hwq =3D zwplug->disk->queue->limits.features &
+				BLK_FEAT_ORDERED_HWQ;
 	struct bio *bio;
=20
 	do {
@@ -1323,7 +1362,7 @@ static void blk_zone_wplug_bio_work(struct work_str=
uct *work)
 		} else {
 			blk_mq_submit_bio(bio);
 		}
-	} while (0);
+	} while (ordered_hwq);
=20
 put_zwplug:
 	/* Drop the reference we took in disk_zone_wplug_schedule_bio_work(). *=
/
@@ -1850,6 +1889,7 @@ static void queue_zone_wplug_show(struct blk_zone_w=
plug *zwplug,
 	unsigned int zwp_zone_no, zwp_ref;
 	unsigned int zwp_bio_list_size;
 	unsigned long flags;
+	int from_cpu;
=20
 	spin_lock_irqsave(&zwplug->lock, flags);
 	zwp_zone_no =3D zwplug->zone_no;
@@ -1857,10 +1897,12 @@ static void queue_zone_wplug_show(struct blk_zone=
_wplug *zwplug,
 	zwp_ref =3D refcount_read(&zwplug->ref);
 	zwp_wp_offset =3D zwplug->wp_offset;
 	zwp_bio_list_size =3D bio_list_size(&zwplug->bio_list);
+	from_cpu =3D zwplug->from_cpu;
 	spin_unlock_irqrestore(&zwplug->lock, flags);
=20
-	seq_printf(m, "%u 0x%x %u %u %u\n", zwp_zone_no, zwp_flags, zwp_ref,
-		   zwp_wp_offset, zwp_bio_list_size);
+	seq_printf(m, "zone_no %u flags 0x%x ref %u wp_offset %u bio_list_size =
%u from_cpu %d\n",
+		   zwp_zone_no, zwp_flags, zwp_ref, zwp_wp_offset,
+		   zwp_bio_list_size, from_cpu);
 }
=20
 int queue_zone_wplugs_show(void *data, struct seq_file *m)
