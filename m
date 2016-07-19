From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/6] block: Introduce BLKPREP_DONE
Date: Tue, 19 Jul 2016 15:20:38 +0200
Message-ID: <1468934439-93579-6-git-send-email-hare@suse.de>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbcGSNUn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 09:20:43 -0400
In-Reply-To: <1468934439-93579-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>

Add a new blkprep return code BLKPREP_DONE to signal completion
without I/O error.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c        | 6 +++++-
 drivers/scsi/scsi_lib.c | 1 +
 include/linux/blkdev.h  | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e273194..4bcf30a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2462,9 +2462,13 @@ struct request *blk_peek_request(struct request_queue *q)
 
 			rq = NULL;
 			break;
-		} else if (ret == BLKPREP_KILL || ret == BLKPREP_INVALID) {
+		} else if (ret == BLKPREP_KILL || ret == BLKPREP_INVALID ||
+			   ret == BLKPREP_DONE) {
 			int err = (ret == BLKPREP_INVALID) ? -EREMOTEIO : -EIO;
 
+			if (ret == BLKPREP_DONE)
+				err = 0;
+
 			rq->cmd_flags |= REQ_QUIET;
 			/*
 			 * Mark this request as started so we don't trigger
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b2e332a..f112926 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1257,6 +1257,7 @@ scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 	case BLKPREP_KILL:
 	case BLKPREP_INVALID:
 		req->errors = DID_NO_CONNECT << 16;
+	case BLKPREP_DONE:
 		/* release the command and kill it */
 		if (req->special) {
 			struct scsi_cmnd *cmd = req->special;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d5e3d8b..c351444 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -736,6 +736,7 @@ enum {
 	BLKPREP_KILL,		/* fatal error, kill, return -EIO */
 	BLKPREP_DEFER,		/* leave on queue */
 	BLKPREP_INVALID,	/* invalid command, kill, return -EREMOTEIO */
+	BLKPREP_DONE,		/* complete w/o error */
 };
 
 extern unsigned long blk_max_low_pfn, blk_max_pfn;
-- 
1.8.5.6

