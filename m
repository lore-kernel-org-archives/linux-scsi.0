From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Wed, 25 May 2005 11:29:52 +0200
Message-ID: <20050525092952.GA7005@suse.de>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524075953.GY9855@suse.de> <4292E3EE.10006@pobox.com> <20050524085133.GZ9855@suse.de> <42935852.2020300@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:45778 "EHLO
	nelson.home.kernel.dk") by vger.kernel.org with ESMTP
	id S261933AbVEYJ25 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 05:28:57 -0400
Content-Disposition: inline
In-Reply-To: <42935852.2020300@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Tue, May 24 2005, Jeff Garzik wrote:
> Jens Axboe wrote:
> >I agree, it's a cleaner approach, with the rq being a container for
> >generel messages as well not just SCSI commands. The one missing piece
> >for that was the rq->end_io() callback so everything doesn't have to go
> >down sync, but that is in now as well.
> >
> >I'll try and cook something up.
> 
> Very cool ;)

This is the base for it. It splits request->flags into two variables:

- cmd_type. this is not a bitmask, but a value indicating what type of
  request this is.

- cmd_flags. various command modified flags.

The idea is to add a REQ_TYPE_LINUX_BLOCK request type, where we define
a set of command opcodes that signify an upper level defined function
(such as flush) that is implemented differently at the hardware/driver
level. Basically a way to pass down messages or commands generically.

I like this better than using scsi opcodes always, it's a cleaner
abstraction. For sending generic commands to a device, we could add a
function ala:

blk_send_message(queue, unsigned char cmd, completion_callback);

that would allocate the request, set it up, add to block layer queue,
and call the completion_callback when it is done. So for a flush, a
driver could do

        blk_send_message(q, REQ_LB_OP_FLUSH, flush_done);

to a target queue.

What do you think?

Index: drivers/block/as-iosched.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/block/as-iosched.c  (mode:100644)
+++ uncommitted/drivers/block/as-iosched.c  (mode:100644)
@@ -1476,7 +1476,7 @@
 		}
 	} else
 		WARN_ON(blk_fs_request(rq)
-			&& (!(rq->flags & (REQ_HARDBARRIER|REQ_SOFTBARRIER))) );
+			&& (!(rq->cmd_flags & (REQ_HARDBARRIER|REQ_SOFTBARRIER))) );
 
 	/* Stop anticipating - let this request get through */
 	as_antic_stop(ad);
@@ -1522,7 +1522,7 @@
 	}
 
 	/* barriers must flush the reorder queue */
