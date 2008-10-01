From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/1] scsi: export busy state via q->lld_busy_fn()
Date: Wed, 01 Oct 2008 14:50:39 -0400 (EDT)
Message-ID: <20081001.145039.39152159.k-ueda@ct.jp.nec.com>
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
To: James.Bottomley@HansenPartnership.com
Cc: k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Hi James,

I hope the previous RFC patch(*) would be no problem, since I haven't
gotten any negative comment.
    (*) http://lkml.org/lkml/2008/9/25/262

So could you take this patch for 2.6.28 additionally?
This patch implements a new interface of the block layer for
request stacking drivers.
There should be no effect on existing drivers' behavior.

This patch was created on top of the commit below of scsi-post-merge-2.6.
---------------------------------------------------------------------
commit e49f03f37104c0e7cae7c455480069bada00932f
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Fri Sep 12 16:46:51 2008 -0500

    [SCSI] scsi_error: fix target reset handling
---------------------------------------------------------------------

And this patch depends on the following block layer patch, which
is in Jens' for-2.6.28 of linux-2.6-block.
    http://lkml.org/lkml/2008/9/29/142

Thanks,
Kiyoshi Ueda


Subject: [PATCH 1/1] scsi: export busy state via q->lld_busy_fn()

This patch implements q->lld_busy_fn() for scsi mid layer to export
its busy state.

Please note that it checks the cached information (sdev->lld_busy)
for efficiency, instead of checking the actual state of
sdev/starget/shost everytime.

So the care must be taken not to leave sdev->lld_busy = 1 for
the following cases:
    - when there is no request in the sdev queue
    - when scsi can't dispatch I/Os anymore and needs to kill I/Os
Otherwise, request stacking drivers may not submit any request,
and then, nobody sets back lld_busy = 0 and that causes deadlock.

OTOH, it has no major problem in setting sdev->lld_busy = 0 even when
the starget/shost is actually busy, because newly submitted request
will soon turn it to 1 in scsi_request_fn().


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi.c        |    4 ++--
 drivers/scsi/scsi_lib.c    |   20 +++++++++++++++++++-
 include/scsi/scsi_device.h |   13 +++++++++++++
 3 files changed, 34 insertions(+), 3 deletions(-)

Index: scsi-post-merge-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-post-merge-2.6.orig/drivers/scsi/scsi_lib.c
+++ scsi-post-merge-2.6/drivers/scsi/scsi_lib.c
@@ -480,6 +480,8 @@ void scsi_device_unbusy(struct scsi_devi
 	spin_unlock(shost->host_lock);
 	spin_lock(sdev->request_queue->queue_lock);
 	sdev->device_busy--;
+	if (sdev->device_busy < sdev->queue_depth && !sdev->device_blocked)
+		sdev->lld_busy = 0;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 }
 
@@ -1535,6 +1537,13 @@ static void scsi_softirq_done(struct req
 	}
 }
 
+static int scsi_lld_busy(struct request_queue *q)
+{
+	struct scsi_device *sdev = q->queuedata;
+
+	return sdev ? sdev->lld_busy : 0;
+}
+
 /*
  * Function:    scsi_request_fn()
  *
@@ -1577,9 +1586,14 @@ static void scsi_request_fn(struct reque
 		 * accept it.
 		 */
 		req = elv_next_request(q);
-		if (!req || !scsi_dev_queue_ready(q, sdev))
+		if (!req)
 			break;
 
+		if (!scsi_dev_queue_ready(q, sdev)) {
+			sdev->lld_busy = 1;
+			break;
+		}
+
 		if (unlikely(!scsi_device_online(sdev))) {
 			sdev_printk(KERN_ERR, sdev,
 				    "rejecting I/O to offline device\n");
@@ -1649,6 +1663,8 @@ static void scsi_request_fn(struct reque
 		rtn = scsi_dispatch_cmd(cmd);
 		spin_lock_irq(q->queue_lock);
 		if(rtn) {
+			sdev->lld_busy = 1;
+
 			/* we're refusing the command; because of
 			 * the way locks get dropped, we need to 
 			 * check here if plugging is required */
@@ -1673,6 +1689,7 @@ static void scsi_request_fn(struct reque
 	 * later time.
 	 */
 	spin_lock_irq(q->queue_lock);
+	sdev->lld_busy = 1;
 	blk_requeue_request(q, req);
 	sdev->device_busy--;
 	if(sdev->device_busy == 0)
@@ -1756,6 +1773,7 @@ struct request_queue *scsi_alloc_queue(s
 	blk_queue_prep_rq(q, scsi_prep_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
 	blk_queue_rq_timed_out(q, scsi_times_out);
+	blk_queue_lld_busy(q, scsi_lld_busy);
 	return q;
 }
 
Index: scsi-post-merge-2.6/drivers/scsi/scsi.c
===================================================================
--- scsi-post-merge-2.6.orig/drivers/scsi/scsi.c
+++ scsi-post-merge-2.6/drivers/scsi/scsi.c
@@ -809,8 +809,6 @@ void scsi_finish_command(struct scsi_cmn
 	struct scsi_driver *drv;
 	unsigned int good_bytes;
 
-	scsi_device_unbusy(sdev);
-
         /*
          * Clear the flags which say that the device/host is no longer
          * capable of accepting new commands.  These are set in scsi_queue.c
@@ -823,6 +821,8 @@ void scsi_finish_command(struct scsi_cmn
 	starget->target_blocked = 0;
         sdev->device_blocked = 0;
 
+	scsi_device_unbusy(sdev);
+
 	/*
 	 * If we have valid sense information, then some kind of recovery
 	 * must have taken place.  Make a note of this.
Index: scsi-post-merge-2.6/include/scsi/scsi_device.h
===================================================================
--- scsi-post-merge-2.6.orig/include/scsi/scsi_device.h
+++ scsi-post-merge-2.6/include/scsi/scsi_device.h
@@ -145,6 +145,19 @@ struct scsi_device {
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 	unsigned last_sector_bug:1;	/* do not use multisector accesses on
 					   SD_LAST_BUGGY_SECTORS */
+	unsigned lld_busy:1;		/* Exporting busy state for stacking
+					 * drivers.
+					 *
+					 * 1 - There is one or more requests
+					 *     in the device's queue,
+					 *     and the device (or target/host)
+					 *     can not dispatch any request
+					 *     immediately.
+					 * 0 - The device can dispatch
+					 *     (or kill) requests immediately,
+					 *     or there is no request in
+					 *     the device's queue even though
+					 *     target/host may busy. */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
