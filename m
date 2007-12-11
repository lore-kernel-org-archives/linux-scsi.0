From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 04/30] blk_end_request: changing arm (take 4)
Date: Tue, 11 Dec 2007 17:42:27 -0500 (EST)
Message-ID: <20071211.174227.66055336.k-ueda@ct.jp.nec.com>
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
Cc: linux-scsi@vger.kernel.org, toshihiro.kobayashi@nokia.com, Hiroshi.DOYU@nokia.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts arm's OMAP mailbox driver to use
blk_end_request interfaces.

If the original code was converted literally, blk_end_request would
be called with '-EIO' because end_that_request_last() were called
with '0' (i.e. failure).
But I think these '0's are bugs in the original code because it's
unlikely that all requests are treated as failure.
(The bugs should have no effect unless these requests have an end_io
 callback.)

So I changed them to pass '0' (i.e. success) to blk_end_request.

Cc: Toshihiro Kobayashi <toshihiro.kobayashi@nokia.com>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---

 arch/arm/plat-omap/mailbox.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

Index: 2.6.24-rc4/arch/arm/plat-omap/mailbox.c
===================================================================
--- 2.6.24-rc4.orig/arch/arm/plat-omap/mailbox.c
+++ 2.6.24-rc4/arch/arm/plat-omap/mailbox.c
@@ -116,8 +116,8 @@ static void mbox_tx_work(struct work_str
 		}
 
 		spin_lock(q->queue_lock);
-		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
+		if (__blk_end_request(rq, 0, 0))
+			BUG();
 		spin_unlock(q->queue_lock);
 	}
 }
@@ -149,10 +149,8 @@ static void mbox_rx_work(struct work_str
 
 		msg = (mbox_msg_t) rq->data;
 
-		spin_lock_irqsave(q->queue_lock, flags);
-		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
-		spin_unlock_irqrestore(q->queue_lock, flags);
+		if (blk_end_request(rq, 0, 0))
+			BUG();
 
 		mbox->rxq->callback((void *)msg);
 	}
@@ -263,10 +261,8 @@ omap_mbox_read(struct device *dev, struc
 
 		*p = (mbox_msg_t) rq->data;
 
-		spin_lock_irqsave(q->queue_lock, flags);
-		blkdev_dequeue_request(rq);
-		end_that_request_last(rq, 0);
-		spin_unlock_irqrestore(q->queue_lock, flags);
+		if (blk_end_request(rq, 0, 0))
+			BUG();
 
 		if (unlikely(mbox_seq_test(mbox, *p))) {
 			pr_info("mbox: Illegal seq bit!(%08x) ignored\n", *p);
