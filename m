From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 10/27] blk_end_request: changing ps3disk (take 2)
Date: Tue, 11 Sep 2007 14:59:42 -0400 (EDT)
Message-ID: <20070911.145942.10250776.k-ueda@ct.jp.nec.com>
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

This patch converts ps3disk to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/ps3disk.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -rupN 09-nbd-caller-change/drivers/block/ps3disk.c 10-ps3disk-caller-change/drivers/block/ps3disk.c
--- 09-nbd-caller-change/drivers/block/ps3disk.c	2007-08-27 21:32:35.000000000 -0400
+++ 10-ps3disk-caller-change/drivers/block/ps3disk.c	2007-09-10 18:03:00.000000000 -0400
@@ -280,11 +280,7 @@ static irqreturn_t ps3disk_interrupt(int
 	}
 
 	spin_lock(&priv->lock);
-	if (!end_that_request_first(req, uptodate, num_sectors)) {
-		add_disk_randomness(req->rq_disk);
-		blkdev_dequeue_request(req);
-		end_that_request_last(req, uptodate);
-	}
+	__blk_end_request(req, uptodate, num_sectors << 9);
 	priv->req = NULL;
 	ps3disk_do_request(dev, priv->queue);
 	spin_unlock(&priv->lock);
