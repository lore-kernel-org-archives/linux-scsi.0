From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: mq queue stall during command requeue
Date: Thu, 19 Jan 2017 15:17:45 +0100
Message-ID: <1484835465-66514-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752748AbdASOTI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Jan 2017 09:19:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When we're hitting a busy condition in queuecommand() we need to
stop the hardware queue before calling blk_mq_delay_queue(); if
we don't blk_mq_delay_queue() will not do anything and requeue
will never triggered.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9e1e14..4b1cbc6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1951,8 +1951,10 @@ static int scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	switch (ret) {
 	case BLK_MQ_RQ_QUEUE_BUSY:
 		if (atomic_read(&sdev->device_busy) == 0 &&
-		    !scsi_device_blocked(sdev))
+		    !scsi_device_blocked(sdev)) {
+			blk_mq_stop_hw_queue(hctx);
 			blk_mq_delay_queue(hctx, SCSI_QUEUE_DELAY);
+		}
 		break;
 	case BLK_MQ_RQ_QUEUE_ERROR:
 		/*
-- 
1.8.5.6

