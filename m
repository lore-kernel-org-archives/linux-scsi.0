From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 15/27] blk_end_request: changing xen-blkfront
	(take 2)
Date: Tue, 11 Sep 2007 15:01:31 -0400 (EDT)
Message-ID: <20070911.150131.50590147.k-ueda@ct.jp.nec.com>
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

This patch converts xen-blkfront to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/xen-blkfront.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -rupN 14-viodasd-caller-change/drivers/block/xen-blkfront.c 15-xen-caller-change/drivers/block/xen-blkfront.c
--- 14-viodasd-caller-change/drivers/block/xen-blkfront.c	2007-08-27 21:32:35.000000000 -0400
+++ 15-xen-caller-change/drivers/block/xen-blkfront.c	2007-09-10 18:05:29.000000000 -0400
@@ -498,10 +498,9 @@ static irqreturn_t blkif_interrupt(int i
 				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
 					"request: %x\n", bret->status);
 
-			ret = end_that_request_first(req, uptodate,
-				req->hard_nr_sectors);
+			ret = __blk_end_request(req, uptodate,
+						blk_rq_size(req));
 			BUG_ON(ret);
-			end_that_request_last(req, uptodate);
 			break;
 		default:
 			BUG();
