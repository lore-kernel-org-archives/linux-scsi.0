From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 10/12] SRP transport, scsi-mq: Wait for .queue_rq() if
 necessary
Date: Wed, 26 Oct 2016 15:55:34 -0700
Message-ID: <0cd77719-1f11-d5c3-3186-1c7c3cfd6886@sandisk.com>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Ensure that if scsi-mq is enabled that scsi_wait_for_queuecommand()
waits until ongoing shost->hostt->queuecommand() calls have finished.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>
---
 drivers/scsi/scsi_lib.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c1561e7..9b8b19e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2724,8 +2724,6 @@ EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
 /**
  * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
  * @shost: SCSI host for which to count the number of scsi_request_fn() callers.
- *
- * To do: add support for scsi-mq in this function.
  */
 static int scsi_request_fn_active(struct Scsi_Host *shost)
 {
@@ -2744,12 +2742,20 @@ static int scsi_request_fn_active(struct Scsi_Host *shost)
 	return request_fn_active;
 }
 
+static void scsi_mq_wait_for_queuecommand(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, shost)
+		blk_mq_quiesce_queue(sdev->request_queue);
+}
+
 /**
  * scsi_wait_for_queuecommand() - wait for ongoing queuecommand() calls
  * @shost: SCSI host pointer.
  *
  * Wait until the ongoing shost->hostt->queuecommand() calls that are
- * invoked from scsi_request_fn() have finished.
+ * invoked from either scsi_request_fn() or scsi_queue_rq() have finished.
  *
  * To do: avoid that scsi_send_eh_cmnd() calls queuecommand() after
  * scsi_internal_device_block() has blocked a SCSI device and remove and also
@@ -2757,8 +2763,12 @@ static int scsi_request_fn_active(struct Scsi_Host *shost)
  */
 void scsi_wait_for_queuecommand(struct Scsi_Host *shost)
 {
-	while (scsi_request_fn_active(shost))
-		msleep(20);
+	if (shost->use_blk_mq) {
+		scsi_mq_wait_for_queuecommand(shost);
+	} else {
+		while (scsi_request_fn_active(shost))
+			msleep(20);
+	}
 }
 EXPORT_SYMBOL(scsi_wait_for_queuecommand);
 
-- 
2.10.1

