Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259DA1A8F84;
	Tue,  8 Jul 2025 22:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012497; cv=none; b=UgpDFS/9prjEO0HY3fi7DyT2HbgyvBv41NyEt2+yXDAQ1Vdg85msU7IrEJrhUX56Dw2zt7m22vjC3cuB5C9hMgPDDKD6DfdNW1HiHsgWRhhPlM2y69T73oii+wC5sGvBpBo86123TodrW1BdnCL/3oy2Wn6H40WV1MJ8yiHcBJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012497; c=relaxed/simple;
	bh=gJLxKx2g50UGHdQMrQUFMhmSbusgU+05dETnrJFJhDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUSWDRi6awgk2kO1aPVoUUDaZm+rSkj9bcyhxnJDvqses45//I01BKzvsNGdCpMyVll3KNzD0SmmV5F+Ts6Vmkokx8W5g3S8hIuw6kCTWxfk/IPkU10H9Cg4dsqXtRSLjCMSTl35iWSRH6awBC+zbr251EgbMJZRa6wuYRq6Lps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HDCFmg41; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HDCFmg41"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bcFby0z5xzltNQL;
	Tue,  8 Jul 2025 22:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1752012492; x=1754604493; bh=CEvbn
	2VP74VF+4F7Gxx+U6NyruAfph3VX7NUEQNxZ34=; b=HDCFmg41uRiYkisgvfNYy
	fMraS5AKWYScDS8EnYuzfAB5YvFMHeOvnxuAw75fWsMt97IkAu9rIGTd7FZmOD9P
	xe+j6DnqPUGaUGfQkJp+xRGqBmhzpPZCAKxluLrdicZlB5xaEsA/Gd1Da/yhKbws
	OzeyCBaxKCZm+MlN5mawGGb1AQcn2XRfqKMietwu5vZsRw6ZEQZ6YA9aVEe4xZ0L
	mfqzFg6+bQcmKMWmhSop/a36mX60DVMMAsr0QhpyDIO2LfUJMz7KHQy50xRK41KQ
	UNiO2lQ9IWioFp1p4NGucAJOJuNhYF6aSoRY6FR+4Xc6v18NGS9C4alM/xWHe6OM
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iqKmcon2UtFT; Tue,  8 Jul 2025 22:08:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bcFbr3PnjzltKGR;
	Tue,  8 Jul 2025 22:08:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v20 07/13] blk-zoned: Support pipelining of zoned writes
