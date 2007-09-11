From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 17/27] blk_end_request: changing i2o_block (take
	2)
Date: Tue, 11 Sep 2007 15:02:12 -0400 (EDT)
Message-ID: <20070911.150212.52121578.k-ueda@ct.jp.nec.com>
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

This patch converts i2o_block to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/message/i2o/i2o_block.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff -rupN 16-viocd-caller-change/drivers/message/i2o/i2o_block.c 17-i2o-caller-change/drivers/message/i2o/i2o_block.c
--- 16-viocd-caller-change/drivers/message/i2o/i2o_block.c	2007-09-10 17:32:13.000000000 -0400
+++ 17-i2o-caller-change/drivers/message/i2o/i2o_block.c	2007-09-10 18:08:24.000000000 -0400
@@ -425,22 +425,18 @@ static void i2o_block_end_request(struct
 	struct request_queue *q = req->q;
 	unsigned long flags;
 
-	if (end_that_request_chunk(req, uptodate, nr_bytes)) {
+	if (blk_end_request(req, uptodate, nr_bytes)) {
 		int leftover = (req->hard_nr_sectors << KERNEL_SECTOR_SHIFT);
 
 		if (blk_pc_request(req))
 			leftover = req->data_len;
 
 		if (end_io_error(uptodate))
-			end_that_request_chunk(req, 0, leftover);
+			blk_end_request(req, 0, leftover);
 	}
 
-	add_disk_randomness(req->rq_disk);
-
 	spin_lock_irqsave(q->queue_lock, flags);
 
-	end_that_request_last(req, uptodate);
-
 	if (likely(dev)) {
 		dev->open_queue_depth--;
 		list_del(&ireq->queue);
