Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA5D2E88B6;
	Tue, 14 Oct 2025 21:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478973; cv=none; b=BWgU866iweqtx5IfExUizQwgdg+JCfvkj0f3yxkHsT90LnQs1S+Mmoa/zHcREFapZDmYw6W+Le8Uo3RyKiBONhFqZpizuG4ruIgEyIbui0QdOF+kqgATBOVKWi+wD+G4psbFxhDbjOIsWLI10YswhSYqsg/A2D5Vw3eLvzWMBXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478973; c=relaxed/simple;
	bh=c8+POOcobgewLtxqyjkgbUNbr7hRmXGmIee5fHVraBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sktn8EYy5+IIU+gyZIUjSVL+yVVFj1tXhphOdDooFJVOg40GMzEi93s1MShn2HuOYlkJX0XIMP/V4R+hLszurL6xfV9YQOWM8LV3DR9x/NstPnmTLeVKO0zdGGVZnNLFrjZ8vnCketyx2twQ4OvwNeltTVejuQq2B0BgaOAHaiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lVYPPSZA; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lVYPPSZA"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmShn2zyPzm0ysr;
	Tue, 14 Oct 2025 21:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760478967; x=1763070968; bh=2eYte
	WgKLEHYZ3brZ69gyunbe3yiJtR4AOYPXcFE3j8=; b=lVYPPSZAggZ3J6V3NVd4h
	4N6X1QXd7CD0ffjAHCKA7swJq71ghCJn9lZlUs+jS+wET20xf0CV/inYzlYAFd9Q
	mH4N9omDZyR+2TaFwldKqgPawemA+VmC1YHd1wsWpcYQZXtUpZe2ApnfJcZrPkZa
	hdsZelC0vfOSa6awGcK+oiQn5D1Ug7cjGdIpsEioED3Xtm8XzFazhwIpXUS5eZ0/
	9OiBkilT+IK3lyELvtzvq2GMrVpQJoWA91gcx9MpzIUX4QsDJJ9zuPDKHAKJXSOK
	vUmrH6N4pk1ROZacEV6eHqwhC5XqUQVUSmfLr82+ItENkOgH3UCKTncnjNYfuXI1
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cLOVzWPqbm9F; Tue, 14 Oct 2025 21:56:07 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmShg5JVZzm0ysd;
	Tue, 14 Oct 2025 21:56:02 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v25 14/20] blk-zoned: Support pipelining of zoned writes
Date: Tue, 14 Oct 2025 14:54:22 -0700
Message-ID: <20251014215428.3686084-15-bvanassche@acm.org>
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

Support pipelining of zoned writes if the write order is preserved per
hardware queue. Track per zone to which software queue writes have been
queued. If zoned writes are pipelined, submit new writes to the same
software queue as the writes that are already in progress. This prevents
reordering by submitting requests for the same zone to different
software or hardware queues. In disk_zone_wplug_schedule_bio_work(),
only increment the zwplug reference count if queuing zwplug->bio_work
succeeded since with this patch applied the bio_work may already be
queued if disk_zone_wplug_schedule_bio_work() is called.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c    |  4 +--
 block/blk-zoned.c | 89 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 77 insertions(+), 16 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a19645701b0e..4b7a1dca0fb9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3188,8 +3188,8 @@ void blk_mq_submit_bio(struct bio *bio)
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
index 74f0fea56eda..3584c049323e 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -8,6 +8,7 @@
  * Copyright (c) 2016, Damien Le Moal
  * Copyright (c) 2016, Western Digital
  * Copyright (c) 2024, Western Digital Corporation or its affiliates.
+ * Copyright 2025 Google LLC
  */
=20
 #include <linux/kernel.h>
