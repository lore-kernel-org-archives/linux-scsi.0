From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 1/2] Update struct request to use bio_list
Date: Sun, 19 Apr 2009 12:13:17 -0400
Message-ID: <20090419161317.GA12531@havoc.gtf.org>
References: <20090419161234.GA12105@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:33711 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549AbZDSQNS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Apr 2009 12:13:18 -0400
Content-Disposition: inline
In-Reply-To: <20090419161234.GA12105@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, hch@lst.de

commit 861c7c88e1eca795fdd879ac703d5d52fc18a837
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Apr 19 11:51:08 2009 -0400

    struct request: replace bio, biotail with struct bio_list->{head,tail}
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 block/blk-barrier.c                      |    6 ++++--
 block/blk-core.c                         |   30 +++++++++++++++---------------
 block/blk-map.c                          |   11 +++++------
 block/blk-merge.c                        |   28 ++++++++++++++--------------
 block/bsg.c                              |   10 +++++-----
 block/elevator.c                         |    2 +-
 block/scsi_ioctl.c                       |    2 +-
 drivers/block/floppy.c                   |    2 +-
 drivers/block/hd.c                       |    3 ++-
 drivers/cdrom/cdrom.c                    |    2 +-
 drivers/ide/ide-cd.c                     |    9 +++++----
 drivers/ide/ide-dma.c                    |    8 ++++----
 drivers/ide/ide-floppy.c                 |    2 +-
 drivers/ide/ide-io.c                     |    2 +-
 drivers/message/fusion/mptsas.c          |   11 ++++++-----
 drivers/scsi/libsas/sas_expander.c       |   11 ++++++-----
 drivers/scsi/libsas/sas_host_smp.c       |   16 +++++++++-------
 drivers/scsi/mpt2sas/mpt2sas_transport.c |   11 ++++++-----
 drivers/scsi/osd/osd_initiator.c         |    7 ++++---
 drivers/scsi/osst.c                      |    2 +-
 drivers/scsi/scsi_lib.c                  |    2 +-
 drivers/scsi/scsi_tgt_lib.c              |    2 +-
 drivers/scsi/sd_dif.c                    |    2 +-
 drivers/scsi/sg.c                        |    2 +-
 drivers/scsi/sr.c                        |    4 ++--
 drivers/scsi/st.c                        |    2 +-
 include/linux/blkdev.h                   |   11 +++++------
 27 files changed, 104 insertions(+), 96 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 20b4111..17a76b6 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -200,15 +200,17 @@ static inline bool start_ordered(struct request_queue *q, struct request **rqp)
 		skip |= QUEUE_ORDSEQ_POSTFLUSH;
 
 	if (q->ordered & QUEUE_ORDERED_DO_BAR) {
+		struct bio *obb_bio;
 		rq = &q->bar_rq;
 
 		/* initialize proxy request and queue it */
 		blk_rq_init(q, rq);
-		if (bio_data_dir(q->orig_bar_rq->bio) == WRITE)
+		obb_bio = q->orig_bar_rq->bio_list.head;
+		if (bio_data_dir(obb_bio) == WRITE)
 			rq->cmd_flags |= REQ_RW;
 		if (q->ordered & QUEUE_ORDERED_DO_FUA)
 			rq->cmd_flags |= REQ_FUA;
-		init_request_from_bio(rq, q->orig_bar_rq->bio);
+		init_request_from_bio(rq, obb_bio);
 		rq->end_io = bar_end_io;
 
 		elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
diff --git a/block/blk-core.c b/block/blk-core.c
index 07ab754..0ec8621 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -189,7 +189,8 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 						rq->nr_sectors,
 						rq->current_nr_sectors);
 	printk(KERN_INFO "  bio %p, biotail %p, buffer %p, data %p, len %u\n",
-						rq->bio, rq->biotail,
+						rq->bio_list.head,
+						rq->bio_list.tail,
 						rq->buffer, rq->data,
 						rq->data_len);
 
