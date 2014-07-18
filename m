From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/14] scsi: only maintain target_blocked if the driver has a target queue limit
Date: Fri, 18 Jul 2014 12:13:09 +0200
Message-ID: <1405678393-11497-11-git-send-email-hch@lst.de>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405678393-11497-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This saves us an atomic operation for each I/O submission and completion
for the usual case where the driver doesn't set a per-target can_queue
value.  Only a few iscsi hardware offload drivers set the per-target
can_queue value at the moment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Webb Scales <webbnh@hp.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Robert Elliott <elliott@hp.com>
---
 drivers/scsi/scsi_lib.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 69da4cb..a643353 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -295,7 +295,8 @@ void scsi_device_unbusy(struct scsi_device *sdev)
 	unsigned long flags;
 
 	atomic_dec(&shost->host_busy);
-	atomic_dec(&starget->target_busy);
+	if (starget->can_queue > 0)
+		atomic_dec(&starget->target_busy);
 
 	if (unlikely(scsi_host_in_recovery(shost) &&
 		     (shost->host_failed || shost->host_eh_scheduled))) {
@@ -364,11 +365,12 @@ static inline bool scsi_device_is_busy(struct scsi_device *sdev)
 
 static inline bool scsi_target_is_busy(struct scsi_target *starget)
 {
-	if (starget->can_queue > 0 &&
-	    atomic_read(&starget->target_busy) >= starget->can_queue)
-		return true;
-	if (atomic_read(&starget->target_blocked) > 0)
-		return true;
+	if (starget->can_queue > 0) {
+		if (atomic_read(&starget->target_busy) >= starget->can_queue)
+			return true;
+		if (atomic_read(&starget->target_blocked) > 0)
+			return true;
+	}
 	return false;
 }
 
@@ -1309,6 +1311,9 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 		spin_unlock_irq(shost->host_lock);
 	}
 
+	if (starget->can_queue <= 0)
+		return 1;
+
 	busy = atomic_inc_return(&starget->target_busy) - 1;
 	if (atomic_read(&starget->target_blocked) > 0) {
 		if (busy)
@@ -1324,7 +1329,7 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 				 "unblocking target at zero depth\n"));
 	}
 
-	if (starget->can_queue > 0 && busy >= starget->can_queue)
+	if (busy >= starget->can_queue)
 		goto starved;
 
 	return 1;
@@ -1334,7 +1339,8 @@ starved:
 	list_move_tail(&sdev->starved_entry, &shost->starved_list);
 	spin_unlock_irq(shost->host_lock);
 out_dec:
-	atomic_dec(&starget->target_busy);
+	if (starget->can_queue > 0)
+		atomic_dec(&starget->target_busy);
 	return 0;
 }
 
@@ -1455,7 +1461,8 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	 */
 	atomic_inc(&sdev->device_busy);
 	atomic_inc(&shost->host_busy);
-	atomic_inc(&starget->target_busy);
+	if (starget->can_queue > 0)
+		atomic_inc(&starget->target_busy);
 
 	blk_complete_request(req);
 }
@@ -1624,7 +1631,8 @@ static void scsi_request_fn(struct request_queue *q)
 	return;
 
  host_not_ready:
-	atomic_dec(&scsi_target(sdev)->target_busy);
+	if (scsi_target(sdev)->can_queue > 0)
+		atomic_dec(&scsi_target(sdev)->target_busy);
  not_ready:
 	/*
 	 * lock q, handle tag, requeue req, and decrement device_busy. We
-- 
1.9.1
