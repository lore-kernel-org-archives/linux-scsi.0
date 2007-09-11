From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 26/27] blk_end_request: changing ide-cd (take 2)
Date: Tue, 11 Sep 2007 15:05:45 -0400 (EDT)
Message-ID: <20070911.150545.125541111.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts ide-cd (cdrom_newpc_intr()) to use blk_end_request().

Due to the oddness of the driver, the patch adds a variant of
the interface, blk_end_request_callback().

cdrom_newpc_intr() of ide-cd is the only function in the kernel tree
which needs to call end_that_request_first() and
end_that_request_last() separately.
blk_end_request_callback() allows it to pass callback function to do
something between end_that_request_first() and end_that_request_last().

ide-cd (cdrom_newpc_intr) needs to the followings:
  1. call post_transform_command() to modify request contents
  2. wait completing request until DRQ_STAT is cleared
after end_that_request_first() and before end_that_request_last().

As for the second one, ide-cd will wait for the interrupt from device.
So blk_end_request() has to return without completing request even if
no leftover in the request.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c      |   54 +++++++++++++++++++++++++++++++++
 drivers/ide/ide-cd.c   |   78 ++++++++++++++++++++++++++++++++++++++----------
 include/linux/blkdev.h |    3 +
 3 files changed, 118 insertions(+), 17 deletions(-)

diff -rupN 25-ide-normal-caller-change/block/ll_rw_blk.c 26-ide-odd-caller-change/block/ll_rw_blk.c
--- 25-ide-normal-caller-change/block/ll_rw_blk.c	2007-09-10 17:57:59.000000000 -0400
+++ 26-ide-odd-caller-change/block/ll_rw_blk.c	2007-09-10 18:21:27.000000000 -0400
@@ -3845,6 +3845,60 @@ int __blk_end_request(struct request *rq
 }
 EXPORT_SYMBOL_GPL(__blk_end_request);
 
+/**
+ * blk_end_request_callback - Special helper function for the ide-cd driver
+ * @rq:           the request being processed
+ * @uptodate:     1 for success, 0 for I/O error, < 0 for specific error
+ * @nr_bytes:     number of bytes to complete
+ * @drv_callback: function called between completion of bios in the request
+ *                and completion of the request.
+ *                If the callback returns non 0, this helper returns without
+ *                completion of the request.
+ *
+ * Description:
+ *     Ends I/O on a number of bytes attached to @rq.
+ *     If @rq has leftover, sets it up for the next range of segments.
+ *
+ *     This special helper function for the ide-cd driver is used
+ *     to complete the request only in cdrom_newpc_intr().
+ *     This interface will be removed when cdrom_newpc_intr() is rewritten.
+ *     Don't use this interface in other places.
+ *
+ * Return:
+ *     0 - we are done with this request
+ *     1 - this request is not freed yet.
+ *         this request still has pending buffers or
+ *         the ide-cd driver doesn't want to finish this request yet.
+ **/
+int blk_end_request_callback(struct request *rq, int uptodate, int nr_bytes,
+			     int (drv_callback)(struct request *))
+{
+	struct request_queue *q = rq->q;
+	unsigned long flags = 0UL;
+
+	if (blk_fs_request(rq) || blk_pc_request(rq)) {
+		if (__end_that_request_first(rq, uptodate, nr_bytes))
+			return 1;
+	}
+
+	/* Special feature for drivers/ide/ide-cd.c:cdrom_newpc_intr() */
+	if (drv_callback && drv_callback(rq))
+		return 1;
+
+	/*
+	 * No need to check the argument here because it is done
+	 * in add_disk_randomness().
+	 */
+	add_disk_randomness(rq->rq_disk);
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	complete_request(rq, uptodate);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(blk_end_request_callback);
+
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		     struct bio *bio)
 {
diff -rupN 25-ide-normal-caller-change/drivers/ide/ide-cd.c 26-ide-odd-caller-change/drivers/ide/ide-cd.c
--- 25-ide-normal-caller-change/drivers/ide/ide-cd.c	2007-09-10 18:17:38.000000000 -0400
+++ 26-ide-odd-caller-change/drivers/ide/ide-cd.c	2007-09-10 18:21:27.000000000 -0400
@@ -1675,6 +1675,37 @@ static void post_transform_command(struc
 	}
 }
 
