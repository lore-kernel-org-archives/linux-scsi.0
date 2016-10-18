From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 09/11] SRP transport, scsi-mq: Wait for .queue_rq() if
 necessary
Date: Tue, 18 Oct 2016 14:52:53 -0700
Message-ID: <23d3615f-6905-0b60-a531-4a4d2cd9cf3f@sandisk.com>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0077.outbound.protection.outlook.com ([104.47.42.77]:4352
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756051AbcJRVw5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 17:52:57 -0400
In-Reply-To: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

Rename srp_wait_for_queuecommand() into scsi_wait_for_queuecommand().
Ensure that if scsi-mq is enabled that scsi_wait_for_queuecommand()
waits until ongoing shost->hostt->queuecommand() calls have finished.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>
---
 drivers/scsi/scsi_lib.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a5a1b5d..b7e9662 100644
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
@@ -2744,11 +2742,19 @@ static int scsi_request_fn_active(struct Scsi_Host *shost)
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
  *
  * Wait until the ongoing shost->hostt->queuecommand() calls that are
- * invoked from scsi_request_fn() have finished.
+ * invoked from either scsi_request_fn() or scsi_queue_rq() have finished.
  *
  * To do: avoid that scsi_send_eh_cmnd() calls queuecommand() after
  * scsi_internal_device_block() has blocked a SCSI device and remove and also
@@ -2756,8 +2762,12 @@ static int scsi_request_fn_active(struct Scsi_Host *shost)
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

