From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/11] block: implement blk_rq_pos/[cur_]sectors() and convert obvious ones
Date: Mon,  4 May 2009 16:58:40 +0900
Message-ID: <1241423927-11871-5-git-send-email-tj@kernel.org>
References: <1241423927-11871-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:57226 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbZEDIJj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2009 04:09:39 -0400
In-Reply-To: <1241423927-11871-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petko
Cc: Tejun Heo <tj@kernel.org>

Implement accessors - blk_rq_pos(), blk_rq_sectors() and
blk_rq_cur_sectors() which return rq->sector, rq->hard_nr_sectors and
rq->hard_cur_sectors respectively and convert direct references of the
said fields to the accessors.

This is in preparation of request data length handling cleanup.

const added to struct request * parameter to accessors as suggested by
Geert Uytterhoeven.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/blk-barrier.c             |    2 +-
 block/blk-core.c                |    2 +-
 block/cfq-iosched.c             |    2 +-
 drivers/block/ps3disk.c         |    2 +-
 drivers/block/viodasd.c         |    6 +++---
 drivers/block/xsysace.c         |   10 +++++-----
 drivers/ide/ide-cd.c            |    8 ++++----
 drivers/ide/ide-io.c            |    4 ++--
 drivers/message/i2o/i2o_block.c |    2 +-
 drivers/scsi/scsi_lib.c         |    2 +-
 include/linux/blkdev.h          |   23 ++++++++++++++++++++---
 kernel/trace/blktrace.c         |    4 ++--
 12 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index c8d0876..c167de5 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -163,7 +163,7 @@ static inline bool start_ordered(struct request_queue *q, struct request **rqp)
 	 * For an empty barrier, there's no actual BAR request, which
 	 * in turn makes POSTFLUSH unnecessary.  Mask them off.
 	 */
-	if (!rq->hard_nr_sectors) {
+	if (!blk_rq_sectors(rq)) {
 		q->ordered &= ~(QUEUE_ORDERED_DO_BAR |
 				QUEUE_ORDERED_DO_POSTFLUSH);
 		/*
diff --git a/block/blk-core.c b/block/blk-core.c
index 394c5bd..895e55b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1683,7 +1683,7 @@ static void blk_account_io_done(struct request *req)
 unsigned int blk_rq_bytes(struct request *rq)
 {
 	if (blk_fs_request(rq))
-		return rq->hard_nr_sectors << 9;
+		return blk_rq_sectors(rq) << 9;
 
 	return rq->data_len;
 }
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index def0c69..575083a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -760,7 +760,7 @@ static void cfq_activate_request(struct request_queue *q, struct request *rq)
 	cfq_log_cfqq(cfqd, RQ_CFQQ(rq), "activate rq, drv=%d",
 						cfqd->rq_in_driver);
 
-	cfqd->last_position = rq->hard_sector + rq->hard_nr_sectors;
+	cfqd->last_position = blk_rq_pos(rq) + blk_rq_sectors(rq);
 }
 
 static void cfq_deactivate_request(struct request_queue *q, struct request *rq)
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index f6586e4..c238867 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -136,7 +136,7 @@ static int ps3disk_submit_request_sg(struct ps3_storage_device *dev,
 	dev_dbg(&dev->sbd.core,
 		"%s:%u: %s req has %u bvecs for %lu sectors %lu hard sectors\n",
 		__func__, __LINE__, op, n, req->nr_sectors,
-		req->hard_nr_sectors);
+		blk_rq_sectors(req));
 #endif
 
 	start_sector = req->sector * priv->blocking_factor;
diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
index ecccf65..e821eed 100644
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -368,12 +368,12 @@ static void do_viodasd_request(struct request_queue *q)
 		blkdev_dequeue_request(req);
 		/* check that request contains a valid command */
 		if (!blk_fs_request(req)) {
-			viodasd_end_request(req, -EIO, req->hard_nr_sectors);
+			viodasd_end_request(req, -EIO, blk_rq_sectors(req));
 			continue;
 		}
 		/* Try sending the request */
 		if (send_request(req) != 0)
-			viodasd_end_request(req, -EIO, req->hard_nr_sectors);
+			viodasd_end_request(req, -EIO, blk_rq_sectors(req));
 	}
 }
 
