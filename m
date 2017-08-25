From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] bsg-lib: pass the release callback through bsg_setup_queue
Date: Fri, 25 Aug 2017 17:37:38 +0200
Message-ID: <20170825153741.5091-2-hch@lst.de>
References: <20170825153741.5091-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47861 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933386AbdHYPhs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 11:37:48 -0400
In-Reply-To: <20170825153741.5091-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chaitra Basappa <chaitra.basappa@broadcom.com>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bart.vanassche@wdc.com>

The SAS code will need it.  Also mark the name argument const to match
bsg_register_queue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bsg-lib.c                     | 7 ++++---
 drivers/scsi/scsi_transport_fc.c    | 6 ++++--
 drivers/scsi/scsi_transport_iscsi.c | 2 +-
 include/linux/bsg-lib.h             | 5 +++--
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index dd56d7460cb9..c82408c7cc3c 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -239,8 +239,9 @@ static void bsg_exit_rq(struct request_queue *q, struct request *req)
  * @job_fn: bsg job handler
  * @dd_job_size: size of LLD data needed for each job
  */
-struct request_queue *bsg_setup_queue(struct device *dev, char *name,
-		bsg_job_fn *job_fn, int dd_job_size)
+struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
+		bsg_job_fn *job_fn, int dd_job_size,
+		void (*release)(struct device *))
 {
 	struct request_queue *q;
 	int ret;
@@ -264,7 +265,7 @@ struct request_queue *bsg_setup_queue(struct device *dev, char *name,
 	blk_queue_softirq_done(q, bsg_softirq_done);
 	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
 
-	ret = bsg_register_queue(q, dev, name, NULL);
+	ret = bsg_register_queue(q, dev, name, release);
 	if (ret) {
 		printk(KERN_ERR "%s: bsg interface failed to "
 		       "initialize - register queue\n", dev->kobj.name);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 892fbd9800d9..0b453583fce0 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3763,7 +3763,8 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 	snprintf(bsg_name, sizeof(bsg_name),
 		 "fc_host%d", shost->host_no);
 
-	q = bsg_setup_queue(dev, bsg_name, fc_bsg_dispatch, i->f->dd_bsg_size);
+	q = bsg_setup_queue(dev, bsg_name, fc_bsg_dispatch, i->f->dd_bsg_size,
+			NULL);
 	if (IS_ERR(q)) {
 		dev_err(dev,
 			"fc_host%d: bsg interface failed to initialize - setup queue\n",
@@ -3808,7 +3809,8 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
 	if (!i->f->bsg_request)
 		return -ENOTSUPP;
 
-	q = bsg_setup_queue(dev, NULL, fc_bsg_dispatch, i->f->dd_bsg_size);
+	q = bsg_setup_queue(dev, NULL, fc_bsg_dispatch, i->f->dd_bsg_size,
+			NULL);
 	if (IS_ERR(q)) {
 		dev_err(dev, "failed to setup bsg queue\n");
 		return PTR_ERR(q);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index a424eaeafeb0..75b3a8d015e1 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1542,7 +1542,7 @@ iscsi_bsg_host_add(struct Scsi_Host *shost, struct iscsi_cls_host *ihost)
 		return -ENOTSUPP;
 
 	snprintf(bsg_name, sizeof(bsg_name), "iscsi_host%d", shost->host_no);
-	q = bsg_setup_queue(dev, bsg_name, iscsi_bsg_host_dispatch, 0);
+	q = bsg_setup_queue(dev, bsg_name, iscsi_bsg_host_dispatch, 0, NULL);
 	if (IS_ERR(q)) {
 		shost_printk(KERN_ERR, shost, "bsg interface failed to "
 			     "initialize - no request queue\n");
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 637a20cfb237..b1be0233ce35 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -68,8 +68,9 @@ struct bsg_job {
 
 void bsg_job_done(struct bsg_job *job, int result,
 		  unsigned int reply_payload_rcv_len);
-struct request_queue *bsg_setup_queue(struct device *dev, char *name,
-		bsg_job_fn *job_fn, int dd_job_size);
+struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
+		bsg_job_fn *job_fn, int dd_job_size,
+		void (*release)(struct device *));
 void bsg_job_put(struct bsg_job *job);
 int __must_check bsg_job_get(struct bsg_job *job);
 
-- 
2.11.0
