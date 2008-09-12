From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 05/13] block: add a queue flag for request
	stacking support
Date: Fri, 12 Sep 2008 10:43:35 -0400 (EDT)
Message-ID: <20080912.104335.88699296.k-ueda@ct.jp.nec.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, agk@redhat.com, James.Bottomley@HansenPartnership.com
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds a queue flag to indicate the block device can be
used for request stacking.

Request stacking drivers need to stack their devices on top of
only devices of which q->request_fn is functional.
Since bio stacking drivers (e.g. md, loop) basically initialize
their queue using blk_alloc_queue() and don't set q->request_fn,
the check of (q->request_fn == NULL) looks enough for that purpose.

However, dm becomes both types of stacking driver (bio-based and
request-based) with this patch-set.  And dm always sets q->request_fn
even if the dm device is bio-based of which q->request_fn is not
functional actually.
So we need something else to distinguish the type of the device.
Adding a queue flag is a solution for that.


The reason why dm always sets q->request_fn is to keep
the compatibility of dm user-space tools.
Currently, all dm user-space tools are using bio-based dm without
specifying the type of the dm device they use.
To use request-based dm without changing such tools, the kernel
must decide the type of the dm device automatically.
The automatic type decision can't be done at the device creation time
and needs to be deferred until such tools load a mapping table,
since the actual type is decided by dm target type included in
the mapping table.

So a dm device has to be initialized using blk_init_queue()
so that we can load either type of table.
Then, all queue stuffs are set (e.g. q->request_fn) and we have
no element to distinguish that it is bio-based or request-based,
even after a table is loaded and the type of the device is decided.

By the way, some stuffs of the queue (e.g. request_list, elevator)
are needless when the dm device is used as bio-based.
But the memory size is not so large (about 20[KB] per queue on ia64),
so I hope the memory loss can be acceptable for bio-based dm users.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c       |    3 ++-
 include/linux/blkdev.h |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: 2.6.27-rc6/block/blk-core.c
===================================================================
--- 2.6.27-rc6.orig/block/blk-core.c
+++ 2.6.27-rc6/block/blk-core.c
@@ -569,7 +569,8 @@ blk_init_queue_node(request_fn_proc *rfn
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unplug_fn		= generic_unplug_device;
-	q->queue_flags		= (1 << QUEUE_FLAG_CLUSTER);
+	q->queue_flags		= (1 << QUEUE_FLAG_CLUSTER |
+				   1 << QUEUE_FLAG_STACKABLE);
 	q->queue_lock		= lock;
 
 	blk_queue_segment_boundary(q, 0xffffffff);
Index: 2.6.27-rc6/include/linux/blkdev.h
===================================================================
--- 2.6.27-rc6.orig/include/linux/blkdev.h
+++ 2.6.27-rc6/include/linux/blkdev.h
@@ -421,6 +421,7 @@ struct request_queue
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
 #define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
 #define QUEUE_FLAG_NOMERGES    10	/* disable merge attempts */
+#define QUEUE_FLAG_STACKABLE   11	/* supports request stacking */
 
 static inline int queue_is_locked(struct request_queue *q)
 {
@@ -527,6 +528,8 @@ enum {
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_flushing(q)	((q)->ordseq)
+#define blk_queue_stackable(q)	\
+	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
 
 #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
