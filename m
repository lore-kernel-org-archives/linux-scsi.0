Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E75138FA6;
	Tue, 19 Nov 2024 00:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976130; cv=none; b=FYv91CZ/Q7PrJSeLL3bykLyH0fYh645/QNCM1DmzNMmi/8Bm36OFi/1iysqPzWQoHy3S4iWGCeBctsN/K13ZV2QXD/prpmGjYb3/KGttYBt1qzwzMm3JfEeFxhCAn1X1PZ+et/O0F4YiKjkAL9sdoV95qKMd/FaGg1qqFEtLq3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976130; c=relaxed/simple;
	bh=2HcQmdgi8D0gbNiFbXQIisgIrCR0OGjMywbyhS/VZ+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+bYqlXrI52AaZ4wrUy1mkQSDXKT1f/vSHU42LgC7cpsU1mtLrghy+wuXnclVSbfper/OBdUEQiASNwY3i5rjUQQJIhySNmfzaqvaCmGs7tDd/cUXMGtIJ9y5q2TFGjI2AU3qTd54cfOxUMADC64W3Dn5oXuzBc6jNH7FFhk78g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ey/eLbQg; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ey/eLbQg"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XsljB4HhyzlgVnY;
	Tue, 19 Nov 2024 00:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976116; x=1734568117; bh=ApTxr
	KLlqtUOcY6Efmc/C8s1lOktZwRB41eCGj+9khg=; b=ey/eLbQgNVjWJwXGnTn4v
	mKxiTwTXMCZFqGcEPNYYv6XJhlFTwE/Kvlh9Eku6pjLUWbfsUvrM13+xv46hyX0U
	CcTb4ZqAdQBPwLjeAJNqS9xEN5mohIuf1F+2TSg1KArm0Y5lbiPxpG1V9aJIoldj
	draoHqLVbrpMBWa8pAmiF6PpwRPC0JgrbaWfVMZeTvd0tu/+nzC+KJ0c0ETpg0U/
	kiJUoeh5JUAmXnTn5Kozo9Wc4gIkwxfxnw3QDnUs3I0bYJ2h44EaRHOz1QnDAACP
	kP7t3gukqyQX7y2tgk0lxj9gZbPzY8dQwRi+F3bsUygOBZUzYtrMpakn2iCkS+xt
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RUa2xrTqqH-7; Tue, 19 Nov 2024 00:28:36 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xslhy57BMzlgVXv;
	Tue, 19 Nov 2024 00:28:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 04/26] blk-zoned: Only handle errors after pending zoned writes have completed
Date: Mon, 18 Nov 2024 16:27:53 -0800
Message-ID: <20241119002815.600608-5-bvanassche@acm.org>
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

Instead of handling write errors immediately, only handle these after all
pending zoned write requests have completed or have been requeued. This
patch prepares for changing the zone write pointer tracking approach.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-mq.c         |   9 +++
 block/blk-zoned.c      | 154 +++++++++++++++++++++++++++++++++++++++--
 block/blk.h            |  29 ++++++++
 include/linux/blk-mq.h |  18 +++++
 4 files changed, 203 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 270cfd9fc6b0..a45077e187b5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -793,6 +793,9 @@ void blk_mq_free_request(struct request *rq)
 	rq_qos_done(q, rq);
=20
 	WRITE_ONCE(rq->state, MQ_RQ_IDLE);
+
+	blk_zone_free_request(rq);
+
 	if (req_ref_put_and_test(rq))
 		__blk_mq_free_request(rq);
 }
@@ -1189,6 +1192,9 @@ void blk_mq_end_request_batch(struct io_comp_batch =
*iob)
 			continue;
=20
 		WRITE_ONCE(rq->state, MQ_RQ_IDLE);
+
+		blk_zone_free_request(rq);
+
 		if (!req_ref_put_and_test(rq))
 			continue;
=20
@@ -1507,6 +1513,7 @@ static void __blk_mq_requeue_request(struct request=
 *rq)
 	if (blk_mq_request_started(rq)) {
 		WRITE_ONCE(rq->state, MQ_RQ_IDLE);
 		rq->rq_flags &=3D ~RQF_TIMED_OUT;
+		blk_zone_requeue_work(q);
 	}
 }
