From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH] scsi: use blk_mq_run_hw_queues in scsi_kick_queue
Date: Wed,  8 Aug 2018 14:24:59 +0800
Message-ID: <1533709499-1661-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We don't use blk-mq start/stop hw queue any more, so no reason to
use blk_mq_start_hw_queues which does clear_bit, replace it with
blk_mq_run_hw_queues.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 41e9ac9..7de0f26 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -371,7 +371,7 @@ void scsi_device_unbusy(struct scsi_device *sdev)
 static void scsi_kick_queue(struct request_queue *q)
 {
 	if (q->mq_ops)
-		blk_mq_start_hw_queues(q);
+		blk_mq_run_hw_queues(q, false);
 	else
 		blk_run_queue(q);
 }
-- 
2.7.4
