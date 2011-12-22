From: Shaohua Li <shaohua.li@intel.com>
Subject: [patch 2/2]scsi: changed sdev order in starved list only when it
 dispatches requests
Date: Thu, 22 Dec 2011 11:10:15 +0800
Message-ID: <1324523415.22361.472.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab1LVC5C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Dec 2011 21:57:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: JBottomley@Parallels.com, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Ted Ts'o <tytso@mit.edu>, "Wu, Fengguang" <fengguang.wu@intel.com>, "Darrick J. Wong" <djwong@us.ibm.com>

The sdev is deleted from starved list and then try to dispatch from this
device. It's quite possible the sdev can't eventually dispatch a request,
then the sdev will be in starved list tail. This isn't fair.
With below patch, we move the sdev to starved list tail only after it
dispatched a request. If the sdev doesn't have request queued, it will
be deleted from starved list. In this way, if the sdev doesn't dispatch
request, its order in starved list will not be changed.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/scsi/scsi_lib.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

Index: linux/drivers/scsi/scsi_lib.c
===================================================================
--- linux.orig/drivers/scsi/scsi_lib.c	2011-12-22 09:36:54.000000000 +0800
+++ linux/drivers/scsi/scsi_lib.c	2011-12-22 09:42:06.000000000 +0800
@@ -436,7 +436,6 @@ static void scsi_run_queue(struct reques
 		if (!head_sdev)
 			head_sdev = sdev;
 
-		list_del_init(&sdev->starved_entry);
 		if (scsi_target_is_busy(scsi_target(sdev))) {
 			list_move_tail(&sdev->starved_entry,
 				       &shost->starved_list);
@@ -1329,9 +1328,6 @@ static inline int scsi_target_queue_read
 		return 0;
 	}
 
-	/* We're OK to process the command, so we can't be starved */
-	if (!list_empty(&sdev->starved_entry))
-		list_del_init(&sdev->starved_entry);
 	return 1;
 }
 
@@ -1366,10 +1362,6 @@ static inline int scsi_host_queue_ready(
 		return 0;
 	}
 
-	/* We're OK to process the command, so we can't be starved */
-	if (!list_empty(&sdev->starved_entry))
-		list_del_init(&sdev->starved_entry);
-
 	return 1;
 }
 
@@ -1497,6 +1489,7 @@ static void scsi_request_fn(struct reque
 	struct Scsi_Host *shost;
 	struct scsi_cmnd *cmd;
 	struct request *req;
+	bool empty_queue = false;
 
 	if (!sdev) {
 		while ((req = blk_peek_request(q)) != NULL)
@@ -1575,6 +1568,11 @@ static void scsi_request_fn(struct reque
 		scsi_target(sdev)->target_busy++;
 		shost->host_busy++;
 
+		/* dispatched one requests, move it to tail  */
+		if (!list_empty(&sdev->starved_entry))
+			list_move_tail(&sdev->starved_entry,
+					       &shost->starved_list);
+
 		/*
 		 * XXX(hch): This is rather suboptimal, scsi_dispatch_cmd will
 		 *		take the lock again.
@@ -1596,6 +1594,7 @@ static void scsi_request_fn(struct reque
 			goto out_delay;
 	}
 
+	empty_queue = true;
 	goto out;
 
  not_ready:
@@ -1618,7 +1617,15 @@ out_delay:
 out:
 	/* must be careful here...if we trigger the ->remove() function
 	 * we cannot be holding the q lock */
-	spin_unlock_irq(q->queue_lock);
+	spin_unlock(q->queue_lock);
+
+	if (empty_queue) {
+		spin_lock(shost->host_lock);
+		list_del_init(&sdev->starved_entry);
+		spin_unlock_irq(shost->host_lock);
+	} else
+		local_irq_disable();
+
 	put_device(&sdev->sdev_gendev);
 	spin_lock_irq(q->queue_lock);
 }


