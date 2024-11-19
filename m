Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCA2610B;
	Tue, 19 Nov 2024 00:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976150; cv=none; b=V9mfJ5gRO1FkqUN9O/Fa306zEBXwa8CkADh8GZPQjyYt8oP5ToqmIji3SnGKH8g07+7z+DwSbEcu0LFS61QZVrRJaOKUs+/HwU/vIQ+jIjUh5fhSZRGy/Ed3hjZFQRhGLYHBsyMpeJDOTaw+QD2ZbUTSzCIzX7NAoX7wlOUxVzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976150; c=relaxed/simple;
	bh=Q6QmAIcqJC5cupCYeyNx1mlrrc+kt+kKNMpwXvrx8wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2ziHRCSdasexwbrikiYjFWWzRt+k+4atQIT2uYPageR0cgRR2skqiD4ISd6cgy5EoEEz7LZu4xA6gKxvA74joSMbLE0yvTyS1ohc3IbwN4xI2OO5VPJ+If5aHnL3O2U7viJpyc8/DGDlXpWmaAkbDcJ8+x2Ulbg2W1EbK+pZsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tj7a5UYk; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tj7a5UYk"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xsljc6dGmzlgMVV;
	Tue, 19 Nov 2024 00:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976142; x=1734568143; bh=Tt1/D
	0e9LV64r7vKCUB7bjczn1bJ4ahHGvzAEU7qeKI=; b=tj7a5UYks/qR+DuOGqqww
	nOj4d2sgL9q7K7q9RTla54V348Z7Y0qIBmyIlLxv2bXQdoncFq0otReMIpJpwRdZ
	njF2eExnzAkGnqW3yar+4uM1Oq8J+fkbjGqq3+2qfdaHep1NcghljY0Oh1IOE+h/
	aFzGXs0dDZxJxLRICUDz5f9aw197wP/WUBibLDA50Mn5yzS7RmwPaKbjLiQlv30e
	ZEsC3uXcNWBcTvXAnjdn5tE1x0pUdUqvw1C/PcHFO4wp7RhOF9oR9Vw+mewJtODB
	qazftFw5K+COy3THxEX+y9qYk6yPWwS3BPRU3mp72ss/ZsrBNWZjFVfx+b0DArSg
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HRXXmZYV1hA7; Tue, 19 Nov 2024 00:29:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XsljT162yzlgMVb;
	Tue, 19 Nov 2024 00:29:00 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 20/26] blk-zoned: Support pipelining of zoned writes
Date: Mon, 18 Nov 2024 16:28:09 -0800
Message-ID: <20241119002815.600608-21-bvanassche@acm.org>
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

Support pipelining of zoned writes if the block driver preserves the writ=
e
order per hardware queue. Track per zone to which software queue writes
have been queued. If zoned writes are pipelined, submit new writes to the
same software queue as the writes that are already in progress. This
prevents reordering by submitting requests for the same zone to different
software or hardware queues.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 8d0fac14c837..f934c0cb5fdd 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -8,6 +8,7 @@
  * Copyright (c) 2016, Damien Le Moal
  * Copyright (c) 2016, Western Digital
  * Copyright (c) 2024, Western Digital Corporation or its affiliates.
+ * Copyright 2024 Google LLC
  */
=20
 #include <linux/kernel.h>
