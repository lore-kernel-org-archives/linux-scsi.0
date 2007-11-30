From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 04/28] blk_end_request: changing arm (take 3)
Date: Fri, 30 Nov 2007 18:25:52 -0500 (EST)
Message-ID: <20071130.182552.105434070.k-ueda@ct.jp.nec.com>
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

This patch converts arm to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---

 arch/arm/plat-omap/mailbox.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

Index: 2.6.24-rc3-mm2/arch/arm/plat-omap/mailbox.c
===================================================================
--- 2.6.24-rc3-mm2.orig/arch/arm/plat-omap/mailbox.c
+++ 2.6.24-rc3-mm2/arch/arm/plat-omap/mailbox.c
@@ -117,7 +117,8 @@ static void mbox_tx_work(struct work_str
 
 		spin_lock(q->queue_lock);
 		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
+		if (__blk_end_request(rq, 0, 0))
+			BUG();
 		spin_unlock(q->queue_lock);
 	}
 }
@@ -151,7 +152,8 @@ static void mbox_rx_work(struct work_str
 
 		spin_lock_irqsave(q->queue_lock, flags);
 		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
+		if (__blk_end_request(rq, 0, 0))
+			BUG();
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
 		mbox->rxq->callback((void *)msg);
@@ -265,7 +267,8 @@ omap_mbox_read(struct device *dev, struc
 
 		spin_lock_irqsave(q->queue_lock, flags);
 		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
+		if (__blk_end_request(rq, 0, 0))
+			BUG();
 		spin_unlock_irqrestore(q->queue_lock, flags);
 
 		if (unlikely(mbox_seq_test(mbox, *p))) {