@@ -590,7 +590,7 @@ static int viodasd_handle_read_write(struct vioblocklpevent *bevent)
 		err = vio_lookup_rc(viodasd_err_table, bevent->sub_result);
 		printk(VIOD_KERN_WARNING "read/write error %d:0x%04x (%s)\n",
 				event->xRc, bevent->sub_result, err->msg);
-		num_sect = req->hard_nr_sectors;
+		num_sect = blk_rq_sectors(req);
 	}
 	qlock = req->q->queue_lock;
 	spin_lock_irqsave(qlock, irq_flags);
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index b1e1d7e..5722931 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -645,8 +645,8 @@ static void ace_fsm_dostate(struct ace_device *ace)
 
 		/* Okay, it's a data request, set it up for transfer */
 		dev_dbg(ace->dev,
-			"request: sec=%llx hcnt=%lx, ccnt=%x, dir=%i\n",
-			(unsigned long long) req->sector, req->hard_nr_sectors,
+			"request: sec=%llx hcnt=%x, ccnt=%x, dir=%i\n",
+			(unsigned long long) req->sector, blk_rq_sectors(req),
 			req->current_nr_sectors, rq_data_dir(req));
 
 		ace->req = req;
@@ -654,7 +654,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		ace->data_count = req->current_nr_sectors * ACE_BUF_PER_SECTOR;
 		ace_out32(ace, ACE_MPULBA, req->sector & 0x0FFFFFFF);
 