@@ -59,6 +60,8 @@ static const char *const zone_cond_name[] =3D {
  *             as a number of 512B sectors.
  * @wp_offset_compl: End offset for completed zoned writes as a number o=
f 512
  *		     byte sectors.
+ * @swq_cpu: Software queue to submit writes to for drivers that preserv=
e the
+ *	write order.
  * @bio_list: The list of BIOs that are currently plugged.
  * @bio_work: Work struct to handle issuing of plugged BIOs
  * @rcu_head: RCU head to free zone write plugs with an RCU grace period=
.
@@ -73,6 +76,7 @@ struct blk_zone_wplug {
 	unsigned int		zone_no;
 	unsigned int		wp_offset;
 	unsigned int		wp_offset_compl;
+	int			swq_cpu;
 	struct bio_list		bio_list;
 	struct work_struct	bio_work;
 	struct rcu_head		rcu_head;
@@ -82,8 +86,7 @@ struct blk_zone_wplug {
 /*
  * Zone write plug flags bits:
  *  - BLK_ZONE_WPLUG_PLUGGED: Indicates that the zone write plug is plug=
ged,
- *    that is, that write BIOs are being throttled due to a write BIO al=
ready
- *    being executed or the zone write plug bio list is not empty.
+ *    that is, that write BIOs are being throttled.
  *  - BLK_ZONE_WPLUG_ERROR: Indicates that a write error happened which =
will be
  *    recovered with a report zone to update the zone write pointer offs=
et.
  *  - BLK_ZONE_WPLUG_UNHASHED: Indicates that the zone write plug was re=
moved
@@ -535,6 +538,7 @@ static struct blk_zone_wplug *disk_get_and_lock_zone_=
wplug(struct gendisk *disk,
 	zwplug->zone_no =3D zno;
 	zwplug->wp_offset =3D sector & (disk->queue->limits.chunk_sectors - 1);
 	zwplug->wp_offset_compl =3D 0;
+	zwplug->swq_cpu =3D -1;
 	bio_list_init(&zwplug->bio_list);
 	INIT_WORK(&zwplug->bio_work, blk_zone_wplug_bio_work);
 	zwplug->disk =3D disk;
@@ -973,7 +977,8 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zon=
e_wplug *zwplug,
 	return false;
 }
=20
-static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr=
_segs)
+static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr=
_segs,
+					int *swq_cpu)
 {
 	struct gendisk *disk =3D bio->bi_bdev->bd_disk;
 	sector_t sector =3D bio->bi_iter.bi_sector;
@@ -1017,11 +1022,19 @@ static bool blk_zone_wplug_handle_write(struct bi=
o *bio, unsigned int nr_segs)
 	bio_set_flag(bio, BIO_ZONE_WRITE_PLUGGING);
=20
 	/*
-	 * If the zone is already plugged or has a pending error, add the BIO
-	 * to the plug BIO list. Otherwise, plug and let the BIO execute.
+	 * If the zone has a pending error or is already plugged, add the BIO
+	 * to the plug BIO list. Otherwise, execute the BIO and plug if not yet
+	 * plugged and if the write order is not preserved.
 	 */
-	if (zwplug->flags & BLK_ZONE_WPLUG_BUSY)
+	if (zwplug->flags & BLK_ZONE_WPLUG_BUSY) {
 		goto plug;
+	} else if (disk->queue->limits.driver_preserves_write_order) {
+		if (zwplug->swq_cpu < 0)
+			zwplug->swq_cpu =3D raw_smp_processor_id();
+		*swq_cpu =3D zwplug->swq_cpu;
+	} else {
+		zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
+	}
=20
 	/*
 	 * If an error is detected when preparing the BIO, add it to the BIO
@@ -1030,8 +1043,6 @@ static bool blk_zone_wplug_handle_write(struct bio =
*bio, unsigned int nr_segs)
 	if (!blk_zone_wplug_prepare_bio(zwplug, bio))
 		goto plug;
=20
-	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
-
 	spin_unlock_irqrestore(&zwplug->lock, flags);
=20
 	return false;
@@ -1107,7 +1118,7 @@ bool blk_zone_plug_bio(struct bio *bio, unsigned in=
t nr_segs, int *swq_cpu)
 		fallthrough;
 	case REQ_OP_WRITE:
 	case REQ_OP_WRITE_ZEROES:
-		return blk_zone_wplug_handle_write(bio, nr_segs);
+		return blk_zone_wplug_handle_write(bio, nr_segs, swq_cpu);
 	case REQ_OP_ZONE_RESET:
 		return blk_zone_wplug_handle_reset_or_finish(bio, 0);
 	case REQ_OP_ZONE_FINISH:
@@ -1131,7 +1142,6 @@ static void disk_zone_wplug_schedule_bio_work(struc=
t gendisk *disk,
 	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the
 	 * reference we take here.
 	 */
-	WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
 	refcount_inc(&zwplug->ref);
 	queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
 }
@@ -1185,6 +1195,9 @@ static void disk_zone_wplug_unplug_bio(struct gendi=
sk *disk,
=20
 	zwplug->flags &=3D ~BLK_ZONE_WPLUG_PLUGGED;
=20
+	if (refcount_read(&zwplug->ref) =3D=3D 2)
+		zwplug->swq_cpu =3D -1;
+
 	/*
 	 * If the zone is full (it was fully written or finished, or empty
 	 * (it was reset), remove its zone write plug from the hash table.
@@ -1937,6 +1950,7 @@ static void queue_zone_wplug_show(struct blk_zone_w=
plug *zwplug,
 	unsigned int zwp_zone_no, zwp_ref;
 	unsigned int zwp_bio_list_size;
 	unsigned long flags;
+	int swq_cpu;
=20
 	spin_lock_irqsave(&zwplug->lock, flags);
 	zwp_zone_no =3D zwplug->zone_no;
@@ -1945,13 +1959,15 @@ static void queue_zone_wplug_show(struct blk_zone=
_wplug *zwplug,
 	zwp_wp_offset =3D zwplug->wp_offset;
 	zwp_wp_offset_compl =3D zwplug->wp_offset_compl;
 	zwp_bio_list_size =3D bio_list_size(&zwplug->bio_list);
+	swq_cpu =3D zwplug->swq_cpu;
 	spin_unlock_irqrestore(&zwplug->lock, flags);
=20
 	bool all_zwr_inserted =3D blk_zone_all_zwr_inserted(zwplug);
=20
-	seq_printf(m, "zone_no %u flags 0x%x ref %u wp_offset %u wp_offset_comp=
l %u bio_list_size %u all_zwr_inserted %d\n",
+	seq_printf(m, "zone_no %u flags 0x%x ref %u wp_offset %u wp_offset_comp=
l %u bio_list_size %u all_zwr_inserted %d swq_cpu %d\n",
 		   zwp_zone_no, zwp_flags, zwp_ref, zwp_wp_offset,
-		   zwp_wp_offset_compl, zwp_bio_list_size, all_zwr_inserted);
+		   zwp_wp_offset_compl, zwp_bio_list_size, all_zwr_inserted,
+		   swq_cpu);
 }
=20
 int queue_zone_wplugs_show(void *data, struct seq_file *m)
