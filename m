From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 23/30] blk_end_request: changing ide normal
	caller (take 4)
Date: Tue, 11 Dec 2007 17:50:41 -0500 (EST)
Message-ID: <20071211.175041.15586071.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com
Cc: bzolnier@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts "normal" parts of ide to use blk_end_request
interfaces.  Related 'uptodate' arguments are converted to 'error'.

The conversion of 'uptodate' to 'error' is done only for the internal
function, __ide_end_request().
ide_end_request() was not changed since it's exported and used
by many ide drivers.


With this patch, blkdev_dequeue_request() in __ide_end_request() is
moved to blk_end_request, since blk_end_request takes care of
dequeueing request like below:

	if (!list_empty(&rq->queuelist))
		blkdev_dequeue_request(rq);

In the case of ide,
  o 'dequeue' variable of __ide_end_request() is 1 only when the request
    is still linked to the queue (i.e. rq->queuelist is not empty)
  o 'dequeue' variable of __ide_end_request() is 0 only when the request
    has already been removed from the queue (i.e. rq->queuelist is empty)
So blk_end_request can handle it correctly although ide always run
thought the code above.

Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/ide/ide-cd.c |    6 +++---
 drivers/ide/ide-io.c |   25 ++++++++++++-------------
 2 files changed, 15 insertions(+), 16 deletions(-)

Index: 2.6.24-rc4/drivers/ide/ide-cd.c
===================================================================
--- 2.6.24-rc4.orig/drivers/ide/ide-cd.c
+++ 2.6.24-rc4/drivers/ide/ide-cd.c
@@ -655,9 +655,9 @@ static void cdrom_end_request (ide_drive
 					BUG();
 			} else {
 				spin_lock_irqsave(&ide_lock, flags);
-				end_that_request_chunk(failed, 0,
-							failed->data_len);
-				end_that_request_last(failed, 0);
+				if (__blk_end_request(failed, -EIO,
+						      failed->data_len))
+					BUG();
 				spin_unlock_irqrestore(&ide_lock, flags);
 			}
 		} else
Index: 2.6.24-rc4/drivers/ide/ide-io.c
===================================================================
--- 2.6.24-rc4.orig/drivers/ide/ide-io.c
+++ 2.6.24-rc4/drivers/ide/ide-io.c
@@ -58,15 +58,19 @@ static int __ide_end_request(ide_drive_t
 			     int uptodate, unsigned int nr_bytes, int dequeue)
 {
 	int ret = 1;
+	int error = 0;
+
+	if (uptodate <= 0)
+		error = uptodate ? uptodate : -EIO;
 
 	/*
 	 * if failfast is set on a request, override number of sectors and
 	 * complete the whole request right now
 	 */
-	if (blk_noretry_request(rq) && end_io_error(uptodate))
+	if (blk_noretry_request(rq) && error)
 		nr_bytes = rq->hard_nr_sectors << 9;
 
-	if (!blk_fs_request(rq) && end_io_error(uptodate) && !rq->errors)
+	if (!blk_fs_request(rq) && error && !rq->errors)
 		rq->errors = -EIO;
 
 	/*
@@ -78,14 +82,9 @@ static int __ide_end_request(ide_drive_t
 		HWGROUP(drive)->hwif->ide_dma_on(drive);
 	}
 
-	if (!end_that_request_chunk(rq, uptodate, nr_bytes)) {
-		add_disk_randomness(rq->rq_disk);
-		if (dequeue) {
-			if (!list_empty(&rq->queuelist))
-				blkdev_dequeue_request(rq);
+	if (!__blk_end_request(rq, error, nr_bytes)) {
+		if (dequeue)
 			HWGROUP(drive)->rq = NULL;
-		}
-		end_that_request_last(rq, uptodate);
 		ret = 0;
 	}
 
@@ -292,9 +291,9 @@ static void ide_complete_pm_request (ide
 		drive->blocked = 0;
 		blk_start_queue(drive->queue);
 	}
-	blkdev_dequeue_request(rq);
 	HWGROUP(drive)->rq = NULL;
-	end_that_request_last(rq, 1);
+	if (__blk_end_request(rq, 0, 0))
+		BUG();
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
@@ -391,10 +390,10 @@ void ide_end_drive_cmd (ide_drive_t *dri
 	}
 
 	spin_lock_irqsave(&ide_lock, flags);
-	blkdev_dequeue_request(rq);
 	HWGROUP(drive)->rq = NULL;
 	rq->errors = err;
-	end_that_request_last(rq, !rq->errors);
+	if (__blk_end_request(rq, (rq->errors ? -EIO : 0), 0))
+		BUG();
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