-	if (unlikely(rq->flags & (REQ_SOFTBARRIER | REQ_HARDBARRIER)
+	if (unlikely(rq->cmd_flags & (REQ_SOFTBARRIER | REQ_HARDBARRIER)
 			&& where == ELEVATOR_INSERT_SORT)) {
 		WARN_ON(1);
 		where = ELEVATOR_INSERT_BACK;
Index: drivers/block/deadline-iosched.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/block/deadline-iosched.c  (mode:100644)
+++ uncommitted/drivers/block/deadline-iosched.c  (mode:100644)
@@ -628,7 +628,7 @@
 	struct deadline_data *dd = q->elevator->elevator_data;
 
 	/* barriers must flush the reorder queue */
-	if (unlikely(rq->flags & (REQ_SOFTBARRIER | REQ_HARDBARRIER)
+	if (unlikely(rq->cmd_flags & (REQ_SOFTBARRIER | REQ_HARDBARRIER)
 			&& where == ELEVATOR_INSERT_SORT))
 		where = ELEVATOR_INSERT_BACK;
 
Index: drivers/block/elevator.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/block/elevator.c  (mode:100644)
+++ uncommitted/drivers/block/elevator.c  (mode:100644)
@@ -272,7 +272,7 @@
 	if (blk_account_rq(rq))
 		q->in_flight--;
 
-	rq->flags &= ~REQ_STARTED;
+	rq->cmd_flags &= ~REQ_STARTED;
 
 	if (e->ops->elevator_deactivate_req_fn)
 		e->ops->elevator_deactivate_req_fn(q, rq);
@@ -285,7 +285,7 @@
 	/*
 	 * if this is the flush, requeue the original instead and drop the flush
 	 */
-	if (rq->flags & REQ_BAR_FLUSH) {
+	if (rq->cmd_type == REQ_TYPE_FLUSH) {
 		clear_bit(QUEUE_FLAG_FLUSH, &q->queue_flags);
 		rq = rq->end_io_data;
 	}
@@ -306,7 +306,7 @@
 	/*
 	 * barriers implicitly indicate back insertion
 	 */
-	if (rq->flags & (REQ_SOFTBARRIER | REQ_HARDBARRIER) &&
+	if (rq->cmd_flags & (REQ_SOFTBARRIER | REQ_HARDBARRIER) &&
 	    where == ELEVATOR_INSERT_SORT)
 		where = ELEVATOR_INSERT_BACK;
 
@@ -374,12 +374,12 @@
 		 * that has been delayed should not be passed by new incoming
 		 * requests
 		 */
-		rq->flags |= REQ_STARTED;
+		rq->cmd_flags |= REQ_STARTED;
 
 		if (rq == q->last_merge)
 			q->last_merge = NULL;
 
-		if ((rq->flags & REQ_DONTPREP) || !q->prep_rq_fn)
+		if ((rq->cmd_flags & REQ_DONTPREP) || !q->prep_rq_fn)
 			break;
 
 		ret = q->prep_rq_fn(q, rq);
@@ -395,7 +395,7 @@
 				nr_bytes = rq->data_len;
 
 			blkdev_dequeue_request(rq);
-			rq->flags |= REQ_QUIET;
+			rq->cmd_flags |= REQ_QUIET;
 			end_that_request_chunk(rq, 0, nr_bytes);
 			end_that_request_last(rq);
 		} else {
Index: drivers/block/floppy.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/block/floppy.c  (mode:100644)
+++ uncommitted/drivers/block/floppy.c  (mode:100644)
@@ -3001,8 +3001,8 @@
 	if (usage_count == 0) {
 		printk("warning: usage count=0, current_req=%p exiting\n",
 		       current_req);
-		printk("sect=%ld flags=%lx\n", (long)current_req->sector,
-		       current_req->flags);
+		printk("sect=%ld type=%x flags=%x\n", (long)current_req->sector,
+		       current_req->cmd_type, current_req->cmd_flags);
 		return;
 	}
 	if (test_bit(0, &fdc_busy)) {
Index: drivers/block/ll_rw_blk.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/block/ll_rw_blk.c  (mode:100644)
+++ uncommitted/drivers/block/ll_rw_blk.c  (mode:100644)
@@ -349,7 +349,7 @@
 	struct request *rq = flush_rq->end_io_data;
 	request_queue_t *q = rq->q;
 
-	rq->flags |= REQ_BAR_PREFLUSH;
+	rq->cmd_flags |= REQ_BAR_PREFLUSH;
 
 	if (!flush_rq->errors)
 		elv_requeue_request(q, rq);
@@ -365,7 +365,7 @@
 	struct request *rq = flush_rq->end_io_data;
 	request_queue_t *q = rq->q;
 
-	rq->flags |= REQ_BAR_POSTFLUSH;
+	rq->cmd_flags |= REQ_BAR_POSTFLUSH;
 
 	q->end_flush_fn(q, flush_rq);
 	clear_bit(QUEUE_FLAG_FLUSH, &q->queue_flags);
@@ -383,7 +383,7 @@
 
 	rq_init(q, flush_rq);
 	flush_rq->elevator_private = NULL;
-	flush_rq->flags = REQ_BAR_FLUSH;
+	flush_rq->cmd_type = REQ_TYPE_FLUSH;
 	flush_rq->rq_disk = rq->rq_disk;
 	flush_rq->rl = NULL;
 
@@ -392,7 +392,7 @@
 	 * pre and post flush as done in that case
 	 */
 	if (!q->prepare_flush_fn(q, flush_rq)) {
-		rq->flags |= REQ_BAR_PREFLUSH | REQ_BAR_POSTFLUSH;
+		rq->cmd_flags |= REQ_BAR_PREFLUSH | REQ_BAR_POSTFLUSH;
 		clear_bit(QUEUE_FLAG_FLUSH, &q->queue_flags);
 		return rq;
 	}
@@ -421,7 +421,7 @@
 
 	rq_init(q, flush_rq);
 	flush_rq->elevator_private = NULL;
-	flush_rq->flags = REQ_BAR_FLUSH;
+	flush_rq->cmd_type = REQ_TYPE_FLUSH;
 	flush_rq->rq_disk = rq->rq_disk;
 	flush_rq->rl = NULL;
 
@@ -934,7 +934,7 @@
 	}
 
 	list_del_init(&rq->queuelist);
-	rq->flags &= ~REQ_QUEUED;
+	rq->cmd_flags &= ~REQ_QUEUED;
 	rq->tag = -1;
 
 	if (unlikely(bqt->tag_index[tag] == NULL))
@@ -970,7 +970,7 @@
 	unsigned long *map = bqt->tag_map;
 	int tag = 0;
 
-	if (unlikely((rq->flags & REQ_QUEUED))) {
+	if (unlikely((rq->cmd_flags & REQ_QUEUED))) {
 		printk(KERN_ERR 
 		       "request %p for device [%s] already tagged %d",
 		       rq, rq->rq_disk ? rq->rq_disk->disk_name : "?", rq->tag);
@@ -987,7 +987,7 @@
 	tag += ffz(*map);
 	__set_bit(tag, bqt->tag_map);
 
-	rq->flags |= REQ_QUEUED;
+	rq->cmd_flags |= REQ_QUEUED;
 	rq->tag = tag;
 	bqt->tag_index[tag] = rq;
 	blkdev_dequeue_request(rq);
@@ -1022,61 +1022,31 @@
 		if (rq->tag == -1) {
 			printk("bad tag found on list\n");
 			list_del_init(&rq->queuelist);
-			rq->flags &= ~REQ_QUEUED;
+			rq->cmd_flags &= ~REQ_QUEUED;
 		} else
 			blk_queue_end_tag(q, rq);
 
-		rq->flags &= ~REQ_STARTED;
+		rq->cmd_flags &= ~REQ_STARTED;
 		__elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 0);
 	}
 }
 
 EXPORT_SYMBOL(blk_queue_invalidate_tags);
 
-static char *rq_flags[] = {
-	"REQ_RW",
-	"REQ_FAILFAST",
-	"REQ_SOFTBARRIER",
-	"REQ_HARDBARRIER",
-	"REQ_CMD",
-	"REQ_NOMERGE",
-	"REQ_STARTED",
-	"REQ_DONTPREP",
-	"REQ_QUEUED",
-	"REQ_PC",
-	"REQ_BLOCK_PC",
-	"REQ_SENSE",
-	"REQ_FAILED",
-	"REQ_QUIET",
-	"REQ_SPECIAL",
-	"REQ_DRIVE_CMD",
-	"REQ_DRIVE_TASK",
-	"REQ_DRIVE_TASKFILE",
-	"REQ_PREEMPT",
-	"REQ_PM_SUSPEND",
-	"REQ_PM_RESUME",
-	"REQ_PM_SHUTDOWN",
-};
-
 void blk_dump_rq_flags(struct request *rq, char *msg)
 {
 	int bit;
 
-	printk("%s: dev %s: flags = ", msg,
-		rq->rq_disk ? rq->rq_disk->disk_name : "?");
-	bit = 0;
-	do {
-		if (rq->flags & (1 << bit))
-			printk("%s ", rq_flags[bit]);
-		bit++;
-	} while (bit < __REQ_NR_BITS);
+	printk("%s: dev %s: type=%x, flags=%x\n", msg,
+		rq->rq_disk ? rq->rq_disk->disk_name : "?", rq->cmd_type,
+		rq->cmd_flags);
 
 	printk("\nsector %llu, nr/cnr %lu/%u\n", (unsigned long long)rq->sector,
 						       rq->nr_sectors,
 						       rq->current_nr_sectors);
 	printk("bio %p, biotail %p, buffer %p, data %p, len %u\n", rq->bio, rq->biotail, rq->buffer, rq->data, rq->data_len);
 
-	if (rq->flags & (REQ_BLOCK_PC | REQ_PC)) {
+	if (blk_pc_request(rq)) {
 		printk("cdb: ");
 		for (bit = 0; bit < sizeof(rq->cmd); bit++)
 			printk("%02x ", rq->cmd[bit]);
@@ -1253,7 +1223,7 @@
 	int nr_phys_segs = bio_phys_segments(q, bio);
 
 	if (req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
-		req->flags |= REQ_NOMERGE;
+		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
 		return 0;
@@ -1276,7 +1246,7 @@
 
 	if (req->nr_hw_segments + nr_hw_segs > q->max_hw_segments
 	    || req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
-		req->flags |= REQ_NOMERGE;
+		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
 		return 0;
@@ -1297,7 +1267,7 @@
 	int len;
 
 	if (req->nr_sectors + bio_sectors(bio) > q->max_sectors) {
-		req->flags |= REQ_NOMERGE;
+		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
 		return 0;
@@ -1329,7 +1299,7 @@
 	int len;
 
 	if (req->nr_sectors + bio_sectors(bio) > q->max_sectors) {
-		req->flags |= REQ_NOMERGE;
+		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
 		return 0;
@@ -1784,10 +1754,10 @@
 		return NULL;
 
 	/*
-	 * first three bits are identical in rq->flags and bio->bi_rw,
+	 * first three bits are identical in rq->cmd_flags and bio->bi_rw,
 	 * see bio.h and blkdev.h
 	 */
-	rq->flags = rw;
+	rq->cmd_flags = rw;
 
 	if (!elv_set_request(q, rq, gfp_mask))
 		return rq;
@@ -2044,8 +2014,8 @@
  *    Many block devices need to execute commands asynchronously, so they don't
  *    block the whole kernel from preemption during request execution.  This is
  *    accomplished normally by inserting aritficial requests tagged as
- *    REQ_SPECIAL in to the corresponding request queue, and letting them be
- *    scheduled for actual execution by the request queue.
+ *    REQ_TYPE_SPECIAL in to the corresponding request queue, and letting them
+ *    be scheduled for actual execution by the request queue.
  *
  *    We have the option of inserting the head or the tail of the queue.
  *    Typically we use the tail for new ioctls and so forth.  We use the head
@@ -2062,7 +2032,8 @@
 	 * must not attempt merges on this) and that it acts as a soft
 	 * barrier
 	 */
-	rq->flags |= REQ_SPECIAL | REQ_SOFTBARRIER;
+	rq->cmd_type = REQ_TYPE_SPECIAL;
+	rq->cmd_flags |= REQ_SOFTBARRIER;
 
 	rq->special = data;
 
@@ -2215,7 +2186,7 @@
 		rq->sense_len = 0;
 	}
 
-	rq->flags |= REQ_NOMERGE;
+	rq->cmd_flags |= REQ_NOMERGE;
 	rq->waiting = &wait;
 	rq->end_io = blk_end_sync_rq;
 	elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 1);
@@ -2277,7 +2248,8 @@
 	struct request *rq = blk_get_request(q, WRITE, __GFP_WAIT);
 	int ret;
 
-	rq->flags |= REQ_BLOCK_PC | REQ_SOFTBARRIER;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_flags |= REQ_SOFTBARRIER;
 	rq->sector = 0;
 	memset(rq->cmd, 0, sizeof(rq->cmd));
 	rq->cmd[0] = 0x35;
@@ -2679,19 +2651,19 @@
 		goto again;
 	}
 
-	req->flags |= REQ_CMD;
+	req->cmd_type = REQ_TYPE_FS;
 
 	/*
 	 * inherit FAILFAST from bio (for read-ahead, and explicit FAILFAST)
 	 */
 	if (bio_rw_ahead(bio) || bio_failfast(bio))
-		req->flags |= REQ_FAILFAST;
+		req->cmd_flags |= REQ_FAILFAST;
 
 	/*
 	 * REQ_BARRIER implies no merging, but lets make it explicit
 	 */
 	if (barrier)
-		req->flags |= (REQ_HARDBARRIER | REQ_NOMERGE);
+		req->cmd_flags |= (REQ_HARDBARRIER | REQ_NOMERGE);
 
 	req->errors = 0;
 	req->hard_sector = req->sector = sector;
@@ -3068,7 +3040,7 @@
 		req->errors = 0;
 
 	if (!uptodate) {
-		if (blk_fs_request(req) && !(req->flags & REQ_QUIET))
+		if (blk_fs_request(req) && !(req->cmd_flags & REQ_QUIET))
 			printk("end_request: I/O error, dev %s, sector %llu\n",
 				req->rq_disk ? req->rq_disk->disk_name : "?",
 				(unsigned long long)req->sector);
@@ -3236,8 +3208,8 @@
 
 void blk_rq_bio_prep(request_queue_t *q, struct request *rq, struct bio *bio)
 {
-	/* first three bits are identical in rq->flags and bio->bi_rw */
-	rq->flags |= (bio->bi_rw & 7);
+	/* first three bits are identical in rq->cmd_flags and bio->bi_rw */
+	rq->cmd_flags |= (bio->bi_rw & 7);
 
 	rq->nr_phys_segments = bio_phys_segments(q, bio);
 	rq->nr_hw_segments = bio_hw_segments(q, bio);
Index: drivers/block/nbd.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/block/nbd.c  (mode:100644)
+++ uncommitted/drivers/block/nbd.c  (mode:100644)
@@ -428,7 +428,7 @@
 		dprintk(DBG_BLKDEV, "%s: request %p: dequeued (flags=%lx)\n",
 				req->rq_disk->disk_name, req, req->flags);
 
-		if (!(req->flags & REQ_CMD))
+		if (!blk_fs_request(req))
 			goto error_out;
 
 		lo = req->rq_disk->private_data;
@@ -510,7 +510,7 @@
 	switch (cmd) {
 	case NBD_DISCONNECT:
 	        printk(KERN_INFO "%s: NBD_DISCONNECT\n", lo->disk->disk_name);
-		sreq.flags = REQ_SPECIAL;
+		sreq.cmd_type = REQ_TYPE_SPECIAL;
 		nbd_cmd(&sreq) = NBD_CMD_DISC;
 		/*
 		 * Set these to sane values in case server implementation
Index: drivers/block/noop-iosched.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/block/noop-iosched.c  (mode:100644)
+++ uncommitted/drivers/block/noop-iosched.c  (mode:100644)
@@ -39,7 +39,7 @@
 	/*
 	 * new merges must not precede this barrier
 	 */
-	if (rq->flags & REQ_HARDBARRIER)
+	if (rq->cmd_flags & REQ_HARDBARRIER)
 		q->last_merge = NULL;
 	else if (!q->last_merge)
 		q->last_merge = rq;
Index: drivers/block/paride/pd.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/block/paride/pd.c  (mode:100644)
+++ uncommitted/drivers/block/paride/pd.c  (mode:100644)
@@ -436,7 +436,7 @@
 
 static enum action do_pd_io_start(void)
 {
-	if (pd_req->flags & REQ_SPECIAL) {
+	if (blk_special_request(pd_req)) {
 		phase = pd_special;
 		return pd_special();
 	}
Index: drivers/block/pktcdvd.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/block/pktcdvd.c  (mode:100644)
+++ uncommitted/drivers/block/pktcdvd.c  (mode:100644)
@@ -365,15 +365,15 @@
 	rq->sense = sense;
 	memset(sense, 0, sizeof(sense));
 	rq->sense_len = 0;
-	rq->flags |= REQ_BLOCK_PC | REQ_HARDBARRIER;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_flags |= (REQ_HARDBARRIER | REQ_NOMERGE);
 	if (cgc->quiet)
-		rq->flags |= REQ_QUIET;
+		rq->cmd_flags |= REQ_QUIET;
 	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
 	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
 		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PACKET_SIZE);
 
 	rq->ref_count++;
-	rq->flags |= REQ_NOMERGE;
 	rq->waiting = &wait;
 	rq->end_io = blk_end_sync_rq;
 	elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 1);
Index: drivers/block/scsi_ioctl.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/block/scsi_ioctl.c  (mode:100644)
+++ uncommitted/drivers/block/scsi_ioctl.c  (mode:100644)
@@ -276,7 +276,7 @@
 	rq->sense = sense;
 	rq->sense_len = 0;
 
-	rq->flags |= REQ_BLOCK_PC;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	bio = rq->bio;
 
 	/*
@@ -406,7 +406,7 @@
 
 	rq->data = buffer;
 	rq->data_len = bytes;
-	rq->flags |= REQ_BLOCK_PC;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 
 	blk_execute_rq(q, bd_disk, rq);
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
@@ -553,7 +553,7 @@
 			close = 1;
 		case CDROMEJECT:
 			rq = blk_get_request(q, WRITE, __GFP_WAIT);
-			rq->flags |= REQ_BLOCK_PC;
+			rq->cmd_type = REQ_TYPE_BLOCK_PC;
 			rq->data = NULL;
 			rq->data_len = 0;
 			rq->timeout = BLK_DEFAULT_TIMEOUT;
Index: drivers/block/xd.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/block/xd.c  (mode:100644)
+++ uncommitted/drivers/block/xd.c  (mode:100644)
@@ -310,7 +310,7 @@
 		int res = 0;
 		int retry;
 
-		if (!(req->flags & REQ_CMD)) {
+		if (!blk_fs_request(req)) {
 			end_request(req, 0);
 			continue;
 		}
Index: drivers/cdrom/cdrom.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/cdrom/cdrom.c  (mode:100644)
+++ uncommitted/drivers/cdrom/cdrom.c  (mode:100644)
@@ -2125,7 +2125,7 @@
 		rq->cmd[9] = 0xf8;
 
 		rq->cmd_len = 12;
-		rq->flags |= REQ_BLOCK_PC;
+		rq->cmd_type = REQ_TYPE_BLOCK_PC;
 		rq->timeout = 60 * HZ;
 		bio = rq->bio;
 
Index: drivers/cdrom/cdu31a.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/cdrom/cdu31a.c  (mode:100644)
+++ uncommitted/drivers/cdrom/cdu31a.c  (mode:100644)
@@ -1339,8 +1339,10 @@
 		}
 
 		/* WTF??? */
-		if (!(req->flags & REQ_CMD))
+		if (!blk_fs_request(req)) {
+			end_request(req, 0);
 			continue;
+		}
 		if (rq_data_dir(req) == WRITE) {
 			end_request(req, 0);
 			continue;
Index: drivers/ide/ide-cd.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/ide/ide-cd.c  (mode:100644)
+++ uncommitted/drivers/ide/ide-cd.c  (mode:100644)
@@ -372,7 +372,7 @@
 {
 	int log = 0;
 
-	if (!sense || !rq || (rq->flags & REQ_QUIET))
+	if (!sense || !rq || (rq->cmd_flags & REQ_QUIET))
 		return 0;
 
 	switch (sense->sense_key) {
@@ -562,7 +562,7 @@
 	struct cdrom_info *cd = drive->driver_data;
 
 	ide_init_drive_cmd(rq);
-	rq->flags = REQ_PC;
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->rq_disk = cd->disk;
 }
 
@@ -582,7 +582,7 @@
 	rq->cmd[0] = GPCMD_REQUEST_SENSE;
 	rq->cmd[4] = rq->data_len = 18;
 
-	rq->flags = REQ_SENSE;
+	rq->cmd_type = REQ_TYPE_SENSE;
 
 	/* NOTE! Save the failed command in "rq->buffer" */
 	rq->buffer = (void *) failed_command;
@@ -595,10 +595,10 @@
 	struct request *rq = HWGROUP(drive)->rq;
 	int nsectors = rq->hard_cur_sectors;
 
-	if ((rq->flags & REQ_SENSE) && uptodate) {
+	if (blk_sense_request(rq) && uptodate) {
 		/*
-		 * For REQ_SENSE, "rq->buffer" points to the original failed
-		 * request
+		 * For REQ_TYPE_SENSE, "rq->buffer" points to the original
+		 * failed request
 		 */
 		struct request *failed = (struct request *) rq->buffer;
 		struct cdrom_info *info = drive->driver_data;
@@ -658,17 +658,17 @@
 		return 1;
 	}
 
-	if (rq->flags & REQ_SENSE) {
+	if (blk_sense_request(rq)) {
 		/* We got an error trying to get sense info
 		   from the drive (probably while trying
 		   to recover from a former error).  Just give up. */
 
-		rq->flags |= REQ_FAILED;
+		rq->cmd_flags |= REQ_FAILED;
 		cdrom_end_request(drive, 0);
 		ide_error(drive, "request sense failure", stat);
 		return 1;
 
-	} else if (rq->flags & (REQ_PC | REQ_BLOCK_PC)) {
+	} else if (blk_pc_request(rq)) {
 		/* All other functions, except for READ. */
 		unsigned long flags;
 
@@ -676,7 +676,7 @@
 		 * if we have an error, pass back CHECK_CONDITION as the
 		 * scsi status byte
 		 */
-		if ((rq->flags & REQ_BLOCK_PC) && !rq->errors)
+		if (!rq->errors)
 			rq->errors = SAM_STAT_CHECK_CONDITION;
 
 		/* Check for tray open. */
@@ -687,12 +687,12 @@
 			cdrom_saw_media_change (drive);
 			/*printk("%s: media changed\n",drive->name);*/
 			return 0;
-		} else if (!(rq->flags & REQ_QUIET)) {
+		} else if (!(rq->cmd_flags & REQ_QUIET)) {
 			/* Otherwise, print an error. */
 			ide_dump_status(drive, "packet command error", stat);
 		}
 		
-		rq->flags |= REQ_FAILED;
+		rq->cmd_flags |= REQ_FAILED;
 
 		/*
 		 * instead of playing games with moving completions around,
@@ -819,7 +819,7 @@
 			wait = ATAPI_WAIT_PC;
 			break;
 		default:
-			if (!(rq->flags & REQ_QUIET))
+			if (!(rq->cmd_flags & REQ_QUIET))
 				printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n", rq->cmd[0]);
 			wait = 0;
 			break;
@@ -1062,7 +1062,7 @@
 		if (rq->current_nr_sectors > 0) {
 			printk (KERN_ERR "%s: cdrom_read_intr: data underrun (%d blocks)\n",
 				drive->name, rq->current_nr_sectors);
-			rq->flags |= REQ_FAILED;
+			rq->cmd_flags |= REQ_FAILED;
 			cdrom_end_request(drive, 0);
 		} else
 			cdrom_end_request(drive, 1);
@@ -1399,7 +1399,7 @@
 			printk ("%s: cdrom_pc_intr: data underrun %d\n",
 				drive->name, pc->buflen);
 			*/
-			rq->flags |= REQ_FAILED;
+			rq->cmd_flags |= REQ_FAILED;
 			cdrom_end_request(drive, 0);
 		}
 		return ide_stopped;
@@ -1452,14 +1452,14 @@
 		rq->data += thislen;
 		rq->data_len -= thislen;
 
-		if (rq->flags & REQ_SENSE)
+		if (blk_sense_request(rq))
 			rq->sense_len += thislen;
 	} else {
 confused:
 		printk (KERN_ERR "%s: cdrom_pc_intr: The drive "
 			"appears confused (ireason = 0x%02x)\n",
 			drive->name, ireason);
-		rq->flags |= REQ_FAILED;
+		rq->cmd_flags |= REQ_FAILED;
 	}
 
 	/* Now we wait for another interrupt. */
@@ -1487,7 +1487,7 @@
 
 	info->dma = 0;
 	info->cmd = 0;
-	rq->flags &= ~REQ_FAILED;
+	rq->cmd_flags &= ~REQ_FAILED;
 	len = rq->data_len;
 
 	/* Start sending the command to the drive. */
@@ -1500,7 +1500,7 @@
 {
 	struct request_sense sense;
 	int retries = 10;
-	unsigned int flags = rq->flags;
+	unsigned int flags = rq->cmd_flags;
 
 	if (rq->sense == NULL)
 		rq->sense = &sense;
@@ -1509,14 +1509,14 @@
 	do {
 		int error;
 		unsigned long time = jiffies;
-		rq->flags = flags;
+		rq->cmd_flags = flags;
 
 		error = ide_do_drive_cmd(drive, rq, ide_wait);
 		time = jiffies - time;
 
 		/* FIXME: we should probably abort/retry or something 
 		 * in case of failure */
-		if (rq->flags & REQ_FAILED) {
+		if (rq->cmd_flags & REQ_FAILED) {
 			/* The request failed.  Retry if it was due to a unit
 			   attention status
 			   (usually means media was changed). */
@@ -1538,10 +1538,10 @@
 		}
 
 		/* End of retry loop. */
-	} while ((rq->flags & REQ_FAILED) && retries >= 0);
+	} while ((rq->cmd_flags & REQ_FAILED) && retries >= 0);
 
 	/* Return an error if the command failed. */
-	return (rq->flags & REQ_FAILED) ? -EIO : 0;
+	return (rq->cmd_flags & REQ_FAILED) ? -EIO : 0;
 }
 
 /*
@@ -1915,7 +1915,7 @@
 {
 	struct cdrom_info *info = drive->driver_data;
 
-	rq->flags |= REQ_QUIET;
+	rq->cmd_flags |= REQ_QUIET;
 
 	info->dma = 0;
 	info->cmd = 0;
@@ -1974,11 +1974,11 @@
 		}
 		info->last_block = block;
 		return action;
-	} else if (rq->flags & (REQ_PC | REQ_SENSE)) {
+	} else if (rq->cmd_type == REQ_TYPE_SENSE) {
 		return cdrom_do_packet_command(drive);
-	} else if (rq->flags & REQ_BLOCK_PC) {
+	} else if (blk_pc_request(rq)) {
 		return cdrom_do_block_pc(drive, rq);
-	} else if (rq->flags & REQ_SPECIAL) {
+	} else if (blk_special_request(rq)) {
 		/*
 		 * right now this can only be a reset...
 		 */
@@ -2056,7 +2056,7 @@
 
 	req.sense = sense;
 	req.cmd[0] = GPCMD_TEST_UNIT_READY;
-	req.flags |= REQ_QUIET;
+	req.cmd_flags |= REQ_QUIET;
 
 #if ! STANDARD_ATAPI
         /* the Sanyo 3 CD changer uses byte 7 of TEST_UNIT_READY to 
@@ -2180,7 +2180,7 @@
 	req.sense = sense;
 	req.data =  buf;
 	req.data_len = buflen;
-	req.flags |= REQ_QUIET;
+	req.cmd_flags |= REQ_QUIET;
 	req.cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
 	req.cmd[6] = trackno;
 	req.cmd[7] = (buflen >> 8);
@@ -2476,7 +2476,7 @@
 	req.timeout = cgc->timeout;
 
 	if (cgc->quiet)
-		req.flags |= REQ_QUIET;
+		req.cmd_flags |= REQ_QUIET;
 
 	req.sense = cgc->sense;
 	cgc->stat = cdrom_queue_packet_command(drive, &req);
@@ -2618,7 +2618,8 @@
 	int ret;
 
 	cdrom_prepare_request(drive, &req);
-	req.flags = REQ_SPECIAL | REQ_QUIET;
+	req.cmd_type = REQ_TYPE_SPECIAL;
+	req.cmd_flags = REQ_QUIET;
 	ret = ide_do_drive_cmd(drive, &req, ide_wait);
 
 	/*
@@ -3097,9 +3098,9 @@
 
 static int ide_cdrom_prep_fn(request_queue_t *q, struct request *rq)
 {
-	if (rq->flags & REQ_CMD)
+	if (blk_fs_request(rq))
 		return ide_cdrom_prep_fs(q, rq);
-	else if (rq->flags & REQ_BLOCK_PC)
+	else if (blk_pc_request(rq))
 		return ide_cdrom_prep_pc(rq);
 
 	return 0;
Index: drivers/ide/ide-disk.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/ide/ide-disk.c  (mode:100644)
+++ uncommitted/drivers/ide/ide-disk.c  (mode:100644)
@@ -731,7 +731,8 @@
 		rq->cmd[0] = WIN_FLUSH_CACHE;
 
 
-	rq->flags |= REQ_DRIVE_TASK | REQ_SOFTBARRIER;
+	rq->cmd_type = REQ_TYPE_ATA_TASK;
+	rq->cmd_flags |= REQ_SOFTBARRIER;
 	rq->buffer = rq->cmd;
 	return 1;
 }
Index: drivers/ide/ide-dma.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/ide/ide-dma.c  (mode:100644)
+++ uncommitted/drivers/ide/ide-dma.c  (mode:100644)
@@ -210,7 +210,7 @@
 	ide_hwif_t *hwif = HWIF(drive);
 	struct scatterlist *sg = hwif->sg_table;
 
-	if ((rq->flags & REQ_DRIVE_TASKFILE) && rq->nr_sectors > 256)
+	if ((rq->cmd_type == REQ_TYPE_ATA_TASKFILE) && rq->nr_sectors > 256)
 		BUG();
 
 	ide_map_sg(drive, rq);
Index: drivers/ide/ide-floppy.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/ide/ide-floppy.c  (mode:100644)
+++ uncommitted/drivers/ide/ide-floppy.c  (mode:100644)
@@ -588,7 +588,7 @@
 	/* Why does this happen? */
 	if (!rq)
 		return 0;
-	if (!(rq->flags & REQ_SPECIAL)) { //if (!IDEFLOPPY_RQ_CMD (rq->cmd)) {
+	if (!blk_special_request(rq)) {
 		/* our real local end request function */
 		ide_end_request(drive, uptodate, nsecs);
 		return 0;
@@ -687,7 +687,7 @@
 
 	ide_init_drive_cmd(rq);
 	rq->buffer = (char *) pc;
-	rq->flags = REQ_SPECIAL;	//rq->cmd = IDEFLOPPY_PC_RQ;
+	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->rq_disk = floppy->disk;
 	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
 }
@@ -1301,7 +1301,7 @@
 		idefloppy_do_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
-	if (rq->flags & REQ_CMD) {
+	if (blk_fs_request(rq)) {
 		if (((long)rq->sector % floppy->bs_factor) ||
 		    (rq->nr_sectors % floppy->bs_factor)) {
 			printk("%s: unsupported r/w request size\n",
@@ -1311,9 +1311,9 @@
 		}
 		pc = idefloppy_next_pc_storage(drive);
 		idefloppy_create_rw_cmd(floppy, pc, rq, block);
-	} else if (rq->flags & REQ_SPECIAL) {
+	} else if (blk_special_request(rq))
 		pc = (idefloppy_pc_t *) rq->buffer;
-	} else if (rq->flags & REQ_BLOCK_PC) {
+	} else if (blk_fs_request(rq)) {
 		pc = idefloppy_next_pc_storage(drive);
 		if (idefloppy_blockpc_cmd(floppy, pc, rq)) {
 			idefloppy_do_end_request(drive, 0, 0);
@@ -1341,7 +1341,7 @@
 
 	ide_init_drive_cmd (&rq);
 	rq.buffer = (char *) pc;
-	rq.flags = REQ_SPECIAL;		//	rq.cmd = IDEFLOPPY_PC_RQ;
+	rq.cmd_type = REQ_TYPE_SPECIAL;
 	rq.rq_disk = floppy->disk;
 
 	return ide_do_drive_cmd(drive, &rq, ide_wait);
Index: drivers/ide/ide-io.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/ide/ide-io.c  (mode:100644)
+++ uncommitted/drivers/ide/ide-io.c  (mode:100644)
@@ -60,7 +60,7 @@
 {
 	int ret = 1;
 
-	BUG_ON(!(rq->flags & REQ_STARTED));
+	BUG_ON(!blk_rq_started(rq));
 
 	/*
 	 * if failfast is set on a request, override number of sectors and
@@ -310,7 +310,7 @@
 	rq = HWGROUP(drive)->rq;
 	spin_unlock_irqrestore(&ide_lock, flags);
 
-	if (rq->flags & REQ_DRIVE_CMD) {
+	if (rq->cmd_type == REQ_TYPE_ATA_CMD) {
 		u8 *args = (u8 *) rq->buffer;
 		if (rq->errors == 0)
 			rq->errors = !OK_STAT(stat,READY_STAT,BAD_STAT);
@@ -320,7 +320,7 @@
 			args[1] = err;
 			args[2] = hwif->INB(IDE_NSECTOR_REG);
 		}
-	} else if (rq->flags & REQ_DRIVE_TASK) {
+	} else if (rq->cmd_type == REQ_TYPE_ATA_TASK) {
 		u8 *args = (u8 *) rq->buffer;
 		if (rq->errors == 0)
 			rq->errors = !OK_STAT(stat,READY_STAT,BAD_STAT);
@@ -334,7 +334,7 @@
 			args[5] = hwif->INB(IDE_HCYL_REG);
 			args[6] = hwif->INB(IDE_SELECT_REG);
 		}
-	} else if (rq->flags & REQ_DRIVE_TASKFILE) {
+	} else if (rq->cmd_type & REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *args = (ide_task_t *) rq->special;
 		if (rq->errors == 0)
 			rq->errors = !OK_STAT(stat,READY_STAT,BAD_STAT);
@@ -530,7 +530,7 @@
 		return ide_stopped;
 
 	/* retry only "normal" I/O: */
-	if (rq->flags & (REQ_DRIVE_CMD | REQ_DRIVE_TASK | REQ_DRIVE_TASKFILE)) {
+	if (!blk_fs_request(rq)) {
 		rq->errors = 1;
 		ide_end_drive_cmd(drive, stat, err);
 		return ide_stopped;
@@ -581,7 +581,7 @@
 		return ide_stopped;
 
 	/* retry only "normal" I/O: */
-	if (rq->flags & (REQ_DRIVE_CMD | REQ_DRIVE_TASK | REQ_DRIVE_TASKFILE)) {
+	if (!blk_fs_request(rq)) {
 		rq->errors = 1;
 		ide_end_drive_cmd(drive, BUSY_STAT, 0);
 		return ide_stopped;
@@ -751,7 +751,7 @@
 	if (hwif->sg_mapped)	/* needed by ide-scsi */
 		return;
 
-	if ((rq->flags & REQ_DRIVE_TASKFILE) == 0) {
+	if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
 		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
 	} else {
 		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
@@ -787,7 +787,7 @@
 		struct request *rq)
 {
 	ide_hwif_t *hwif = HWIF(drive);
-	if (rq->flags & REQ_DRIVE_TASKFILE) {
+	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
  		ide_task_t *args = rq->special;
  
 		if (!args)
@@ -809,7 +809,7 @@
 		if (args->tf_out_flags.all != 0) 
 			return flagged_taskfile(drive, args);
 		return do_rw_taskfile(drive, args);
-	} else if (rq->flags & REQ_DRIVE_TASK) {
+	} else if (rq->cmd_type == REQ_TYPE_ATA_TASK) {
 		u8 *args = rq->buffer;
 		u8 sel;
  
@@ -835,7 +835,7 @@
  		hwif->OUTB(sel, IDE_SELECT_REG);
  		ide_cmd(drive, args[0], args[2], &drive_cmd_intr);
  		return ide_started;
- 	} else if (rq->flags & REQ_DRIVE_CMD) {
+ 	} else if (rq->cmd_type == REQ_TYPE_ATA_CMD) {
  		u8 *args = rq->buffer;
 
 		if (!args)
@@ -890,7 +890,7 @@
 	ide_startstop_t startstop;
 	sector_t block;
 
-	BUG_ON(!(rq->flags & REQ_STARTED));
+	BUG_ON(!blk_rq_started(rq));
 
 #ifdef DEBUG
 	printk("%s: start_request: current=0x%08lx\n",
@@ -948,9 +948,10 @@
 	if (!drive->special.all) {
 		ide_driver_t *drv;
 
-		if (rq->flags & (REQ_DRIVE_CMD | REQ_DRIVE_TASK))
+		if (rq->cmd_type == REQ_TYPE_ATA_CMD ||
+		    rq->cmd_type == REQ_TYPE_ATA_TASK)
 			return execute_drive_cmd(drive, rq);
-		else if (rq->flags & REQ_DRIVE_TASKFILE)
+		else if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
 			return execute_drive_cmd(drive, rq);
 		else if (blk_pm_request(rq)) {
 #ifdef DEBUG_PM
@@ -1193,7 +1194,8 @@
 		 * unless the subdriver triggers such a thing in its own PM
 		 * state machine.
 		 */
-		if (drive->blocked && !blk_pm_request(rq) && !(rq->flags & REQ_PREEMPT)) {
+		if (drive->blocked && !blk_pm_request(rq) &&
+		    !(rq->cmd_flags & REQ_PREEMPT)) {
 			/* We clear busy, there should be no pending ATA command at this point. */
 			hwgroup->busy = 0;
 			break;
@@ -1596,7 +1598,7 @@
 void ide_init_drive_cmd (struct request *rq)
 {
 	memset(rq, 0, sizeof(*rq));
-	rq->flags = REQ_DRIVE_CMD;
+	rq->cmd_type = REQ_TYPE_ATA_CMD;
 	rq->ref_count = 1;
 }
 
@@ -1659,7 +1661,7 @@
 		hwgroup->rq = NULL;
 	if (action == ide_preempt || action == ide_head_wait) {
 		where = ELEVATOR_INSERT_FRONT;
-		rq->flags |= REQ_PREEMPT;
+		rq->cmd_flags |= REQ_PREEMPT;
 	}
 	__elv_add_request(drive->queue, rq, where, 0);
 	ide_do_request(hwgroup, IDE_NO_IRQ);
Index: drivers/ide/ide-lib.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/ide/ide-lib.c  (mode:100644)
+++ uncommitted/drivers/ide/ide-lib.c  (mode:100644)
@@ -458,13 +458,14 @@
 	spin_unlock(&ide_lock);
 	if (!rq)
 		return;
-	if (rq->flags & (REQ_DRIVE_CMD | REQ_DRIVE_TASK)) {
+	if (rq->cmd_type == REQ_TYPE_ATA_CMD ||
+	    rq->cmd_type == REQ_TYPE_ATA_TASK) {
 		char *args = rq->buffer;
 		if (args) {
 			opcode = args[0];
 			found = 1;
 		}
-	} else if (rq->flags & REQ_DRIVE_TASKFILE) {
+	} else if (rq->cmd_type & REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *args = rq->special;
 		if (args) {
 			task_struct_t *tf = (task_struct_t *) args->tfRegister;
Index: drivers/ide/ide-tape.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/ide/ide-tape.c  (mode:100644)
+++ uncommitted/drivers/ide/ide-tape.c  (mode:100644)
@@ -1774,7 +1774,7 @@
 static void idetape_init_rq(struct request *rq, u8 cmd)
 {
 	memset(rq, 0, sizeof(*rq));
-	rq->flags = REQ_SPECIAL;
+	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd[0] = cmd;
 }
 
@@ -2431,7 +2431,7 @@
 			rq->sector, rq->nr_sectors, rq->current_nr_sectors);
 #endif /* IDETAPE_DEBUG_LOG */
 
-	if ((rq->flags & REQ_SPECIAL) == 0) {
+	if (!blk_special_request(rq)) {
 		/*
 		 * We do not support buffer cache originated requests.
 		 */
@@ -2760,7 +2760,7 @@
 	idetape_tape_t *tape = drive->driver_data;
 
 #if IDETAPE_DEBUG_BUGS
-	if (rq == NULL || (rq->flags & REQ_SPECIAL) == 0) {
+	if (rq == NULL || !blk_special_request(rq)) {
 		printk (KERN_ERR "ide-tape: bug: Trying to sleep on non-valid request\n");
 		return;
 	}
Index: drivers/ide/ide-taskfile.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/ide/ide-taskfile.c  (mode:100644)
+++ uncommitted/drivers/ide/ide-taskfile.c  (mode:100644)
@@ -366,7 +366,7 @@
 
 static void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 {
-	if (rq->flags & REQ_DRIVE_TASKFILE) {
+	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
 		ide_task_t *task = rq->special;
 
 		if (task->tf_out_flags.all) {
@@ -471,7 +471,7 @@
 	struct request rq;
 
 	memset(&rq, 0, sizeof(rq));
-	rq.flags = REQ_DRIVE_TASKFILE;
+	rq.cmd_type = REQ_TYPE_ATA_TASKFILE;
 	rq.buffer = buf;
 
 	/*
@@ -496,7 +496,7 @@
 		rq.hard_cur_sectors = rq.current_nr_sectors = rq.nr_sectors;
 
 		if (args->command_type == IDE_DRIVE_TASK_RAW_WRITE)
-			rq.flags |= REQ_RW;
+			rq.cmd_flags |= REQ_RW;
 	}
 
 	rq.special = args;
@@ -739,7 +739,7 @@
 	struct request rq;
 
 	ide_init_drive_cmd(&rq);
-	rq.flags = REQ_DRIVE_TASK;
+	rq.cmd_type = REQ_TYPE_ATA_TASK;
 	rq.buffer = buf;
 	return ide_do_drive_cmd(drive, &rq, ide_wait);
 }
Index: drivers/ide/ide.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/ide/ide.c  (mode:100644)
+++ uncommitted/drivers/ide/ide.c  (mode:100644)
@@ -1381,7 +1381,7 @@
 	memset(&rq, 0, sizeof(rq));
 	memset(&rqpm, 0, sizeof(rqpm));
 	memset(&args, 0, sizeof(args));
-	rq.flags = REQ_PM_SUSPEND;
+	rq.cmd_type = REQ_TYPE_PM_SUSPEND;
 	rq.special = &args;
 	rq.pm = &rqpm;
 	rqpm.pm_step = ide_pm_state_start_suspend;
@@ -1400,7 +1400,7 @@
 	memset(&rq, 0, sizeof(rq));
 	memset(&rqpm, 0, sizeof(rqpm));
 	memset(&args, 0, sizeof(args));
-	rq.flags = REQ_PM_RESUME;
+	rq.cmd_type = REQ_TYPE_PM_RESUME;
 	rq.special = &args;
 	rq.pm = &rqpm;
 	rqpm.pm_step = ide_pm_state_start_resume;
Index: drivers/ide/legacy/hd.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/ide/legacy/hd.c  (mode:100644)
+++ uncommitted/drivers/ide/legacy/hd.c  (mode:100644)
@@ -624,7 +624,7 @@
 		req->rq_disk->disk_name, (req->cmd == READ)?"read":"writ",
 		cyl, head, sec, nsect, req->buffer);
 #endif
-	if (req->flags & REQ_CMD) {
+	if (blk_fs_request(req)) {
 		switch (rq_data_dir(req)) {
 		case READ:
 			hd_out(disk,nsect,sec,head,cyl,WIN_READ,&read_intr);
Index: drivers/message/i2o/i2o_block.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/message/i2o/i2o_block.c  (mode:100644)
+++ uncommitted/drivers/message/i2o/i2o_block.c  (mode:100644)
@@ -352,9 +352,9 @@
 	struct i2o_block_request *ireq;
 
 	/* request is already processed by us, so return */
-	if (req->flags & REQ_SPECIAL) {
+	if (blk_special_request(req)) {
 		osm_debug("REQ_SPECIAL already set!\n");
-		req->flags |= REQ_DONTPREP;
+		req->cmd_flags |= REQ_DONTPREP;
 		return BLKPREP_OK;
 	}
 
@@ -373,7 +373,8 @@
 		ireq = req->special;
 
 	/* do not come back here */
-	req->flags |= REQ_DONTPREP | REQ_SPECIAL;
+	req->cmd_type = REQ_TYPE_SPECIAL;
+	req->cmd_flags |= REQ_DONTPREP;
 
 	return BLKPREP_OK;
 };
Index: drivers/mmc/mmc_queue.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/mmc/mmc_queue.c  (mode:100644)
+++ uncommitted/drivers/mmc/mmc_queue.c  (mode:100644)
@@ -28,7 +28,7 @@
 	struct mmc_queue *mq = q->queuedata;
 	int ret = BLKPREP_KILL;
 
-	if (req->flags & REQ_SPECIAL) {
+	if (blk_special_request(req)) {
 		/*
 		 * Special commands already have the command
 		 * blocks already setup in req->special.
@@ -36,7 +36,7 @@
 		BUG_ON(!req->special);
 
 		ret = BLKPREP_OK;
-	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
+	} else if (blk_fs_request(req) || blk_pc_request(req)) {
 		/*
 		 * Block I/O requests need translating according
 		 * to the protocol.
Index: drivers/mtd/mtd_blkdevs.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/mtd/mtd_blkdevs.c  (mode:100644)
+++ uncommitted/drivers/mtd/mtd_blkdevs.c  (mode:100644)
@@ -47,7 +47,7 @@
 	nsect = req->current_nr_sectors;
 	buf = req->buffer;
 
-	if (!(req->flags & REQ_CMD))
+	if (!blk_fs_request(req))
 		return 0;
 
 	if (block + nsect > get_capacity(req->rq_disk))
Index: drivers/scsi/ide-scsi.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/scsi/ide-scsi.c  (mode:100644)
+++ uncommitted/drivers/scsi/ide-scsi.c  (mode:100644)
@@ -317,7 +317,7 @@
 	pc->buffer = buf;
 	pc->c[0] = REQUEST_SENSE;
 	pc->c[4] = pc->request_transfer = pc->buffer_size = SCSI_SENSE_BUFFERSIZE;
-	rq->flags = REQ_SENSE;
+	rq->cmd_type = REQ_TYPE_SENSE;
 	pc->timeout = jiffies + WAIT_READY;
 	/* NOTE! Save the failed packet command in "rq->buffer" */
 	rq->buffer = (void *) failed_command->special;
@@ -370,12 +370,12 @@
 	u8 *scsi_buf;
 	unsigned long flags;
 
-	if (!(rq->flags & (REQ_SPECIAL|REQ_SENSE))) {
+	if (!blk_special_request(rq) || !blk_sense_request(rq)) {
 		ide_end_request(drive, uptodate, nrsecs);
 		return 0;
 	}
 	ide_end_drive_cmd (drive, 0, 0);
-	if (rq->flags & REQ_SENSE) {
+	if (blk_sense_request(rq)) {
 		idescsi_pc_t *opc = (idescsi_pc_t *) rq->buffer;
 		if (log) {
 			printk ("ide-scsi: %s: wrap up check %lu, rst = ", drive->name, opc->scsi_cmd->serial_number);
@@ -686,7 +686,7 @@
 	printk (KERN_INFO "sector: %ld, nr_sectors: %ld, current_nr_sectors: %d\n",rq->sector,rq->nr_sectors,rq->current_nr_sectors);
 #endif /* IDESCSI_DEBUG_LOG */
 
-	if (rq->flags & (REQ_SPECIAL|REQ_SENSE)) {
+	if (blk_sense_request(rq) || blk_special_request(rq)) {
 		return idescsi_issue_pc (drive, (idescsi_pc_t *) rq->special);
 	}
 	blk_dump_rq_flags(rq, "ide-scsi: unsup command");
@@ -921,7 +921,7 @@
 
 	ide_init_drive_cmd (rq);
 	rq->special = (char *) pc;
-	rq->flags = REQ_SPECIAL;
+	rq->cmd_type = REQ_TYPE_SPECIAL;
 	spin_unlock_irq(host->host_lock);
 	rq->rq_disk = scsi->disk;
 	(void) ide_do_drive_cmd (drive, rq, ide_end);
@@ -975,7 +975,7 @@
 		 */
 		printk (KERN_ERR "ide-scsi: cmd aborted!\n");
 
-		if (scsi->pc->rq->flags & REQ_SENSE)
+		if (blk_sense_request(scsi->pc->rq))
 			kfree(scsi->pc->buffer);
 		kfree(scsi->pc->rq);
 		kfree(scsi->pc);
@@ -1023,7 +1023,7 @@
 	/* kill current request */
 	blkdev_dequeue_request(req);
 	end_that_request_last(req);
-	if (req->flags & REQ_SENSE)
+	if (blk_sense_request(req))
 		kfree(scsi->pc->buffer);
 	kfree(scsi->pc);
 	scsi->pc = NULL;
Index: drivers/scsi/scsi_lib.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/scsi/scsi_lib.c  (mode:100644)
+++ uncommitted/drivers/scsi/scsi_lib.c  (mode:100644)
@@ -90,7 +90,7 @@
 	 * Because users of this function are apt to reuse requests with no
 	 * modification, we have to sanitise the request flags here
 	 */
-	sreq->sr_request->flags &= ~REQ_DONTPREP;
+	sreq->sr_request->cmd_flags &= ~REQ_DONTPREP;
 	blk_insert_request(sreq->sr_device->request_queue, sreq->sr_request,
 		       	   at_head, sreq, 0);
 	return 0;
@@ -485,7 +485,7 @@
  */
 static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 {
-	cmd->request->flags &= ~REQ_DONTPREP;
+	cmd->request->cmd_flags &= ~REQ_DONTPREP;
 	blk_insert_request(q, cmd->request, 1, cmd, 1);
 
 	scsi_run_queue(q);
@@ -922,7 +922,7 @@
 	/*
 	 * if this is a rq->data based REQ_BLOCK_PC, setup for a non-sg xfer
 	 */
-	if ((req->flags & REQ_BLOCK_PC) && !req->bio) {
+	if (blk_pc_request(req) && req->bio) {
 		cmd->request_bufflen = req->data_len;
 		cmd->request_buffer = req->data;
 		req->buffer = req->data;
@@ -942,7 +942,7 @@
 	 */
 	sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
 	if (unlikely(!sgpnt)) {
-		req->flags |= REQ_SPECIAL;
+		req->cmd_type = REQ_TYPE_SPECIAL;
 		return BLKPREP_DEFER;
 	}
 
@@ -1066,7 +1066,7 @@
 	 * these two cases differently.  We differentiate by looking
 	 * at request->cmd, as this tells us the real story.
 	 */
-	if (req->flags & REQ_SPECIAL) {
+	if (req->cmd_type == REQ_TYPE_SPECIAL) {
 		struct scsi_request *sreq = req->special;
 
 		if (sreq->sr_magic == SCSI_REQ_MAGIC) {
@@ -1076,7 +1076,7 @@
 			scsi_init_cmd_from_req(cmd, sreq);
 		} else
 			cmd = req->special;
-	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
+	} else if (blk_fs_request(req) || blk_pc_request(req)) {
 
 		if(unlikely(specials_only)) {
 			if(specials_only == SDEV_QUIESCE ||
@@ -1119,7 +1119,7 @@
 	 * lock.  We hope REQ_STARTED prevents anything untoward from
 	 * happening now.
 	 */
-	if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
+	if (blk_fs_request(req) || blk_pc_request(req)) {
 		struct scsi_driver *drv;
 		int ret;
 
@@ -1158,7 +1158,7 @@
 	/*
 	 * The request is now prepped, no need to come back here
 	 */
-	req->flags |= REQ_DONTPREP;
+	req->cmd_flags |= REQ_DONTPREP;
 	return BLKPREP_OK;
 
  defer:
@@ -1250,7 +1250,7 @@
 
 	while ((req = elv_next_request(q)) != NULL) {
 		blkdev_dequeue_request(req);
-		req->flags |= REQ_QUIET;
+		req->cmd_flags |= REQ_QUIET;
 		while (end_that_request_first(req, 0, req->nr_sectors))
 			;
 		end_that_request_last(req);
@@ -1305,7 +1305,7 @@
 			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
 			       sdev->host->host_no, sdev->id, sdev->lun);
 			blkdev_dequeue_request(req);
-			req->flags |= REQ_QUIET;
+			req->cmd_flags |= REQ_QUIET;
 			while (end_that_request_first(req, 0, req->nr_sectors))
 				;
 			end_that_request_last(req);
Index: drivers/scsi/sd.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/scsi/sd.c  (mode:100644)
+++ uncommitted/drivers/scsi/sd.c  (mode:100644)
@@ -329,13 +329,9 @@
 		}
 		SCpnt->cmnd[0] = WRITE_6;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
-	} else if (rq_data_dir(rq) == READ) {
+	} else {
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-	} else {
-		printk(KERN_ERR "sd: Unknown command %lx\n", rq->flags);
-/* overkill 	panic("Unknown sd command %lx\n", rq->flags); */
-		return 0;
 	}
 
 	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n", 
@@ -769,7 +765,8 @@
 
 	if (sdkp->WCE) {
 		memset(rq->cmd, 0, sizeof(rq->cmd));
-		rq->flags |= REQ_BLOCK_PC | REQ_SOFTBARRIER;
+		rq->cmd_type = REQ_TYPE_BLOCK_PC;
+		rq->cmd_flags |= REQ_SOFTBARRIER;
 		rq->timeout = SD_TIMEOUT;
 		rq->cmd[0] = SYNCHRONIZE_CACHE;
 		return 1;
Index: drivers/scsi/sr.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/scsi/sr.c  (mode:100644)
+++ uncommitted/drivers/scsi/sr.c  (mode:100644)
@@ -349,7 +349,7 @@
 		goto queue;
 	}
 
-	if (!(SCpnt->request->flags & REQ_CMD)) {
+	if (!blk_fs_request(SCpnt->request)) {
 		blk_dump_rq_flags(SCpnt->request, "sr unsup command");
 		return 0;
 	}
Index: drivers/scsi/sun3_NCR5380.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/scsi/sun3_NCR5380.c  (mode:100644)
+++ uncommitted/drivers/scsi/sun3_NCR5380.c  (mode:100644)
@@ -2017,7 +2017,7 @@
 		if((count > SUN3_DMA_MINSIZE) && (sun3_dma_setup_done
 						  != cmd))
 		{
-			if(cmd->request->flags & REQ_CMD) {
+			if(blk_fs_request(cmd->request)) {
 				sun3scsi_dma_setup(d, count,
 						   rq_data_dir(cmd->request));
 				sun3_dma_setup_done = cmd;
Index: drivers/scsi/sun3_scsi.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/scsi/sun3_scsi.c  (mode:100644)
+++ uncommitted/drivers/scsi/sun3_scsi.c  (mode:100644)
@@ -524,7 +524,7 @@
 static inline unsigned long sun3scsi_dma_xfer_len(unsigned long wanted, Scsi_Cmnd *cmd,
 				    int write_flag)
 {
-	if(cmd->request->flags & REQ_CMD)
+	if(blk_fs_request(cmd->request))
  		return wanted;
 	else
 		return 0;
Index: drivers/scsi/sun3_scsi_vme.c
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/drivers/scsi/sun3_scsi_vme.c  (mode:100644)
+++ uncommitted/drivers/scsi/sun3_scsi_vme.c  (mode:100644)
@@ -458,7 +458,7 @@
 static inline unsigned long sun3scsi_dma_xfer_len(unsigned long wanted, Scsi_Cmnd *cmd,
 				    int write_flag)
 {
-	if(cmd->request->flags & REQ_CMD)
+	if(blk_fs_request(cmd->request))
  		return wanted;
 	else
 		return 0;
Index: include/linux/blkdev.h
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/include/linux/blkdev.h  (mode:100644)
+++ uncommitted/include/linux/blkdev.h  (mode:100644)
@@ -113,7 +113,8 @@
 	struct list_head queuelist; /* looking for ->queue? you must _not_
 				     * access it directly, use
 				     * blkdev_dequeue_request! */
-	unsigned long flags;		/* see REQ_ bits below */
+	unsigned int cmd_flags;
+	unsigned char cmd_type;
 
 	/* Maintain bio traversal state for part by part I/O submission.
 	 * hard_* are block layer internals, no driver should touch them!
@@ -188,38 +189,63 @@
 };
 
 /*
- * first three bits match BIO_RW* bits, important
+ * request command types
  */
-enum rq_flag_bits {
+enum rq_cmd_type_bits {
+	REQ_TYPE_FS		= 1,	/* fs request */
+	REQ_TYPE_BLOCK_PC,		/* scsi command */
+	REQ_TYPE_SENSE,			/* sense request */
+	REQ_TYPE_PM_SUSPEND,		/* suspend request */
+	REQ_TYPE_PM_RESUME,		/* resume request */
+	REQ_TYPE_PM_SHUTDOWN,		/* shutdown request */
+	REQ_TYPE_FLUSH,			/* flush request */
+	REQ_TYPE_SPECIAL,		/* driver defined type */
+	REQ_TYPE_LINUX_BLOCK,		/* generic block layer message */
+	/*
+	 * for ATA/ATAPI devices. this really doesn't belong here, ide should
+	 * use REQ_TYPE_SPECIAL and use rq->cmd[0] to differentiate what type
+	 * of request this is.
+	 */
+	REQ_TYPE_ATA_CMD,
+	REQ_TYPE_ATA_TASK,
+	REQ_TYPE_ATA_TASKFILE,
+};
+
+/*
+ * For request of type REQ_TYPE_LINUX_BLOCK, rq->cmd[0] is the opcode being
+ * sent down (similar to how REQ_TYPE_BLOCK_PC means that ->cmd[] holds a
+ * SCSI cdb.
+ *
+ * 0x00 -> 0x3f are driver private, to be used for whatever purpose they need,
+ * typically to differentiate REQ_TYPE_SPECIAL requests.
+ *
+ */
+enum {
+	/*
+	 * just examples for now
+	 */
+	REQ_LB_OP_EJECT	= 0x40,		/* eject request */
+	REQ_LB_OP_FLUSH = 0x41,		/* flush device */
+};
+
+/*
+ * request type modified bits. first three bits match BIO_RW* bits, important
+ */
+enum rq_cmd_flag_bits {
 	__REQ_RW,		/* not set, read. set, write */
 	__REQ_FAILFAST,		/* no low level driver retries */
 	__REQ_SOFTBARRIER,	/* may not be passed by ioscheduler */
 	__REQ_HARDBARRIER,	/* may not be passed by drive either */
-	__REQ_CMD,		/* is a regular fs rw request */
 	__REQ_NOMERGE,		/* don't touch this for merging */
 	__REQ_STARTED,		/* drive already may have started this one */
 	__REQ_DONTPREP,		/* don't call prep for this one */
 	__REQ_QUEUED,		/* uses queueing */
-	/*
-	 * for ATA/ATAPI devices
-	 */
-	__REQ_PC,		/* packet command (special) */
-	__REQ_BLOCK_PC,		/* queued down pc from block layer */
-	__REQ_SENSE,		/* sense retrival */
-
 	__REQ_FAILED,		/* set if the request failed */
 	__REQ_QUIET,		/* don't worry about errors */
-	__REQ_SPECIAL,		/* driver suplied command */
-	__REQ_DRIVE_CMD,
-	__REQ_DRIVE_TASK,
-	__REQ_DRIVE_TASKFILE,
 	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
-	__REQ_PM_SUSPEND,	/* suspend request */
-	__REQ_PM_RESUME,	/* resume request */
-	__REQ_PM_SHUTDOWN,	/* shutdown request */
 	__REQ_BAR_PREFLUSH,	/* barrier pre-flush done */
 	__REQ_BAR_POSTFLUSH,	/* barrier post-flush */
-	__REQ_BAR_FLUSH,	/* rq is the flush request */
+
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -227,30 +253,18 @@
 #define REQ_FAILFAST	(1 << __REQ_FAILFAST)
 #define REQ_SOFTBARRIER	(1 << __REQ_SOFTBARRIER)
 #define REQ_HARDBARRIER	(1 << __REQ_HARDBARRIER)
-#define REQ_CMD		(1 << __REQ_CMD)
 #define REQ_NOMERGE	(1 << __REQ_NOMERGE)
 #define REQ_STARTED	(1 << __REQ_STARTED)
 #define REQ_DONTPREP	(1 << __REQ_DONTPREP)
 #define REQ_QUEUED	(1 << __REQ_QUEUED)
-#define REQ_PC		(1 << __REQ_PC)
-#define REQ_BLOCK_PC	(1 << __REQ_BLOCK_PC)
-#define REQ_SENSE	(1 << __REQ_SENSE)
 #define REQ_FAILED	(1 << __REQ_FAILED)
 #define REQ_QUIET	(1 << __REQ_QUIET)
-#define REQ_SPECIAL	(1 << __REQ_SPECIAL)
-#define REQ_DRIVE_CMD	(1 << __REQ_DRIVE_CMD)
-#define REQ_DRIVE_TASK	(1 << __REQ_DRIVE_TASK)
-#define REQ_DRIVE_TASKFILE	(1 << __REQ_DRIVE_TASKFILE)
 #define REQ_PREEMPT	(1 << __REQ_PREEMPT)
-#define REQ_PM_SUSPEND	(1 << __REQ_PM_SUSPEND)
-#define REQ_PM_RESUME	(1 << __REQ_PM_RESUME)
-#define REQ_PM_SHUTDOWN	(1 << __REQ_PM_SHUTDOWN)
 #define REQ_BAR_PREFLUSH	(1 << __REQ_BAR_PREFLUSH)
 #define REQ_BAR_POSTFLUSH	(1 << __REQ_BAR_POSTFLUSH)
-#define REQ_BAR_FLUSH	(1 << __REQ_BAR_FLUSH)
 
 /*
- * State information carried for REQ_PM_SUSPEND and REQ_PM_RESUME
+ * State information carried for REQ_TYPE_PM_SUSPEND and REQ_TYPE_PM_RESUME
  * requests. Some step values could eventually be made generic.
  */
 struct request_pm_state
@@ -434,25 +448,28 @@
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_flushing(q)	test_bit(QUEUE_FLAG_FLUSH, &(q)->queue_flags)
 
-#define blk_fs_request(rq)	((rq)->flags & REQ_CMD)
-#define blk_pc_request(rq)	((rq)->flags & REQ_BLOCK_PC)
-#define blk_noretry_request(rq)	((rq)->flags & REQ_FAILFAST)
-#define blk_rq_started(rq)	((rq)->flags & REQ_STARTED)
+#define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
+#define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
+#define blk_special_request(rq)	((rq)->cmd_type == REQ_TYPE_SPECIAL)
+#define blk_sense_request(rq)	((rq)->cmd_type == REQ_TYPE_SENSE)
+
+#define blk_noretry_request(rq)	((rq)->cmd_flags & REQ_FAILFAST)
+#define blk_rq_started(rq)	((rq)->cmd_flags & REQ_STARTED)
 
 #define blk_account_rq(rq)	(blk_rq_started(rq) && blk_fs_request(rq))
 
-#define blk_pm_suspend_request(rq)	((rq)->flags & REQ_PM_SUSPEND)
-#define blk_pm_resume_request(rq)	((rq)->flags & REQ_PM_RESUME)
+#define blk_pm_suspend_request(rq)	((rq)->cmd_type == REQ_TYPE_PM_SUSPEND)
+#define blk_pm_resume_request(rq)	((rq)->cmd_type == REQ_TYPE_PM_RESUME)
 #define blk_pm_request(rq)	\
-	((rq)->flags & (REQ_PM_SUSPEND | REQ_PM_RESUME))
+	(blk_pm_suspend_request(rq) || blk_pm_resume_request(rq))
 
-#define blk_barrier_rq(rq)	((rq)->flags & REQ_HARDBARRIER)
-#define blk_barrier_preflush(rq)	((rq)->flags & REQ_BAR_PREFLUSH)
-#define blk_barrier_postflush(rq)	((rq)->flags & REQ_BAR_POSTFLUSH)
+#define blk_barrier_rq(rq)	((rq)->cmd_flags & REQ_HARDBARRIER)
+#define blk_barrier_preflush(rq)	((rq)->cmd_flags & REQ_BAR_PREFLUSH)
+#define blk_barrier_postflush(rq)	((rq)->cmd_flags & REQ_BAR_POSTFLUSH)
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
-#define rq_data_dir(rq)		((rq)->flags & 1)
+#define rq_data_dir(rq)		((rq)->cmd_flags & 1)
 
 static inline int blk_queue_full(struct request_queue *q, int rw)
 {
@@ -485,7 +502,7 @@
 #define RQ_NOMERGE_FLAGS	\
 	(REQ_NOMERGE | REQ_STARTED | REQ_HARDBARRIER | REQ_SOFTBARRIER)
 #define rq_mergeable(rq)	\
-	(!((rq)->flags & RQ_NOMERGE_FLAGS) && blk_fs_request((rq)))
+	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && blk_fs_request((rq)))
 
 /*
  * noop, requests are automagically marked as active/inactive by I/O
@@ -654,7 +671,7 @@
  */
 #define blk_queue_tag_depth(q)		((q)->queue_tags->busy)
 #define blk_queue_tag_queue(q)		((q)->queue_tags->busy < (q)->queue_tags->max_depth)
-#define blk_rq_tagged(rq)		((rq)->flags & REQ_QUEUED)
+#define blk_rq_tagged(rq)		((rq)->cmd_flags & REQ_QUEUED)
 extern int blk_queue_start_tag(request_queue_t *, struct request *);
 extern struct request *blk_queue_find_tag(request_queue_t *, int);
 extern void blk_queue_end_tag(request_queue_t *, struct request *);
Index: include/scsi/scsi_tcq.h
===================================================================
--- 137318b273db26b889675101fbd02d2e84cae5e3/include/scsi/scsi_tcq.h  (mode:100644)
+++ uncommitted/include/scsi/scsi_tcq.h  (mode:100644)
@@ -98,7 +98,7 @@
 	struct scsi_device *sdev = cmd->device;
 
         if (blk_rq_tagged(req)) {
-		if (sdev->ordered_tags && req->flags & REQ_HARDBARRIER)
+		if (sdev->ordered_tags && req->cmd_flags & REQ_HARDBARRIER)
         	        *msg++ = MSG_ORDERED_TAG;
         	else
         	        *msg++ = MSG_SIMPLE_TAG;

-- 
Jens Axboe

