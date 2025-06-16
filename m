Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54024A0C;
	Mon, 16 Jun 2025 22:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750113272; cv=none; b=lFyx8xc0gk4EYfF8Tk5JSt1pPkX+GcbmE4qpCrPJW58YxawcpxfYmuCu0FlPM6pfMG8YF5TTpd3UR/y+EKGXl8eV7/326alflw3Wg8DvlzuxxqMHeEnAYvHpPjH+hOnluIqtOwK99Ww2NZMlKdF/Ch+HAAVO9TjlKFs+52pNcNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750113272; c=relaxed/simple;
	bh=SSsXvsUdfN3Qm8rSKvHvTFQo24rID/Db6IyG1R/WrOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7vVlrjIzfcZAiLidRFtNT7h0+8IPw6LDT3OFoV2HopaFXjv540nxP6kha+iYwyefZQSfTtSePxCdtM681ThjJPkbDcnwjqCBqVe2tneL+DDONKLrOjRKS1yTUFj4r6KF8phNCVuYjgRJZmsqj9Fu6pJ+RyH/4VcKu1GC+UhSjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZOvtGfvc; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZOvtGfvc"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bLlDQ1wF0zlgqxs;
	Mon, 16 Jun 2025 22:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1750113268; x=1752705269; bh=OvhHE
	5KSCs4+rbYXi5MhgMZPB2AOtH9lh4zoHhAh+YU=; b=ZOvtGfvcUwLRXLdU6WkBh
	Z3sjvpPewRwuZ6fuxs2AFbjsY1AJYf0iz03MFhEe/3hmfgb6o6TtKIfNP5Hillgy
	wooi6GVd31lNuwSQ2ioWjjg75X+EPuuzb/mRNREGgAW+QQLP4wOhV7OFl7IFJVno
	EC8KeUI32wHqNceRE/5hINqutiqkYq+sBpMenskkAsuDZ+DBUj26j8csmeEPE5TF
	tWaBocl1PKvO6QPdxKVZC7ddM6SX/bsz/SldEUjPaDMHWQfRB0niROKm6jVr4tW8
	qIfF39LmuaNMsSqMoe0lweeI6Wdt+8WQnLMm+EhUpMBaXatOi9ENbc3YHSorW14u
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 75Acpz3Ih7iw; Mon, 16 Jun 2025 22:34:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bLlDJ4sNnzlgqVx;
	Mon, 16 Jun 2025 22:34:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v18 06/12] blk-zoned: Support pipelining of zoned writes
Date: Mon, 16 Jun 2025 15:33:06 -0700
Message-ID: <20250616223312.1607638-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
In-Reply-To: <20250616223312.1607638-1-bvanassche@acm.org>
References: <20250616223312.1607638-1-bvanassche@acm.org>
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
 block/blk-mq.c    |  4 ++--
 block/blk-zoned.c | 30 +++++++++++++++++++++++-------
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ec04ff556983..6954de9f9fe9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3147,8 +3147,8 @@ void blk_mq_submit_bio(struct bio *bio)
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
index a79bb71a83e0..76f76fd83f73 100644
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
@@ -983,7 +986,8 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zon=
e_wplug *zwplug,
 	return true;
 }
=20
-static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr=
_segs)
+static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr=
_segs,
+					int *from_cpu)
 {
 	struct gendisk *disk =3D bio->bi_bdev->bd_disk;
 	sector_t sector =3D bio->bi_iter.bi_sector;
@@ -1045,7 +1049,13 @@ static bool blk_zone_wplug_handle_write(struct bio=
 *bio, unsigned int nr_segs)
 		return true;
 	}
=20
-	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
+	if (disk->queue->limits.driver_preserves_write_order) {
+		if (zwplug->from_cpu < 0)
+			zwplug->from_cpu =3D raw_smp_processor_id();
+		*from_cpu =3D zwplug->from_cpu;
+	} else {
+		zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
+	}
=20
 	spin_unlock_irqrestore(&zwplug->lock, flags);
=20
@@ -1165,7 +1175,7 @@ bool blk_zone_plug_bio(struct bio *bio, unsigned in=
t nr_segs, int *from_cpu)
 		fallthrough;
 	case REQ_OP_WRITE:
 	case REQ_OP_WRITE_ZEROES:
-		return blk_zone_wplug_handle_write(bio, nr_segs);
+		return blk_zone_wplug_handle_write(bio, nr_segs, from_cpu);
 	case REQ_OP_ZONE_RESET:
 		return blk_zone_wplug_handle_reset_or_finish(bio, 0);
 	case REQ_OP_ZONE_FINISH:
@@ -1197,6 +1207,9 @@ static void disk_zone_wplug_unplug_bio(struct gendi=
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
@@ -1848,6 +1861,7 @@ static void queue_zone_wplug_show(struct blk_zone_w=
plug *zwplug,
 	unsigned int zwp_zone_no, zwp_ref;
 	unsigned int zwp_bio_list_size;
 	unsigned long flags;
+	int from_cpu;
=20
 	spin_lock_irqsave(&zwplug->lock, flags);
 	zwp_zone_no =3D zwplug->zone_no;
@@ -1855,10 +1869,12 @@ static void queue_zone_wplug_show(struct blk_zone=
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
