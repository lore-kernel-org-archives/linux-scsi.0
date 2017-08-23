From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 06/19] Document which queue type a function is intended for
Date: Wed, 23 Aug 2017 14:39:56 -0700
Message-ID: <20170823214009.15015-7-bart.vanassche@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60815 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdHWVmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:42:12 -0400
In-Reply-To: <20170823214009.15015-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

Document which queue type a function is intended for if this is not
easy to derive from the function name.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f9a0d5b13707..1905962fb992 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2006,6 +2006,7 @@ static enum blk_eh_timer_return scsi_timeout(struct request *req,
 	return scsi_times_out(req);
 }
 
+/* scsi-mq */
 static int scsi_init_request(struct blk_mq_tag_set *set, struct request *rq,
 		unsigned int hctx_idx, unsigned int numa_node)
 {
@@ -2031,6 +2032,7 @@ static int scsi_init_request(struct blk_mq_tag_set *set, struct request *rq,
 	return 0;
 }
 
+/* scsi-mq */
 static void scsi_exit_request(struct blk_mq_tag_set *set, struct request *rq,
 		unsigned int hctx_idx)
 {
@@ -2070,6 +2072,7 @@ static u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 	return bounce_limit;
 }
 
+/* scsi-sq and scsi-mq */
 void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 {
 	struct device *dev = shost->dma_dev;
@@ -2109,6 +2112,7 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(__scsi_init_queue);
 
+/* scsi-sq */
 static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
 {
 	struct Scsi_Host *shost = q->rq_alloc_data;
@@ -2139,6 +2143,7 @@ static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
 	return -ENOMEM;
 }
 
+/* scsi-sq */
 static void scsi_exit_rq(struct request_queue *q, struct request *rq)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
@@ -2149,6 +2154,7 @@ static void scsi_exit_rq(struct request_queue *q, struct request *rq)
 			       cmd->sense_buffer);
 }
 
+/* scsi-sq */
 struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
-- 
2.14.0
