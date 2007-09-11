From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 25/27] blk_end_request: changing ide normal
	caller (take 2)
Date: Tue, 11 Sep 2007 15:05:12 -0400 (EDT)
Message-ID: <20070911.150512.71159498.k-ueda@ct.jp.nec.com>
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

This patch converts "normal" parts of ide to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/ide/ide-cd.c |    6 +++---
 drivers/ide/ide-io.c |   22 +++++++---------------
 2 files changed, 10 insertions(+), 18 deletions(-)

diff -rupN 24-cpqarray-caller-change/drivers/ide/ide-cd.c 25-ide-normal-caller-change/drivers/ide/ide-cd.c
--- 24-cpqarray-caller-change/drivers/ide/ide-cd.c	2007-08-27 21:32:35.000000000 -0400
+++ 25-ide-normal-caller-change/drivers/ide/ide-cd.c	2007-09-10 18:17:38.000000000 -0400
@@ -655,9 +655,9 @@ static void cdrom_end_request (ide_drive
 					BUG();
 			} else {
 				spin_lock_irqsave(&ide_lock, flags);
-				end_that_request_chunk(failed, 0,
-							failed->data_len);
-				end_that_request_last(failed, 0);
+				if (__blk_end_request(failed, 0,
+						      failed->data_len))
+					BUG();
 				spin_unlock_irqrestore(&ide_lock, flags);
 			}
 		} else
diff -rupN 24-cpqarray-caller-change/drivers/ide/ide-io.c 25-ide-normal-caller-change/drivers/ide/ide-io.c
--- 24-cpqarray-caller-change/drivers/ide/ide-io.c	2007-09-10 17:32:12.000000000 -0400
+++ 25-ide-normal-caller-change/drivers/ide/ide-io.c	2007-09-10 18:17:38.000000000 -0400
@@ -78,12 +78,8 @@ static int __ide_end_request(ide_drive_t
 		HWGROUP(drive)->hwif->ide_dma_on(drive);
 	}
 
-	if (!end_that_request_chunk(rq, uptodate, nr_bytes)) {
-		add_disk_randomness(rq->rq_disk);
-		if (!list_empty(&rq->queuelist))
-			blkdev_dequeue_request(rq);
+	if (!__blk_end_request(rq, uptodate, nr_bytes)) {
 		HWGROUP(drive)->rq = NULL;
-		end_that_request_last(rq, uptodate);
 		ret = 0;
 	}
 
@@ -280,13 +276,9 @@ int ide_end_dequeued_request(ide_drive_t
 		HWGROUP(drive)->hwif->ide_dma_on(drive);
 	}
 
-	if (!end_that_request_first(rq, uptodate, nr_sectors)) {
-		add_disk_randomness(rq->rq_disk);
-		if (blk_rq_tagged(rq))
-			blk_queue_end_tag(drive->queue, rq);
-		end_that_request_last(rq, uptodate);
+	if (!__blk_end_request(rq, uptodate, nr_sectors << 9))
 		ret = 0;
-	}
+
 	spin_unlock_irqrestore(&ide_lock, flags);
 	return ret;
 }
@@ -316,9 +308,9 @@ static void ide_complete_pm_request (ide
 		drive->blocked = 0;
 		blk_start_queue(drive->queue);
 	}
-	blkdev_dequeue_request(rq);
 	HWGROUP(drive)->rq = NULL;
-	end_that_request_last(rq, 1);
+	if (__blk_end_request(rq, 1, 0))
+		BUG();
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
@@ -448,10 +440,10 @@ void ide_end_drive_cmd (ide_drive_t *dri
 	}
 
 	spin_lock_irqsave(&ide_lock, flags);
-	blkdev_dequeue_request(rq);
 	HWGROUP(drive)->rq = NULL;
 	rq->errors = err;
-	end_that_request_last(rq, !rq->errors);
+	if (__blk_end_request(rq, !rq->errors, 0))
+		BUG();
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
