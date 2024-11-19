Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0488A93D;
	Tue, 19 Nov 2024 00:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731976126; cv=none; b=JKezkuEeRMjouFC6tmHXykhqduZ5AOMJaXnhXwryDp2oGDGI4WN83qMC+QedlGoV1lcoA1NVz7v000q8kbxRBN0Dvtm3WWRsh6G8Ff7mQCfWiMYTq8y9HFtgBxsdH114j6WnP+2hK556VUObjhrfa+Npj+vEwAN5lqLAIPqbA2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731976126; c=relaxed/simple;
	bh=55CfKNm0m6d840UXU3+xco443Ng4vf0jVKA4Rb3WTKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJ2T6gBLVb461UZrQbul2VHtC8PXsrFt5GG1znpFMTN0pI4q8Av+53JsnIO8hRTM60wQIJxlTUHfSpswVA4fQ1PiuJAbVo0YMHRVGFihnT994iocInvlM19LPw6BMuoyjN1HmcKAwF/LTx/8aWJ4lvGgbVSfdkz/nTd6C5nXr1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JbHXPfCA; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JbHXPfCA"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xslj829NkzlgMVQ;
	Tue, 19 Nov 2024 00:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1731976117; x=1734568118; bh=stSQS
	fUIRjbG+lH//eK5AJt7SRvcFvSCywnt/x9hkjU=; b=JbHXPfCATXNWsFYvfo9Lq
	ES687hZ/4/9llslZl/pC+oD/NL3d9QCyFWVPYbdq8/tQzrYu5jF+4Qt2AaPP5L6g
	+qk09N3nEmAR6fGs0H4+gNNJCE3n61RlY3jnXeWDFyvQP69Nh3PBH1U6ttwxGYuJ
	6OCI+ZlG5V8utbUfcjpuiRjehA1UC4haM7KFrZum9HaWt6DFdcVVz4GCkgwfYVsc
	zIfzzHniu6zNuXa0WAttG7/RJEZMvAo2xcAWf35lg35Klbnpfz8yeyfGQSidXyHu
	MFt1kBdqq1GDIBktCM8U/QGe4J5wJ4CNJ1Vo/jsUh4L/S21tYhjdRdcxMWLc+kBO
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uiu7UU1BmcJ3; Tue, 19 Nov 2024 00:28:37 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xslj02MD2zlgT1M;
	Tue, 19 Nov 2024 00:28:36 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v16 05/26] blk-zoned: Fix a deadlock triggered by unaligned writes
Date: Mon, 18 Nov 2024 16:27:54 -0800
Message-ID: <20241119002815.600608-6-bvanassche@acm.org>
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

If the queue is filled with unaligned writes then the following
deadlock occurs:

Call Trace:
 <TASK>
 __schedule+0x8cc/0x2190
 schedule+0xdd/0x2b0
 blk_queue_enter+0x2ce/0x4f0
 blk_mq_alloc_request+0x303/0x810
 scsi_execute_cmd+0x3f4/0x7b0
 sd_zbc_do_report_zones+0x19e/0x4c0
 sd_zbc_report_zones+0x304/0x920
 disk_zone_wplug_handle_error+0x237/0x920
 disk_zone_wplugs_work+0x17e/0x430
 process_one_work+0xdd0/0x1490
 worker_thread+0x5eb/0x1010
 kthread+0x2e5/0x3b0
 ret_from_fork+0x3a/0x80
 </TASK>

