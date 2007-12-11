From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 14/30] blk_end_request: changing xen-blkfront
	(take 4)
Date: Tue, 11 Dec 2007 17:47:36 -0500 (EST)
Message-ID: <20071211.174736.88347027.k-ueda@ct.jp.nec.com>
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
Cc: jeremy@xensource.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts xen-blkfront to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/xen-blkfront.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

Index: 2.6.24-rc4/drivers/block/xen-blkfront.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/xen-blkfront.c
+++ 2.6.24-rc4/drivers/block/xen-blkfront.c
@@ -452,7 +452,7 @@ static irqreturn_t blkif_interrupt(int i
 	RING_IDX i, rp;
 	unsigned long flags;
 	struct blkfront_info *info = (struct blkfront_info *)dev_id;
-	int uptodate;
+	int error;
 
 	spin_lock_irqsave(&blkif_io_lock, flags);
 
@@ -477,13 +477,13 @@ static irqreturn_t blkif_interrupt(int i
 
 		add_id_to_freelist(info, id);
 
-		uptodate = (bret->status == BLKIF_RSP_OKAY);
+		error = (bret->status == BLKIF_RSP_OKAY) ? 0 : -EIO;
 		switch (bret->operation) {
 		case BLKIF_OP_WRITE_BARRIER:
 			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
 				printk(KERN_WARNING "blkfront: %s: write barrier op failed\n",
 				       info->gd->disk_name);
-				uptodate = -EOPNOTSUPP;
+				error = -EOPNOTSUPP;
 				info->feature_barrier = 0;
 				xlvbd_barrier(info);
 			}
@@ -494,10 +494,8 @@ static irqreturn_t blkif_interrupt(int i
 				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
 					"request: %x\n", bret->status);
 
-			ret = end_that_request_first(req, uptodate,
-				req->hard_nr_sectors);
+			ret = __blk_end_request(req, error, blk_rq_bytes(req));
 			BUG_ON(ret);
-			end_that_request_last(req, uptodate);
 			break;
 		default:
 			BUG();
