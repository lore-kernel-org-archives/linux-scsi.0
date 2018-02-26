From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH] scsi: core: use blk_mq_requeue_request in __scsi_queue_insert
Date: Mon, 26 Feb 2018 15:58:52 +0800
Message-ID: <1519631932-1730-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

In scsi core, __scsi_queue_insert should just put request back on
the queue and retry using the same command as before. However, for
blk-mq, scsi_mq_requeue_cmd is employed here which will unprepare
the request. To align with the semantics of __scsi_queue_insert,
just use blk_mq_requeue_request with kick_requeue_list == true.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a86df9c..06d8110 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -191,7 +191,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
 	 */
 	cmd->result = 0;
 	if (q->mq_ops) {
-		scsi_mq_requeue_cmd(cmd);
+		blk_mq_requeue_request(cmd->request, true);
 		return;
 	}
 	spin_lock_irqsave(q->queue_lock, flags);
-- 
2.7.4