Fix this deadlock by removing the disk->fops->report_zones() call and by
deriving the write pointer information from successfully completed zoned
writes.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 69 +++++++++++++++++++----------------------------
 block/blk.h       |  4 ++-
 2 files changed, 31 insertions(+), 42 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index b570b773e65f..284820b29285 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -56,6 +56,8 @@ static const char *const zone_cond_name[] =3D {
  * @zone_no: The number of the zone the plug is managing.
  * @wp_offset: The zone write pointer location relative to the start of =
the zone
  *             as a number of 512B sectors.
+ * @wp_offset_compl: End offset for completed zoned writes as a number o=
f 512
+ *		     byte sectors.
  * @bio_list: The list of BIOs that are currently plugged.
  * @bio_work: Work struct to handle issuing of plugged BIOs
  * @rcu_head: RCU head to free zone write plugs with an RCU grace period=
.
@@ -69,6 +71,7 @@ struct blk_zone_wplug {
 	unsigned int		flags;
 	unsigned int		zone_no;
 	unsigned int		wp_offset;
+	unsigned int		wp_offset_compl;
 	struct bio_list		bio_list;
 	struct work_struct	bio_work;
 	struct rcu_head		rcu_head;
@@ -531,6 +534,7 @@ static struct blk_zone_wplug *disk_get_and_lock_zone_=
wplug(struct gendisk *disk,
 	zwplug->flags =3D 0;
 	zwplug->zone_no =3D zno;
 	zwplug->wp_offset =3D sector & (disk->queue->limits.chunk_sectors - 1);
+	zwplug->wp_offset_compl =3D 0;
 	bio_list_init(&zwplug->bio_list);
 	INIT_WORK(&zwplug->bio_work, blk_zone_wplug_bio_work);
 	zwplug->disk =3D disk;
@@ -1226,6 +1230,7 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
 	struct gendisk *disk =3D bio->bi_bdev->bd_disk;
 	struct blk_zone_wplug *zwplug =3D
 		disk_get_zone_wplug(disk, bio->bi_iter.bi_sector);
+	unsigned int end_sector;
 	unsigned long flags;
=20
 	if (WARN_ON_ONCE(!zwplug))
@@ -1243,11 +1248,24 @@ void blk_zone_write_plug_bio_endio(struct bio *bi=
o)
 		bio->bi_opf |=3D REQ_OP_ZONE_APPEND;
 	}
=20
-	/*
-	 * If the BIO failed, mark the plug as having an error to trigger
-	 * recovery.
-	 */
-	if (bio->bi_status !=3D BLK_STS_OK) {
+	if (bio->bi_status =3D=3D BLK_STS_OK) {
+		switch (bio_op(bio)) {
+		case REQ_OP_WRITE:
+		case REQ_OP_ZONE_APPEND:
+		case REQ_OP_WRITE_ZEROES:
+			end_sector =3D bdev_offset_from_zone_start(disk->part0,
+				     bio->bi_iter.bi_sector + bio_sectors(bio));
+			if (end_sector > zwplug->wp_offset_compl)
+				zwplug->wp_offset_compl =3D end_sector;
+			break;
+		default:
+			break;
+		}
+	} else {
+		/*
+		 * If the BIO failed, mark the plug as having an error to
+		 * trigger recovery.
+		 */
 		spin_lock_irqsave(&zwplug->lock, flags);
 		disk_zone_wplug_set_error(disk, zwplug);
 		spin_unlock_irqrestore(&zwplug->lock, flags);
@@ -1388,30 +1406,10 @@ static unsigned int blk_zone_wp_offset(struct blk=
_zone *zone)
 	}
 }
=20
-static int blk_zone_wplug_report_zone_cb(struct blk_zone *zone,
-					 unsigned int idx, void *data)
-{
-	struct blk_zone *zonep =3D data;
-
-	*zonep =3D *zone;
-	return 0;
-}
-
 static void disk_zone_wplug_handle_error(struct gendisk *disk,
 					 struct blk_zone_wplug *zwplug)
 {
-	sector_t zone_start_sector =3D
-		bdev_zone_sectors(disk->part0) * zwplug->zone_no;
-	unsigned int noio_flag;
-	struct blk_zone zone;
 	unsigned long flags;
-	int ret;
-
-	/* Get the current zone information from the device. */
-	noio_flag =3D memalloc_noio_save();
-	ret =3D disk->fops->report_zones(disk, zone_start_sector, 1,
-				       blk_zone_wplug_report_zone_cb, &zone);
-	memalloc_noio_restore(noio_flag);
=20
 	spin_lock_irqsave(&zwplug->lock, flags);
=20
@@ -1425,19 +1423,8 @@ static void disk_zone_wplug_handle_error(struct ge=
ndisk *disk,
=20
 	zwplug->flags &=3D ~BLK_ZONE_WPLUG_ERROR;
=20
-	if (ret !=3D 1) {
-		/*
-		 * We failed to get the zone information, meaning that something
-		 * is likely really wrong with the device. Abort all remaining
-		 * plugged BIOs as otherwise we could endup waiting forever on
-		 * plugged BIOs to complete if there is a queue freeze on-going.
-		 */
-		disk_zone_wplug_abort(zwplug);
-		goto unplug;
-	}
-
 	/* Update the zone write pointer offset. */
-	zwplug->wp_offset =3D blk_zone_wp_offset(&zone);
+	zwplug->wp_offset =3D zwplug->wp_offset_compl;
 	disk_zone_wplug_abort_unaligned(disk, zwplug);
=20
 	/* Restart BIO submission if we still have any BIO left. */
@@ -1446,7 +1433,6 @@ static void disk_zone_wplug_handle_error(struct gen=
disk *disk,
 		goto unlock;
 	}
=20
-unplug:
 	zwplug->flags &=3D ~BLK_ZONE_WPLUG_PLUGGED;
 	if (disk_should_remove_zone_wplug(disk, zwplug))
 		disk_remove_zone_wplug(disk, zwplug);
@@ -1978,7 +1964,7 @@ EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
 static void queue_zone_wplug_show(struct blk_zone_wplug *zwplug,
 				  struct seq_file *m)
 {
-	unsigned int zwp_wp_offset, zwp_flags;
+	unsigned int zwp_wp_offset, zwp_wp_offset_compl, zwp_flags;
 	unsigned int zwp_zone_no, zwp_ref;
 	unsigned int zwp_bio_list_size;
 	unsigned long flags;
@@ -1988,14 +1974,15 @@ static void queue_zone_wplug_show(struct blk_zone=
_wplug *zwplug,
 	zwp_flags =3D zwplug->flags;
 	zwp_ref =3D refcount_read(&zwplug->ref);
 	zwp_wp_offset =3D zwplug->wp_offset;
+	zwp_wp_offset_compl =3D zwplug->wp_offset_compl;
 	zwp_bio_list_size =3D bio_list_size(&zwplug->bio_list);
 	spin_unlock_irqrestore(&zwplug->lock, flags);
=20
 	bool all_zwr_inserted =3D blk_zone_all_zwr_inserted(zwplug);
=20
-	seq_printf(m, "zone_no %u flags 0x%x ref %u wp_offset %u bio_list_size =
%u all_zwr_inserted %d\n",
+	seq_printf(m, "zone_no %u flags 0x%x ref %u wp_offset %u wp_offset_comp=
l %u bio_list_size %u all_zwr_inserted %d\n",
 		   zwp_zone_no, zwp_flags, zwp_ref, zwp_wp_offset,
-		   zwp_bio_list_size, all_zwr_inserted);
+		   zwp_wp_offset_compl, zwp_bio_list_size, all_zwr_inserted);
 }
=20
 int queue_zone_wplugs_show(void *data, struct seq_file *m)
diff --git a/block/blk.h b/block/blk.h
index be945db6298d..88a6e258eafe 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -470,8 +470,10 @@ static inline void blk_zone_update_request_bio(struc=
t request *rq,
 	 * the original BIO sector so that blk_zone_write_plug_bio_endio() can
 	 * lookup the zone write plug.
 	 */
-	if (req_op(rq) =3D=3D REQ_OP_ZONE_APPEND || bio_zone_write_plugging(bio=
))
+	if (req_op(rq) =3D=3D REQ_OP_ZONE_APPEND || bio_zone_write_plugging(bio=
)) {
 		bio->bi_iter.bi_sector =3D rq->__sector;
+		bio->bi_iter.bi_size =3D rq->__data_len;
+	}
 }
=20
 void blk_zone_write_plug_requeue_request(struct request *rq);