@@ -1063,7 +1064,7 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	elv_completed_request(q, req);
 
 	/* this is a bio leak */
-	WARN_ON(req->bio != NULL);
+	WARN_ON(!bio_list_empty(&req->bio_list));
 
 	/*
 	 * Request may not have originated from ll_rw_blk. if not,
@@ -1178,8 +1179,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 
 		trace_block_bio_backmerge(q, bio);
 
-		req->biotail->bi_next = bio;
-		req->biotail = bio;
+		bio_list_add(&req->bio_list, bio);
 		req->nr_sectors = req->hard_nr_sectors += nr_sectors;
 		req->ioprio = ioprio_best(req->ioprio, prio);
 		if (!blk_rq_cpu_valid(req))
@@ -1197,8 +1197,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 
 		trace_block_bio_frontmerge(q, bio);
 
-		bio->bi_next = req->bio;
-		req->bio = bio;
+		bio_list_add_head(&req->bio_list, bio);
 
 		/*
 		 * may not be valid. if the low level driver said
@@ -1754,11 +1753,11 @@ static int __end_that_request_first(struct request *req, int error,
 	blk_account_io_completion(req, nr_bytes);
 
 	total_bytes = bio_nbytes = 0;
-	while ((bio = req->bio) != NULL) {
+	while ((bio = req->bio_list.head) != NULL) {
 		int nbytes;
 
 		if (nr_bytes >= bio->bi_size) {
-			req->bio = bio->bi_next;
+			req->bio_list.head = bio->bi_next;
 			nbytes = bio->bi_size;
 			req_bio_endio(req, bio, nbytes, error);
 			next_idx = 0;
@@ -1795,7 +1794,7 @@ static int __end_that_request_first(struct request *req, int error,
 		total_bytes += nbytes;
 		nr_bytes -= nbytes;
 
-		bio = req->bio;
+		bio = req->bio_list.head;
 		if (bio) {
 			/*
 			 * end more in this run, or just return 'not-done'
@@ -1808,7 +1807,7 @@ static int __end_that_request_first(struct request *req, int error,
 	/*
 	 * completely done
 	 */
-	if (!req->bio)
+	if (bio_list_empty(&req->bio_list))
 		return 0;
 
 	/*
@@ -1876,8 +1875,8 @@ unsigned int blk_rq_cur_bytes(struct request *rq)
 	if (blk_fs_request(rq))
 		return rq->current_nr_sectors << 9;
 
-	if (rq->bio)
-		return rq->bio->bi_size;
+	if (!bio_list_empty(&rq->bio_list))
+		return rq->bio_list.head->bi_size;
 
 	return rq->data_len;
 }
@@ -1913,7 +1912,7 @@ EXPORT_SYMBOL(end_request);
 static int end_that_request_data(struct request *rq, int error,
 				 unsigned int nr_bytes, unsigned int bidi_bytes)
 {
-	if (rq->bio) {
+	if (!bio_list_empty(&rq->bio_list)) {
 		if (__end_that_request_first(rq, error, nr_bytes))
 			return 1;
 
@@ -2003,7 +2002,8 @@ EXPORT_SYMBOL_GPL(blk_end_request);
  **/
 int __blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
 {
-	if (rq->bio && __end_that_request_first(rq, error, nr_bytes))
+	if (!bio_list_empty(&rq->bio_list) &&
+	    __end_that_request_first(rq, error, nr_bytes))
 		return 1;
 
 	add_disk_randomness(rq->rq_disk);
@@ -2114,7 +2114,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
 	rq->data_len = bio->bi_size;
 
-	rq->bio = rq->biotail = bio;
+	rq->bio_list.head = rq->bio_list.tail = bio;
 
 	if (bio->bi_bdev)
 		rq->rq_disk = bio->bi_bdev->bd_disk;
diff --git a/block/blk-map.c b/block/blk-map.c
index f103729..437b916 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -12,13 +12,12 @@
 int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		      struct bio *bio)
 {
-	if (!rq->bio)
+	if (bio_list_empty(&rq->bio_list))
 		blk_rq_bio_prep(q, rq, bio);
 	else if (!ll_back_merge_fn(q, rq, bio))
 		return -EINVAL;
 	else {
-		rq->biotail->bi_next = bio;
-		rq->biotail = bio;
+		bio_list_add(&rq->bio_list, bio);
 
 		rq->data_len += bio->bi_size;
 	}
@@ -145,7 +144,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 		if (ret < 0)
 			goto unmap_rq;
 		if (!bio)
-			bio = rq->bio;
+			bio = rq->bio_list.head;
 		bytes_read += ret;
 		ubuf += ret;
 
@@ -160,7 +159,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 	return 0;
 unmap_rq:
 	blk_rq_unmap_user(bio);
-	rq->bio = NULL;
+	rq->bio_list.head = NULL;
 	return ret;
 }
 EXPORT_SYMBOL(blk_rq_map_user);
