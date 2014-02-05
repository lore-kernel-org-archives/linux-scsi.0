From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/15] scsi: factor out __scsi_init_queue
Date: Wed, 05 Feb 2014 04:41:29 -0800
Message-ID: <20140205124154.136919713@bombadil.infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53240 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaBEMlz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:55 -0500
Content-Disposition: inline; filename=0011-scsi-factor-out-__scsi_init_queue.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Factor code common out so that it can be reused independently for the blk-mq
code path.

Split from a bigger patch by Nicholas Bellinger.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3b3c3ab..e67950c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1690,16 +1690,10 @@ u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(scsi_calculate_bounce_limit);
 
-struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
-					 request_fn_proc *request_fn)
+static void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 {
-	struct request_queue *q;
 	struct device *dev = shost->dma_dev;
 
-	q = blk_init_queue(request_fn, NULL);
-	if (!q)
-		return NULL;
-
 	/*
 	 * this limit is imposed by hardware restrictions
 	 */
@@ -1730,7 +1724,17 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	 * blk_queue_update_dma_alignment() later.
 	 */
 	blk_queue_dma_alignment(q, 0x03);
+}
 
+struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
+					 request_fn_proc *request_fn)
+{
+	struct request_queue *q;
+
+	q = blk_init_queue(request_fn, NULL);
+	if (!q)
+		return NULL;
+	__scsi_init_queue(shost, q);
 	return q;
 }
 EXPORT_SYMBOL(__scsi_alloc_queue);
-- 
1.7.10.4


