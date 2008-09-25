From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 2/2] scsi: export busy state via q->lld_busy_fn()
Date: Thu, 25 Sep 2008 11:55:33 -0400 (EDT)
Message-ID: <20080925.115533.122620313.k-ueda@ct.jp.nec.com>
References: <20080925.115355.71085765.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49307 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbYIYP6R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2008 11:58:17 -0400
In-Reply-To: <20080925.115355.71085765.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

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
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi.c        |    4 ++--
 drivers/scsi/scsi_lib.c    |   20 +++++++++++++++++++-
 include/scsi/scsi_device.h |   13 +++++++++++++
 3 files changed, 34 insertions(+), 3 deletions(-)

Index: linux-2.6-block/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6-block.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6-block/drivers/scsi/scsi_lib.c
@@ -470,6 +470,8 @@ void scsi_device_unbusy(struct scsi_devi
 	spin_unlock(shost->host_lock);
 	spin_lock(sdev->request_queue->queue_lock);
 	sdev->device_busy--;
+	if (sdev->device_busy < sdev->queue_depth && !sdev->device_blocked)
+		sdev->lld_busy = 0;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 }
 
@@ -1461,6 +1463,13 @@ static void scsi_softirq_done(struct req
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
@@ -1503,9 +1512,14 @@ static void scsi_request_fn(struct reque
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
@@ -1576,6 +1590,8 @@ static void scsi_request_fn(struct reque
 		rtn = scsi_dispatch_cmd(cmd);
 		spin_lock_irq(q->queue_lock);
 		if(rtn) {
+			sdev->lld_busy = 1;
+
 			/* we're refusing the command; because of
 			 * the way locks get dropped, we need to 
 			 * check here if plugging is required */
@@ -1600,6 +1616,7 @@ static void scsi_request_fn(struct reque
 	 * later time.
 	 */
 	spin_lock_irq(q->queue_lock);
+	sdev->lld_busy = 1;
 	blk_requeue_request(q, req);
 	sdev->device_busy--;
 	if(sdev->device_busy == 0)
@@ -1683,6 +1700,7 @@ struct request_queue *scsi_alloc_queue(s
 	blk_queue_prep_rq(q, scsi_prep_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
 	blk_queue_rq_timed_out(q, scsi_times_out);
+	blk_queue_lld_busy(q, scsi_lld_busy);
 	return q;
 }
 
Index: linux-2.6-block/drivers/scsi/scsi.c
===================================================================
--- linux-2.6-block.orig/drivers/scsi/scsi.c
+++ linux-2.6-block/drivers/scsi/scsi.c
@@ -803,8 +803,6 @@ void scsi_finish_command(struct scsi_cmn
 	struct scsi_driver *drv;
 	unsigned int good_bytes;
 
-	scsi_device_unbusy(sdev);
-
         /*
          * Clear the flags which say that the device/host is no longer
          * capable of accepting new commands.  These are set in scsi_queue.c
@@ -816,6 +814,8 @@ void scsi_finish_command(struct scsi_cmn
         shost->host_blocked = 0;
         sdev->device_blocked = 0;
 
+	scsi_device_unbusy(sdev);
+
 	/*
 	 * If we have valid sense information, then some kind of recovery
 	 * must have taken place.  Make a note of this.
Index: linux-2.6-block/include/scsi/scsi_device.h
===================================================================
--- linux-2.6-block.orig/include/scsi/scsi_device.h
+++ linux-2.6-block/include/scsi/scsi_device.h
@@ -143,6 +143,19 @@ struct scsi_device {
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