@@ -312,7 +311,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 		rq->cmd_flags |= REQ_COPY_USER;
 
 	blk_rq_bio_prep(q, rq, bio);
-	blk_queue_bounce(q, &rq->bio);
+	blk_queue_bounce(q, &rq->bio_list.head);
 	rq->buffer = rq->data = NULL;
 	return 0;
 }
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 63760ca..a1a23ae 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -22,9 +22,9 @@ void blk_recalc_rq_sectors(struct request *rq, int nsect)
 		    (rq->sector <= rq->hard_sector)) {
 			rq->sector = rq->hard_sector;
 			rq->nr_sectors = rq->hard_nr_sectors;
-			rq->hard_cur_sectors = bio_cur_sectors(rq->bio);
+			rq->hard_cur_sectors = bio_cur_sectors(rq->bio_list.head);
 			rq->current_nr_sectors = rq->hard_cur_sectors;
-			rq->buffer = bio_data(rq->bio);
+			rq->buffer = bio_data(rq->bio_list.head);
 		}
 
 		/*
@@ -99,7 +99,7 @@ new_segment:
 
 void blk_recalc_rq_segments(struct request *rq)
 {
-	rq->nr_phys_segments = __blk_recalc_rq_segments(rq->q, rq->bio);
+	rq->nr_phys_segments = __blk_recalc_rq_segments(rq->q, rq->bio_list.head);
 }
 
 void blk_recount_segments(struct request_queue *q, struct bio *bio)
@@ -265,8 +265,8 @@ int ll_back_merge_fn(struct request_queue *q, struct request *req,
 			q->last_merge = NULL;
 		return 0;
 	}
-	if (!bio_flagged(req->biotail, BIO_SEG_VALID))
-		blk_recount_segments(q, req->biotail);
+	if (!bio_flagged(req->bio_list.tail, BIO_SEG_VALID))
+		blk_recount_segments(q, req->bio_list.tail);
 	if (!bio_flagged(bio, BIO_SEG_VALID))
 		blk_recount_segments(q, bio);
 
@@ -292,8 +292,8 @@ int ll_front_merge_fn(struct request_queue *q, struct request *req,
 	}
 	if (!bio_flagged(bio, BIO_SEG_VALID))
 		blk_recount_segments(q, bio);
-	if (!bio_flagged(req->bio, BIO_SEG_VALID))
-		blk_recount_segments(q, req->bio);
+	if (!bio_flagged(req->bio_list.head, BIO_SEG_VALID))
+		blk_recount_segments(q, req->bio_list.head);
 
 	return ll_new_hw_segment(q, req, bio);
 }
@@ -303,7 +303,8 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 {
 	int total_phys_segments;
 	unsigned int seg_size =
-		req->biotail->bi_seg_back_size + next->bio->bi_seg_front_size;
+		req->bio_list.tail->bi_seg_back_size +
+		next->bio_list.head->bi_seg_front_size;
 
 	/*
 	 * First check if the either of the requests are re-queued
@@ -319,11 +320,11 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 		return 0;
 
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
-	if (blk_phys_contig_segment(q, req->biotail, next->bio)) {
+	if (blk_phys_contig_segment(q, req->bio_list.tail, next->bio_list.head)) {
 		if (req->nr_phys_segments == 1)
-			req->bio->bi_seg_front_size = seg_size;
+			req->bio_list.head->bi_seg_front_size = seg_size;
 		if (next->nr_phys_segments == 1)
-			next->biotail->bi_seg_back_size = seg_size;
+			next->bio_list.tail->bi_seg_back_size = seg_size;
 		total_phys_segments--;
 	}
 
@@ -395,8 +396,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	if (time_after(req->start_time, next->start_time))
 		req->start_time = next->start_time;
 
-	req->biotail->bi_next = next->bio;
-	req->biotail = next->biotail;
+	bio_list_merge(&req->bio_list, &next->bio_list);
 
 	req->nr_sectors = req->hard_nr_sectors += next->hard_nr_sectors;
 
@@ -409,7 +409,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 		req->cpu = next->cpu;
 
 	/* owner-ship of bio passed from next to req */
