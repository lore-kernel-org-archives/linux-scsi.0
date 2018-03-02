From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH V3] scsi: core: use blk_mq_requeue_request in __scsi_queue_insert
Date: Fri,  2 Mar 2018 11:31:14 +0800
Message-ID: <1519961474-15236-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Bart.VanAssche@wdc.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

In scsi core, __scsi_queue_insert should just put request back on
the queue and retry using the same command as before. However, for
blk-mq, scsi_mq_requeue_cmd is employed here which will unprepare
the request. To align with the semantics of __scsi_queue_insert,
use blk_mq_requeue_request with kick_requeue_list == true and put
the reference of scsi_device.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>

---
Changelog:
V2 -> V3:
 - add commit to explain why we need a put_device in
   __scsi_queue_insert
 - add reviewed-by

V1 -> V2:
 - add put_device on scsi_device->sdev_gendev

 drivers/scsi/scsi_lib.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a86df9c..d2f1838 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -191,7 +191,13 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
 	 */
 	cmd->result = 0;
 	if (q->mq_ops) {
-		scsi_mq_requeue_cmd(cmd);
+		/*
+		 * scsi_device.sdev_gendev will be get every time in .get_budget and
+		 * be put in scsi_end_request. Hence we need to put the reference
+		 * here when we decide to requeue request.
+		 */
+		blk_mq_requeue_request(cmd->request, true);
+		put_device(&device->sdev_gendev);
 		return;
 	}
 	spin_lock_irqsave(q->queue_lock, flags);
-- 
2.7.4