Date: Tue,  8 Jul 2025 15:07:04 -0700
Message-ID: <20250708220710.3897958-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250708220710.3897958-1-bvanassche@acm.org>
References: <20250708220710.3897958-1-bvanassche@acm.org>
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
 block/blk-zoned.c | 68 ++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 55 insertions(+), 17 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c02cf4140717..1b45c98c7e0c 100644
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
index d2aa7671ddd6..7c99e64647d0 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -51,6 +51,8 @@ static const char *const zone_cond_name[] =3D {
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
@@ -63,6 +65,7 @@ struct blk_zone_wplug {
 	unsigned int		flags;
 	unsigned int		zone_no;
 	unsigned int		wp_offset;
+	int			from_cpu;
 	struct bio_list		bio_list;
 	struct work_struct	bio_work;
 	struct rcu_head		rcu_head;
@@ -72,8 +75,7 @@ struct blk_zone_wplug {
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
@@ -568,6 +570,7 @@ static struct blk_zone_wplug *disk_get_and_lock_zone_=
wplug(struct gendisk *disk,
 	zwplug->flags =3D 0;
 	zwplug->zone_no =3D zno;
 	zwplug->wp_offset =3D bdev_offset_from_zone_start(disk->part0, sector);
+	zwplug->from_cpu =3D -1;
 	bio_list_init(&zwplug->bio_list);
 	INIT_WORK(&zwplug->bio_work, blk_zone_wplug_bio_work);
 	zwplug->disk =3D disk;
@@ -764,14 +767,18 @@ static bool blk_zone_wplug_handle_reset_all(struct =
bio *bio)
 static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
 					      struct blk_zone_wplug *zwplug)
 {
+	int cpu;
+
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
+	cpu =3D zwplug->from_cpu >=3D 0 ? zwplug->from_cpu : WORK_CPU_UNBOUND;
+	queue_work_on(cpu, disk->zone_wplugs_wq, &zwplug->bio_work);
 }
=20
 static inline void disk_zone_wplug_add_bio(struct gendisk *disk,
@@ -932,7 +939,8 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zon=
e_wplug *zwplug,
 	 * We know such BIO will fail, and that would potentially overflow our
 	 * write pointer offset beyond the end of the zone.
 	 */
-	if (disk_zone_wplug_is_full(disk, zwplug))
+	if (!disk->queue->limits.driver_preserves_write_order
+	    && disk_zone_wplug_is_full(disk, zwplug))
 		return false;
=20
 	if (bio_op(bio) =3D=3D REQ_OP_ZONE_APPEND) {
@@ -956,7 +964,8 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zon=
e_wplug *zwplug,
 		 * with a start sector not unaligned to the zone write pointer
 		 * will fail.
 		 */
-		if (bio_offset_from_zone_start(bio) !=3D zwplug->wp_offset)
+		if (!disk->queue->limits.driver_preserves_write_order
+		    && bio_offset_from_zone_start(bio) !=3D zwplug->wp_offset)
 			return false;
 	}
=20
@@ -966,9 +975,11 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zo=
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
+	const bool dpwo =3D disk->queue->limits.driver_preserves_write_order;
 	sector_t sector =3D bio->bi_iter.bi_sector;
 	bool schedule_bio_work =3D false;
 	struct blk_zone_wplug *zwplug;
@@ -1033,8 +1044,23 @@ static bool blk_zone_wplug_handle_write(struct bio=
 *bio, unsigned int nr_segs)
 		return true;
 	}
=20
-	/* Otherwise, plug and submit the BIO. */
-	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
+	if (dpwo && zwplug->from_cpu < 0) {
+		/* No zoned writes are in progress. Select the current CPU. */
+		zwplug->from_cpu =3D raw_smp_processor_id();
+		goto plug;
+	} else if (dpwo) {
+		/*
+		 * The block driver preserves the write order. Submit the bio
+		 * from zwplug->from_cpu.
+		 */
+		goto plug;
+	} else {
+		/*
+		 * The block driver does not preserve the write order. Plug and
+		 * submit the BIO.
+		 */
+		zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
+	}
=20
 	spin_unlock_irqrestore(&zwplug->lock, flags);
=20
@@ -1143,7 +1169,7 @@ bool blk_zone_plug_bio(struct bio *bio, unsigned in=
t nr_segs, int rq_cpu)
 		fallthrough;
 	case REQ_OP_WRITE:
 	case REQ_OP_WRITE_ZEROES:
-		return blk_zone_wplug_handle_write(bio, nr_segs);
+		return blk_zone_wplug_handle_write(bio, nr_segs, rq_cpu);
 	case REQ_OP_ZONE_RESET:
 		return blk_zone_wplug_handle_reset_or_finish(bio, 0);
 	case REQ_OP_ZONE_FINISH:
@@ -1175,6 +1201,9 @@ static void disk_zone_wplug_unplug_bio(struct gendi=
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
@@ -1257,9 +1286,10 @@ void blk_zone_write_plug_finish_request(struct req=
uest *req)
 	disk_put_zone_wplug(zwplug);
 }
=20
-static void blk_zone_submit_one_bio(struct blk_zone_wplug *zwplug)
+static bool blk_zone_submit_one_bio(struct blk_zone_wplug *zwplug)
 {
 	struct block_device *bdev;
+	struct gendisk *disk;
 	unsigned long flags;
 	struct bio *bio;
=20
@@ -1274,7 +1304,7 @@ static void blk_zone_submit_one_bio(struct blk_zone=
_wplug *zwplug)
 	if (!bio) {
 		zwplug->flags &=3D ~BLK_ZONE_WPLUG_PLUGGED;
 		spin_unlock_irqrestore(&zwplug->lock, flags);
-		return;
+		return false;
 	}
=20
 	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
@@ -1285,6 +1315,7 @@ static void blk_zone_submit_one_bio(struct blk_zone=
_wplug *zwplug)
 	spin_unlock_irqrestore(&zwplug->lock, flags);
=20
 	bdev =3D bio->bi_bdev;
+	disk =3D bdev->bd_disk;
=20
 	/*
 	 * blk-mq devices will reuse the extra reference on the request queue
@@ -1298,6 +1329,9 @@ static void blk_zone_submit_one_bio(struct blk_zone=
_wplug *zwplug)
 	} else {
 		blk_mq_submit_bio(bio);
 	}
+
+	return disk->queue->limits.driver_preserves_write_order &&
+		!need_resched();
 }
=20
 static void blk_zone_wplug_bio_work(struct work_struct *work)
@@ -1305,7 +1339,8 @@ static void blk_zone_wplug_bio_work(struct work_str=
uct *work)
 	struct blk_zone_wplug *zwplug =3D
 		container_of(work, struct blk_zone_wplug, bio_work);
=20
-	blk_zone_submit_one_bio(zwplug);
+	while (blk_zone_submit_one_bio(zwplug))
+		;
=20
 	/* Drop the reference we took in disk_zone_wplug_schedule_bio_work(). *=
/
 	disk_put_zone_wplug(zwplug);
@@ -1831,6 +1866,7 @@ static void queue_zone_wplug_show(struct blk_zone_w=
plug *zwplug,
 	unsigned int zwp_zone_no, zwp_ref;
 	unsigned int zwp_bio_list_size;
 	unsigned long flags;
+	int from_cpu;
=20
 	spin_lock_irqsave(&zwplug->lock, flags);
 	zwp_zone_no =3D zwplug->zone_no;
@@ -1838,10 +1874,12 @@ static void queue_zone_wplug_show(struct blk_zone=
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