-	next->bio = NULL;
+	next->bio_list.head = NULL;
 	__blk_put_request(q, next);
 	return 1;
 }
diff --git a/block/bsg.c b/block/bsg.c
index 206060e..80ff23a 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -314,7 +314,7 @@ out:
 		kfree(rq->cmd);
 	blk_put_request(rq);
 	if (next_rq) {
-		blk_rq_unmap_user(next_rq->bio);
+		blk_rq_unmap_user(next_rq->bio_list.head);
 		blk_put_request(next_rq);
 	}
 	return ERR_PTR(ret);
@@ -356,9 +356,9 @@ static void bsg_add_command(struct bsg_device *bd, struct request_queue *q,
 	 * add bc command to busy queue and submit rq for io
 	 */
 	bc->rq = rq;
-	bc->bio = rq->bio;
+	bc->bio = rq->bio_list.head;
 	if (rq->next_rq)
-		bc->bidi_bio = rq->next_rq->bio;
+		bc->bidi_bio = rq->next_rq->bio_list.head;
 	bc->hdr.duration = jiffies;
 	spin_lock_irq(&bd->lock);
 	list_add_tail(&bc->list, &bd->busy_list);
@@ -933,9 +933,9 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (IS_ERR(rq))
 			return PTR_ERR(rq);
 
-		bio = rq->bio;
+		bio = rq->bio_list.head;
 		if (rq->next_rq)
-			bidi_bio = rq->next_rq->bio;
+			bidi_bio = rq->next_rq->bio_list.head;
 
 		at_head = (0 == (hdr.flags & BSG_FLAG_Q_AT_TAIL));
 		blk_execute_rq(bd->queue, NULL, rq, at_head);
diff --git a/block/elevator.c b/block/elevator.c
index 7073a90..6e59138 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -84,7 +84,7 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 	/*
 	 * Don't merge file system requests and discard requests
 	 */
-	if (bio_discard(bio) != bio_discard(rq->bio))
+	if (bio_discard(bio) != bio_discard(rq->bio_list.head))
 		return 0;
 
 	/*
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 84b7f87..688e80d 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -314,7 +314,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	if (ret)
 		goto out;
 
-	bio = rq->bio;
+	bio = rq->bio_list.head;
 	memset(sense, 0, sizeof(sense));
 	rq->sense = sense;
 	rq->sense_len = 0;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 1300df6..b015e2d 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2462,7 +2462,7 @@ static int buffer_chain_size(void)
 	struct req_iterator iter;
 	char *base;
 
-	base = bio_data(current_req->bio);
+	base = bio_data(current_req->bio_list.head);
 	size = 0;
 
 	rq_for_each_segment(bv, current_req, iter) {
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index 3c11f06..deb76a4 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -504,7 +504,8 @@ ok_to_write:
 	i = --req->nr_sectors;
 	--req->current_nr_sectors;
 	req->buffer += 512;
-	if (!i || (req->bio && req->current_nr_sectors <= 0))
+	if (!i || (!bio_list_empty(&req->bio_list) &&
+		   req->current_nr_sectors <= 0))
 		end_request(req, 1);
 	if (i > 0) {
 		SET_HANDLER(&write_intr);
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index cceace6..da8beda 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2132,7 +2132,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 		rq->cmd_len = 12;
 		rq->cmd_type = REQ_TYPE_BLOCK_PC;
 		rq->timeout = 60 * HZ;
-		bio = rq->bio;
+		bio = rq->bio_list.head;
 
 		if (blk_execute_rq(q, cdi->disk, rq, 0)) {
 			struct request_sense *s = rq->sense;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 3aec19d..3303646 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -186,7 +186,7 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 				/* device sector size is 2K */
 				sector <<= 2;
 
-			bio_sectors = max(bio_sectors(failed_command->bio), 4U);
+			bio_sectors = max(bio_sectors(failed_command->bio_list.head), 4U);
 			sector &= ~(bio_sectors - 1);
 
 			/*
@@ -839,13 +839,14 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 	drive->dma = 0;
 
 	/* sg request */
-	if (rq->bio || ((rq->cmd_type == REQ_TYPE_ATA_PC) && rq->data_len)) {
+	if (!bio_list_empty(&rq->bio_list) ||
+	    ((rq->cmd_type == REQ_TYPE_ATA_PC) && rq->data_len)) {
 		struct request_queue *q = drive->queue;
 		unsigned int alignment;
 		char *buf;
 
-		if (rq->bio)
-			buf = bio_data(rq->bio);
+		if (!bio_list_empty(&rq->bio_list))
+			buf = bio_data(rq->bio_list.head);
 		else
 			buf = rq->data;
 
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index a0b8cab..b67fee3 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -519,13 +519,13 @@ ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error)
 
 	rq->errors = 0;
 
-	if (!rq->bio)
+	if (bio_list_empty(&rq->bio_list))
 		goto out;
 
-	rq->sector = rq->bio->bi_sector;
-	rq->current_nr_sectors = bio_iovec(rq->bio)->bv_len >> 9;
+	rq->sector = rq->bio_list.head->bi_sector;
+	rq->current_nr_sectors = bio_iovec(rq->bio_list.head)->bv_len >> 9;
 	rq->hard_cur_sectors = rq->current_nr_sectors;
-	rq->buffer = bio_data(rq->bio);
+	rq->buffer = bio_data(rq->bio_list.head);
 out:
 	return ret;
 }
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 2b4868d..548f243 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -219,7 +219,7 @@ static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
 	if (rq->data_len && rq_data_dir(rq) == WRITE)
 		pc->flags |= PC_FLAG_WRITING;
 	pc->buf = rq->data;
-	if (rq->bio)
+	if (!bio_list_empty(&rq->bio_list))
 		pc->flags |= PC_FLAG_DMA_OK;
 	/*
 	 * possibly problematic, doesn't look like ide-floppy correctly
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 35dc38d..f7ce3dd 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -251,7 +251,7 @@ void ide_map_sg(ide_drive_t *drive, struct ide_cmd *cmd)
 	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
 		cmd->sg_nents = 1;
-	} else if (!rq->bio) {
+	} else if (bio_list_empty(&rq->bio_list)) {
 		sg_init_one(sg, rq->data, rq->data_len);
 		cmd->sg_nents = 1;
 	} else
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index a9019f0..76f9738 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1275,10 +1275,11 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	}
 
 	/* do we need to support multiple segments? */
-	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
+	if (req->bio_list.head->bi_vcnt > 1 ||
+	    rsp->bio_list.head->bi_vcnt > 1) {
 		printk(MYIOC_s_ERR_FMT "%s: multiple segments req %u %u, rsp %u %u\n",
-		    ioc->name, __func__, req->bio->bi_vcnt, req->data_len,
-		    rsp->bio->bi_vcnt, rsp->data_len);
+		    ioc->name, __func__, req->bio_list.head->bi_vcnt,
+		    req->data_len, rsp->bio_list.head->bi_vcnt, rsp->data_len);
 		return -EINVAL;
 	}
 
