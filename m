From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/18] block/bsg: move queue creation into bsg_setup_queue
Date: Wed, 25 Jan 2017 18:25:24 +0100
Message-ID: <1485365126-23210-17-git-send-email-hch@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-1-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Simply the boilerplate code needed for bsg nodes a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/bsg-lib.c                     | 21 +++++++++++----------
 drivers/scsi/scsi_transport_fc.c    | 36 ++++++++----------------------------
 drivers/scsi/scsi_transport_iscsi.c | 15 ++++-----------
 include/linux/bsg-lib.h             |  5 ++---
 4 files changed, 25 insertions(+), 52 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 9d652a9..c74acf4 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -177,7 +177,7 @@ static int bsg_create_job(struct device *dev, struct request *req)
  *
  * Drivers/subsys should pass this to the queue init function.
  */
-void bsg_request_fn(struct request_queue *q)
+static void bsg_request_fn(struct request_queue *q)
 	__releases(q->queue_lock)
 	__acquires(q->queue_lock)
 {
@@ -214,24 +214,24 @@ void bsg_request_fn(struct request_queue *q)
 	put_device(dev);
 	spin_lock_irq(q->queue_lock);
 }
-EXPORT_SYMBOL_GPL(bsg_request_fn);
 
 /**
  * bsg_setup_queue - Create and add the bsg hooks so we can receive requests
  * @dev: device to attach bsg device to
- * @q: request queue setup by caller
  * @name: device to give bsg device
  * @job_fn: bsg job handler
  * @dd_job_size: size of LLD data needed for each job
- *
- * The caller should have setup the reuqest queue with bsg_request_fn
- * as the request_fn.
  */
-int bsg_setup_queue(struct device *dev, struct request_queue *q,
-		    char *name, bsg_job_fn *job_fn, int dd_job_size)
+struct request_queue *bsg_setup_queue(struct device *dev, char *name,
+		bsg_job_fn *job_fn, int dd_job_size)
 {
+	struct request_queue *q;
 	int ret;
 
+	q = blk_init_queue(bsg_request_fn, NULL);
+	if (!q)
+		return ERR_PTR(-ENOMEM);
+
 	q->queuedata = dev;
 	q->bsg_job_size = dd_job_size;
 	q->bsg_job_fn = job_fn;
@@ -243,9 +243,10 @@ int bsg_setup_queue(struct device *dev, struct request_queue *q,
 	if (ret) {
 		printk(KERN_ERR "%s: bsg interface failed to "
 		       "initialize - register queue\n", dev->kobj.name);
-		return ret;
+		blk_cleanup_queue(q);
+		return ERR_PTR(ret);
 	}
 
-	return 0;
+	return q;
 }
 EXPORT_SYMBOL_GPL(bsg_setup_queue);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index afcedec..13dcb9b 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3765,7 +3765,6 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 	struct device *dev = &shost->shost_gendev;
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct request_queue *q;
-	int err;
 	char bsg_name[20];
 
 	fc_host->rqst_q = NULL;
@@ -3776,24 +3775,14 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 	snprintf(bsg_name, sizeof(bsg_name),
 		 "fc_host%d", shost->host_no);
 
-	q = blk_init_queue(bsg_request_fn, NULL);
-	if (!q) {
-		dev_err(dev,
-			"fc_host%d: bsg interface failed to initialize - no request queue\n",
-			shost->host_no);
-		return -ENOMEM;
-	}
-
-	__scsi_init_queue(shost, q);
-	err = bsg_setup_queue(dev, q, bsg_name, fc_bsg_dispatch,
-				 i->f->dd_bsg_size);
-	if (err) {
+	q = bsg_setup_queue(dev, bsg_name, fc_bsg_dispatch, i->f->dd_bsg_size);
+	if (IS_ERR(q)) {
 		dev_err(dev,
 			"fc_host%d: bsg interface failed to initialize - setup queue\n",
 			shost->host_no);
-		blk_cleanup_queue(q);
-		return err;
+		return PTR_ERR(q);
 	}
+	__scsi_init_queue(shost, q);
 	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
 	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
 	fc_host->rqst_q = q;
@@ -3825,27 +3814,18 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
 	struct device *dev = &rport->dev;
 	struct fc_internal *i = to_fc_internal(shost->transportt);
 	struct request_queue *q;
-	int err;
 
 	rport->rqst_q = NULL;
 
 	if (!i->f->bsg_request)
 		return -ENOTSUPP;
 
-	q = blk_init_queue(bsg_request_fn, NULL);
-	if (!q) {
-		dev_err(dev, "bsg interface failed to initialize - no request queue\n");
-		return -ENOMEM;
-	}
-
-	__scsi_init_queue(shost, q);
-	err = bsg_setup_queue(dev, q, NULL, fc_bsg_dispatch, i->f->dd_bsg_size);
-	if (err) {
+	q = bsg_setup_queue(dev, NULL, fc_bsg_dispatch, i->f->dd_bsg_size);
+	if (IS_ERR(q)) {
 		dev_err(dev, "failed to setup bsg queue\n");
-		blk_cleanup_queue(q);
-		return err;
+		return PTR_ERR(q);
 	}
-
+	__scsi_init_queue(shost, q);
 	blk_queue_prep_rq(q, fc_bsg_rport_prep);
 	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
 	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 04ebe6e..568c9f2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1537,25 +1537,18 @@ iscsi_bsg_host_add(struct Scsi_Host *shost, struct iscsi_cls_host *ihost)
 	struct iscsi_internal *i = to_iscsi_internal(shost->transportt);
 	struct request_queue *q;
 	char bsg_name[20];
-	int ret;
 
 	if (!i->iscsi_transport->bsg_request)
 		return -ENOTSUPP;
 
 	snprintf(bsg_name, sizeof(bsg_name), "iscsi_host%d", shost->host_no);
-
-	q = blk_init_queue(bsg_request_fn, NULL);
-	if (!q)
-		return -ENOMEM;
-
-	__scsi_init_queue(shost, q);
-	ret = bsg_setup_queue(dev, q, bsg_name, iscsi_bsg_host_dispatch, 0);
-	if (ret) {
+	q = bsg_setup_queue(dev, bsg_name, iscsi_bsg_host_dispatch, 0);
+	if (IS_ERR(q)) {
 		shost_printk(KERN_ERR, shost, "bsg interface failed to "
 			     "initialize - no request queue\n");
-		blk_cleanup_queue(q);
-		return ret;
+		return PTR_ERR(q);
 	}
+	__scsi_init_queue(shost, q);
 
 	ihost->bsg_q = q;
 	return 0;
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 657a718..e34dde2 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -66,9 +66,8 @@ struct bsg_job {
 
 void bsg_job_done(struct bsg_job *job, int result,
 		  unsigned int reply_payload_rcv_len);
-int bsg_setup_queue(struct device *dev, struct request_queue *q, char *name,
-		    bsg_job_fn *job_fn, int dd_job_size);
-void bsg_request_fn(struct request_queue *q);
+struct request_queue *bsg_setup_queue(struct device *dev, char *name,
+		bsg_job_fn *job_fn, int dd_job_size);
 void bsg_job_put(struct bsg_job *job);
 int __must_check bsg_job_get(struct bsg_job *job);
 
-- 
2.1.4

