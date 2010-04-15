From: Tejun Heo <tj@kernel.org>
Subject: [PATCH SCSI] scsi: fix locking around blk_abort_request()
Date: Thu, 15 Apr 2010 09:00:08 +0900
Message-ID: <4BC65708.80602@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:33668 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab0DNX4n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Apr 2010 19:56:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

blk_abort_request() expects queue lock to be held by the caller.
Grab it before calling the function.

Lack of this synchronization led to infinite loop on corrupt
q->timeout_list.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: stable@kernel.org
---
 drivers/scsi/libsas/sas_ata.c       |    4 ++++
 drivers/scsi/libsas/sas_scsi_host.c |    4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index b00efd1..88f7446 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -395,11 +395,15 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
 void sas_ata_task_abort(struct sas_task *task)
 {
 	struct ata_queued_cmd *qc = task->uldd_task;
+	struct request_queue *q = qc->scsicmd->device->request_queue;
 	struct completion *waiting;
+	unsigned long flags;

 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
+		spin_lock_irqsave(q->queue_lock, flags);
 		blk_abort_request(qc->scsicmd->request);
+		spin_unlock_irqrestore(q->queue_lock, flags);
 		scsi_schedule_eh(qc->scsicmd->device->host);
 		return;
 	}
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 2660e1b..8228350 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1030,6 +1030,8 @@ int __sas_task_abort(struct sas_task *task)
 void sas_task_abort(struct sas_task *task)
 {
 	struct scsi_cmnd *sc = task->uldd_task;
+	struct request_queue *q = sc->device->request_queue;
+	unsigned long flags;

 	/* Escape for libsas internal commands */
 	if (!sc) {
@@ -1044,7 +1046,9 @@ void sas_task_abort(struct sas_task *task)
 		return;
 	}

+	spin_lock_irqsave(q->queue_lock, flags);
 	blk_abort_request(sc->request);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 	scsi_schedule_eh(sc->device->host);
 }

