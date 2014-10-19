From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] scsi: set REQ_QUEUE for the blk-mq case
Date: Sun, 19 Oct 2014 17:13:58 +0200
Message-ID: <1413731638-28305-3-git-send-email-hch@lst.de>
References: <1413731638-28305-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40621 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaJSPLe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Oct 2014 11:11:34 -0400
In-Reply-To: <1413731638-28305-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Meelis Roos <mroos@linux.ee>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

To generate the right SPI tag messages we need to properly set
QUEUE_FLAG_QUEUED in the request_queue and mirror it to the
request.

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
---
 drivers/scsi/scsi_lib.c | 5 +++++
 include/scsi/scsi_tcq.h | 8 ++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9eff8a3..50a6e1a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1893,6 +1893,11 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req,
 		blk_mq_start_request(req);
 	}
 
+	if (blk_queue_tagged(q))
+		req->cmd_flags |= REQ_QUEUED;
+	else
+		req->cmd_flags &= ~REQ_QUEUED;
+
 	scsi_init_cmd_errh(cmd);
 	cmd->scsi_done = scsi_mq_done;
 
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index e645835..56ed843 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -67,8 +67,9 @@ static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
 	if (!sdev->tagged_supported)
 		return;
 
-	if (!shost_use_blk_mq(sdev->host) &&
-	    !blk_queue_tagged(sdev->request_queue))
+	if (shost_use_blk_mq(sdev->host))
+		queue_flag_set_unlocked(QUEUE_FLAG_QUEUED, sdev->request_queue);
+	else if (!blk_queue_tagged(sdev->request_queue))
 		blk_queue_init_tags(sdev->request_queue, depth,
 				    sdev->host->bqt);
 
@@ -81,8 +82,7 @@ static inline void scsi_activate_tcq(struct scsi_device *sdev, int depth)
  **/
 static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
 {
-	if (!shost_use_blk_mq(sdev->host) &&
-	    blk_queue_tagged(sdev->request_queue))
+	if (blk_queue_tagged(sdev->request_queue))
 		blk_queue_free_tags(sdev->request_queue);
 	scsi_adjust_queue_depth(sdev, 0, depth);
 }
-- 
1.9.1

