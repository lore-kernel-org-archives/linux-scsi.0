From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/18] ataflop: dequeue and track in-flight request
Date: Fri,  8 May 2009 11:54:03 +0900
Message-ID: <1241751256-17435-6-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:36180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbZEHC4K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2009 22:56:10 -0400
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.c
Cc: Tejun Heo <tj@kernel.org>

ataflop has single request in flight.  Till now, whenever it needs to
access the in-flight request it called elv_next_request().  This patch
makes ataflop track the in-flight request directly and dequeue it when
processing starts.  The added complexity is minimal and this will help
future block layer changes.

[ Impact: dequeue in-flight request, one elv_next_request() per request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/ataflop.c |   63 ++++++++++++++++++++++++++---------------------
 1 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 234024c..89a591d 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -79,9 +79,7 @@
 #undef DEBUG
 
 static struct request_queue *floppy_queue;
-
-#define QUEUE (floppy_queue)
-#define CURRENT elv_next_request(floppy_queue)
+static struct request *fd_request;
 
 /* Disk types: DD, HD, ED */
 static struct atari_disk_type {
@@ -376,6 +374,12 @@ static DEFINE_TIMER(readtrack_timer, fd_readtrack_check, 0, 0);
 static DEFINE_TIMER(timeout_timer, fd_times_out, 0, 0);
 static DEFINE_TIMER(fd_timer, check_change, 0, 0);
 	
+static void fd_end_request_cur(int err)
+{
+	if (!__blk_end_request_cur(fd_request, err))
+		fd_request = NULL;
+}
+
 static inline void start_motor_off_timer(void)
 {
 	mod_timer(&motor_off_timer, jiffies + FD_MOTOR_OFF_DELAY);
@@ -606,15 +610,15 @@ static void fd_error( void )
 		return;
 	}
 
-	if (!CURRENT)
+	if (!fd_request)
 		return;
 
-	CURRENT->errors++;
-	if (CURRENT->errors >= MAX_ERRORS) {
+	fd_request->errors++;
+	if (fd_request->errors >= MAX_ERRORS) {
 		printk(KERN_ERR "fd%d: too many errors.\n", SelectedDrive );
-		__blk_end_request_cur(CURRENT, -EIO);
+		fd_end_request_cur(-EIO);
 	}
-	else if (CURRENT->errors == RECALIBRATE_ERRORS) {
+	else if (fd_request->errors == RECALIBRATE_ERRORS) {
 		printk(KERN_WARNING "fd%d: recalibrating\n", SelectedDrive );
 		if (SelectedDrive != -1)
 			SUD.track = -1;
@@ -725,14 +729,14 @@ static void do_fd_action( int drive )
 	    if (IS_BUFFERED( drive, ReqSide, ReqTrack )) {
 		if (ReqCmd == READ) {
 		    copy_buffer( SECTOR_BUFFER(ReqSector), ReqData );
-		    if (++ReqCnt < blk_rq_cur_sectors(CURRENT)) {
+		    if (++ReqCnt < blk_rq_cur_sectors(fd_request)) {
 			/* read next sector */
 			setup_req_params( drive );
 			goto repeat;
 		    }
 		    else {
 			/* all sectors finished */
-			__blk_end_request_cur(CURRENT, 0);
+			fd_end_request_cur(0);
 			redo_fd_request();
 			return;
 		    }
@@ -1130,14 +1134,14 @@ static void fd_rwsec_done1(int status)
 		}
 	}
   
-	if (++ReqCnt < blk_rq_cur_sectors(CURRENT)) {
+	if (++ReqCnt < blk_rq_cur_sectors(fd_request)) {
 		/* read next sector */
 		setup_req_params( SelectedDrive );
 		do_fd_action( SelectedDrive );
 	}
 	else {
 		/* all sectors finished */
-		__blk_end_request_cur(CURRENT, 0);
+		fd_end_request_cur(0);
 		redo_fd_request();
 	}
 	return;
@@ -1378,7 +1382,7 @@ static void setup_req_params( int drive )
 	ReqData = ReqBuffer + 512 * ReqCnt;
 
 	if (UseTrackbuffer)
-		read_track = (ReqCmd == READ && CURRENT->errors == 0);
+		read_track = (ReqCmd == READ && fd_request->errors == 0);
 	else
 		read_track = 0;
 
@@ -1392,25 +1396,28 @@ static void redo_fd_request(void)
 	int drive, type;
 	struct atari_floppy_struct *floppy;
 
-	DPRINT(("redo_fd_request: CURRENT=%p dev=%s CURRENT->sector=%ld\n",
-		CURRENT, CURRENT ? CURRENT->rq_disk->disk_name : "",
-		CURRENT ? blk_rq_pos(CURRENT) : 0 ));
+	DPRINT(("redo_fd_request: fd_request=%p dev=%s fd_request->sector=%ld\n",
+		fd_request, fd_request ? fd_request->rq_disk->disk_name : "",
+		fd_request ? blk_rq_pos(fd_request) : 0 ));
 
 	IsFormatting = 0;
 
 repeat:
+	if (!fd_request) {
+		fd_request = elv_next_request(floppy_queue);
+		if (!fd_request)
+			goto the_end;
+		blkdev_dequeue_request(fd_request);
+	}
 
-	if (!CURRENT)
-		goto the_end;
-
-	floppy = CURRENT->rq_disk->private_data;
+	floppy = fd_request->rq_disk->private_data;
 	drive = floppy - unit;
 	type = floppy->type;
 	
 	if (!UD.connected) {
 		/* drive not connected */
 		printk(KERN_ERR "Unknown Device: fd%d\n", drive );
-		__blk_end_request_cur(CURRENT, -EIO);
+		fd_end_request_cur(-EIO);
 		goto repeat;
 	}
 		
@@ -1426,12 +1433,12 @@ repeat:
 		/* user supplied disk type */
 		if (--type >= NUM_DISK_MINORS) {
 			printk(KERN_WARNING "fd%d: invalid disk format", drive );
-			__blk_end_request_cur(CURRENT, -EIO);
+			fd_end_request_cur(-EIO);
 			goto repeat;
 		}
 		if (minor2disktype[type].drive_types > DriveType)  {
 			printk(KERN_WARNING "fd%d: unsupported disk format", drive );
-			__blk_end_request_cur(CURRENT, -EIO);
+			fd_end_request_cur(-EIO);
 			goto repeat;
 		}
 		type = minor2disktype[type].index;
@@ -1440,8 +1447,8 @@ repeat:
 		UD.autoprobe = 0;
 	}
 	
-	if (blk_rq_pos(CURRENT) + 1 > UDT->blocks) {
-		__blk_end_request_cur(CURRENT, -EIO);
+	if (blk_rq_pos(fd_request) + 1 > UDT->blocks) {
+		fd_end_request_cur(-EIO);
 		goto repeat;
 	}
 
@@ -1449,9 +1456,9 @@ repeat:
 	del_timer( &motor_off_timer );
 		
 	ReqCnt = 0;
-	ReqCmd = rq_data_dir(CURRENT);
-	ReqBlock = blk_rq_pos(CURRENT);
-	ReqBuffer = CURRENT->buffer;
+	ReqCmd = rq_data_dir(fd_request);
+	ReqBlock = blk_rq_pos(fd_request);
+	ReqBuffer = fd_request->buffer;
 	setup_req_params( drive );
 	do_fd_action( drive );
 
-- 
1.6.0.2

