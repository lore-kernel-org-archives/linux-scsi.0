From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/10] block: convert to pos and nr_sectors accessors
Date: Wed, 29 Apr 2009 18:13:43 +0900
Message-ID: <1240996428-10159-6-git-send-email-tj@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:56420 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbZD2JSn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2009 05:18:43 -0400
In-Reply-To: <1240996428-10159-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petko
Cc: Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>

With recent cleanups, there is no place where low level driver
directly manipulates request fields.  This means that the 'hard'
request fields always equal the !hard fields.  Convert all
rq->sectors, nr_sectors and current_nr_sectors references to
accessors.

[ Impact: use pos and nr_sectors accessors ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Chirag Kantharia <chirag.kantharia@hp.com>
Cc: Eric Moore <Eric.Moore@lsi.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Miller <mike.miller@hp.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Clements <paul.clements@steeleye.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Tim Waugh <tim@cyberelk.net>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Dario Ballabio <ballabio_dario@emc.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/um/drivers/ubd_kern.c          |    2 +-
 block/as-iosched.c                  |   18 ++++++-----
 block/blk-barrier.c                 |    2 +-
 block/blk-core.c                    |   17 +++++------
 block/blk-merge.c                   |   10 +++---
 block/cfq-iosched.c                 |   18 ++++++------
 block/deadline-iosched.c            |    2 +-
 block/elevator.c                    |   22 +++++++-------
 drivers/block/DAC960.c              |    6 ++--
 drivers/block/amiflop.c             |    6 ++--
 drivers/block/ataflop.c             |   10 +++---
 drivers/block/cciss.c               |   22 +++++++-------
 drivers/block/cpqarray.c            |    9 +++--
 drivers/block/floppy.c              |   53 ++++++++++++++++++-----------------
 drivers/block/hd.c                  |   14 ++++----
 drivers/block/nbd.c                 |   12 ++++----
 drivers/block/paride/pcd.c          |    4 +-
 drivers/block/paride/pd.c           |    8 ++--
 drivers/block/paride/pf.c           |    8 ++--
 drivers/block/ps3disk.c             |    9 ++---
 drivers/block/sunvdc.c              |    2 +-
 drivers/block/swim3.c               |   34 ++++++++++++----------
 drivers/block/sx8.c                 |    6 ++--
 drivers/block/ub.c                  |    6 ++--
 drivers/block/viodasd.c             |    2 +-
 drivers/block/virtio_blk.c          |    2 +-
 drivers/block/xd.c                  |    4 +-
 drivers/block/xen-blkfront.c        |   11 +++----
 drivers/block/xsysace.c             |   17 ++++++-----
 drivers/block/z2ram.c               |    6 ++--
 drivers/cdrom/gdrom.c               |    6 ++--
 drivers/cdrom/viocd.c               |    2 +-
 drivers/memstick/core/mspro_block.c |    6 ++--
 drivers/message/i2o/i2o_block.c     |   20 +++++++------
 drivers/mmc/card/block.c            |   10 +++---
 drivers/mtd/mtd_blkdevs.c           |    7 ++--
 drivers/s390/block/dasd.c           |    2 +-
 drivers/s390/block/dasd_diag.c      |    5 ++-
 drivers/s390/block/dasd_eckd.c      |    6 ++--
 drivers/s390/block/dasd_fba.c       |    7 ++--
 drivers/s390/char/tape_34xx.c       |    2 +-
 drivers/s390/char/tape_3590.c       |    2 +-
 drivers/s390/char/tape_block.c      |    2 +-
 drivers/sbus/char/jsflash.c         |    4 +-
 drivers/scsi/eata.c                 |   24 ++++++++--------
 drivers/scsi/lpfc/lpfc_scsi.c       |   22 +++++++-------
 drivers/scsi/scsi_lib.c             |    6 ++--
 drivers/scsi/sd.c                   |   24 ++++++++--------
 drivers/scsi/sd_dif.c               |    2 +-
 drivers/scsi/sr.c                   |   15 +++++----
 drivers/scsi/u14-34f.c              |   22 ++++++++------
 include/scsi/scsi_cmnd.h            |    2 +-
 52 files changed, 276 insertions(+), 264 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 4330127..402ba8f 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1239,7 +1239,7 @@ static void do_ubd_request(struct request_queue *q)
 		}
 
 		req = dev->request;
-		sector = req->sector;
+		sector = blk_rq_pos(req);
 		while(dev->start_sg < dev->end_sg){
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
diff --git a/block/as-iosched.c b/block/as-iosched.c
index 45bd070..7a12cf6 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -306,8 +306,8 @@ as_choose_req(struct as_data *ad, struct request *rq1, struct request *rq2)
 	data_dir = rq_is_sync(rq1);
 
 	last = ad->last_sector[data_dir];
-	s1 = rq1->sector;
-	s2 = rq2->sector;
+	s1 = blk_rq_pos(rq1);
+	s2 = blk_rq_pos(rq2);
 
 	BUG_ON(data_dir != rq_is_sync(rq2));
 
@@ -566,13 +566,15 @@ static void as_update_iohist(struct as_data *ad, struct as_io_context *aic,
 			as_update_thinktime(ad, aic, thinktime);
 
 			/* Calculate read -> read seek distance */
-			if (aic->last_request_pos < rq->sector)
-				seek_dist = rq->sector - aic->last_request_pos;
+			if (aic->last_request_pos < blk_rq_pos(rq))
+				seek_dist = blk_rq_pos(rq) -
+					    aic->last_request_pos;
 			else
-				seek_dist = aic->last_request_pos - rq->sector;
+				seek_dist = aic->last_request_pos -
+					    blk_rq_pos(rq);
 			as_update_seekdist(ad, aic, seek_dist);
 		}
-		aic->last_request_pos = rq->sector + rq->nr_sectors;
+		aic->last_request_pos = blk_rq_pos(rq) + blk_rq_sectors(rq);
 		set_bit(AS_TASK_IOSTARTED, &aic->state);
 		spin_unlock(&aic->lock);
 	}
