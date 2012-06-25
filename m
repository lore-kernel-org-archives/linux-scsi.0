From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 4/4] scsi: Stop accepting SCSI requests before removing a
 device
Date: Mon, 25 Jun 2012 18:17:18 +0000
Message-ID: <4FE8AB2E.10400@acm.org>
References: <4FE8A9FC.6040805@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:46036 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2FYSRU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2012 14:17:20 -0400
In-Reply-To: <4FE8A9FC.6040805@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Joe Lawrence <jdl1291@gmail.com>

Avoid that the code for requeueing SCSI requests triggers a
crash by making sure that that code isn't scheduled anymore
after a device has been removed.

Also, source code inspection of __scsi_remove_device() revealed
a race condition in this function: no new SCSI requests must be
accepted for a SCSI device after device removal started.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Joe Lawrence <jdl1291@gmail.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: <stable@kernel.org>
---
 drivers/scsi/scsi_lib.c   |    7 ++++---
 drivers/scsi/scsi_sysfs.c |   11 +++++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 082c1e5..fc2b9f4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -155,13 +155,14 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 
 	/*
 	 * Requeue this command.  It will go before all other commands
-	 * that are already in the queue.
+	 * that are already in the queue. Schedule requeue work under
+	 * lock such that the kblockd_schedule_work() call happens
+	 * before blk_cleanup_queue() finishes.
 	 */
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, cmd->request);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
 	kblockd_schedule_work(q, &device->requeue_work);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
 /*
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 42c35ff..efffc92 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -966,13 +966,20 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		device_del(dev);
 	} else
 		put_device(&sdev->sdev_dev);
+
+	/*
+	 * Stop accepting new requests and wait until all queuecommand() and
+	 * scsi_run_queue() invocations have finished before tearing down the
+	 * device.
+	 */
 	scsi_device_set_state(sdev, SDEV_DEL);
+	blk_cleanup_queue(sdev->request_queue);
+	cancel_work_sync(&sdev->requeue_work);
+
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
 
-	/* Freeing the queue signals to block that we're done */
-	blk_cleanup_queue(sdev->request_queue);
 	put_device(dev);
 }
 
