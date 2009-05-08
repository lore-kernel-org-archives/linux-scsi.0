From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/18] amiflop: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:08 +0900
Message-ID: <1241751256-17435-11-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:36200 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078AbZEHC4O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2009 22:56:14 -0400
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.c
Cc: Tejun Heo <tj@kernel.org>

Request processing in amiflop is done sequentially in
redo_fd_request() proper and redo_fd_request() can easily be converted
to track in-flight request.  Remove CURRENT, track in-flight request
directly and dequeue it when processing starts.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/amiflop.c |   48 +++++++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index e4a14b9..80a68b2 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -112,8 +112,6 @@ module_param(fd_def_df0, ulong, 0);
 MODULE_LICENSE("GPL");
 
 static struct request_queue *floppy_queue;
-#define QUEUE (floppy_queue)
-#define CURRENT elv_next_request(floppy_queue)
 
 /*
  *  Macros
@@ -1335,59 +1333,61 @@ static int get_track(int drive, int track)
 
 static void redo_fd_request(void)
 {
+	struct request *rq;
 	unsigned int cnt, block, track, sector;
 	int drive;
 	struct amiga_floppy_struct *floppy;
 	char *data;
 	unsigned long flags;
+	int err;
 
- repeat:
-	if (!CURRENT) {
+next_req:
+	rq = elv_next_request(floppy_queue);
+	if (!rq) {
 		/* Nothing left to do */
 		return;
 	}
+	blkdev_dequeue_request(rq);
 
-	floppy = CURRENT->rq_disk->private_data;
+	floppy = rq->rq_disk->private_data;
 	drive = floppy - unit;
 
+next_segment:
 	/* Here someone could investigate to be more efficient */
-	for (cnt = 0; cnt < blk_rq_cur_sectors(CURRENT); cnt++) {
+	for (cnt = 0, err = 0; cnt < blk_rq_cur_sectors(rq); cnt++) {
 #ifdef DEBUG
 		printk("fd: sector %ld + %d requested for %s\n",
-		       blk_rq_pos(CURRENT), cnt,
-		       (rq_data_dir(CURRENT) == READ) ? "read" : "write");
+		       blk_rq_pos(rq), cnt,
+		       (rq_data_dir(rq) == READ) ? "read" : "write");
 #endif
-		block = blk_rq_pos(CURRENT) + cnt;
+		block = blk_rq_pos(rq) + cnt;
 		if ((int)block > floppy->blocks) {
-			__blk_end_request_cur(CURRENT, -EIO);
-			goto repeat;
+			err = -EIO;
+			break;
 		}
 
 		track = block / (floppy->dtype->sects * floppy->type->sect_mult);
 		sector = block % (floppy->dtype->sects * floppy->type->sect_mult);
-		data = CURRENT->buffer + 512 * cnt;
+		data = rq->buffer + 512 * cnt;
 #ifdef DEBUG
 		printk("access to track %d, sector %d, with buffer at "
 		       "0x%08lx\n", track, sector, data);
 #endif
 
 		if (get_track(drive, track) == -1) {
-			__blk_end_request_cur(CURRENT, -EIO);
-			goto repeat;
+			err = -EIO;
+			break;
 		}
 
-		switch (rq_data_dir(CURRENT)) {
-		case READ:
+		if (rq_data_dir(rq) == READ) {
 			memcpy(data, floppy->trackbuf + sector * 512, 512);
-			break;
-
-		case WRITE:
+		} else {
 			memcpy(floppy->trackbuf + sector * 512, data, 512);
 
 			/* keep the drive spinning while writes are scheduled */
 			if (!fd_motor_on(drive)) {
-				__blk_end_request_cur(CURRENT, -EIO);
-				goto repeat;
+				err = -EIO;
+				break;
 			}
 			/*
 			 * setup a callback to write the track buffer
@@ -1399,12 +1399,12 @@ static void redo_fd_request(void)
 		        /* reset the timer */
 			mod_timer (flush_track_timer + drive, jiffies + 1);
 			local_irq_restore(flags);
-			break;
 		}
 	}
 
-	__blk_end_request_cur(CURRENT, 0);
-	goto repeat;
+	if (__blk_end_request_cur(rq, err))
+		goto next_segment;
+	goto next_req;
 }
 
 static void do_fd_request(struct request_queue * q)
-- 
1.6.0.2

