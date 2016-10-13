From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3 12/16] scsi: fc: use bsg_softirq_done
Date: Thu, 13 Oct 2016 17:00:28 +0200
Message-ID: <a4a1fd8981ade25296f11faeb626d5480fcb8907.1476369687.git.jthumshirn@suse.de>
References: <cover.1476369687.git.jthumshirn@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cover.1476369687.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476369687.git.jthumshirn@suse.de>
References: <cover.1476369687.git.jthumshirn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

bsg_softirq_done() and fc_bsg_softirq_done() are copies of each other, so
ditch the fc specific one.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 block/bsg-lib.c                  |  3 ++-
 drivers/scsi/scsi_transport_fc.c | 15 ++-------------
 include/linux/bsg-lib.h          |  1 +
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 9f1e8fd..6661f82 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -85,12 +85,13 @@ void bsg_job_done(struct bsg_job *job, int result,
  * bsg_softirq_done - softirq done routine for destroying the bsg requests
  * @rq: BSG request that holds the job to be destroyed
  */
-static void bsg_softirq_done(struct request *rq)
+void bsg_softirq_done(struct request *rq)
 {
 	struct bsg_job *job = rq->special;
 
 	kref_put(&job->kref, bsg_destroy_job);
 }
+EXPORT_SYMBOL_GPL(bsg_softirq_done);
 
 static int bsg_map_buffer(struct bsg_buffer *buf, struct request *req)
 {
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index d2d0a27..1ae6d86 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3591,17 +3591,6 @@ void fc_bsg_jobdone(struct bsg_job *job, int result,
 EXPORT_SYMBOL_GPL(fc_bsg_jobdone);
 
 /**
- * fc_bsg_softirq_done - softirq done routine for destroying the bsg requests
- * @rq:        BSG request that holds the job to be destroyed
- */
-static void fc_bsg_softirq_done(struct request *rq)
-{
-	struct bsg_job *job = rq->special;
-
-	kref_put(&job->kref, fc_destroy_bsgjob);
-}
-
-/**
  * fc_bsg_job_timeout - handler for when a bsg request timesout
  * @req:	request that timed out
  */
@@ -4035,7 +4024,7 @@ enum fc_dispatch_result {
 
 	q->queuedata = shost;
 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
-	blk_queue_softirq_done(q, fc_bsg_softirq_done);
+	blk_queue_softirq_done(q, bsg_softirq_done);
 	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
 	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
 
@@ -4081,7 +4070,7 @@ enum fc_dispatch_result {
 
 	q->queuedata = rport;
 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
-	blk_queue_softirq_done(q, fc_bsg_softirq_done);
+	blk_queue_softirq_done(q, bsg_softirq_done);
 	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
 	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
 
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 67f7de6..09f3044 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -70,5 +70,6 @@ int bsg_setup_queue(struct device *dev, struct request_queue *q, char *name,
 		    bsg_job_fn *job_fn, int dd_job_size);
 void bsg_request_fn(struct request_queue *q);
 void bsg_destroy_job(struct kref *kref);
+void bsg_softirq_done(struct request *rq);
 
 #endif
-- 
1.8.5.6