@@ -54,6 +55,8 @@ static const char *const zone_cond_name[] =3D {
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
@@ -66,6 +69,7 @@ struct blk_zone_wplug {
 	unsigned int		flags;
 	unsigned int		zone_no;
 	unsigned int		wp_offset;
+	int			from_cpu;
 	struct bio_list		bio_list;
 	struct work_struct	bio_work;
 	struct rcu_head		rcu_head;
@@ -75,8 +79,7 @@ struct blk_zone_wplug {
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
@@ -593,6 +596,7 @@ static struct blk_zone_wplug *disk_get_and_lock_zone_=
wplug(struct gendisk *disk,
 	zwplug->flags =3D 0;
 	zwplug->zone_no =3D zno;
 	zwplug->wp_offset =3D bdev_offset_from_zone_start(disk->part0, sector);
+	zwplug->from_cpu =3D -1;
 	bio_list_init(&zwplug->bio_list);
 	INIT_WORK(&zwplug->bio_work, blk_zone_wplug_bio_work);
 	zwplug->disk =3D disk;
@@ -789,16 +793,25 @@ static bool blk_zone_wplug_handle_reset_all(struct =
bio *bio)
 static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
 					      struct blk_zone_wplug *zwplug)
 {
+	int cpu;
+
 	lockdep_assert_held(&zwplug->lock);
=20
 	/*
-	 * Take a reference on the zone write plug and schedule the submission
-	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the
-	 * reference we take here.
+	 * Schedule a blk_zone_wplug_bio_work() call and increase the zone writ=
e
+	 * plug reference count. blk_zone_wplug_bio_work() will release the
+	 * reference we take here. Increasing the zone write plug reference
+	 * count after the queue_work_on() call is safe because all callers hol=
d
+	 * the zone write plug lock and blk_zone_wplug_bio_work() obtains the
+	 * same lock before decrementing the reference count.
 	 */
 	WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
-	refcount_inc(&zwplug->ref);
-	queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
+	if (zwplug->from_cpu >=3D 0)
+		cpu =3D zwplug->from_cpu;
+	else
+		cpu =3D WORK_CPU_UNBOUND;
+	if (queue_work_on(cpu, disk->zone_wplugs_wq, &zwplug->bio_work))
+		refcount_inc(&zwplug->ref);
 }
=20
 static inline void disk_zone_wplug_add_bio(struct gendisk *disk,
@@ -995,14 +1008,18 @@ static bool blk_zone_wplug_prepare_bio(struct blk_=
zone_wplug *zwplug,
 	return true;
 }
=20
-static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr=
_segs)
+static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr=
_segs,
+					int rq_cpu)
 {
 	struct gendisk *disk =3D bio->bi_bdev->bd_disk;
+	const bool pipeline_zwr =3D bio_op(bio) !=3D REQ_OP_ZONE_APPEND &&
+				 blk_pipeline_zwr(disk->queue);
 	sector_t sector =3D bio->bi_iter.bi_sector;
 	bool schedule_bio_work =3D false;
 	struct blk_zone_wplug *zwplug;
 	gfp_t gfp_mask =3D GFP_NOIO;
 	unsigned long flags;
+	int from_cpu =3D -1;
=20
 	/*
 	 * BIOs must be fully contained within a zone so that we use the correc=
t
@@ -1055,14 +1072,44 @@ static bool blk_zone_wplug_handle_write(struct bi=
o *bio, unsigned int nr_segs)
 	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
 		goto add_to_bio_list;
=20
+	/*
+	 * The code below has been organized such that zwplug->from_cpu and
+	 * zwplug->flags are only modified after it is clear that a request wil=
l
+	 * be added to the bio list or that it will be submitted by the
+	 * caller. This prevents that any changes to these member variables hav=
e
+	 * to be reverted if the blk_zone_wplug_prepare_bio() call fails.
+	 */
+
+	if (pipeline_zwr) {
+		if (zwplug->from_cpu >=3D 0)
+			from_cpu =3D zwplug->from_cpu;
+		else
+			from_cpu =3D smp_processor_id();
+		if (from_cpu !=3D rq_cpu) {
+			zwplug->from_cpu =3D from_cpu;
+			goto add_to_bio_list;
+		}
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
+	if (pipeline_zwr) {
+		/*
+		 * The block driver preserves the write order. Submit future
+		 * writes from the same CPU core as ongoing writes.
+		 */
+		zwplug->from_cpu =3D from_cpu;
+	} else {
+		/*
+		 * The block driver does not preserve the write order. Plug and
+		 * let the caller submit the BIO.
+		 */
+		zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
+	}
=20
 	spin_unlock_irqrestore(&zwplug->lock, flags);
=20
@@ -1170,7 +1217,7 @@ bool blk_zone_plug_bio(struct bio *bio, unsigned in=
t nr_segs, int rq_cpu)
 		fallthrough;
 	case REQ_OP_WRITE:
 	case REQ_OP_WRITE_ZEROES:
-		return blk_zone_wplug_handle_write(bio, nr_segs);
+		return blk_zone_wplug_handle_write(bio, nr_segs, rq_cpu);
 	case REQ_OP_ZONE_RESET:
 		return blk_zone_wplug_handle_reset_or_finish(bio, 0);
 	case REQ_OP_ZONE_FINISH:
@@ -1202,6 +1249,16 @@ static void disk_zone_wplug_unplug_bio(struct gend=
isk *disk,
=20
 	zwplug->flags &=3D ~BLK_ZONE_WPLUG_PLUGGED;
=20
+	/*
+	 * zwplug->from_cpu must not change while one or more writes are pendin=
g
+	 * for the zone associated with zwplug. zwplug->ref is 2 when the plug
+	 * is unused (one reference taken when the plug was allocated and
+	 * another reference taken by the caller context). Reset
+	 * zwplug->from_cpu if no more writes are pending.
+	 */
+	if (refcount_read(&zwplug->ref) =3D=3D 2)
+		zwplug->from_cpu =3D -1;
+
 	/*
 	 * If the zone is full (it was fully written or finished, or empty
 	 * (it was reset), remove its zone write plug from the hash table.
@@ -1302,6 +1359,7 @@ static void blk_zone_wplug_bio_work(struct work_str=
uct *work)
 {
 	struct blk_zone_wplug *zwplug =3D
 		container_of(work, struct blk_zone_wplug, bio_work);
+	bool pipeline_zwr =3D blk_pipeline_zwr(zwplug->disk->queue);
 	struct block_device *bdev;
 	unsigned long flags;
 	struct bio *bio;
@@ -1348,7 +1406,7 @@ static void blk_zone_wplug_bio_work(struct work_str=
uct *work)
 		} else {
 			blk_mq_submit_bio(bio);
 		}
-	} while (0);
+	} while (pipeline_zwr);
=20
 put_zwplug:
 	/* Drop the reference we took in disk_zone_wplug_schedule_bio_work(). *=
/
@@ -1875,6 +1933,7 @@ static void queue_zone_wplug_show(struct blk_zone_w=
plug *zwplug,
 	unsigned int zwp_zone_no, zwp_ref;
 	unsigned int zwp_bio_list_size;
 	unsigned long flags;
+	int from_cpu;
=20
 	spin_lock_irqsave(&zwplug->lock, flags);
 	zwp_zone_no =3D zwplug->zone_no;
@@ -1882,10 +1941,12 @@ static void queue_zone_wplug_show(struct blk_zone=
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