=20
@@ -1542,6 +1549,8 @@ static void blk_mq_requeue_work(struct work_struct =
*work)
 	list_splice_init(&q->flush_list, &flush_list);
 	spin_unlock_irq(&q->requeue_lock);
=20
+	blk_zone_requeue_work(q);
+
 	while (!list_empty(&rq_list)) {
 		rq =3D list_entry(rq_list.next, struct request, queuelist);
 		/*
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 7e6e6ebb6235..b570b773e65f 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -608,6 +608,8 @@ static inline void disk_zone_wplug_set_error(struct g=
endisk *disk,
 	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR)
 		return;
=20
+	zwplug->flags |=3D BLK_ZONE_WPLUG_PLUGGED;
+	zwplug->flags |=3D BLK_ZONE_WPLUG_ERROR;
 	/*
 	 * At this point, we already have a reference on the zone write plug.
 	 * However, since we are going to add the plug to the disk zone write
@@ -616,7 +618,6 @@ static inline void disk_zone_wplug_set_error(struct g=
endisk *disk,
 	 * handled, or in disk_zone_wplug_clear_error() if the zone is reset or
 	 * finished.
 	 */
-	zwplug->flags |=3D BLK_ZONE_WPLUG_ERROR;
 	refcount_inc(&zwplug->ref);
=20
 	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
@@ -642,6 +643,7 @@ static inline void disk_zone_wplug_clear_error(struct=
 gendisk *disk,
 	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
 	if (!list_empty(&zwplug->link)) {
 		list_del_init(&zwplug->link);
+		zwplug->flags &=3D ~BLK_ZONE_WPLUG_PLUGGED;
 		zwplug->flags &=3D ~BLK_ZONE_WPLUG_ERROR;
 		disk_put_zone_wplug(zwplug);
 	}
@@ -746,6 +748,70 @@ static bool blk_zone_wplug_handle_reset_all(struct b=
io *bio)
 	return false;
 }
=20
+struct all_zwr_inserted_data {
+	struct blk_zone_wplug *zwplug;
+	bool res;
+};
+
+/*
+ * Changes @data->res to %false if and only if @rq is a zoned write for =
the
+ * given zone and if it is owned by the block driver.
+ *
+ * @rq members may change while this function is in progress. Hence, use
+ * READ_ONCE() to read @rq members.
+ */
+static bool blk_zwr_inserted(struct request *rq, void *data)
+{
+	struct all_zwr_inserted_data *d =3D data;
+	struct blk_zone_wplug *zwplug =3D d->zwplug;
+	struct request_queue *q =3D zwplug->disk->queue;
+	struct bio *bio =3D READ_ONCE(rq->bio);
+
+	if (rq->q =3D=3D q && READ_ONCE(rq->state) !=3D MQ_RQ_IDLE &&
+	    blk_rq_is_seq_zoned_write(rq) && bio &&
+	    bio_zone_no(bio) =3D=3D zwplug->zone_no) {
+		d->res =3D false;
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * Report whether or not all zoned writes for a zone have been inserted =
into a
+ * software queue, elevator queue or hardware queue.
+ */
+static bool blk_zone_all_zwr_inserted(struct blk_zone_wplug *zwplug)
+{
+	struct gendisk *disk =3D zwplug->disk;
+	struct request_queue *q =3D disk->queue;
+	struct all_zwr_inserted_data d =3D { .zwplug =3D zwplug, .res =3D true =
};
+	struct blk_mq_hw_ctx *hctx;
+	long unsigned int i;
+	struct request *rq;
+
+	scoped_guard(spinlock_irqsave, &q->requeue_lock) {
+		list_for_each_entry(rq, &q->requeue_list, queuelist)
+			if (blk_rq_is_seq_zoned_write(rq) &&
+			    bio_zone_no(rq->bio) =3D=3D zwplug->zone_no)
+				return false;
+		list_for_each_entry(rq, &q->flush_list, queuelist)
+			if (blk_rq_is_seq_zoned_write(rq) &&
+			    bio_zone_no(rq->bio) =3D=3D zwplug->zone_no)
+				return false;
+	}
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		struct blk_mq_tags *tags =3D hctx->sched_tags ?: hctx->tags;
+
+		blk_mq_all_tag_iter(tags, blk_zwr_inserted, &d);
+		if (!d.res || blk_mq_is_shared_tags(q->tag_set->flags))
+			break;
+	}
+
+	return d.res;
+}
+
 static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
 					  struct bio *bio, unsigned int nr_segs)
 {
@@ -1096,6 +1162,29 @@ static void disk_zone_wplug_schedule_bio_work(stru=
ct gendisk *disk,
 	queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
 }
=20
+/*
+ * Change the zone state to "error" if a request is requeued to postpone
+ * processing of requeued requests until all pending requests have eithe=
r
+ * completed or have been requeued.
+ */
+void blk_zone_write_plug_requeue_request(struct request *rq)
+{
+	struct gendisk *disk =3D rq->q->disk;
+	struct blk_zone_wplug *zwplug;
+
+	if (!disk->zone_wplugs_hash_bits || !blk_rq_is_seq_zoned_write(rq))
+		return;
+
+	zwplug =3D disk_get_zone_wplug(disk, blk_rq_pos(rq));
+	if (WARN_ON_ONCE(!zwplug))
+		return;
+
+	scoped_guard(spinlock_irqsave, &zwplug->lock)
+		disk_zone_wplug_set_error(disk, zwplug);
+
+	disk_put_zone_wplug(zwplug);
+}
+
 static void disk_zone_wplug_unplug_bio(struct gendisk *disk,
 				       struct blk_zone_wplug *zwplug)
 {
@@ -1202,6 +1291,33 @@ void blk_zone_write_plug_finish_request(struct req=
uest *req)
 	disk_put_zone_wplug(zwplug);
 }
=20
+/*
+ * Schedule zone_plugs_work if a zone is in the error state and if no re=
quests
+ * are in flight. Called from blk_mq_free_request().
+ */
+void blk_zone_write_plug_free_request(struct request *rq)
+{
+	struct gendisk *disk =3D rq->q->disk;
+	struct blk_zone_wplug *zwplug;
+
+	/*
+	 * Do nothing if this function is called before the zone information
+	 * has been initialized.
+	 */
+	if (!disk->zone_wplugs_hash_bits)
+		return;
+
+	zwplug =3D disk_get_zone_wplug(disk, blk_rq_pos(rq));
+
+	if (!zwplug)
+		return;
+
+	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR)
+		kblockd_schedule_work(&disk->zone_wplugs_work);
+
+	disk_put_zone_wplug(zwplug);
+}
+
 static void blk_zone_wplug_bio_work(struct work_struct *work)
 {
 	struct blk_zone_wplug *zwplug =3D
@@ -1343,14 +1459,15 @@ static void disk_zone_wplug_handle_error(struct g=
endisk *disk,
=20
 static void disk_zone_process_err_list(struct gendisk *disk)
 {
-	struct blk_zone_wplug *zwplug;
+	struct blk_zone_wplug *zwplug, *next;
 	unsigned long flags;
=20
 	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
=20
-	while (!list_empty(&disk->zone_wplugs_err_list)) {
-		zwplug =3D list_first_entry(&disk->zone_wplugs_err_list,
-					  struct blk_zone_wplug, link);
+	list_for_each_entry_safe(zwplug, next, &disk->zone_wplugs_err_list,
+				 link) {
+		if (!blk_zone_all_zwr_inserted(zwplug))
+			continue;
 		list_del_init(&zwplug->link);
 		spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
=20
@@ -1361,6 +1478,12 @@ static void disk_zone_process_err_list(struct gend=
isk *disk)
 	}
=20
 	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+
+	/*
+	 * If one or more zones have been skipped, this work will be requeued
+	 * when a request is requeued (blk_zone_requeue_work()) or freed
+	 * (blk_zone_write_plug_free_request()).
+	 */
 }
=20
 static void disk_zone_wplugs_work(struct work_struct *work)
@@ -1371,6 +1494,20 @@ static void disk_zone_wplugs_work(struct work_stru=
ct *work)
 	disk_zone_process_err_list(disk);
 }
=20
+/* May be called from interrupt context and hence must not sleep. */
+void blk_zone_requeue_work(struct request_queue *q)
+{
+	struct gendisk *disk =3D q->disk;
+
+	if (!disk)
+		return;
+
+	if (in_interrupt())
+		kblockd_schedule_work(&disk->zone_wplugs_work);
+	else
+		disk_zone_process_err_list(disk);
+}
+
 static inline unsigned int disk_zone_wplugs_hash_size(struct gendisk *di=
sk)
 {
 	return 1U << disk->zone_wplugs_hash_bits;
@@ -1854,8 +1991,11 @@ static void queue_zone_wplug_show(struct blk_zone_=
wplug *zwplug,
 	zwp_bio_list_size =3D bio_list_size(&zwplug->bio_list);
 	spin_unlock_irqrestore(&zwplug->lock, flags);
=20
-	seq_printf(m, "%u 0x%x %u %u %u\n", zwp_zone_no, zwp_flags, zwp_ref,
-		   zwp_wp_offset, zwp_bio_list_size);
+	bool all_zwr_inserted =3D blk_zone_all_zwr_inserted(zwplug);
+
+	seq_printf(m, "zone_no %u flags 0x%x ref %u wp_offset %u bio_list_size =
%u all_zwr_inserted %d\n",
+		   zwp_zone_no, zwp_flags, zwp_ref, zwp_wp_offset,
+		   zwp_bio_list_size, all_zwr_inserted);
 }
=20
 int queue_zone_wplugs_show(void *data, struct seq_file *m)
diff --git a/block/blk.h b/block/blk.h
index 2c26abf505b8..be945db6298d 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -473,6 +473,18 @@ static inline void blk_zone_update_request_bio(struc=
t request *rq,
 	if (req_op(rq) =3D=3D REQ_OP_ZONE_APPEND || bio_zone_write_plugging(bio=
))
 		bio->bi_iter.bi_sector =3D rq->__sector;
 }
+
+void blk_zone_write_plug_requeue_request(struct request *rq);
+static inline void blk_zone_requeue_request(struct request *rq)
+{
+	if (!blk_rq_is_seq_zoned_write(rq))
+		return;
+
+	blk_zone_write_plug_requeue_request(rq);
+}
+
+void blk_zone_requeue_work(struct request_queue *q);
+
 void blk_zone_write_plug_bio_endio(struct bio *bio);
 static inline void blk_zone_bio_endio(struct bio *bio)
 {
@@ -490,6 +502,14 @@ static inline void blk_zone_finish_request(struct re=
quest *rq)
 	if (rq->rq_flags & RQF_ZONE_WRITE_PLUGGING)
 		blk_zone_write_plug_finish_request(rq);
 }
+
+void blk_zone_write_plug_free_request(struct request *rq);
+static inline void blk_zone_free_request(struct request *rq)
+{
+	if (blk_queue_is_zoned(rq->q))
+		blk_zone_write_plug_free_request(rq);
+}
+
 int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cm=
d,
 		unsigned long arg);
 int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
@@ -515,12 +535,21 @@ static inline void blk_zone_update_request_bio(stru=
ct request *rq,
 					       struct bio *bio)
 {
 }
+static inline void blk_zone_requeue_request(struct request *rq)
+{
+}
+static inline void blk_zone_requeue_work(struct request_queue *q)
+{
+}
 static inline void blk_zone_bio_endio(struct bio *bio)
 {
 }
 static inline void blk_zone_finish_request(struct request *rq)
 {
 }
+static inline void blk_zone_free_request(struct request *rq)
+{
+}
 static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
 		unsigned int cmd, unsigned long arg)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index c596e0e4cb75..ac05974f08f9 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1169,4 +1169,22 @@ static inline int blk_rq_map_sg(struct request_que=
ue *q, struct request *rq,
 }
 void blk_dump_rq_flags(struct request *, char *);
=20
+#ifdef CONFIG_BLK_DEV_ZONED
+static inline bool blk_rq_is_seq_zoned_write(struct request *rq)
+{
+	switch (req_op(rq)) {
+	case REQ_OP_WRITE:
+	case REQ_OP_WRITE_ZEROES:
+		return bdev_zone_is_seq(rq->q->disk->part0, blk_rq_pos(rq));
+	default:
+		return false;
+	}
+}
+#else /* CONFIG_BLK_DEV_ZONED */
+static inline bool blk_rq_is_seq_zoned_write(struct request *rq)
+{
+	return false;
+}
+#endif /* CONFIG_BLK_DEV_ZONED */
+
 #endif /* BLK_MQ_H */
