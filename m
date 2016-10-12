From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 08/16] scsi: fc: implement kref backed reference counting
Date: Wed, 12 Oct 2016 15:06:34 +0200
Message-ID: <60854e8cdb8b2306d403973ff3759e3650e7d0de.1476276823.git.jthumshirn@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37775 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755325AbcJLNIF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Oct 2016 09:08:05 -0400
In-Reply-To: <cover.1476276823.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476276823.git.jthumshirn@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

Implement kref backed reference counting instead of rolling our own. This
elimnates the need of the following fields in 'struct fc_bsg_job':
* ref_cnt
* state_flags
* job_lock
bringing us close to unification of 'struct fc_bsg_job' and 'struct bsg_job'.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_fc.c | 38 +++++++++-----------------------------
 include/scsi/scsi_transport_fc.h |  4 +---
 2 files changed, 10 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 96b3a2e..b0e28af 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3560,16 +3560,9 @@ fc_vport_sched_delete(struct work_struct *work)
  * @job:	fc_bsg_job that is to be torn down
  */
 static void
-fc_destroy_bsgjob(struct fc_bsg_job *job)
+fc_destroy_bsgjob(struct kref *kref)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&job->job_lock, flags);
-	if (job->ref_cnt) {
-		spin_unlock_irqrestore(&job->job_lock, flags);
-		return;
-	}
-	spin_unlock_irqrestore(&job->job_lock, flags);
+	struct fc_bsg_job *job = container_of(kref, struct fc_bsg_job, kref);
 
 	put_device(job->dev);	/* release reference for the request */
 
@@ -3620,15 +3613,9 @@ EXPORT_SYMBOL_GPL(fc_bsg_jobdone);
 static void fc_bsg_softirq_done(struct request *rq)
 {
 	struct fc_bsg_job *job = rq->special;
-	unsigned long flags;
-
-	spin_lock_irqsave(&job->job_lock, flags);
-	job->state_flags |= FC_RQST_STATE_DONE;
-	job->ref_cnt--;
-	spin_unlock_irqrestore(&job->job_lock, flags);
 
 	blk_end_request_all(rq, rq->errors);
-	fc_destroy_bsgjob(job);
+	kref_put(&job->kref, fc_destroy_bsgjob);
 }
 
 /**
@@ -3642,24 +3629,18 @@ fc_bsg_job_timeout(struct request *req)
 	struct Scsi_Host *shost = fc_bsg_to_shost(job);
 	struct fc_rport *rport = fc_bsg_to_rport(job);
 	struct fc_internal *i = to_fc_internal(shost->transportt);
-	unsigned long flags;
-	int err = 0, done = 0;
+	int err = 0, inflight = 0;
 
 	if (rport && rport->port_state == FC_PORTSTATE_BLOCKED)
 		return BLK_EH_RESET_TIMER;
 
-	spin_lock_irqsave(&job->job_lock, flags);
-	if (job->state_flags & FC_RQST_STATE_DONE)
-		done = 1;
-	else
-		job->ref_cnt++;
-	spin_unlock_irqrestore(&job->job_lock, flags);
+	inflight = kref_get_unless_zero(&job->kref);
 
-	if (!done && i->f->bsg_timeout) {
+	if (inflight && i->f->bsg_timeout) {
 		/* call LLDD to abort the i/o as it has timed out */
 		err = i->f->bsg_timeout(job);
 		if (err == -EAGAIN) {
-			job->ref_cnt--;
+			kref_put(&job->kref, fc_destroy_bsgjob);
 			return BLK_EH_RESET_TIMER;
 		} else if (err)
 			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
@@ -3667,7 +3648,7 @@ fc_bsg_job_timeout(struct request *req)
 	}
 
 	/* the blk_end_sync_io() doesn't check the error */
-	if (done)
+	if (!inflight)
 		return BLK_EH_NOT_HANDLED;
 	else
 		return BLK_EH_HANDLED;
@@ -3730,7 +3711,6 @@ fc_req_to_bsgjob(struct Scsi_Host *shost, struct fc_rport *rport,
 	job->req = req;
 	if (i->f->dd_bsg_size)
 		job->dd_data = (void *)&job[1];
-	spin_lock_init(&job->job_lock);
 	bsg_request = (struct fc_bsg_request *)req->cmd;
 	job->request_len = req->cmd_len;
 	bsg_reply = req->sense;
@@ -3752,7 +3732,7 @@ fc_req_to_bsgjob(struct Scsi_Host *shost, struct fc_rport *rport,
 		job->dev = &shost->shost_gendev;
 	get_device(job->dev);		/* take a reference for the request */
 
-	job->ref_cnt = 1;
+	kref_init(&job->kref);
 
 	return 0;
 
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 9f53fe3..8ae5680 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -634,9 +634,7 @@ struct fc_bsg_job {
 	struct fc_rport *rport;
 	struct device *dev;
 	struct request *req;
-	spinlock_t job_lock;
-	unsigned int state_flags;
-	unsigned int ref_cnt;
+	struct kref kref;
 
 	struct fc_bsg_request *request;
 	struct fc_bsg_reply *reply;
-- 
1.8.5.6

