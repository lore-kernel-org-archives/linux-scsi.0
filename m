From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 18/30] blk_end_request: changing s390 (take 4)
Date: Tue, 11 Dec 2007 17:48:51 -0500 (EST)
Message-ID: <20071211.174851.98715511.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, linux390@de.ibm.com
List-Id: linux-scsi@vger.kernel.org

This patch converts s390 to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

As a result, the interfaces of internal functions below are changed:
  o dasd_end_request
  o tapeblock_end_request

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/s390/block/dasd.c      |   19 ++++++++++---------
 drivers/s390/char/tape_block.c |   13 ++++++-------
 2 files changed, 16 insertions(+), 16 deletions(-)

Index: 2.6.24-rc4/drivers/s390/block/dasd.c
===================================================================
--- 2.6.24-rc4.orig/drivers/s390/block/dasd.c
+++ 2.6.24-rc4/drivers/s390/block/dasd.c
@@ -1078,12 +1078,10 @@ dasd_int_handler(struct ccw_device *cdev
  * posts the buffer_cache about a finalized request
  */
 static inline void
-dasd_end_request(struct request *req, int uptodate)
+dasd_end_request(struct request *req, int error)
 {
-	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+	if (__blk_end_request(req, error, blk_rq_bytes(req)))
 		BUG();
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
 }
 
 /*
@@ -1170,13 +1168,16 @@ dasd_end_request_cb(struct dasd_ccw_req 
 	struct request *req;
 	struct dasd_device *device;
 	int status;
+	int error = 0;
 
 	req = (struct request *) data;
 	device = cqr->device;
 	dasd_profile_end(device, cqr, req);
 	status = cqr->device->discipline->free_cp(cqr,req);
+	if (status <= 0)
+		error = status ? status : -EIO;
 	spin_lock_irq(&device->request_queue_lock);
-	dasd_end_request(req, status);
+	dasd_end_request(req, error);
 	spin_unlock_irq(&device->request_queue_lock);
 }
 
@@ -1223,12 +1224,12 @@ __dasd_process_blk_queue(struct dasd_dev
 				      "Rejecting write request %p",
 				      req);
 			blkdev_dequeue_request(req);
-			dasd_end_request(req, 0);
+			dasd_end_request(req, -EIO);
 			continue;
 		}
 		if (device->stopped & DASD_STOPPED_DC_EIO) {
 			blkdev_dequeue_request(req);
-			dasd_end_request(req, 0);
+			dasd_end_request(req, -EIO);
 			continue;
 		}
 		cqr = device->discipline->build_cp(device, req);
@@ -1253,7 +1254,7 @@ __dasd_process_blk_queue(struct dasd_dev
 				      "on request %p",
 				      PTR_ERR(cqr), req);
 			blkdev_dequeue_request(req);
-			dasd_end_request(req, 0);
+			dasd_end_request(req, -EIO);
 			continue;
 		}
 		cqr->callback = dasd_end_request_cb;
@@ -1821,7 +1822,7 @@ dasd_flush_request_queue(struct dasd_dev
 	spin_lock_irq(&device->request_queue_lock);
 	while ((req = elv_next_request(device->request_queue))) {
 		blkdev_dequeue_request(req);
-		dasd_end_request(req, 0);
+		dasd_end_request(req, -EIO);
 	}
 	spin_unlock_irq(&device->request_queue_lock);
 }
Index: 2.6.24-rc4/drivers/s390/char/tape_block.c
===================================================================
--- 2.6.24-rc4.orig/drivers/s390/char/tape_block.c
+++ 2.6.24-rc4/drivers/s390/char/tape_block.c
@@ -74,11 +74,10 @@ tapeblock_trigger_requeue(struct tape_de
  * Post finished request.
  */
 static void
-tapeblock_end_request(struct request *req, int uptodate)
+tapeblock_end_request(struct request *req, int error)
 {
-	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+	if (__blk_end_request(req, error, blk_rq_bytes(req)))
 		BUG();
-	end_that_request_last(req, uptodate);
 }
 
 static void
@@ -91,7 +90,7 @@ __tapeblock_end_request(struct tape_requ
 
 	device = ccw_req->device;
 	req = (struct request *) data;
-	tapeblock_end_request(req, ccw_req->rc == 0);
+	tapeblock_end_request(req, (ccw_req->rc == 0) ? 0 : -EIO);
 	if (ccw_req->rc == 0)
 		/* Update position. */
 		device->blk_data.block_position =
@@ -119,7 +118,7 @@ tapeblock_start_request(struct tape_devi
 	ccw_req = device->discipline->bread(device, req);
 	if (IS_ERR(ccw_req)) {
 		DBF_EVENT(1, "TBLOCK: bread failed\n");
-		tapeblock_end_request(req, 0);
+		tapeblock_end_request(req, -EIO);
 		return PTR_ERR(ccw_req);
 	}
 	ccw_req->callback = __tapeblock_end_request;
@@ -132,7 +131,7 @@ tapeblock_start_request(struct tape_devi
 		 * Start/enqueueing failed. No retries in
 		 * this case.
 		 */
-		tapeblock_end_request(req, 0);
+		tapeblock_end_request(req, -EIO);
 		device->discipline->free_bread(ccw_req);
 	}
 
@@ -177,7 +176,7 @@ tapeblock_requeue(struct work_struct *wo
 		if (rq_data_dir(req) == WRITE) {
 			DBF_EVENT(1, "TBLOCK: Rejecting write request\n");
 			blkdev_dequeue_request(req);
-			tapeblock_end_request(req, 0);
+			tapeblock_end_request(req, -EIO);
 			continue;
 		}
 		spin_unlock_irq(&device->blk_data.request_queue_lock);
