From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [patch] libsas: dereferencing variable before check
Date: Thu, 13 May 2010 09:31:54 -0500
Message-ID: <1273761114.4353.122.camel@mulgrave.site>
References: <20100512225629.GB5695@bicker>
	 <23e0bf65-8758-45b3-b0a8-1df97db07d9a@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:49157 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab0EMOcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2010 10:32:01 -0400
In-Reply-To: <23e0bf65-8758-45b3-b0a8-1df97db07d9a@email.android.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Dan Carpenter <error27@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 01:08 +0200, Tejun Heo wrote:
> 
> "Dan Carpenter" <error27@gmail.com> wrote:
> 
> >The "qc->scsicmd" could be null so I moved the dereference inside the
> >check.  This was introduced by 70b25f890: "[SCSI] fix locking around
> >blk_abort_request()" 
> >
> >Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> Ooh.. right.
> 
> Asked-by: Tejun Heo <tj@kernel.org>

Well, oops, yes.  Two patches to fix one bug is a bit overboard, I
think, plus some code rearrangement to fix the locality of the problem
and ensure it doesn't happen again might be useful.  What about this.

James

---

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 88f7446..8c496b5 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -395,12 +395,13 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
 void sas_ata_task_abort(struct sas_task *task)
 {
 	struct ata_queued_cmd *qc = task->uldd_task;
-	struct request_queue *q = qc->scsicmd->device->request_queue;
 	struct completion *waiting;
-	unsigned long flags;
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
+		struct request_queue *q = qc->scsicmd->device->request_queue;
+		unsigned long flags;
+
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_abort_request(qc->scsicmd->request);
 		spin_unlock_irqrestore(q->queue_lock, flags);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 8228350..53849f2 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1030,8 +1030,6 @@ int __sas_task_abort(struct sas_task *task)
 void sas_task_abort(struct sas_task *task)
 {
 	struct scsi_cmnd *sc = task->uldd_task;
-	struct request_queue *q = sc->device->request_queue;
-	unsigned long flags;
 
 	/* Escape for libsas internal commands */
 	if (!sc) {
@@ -1043,13 +1041,15 @@ void sas_task_abort(struct sas_task *task)
 
 	if (dev_is_sata(task->dev)) {
 		sas_ata_task_abort(task);
-		return;
-	}
+	} else {
+		struct request_queue *q = sc->device->request_queue;
+		unsigned long flags;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	blk_abort_request(sc->request);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-	scsi_schedule_eh(sc->device->host);
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_abort_request(sc->request);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+		scsi_schedule_eh(sc->device->host);
+	}
 }
 
 int sas_slave_alloc(struct scsi_device *scsi_dev)


