From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 14/16] block: add bsg_job_put() and bsg_job_get()
Date: Wed, 12 Oct 2016 15:06:40 +0200
Message-ID: <18a915378ba11b84faa85341beb57df3f5976b64.1476276823.git.jthumshirn@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476276823.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476276823.git.jthumshirn@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Add bsg_job_put() and bsg_job_get() so don't need to export
bsg_destroy_job() any more.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/bsg-lib.c                  | 17 ++++++++++++++---
 drivers/scsi/scsi_transport_fc.c |  4 ++--
 include/linux/bsg-lib.h          |  3 ++-
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 5d24d25..46a4fee 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -32,7 +32,7 @@
  * bsg_destroy_job - routine to teardown/delete a bsg job
  * @job: bsg_job that is to be torn down
  */
-void bsg_destroy_job(struct kref *kref)
+static void bsg_destroy_job(struct kref *kref)
 {
 	struct bsg_job *job = container_of(kref, struct bsg_job, kref);
 
@@ -42,7 +42,18 @@ void bsg_destroy_job(struct kref *kref)
 	kfree(job->reply_payload.sg_list);
 	kfree(job);
 }
-EXPORT_SYMBOL_GPL(bsg_destroy_job);
+
+void bsg_job_put(struct bsg_job *job)
+{
+	kref_put(&job->kref, bsg_destroy_job);
+}
+EXPORT_SYMBOL_GPL(bsg_job_put);
+
+int bsg_job_get(struct bsg_job *job)
+{
+	return kref_get_unless_zero(&job->kref);
+}
+EXPORT_SYMBOL_GPL(bsg_job_get);
 
 /**
  * bsg_job_done - completion routine for bsg requests
@@ -87,7 +98,7 @@ void bsg_softirq_done(struct request *rq)
 	struct bsg_job *job = rq->special;
 
 	blk_end_request_all(rq, rq->errors);
-	kref_put(&job->kref, bsg_destroy_job);
+	bsg_job_put(job);
 }
 EXPORT_SYMBOL_GPL(bsg_softirq_done);
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 720ddc9..7fae045 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3571,13 +3571,13 @@ fc_bsg_job_timeout(struct request *req)
 	if (rport && rport->port_state == FC_PORTSTATE_BLOCKED)
 		return BLK_EH_RESET_TIMER;
 
-	inflight = kref_get_unless_zero(&job->kref);
+	inflight = bsg_job_get(job);
 
 	if (inflight && i->f->bsg_timeout) {
 		/* call LLDD to abort the i/o as it has timed out */
 		err = i->f->bsg_timeout(job);
 		if (err == -EAGAIN) {
-			kref_put(&job->kref, bsg_destroy_job);
+			bsg_job_put(job);
 			return BLK_EH_RESET_TIMER;
 		} else if (err)
 			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 09f3044..b708db9 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -69,7 +69,8 @@ void bsg_job_done(struct bsg_job *job, int result,
 int bsg_setup_queue(struct device *dev, struct request_queue *q, char *name,
 		    bsg_job_fn *job_fn, int dd_job_size);
 void bsg_request_fn(struct request_queue *q);
-void bsg_destroy_job(struct kref *kref);
 void bsg_softirq_done(struct request *rq);
+void bsg_job_put(struct bsg_job *job);
+int __must_check bsg_job_get(struct bsg_job *job);
 
 #endif
-- 
1.8.5.6
