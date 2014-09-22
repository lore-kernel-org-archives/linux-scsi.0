From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] scsi: move blk_mq_start_request call earlier
Date: Mon, 22 Sep 2014 15:59:31 +0200
Message-ID: <1411394371-16254-3-git-send-email-hch@lst.de>
References: <1411394371-16254-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54542 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaIVN5M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2014 09:57:12 -0400
In-Reply-To: <1411394371-16254-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Some ATA drivers need the dma drain size workaround, and thus need to
call blk_mq_start_request before the S/G mapping.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dc01ab2..56cc4b4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1846,6 +1846,8 @@ static int scsi_mq_prep_fn(struct request *req)
 		next_rq->special = bidi_sdb;
 	}
 
+	blk_mq_start_request(req);
+
 	return scsi_setup_cmnd(sdev, req);
 }
 
@@ -1880,17 +1882,19 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req,
 	if (!scsi_host_queue_ready(q, shost, sdev))
 		goto out_dec_target_busy;
 
+
 	if (!(req->cmd_flags & REQ_DONTPREP)) {
 		ret = prep_to_mq(scsi_mq_prep_fn(req));
 		if (ret)
 			goto out_dec_host_busy;
 		req->cmd_flags |= REQ_DONTPREP;
+	} else {
+		blk_mq_start_request(req);
 	}
 
 	scsi_init_cmd_errh(cmd);
 	cmd->scsi_done = scsi_mq_done;
 
-	blk_mq_start_request(req);
 	reason = scsi_dispatch_cmd(cmd);
 	if (reason) {
 		scsi_set_blocked(cmd, reason);
-- 
1.9.1

