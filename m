From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 23/27] blk_end_request: changing cciss (take 2)
Date: Tue, 11 Sep 2007 15:04:12 -0400 (EDT)
Message-ID: <20070911.150412.01284032.k-ueda@ct.jp.nec.com>
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

This patch converts cciss to use blk_end_request().

cciss is a little bit different from "normal" drivers.
cciss directly calls bio_endio() and disk_stat_add()
when completing request.  But those can be replaced with
__end_that_request_first().
After the replacement, request completion procedures of
those drivers become like the following:
    o end_that_request_first()
    o add_disk_randomness()
    o end_that_request_last()
This can be converted to blk_end_request() by following
the rule (a) mentioned in the patch subject
"[PATCH 01/27] blk_end_request: add new request completion interface".

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/cciss.c |   26 +++-----------------------
 1 files changed, 3 insertions(+), 23 deletions(-)

diff -rupN 22-xsysace-caller-change/drivers/block/cciss.c 23-cciss-caller-change/drivers/block/cciss.c
--- 22-xsysace-caller-change/drivers/block/cciss.c	2007-09-10 17:32:11.000000000 -0400
+++ 23-cciss-caller-change/drivers/block/cciss.c	2007-09-10 18:16:34.000000000 -0400
@@ -1187,18 +1187,6 @@ static int cciss_ioctl(struct inode *ino
 	}
 }
 
-static inline void complete_buffers(struct bio *bio, int status)
-{
-	while (bio) {
-		struct bio *xbh = bio->bi_next;
-		int nr_sectors = bio_sectors(bio);
-
-		bio->bi_next = NULL;
-		bio_endio(bio, nr_sectors << 9, status ? 0 : -EIO);
-		bio = xbh;
-	}
-}
-
 static void cciss_check_queues(ctlr_info_t *h)
 {
 	int start_queue = h->next_to_run;
@@ -1264,21 +1252,14 @@ static void cciss_softirq_done(struct re
 		pci_unmap_page(h->pdev, temp64.val, cmd->SG[i].Len, ddir);
 	}
 
-	complete_buffers(rq->bio, (rq->errors == 0));
-
-	if (blk_fs_request(rq)) {
-		const int rw = rq_data_dir(rq);
-
-		disk_stat_add(rq->rq_disk, sectors[rw], rq->nr_sectors);
-	}
-
 #ifdef CCISS_DEBUG
 	printk("Done with %p\n", rq);
 #endif				/* CCISS_DEBUG */
 
-	add_disk_randomness(rq->rq_disk);
+	if (blk_end_request(rq, (rq->errors == 0), blk_rq_size(rq)))
+		BUG();
+
 	spin_lock_irqsave(&h->lock, flags);
-	end_that_request_last(rq, (rq->errors == 0));
 	cmd_free(h, cmd, 1);
 	cciss_check_queues(h);
 	spin_unlock_irqrestore(&h->lock, flags);
@@ -2545,7 +2526,6 @@ after_error_processing:
 	}
 	cmd->rq->data_len = 0;
 	cmd->rq->completion_data = cmd;
-	blk_add_trace_rq(cmd->rq->q, cmd->rq, BLK_TA_COMPLETE);
 	blk_complete_request(cmd->rq);
 }
 
