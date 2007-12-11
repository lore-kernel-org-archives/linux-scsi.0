From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 07/30] blk_end_request: changing floppy (take 4)
Date: Tue, 11 Dec 2007 17:43:40 -0500 (EST)
Message-ID: <20071211.174340.107680113.k-ueda@ct.jp.nec.com>
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
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts floppy to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

As a result, the interface of internal function, floppy_end_request(),
is changed.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/floppy.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

Index: 2.6.24-rc4/drivers/block/floppy.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/floppy.c
+++ 2.6.24-rc4/drivers/block/floppy.c
@@ -2287,21 +2287,19 @@ static int do_format(int drive, struct f
  * =============================
  */
 
-static void floppy_end_request(struct request *req, int uptodate)
+static void floppy_end_request(struct request *req, int error)
 {
 	unsigned int nr_sectors = current_count_sectors;
+	unsigned int drive = (unsigned int)req->rq_disk->private_data;
 
 	/* current_count_sectors can be zero if transfer failed */
-	if (!uptodate)
+	if (error)
 		nr_sectors = req->current_nr_sectors;
-	if (end_that_request_first(req, uptodate, nr_sectors))
+	if (__blk_end_request(req, error, nr_sectors << 9))
 		return;
-	add_disk_randomness(req->rq_disk);
-	floppy_off((long)req->rq_disk->private_data);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, uptodate);
 
 	/* We're done with the request */
+	floppy_off(drive);
 	current_req = NULL;
 }
 
@@ -2332,7 +2330,7 @@ static void request_done(int uptodate)
 
 		/* unlock chained buffers */
 		spin_lock_irqsave(q->queue_lock, flags);
-		floppy_end_request(req, 1);
+		floppy_end_request(req, 0);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 	} else {
 		if (rq_data_dir(req) == WRITE) {
@@ -2346,7 +2344,7 @@ static void request_done(int uptodate)
 			DRWE->last_error_generation = DRS->generation;
 		}
 		spin_lock_irqsave(q->queue_lock, flags);
-		floppy_end_request(req, 0);
+		floppy_end_request(req, -EIO);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
 }
