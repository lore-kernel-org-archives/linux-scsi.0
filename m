From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 26/28] blk_end_request: changing ide-cd (take 3)
Date: Fri, 30 Nov 2007 18:34:47 -0500 (EST)
Message-ID: <20071130.183447.82055860.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts ide-cd (cdrom_newpc_intr()) to use blk_end_request().

ide-cd (cdrom_newpc_intr()) has some tricky behaviors below which
need to use blk_end_request_callback().
Needs to:
  1. call post_transform_command() to modify request contents
  2. wait completing request until DRQ_STAT is cleared
after end_that_request_first() and before end_that_request_last().

As for the second one, ide-cd will wait for the interrupt from device.
So blk_end_request_callback() has to return without completing request
even if no leftover in the request.
ide-cd uses a dummy callback function, which just returns value '1',
to tell blk_end_request_callback() about that.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/ide/ide-cd.c |   78 +++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 61 insertions(+), 17 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/ide/ide-cd.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/ide/ide-cd.c
+++ 2.6.24-rc3-mm2/drivers/ide/ide-cd.c
@@ -1669,6 +1669,37 @@ static void post_transform_command(struc
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
@@ -1707,9 +1738,16 @@ static ide_startstop_t cdrom_newpc_intr(
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
@@ -1727,8 +1765,18 @@ static ide_startstop_t cdrom_newpc_intr(
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
@@ -1781,7 +1829,14 @@ static ide_startstop_t cdrom_newpc_intr(
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
@@ -1802,17 +1857,6 @@ static ide_startstop_t cdrom_newpc_intr(
 
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