@@ -1323,7 +1324,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		       mpt_addr_size()) << MPI_SGE_FLAGS_SHIFT;
 	flagsLength |= (req->data_len - 4);
 
-	dma_addr_out = pci_map_single(ioc->pcidev, bio_data(req->bio),
+	dma_addr_out = pci_map_single(ioc->pcidev, bio_data(req->bio_list.head),
 				      req->data_len, PCI_DMA_BIDIRECTIONAL);
 	if (!dma_addr_out)
 		goto put_mf;
@@ -1333,7 +1334,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	/* response */
 	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ;
 	flagsLength |= rsp->data_len + 4;
-	dma_addr_in =  pci_map_single(ioc->pcidev, bio_data(rsp->bio),
+	dma_addr_in =  pci_map_single(ioc->pcidev, bio_data(rsp->bio_list.head),
 				      rsp->data_len, PCI_DMA_BIDIRECTIONAL);
 	if (!dma_addr_in)
 		goto unmap;
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 3da02e4..26daefd 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1925,15 +1925,16 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	}
 
 	/* do we need to support multiple segments? */
-	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
+	if (req->bio_list.head->bi_vcnt > 1 ||
+	    rsp->bio_list.head->bi_vcnt > 1) {
 		printk("%s: multiple segments req %u %u, rsp %u %u\n",
-		       __func__, req->bio->bi_vcnt, req->data_len,
-		       rsp->bio->bi_vcnt, rsp->data_len);
+		       __func__, req->bio_list.head->bi_vcnt, req->data_len,
+		       rsp->bio_list.head->bi_vcnt, rsp->data_len);
 		return -EINVAL;
 	}
 
