From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 6/7] SRP transport: Port srp_wait_for_queuecommand() to
 scsi-mq
Date: Wed, 28 Sep 2016 17:01:22 -0700
Message-ID: <bedf4b45-00b0-6844-047d-f1e05bb1092f@sandisk.com>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Ensure that if scsi-mq is enabled that srp_wait_for_queuecommand()
waits until ongoing shost->hostt->queuecommand() calls have finished.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>
---
 drivers/scsi/scsi_transport_srp.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index e3cd3ec..f1d580e 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/delay.h>
+#include <linux/blk-mq.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -405,8 +406,6 @@ static void srp_reconnect_work(struct work_struct *work)
 /**
  * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
  * @shost: SCSI host for which to count the number of scsi_request_fn() callers.
- *
- * To do: add support for scsi-mq in this function.
  */
 static int scsi_request_fn_active(struct Scsi_Host *shost)
 {
@@ -425,11 +424,28 @@ static int scsi_request_fn_active(struct Scsi_Host *shost)
 	return request_fn_active;
 }
 
+static void srp_mq_wait_for_queuecommand(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+	struct request_queue *q;
+
+	shost_for_each_device(sdev, shost) {
+		q = sdev->request_queue;
+
+		blk_mq_quiesce_queue(q);
+		blk_mq_resume_queue(q);
+	}
+}
+
 /* Wait until ongoing shost->hostt->queuecommand() calls have finished. */
 static void srp_wait_for_queuecommand(struct Scsi_Host *shost)
 {
-	while (scsi_request_fn_active(shost))
-		msleep(20);
+	if (shost->use_blk_mq) {
+		srp_mq_wait_for_queuecommand(shost);
+	} else {
+		while (scsi_request_fn_active(shost))
+			msleep(20);
+	}
 }
 
 static void __rport_fail_io_fast(struct srp_rport *rport)
-- 
2.10.0

