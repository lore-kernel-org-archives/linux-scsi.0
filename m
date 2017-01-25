From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/18] scsi: remove __scsi_alloc_queue
Date: Wed, 25 Jan 2017 18:25:22 +0100
Message-ID: <1485365126-23210-15-git-send-email-hch@lst.de>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54278 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751990AbdAYR0Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2017 12:26:16 -0500
In-Reply-To: <1485365126-23210-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com

Instead do an internal export of __scsi_init_queue for the transport
classes that export BSG nodes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c             | 19 ++++---------------
 drivers/scsi/scsi_transport_fc.c    |  6 ++++--
 drivers/scsi/scsi_transport_iscsi.c |  3 ++-
 include/scsi/scsi_host.h            |  2 --
 include/scsi/scsi_transport.h       |  2 ++
 5 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3d6b364..7950516 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2082,7 +2082,7 @@ static u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 	return bounce_limit;
 }
 
-static void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
+void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 {
 	struct device *dev = shost->dma_dev;
 
@@ -2117,28 +2117,17 @@ static void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 	 */
 	blk_queue_dma_alignment(q, 0x03);
 }
-
-struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
-					 request_fn_proc *request_fn)
-{
-	struct request_queue *q;
-
-	q = blk_init_queue(request_fn, NULL);
-	if (!q)
-		return NULL;
-	__scsi_init_queue(shost, q);
-	return q;
-}
-EXPORT_SYMBOL(__scsi_alloc_queue);
+EXPORT_SYMBOL_GPL(__scsi_init_queue);
 
 struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 {
 	struct request_queue *q;
 
-	q = __scsi_alloc_queue(sdev->host, scsi_request_fn);
+	q = blk_init_queue(scsi_request_fn, NULL);
 	if (!q)
 		return NULL;
 
+	__scsi_init_queue(sdev->host, q);
 	blk_queue_prep_rq(q, scsi_prep_fn);
 	blk_queue_unprep_rq(q, scsi_unprep_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 03577bd..afcedec 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3776,7 +3776,7 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 	snprintf(bsg_name, sizeof(bsg_name),
 		 "fc_host%d", shost->host_no);
 
-	q = __scsi_alloc_queue(shost, bsg_request_fn);
+	q = blk_init_queue(bsg_request_fn, NULL);
 	if (!q) {
 		dev_err(dev,
 			"fc_host%d: bsg interface failed to initialize - no request queue\n",
@@ -3784,6 +3784,7 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
 		return -ENOMEM;
 	}
 
+	__scsi_init_queue(shost, q);
 	err = bsg_setup_queue(dev, q, bsg_name, fc_bsg_dispatch,
 				 i->f->dd_bsg_size);
 	if (err) {
@@ -3831,12 +3832,13 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
 	if (!i->f->bsg_request)
 		return -ENOTSUPP;
 
-	q = __scsi_alloc_queue(shost, bsg_request_fn);
+	q = blk_init_queue(bsg_request_fn, NULL);
 	if (!q) {
 		dev_err(dev, "bsg interface failed to initialize - no request queue\n");
 		return -ENOMEM;
 	}
 
+	__scsi_init_queue(shost, q);
 	err = bsg_setup_queue(dev, q, NULL, fc_bsg_dispatch, i->f->dd_bsg_size);
 	if (err) {
 		dev_err(dev, "failed to setup bsg queue\n");
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 42bca61..04ebe6e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1544,10 +1544,11 @@ iscsi_bsg_host_add(struct Scsi_Host *shost, struct iscsi_cls_host *ihost)
 
 	snprintf(bsg_name, sizeof(bsg_name), "iscsi_host%d", shost->host_no);
 
-	q = __scsi_alloc_queue(shost, bsg_request_fn);
+	q = blk_init_queue(bsg_request_fn, NULL);
 	if (!q)
 		return -ENOMEM;
 
+	__scsi_init_queue(shost, q);
 	ret = bsg_setup_queue(dev, q, bsg_name, iscsi_bsg_host_dispatch, 0);
 	if (ret) {
 		shost_printk(KERN_ERR, shost, "bsg interface failed to "
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 36680f1..f4964d7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -826,8 +826,6 @@ extern void scsi_block_requests(struct Scsi_Host *);
 
 struct class_container;
 
-extern struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
-						void (*) (struct request_queue *));
 /*
  * These two functions are used to allocate and free a pseudo device
  * which will connect to the host adapter itself rather than any
diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index 8129239..b6e07b5 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -119,4 +119,6 @@ scsi_transport_device_data(struct scsi_device *sdev)
 		+ shost->transportt->device_private_offset;
 }
 
+void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q);
+
 #endif /* SCSI_TRANSPORT_H */
-- 
2.1.4