-	ret = smp_execute_task(dev, bio_data(req->bio), req->data_len,
-			       bio_data(rsp->bio), rsp->data_len);
+	ret = smp_execute_task(dev, bio_data(req->bio_list.head), req->data_len,
+			       bio_data(rsp->bio_list.head), rsp->data_len);
 	if (ret > 0) {
 		/* positive number is the untransferred residual */
 		rsp->data_len = ret;
diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index d110a36..405e97e 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -140,8 +140,8 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 	if (req->data_len < 8 || rsp->data_len < 8)
 		goto out;
 
-	if (bio_offset(req->bio) + req->data_len > PAGE_SIZE ||
-	    bio_offset(rsp->bio) + rsp->data_len > PAGE_SIZE) {
+	if (bio_offset(req->bio_list.head) + req->data_len > PAGE_SIZE ||
+	    bio_offset(rsp->bio_list.head) + rsp->data_len > PAGE_SIZE) {
 		shost_printk(KERN_ERR, shost,
 			"SMP request/response frame crosses page boundary");
 		goto out;
@@ -159,9 +159,10 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 	}
 
 	local_irq_disable();
-	buf = kmap_atomic(bio_page(req->bio), KM_USER0) + bio_offset(req->bio);
+	buf = kmap_atomic(bio_page(req->bio_list.head), KM_USER0) +
+	      bio_offset(req->bio_list.head);
 	memcpy(req_data, buf, req->data_len);
-	kunmap_atomic(buf - bio_offset(req->bio), KM_USER0);
+	kunmap_atomic(buf - bio_offset(req->bio_list.head), KM_USER0);
 	local_irq_enable();
 
 	if (req_data[0] != SMP_REQUEST)
@@ -260,10 +261,11 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 	}
 
 	local_irq_disable();
-	buf = kmap_atomic(bio_page(rsp->bio), KM_USER0) + bio_offset(rsp->bio);
+	buf = kmap_atomic(bio_page(rsp->bio_list.head), KM_USER0) +
+	      bio_offset(rsp->bio_list.head);
 	memcpy(buf, resp_data, rsp->data_len);
-	flush_kernel_dcache_page(bio_page(rsp->bio));
-	kunmap_atomic(buf - bio_offset(rsp->bio), KM_USER0);
+	flush_kernel_dcache_page(bio_page(rsp->bio_list.head));
+	kunmap_atomic(buf - bio_offset(rsp->bio_list.head), KM_USER0);
 	local_irq_enable();
 	rsp->data_len = resp_data_len;
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index e03dc0b..99f1262 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1038,10 +1038,11 @@ transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	}
 
 	/* do we need to support multiple segments? */
