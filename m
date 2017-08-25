From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 05/17] Document which queue type a function is intended for
Date: Fri, 25 Aug 2017 13:46:31 -0700
Message-ID: <20170825204643.25043-6-bart.vanassche@wdc.com>
References: <20170825204643.25043-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31397 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932929AbdHYUsN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 16:48:13 -0400
In-Reply-To: <20170825204643.25043-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Rename several functions to make it easy to see which queue type a
function is intended for.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c  | 23 ++++++++++++-----------
 drivers/scsi/scsi_priv.h |  2 +-
 drivers/scsi/scsi_scan.c |  2 +-
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 98c600442227..1e2d1d8becbc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2006,8 +2006,8 @@ static enum blk_eh_timer_return scsi_timeout(struct request *req,
 	return scsi_times_out(req);
 }
 
-static int scsi_init_request(struct blk_mq_tag_set *set, struct request *rq,
-		unsigned int hctx_idx, unsigned int numa_node)
+static int scsi_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
+				unsigned int hctx_idx, unsigned int numa_node)
 {
 	struct Scsi_Host *shost = set->driver_data;
 	const bool unchecked_isa_dma = shost->unchecked_isa_dma;
@@ -2031,8 +2031,8 @@ static int scsi_init_request(struct blk_mq_tag_set *set, struct request *rq,
 	return 0;
 }
 
-static void scsi_exit_request(struct blk_mq_tag_set *set, struct request *rq,
-		unsigned int hctx_idx)
+static void scsi_mq_exit_request(struct blk_mq_tag_set *set, struct request *rq,
+				 unsigned int hctx_idx)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
@@ -2109,7 +2109,8 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(__scsi_init_queue);
 
-static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
+static int scsi_old_init_rq(struct request_queue *q, struct request *rq,
+			    gfp_t gfp)
 {
 	struct Scsi_Host *shost = q->rq_alloc_data;
 	const bool unchecked_isa_dma = shost->unchecked_isa_dma;
@@ -2139,7 +2140,7 @@ static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
 	return -ENOMEM;
 }
 
-static void scsi_exit_rq(struct request_queue *q, struct request *rq)
+static void scsi_old_exit_rq(struct request_queue *q, struct request *rq)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 
@@ -2149,7 +2150,7 @@ static void scsi_exit_rq(struct request_queue *q, struct request *rq)
 			       cmd->sense_buffer);
 }
 
-struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
+struct request_queue *scsi_old_alloc_queue(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
 	struct request_queue *q;
@@ -2160,8 +2161,8 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 	q->cmd_size = sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
 	q->rq_alloc_data = shost;
 	q->request_fn = scsi_request_fn;
-	q->init_rq_fn = scsi_init_rq;
-	q->exit_rq_fn = scsi_exit_rq;
+	q->init_rq_fn = scsi_old_init_rq;
+	q->exit_rq_fn = scsi_old_exit_rq;
 	q->initialize_rq_fn = scsi_initialize_rq;
 
 	if (blk_init_allocated_queue(q) < 0) {
@@ -2185,8 +2186,8 @@ static const struct blk_mq_ops scsi_mq_ops = {
 #ifdef CONFIG_BLK_DEBUG_FS
 	.show_rq	= scsi_show_rq,
 #endif
-	.init_request	= scsi_init_request,
-	.exit_request	= scsi_exit_request,
+	.init_request	= scsi_mq_init_request,
+	.exit_request	= scsi_mq_exit_request,
 	.initialize_rq_fn = scsi_initialize_rq,
 	.map_queues	= scsi_map_queues,
 };
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index c11c1f9c912c..5c6d016a5ae9 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -88,7 +88,7 @@ extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern void scsi_requeue_run_queue(struct work_struct *work);
-extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
+extern struct request_queue *scsi_old_alloc_queue(struct scsi_device *sdev);
 extern struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev);
 extern void scsi_start_queue(struct scsi_device *sdev);
 extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fd88dabd599d..e7818afeda2b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -268,7 +268,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	if (shost_use_blk_mq(shost))
 		sdev->request_queue = scsi_mq_alloc_queue(sdev);
 	else
-		sdev->request_queue = scsi_alloc_queue(sdev);
+		sdev->request_queue = scsi_old_alloc_queue(sdev);
 	if (!sdev->request_queue) {
 		/* release fn is set up in scsi_sysfs_device_initialise, so
 		 * have to free and put manually here */
-- 
2.14.1
