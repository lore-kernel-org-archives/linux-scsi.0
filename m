From: Dan Carpenter <error27@gmail.com>
Subject: [patch] libsas: dereferencing variable before check
Date: Thu, 13 May 2010 00:56:29 +0200
Message-ID: <20100512225629.GB5695@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The "qc->scsicmd" could be null so I moved the dereference inside the
check.  This was introduced by 70b25f890: "[SCSI] fix locking around
blk_abort_request()" 

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 88f7446..98b1545 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -395,12 +395,13 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
 void sas_ata_task_abort(struct sas_task *task)
 {
 	struct ata_queued_cmd *qc = task->uldd_task;
-	struct request_queue *q = qc->scsicmd->device->request_queue;
+	struct request_queue *q;
 	struct completion *waiting;
 	unsigned long flags;
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
+		q = qc->scsicmd->device->request_queue;
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_abort_request(qc->scsicmd->request);
 		spin_unlock_irqrestore(q->queue_lock, flags);