-	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
+	if (req->bio_list.head->bi_vcnt > 1 ||
+	    rsp->bio_list.head->bi_vcnt > 1) {
 		printk(MPT2SAS_ERR_FMT "%s: multiple segments req %u %u, "
-		    "rsp %u %u\n", ioc->name, __func__, req->bio->bi_vcnt,
-		    req->data_len, rsp->bio->bi_vcnt, rsp->data_len);
+		    "rsp %u %u\n", ioc->name, __func__, req->bio_list.head->bi_vcnt,
+		    req->data_len, rsp->bio_list.head->bi_vcnt, rsp->data_len);
 		return -EINVAL;
 	}
 
@@ -1111,7 +1112,7 @@ transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	sgl_flags = (MPI2_SGE_FLAGS_SIMPLE_ELEMENT |
 	    MPI2_SGE_FLAGS_END_OF_BUFFER | MPI2_SGE_FLAGS_HOST_TO_IOC);
 	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
-	dma_addr_out = pci_map_single(ioc->pdev, bio_data(req->bio),
+	dma_addr_out = pci_map_single(ioc->pdev, bio_data(req->bio_list.head),
 	      req->data_len, PCI_DMA_BIDIRECTIONAL);
 	if (!dma_addr_out) {
 		mpt2sas_base_free_smid(ioc, le16_to_cpu(smid));
@@ -1129,7 +1130,7 @@ transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	    MPI2_SGE_FLAGS_LAST_ELEMENT | MPI2_SGE_FLAGS_END_OF_BUFFER |
 	    MPI2_SGE_FLAGS_END_OF_LIST);
 	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
-	dma_addr_in =  pci_map_single(ioc->pdev, bio_data(rsp->bio),
+	dma_addr_in =  pci_map_single(ioc->pdev, bio_data(rsp->bio_list.head),
 	      rsp->data_len, PCI_DMA_BIDIRECTIONAL);
 	if (!dma_addr_in) {
 		mpt2sas_base_free_smid(ioc, le16_to_cpu(smid));
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 2a5f077..5682796 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -352,7 +352,7 @@ static void _osd_free_seg(struct osd_request *or __unused,
 static void _put_request(struct request *rq , bool is_async)
 {
 	if (is_async) {
-		WARN_ON(rq->bio);
+		WARN_ON(!bio_list_empty(&rq->bio_list));
 		__blk_put_request(rq->q, rq);
 	} else {
 		/*
@@ -361,7 +361,7 @@ static void _put_request(struct request *rq , bool is_async)
 		 * TODO: Keep error code in or->async_error. Need to audit all
 		 *       code paths.
 		 */
-		if (unlikely(rq->bio))
+		if (unlikely(!bio_list_empty(&rq->bio_list)))
 			blk_end_request(rq, -ENOMEM, blk_rq_bytes(rq));
 		else
 			blk_put_request(rq);
@@ -1192,7 +1192,8 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
 		or->out.last_seg = NULL;
 
 		/* they are now all chained to request sign them all together */
-		osd_sec_sign_data(&or->out_data_integ, or->out.req->bio,
+		osd_sec_sign_data(&or->out_data_integ,
+				  or->out.req->bio_list.head,
 				  cap_key);
 	}
 
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index acb8358..e4e41fc 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -392,7 +392,7 @@ static int osst_execute(struct osst_request *SRpnt, const unsigned char *cmd,
 			kfree(pages);
 			goto free_req;
 		}
-		SRpnt->bio = req->bio;
+		SRpnt->bio = req->bio_list.head;
 		mdata->pages = pages;
 
 	} else if (bufflen) {
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d1cb64a..e84c9e9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1078,7 +1078,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	 * that does not transfer data, in which case they may optionally
 	 * submit a request without an attached bio.
 	 */
-	if (req->bio) {
+	if (!bio_list_empty(&req->bio_list)) {
 		int ret;
 
 		BUG_ON(!req->nr_phys_segments);
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 48ba413..28b570e 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -377,7 +377,7 @@ static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
 		return err;
 	}
 
-	tcmd->bio = rq->bio;
+	tcmd->bio = rq->bio_list.head;
 	err = scsi_init_io(cmd, GFP_KERNEL);
 	if (err) {
 		scsi_release_buffers(cmd);
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 184dff4..011bd1e 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -444,7 +444,7 @@ int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_s
 	if (rq->cmd_flags & REQ_INTEGRITY)
 		return 0;
 
-	sdkp = rq->bio->bi_bdev->bd_disk->private_data;
+	sdkp = rq->bio_list.head->bi_bdev->bd_disk->private_data;
 
 	if (sdkp->protection_type == SD_DIF_TYPE3_PROTECTION)
 		return 0;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 82312df..f59f30f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1686,7 +1686,7 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 				      hp->dxfer_len, GFP_ATOMIC);
 
 	if (!res) {
-		srp->bio = rq->bio;
+		srp->bio = rq->bio_list.head;
 
 		if (!md) {
 			req_schp->dio_in_use = 1;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0e1a0f2..d523ec9 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -284,9 +284,9 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 				(SCpnt->sense_buffer[4] << 16) |
 				(SCpnt->sense_buffer[5] << 8) |
 				SCpnt->sense_buffer[6];
-			if (SCpnt->request->bio != NULL)
+			if (!bio_list_empty(&SCpnt->request->bio_list))
 				block_sectors =
-					bio_sectors(SCpnt->request->bio);
+					bio_sectors(SCpnt->request->bio_list.head);
 			if (block_sectors < 4)
 				block_sectors = 4;
 			if (cd->device->sector_size == 2048)
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index eb24efe..595afda 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -500,7 +500,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 		}
 	}
 
-	SRpnt->bio = req->bio;
+	SRpnt->bio = req->bio_list.head;
 	req->cmd_len = COMMAND_SIZE(cmd[0]);
 	memset(req->cmd, 0, BLK_MAX_CDB);
 	memcpy(req->cmd, cmd, req->cmd_len);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba54c83..acb3254 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -178,8 +178,7 @@ struct request {
 	/* no. of sectors left to complete in the current segment */
 	unsigned int hard_cur_sectors;
 
-	struct bio *bio;
-	struct bio *biotail;
+	struct bio_list bio_list;
 
 	struct hlist_node hash;	/* merge hash */
 	/*
@@ -730,8 +729,8 @@ struct req_iterator {
 #define for_each_bio(_bio)		\
 	for (; _bio; _bio = _bio->bi_next)
 #define __rq_for_each_bio(_bio, rq)	\
-	if ((rq->bio))			\
-		for (_bio = (rq)->bio; _bio; _bio = _bio->bi_next)
+	if (!bio_list_empty(&(rq)->bio_list))			\
+		for (_bio = (rq)->bio_list.head; _bio; _bio = _bio->bi_next)
 
 #define rq_for_each_segment(bvl, _rq, _iter)			\
 	__rq_for_each_bio(_iter.bio, _rq)			\
@@ -1077,10 +1076,10 @@ static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
 
 static inline int blk_integrity_rq(struct request *rq)
 {
-	if (rq->bio == NULL)
+	if (bio_list_empty(&rq->bio_list))
 		return 0;
 
-	return bio_integrity(rq->bio);
+	return bio_integrity(rq->bio_list.head);
 }
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
