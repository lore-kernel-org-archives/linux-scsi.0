From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 03/13] block: lld busy status exporting
	interface
Date: Wed, 19 Mar 2008 18:09:00 -0500 (EST)
Message-ID: <20080319.180900.99206705.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com, linux-kernel@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds an interface to check lld's busy status
from the block layer.
(scsi patch is also included just for example.)
This resolves a performance problem on request stacking devices below.


Some drivers like scsi mid layer stop dispatching request when
they detect busy state on its low-level device like host/bus/device.
It allows other requests to stay in the I/O scheduler's queue
for a chance of merging.

Request stacking drivers like request-based dm should follow
the same logic.
However, there is no generic interface for the stacked device
to check if the underlying device(s) are busy.
If the request stacking driver dispatches and submits requests to
the busy underlying device, the requests will stay in
the underlying device's queue without a chance for merging.
This causes performance problem on burst I/O load.

With this patch, busy state of the underlying device is exported
via the queue flag.  So the request stacking driver can check it
and stop dispatching requests if busy.
The underlying device driver must set/clear the flag appropriately.

For example, scsi sets the busy flag when low-level devices are not
ready or the low-level driver rejects dispatching command.
And scsi clears the busy flag when a command has been dispatched
successfully, since there may be more spaces to dispatch (the exact
limit check will be done in the next loop for the next request.)

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/scsi/scsi_lib.c |   11 ++++++++++-
 include/linux/blkdev.h  |    4 ++++
 2 files changed, 14 insertions(+), 1 deletion(-)

Index: 2.6.25-rc5/include/linux/blkdev.h
===================================================================
--- 2.6.25-rc5.orig/include/linux/blkdev.h
+++ 2.6.25-rc5/include/linux/blkdev.h
@@ -405,6 +405,7 @@ struct request_queue
 #define QUEUE_FLAG_PLUGGED	7	/* queue is plugged */
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
 #define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
+#define QUEUE_FLAG_BUSY		10	/* device/host under queue is busy */
 
 enum {
 	/*
@@ -450,6 +451,9 @@ enum {
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_flushing(q)	((q)->ordseq)
+#define blk_lld_busy(q)		test_bit(QUEUE_FLAG_BUSY, &(q)->queue_flags)
+#define blk_set_lld_busy(q)	set_bit(QUEUE_FLAG_BUSY, &(q)->queue_flags)
+#define blk_clear_lld_busy(q)	clear_bit(QUEUE_FLAG_BUSY, &(q)->queue_flags)
 
 #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
Index: 2.6.25-rc5/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6.25-rc5.orig/drivers/scsi/scsi_lib.c
+++ 2.6.25-rc5/drivers/scsi/scsi_lib.c
@@ -1448,9 +1448,14 @@ static void scsi_request_fn(struct reque
 		 * accept it.
 		 */
 		req = elv_next_request(q);
-		if (!req || !scsi_dev_queue_ready(q, sdev))
+		if (!req)
 			break;
 
+		if (!scsi_dev_queue_ready(q, sdev)) {
+			blk_set_lld_busy(q);
+			break;
+		}
+
 		if (unlikely(!scsi_device_online(sdev))) {
 			sdev_printk(KERN_ERR, sdev,
 				    "rejecting I/O to offline device\n");
@@ -1506,6 +1511,8 @@ static void scsi_request_fn(struct reque
 		rtn = scsi_dispatch_cmd(cmd);
 		spin_lock_irq(q->queue_lock);
 		if(rtn) {
+			blk_set_lld_busy(q);
+
 			/* we're refusing the command; because of
 			 * the way locks get dropped, we need to 
 			 * check here if plugging is required */
@@ -1514,6 +1521,7 @@ static void scsi_request_fn(struct reque
 
 			break;
 		}
+		blk_clear_lld_busy(q);
 	}
 
 	goto out;
@@ -1530,6 +1538,7 @@ static void scsi_request_fn(struct reque
 	 * later time.
 	 */
 	spin_lock_irq(q->queue_lock);
+	blk_set_lld_busy(q);
 	blk_requeue_request(q, req);
 	sdev->device_busy--;
 	if(sdev->device_busy == 0)