+/*
+ * Called from blk_end_request_callback() after the data of the request
+ * is completed and before the request is completed.
+ */
+static int cdrom_newpc_intr_dma_cb(struct request *rq)
+{
+	ide_drive_t *drive = rq->q->queuedata;
+	spinlock_t *ide_lock = rq->q->queue_lock;
+	unsigned long flags = 0UL;
+
+	rq->data_len = 0;
+	post_transform_command(rq);
+
+	spin_lock_irqsave(ide_lock, flags);
+	HWGROUP(drive)->rq = NULL;
+	spin_unlock_irqrestore(ide_lock, flags);
+
+	return 0;
+}
+
+/*
+ * Called from blk_end_request_callback() after the data of the request
+ * is completed and before the request is completed.
+ * By returning value '1', blk_end_request_callback() returns immediately
+ * without completing the request.
+ */
+static int cdrom_newpc_intr_dummy_cb(struct request *rq)
+{
+	return 1;
+}
+
 typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
 
 /*
@@ -1713,9 +1744,16 @@ static ide_startstop_t cdrom_newpc_intr(
 			return ide_error(drive, "dma error", stat);
 		}
 
-		end_that_request_chunk(rq, 1, rq->data_len);
-		rq->data_len = 0;
-		goto end_request;
+		/*
+		 * post_transform_command() needs to be called after
+		 * the data of the request is completed, since it may
+		 * modify the data area of the request.
+		 * So use the callback special feature of blk_end_request().
+		 */
+		if (blk_end_request_callback(rq, 1, rq->data_len,
+					     cdrom_newpc_intr_dma_cb))
+			BUG();
+		return ide_stopped;
 	}
 
 	/*
@@ -1733,8 +1771,18 @@ static ide_startstop_t cdrom_newpc_intr(
 	/*
 	 * If DRQ is clear, the command has completed.
 	 */
-	if ((stat & DRQ_STAT) == 0)
-		goto end_request;
+	if ((stat & DRQ_STAT) == 0) {
+		if (!rq->data_len)
+			post_transform_command(rq);
+
+		spin_lock_irqsave(&ide_lock, flags);
+		if (__blk_end_request(rq, 1, 0))
+			BUG();
+		HWGROUP(drive)->rq = NULL;
+		spin_unlock_irqrestore(&ide_lock, flags);
+
+		return ide_stopped;
+	}
 
 	/*
 	 * check which way to transfer data
@@ -1787,7 +1835,14 @@ static ide_startstop_t cdrom_newpc_intr(
 		rq->data_len -= blen;
 
 		if (rq->bio)
-			end_that_request_chunk(rq, 1, blen);
+			/*
+	 		 * The request can't be completed until DRQ is cleared.
+			 * So complete the data, but don't complete the request
+			 * using the dummy function for the callback feature
+			 * of blk_end_request().
+			 */
+			blk_end_request_callback(rq, 1, blen,
+						 cdrom_newpc_intr_dummy_cb);
 		else
 			rq->data += blen;
 	}
@@ -1808,17 +1863,6 @@ static ide_startstop_t cdrom_newpc_intr(
 
 	ide_set_handler(drive, cdrom_newpc_intr, rq->timeout, NULL);
 	return ide_started;
-
-end_request:
-	if (!rq->data_len)
-		post_transform_command(rq);
-
-	spin_lock_irqsave(&ide_lock, flags);
-	blkdev_dequeue_request(rq);
-	end_that_request_last(rq, 1);
-	HWGROUP(drive)->rq = NULL;
-	spin_unlock_irqrestore(&ide_lock, flags);
-	return ide_stopped;
 }
 
 static ide_startstop_t cdrom_write_intr(ide_drive_t *drive)
diff -rupN 25-ide-normal-caller-change/include/linux/blkdev.h 26-ide-odd-caller-change/include/linux/blkdev.h
--- 25-ide-normal-caller-change/include/linux/blkdev.h	2007-09-10 17:44:43.000000000 -0400
+++ 26-ide-odd-caller-change/include/linux/blkdev.h	2007-09-10 18:21:27.000000000 -0400
@@ -734,6 +734,9 @@ extern int end_that_request_chunk(struct
 extern void end_that_request_last(struct request *, int);
 extern void end_request(struct request *, int);
 extern void end_queued_request(struct request *, int);
+extern int blk_end_request_callback(struct request *rq, int uptodate,
+				    int nr_bytes,
+				    int (drv_callback)(struct request *));
 extern void blk_complete_request(struct request *);
 
 /*
