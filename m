From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3 11/16] scsi: fc: Use bsg_destroy_job
Date: Thu, 13 Oct 2016 17:00:27 +0200
Message-ID: <c21eeb69af1be44091fa0dbe13ff1d01c838526c.1476369687.git.jthumshirn@suse.de>
References: <cover.1476369687.git.jthumshirn@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cover.1476369687.git.jthumshirn@suse.de>
In-Reply-To: <cover.1476369687.git.jthumshirn@suse.de>
References: <cover.1476369687.git.jthumshirn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

fc_destroy_bsgjob() and bsg_destroy_job() are now 1:1 copies, so use the
later. As bsg_destroy_job() comes from bsg-lib we need to select it in Kconfig
once CONFOG_SCSI_FC_ATTRS is active.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 block/bsg-lib.c                  |  7 +++++--
 drivers/scsi/Kconfig             |  1 +
 drivers/scsi/scsi_transport_fc.c | 23 ++---------------------
 include/linux/bsg-lib.h          |  1 +
 4 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 632fb40..9f1e8fd 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -32,9 +32,12 @@
  * bsg_destroy_job - routine to teardown/delete a bsg job
  * @job: bsg_job that is to be torn down
  */
-static void bsg_destroy_job(struct kref *kref)
+void bsg_destroy_job(struct kref *kref)
 {
 	struct bsg_job *job = container_of(kref, struct bsg_job, kref);
+	struct request *rq = job->req;
+
+	blk_end_request_all(rq, rq->errors);
 
 	put_device(job->dev);	/* release reference for the request */
 
@@ -42,6 +45,7 @@ static void bsg_destroy_job(struct kref *kref)
 	kfree(job->reply_payload.sg_list);
 	kfree(job);
 }
+EXPORT_SYMBOL_GPL(bsg_destroy_job);
 
 /**
  * bsg_job_done - completion routine for bsg requests
@@ -85,7 +89,6 @@ static void bsg_softirq_done(struct request *rq)
 {
 	struct bsg_job *job = rq->special;
 
-	blk_end_request_all(rq, rq->errors);
 	kref_put(&job->kref, bsg_destroy_job);
 }
 
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3e2bdb9..2774756 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -263,6 +263,7 @@ config SCSI_SPI_ATTRS
 config SCSI_FC_ATTRS
 	tristate "FiberChannel Transport Attributes"
 	depends on SCSI && NET
+	select BLK_DEV_BSGLIB
 	select SCSI_NETLINK
 	help
 	  If you wish to export transport-specific information about
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index eadc80f..d2d0a27 100644
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
@@ -3554,26 +3555,6 @@ struct fc_vport *
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
-	struct request *rq = job->req;
-
-	blk_end_request_all(rq, rq->errors);
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
@@ -3642,7 +3623,7 @@ static void fc_bsg_softirq_done(struct request *rq)
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

