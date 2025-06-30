Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702172E54D7;
	Mon, 30 Jun 2025 22:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322658; cv=none; b=WNYK6kupxJeR+HYrq8msN9HD6n2sDymxPRAsi8ahwDxF1XWUx+avFy3xWIhrmHde85urH4F7WawDvzUnu5T30h0gA2BZIQAGnsHFX53L49qC9FxVDE7dz3vxm5EHCWPgqp8qKDLOE1eSobJUZ/GRjdbgGbwm6h42xTuw7ppK2so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322658; c=relaxed/simple;
	bh=bQ6DF9mFPNFARqHJiYSu0fIJSEWxEI6wVX8lTLQAjj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW8cGVCq33PINzF/xUsIaHhF3cWZfkvPnkY4TQkNlIukPbQ4VgbZwePfzDQHgAtRCkHRX/uK1XCjKO/d1OzU5DbhTu9mkzkcP00O1ZNNmItypuiI+Tkw2VA31Kd7lJVFLa2UPoD44uJ5wrkdm4LC3BMfpF/qbR3YU96WjE6VDiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xTBroTaj; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xTBroTaj"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bWLTq3GjCzm0c30;
	Mon, 30 Jun 2025 22:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1751322653; x=1753914654; bh=6DOoN
	D912JS8bXiblfqv5mE74PppnguEe54JacmLRQE=; b=xTBroTajWH4/mNJS/Qbxh
	wypOMqOr9XSFjDT2ESJ/GmIKmB2tSADhPsGhE3/e8PHh1FQ4YvIVjZBO7oBZYR48
	aQgNO6S1+bPQ+SmBoPvS8h4MW00eY/1246mNizs2wFXsDHqWjAL+0DEwNmSCDIJN
	1/hNDlT+KpR92tvroPdKO9kQkv2dDttfE1mplxbnZzADtxCVLuDzW633skQQEQM/
	IHZicv4nD7u0lo6XWqbZ63rlvu30A9jeCJqwdB66PhzZo3q116XUXnBOUbBvJ5lH
	5fPVTdNQmhp8cKXGC3gK+0WALFfUDpfGYV4pn9JDfk48wg5QaZd3wxlOrLw39cWW
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qa1BN162-oRX; Mon, 30 Jun 2025 22:30:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bWLTk2nGqzm0bfr;
	Mon, 30 Jun 2025 22:30:49 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v19 05/11] blk-zoned: Support pipelining of zoned writes
Date: Mon, 30 Jun 2025 15:29:57 -0700
Message-ID: <20250630223003.2642594-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250630223003.2642594-1-bvanassche@acm.org>
References: <20250630223003.2642594-1-bvanassche@acm.org>
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
index 34304b6ac29e..c8734539606f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3150,8 +3150,8 @@ void blk_mq_submit_bio(struct bio *bio)
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
index 91a59bf54547..04a852058155 100644
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
@@ -1147,7 +1157,7 @@ bool blk_zone_plug_bio(struct bio *bio, unsigned in=
t nr_segs, int *from_cpu)
 		fallthrough;
 	case REQ_OP_WRITE:
 	case REQ_OP_WRITE_ZEROES:
-		return blk_zone_wplug_handle_write(bio, nr_segs);
+		return blk_zone_wplug_handle_write(bio, nr_segs, from_cpu);
 	case REQ_OP_ZONE_RESET:
 		return blk_zone_wplug_handle_reset_or_finish(bio, 0);
 	case REQ_OP_ZONE_FINISH:
@@ -1179,6 +1189,9 @@ static void disk_zone_wplug_unplug_bio(struct gendi=
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
@@ -1830,6 +1843,7 @@ static void queue_zone_wplug_show(struct blk_zone_w=
plug *zwplug,
 	unsigned int zwp_zone_no, zwp_ref;
 	unsigned int zwp_bio_list_size;
 	unsigned long flags;
+	int from_cpu;
=20
 	spin_lock_irqsave(&zwplug->lock, flags);
 	zwp_zone_no =3D zwplug->zone_no;
@@ -1837,10 +1851,12 @@ static void queue_zone_wplug_show(struct blk_zone=
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