-		count = req->hard_nr_sectors;
+		count = blk_rq_sectors(req);
 		if (rq_data_dir(req)) {
 			/* Kick off write request */
 			dev_dbg(ace->dev, "write data\n");
@@ -719,8 +719,8 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		/* bio finished; is there another one? */
 		if (__blk_end_request(ace->req, 0,
 					blk_rq_cur_bytes(ace->req))) {
-			/* dev_dbg(ace->dev, "next block; h=%li c=%i\n",
-			 *      ace->req->hard_nr_sectors,
+			/* dev_dbg(ace->dev, "next block; h=%u c=%u\n",
+			 *      blk_rq_sectors(ace->req),
 			 *      ace->req->current_nr_sectors);
 			 */
 			ace->data_ptr = ace->req->buffer;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index cc8ac5b..474b283 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -729,7 +729,7 @@ out_end:
 		if (blk_pc_request(rq))
 			nsectors = (rq->data_len + 511) >> 9;
 		else
-			nsectors = rq->hard_nr_sectors;
+			nsectors = blk_rq_sectors(rq);
 
 		if (nsectors == 0)
 			nsectors = 1;
@@ -874,7 +874,7 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 
 	return ide_issue_pc(drive, &cmd);
 out_end:
-	nsectors = rq->hard_nr_sectors;
+	nsectors = blk_rq_sectors(rq);
 
 	if (nsectors == 0)
 		nsectors = 1;
@@ -1358,8 +1358,8 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 static int ide_cdrom_prep_fs(struct request_queue *q, struct request *rq)
 {
 	int hard_sect = queue_hardsect_size(q);
-	long block = (long)rq->hard_sector / (hard_sect >> 9);
-	unsigned long blocks = rq->hard_nr_sectors / (hard_sect >> 9);
+	long block = (long)blk_rq_pos(rq) / (hard_sect >> 9);
+	unsigned long blocks = blk_rq_sectors(rq) / (hard_sect >> 9);
 
 	memset(rq->cmd, 0, BLK_MAX_CDB);
 
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index a0309ea..df23bcb 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -118,7 +118,7 @@ unsigned int ide_rq_bytes(struct request *rq)
 	if (blk_pc_request(rq))
 		return rq->data_len;
 	else
-		return rq->hard_cur_sectors << 9;
+		return blk_rq_cur_sectors(rq) << 9;
 }
 EXPORT_SYMBOL_GPL(ide_rq_bytes);
 
@@ -133,7 +133,7 @@ int ide_complete_rq(ide_drive_t *drive, int error, unsigned int nr_bytes)
 	 * and complete the whole request right now
 	 */
 	if (blk_noretry_request(rq) && error <= 0)
-		nr_bytes = rq->hard_nr_sectors << 9;
+		nr_bytes = blk_rq_sectors(rq) << 9;
 
 	rc = ide_end_rq(drive, rq, error, nr_bytes);
 	if (rc == 0)
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index 221317e..56e60f0 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -427,7 +427,7 @@ static void i2o_block_end_request(struct request *req, int error,
 	unsigned long flags;
 
 	if (blk_end_request(req, error, nr_bytes)) {
-		int leftover = (req->hard_nr_sectors << KERNEL_SECTOR_SHIFT);
+		int leftover = (blk_rq_sectors(req) << KERNEL_SECTOR_SHIFT);
 
 		if (blk_pc_request(req))
 			leftover = req->data_len;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7d49ef5..9ff0ca9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -546,7 +546,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
 	 * to queue the remainder of them.
 	 */
 	if (blk_end_request(req, error, bytes)) {
-		int leftover = (req->hard_nr_sectors << 9);
+		int leftover = blk_rq_sectors(req) << 9;
 
 		if (blk_pc_request(req))
 			leftover = req->resid_len;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7ab93d9..b921d91 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -833,13 +833,30 @@ static inline void blk_run_address_space(struct address_space *mapping)
 extern void blkdev_dequeue_request(struct request *req);
 
 /*
- * blk_end_request() takes bytes instead of sectors as a complete size.
- * blk_rq_bytes() returns bytes left to complete in the entire request.
- * blk_rq_cur_bytes() returns bytes left to complete in the current segment.
+ * blk_rq_pos()		: the current sector
+ * blk_rq_bytes()	: bytes left in the entire request
+ * blk_rq_cur_bytes()	: bytes left in the current segment
+ * blk_rq_sectors()	: sectors left in the entire request
+ * blk_rq_cur_sectors()	: sectors left in the current segment
  */
+static inline sector_t blk_rq_pos(const struct request *rq)
+{
+	return rq->hard_sector;
+}
+
 extern unsigned int blk_rq_bytes(struct request *rq);
 extern unsigned int blk_rq_cur_bytes(struct request *rq);
 
+static inline unsigned int blk_rq_sectors(const struct request *rq)
+{
+	return rq->hard_nr_sectors;
+}
+
+static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
+{
+	return rq->hard_cur_sectors;
+}
+
 /*
  * Request completion related functions.
  *
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 921ef5d..42f1c11 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -646,7 +646,7 @@ static void blk_add_trace_rq(struct request_queue *q, struct request *rq,
 				rq->cmd_len, rq->cmd);
 	} else  {
 		what |= BLK_TC_ACT(BLK_TC_FS);
-		__blk_add_trace(bt, rq->hard_sector, rq->hard_nr_sectors << 9,
+		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_sectors(rq) << 9,
 				rw, what, rq->errors, 0, NULL);
 	}
 }
@@ -857,7 +857,7 @@ void blk_add_driver_data(struct request_queue *q,
 		__blk_add_trace(bt, 0, rq->data_len, 0, BLK_TA_DRV_DATA,
 				rq->errors, len, data);
 	else
-		__blk_add_trace(bt, rq->hard_sector, rq->hard_nr_sectors << 9,
+		__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_sectors(rq) << 9,
 				0, BLK_TA_DRV_DATA, rq->errors, len, data);
 }
 EXPORT_SYMBOL_GPL(blk_add_driver_data);
-- 
1.6.0.2