@@ -587,7 +589,7 @@ static int as_close_req(struct as_data *ad, struct as_io_context *aic,
 {
 	unsigned long delay;	/* jiffies */
 	sector_t last = ad->last_sector[ad->batch_data_dir];
-	sector_t next = rq->sector;
+	sector_t next = blk_rq_pos(rq);
 	sector_t delta; /* acceptable close offset (in sectors) */
 	sector_t s;
 
@@ -981,7 +983,7 @@ static void as_move_to_dispatch(struct as_data *ad, struct request *rq)
 	 * This has to be set in order to be correctly updated by
 	 * as_find_next_rq
 	 */
-	ad->last_sector[data_dir] = rq->sector + rq->nr_sectors;
+	ad->last_sector[data_dir] = blk_rq_pos(rq) + blk_rq_sectors(rq);
 
 	if (data_dir == BLK_RW_SYNC) {
 		struct io_context *ioc = RQ_IOC(rq);
diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index c167de5..8713c2f 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -324,7 +324,7 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 	/*
 	 * The driver must store the error location in ->bi_sector, if
 	 * it supports it. For non-stacked drivers, this should be copied
-	 * from rq->sector.
+	 * from blk_rq_pos(rq).
 	 */
 	if (error_sector)
 		*error_sector = bio->bi_sector;
diff --git a/block/blk-core.c b/block/blk-core.c
index 895e55b..82dc206 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -72,7 +72,7 @@ static void drive_stat_acct(struct request *rq, int new_io)
 		return;
 
 	cpu = part_stat_lock();
-	part = disk_map_sector_rcu(rq->rq_disk, rq->sector);
+	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
 
 	if (!new_io)
 		part_stat_inc(cpu, part, merges[rw]);
@@ -185,10 +185,9 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 		rq->rq_disk ? rq->rq_disk->disk_name : "?", rq->cmd_type,
 		rq->cmd_flags);
 
-	printk(KERN_INFO "  sector %llu, nr/cnr %lu/%u\n",
-						(unsigned long long)rq->sector,
-						rq->nr_sectors,
-						rq->current_nr_sectors);
+	printk(KERN_INFO "  sector %llu, nr/cnr %u/%u\n",
+	       (unsigned long long)blk_rq_pos(rq),
+	       blk_rq_sectors(rq), blk_rq_cur_sectors(rq));
 	printk(KERN_INFO "  bio %p, biotail %p, buffer %p, len %u\n",
 						rq->bio, rq->biotail,
 						rq->buffer, rq->data_len);
@@ -1557,7 +1556,7 @@ EXPORT_SYMBOL(submit_bio);
  */
 int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 {
-	if (rq->nr_sectors > q->max_sectors ||
+	if (blk_rq_sectors(rq) > q->max_sectors ||
 	    rq->data_len > q->max_hw_sectors << 9) {
 		printk(KERN_ERR "%s: over max size limit.\n", __func__);
 		return -EIO;
@@ -1645,7 +1644,7 @@ static void blk_account_io_completion(struct request *req, unsigned int bytes)
 		int cpu;
 
 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, req->sector);
+		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
 		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
 		part_stat_unlock();
 	}
@@ -1665,7 +1664,7 @@ static void blk_account_io_done(struct request *req)
 		int cpu;
 
 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, req->sector);
+		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
 
 		part_stat_inc(cpu, part, ios[rw]);
 		part_stat_add(cpu, part, ticks[rw], duration);
@@ -1846,7 +1845,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	if (error && (blk_fs_request(req) && !(req->cmd_flags & REQ_QUIET))) {
 		printk(KERN_ERR "end_request: I/O error, dev %s, sector %llu\n",
 				req->rq_disk ? req->rq_disk->disk_name : "?",
-				(unsigned long long)req->sector);
+				(unsigned long long)blk_rq_pos(req));
 	}
 
 	blk_account_io_completion(req, nr_bytes);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 23d2a6f..bf62a87 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -259,7 +259,7 @@ int ll_back_merge_fn(struct request_queue *q, struct request *req,
 	else
 		max_sectors = q->max_sectors;
 
-	if (req->nr_sectors + bio_sectors(bio) > max_sectors) {
+	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -284,7 +284,7 @@ int ll_front_merge_fn(struct request_queue *q, struct request *req,
 		max_sectors = q->max_sectors;
 
 
-	if (req->nr_sectors + bio_sectors(bio) > max_sectors) {
+	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -315,7 +315,7 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	/*
 	 * Will it become too large?
 	 */
-	if ((req->nr_sectors + next->nr_sectors) > q->max_sectors)
+	if ((blk_rq_sectors(req) + blk_rq_sectors(next)) > q->max_sectors)
 		return 0;
 
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
@@ -345,7 +345,7 @@ static void blk_account_io_merge(struct request *req)
 		int cpu;
 
 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, req->sector);
+		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
 
 		part_round_stats(cpu, part);
 		part_dec_in_flight(part);
@@ -366,7 +366,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	/*
 	 * not contiguous
 	 */
-	if (req->sector + req->nr_sectors != next->sector)
+	if (blk_rq_pos(req) + blk_rq_sectors(req) != blk_rq_pos(next))
 		return 0;
 
 	if (rq_data_dir(req) != rq_data_dir(next)
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 575083a..db4d990 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -349,8 +349,8 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2)
 	else if (rq_is_meta(rq2) && !rq_is_meta(rq1))
 		return rq2;
 
-	s1 = rq1->sector;
-	s2 = rq2->sector;
+	s1 = blk_rq_pos(rq1);
+	s2 = blk_rq_pos(rq2);
 
 	last = cfqd->last_position;
 
@@ -949,10 +949,10 @@ static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd,
 static inline sector_t cfq_dist_from_last(struct cfq_data *cfqd,
 					  struct request *rq)
 {
-	if (rq->sector >= cfqd->last_position)
-		return rq->sector - cfqd->last_position;
+	if (blk_rq_pos(rq) >= cfqd->last_position)
+		return blk_rq_pos(rq) - cfqd->last_position;
 	else
-		return cfqd->last_position - rq->sector;
+		return cfqd->last_position - blk_rq_pos(rq);
 }
 
 #define CIC_SEEK_THR	8 * 1024
@@ -1918,10 +1918,10 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_io_context *cic,
 
 	if (!cic->last_request_pos)
 		sdist = 0;
-	else if (cic->last_request_pos < rq->sector)
-		sdist = rq->sector - cic->last_request_pos;
+	else if (cic->last_request_pos < blk_rq_pos(rq))
+		sdist = blk_rq_pos(rq) - cic->last_request_pos;
 	else
-		sdist = cic->last_request_pos - rq->sector;
+		sdist = cic->last_request_pos - blk_rq_pos(rq);
 
 	/*
 	 * Don't allow the seek distance to get too large from the
@@ -2071,7 +2071,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfq_update_io_seektime(cfqd, cic, rq);
 	cfq_update_idle_window(cfqd, cfqq, cic);
 
-	cic->last_request_pos = rq->sector + rq->nr_sectors;
+	cic->last_request_pos = blk_rq_pos(rq) + blk_rq_sectors(rq);
 
 	if (cfqq == cfqd->active_queue) {
 		/*
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index c4d991d..b547cbc 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -138,7 +138,7 @@ deadline_merge(struct request_queue *q, struct request **req, struct bio *bio)
 
 		__rq = elv_rb_find(&dd->sort_list[bio_data_dir(bio)], sector);
 		if (__rq) {
-			BUG_ON(sector != __rq->sector);
+			BUG_ON(sector != blk_rq_pos(__rq));
 
 			if (elv_rq_merge_ok(__rq, bio)) {
 				ret = ELEVATOR_FRONT_MERGE;
diff --git a/block/elevator.c b/block/elevator.c
index 1af5d9f..9189200 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -52,7 +52,7 @@ static const int elv_hash_shift = 6;
 #define ELV_HASH_FN(sec)	\
 		(hash_long(ELV_HASH_BLOCK((sec)), elv_hash_shift))
 #define ELV_HASH_ENTRIES	(1 << elv_hash_shift)
-#define rq_hash_key(rq)		((rq)->sector + (rq)->nr_sectors)
+#define rq_hash_key(rq)		(blk_rq_pos(rq) + blk_rq_sectors(rq))
 
 DEFINE_TRACE(block_rq_insert);
 DEFINE_TRACE(block_rq_issue);
@@ -119,9 +119,9 @@ static inline int elv_try_merge(struct request *__rq, struct bio *bio)
 	 * we can merge and sequence is ok, check if it's possible
 	 */
 	if (elv_rq_merge_ok(__rq, bio)) {
-		if (__rq->sector + __rq->nr_sectors == bio->bi_sector)
+		if (blk_rq_pos(__rq) + blk_rq_sectors(__rq) == bio->bi_sector)
 			ret = ELEVATOR_BACK_MERGE;
-		else if (__rq->sector - bio_sectors(bio) == bio->bi_sector)
+		else if (blk_rq_pos(__rq) - bio_sectors(bio) == bio->bi_sector)
 			ret = ELEVATOR_FRONT_MERGE;
 	}
 
@@ -370,9 +370,9 @@ struct request *elv_rb_add(struct rb_root *root, struct request *rq)
 		parent = *p;
 		__rq = rb_entry(parent, struct request, rb_node);
 
-		if (rq->sector < __rq->sector)
+		if (blk_rq_pos(rq) < blk_rq_pos(__rq))
 			p = &(*p)->rb_left;
-		else if (rq->sector > __rq->sector)
+		else if (blk_rq_pos(rq) > blk_rq_pos(__rq))
 			p = &(*p)->rb_right;
 		else
 			return __rq;
@@ -400,9 +400,9 @@ struct request *elv_rb_find(struct rb_root *root, sector_t sector)
 	while (n) {
 		rq = rb_entry(n, struct request, rb_node);
 
-		if (sector < rq->sector)
+		if (sector < blk_rq_pos(rq))
 			n = n->rb_left;
-		else if (sector > rq->sector)
+		else if (sector > blk_rq_pos(rq))
 			n = n->rb_right;
 		else
 			return rq;
@@ -441,14 +441,14 @@ void elv_dispatch_sort(struct request_queue *q, struct request *rq)
 			break;
 		if (pos->cmd_flags & stop_flags)
 			break;
-		if (rq->sector >= boundary) {
-			if (pos->sector < boundary)
+		if (blk_rq_pos(rq) >= boundary) {
+			if (blk_rq_pos(pos) < boundary)
 				continue;
 		} else {
-			if (pos->sector >= boundary)
+			if (blk_rq_pos(pos) >= boundary)
 				break;
 		}
-		if (rq->sector >= pos->sector)
+		if (blk_rq_pos(rq) >= blk_rq_pos(pos))
 			break;
 	}
 
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index f22ed6c..774ab05 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -3338,8 +3338,8 @@ static int DAC960_process_queue(DAC960_Controller_T *Controller, struct request_
 	}
 	Command->Completion = Request->end_io_data;
 	Command->LogicalDriveNumber = (long)Request->rq_disk->private_data;
-	Command->BlockNumber = Request->sector;
-	Command->BlockCount = Request->nr_sectors;
+	Command->BlockNumber = blk_rq_pos(Request);
+	Command->BlockCount = blk_rq_sectors(Request);
 	Command->Request = Request;
 	blkdev_dequeue_request(Request);
 	Command->SegmentCount = blk_rq_map_sg(req_q,
@@ -3431,7 +3431,7 @@ static void DAC960_queue_partial_rw(DAC960_Command_T *Command)
    * successfully as possible.
    */
   Command->SegmentCount = 1;
-  Command->BlockNumber = Request->sector;
+  Command->BlockNumber = blk_rq_pos(Request);
   Command->BlockCount = 1;
   DAC960_QueueReadWriteCommand(Command);
   return;
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 8ff95f2..e4a14b9 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1351,13 +1351,13 @@ static void redo_fd_request(void)
 	drive = floppy - unit;
 
 	/* Here someone could investigate to be more efficient */
-	for (cnt = 0; cnt < CURRENT->current_nr_sectors; cnt++) { 
+	for (cnt = 0; cnt < blk_rq_cur_sectors(CURRENT); cnt++) {
 #ifdef DEBUG
 		printk("fd: sector %ld + %d requested for %s\n",
-		       CURRENT->sector,cnt,
+		       blk_rq_pos(CURRENT), cnt,
 		       (rq_data_dir(CURRENT) == READ) ? "read" : "write");
 #endif
-		block = CURRENT->sector + cnt;
+		block = blk_rq_pos(CURRENT) + cnt;
 		if ((int)block > floppy->blocks) {
 			__blk_end_request_cur(CURRENT, -EIO);
 			goto repeat;
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 2506728..234024c 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -725,7 +725,7 @@ static void do_fd_action( int drive )
 	    if (IS_BUFFERED( drive, ReqSide, ReqTrack )) {
 		if (ReqCmd == READ) {
 		    copy_buffer( SECTOR_BUFFER(ReqSector), ReqData );
-		    if (++ReqCnt < CURRENT->current_nr_sectors) {
+		    if (++ReqCnt < blk_rq_cur_sectors(CURRENT)) {
 			/* read next sector */
 			setup_req_params( drive );
 			goto repeat;
@@ -1130,7 +1130,7 @@ static void fd_rwsec_done1(int status)
 		}
 	}
   
-	if (++ReqCnt < CURRENT->current_nr_sectors) {
+	if (++ReqCnt < blk_rq_cur_sectors(CURRENT)) {
 		/* read next sector */
 		setup_req_params( SelectedDrive );
 		do_fd_action( SelectedDrive );
@@ -1394,7 +1394,7 @@ static void redo_fd_request(void)
 
 	DPRINT(("redo_fd_request: CURRENT=%p dev=%s CURRENT->sector=%ld\n",
 		CURRENT, CURRENT ? CURRENT->rq_disk->disk_name : "",
-		CURRENT ? CURRENT->sector : 0 ));
+		CURRENT ? blk_rq_pos(CURRENT) : 0 ));
 
 	IsFormatting = 0;
 
@@ -1440,7 +1440,7 @@ repeat:
 		UD.autoprobe = 0;
 	}
 	
-	if (CURRENT->sector + 1 > UDT->blocks) {
+	if (blk_rq_pos(CURRENT) + 1 > UDT->blocks) {
 		__blk_end_request_cur(CURRENT, -EIO);
 		goto repeat;
 	}
@@ -1450,7 +1450,7 @@ repeat:
 		
 	ReqCnt = 0;
 	ReqCmd = rq_data_dir(CURRENT);
-	ReqBlock = CURRENT->sector;
+	ReqBlock = blk_rq_pos(CURRENT);
 	ReqBuffer = CURRENT->buffer;
 	setup_req_params( drive );
 	do_fd_action( drive );
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index f22d493..ab7b04c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2835,10 +2835,10 @@ static void do_cciss_request(struct request_queue *q)
 	c->Request.Timeout = 0;	// Don't time out
 	c->Request.CDB[0] =
 	    (rq_data_dir(creq) == READ) ? h->cciss_read : h->cciss_write;
-	start_blk = creq->sector;
+	start_blk = blk_rq_pos(creq);
 #ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "ciss: sector =%d nr_sectors=%d\n", (int)creq->sector,
-	       (int)creq->nr_sectors);
+	printk(KERN_DEBUG "ciss: sector =%d nr_sectors=%d\n",
+	       (int)blk_rq_pos(creq), (int)blk_rq_sectors(creq));
 #endif				/* CCISS_DEBUG */
 
 	sg_init_table(tmp_sg, MAXSGENTRIES);
@@ -2864,8 +2864,8 @@ static void do_cciss_request(struct request_queue *q)
 		h->maxSG = seg;
 
 #ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "cciss: Submitting %lu sectors in %d segments\n",
-	       creq->nr_sectors, seg);
+	printk(KERN_DEBUG "cciss: Submitting %u sectors in %d segments\n",
+	       blk_rq_sectors(creq), seg);
 #endif				/* CCISS_DEBUG */
 
 	c->Header.SGList = c->Header.SGTotal = seg;
@@ -2877,8 +2877,8 @@ static void do_cciss_request(struct request_queue *q)
 			c->Request.CDB[4] = (start_blk >> 8) & 0xff;
 			c->Request.CDB[5] = start_blk & 0xff;
 			c->Request.CDB[6] = 0;	// (sect >> 24) & 0xff; MSB
-			c->Request.CDB[7] = (creq->nr_sectors >> 8) & 0xff;
-			c->Request.CDB[8] = creq->nr_sectors & 0xff;
+			c->Request.CDB[7] = (blk_rq_sectors(creq) >> 8) & 0xff;
+			c->Request.CDB[8] = blk_rq_sectors(creq) & 0xff;
 			c->Request.CDB[9] = c->Request.CDB[11] = c->Request.CDB[12] = 0;
 		} else {
 			u32 upper32 = upper_32_bits(start_blk);
@@ -2893,10 +2893,10 @@ static void do_cciss_request(struct request_queue *q)
 			c->Request.CDB[7]= (start_blk >> 16) & 0xff;
 			c->Request.CDB[8]= (start_blk >>  8) & 0xff;
 			c->Request.CDB[9]= start_blk & 0xff;
-			c->Request.CDB[10]= (creq->nr_sectors >>  24) & 0xff;
-			c->Request.CDB[11]= (creq->nr_sectors >>  16) & 0xff;
-			c->Request.CDB[12]= (creq->nr_sectors >>  8) & 0xff;
-			c->Request.CDB[13]= creq->nr_sectors & 0xff;
+			c->Request.CDB[10]= (blk_rq_sectors(creq) >> 24) & 0xff;
+			c->Request.CDB[11]= (blk_rq_sectors(creq) >> 16) & 0xff;
+			c->Request.CDB[12]= (blk_rq_sectors(creq) >>  8) & 0xff;
+			c->Request.CDB[13]= blk_rq_sectors(creq) & 0xff;
 			c->Request.CDB[14] = c->Request.CDB[15] = 0;
 		}
 	} else if (blk_pc_request(creq)) {
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 488a8f4..a5caeff 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -919,10 +919,11 @@ queue_next:
 	c->hdr.size = sizeof(rblk_t) >> 2;
 	c->size += sizeof(rblk_t);
 
-	c->req.hdr.blk = creq->sector;
+	c->req.hdr.blk = blk_rq_pos(creq);
 	c->rq = creq;
 DBGPX(
-	printk("sector=%d, nr_sectors=%d\n", creq->sector, creq->nr_sectors);
+	printk("sector=%d, nr_sectors=%u\n",
+	       blk_rq_pos(creq), blk_rq_sectors(creq));
 );
 	sg_init_table(tmp_sg, SG_MAX);
 	seg = blk_rq_map_sg(q, creq, tmp_sg);
@@ -940,9 +941,9 @@ DBGPX(
 						 tmp_sg[i].offset,
 						 tmp_sg[i].length, dir);
 	}
-DBGPX(	printk("Submitting %d sectors in %d segments\n", creq->nr_sectors, seg); );
+DBGPX(	printk("Submitting %u sectors in %d segments\n", blk_rq_sectors(creq), seg); );
 	c->req.hdr.sg_cnt = seg;
-	c->req.hdr.blk_cnt = creq->nr_sectors;
+	c->req.hdr.blk_cnt = blk_rq_sectors(creq);
 	c->req.hdr.cmd = (rq_data_dir(creq) == READ) ? IDA_READ : IDA_WRITE;
 	c->type = CMD_RWREQ;
 
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 1300df6..4524862 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2303,7 +2303,7 @@ static void floppy_end_request(struct request *req, int error)
 
 	/* current_count_sectors can be zero if transfer failed */
 	if (error)
-		nr_sectors = req->current_nr_sectors;
+		nr_sectors = blk_rq_cur_sectors(req);
 	if (__blk_end_request(req, error, nr_sectors << 9))
 		return;
 
@@ -2332,7 +2332,7 @@ static void request_done(int uptodate)
 	if (uptodate) {
 		/* maintain values for invalidation on geometry
 		 * change */
-		block = current_count_sectors + req->sector;
+		block = current_count_sectors + blk_rq_pos(req);
 		INFBOUND(DRS->maxblock, block);
 		if (block > _floppy->sect)
 			DRS->maxtrack = 1;
@@ -2346,10 +2346,10 @@ static void request_done(int uptodate)
 			/* record write error information */
 			DRWE->write_errors++;
 			if (DRWE->write_errors == 1) {
-				DRWE->first_error_sector = req->sector;
+				DRWE->first_error_sector = blk_rq_pos(req);
 				DRWE->first_error_generation = DRS->generation;
 			}
-			DRWE->last_error_sector = req->sector;
+			DRWE->last_error_sector = blk_rq_pos(req);
 			DRWE->last_error_generation = DRS->generation;
 		}
 		spin_lock_irqsave(q->queue_lock, flags);
@@ -2503,24 +2503,24 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 
 	max_sector = transfer_size(ssize,
 				   min(max_sector, max_sector_2),
-				   current_req->nr_sectors);
+				   blk_rq_sectors(current_req));
 
 	if (current_count_sectors <= 0 && CT(COMMAND) == FD_WRITE &&
-	    buffer_max > fsector_t + current_req->nr_sectors)
+	    buffer_max > fsector_t + blk_rq_sectors(current_req))
 		current_count_sectors = min_t(int, buffer_max - fsector_t,
-					      current_req->nr_sectors);
+					      blk_rq_sectors(current_req));
 
 	remaining = current_count_sectors << 9;
 #ifdef FLOPPY_SANITY_CHECK
-	if ((remaining >> 9) > current_req->nr_sectors &&
+	if ((remaining >> 9) > blk_rq_sectors(current_req) &&
 	    CT(COMMAND) == FD_WRITE) {
 		DPRINT("in copy buffer\n");
 		printk("current_count_sectors=%ld\n", current_count_sectors);
 		printk("remaining=%d\n", remaining >> 9);
-		printk("current_req->nr_sectors=%ld\n",
-		       current_req->nr_sectors);
+		printk("current_req->nr_sectors=%u\n",
+		       blk_rq_sectors(current_req));
 		printk("current_req->current_nr_sectors=%u\n",
-		       current_req->current_nr_sectors);
+		       blk_rq_cur_sectors(current_req));
 		printk("max_sector=%d\n", max_sector);
 		printk("ssize=%d\n", ssize);
 	}
@@ -2530,7 +2530,7 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 
 	dma_buffer = floppy_track_buffer + ((fsector_t - buffer_min) << 9);
 
-	size = current_req->current_nr_sectors << 9;
+	size = blk_rq_cur_sectors(current_req) << 9;
 
 	rq_for_each_segment(bv, current_req, iter) {
 		if (!remaining)
@@ -2648,10 +2648,10 @@ static int make_raw_rw_request(void)
 
 	max_sector = _floppy->sect * _floppy->head;
 
-	TRACK = (int)current_req->sector / max_sector;
-	fsector_t = (int)current_req->sector % max_sector;
+	TRACK = (int)blk_rq_pos(current_req) / max_sector;
+	fsector_t = (int)blk_rq_pos(current_req) % max_sector;
 	if (_floppy->track && TRACK >= _floppy->track) {
-		if (current_req->current_nr_sectors & 1) {
+		if (blk_rq_cur_sectors(current_req) & 1) {
 			current_count_sectors = 1;
 			return 1;
 		} else
@@ -2669,7 +2669,7 @@ static int make_raw_rw_request(void)
 		if (fsector_t >= max_sector) {
 			current_count_sectors =
 			    min_t(int, _floppy->sect - fsector_t,
-				  current_req->nr_sectors);
+				  blk_rq_sectors(current_req));
 			return 1;
 		}
 		SIZECODE = 2;
@@ -2720,7 +2720,7 @@ static int make_raw_rw_request(void)
 
 	in_sector_offset = (fsector_t % _floppy->sect) % ssize;
 	aligned_sector_t = fsector_t - in_sector_offset;
-	max_size = current_req->nr_sectors;
+	max_size = blk_rq_sectors(current_req);
 	if ((raw_cmd->track == buffer_track) &&
 	    (current_drive == buffer_drive) &&
 	    (fsector_t >= buffer_min) && (fsector_t < buffer_max)) {
@@ -2729,10 +2729,10 @@ static int make_raw_rw_request(void)
 			copy_buffer(1, max_sector, buffer_max);
 			return 1;
 		}
-	} else if (in_sector_offset || current_req->nr_sectors < ssize) {
+	} else if (in_sector_offset || blk_rq_sectors(current_req) < ssize) {
 		if (CT(COMMAND) == FD_WRITE) {
-			if (fsector_t + current_req->nr_sectors > ssize &&
-			    fsector_t + current_req->nr_sectors < ssize + ssize)
+			if (fsector_t + blk_rq_sectors(current_req) > ssize &&
+			    fsector_t + blk_rq_sectors(current_req) < ssize + ssize)
 				max_size = ssize + ssize;
 			else
 				max_size = ssize;
@@ -2776,7 +2776,7 @@ static int make_raw_rw_request(void)
 		    (indirect * 2 > direct * 3 &&
 		     *errors < DP->max_errors.read_track && ((!probing
 		       || (DP->read_track & (1 << DRS->probed_format)))))) {
-			max_size = current_req->nr_sectors;
+			max_size = blk_rq_sectors(current_req);
 		} else {
 			raw_cmd->kernel_data = current_req->buffer;
 			raw_cmd->length = current_count_sectors << 9;
@@ -2801,7 +2801,7 @@ static int make_raw_rw_request(void)
 	    fsector_t > buffer_max ||
 	    fsector_t < buffer_min ||
 	    ((CT(COMMAND) == FD_READ ||
-	      (!in_sector_offset && current_req->nr_sectors >= ssize)) &&
+	      (!in_sector_offset && blk_rq_sectors(current_req) >= ssize)) &&
 	     max_sector > 2 * max_buffer_sectors + buffer_min &&
 	     max_size + fsector_t > 2 * max_buffer_sectors + buffer_min)
 	    /* not enough space */
@@ -2879,8 +2879,8 @@ static int make_raw_rw_request(void)
 				printk("write\n");
 			return 0;
 		}
-	} else if (raw_cmd->length > current_req->nr_sectors << 9 ||
-		   current_count_sectors > current_req->nr_sectors) {
+	} else if (raw_cmd->length > blk_rq_sectors(current_req) << 9 ||
+		   current_count_sectors > blk_rq_sectors(current_req)) {
 		DPRINT("buffer overrun in direct transfer\n");
 		return 0;
 	} else if (raw_cmd->length < current_count_sectors << 9) {
@@ -2990,8 +2990,9 @@ static void do_fd_request(struct request_queue * q)
 	if (usage_count == 0) {
 		printk("warning: usage count=0, current_req=%p exiting\n",
 		       current_req);
-		printk("sect=%ld type=%x flags=%x\n", (long)current_req->sector,
-		       current_req->cmd_type, current_req->cmd_flags);
+		printk("sect=%ld type=%x flags=%x\n",
+		       (long)blk_rq_pos(current_req), current_req->cmd_type,
+		       current_req->cmd_flags);
 		return;
 	}
 	if (test_bit(0, &fdc_busy)) {
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index 75b9ca9..a3b3994 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -228,7 +228,7 @@ static void dump_status(const char *msg, unsigned int stat)
 			printk(", CHS=%d/%d/%d", (inb(HD_HCYL)<<8) + inb(HD_LCYL),
 				inb(HD_CURRENT) & 0xf, inb(HD_SECTOR));
 			if (CURRENT)
-				printk(", sector=%ld", CURRENT->sector);
+				printk(", sector=%ld", blk_rq_pos(CURRENT));
 		}
 		printk("\n");
 	}
@@ -457,9 +457,9 @@ ok_to_read:
 	req = CURRENT;
 	insw(HD_DATA, req->buffer, 256);
 #ifdef DEBUG
-	printk("%s: read: sector %ld, remaining = %ld, buffer=%p\n",
-		req->rq_disk->disk_name, req->sector + 1, req->nr_sectors - 1,
-		req->buffer+512);
+	printk("%s: read: sector %ld, remaining = %u, buffer=%p\n",
+	       req->rq_disk->disk_name, blk_rq_pos(req) + 1,
+	       blk_rq_sectors(req) - 1, req->buffer+512);
 #endif
 	if (__blk_end_request(req, 0, 512)) {
 		SET_HANDLER(&read_intr);
@@ -485,7 +485,7 @@ static void write_intr(void)
 			continue;
 		if (!OK_STATUS(i))
 			break;
-		if ((req->nr_sectors <= 1) || (i & DRQ_STAT))
+		if ((blk_rq_sectors(req) <= 1) || (i & DRQ_STAT))
 			goto ok_to_write;
 	} while (--retries > 0);
 	dump_status("write_intr", i);
@@ -589,8 +589,8 @@ repeat:
 		return;
 	}
 	disk = req->rq_disk->private_data;
-	block = req->sector;
-	nsect = req->nr_sectors;
+	block = blk_rq_pos(req);
+	nsect = blk_rq_sectors(req);
 	if (block >= get_capacity(req->rq_disk) ||
 	    ((block+nsect) > get_capacity(req->rq_disk))) {
 		printk("%s: bad access: block=%d, count=%d\n",
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index a9ab8be..977a573 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -110,7 +110,7 @@ static void nbd_end_request(struct request *req)
 			req, error ? "failed" : "done");
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	__blk_end_request(req, error, req->nr_sectors << 9);
+	__blk_end_request(req, error, blk_rq_sectors(req) << 9);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
@@ -231,19 +231,19 @@ static int nbd_send_req(struct nbd_device *lo, struct request *req)
 {
 	int result, flags;
 	struct nbd_request request;
-	unsigned long size = req->nr_sectors << 9;
+	unsigned long size = blk_rq_sectors(req) << 9;
 
 	request.magic = htonl(NBD_REQUEST_MAGIC);
 	request.type = htonl(nbd_cmd(req));
-	request.from = cpu_to_be64((u64) req->sector << 9);
+	request.from = cpu_to_be64((u64)blk_rq_pos(req) << 9);
 	request.len = htonl(size);
 	memcpy(request.handle, &req, sizeof(req));
 
-	dprintk(DBG_TX, "%s: request %p: sending control (%s@%llu,%luB)\n",
+	dprintk(DBG_TX, "%s: request %p: sending control (%s@%llu,%uB)\n",
 			lo->disk->disk_name, req,
 			nbdcmd_to_ascii(nbd_cmd(req)),
-			(unsigned long long)req->sector << 9,
-			req->nr_sectors << 9);
+			(unsigned long long)blk_rq_pos(req) << 9,
+			blk_rq_sectors(req) << 9);
 	result = sock_xmit(lo, 1, &request, sizeof(request),
 			(nbd_cmd(req) == NBD_CMD_WRITE) ? MSG_MORE : 0);
 	if (result <= 0) {
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 9fd57c2..2d5dc0a 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -728,8 +728,8 @@ static void do_pcd_request(struct request_queue * q)
 			if (cd != pcd_current)
 				pcd_bufblk = -1;
 			pcd_current = cd;
-			pcd_sector = pcd_req->sector;
-			pcd_count = pcd_req->current_nr_sectors;
+			pcd_sector = blk_rq_pos(pcd_req);
+			pcd_count = blk_rq_cur_sectors(pcd_req);
 			pcd_buf = pcd_req->buffer;
 			pcd_busy = 1;
 			ps_set_intr(do_pcd_read, NULL, 0, nice);
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 0732df4..9ec5d4a 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -444,11 +444,11 @@ static enum action do_pd_io_start(void)
 
 	pd_cmd = rq_data_dir(pd_req);
 	if (pd_cmd == READ || pd_cmd == WRITE) {
-		pd_block = pd_req->sector;
-		pd_count = pd_req->current_nr_sectors;
+		pd_block = blk_rq_pos(pd_req);
+		pd_count = blk_rq_cur_sectors(pd_req);
 		if (pd_block + pd_count > get_capacity(pd_req->rq_disk))
 			return Fail;
-		pd_run = pd_req->nr_sectors;
+		pd_run = blk_rq_sectors(pd_req);
 		pd_buf = pd_req->buffer;
 		pd_retries = 0;
 		if (pd_cmd == READ)
@@ -479,7 +479,7 @@ static int pd_next_buf(void)
 		return 0;
 	spin_lock_irqsave(&pd_lock, saved_flags);
 	__blk_end_request_cur(pd_req, 0);
-	pd_count = pd_req->current_nr_sectors;
+	pd_count = blk_rq_cur_sectors(pd_req);
 	pd_buf = pd_req->buffer;
 	spin_unlock_irqrestore(&pd_lock, saved_flags);
 	return 0;
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index 3871e35..e88c889 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -768,9 +768,9 @@ repeat:
 		return;
 
 	pf_current = pf_req->rq_disk->private_data;
-	pf_block = pf_req->sector;
-	pf_run = pf_req->nr_sectors;
-	pf_count = pf_req->current_nr_sectors;
+	pf_block = blk_rq_pos(pf_req);
+	pf_run = blk_rq_sectors(pf_req);
+	pf_count = blk_rq_cur_sectors(pf_req);
 
 	if (pf_block + pf_count > get_capacity(pf_req->rq_disk)) {
 		pf_end_request(-EIO);
@@ -810,7 +810,7 @@ static int pf_next_buf(void)
 		spin_unlock_irqrestore(&pf_spin_lock, saved_flags);
 		if (!pf_req)
 			return 1;
-		pf_count = pf_req->current_nr_sectors;
+		pf_count = blk_rq_cur_sectors(pf_req);
 		pf_buf = pf_req->buffer;
 	}
 	return 0;
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index c238867..8d58308 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -134,13 +134,12 @@ static int ps3disk_submit_request_sg(struct ps3_storage_device *dev,
 	rq_for_each_segment(bv, req, iter)
 		n++;
 	dev_dbg(&dev->sbd.core,
-		"%s:%u: %s req has %u bvecs for %lu sectors %lu hard sectors\n",
-		__func__, __LINE__, op, n, req->nr_sectors,
-		blk_rq_sectors(req));
+		"%s:%u: %s req has %u bvecs for %u sectors\n",
+		__func__, __LINE__, op, n, blk_rq_sectors(req));
 #endif
 
-	start_sector = req->sector * priv->blocking_factor;
-	sectors = req->nr_sectors * priv->blocking_factor;
+	start_sector = blk_rq_pos(req) * priv->blocking_factor;
+	sectors = blk_rq_sectors(req) * priv->blocking_factor;
 	dev_dbg(&dev->sbd.core, "%s:%u: %s %llu sectors starting at %llu\n",
 		__func__, __LINE__, op, sectors, start_sector);
 
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index f59887c..9f351bf 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -416,7 +416,7 @@ static int __send_request(struct request *req)
 		desc->slice = 0;
 	}
 	desc->status = ~0;
-	desc->offset = (req->sector << 9) / port->vdisk_block_size;
+	desc->offset = (blk_rq_pos(req) << 9) / port->vdisk_block_size;
 	desc->size = len;
 	desc->ncookies = err;
 
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 4248559..c1b9a4d 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -312,14 +312,14 @@ static void start_request(struct floppy_state *fs)
 	}
 	while (fs->state == idle && (req = elv_next_request(swim3_queue))) {
 #if 0
-		printk("do_fd_req: dev=%s cmd=%d sec=%ld nr_sec=%ld buf=%p\n",
+		printk("do_fd_req: dev=%s cmd=%d sec=%ld nr_sec=%u buf=%p\n",
 		       req->rq_disk->disk_name, req->cmd,
-		       (long)req->sector, req->nr_sectors, req->buffer);
-		printk("           errors=%d current_nr_sectors=%ld\n",
-		       req->errors, req->current_nr_sectors);
+		       (long)blk_rq_pos(req), blk_rq_sectors(req), req->buffer);
+		printk("           errors=%d current_nr_sectors=%u\n",
+		       req->errors, blk_rq_cur_sectors(req));
 #endif
 
-		if (req->sector >= fs->total_secs) {
+		if (blk_rq_pos(req) >= fs->total_secs) {
 			__blk_end_request_cur(req, -EIO);
 			continue;
 		}
@@ -337,13 +337,14 @@ static void start_request(struct floppy_state *fs)
 			}
 		}
 
-		/* Do not remove the cast. req->sector is now a sector_t and
-		 * can be 64 bits, but it will never go past 32 bits for this
-		 * driver anyway, so we can safely cast it down and not have
-		 * to do a 64/32 division
+		/* Do not remove the cast. blk_rq_pos(req) is now a
+		 * sector_t and can be 64 bits, but it will never go
+		 * past 32 bits for this driver anyway, so we can
+		 * safely cast it down and not have to do a 64/32
+		 * division
 		 */
-		fs->req_cyl = ((long)req->sector) / fs->secpercyl;
-		x = ((long)req->sector) % fs->secpercyl;
+		fs->req_cyl = ((long)blk_rq_pos(req)) / fs->secpercyl;
+		x = ((long)blk_rq_pos(req)) % fs->secpercyl;
 		fs->head = x / fs->secpertrack;
 		fs->req_sector = x % fs->secpertrack + 1;
 		fd_req = req;
@@ -420,7 +421,7 @@ static inline void setup_transfer(struct floppy_state *fs)
 	struct dbdma_cmd *cp = fs->dma_cmd;
 	struct dbdma_regs __iomem *dr = fs->dma;
 
-	if (fd_req->current_nr_sectors <= 0) {
+	if (blk_rq_cur_sectors(fd_req) <= 0) {
 		printk(KERN_ERR "swim3: transfer 0 sectors?\n");
 		return;
 	}
@@ -428,8 +429,8 @@ static inline void setup_transfer(struct floppy_state *fs)
 		n = 1;
 	else {
 		n = fs->secpertrack - fs->req_sector + 1;
-		if (n > fd_req->current_nr_sectors)
-			n = fd_req->current_nr_sectors;
+		if (n > blk_rq_cur_sectors(fd_req))
+			n = blk_rq_cur_sectors(fd_req);
 	}
 	fs->scount = n;
 	swim3_select(fs, fs->head? READ_DATA_1: READ_DATA_0);
@@ -600,7 +601,8 @@ static void xfer_timeout(unsigned long data)
 	out_8(&sw->control_bic, WRITE_SECTORS | DO_ACTION);
 	out_8(&sw->select, RELAX);
 	printk(KERN_ERR "swim3: timeout %sing sector %ld\n",
-	       (rq_data_dir(fd_req)==WRITE? "writ": "read"), (long)fd_req->sector);
+	       (rq_data_dir(fd_req)==WRITE? "writ": "read"),
+	       (long)blk_rq_pos(fd_req));
 	__blk_end_request_cur(fd_req, -EIO);
 	fs->state = idle;
 	start_request(fs);
@@ -714,7 +716,7 @@ static irqreturn_t swim3_interrupt(int irq, void *dev_id)
 			} else {
 				printk("swim3: error %sing block %ld (err=%x)\n",
 				       rq_data_dir(fd_req) == WRITE? "writ": "read",
-				       (long)fd_req->sector, err);
+				       (long)blk_rq_pos(fd_req), err);
 				__blk_end_request_cur(fd_req, -EIO);
 				fs->state = idle;
 			}
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index 60e85bb..087c94c 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -903,10 +903,10 @@ queue_one_request:
 	msg->sg_count	= n_elem;
 	msg->sg_type	= SGT_32BIT;
 	msg->handle	= cpu_to_le32(TAG_ENCODE(crq->tag));
-	msg->lba	= cpu_to_le32(rq->sector & 0xffffffff);
-	tmp		= (rq->sector >> 16) >> 16;
+	msg->lba	= cpu_to_le32(blk_rq_pos(rq) & 0xffffffff);
+	tmp		= (blk_rq_pos(rq) >> 16) >> 16;
 	msg->lba_high	= cpu_to_le16( (u16) tmp );
-	msg->lba_count	= cpu_to_le16(rq->nr_sectors);
+	msg->lba_count	= cpu_to_le16(blk_rq_sectors(rq));
 
 	msg_size = sizeof(struct carm_msg_rw) - sizeof(msg->sg);
 	for (i = 0; i < n_elem; i++) {
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 8c2cc71..dc3b899 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -726,8 +726,8 @@ static void ub_cmd_build_block(struct ub_dev *sc, struct ub_lun *lun,
 	 * The call to blk_queue_hardsect_size() guarantees that request
 	 * is aligned, but it is given in terms of 512 byte units, always.
 	 */
-	block = rq->sector >> lun->capacity.bshift;
-	nblks = rq->nr_sectors >> lun->capacity.bshift;
+	block = blk_rq_pos(rq) >> lun->capacity.bshift;
+	nblks = blk_rq_sectors(rq) >> lun->capacity.bshift;
 
 	cmd->cdb[0] = (cmd->dir == UB_DIR_READ)? READ_10: WRITE_10;
 	/* 10-byte uses 4 bytes of LBA: 2147483648KB, 2097152MB, 2048GB */
@@ -739,7 +739,7 @@ static void ub_cmd_build_block(struct ub_dev *sc, struct ub_lun *lun,
 	cmd->cdb[8] = nblks;
 	cmd->cdb_len = 10;
 
-	cmd->len = rq->nr_sectors * 512;
+	cmd->len = blk_rq_sectors(rq) * 512;
 }
 
 static void ub_cmd_build_packet(struct ub_dev *sc, struct ub_lun *lun,
diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
index e821eed..2086cb1 100644
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -252,7 +252,7 @@ static int send_request(struct request *req)
 	struct viodasd_device *d;
 	unsigned long flags;
 
-	start = (u64)req->sector << 9;
+	start = (u64)blk_rq_pos(req) << 9;
 
 	if (rq_data_dir(req) == READ) {
 		direction = DMA_FROM_DEVICE;
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 50745e6..1980ab4 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -85,7 +85,7 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 	vbr->req = req;
 	if (blk_fs_request(vbr->req)) {
 		vbr->out_hdr.type = 0;
-		vbr->out_hdr.sector = vbr->req->sector;
+		vbr->out_hdr.sector = blk_rq_pos(vbr->req);
 		vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
 	} else if (blk_pc_request(vbr->req)) {
 		vbr->out_hdr.type = VIRTIO_BLK_T_SCSI_CMD;
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 14be4c1..4ef8801 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -306,8 +306,8 @@ static void do_xd_request (struct request_queue * q)
 		return;
 
 	while ((req = elv_next_request(q)) != NULL) {
-		unsigned block = req->sector;
-		unsigned count = req->nr_sectors;
+		unsigned block = blk_rq_pos(req);
+		unsigned count = blk_rq_sectors(req);
 		XD_INFO *disk = req->rq_disk->private_data;
 		int res = 0;
 		int retry;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index b456447..91fc565 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -231,7 +231,7 @@ static int blkif_queue_request(struct request *req)
 	info->shadow[id].request = (unsigned long)req;
 
 	ring_req->id = id;
-	ring_req->sector_number = (blkif_sector_t)req->sector;
+	ring_req->sector_number = (blkif_sector_t)blk_rq_pos(req);
 	ring_req->handle = info->handle;
 
 	ring_req->operation = rq_data_dir(req) ?
@@ -310,11 +310,10 @@ static void do_blkif_request(struct request_queue *rq)
 			goto wait;
 
 		pr_debug("do_blk_req %p: cmd %p, sec %lx, "
-			 "(%u/%li) buffer:%p [%s]\n",
-			 req, req->cmd, (unsigned long)req->sector,
-			 req->current_nr_sectors,
-			 req->nr_sectors, req->buffer,
-			 rq_data_dir(req) ? "write" : "read");
+			 "(%u/%u) buffer:%p [%s]\n",
+			 req, req->cmd, (unsigned long)blk_rq_pos(req),
+			 blk_rq_cur_sectors(req), blk_rq_sectors(req),
+			 req->buffer, rq_data_dir(req) ? "write" : "read");
 
 
 		blkdev_dequeue_request(req);
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 5722931..97c99b4 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -646,13 +646,14 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		/* Okay, it's a data request, set it up for transfer */
 		dev_dbg(ace->dev,
 			"request: sec=%llx hcnt=%x, ccnt=%x, dir=%i\n",
-			(unsigned long long) req->sector, blk_rq_sectors(req),
-			req->current_nr_sectors, rq_data_dir(req));
+			(unsigned long long)blk_rq_pos(req),
+			blk_rq_sectors(req), blk_rq_cur_sectors(req),
+			rq_data_dir(req));
 
 		ace->req = req;
 		ace->data_ptr = req->buffer;
-		ace->data_count = req->current_nr_sectors * ACE_BUF_PER_SECTOR;
-		ace_out32(ace, ACE_MPULBA, req->sector & 0x0FFFFFFF);
+		ace->data_count = blk_rq_cur_sectors(req) * ACE_BUF_PER_SECTOR;
+		ace_out32(ace, ACE_MPULBA, blk_rq_pos(req) & 0x0FFFFFFF);
 
 		count = blk_rq_sectors(req);
 		if (rq_data_dir(req)) {
@@ -688,7 +689,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
 			dev_dbg(ace->dev,
 				"CFBSY set; t=%i iter=%i c=%i dc=%i irq=%i\n",
 				ace->fsm_task, ace->fsm_iter_num,
-				ace->req->current_nr_sectors * 16,
+				blk_rq_cur_sectors(ace->req) * 16,
 				ace->data_count, ace->in_irq);
 			ace_fsm_yield(ace);	/* need to poll CFBSY bit */
 			break;
@@ -697,7 +698,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
 			dev_dbg(ace->dev,
 				"DATABUF not set; t=%i iter=%i c=%i dc=%i irq=%i\n",
 				ace->fsm_task, ace->fsm_iter_num,
-				ace->req->current_nr_sectors * 16,
+				blk_rq_cur_sectors(ace->req) * 16,
 				ace->data_count, ace->in_irq);
 			ace_fsm_yieldirq(ace);
 			break;
@@ -721,10 +722,10 @@ static void ace_fsm_dostate(struct ace_device *ace)
 					blk_rq_cur_bytes(ace->req))) {
 			/* dev_dbg(ace->dev, "next block; h=%u c=%u\n",
 			 *      blk_rq_sectors(ace->req),
-			 *      ace->req->current_nr_sectors);
+			 *      blk_rq_cur_sectors(ace->req));
 			 */
 			ace->data_ptr = ace->req->buffer;
-			ace->data_count = ace->req->current_nr_sectors * 16;
+			ace->data_count = blk_rq_cur_sectors(ace->req) * 16;
 			ace_fsm_yieldirq(ace);
 			break;
 		}
diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index b66ad58..d4e6b71 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -71,12 +71,12 @@ static void do_z2_request(struct request_queue *q)
 {
 	struct request *req;
 	while ((req = elv_next_request(q)) != NULL) {
-		unsigned long start = req->sector << 9;
-		unsigned long len  = req->current_nr_sectors << 9;
+		unsigned long start = blk_rq_pos(req) << 9;
+		unsigned long len  = blk_rq_cur_sectors(req) << 9;
 
 		if (start + len > z2ram_size) {
 			printk( KERN_ERR DEVICE_NAME ": bad access: block=%lu, count=%u\n",
-				req->sector, req->current_nr_sectors);
+				blk_rq_pos(req), blk_rq_cur_sectors(req));
 			__blk_end_request_cur(req, -EIO);
 			continue;
 		}
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index cab2b1f..488423c 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -584,8 +584,8 @@ static void gdrom_readdisk_dma(struct work_struct *work)
 	list_for_each_safe(elem, next, &gdrom_deferred) {
 		req = list_entry(elem, struct request, queuelist);
 		spin_unlock(&gdrom_lock);
-		block = req->sector/GD_TO_BLK + GD_SESSION_OFFSET;
-		block_cnt = req->nr_sectors/GD_TO_BLK;
+		block = blk_rq_pos(req)/GD_TO_BLK + GD_SESSION_OFFSET;
+		block_cnt = blk_rq_sectors(req)/GD_TO_BLK;
 		ctrl_outl(PHYSADDR(req->buffer), GDROM_DMA_STARTADDR_REG);
 		ctrl_outl(block_cnt * GDROM_HARD_SECTOR, GDROM_DMA_LENGTH_REG);
 		ctrl_outl(1, GDROM_DMA_DIRECTION_REG);
@@ -661,7 +661,7 @@ static void gdrom_request(struct request_queue *rq)
 			printk(" write request ignored\n");
 			__blk_end_request_cur(req, -EIO);
 		}
-		if (req->nr_sectors)
+		if (blk_rq_sectors(req))
 			gdrom_request_handler_dma(req);
 		else
 			__blk_end_request_cur(req, -EIO);
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index cc3efa0..6e190a9 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -282,7 +282,7 @@ static int send_request(struct request *req)
 			viopath_targetinst(viopath_hostLp),
 			(u64)req, VIOVERSION << 16,
 			((u64)DEVICE_NR(diskinfo) << 48) | dmaaddr,
-			(u64)req->sector * 512, len, 0);
+			(u64)blk_rq_pos(req) * 512, len, 0);
 	if (hvrc != HvLpEvent_Rc_Good) {
 		printk(VIOCD_KERN_WARNING "hv error on op %d\n", (int)hvrc);
 		return -1;
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index a416346..9e600d2 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -677,10 +677,10 @@ try_again:
 			continue;
 		}
 
-		t_sec = msb->block_req->sector << 9;
+		t_sec = blk_rq_pos(msb->block_req) << 9;
 		sector_div(t_sec, msb->page_size);
 
-		count = msb->block_req->nr_sectors << 9;
+		count = blk_rq_sectors(msb->block_req) << 9;
 		count /= msb->page_size;
 
 		param.system = msb->system;
@@ -745,7 +745,7 @@ static int mspro_block_complete_req(struct memstick_dev *card, int error)
 					t_len *= msb->page_size;
 			}
 		} else
-			t_len = msb->block_req->nr_sectors << 9;
+			t_len = blk_rq_sectors(msb->block_req) << 9;
 
 		dev_dbg(&card->dev, "transferred %x (%d)\n", t_len, error);
 
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index 56e60f0..510eb47 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -761,7 +761,7 @@ static int i2o_block_transfer(struct request *req)
 			break;
 
 		case CACHE_SMARTFETCH:
-			if (req->nr_sectors > 16)
+			if (blk_rq_sectors(req) > 16)
 				ctl_flags = 0x201F0008;
 			else
 				ctl_flags = 0x001F0000;
@@ -781,13 +781,13 @@ static int i2o_block_transfer(struct request *req)
 			ctl_flags = 0x001F0010;
 			break;
 		case CACHE_SMARTBACK:
-			if (req->nr_sectors > 16)
+			if (blk_rq_sectors(req) > 16)
 				ctl_flags = 0x001F0004;
 			else
 				ctl_flags = 0x001F0010;
 			break;
 		case CACHE_SMARTTHROUGH:
-			if (req->nr_sectors > 16)
+			if (blk_rq_sectors(req) > 16)
 				ctl_flags = 0x001F0004;
 			else
 				ctl_flags = 0x001F0010;
@@ -827,22 +827,24 @@ static int i2o_block_transfer(struct request *req)
 
 		*mptr++ = cpu_to_le32(scsi_flags);
 
-		*((u32 *) & cmd[2]) = cpu_to_be32(req->sector * hwsec);
-		*((u16 *) & cmd[7]) = cpu_to_be16(req->nr_sectors * hwsec);
+		*((u32 *) & cmd[2]) = cpu_to_be32(blk_rq_pos(req) * hwsec);
+		*((u16 *) & cmd[7]) = cpu_to_be16(blk_rq_sectors(req) * hwsec);
 
 		memcpy(mptr, cmd, 10);
 		mptr += 4;
-		*mptr++ = cpu_to_le32(req->nr_sectors << KERNEL_SECTOR_SHIFT);
+		*mptr++ =
+		    cpu_to_le32(blk_rq_sectors(req) << KERNEL_SECTOR_SHIFT);
 	} else
 #endif
 	{
 		msg->u.head[1] = cpu_to_le32(cmd | HOST_TID << 12 | tid);
 		*mptr++ = cpu_to_le32(ctl_flags);
-		*mptr++ = cpu_to_le32(req->nr_sectors << KERNEL_SECTOR_SHIFT);
 		*mptr++ =
-		    cpu_to_le32((u32) (req->sector << KERNEL_SECTOR_SHIFT));
+		    cpu_to_le32(blk_rq_sectors(req) << KERNEL_SECTOR_SHIFT);
+		*mptr++ =
+		    cpu_to_le32((u32) (blk_rq_pos(req) << KERNEL_SECTOR_SHIFT));
 		*mptr++ =
-		    cpu_to_le32(req->sector >> (32 - KERNEL_SECTOR_SHIFT));
+		    cpu_to_le32(blk_rq_pos(req) >> (32 - KERNEL_SECTOR_SHIFT));
 	}
 
 	if (!i2o_block_sglist_alloc(c, ireq, &mptr)) {
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index fe8041e..949e997 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -243,7 +243,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		brq.mrq.cmd = &brq.cmd;
 		brq.mrq.data = &brq.data;
 
-		brq.cmd.arg = req->sector;
+		brq.cmd.arg = blk_rq_pos(req);
 		if (!mmc_card_blockaddr(card))
 			brq.cmd.arg <<= 9;
 		brq.cmd.flags = MMC_RSP_SPI_R1 | MMC_RSP_R1 | MMC_CMD_ADTC;
@@ -251,7 +251,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		brq.stop.opcode = MMC_STOP_TRANSMISSION;
 		brq.stop.arg = 0;
 		brq.stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
-		brq.data.blocks = req->nr_sectors;
+		brq.data.blocks = blk_rq_sectors(req);
 
 		/*
 		 * After a read error, we redo the request one sector at a time
@@ -293,7 +293,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 		 * Adjust the sg list so it is the same size as the
 		 * request.
 		 */
-		if (brq.data.blocks != req->nr_sectors) {
+		if (brq.data.blocks != blk_rq_sectors(req)) {
 			int i, data_size = brq.data.blocks << 9;
 			struct scatterlist *sg;
 
@@ -344,8 +344,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 			printk(KERN_ERR "%s: error %d transferring data,"
 			       " sector %u, nr %u, card status %#x\n",
 			       req->rq_disk->disk_name, brq.data.error,
-			       (unsigned)req->sector,
-			       (unsigned)req->nr_sectors, status);
+			       (unsigned)blk_rq_pos(req),
+			       (unsigned)blk_rq_sectors(req), status);
 		}
 
 		if (brq.stop.error) {
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 76c4c8d..4ea2e67 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -47,8 +47,8 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 	unsigned long block, nsect;
 	char *buf;
 
-	block = req->sector << 9 >> tr->blkshift;
-	nsect = req->current_nr_sectors << 9 >> tr->blkshift;
+	block = blk_rq_pos(req) << 9 >> tr->blkshift;
+	nsect = blk_rq_cur_sectors(req) << 9 >> tr->blkshift;
 
 	buf = req->buffer;
 
@@ -59,7 +59,8 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 	if (!blk_fs_request(req))
 		return -EIO;
 
-	if (req->sector + req->current_nr_sectors > get_capacity(req->rq_disk))
+	if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
+	    get_capacity(req->rq_disk))
 		return -EIO;
 
 	switch(rq_data_dir(req)) {
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index fabec95..7df03c7 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -603,7 +603,7 @@ static void dasd_profile_end(struct dasd_block *block,
 	if (dasd_profile_level != DASD_PROFILE_ON)
 		return;
 
-	sectors = req->nr_sectors;
+	sectors = blk_rq_sectors(req);
 	if (!cqr->buildclk || !cqr->startclk ||
 	    !cqr->stopclk || !cqr->endclk ||
 	    !sectors)
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index b9a7f77..2efaddf 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -505,8 +505,9 @@ static struct dasd_ccw_req *dasd_diag_build_cp(struct dasd_device *memdev,
 		return ERR_PTR(-EINVAL);
 	blksize = block->bp_block;
 	/* Calculate record id of first and last block. */
-	first_rec = req->sector >> block->s2b_shift;
-	last_rec = (req->sector + req->nr_sectors - 1) >> block->s2b_shift;
+	first_rec = blk_rq_pos(req) >> block->s2b_shift;
+	last_rec =
+		(blk_rq_pos(req) + blk_rq_sectors(req) - 1) >> block->s2b_shift;
 	/* Check struct bio and count the number of blocks for the request. */
 	count = 0;
 	rq_for_each_segment(bv, req, iter) {
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index cb52da0..a41c940 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2354,10 +2354,10 @@ static struct dasd_ccw_req *dasd_eckd_build_cp(struct dasd_device *startdev,
 	blksize = block->bp_block;
 	blk_per_trk = recs_per_track(&private->rdc_data, 0, blksize);
 	/* Calculate record id of first and last block. */
-	first_rec = first_trk = req->sector >> block->s2b_shift;
+	first_rec = first_trk = blk_rq_pos(req) >> block->s2b_shift;
 	first_offs = sector_div(first_trk, blk_per_trk);
 	last_rec = last_trk =
-		(req->sector + req->nr_sectors - 1) >> block->s2b_shift;
+		(blk_rq_pos(req) + blk_rq_sectors(req) - 1) >> block->s2b_shift;
 	last_offs = sector_div(last_trk, blk_per_trk);
 	cdlspecial = (private->uses_cdl && first_rec < 2*blk_per_trk);
 
@@ -2420,7 +2420,7 @@ dasd_eckd_free_cp(struct dasd_ccw_req *cqr, struct request *req)
 	private = (struct dasd_eckd_private *) cqr->block->base->private;
 	blksize = cqr->block->bp_block;
 	blk_per_trk = recs_per_track(&private->rdc_data, 0, blksize);
-	recid = req->sector >> cqr->block->s2b_shift;
+	recid = blk_rq_pos(req) >> cqr->block->s2b_shift;
 	ccw = cqr->cpaddr;
 	/* Skip over define extent & locate record. */
 	ccw++;
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index a3eb6fd..8912358 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -270,8 +270,9 @@ static struct dasd_ccw_req *dasd_fba_build_cp(struct dasd_device * memdev,
 		return ERR_PTR(-EINVAL);
 	blksize = block->bp_block;
 	/* Calculate record id of first and last block. */
-	first_rec = req->sector >> block->s2b_shift;
-	last_rec = (req->sector + req->nr_sectors - 1) >> block->s2b_shift;
+	first_rec = blk_rq_pos(req) >> block->s2b_shift;
+	last_rec =
+		(blk_rq_pos(req) + blk_rq_sectors(req) - 1) >> block->s2b_shift;
 	/* Check struct bio and count the number of blocks for the request. */
 	count = 0;
 	cidaw = 0;
@@ -309,7 +310,7 @@ static struct dasd_ccw_req *dasd_fba_build_cp(struct dasd_device * memdev,
 	ccw = cqr->cpaddr;
 	/* First ccw is define extent. */
 	define_extent(ccw++, cqr->data, rq_data_dir(req),
-		      block->bp_block, req->sector, req->nr_sectors);
+		      block->bp_block, blk_rq_pos(req), blk_rq_sectors(req));
 	/* Build locate_record + read/write ccws. */
 	idaws = (unsigned long *) (cqr->data + sizeof(struct DE_fba_data));
 	LO_data = (struct LO_fba_data *) (idaws + cidaw);
diff --git a/drivers/s390/char/tape_34xx.c b/drivers/s390/char/tape_34xx.c
index 5f8e8ef..2d00a38 100644
--- a/drivers/s390/char/tape_34xx.c
+++ b/drivers/s390/char/tape_34xx.c
@@ -1134,7 +1134,7 @@ tape_34xx_bread(struct tape_device *device, struct request *req)
 	/* Setup ccws. */
 	request->op = TO_BLOCK;
 	start_block = (struct tape_34xx_block_id *) request->cpdata;
-	start_block->block = req->sector >> TAPEBLOCK_HSEC_S2B;
+	start_block->block = blk_rq_pos(req) >> TAPEBLOCK_HSEC_S2B;
 	DBF_EVENT(6, "start_block = %i\n", start_block->block);
 
 	ccw = request->cpaddr;
diff --git a/drivers/s390/char/tape_3590.c b/drivers/s390/char/tape_3590.c
index 823b05b..c453b2f 100644
--- a/drivers/s390/char/tape_3590.c
+++ b/drivers/s390/char/tape_3590.c
@@ -633,7 +633,7 @@ tape_3590_bread(struct tape_device *device, struct request *req)
 	struct req_iterator iter;
 
 	DBF_EVENT(6, "xBREDid:");
-	start_block = req->sector >> TAPEBLOCK_HSEC_S2B;
+	start_block = blk_rq_pos(req) >> TAPEBLOCK_HSEC_S2B;
 	DBF_EVENT(6, "start_block = %i\n", start_block);
 
 	rq_for_each_segment(bv, req, iter)
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index 86596d3..5d035e4 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -87,7 +87,7 @@ __tapeblock_end_request(struct tape_request *ccw_req, void *data)
 	if (ccw_req->rc == 0)
 		/* Update position. */
 		device->blk_data.block_position =
-			(req->sector + req->nr_sectors) >> TAPEBLOCK_HSEC_S2B;
+		  (blk_rq_pos(req) + blk_rq_sectors(req)) >> TAPEBLOCK_HSEC_S2B;
 	else
 		/* We lost the position information due to an error. */
 		device->blk_data.block_position = -1;
diff --git a/drivers/sbus/char/jsflash.c b/drivers/sbus/char/jsflash.c
index 0961788..2132c90 100644
--- a/drivers/sbus/char/jsflash.c
+++ b/drivers/sbus/char/jsflash.c
@@ -188,8 +188,8 @@ static void jsfd_do_request(struct request_queue *q)
 
 	while ((req = elv_next_request(q)) != NULL) {
 		struct jsfd_part *jdp = req->rq_disk->private_data;
-		unsigned long offset = req->sector << 9;
-		size_t len = req->current_nr_sectors << 9;
+		unsigned long offset = blk_rq_pos(req) << 9;
+		size_t len = blk_rq_cur_sectors(req) << 9;
 
 		if ((offset + len) > jdp->dsize) {
 			__blk_end_request_cur(req, -EIO);
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index be5099d..c7076ce 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1825,7 +1825,7 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 	if (linked_comm && SCpnt->device->queue_depth > 2
 	    && TLDEV(SCpnt->device->type)) {
 		ha->cp_stat[i] = READY;
-		flush_dev(SCpnt->device, SCpnt->request->sector, ha, 0);
+		flush_dev(SCpnt->device, blk_rq_pos(SCpnt->request), ha, 0);
 		return 0;
 	}
 
@@ -2144,13 +2144,13 @@ static int reorder(struct hostdata *ha, unsigned long cursec,
 		if (!cpp->din)
 			input_only = 0;
 
-		if (SCpnt->request->sector < minsec)
-			minsec = SCpnt->request->sector;
-		if (SCpnt->request->sector > maxsec)
-			maxsec = SCpnt->request->sector;
+		if (blk_rq_pos(SCpnt->request) < minsec)
+			minsec = blk_rq_pos(SCpnt->request);
+		if (blk_rq_pos(SCpnt->request) > maxsec)
+			maxsec = blk_rq_pos(SCpnt->request);
 
-		sl[n] = SCpnt->request->sector;
-		ioseek += SCpnt->request->nr_sectors;
+		sl[n] = blk_rq_pos(SCpnt->request);
+		ioseek += blk_rq_sectors(SCpnt->request);
 
 		if (!n)
 			continue;
@@ -2190,7 +2190,7 @@ static int reorder(struct hostdata *ha, unsigned long cursec,
 			k = il[n];
 			cpp = &ha->cp[k];
 			SCpnt = cpp->SCpnt;
-			ll[n] = SCpnt->request->nr_sectors;
+			ll[n] = blk_rq_sectors(SCpnt->request);
 			pl[n] = SCpnt->serial_number;
 
 			if (!n)
@@ -2236,12 +2236,12 @@ static int reorder(struct hostdata *ha, unsigned long cursec,
 			cpp = &ha->cp[k];
 			SCpnt = cpp->SCpnt;
 			scmd_printk(KERN_INFO, SCpnt,
-			    "%s pid %ld mb %d fc %d nr %d sec %ld ns %ld"
+			    "%s pid %ld mb %d fc %d nr %d sec %ld ns %u"
 			     " cur %ld s:%c r:%c rev:%c in:%c ov:%c xd %d.\n",
 			     (ihdlr ? "ihdlr" : "qcomm"),
 			     SCpnt->serial_number, k, flushcount,
-			     n_ready, SCpnt->request->sector,
-			     SCpnt->request->nr_sectors, cursec, YESNO(s),
+			     n_ready, blk_rq_pos(SCpnt->request),
+			     blk_rq_sectors(SCpnt->request), cursec, YESNO(s),
 			     YESNO(r), YESNO(rev), YESNO(input_only),
 			     YESNO(overlap), cpp->din);
 		}
@@ -2408,7 +2408,7 @@ static irqreturn_t ihdlr(struct Scsi_Host *shost)
 
 	if (linked_comm && SCpnt->device->queue_depth > 2
 	    && TLDEV(SCpnt->device->type))
-		flush_dev(SCpnt->device, SCpnt->request->sector, ha, 1);
+		flush_dev(SCpnt->device, blk_rq_pos(SCpnt->request), ha, 1);
 
 	tstatus = status_byte(spp->target_status);
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 36fd2e7..a8fab39 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1313,10 +1313,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd,
 	uint32_t bgstat = bgf->bgstat;
 	uint64_t failing_sector = 0;
 
-	printk(KERN_ERR "BG ERROR in cmd 0x%x lba 0x%llx blk cnt 0x%lx "
+	printk(KERN_ERR "BG ERROR in cmd 0x%x lba 0x%llx blk cnt 0x%x "
 			"bgstat=0x%x bghm=0x%x\n",
 			cmd->cmnd[0], (unsigned long long)scsi_get_lba(cmd),
-			cmd->request->nr_sectors, bgstat, bghm);
+			blk_rq_sectors(cmd->request), bgstat, bghm);
 
 	spin_lock(&_dump_buf_lock);
 	if (!_dump_buf_done) {
@@ -2375,15 +2375,15 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		if (cmnd->cmnd[0] == READ_10)
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 					"9035 BLKGRD: READ @ sector %llu, "
-					 "count %lu\n",
-					 (unsigned long long)scsi_get_lba(cmnd),
-					cmnd->request->nr_sectors);
+					"count %u\n",
+					(unsigned long long)scsi_get_lba(cmnd),
+					blk_rq_sectors(cmnd->request));
 		else if (cmnd->cmnd[0] == WRITE_10)
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 					"9036 BLKGRD: WRITE @ sector %llu, "
-					"count %lu cmd=%p\n",
+					"count %u cmd=%p\n",
 					(unsigned long long)scsi_get_lba(cmnd),
-					cmnd->request->nr_sectors,
+					blk_rq_sectors(cmnd->request),
 					cmnd);
 
 		err = lpfc_bg_scsi_prep_dma_buf(phba, lpfc_cmd);
@@ -2403,15 +2403,15 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		if (cmnd->cmnd[0] == READ_10)
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 					 "9040 dbg: READ @ sector %llu, "
-					 "count %lu\n",
+					 "count %u\n",
 					 (unsigned long long)scsi_get_lba(cmnd),
-					 cmnd->request->nr_sectors);
+					 blk_rq_sectors(cmnd->request));
 		else if (cmnd->cmnd[0] == WRITE_10)
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 					 "9041 dbg: WRITE @ sector %llu, "
-					 "count %lu cmd=%p\n",
+					 "count %u cmd=%p\n",
 					 (unsigned long long)scsi_get_lba(cmnd),
-					 cmnd->request->nr_sectors, cmnd);
+					 blk_rq_sectors(cmnd->request), cmnd);
 		else
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 					 "9042 dbg: parser not implemented\n");
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ff0ca9..39b3acf 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -787,9 +787,9 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 * Next deal with any sectors which we were able to correctly
 	 * handle.
 	 */
-	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
+	SCSI_LOG_HLCOMPLETE(1, printk("%u sectors total, "
 				      "%d bytes done.\n",
-				      req->nr_sectors, good_bytes));
+				      blk_rq_sectors(req), good_bytes));
 
 	/*
 	 * Recovered errors need reporting, but they're always treated
@@ -968,7 +968,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
 	if (blk_pc_request(req))
 		sdb->length = req->data_len;
 	else
-		sdb->length = req->nr_sectors << 9;
+		sdb->length = blk_rq_sectors(req) << 9;
 	return BLKPREP_OK;
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3fcb64b..70c4dd9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -383,9 +383,9 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	struct scsi_device *sdp = q->queuedata;
 	struct gendisk *disk = rq->rq_disk;
 	struct scsi_disk *sdkp;
-	sector_t block = rq->sector;
+	sector_t block = blk_rq_pos(rq);
 	sector_t threshold;
-	unsigned int this_count = rq->nr_sectors;
+	unsigned int this_count = blk_rq_sectors(rq);
 	int ret, host_dif;
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
@@ -412,10 +412,10 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 					this_count));
 
 	if (!sdp || !scsi_device_online(sdp) ||
- 	    block + rq->nr_sectors > get_capacity(disk)) {
+	    block + blk_rq_sectors(rq) > get_capacity(disk)) {
 		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
-						"Finishing %ld sectors\n",
-						rq->nr_sectors));
+						"Finishing %u sectors\n",
+						blk_rq_sectors(rq)));
 		SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
 						"Retry with 0x%p\n", SCpnt));
 		goto out;
@@ -462,7 +462,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	 * for this.
 	 */
 	if (sdp->sector_size == 1024) {
-		if ((block & 1) || (rq->nr_sectors & 1)) {
+		if ((block & 1) || (blk_rq_sectors(rq) & 1)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				    "Bad block number requested\n");
 			goto out;
@@ -472,7 +472,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		}
 	}
 	if (sdp->sector_size == 2048) {
-		if ((block & 3) || (rq->nr_sectors & 3)) {
+		if ((block & 3) || (blk_rq_sectors(rq) & 3)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				    "Bad block number requested\n");
 			goto out;
@@ -482,7 +482,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		}
 	}
 	if (sdp->sector_size == 4096) {
-		if ((block & 7) || (rq->nr_sectors & 7)) {
+		if ((block & 7) || (blk_rq_sectors(rq) & 7)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				    "Bad block number requested\n");
 			goto out;
@@ -511,10 +511,10 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	}
 
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
-					"%s %d/%ld 512 byte blocks.\n",
+					"%s %d/%u 512 byte blocks.\n",
 					(rq_data_dir(rq) == WRITE) ?
 					"writing" : "reading", this_count,
-					rq->nr_sectors));
+					blk_rq_sectors(rq)));
 
 	/* Set RDPROTECT/WRPROTECT if disk is formatted with DIF */
 	host_dif = scsi_host_dif_capable(sdp->host, sdkp->protection_type);
@@ -970,8 +970,8 @@ static struct block_device_operations sd_fops = {
 
 static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 {
-	u64 start_lba = scmd->request->sector;
-	u64 end_lba = scmd->request->sector + (scsi_bufflen(scmd) / 512);
+	u64 start_lba = blk_rq_pos(scmd->request);
+	u64 end_lba = blk_rq_pos(scmd->request) + (scsi_bufflen(scmd) / 512);
 	u64 bad_lba;
 	int info_valid;
 
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 184dff4..82f14a9 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -507,7 +507,7 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 	sector_sz = scmd->device->sector_size;
 	sectors = good_bytes / sector_sz;
 
-	phys = scmd->request->sector & 0xffffffff;
+	phys = blk_rq_pos(scmd->request) & 0xffffffff;
 	if (sector_sz == 4096)
 		phys >>= 3;
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0e1a0f2..fddba53 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -292,7 +292,8 @@ static int sr_done(struct scsi_cmnd *SCpnt)
 			if (cd->device->sector_size == 2048)
 				error_sector <<= 2;
 			error_sector &= ~(block_sectors - 1);
-			good_bytes = (error_sector - SCpnt->request->sector) << 9;
+			good_bytes = (error_sector -
+				      blk_rq_pos(SCpnt->request)) << 9;
 			if (good_bytes < 0 || good_bytes >= this_count)
 				good_bytes = 0;
 			/*
@@ -349,8 +350,8 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 				cd->disk->disk_name, block));
 
 	if (!cd->device || !scsi_device_online(cd->device)) {
-		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n",
-					rq->nr_sectors));
+		SCSI_LOG_HLQUEUE(2, printk("Finishing %u sectors\n",
+					   blk_rq_sectors(rq)));
 		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
 		goto out;
 	}
@@ -413,7 +414,7 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 	/*
 	 * request doesn't start on hw block boundary, add scatter pads
 	 */
-	if (((unsigned int)rq->sector % (s_size >> 9)) ||
+	if (((unsigned int)blk_rq_pos(rq) % (s_size >> 9)) ||
 	    (scsi_bufflen(SCpnt) % s_size)) {
 		scmd_printk(KERN_NOTICE, SCpnt, "unaligned transfer\n");
 		goto out;
@@ -422,14 +423,14 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 	this_count = (scsi_bufflen(SCpnt) >> 9) / (s_size >> 9);
 
 
-	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n",
+	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%u 512 byte blocks.\n",
 				cd->cdi.name,
 				(rq_data_dir(rq) == WRITE) ?
 					"writing" : "reading",
-				this_count, rq->nr_sectors));
+				this_count, blk_rq_sectors(rq)));
 
 	SCpnt->cmnd[1] = 0;
-	block = (unsigned int)rq->sector / (s_size >> 9);
+	block = (unsigned int)blk_rq_pos(rq) / (s_size >> 9);
 
 	if (this_count > 0xffff) {
 		this_count = 0xffff;
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 601e951..54023d4 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1306,7 +1306,7 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
    if (linked_comm && SCpnt->device->queue_depth > 2
                                      && TLDEV(SCpnt->device->type)) {
       HD(j)->cp_stat[i] = READY;
-      flush_dev(SCpnt->device, SCpnt->request->sector, j, FALSE);
+      flush_dev(SCpnt->device, blk_rq_pos(SCpnt->request), j, FALSE);
       return 0;
       }
 
@@ -1610,11 +1610,13 @@ static int reorder(unsigned int j, unsigned long cursec,
 
       if (!(cpp->xdir == DTD_IN)) input_only = FALSE;
 
-      if (SCpnt->request->sector < minsec) minsec = SCpnt->request->sector;
-      if (SCpnt->request->sector > maxsec) maxsec = SCpnt->request->sector;
+      if (blk_rq_pos(SCpnt->request) < minsec)
+	 minsec = blk_rq_pos(SCpnt->request);
+      if (blk_rq_pos(SCpnt->request) > maxsec)
+	 maxsec = blk_rq_pos(SCpnt->request);
 
-      sl[n] = SCpnt->request->sector;
-      ioseek += SCpnt->request->nr_sectors;
+      sl[n] = blk_rq_pos(SCpnt->request);
+      ioseek += blk_rq_sectors(SCpnt->request);
 
       if (!n) continue;
 
@@ -1642,7 +1644,7 @@ static int reorder(unsigned int j, unsigned long cursec,
 
    if (!input_only) for (n = 0; n < n_ready; n++) {
       k = il[n]; cpp = &HD(j)->cp[k]; SCpnt = cpp->SCpnt;
-      ll[n] = SCpnt->request->nr_sectors; pl[n] = SCpnt->serial_number;
+      ll[n] = blk_rq_sectors(SCpnt->request); pl[n] = SCpnt->serial_number;
 
       if (!n) continue;
 
@@ -1666,12 +1668,12 @@ static int reorder(unsigned int j, unsigned long cursec,
    if (link_statistics && (overlap || !(flushcount % link_statistics)))
       for (n = 0; n < n_ready; n++) {
          k = il[n]; cpp = &HD(j)->cp[k]; SCpnt = cpp->SCpnt;
-         printk("%s %d.%d:%d pid %ld mb %d fc %d nr %d sec %ld ns %ld"\
+         printk("%s %d.%d:%d pid %ld mb %d fc %d nr %d sec %ld ns %u"\
                 " cur %ld s:%c r:%c rev:%c in:%c ov:%c xd %d.\n",
                 (ihdlr ? "ihdlr" : "qcomm"), SCpnt->channel, SCpnt->target,
                 SCpnt->lun, SCpnt->serial_number, k, flushcount, n_ready,
-                SCpnt->request->sector, SCpnt->request->nr_sectors, cursec,
-                YESNO(s), YESNO(r), YESNO(rev), YESNO(input_only),
+                blk_rq_pos(SCpnt->request), blk_rq_sectors(SCpnt->request),
+		cursec, YESNO(s), YESNO(r), YESNO(rev), YESNO(input_only),
                 YESNO(overlap), cpp->xdir);
          }
 #endif
@@ -1799,7 +1801,7 @@ static irqreturn_t ihdlr(unsigned int j)
 
    if (linked_comm && SCpnt->device->queue_depth > 2
                                      && TLDEV(SCpnt->device->type))
-      flush_dev(SCpnt->device, SCpnt->request->sector, j, TRUE);
+      flush_dev(SCpnt->device, blk_rq_pos(SCpnt->request), j, TRUE);
 
    tstatus = status_byte(spp->target_status);
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 43b50d3..3878d1d 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -270,7 +270,7 @@ static inline unsigned char scsi_get_prot_type(struct scsi_cmnd *scmd)
 
 static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 {
-	return scmd->request->sector;
+	return blk_rq_pos(scmd->request);
 }
 
 static inline unsigned scsi_prot_sg_count(struct scsi_cmnd *cmd)
-- 
1.6.0.2

