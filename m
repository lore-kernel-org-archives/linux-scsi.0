From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 11/16] scsi: fc: Use bsg_destroy_job
Date: Wed, 12 Oct 2016 15:06:37 +0200
Message-ID: <7c7473dfa0f74f7bdf442d5669a57204ecf812e4.1476276823.git.jthumshirn@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cover.1476276823.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476276823.git.jthumshirn@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

fc_destroy_bsgjob() and bsg_destroy_job() are now 1:1 copies, so use the
later.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/bsg-lib.c                  |  3 ++-
 drivers/scsi/scsi_transport_fc.c | 20 ++------------------
 include/linux/bsg-lib.h          |  1 +
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 632fb40..6b99c7f 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -32,7 +32,7 @@
  * bsg_destroy_job - routine to teardown/delete a bsg job
  * @job: bsg_job that is to be torn down
  */
-static void bsg_destroy_job(struct kref *kref)
+void bsg_destroy_job(struct kref *kref)
 {
 	struct bsg_job *job = container_of(kref, struct bsg_job, kref);
 
@@ -42,6 +42,7 @@ static void bsg_destroy_job(struct kref *kref)
 	kfree(job->reply_payload.sg_list);
 	kfree(job);
 }
+EXPORT_SYMBOL_GPL(bsg_destroy_job);
 
 /**
  * bsg_job_done - completion routine for bsg requests
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index a0e150a..4b9324f 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/kernel.h>
+#include <linux/bsg-lib.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
@@ -3554,23 +3555,6 @@ fc_vport_sched_delete(struct work_struct *work)
  * BSG support
  */
 
-
-/**
- * fc_destroy_bsgjob - routine to teardown/delete a fc bsg job
- * @job:	fc_bsg_job that is to be torn down
- */
-static void
-fc_destroy_bsgjob(struct kref *kref)
-{
-	struct bsg_job *job = container_of(kref, struct bsg_job, kref);
-
-	put_device(job->dev);	/* release reference for the request */
-
-	kfree(job->request_payload.sg_list);
-	kfree(job->reply_payload.sg_list);
-	kfree(job);
-}
-
 /**
  * fc_bsg_jobdone - completion routine for bsg requests that the LLD has
  *                  completed
@@ -3640,7 +3624,7 @@ fc_bsg_job_timeout(struct request *req)
 		/* call LLDD to abort the i/o as it has timed out */
 		err = i->f->bsg_timeout(job);
 		if (err == -EAGAIN) {
-			kref_put(&job->kref, fc_destroy_bsgjob);
+			kref_put(&job->kref, bsg_destroy_job);
 			return BLK_EH_RESET_TIMER;
 		} else if (err)
 			printk(KERN_ERR "ERROR: FC BSG request timeout - LLD "
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 58e0717..67f7de6 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -69,5 +69,6 @@ void bsg_job_done(struct bsg_job *job, int result,
 int bsg_setup_queue(struct device *dev, struct request_queue *q, char *name,
 		    bsg_job_fn *job_fn, int dd_job_size);
 void bsg_request_fn(struct request_queue *q);
+void bsg_destroy_job(struct kref *kref);
 
 #endif
-- 
1.8.5.6

