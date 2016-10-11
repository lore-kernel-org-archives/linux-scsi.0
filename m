From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 40/44] scsi: fc: use bsg_softirq_done
Date: Tue, 11 Oct 2016 13:29:11 +0200
Message-ID: <dbdbf40aa971c69b5c04dc2c6a8ab6cb0de3f0fb.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39322 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753305AbcJKL3n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Oct 2016 07:29:43 -0400
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476180827.git.jthumshirn@suse.de>
References: <cover.1476180827.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

bsg_softirq_done() and fc_bsg_softirq_done() are copies of each other, so
ditch the fc specific one.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_transport_fc.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 4b9324f..1ae6d86 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3591,18 +3591,6 @@ void fc_bsg_jobdone(struct bsg_job *job, int result,
 EXPORT_SYMBOL_GPL(fc_bsg_jobdone);
 
 /**
- * fc_bsg_softirq_done - softirq done routine for destroying the bsg requests
- * @rq:        BSG request that holds the job to be destroyed
- */
-static void fc_bsg_softirq_done(struct request *rq)
-{
-	struct bsg_job *job = rq->special;
-
-	blk_end_request_all(rq, rq->errors);
-	kref_put(&job->kref, fc_destroy_bsgjob);
-}
-
-/**
  * fc_bsg_job_timeout - handler for when a bsg request timesout
  * @req:	request that timed out
  */
@@ -4036,7 +4024,7 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 
 	q->queuedata = shost;
 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
-	blk_queue_softirq_done(q, fc_bsg_softirq_done);
+	blk_queue_softirq_done(q, bsg_softirq_done);
 	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
 	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
 
@@ -4082,7 +4070,7 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
 
 	q->queuedata = rport;
 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
-	blk_queue_softirq_done(q, fc_bsg_softirq_done);
+	blk_queue_softirq_done(q, bsg_softirq_done);
 	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
 	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
 
-- 
1.8.5.6

