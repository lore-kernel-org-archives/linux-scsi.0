From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 01/27] blk_end_request: add new request completion
 interface (take 2)
Date: Tue, 11 Sep 2007 14:55:50 -0400 (EDT)
Message-ID: <20070911.145550.58461825.k-ueda@ct.jp.nec.com>
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

This patch adds 2 new interfaces for request completion:
  o blk_end_request()   : called without queue lock
  o __blk_end_request() : called with queue lock held

Some device drivers call some generic functions below between
end_that_request_{first/chunk} and end_that_request_last().
  o add_disk_randomness()
  o blk_queue_end_tag()
  o blkdev_dequeue_request()
These are called in the blk_end_request() as a part of generic
request completion.
So all device drivers become to call above functions.

"Normal" drivers can be converted to use blk_end_request()
in a standard way shown below.

 a) end_that_request_{chunk/first}
    spin_lock_irqsave()
    (add_disk_randomness(), blk_queue_end_tag(), blkdev_dequeue_request())
    end_that_request_last()
    spin_unlock_irqrestore()
    => blk_end_request()

 b) spin_lock_irqsave()
    end_that_request_{chunk/first}
    (add_disk_randomness(), blk_queue_end_tag(), blkdev_dequeue_request())
    end_that_request_last()
    spin_unlock_irqrestore()
    => spin_lock_irqsave()
       __blk_end_request()
       spin_unlock_irqsave()

 c) end_that_request_last()
    => __blk_end_request()

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c      |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    2 +
 2 files changed, 76 insertions(+)

diff -rupN 2.6.23-rc4-mm1/block/ll_rw_blk.c 01-blkendreq-interface/block/ll_rw_blk.c
--- 2.6.23-rc4-mm1/block/ll_rw_blk.c	2007-09-10 17:32:11.000000000 -0400
+++ 01-blkendreq-interface/block/ll_rw_blk.c	2007-09-10 17:42:56.000000000 -0400
@@ -3776,6 +3776,80 @@ void end_request(struct request *req, in
 }
 EXPORT_SYMBOL(end_request);
 
+static void complete_request(struct request *rq, int uptodate)
+{
+	if (blk_rq_tagged(rq))
+		blk_queue_end_tag(rq->q, rq);
+
+	if (!list_empty(&rq->queuelist))
+		blkdev_dequeue_request(rq);
+
+	end_that_request_last(rq, uptodate);
+}
+
+/**
+ * blk_end_request - Helper function for drivers to complete the request.
+ * @rq:       the request being processed
+ * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
+ * @nr_bytes: number of bytes to complete
+ *
+ * Description:
+ *     Ends I/O on a number of bytes attached to @rq.
+ *     If @rq has leftover, sets it up for the next range of segments.
+ *
+ * Return:
+ *     0 - we are done with this request
+ *     1 - still buffers pending for this request
+ **/
+int blk_end_request(struct request *rq, int uptodate, int nr_bytes)
+{
+	struct request_queue *q = rq->q;
+	unsigned long flags = 0UL;
+
+	if (blk_fs_request(rq) || blk_pc_request(rq)) {
+		if (__end_that_request_first(rq, uptodate, nr_bytes))
+			return 1;
+	}
+
+	/*
+	 * No need to check the argument here because it is done
+	 * in add_disk_randomness().
+	 */
+	add_disk_randomness(rq->rq_disk);
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	complete_request(rq, uptodate);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(blk_end_request);
+
+/**
+ * __blk_end_request - Helper function for drivers to complete the request.
+ *
+ * Description:
+ *     Must be called with queue lock held unlike blk_end_request().
+ **/
+int __blk_end_request(struct request *rq, int uptodate, int nr_bytes)
+{
+	if (blk_fs_request(rq) || blk_pc_request(rq)) {
+		if (__end_that_request_first(rq, uptodate, nr_bytes))
+			return 1;
+	}
+
+	/*
+	 * No need to check the argument here because it is done
+	 * in add_disk_randomness().
+	 */
+	add_disk_randomness(rq->rq_disk);
+
+	complete_request(rq, uptodate);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__blk_end_request);
+
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		     struct bio *bio)
 {
diff -rupN 2.6.23-rc4-mm1/include/linux/blkdev.h 01-blkendreq-interface/include/linux/blkdev.h
--- 2.6.23-rc4-mm1/include/linux/blkdev.h	2007-09-10 17:32:18.000000000 -0400
+++ 01-blkendreq-interface/include/linux/blkdev.h	2007-09-10 17:42:56.000000000 -0400
@@ -727,6 +727,8 @@ static inline void blk_run_address_space
  * for parts of the original function. This prevents
  * code duplication in drivers.
  */
+extern int blk_end_request(struct request *rq, int uptodate, int nr_bytes);
+extern int __blk_end_request(struct request *rq, int uptodate, int nr_bytes);
 extern int end_that_request_first(struct request *, int, int);
 extern int end_that_request_chunk(struct request *, int, int);
 extern void end_that_request_last(struct request *, int);
