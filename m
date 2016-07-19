From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] block: Add 'BLK_MQ_RQ_QUEUE_DONE' return value
Date: Tue, 19 Jul 2016 15:20:39 +0200
Message-ID: <1468934439-93579-7-git-send-email-hare@suse.de>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbcGSNUn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 09:20:43 -0400
In-Reply-To: <1468934439-93579-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add a return value BLK_MQ_RQ_QUEUE_DONE to terminate a request
without error.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-mq.c          | 1 +
 drivers/scsi/scsi_lib.c | 3 +++
 include/linux/blk-mq.h  | 1 +
 3 files changed, 5 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7df9c92..cd25d68 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -793,6 +793,7 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 			pr_err("blk-mq: bad return on queue: %d\n", ret);
 		case BLK_MQ_RQ_QUEUE_ERROR:
 			rq->errors = -EIO;
+		case BLK_MQ_RQ_QUEUE_DONE:
 			blk_mq_end_request(rq, rq->errors);
 			break;
 		}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f112926..d74108b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1802,6 +1802,8 @@ static inline int prep_to_mq(int ret)
 		return 0;
 	case BLKPREP_DEFER:
 		return BLK_MQ_RQ_QUEUE_BUSY;
+	case BLKPREP_DONE:
+		return BLK_MQ_RQ_QUEUE_DONE;
 	default:
 		return BLK_MQ_RQ_QUEUE_ERROR;
 	}
@@ -1945,6 +1947,7 @@ out:
 			blk_mq_delay_queue(hctx, SCSI_QUEUE_DELAY);
 		break;
 	case BLK_MQ_RQ_QUEUE_ERROR:
+	case BLK_MQ_RQ_QUEUE_DONE:
 		/*
 		 * Make sure to release all allocated ressources when
 		 * we hit an error, as we will never see this command
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2498fdf..f7a9e97 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -151,6 +151,7 @@ enum {
 	BLK_MQ_RQ_QUEUE_OK	= 0,	/* queued fine */
 	BLK_MQ_RQ_QUEUE_BUSY	= 1,	/* requeue IO for later */
 	BLK_MQ_RQ_QUEUE_ERROR	= 2,	/* end IO with error */
+	BLK_MQ_RQ_QUEUE_DONE	= 3,	/* end IO w/o error */
 
 	BLK_MQ_F_SHOULD_MERGE	= 1 << 0,
 	BLK_MQ_F_TAG_SHARED	= 1 << 1,
-- 
1.8.5.6

