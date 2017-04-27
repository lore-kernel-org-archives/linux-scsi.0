From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] libfc: do not flood console with messages 'libfc: queue full ...'
Date: Thu, 27 Apr 2017 16:25:03 +0200
Message-ID: <1493303103-113774-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39058 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751594AbdD0OZI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Apr 2017 10:25:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When the FCoE sending side becomes congested libfc tries to
reduce the queue depth on the host; however due to the built-in
lag before attempting to ramp down the queue depth _again_ the
message log is flooded with messages

libfc: queue full, reducing can_queue to 512

With this patch the message is printed only once (ie when it's
actually changed).

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_fcp.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index a808e8e..234352da 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -407,11 +407,12 @@ static void fc_fcp_can_queue_ramp_up(struct fc_lport *lport)
  * can_queue. Eventually we will hit the point where we run
  * on all reserved structs.
  */
-static void fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
+static bool fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 {
 	struct fc_fcp_internal *si = fc_get_scsi_internal(lport);
 	unsigned long flags;
 	int can_queue;
+	bool changed = false;
 
 	spin_lock_irqsave(lport->host->host_lock, flags);
 
@@ -427,9 +428,11 @@ static void fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 	if (!can_queue)
 		can_queue = 1;
 	lport->host->can_queue = can_queue;
+	changed = true;
 
 unlock:
 	spin_unlock_irqrestore(lport->host->host_lock, flags);
+	return changed;
 }
 
 /*
@@ -1896,11 +1899,11 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 
 	if (!fc_fcp_lport_queue_ready(lport)) {
 		if (lport->qfull) {
-			fc_fcp_can_queue_ramp_down(lport);
-			shost_printk(KERN_ERR, lport->host,
-				     "libfc: queue full, "
-				     "reducing can_queue to %d.\n",
-				     lport->host->can_queue);
+			if (fc_fcp_can_queue_ramp_down(lport))
+				shost_printk(KERN_ERR, lport->host,
+					     "libfc: queue full, "
+					     "reducing can_queue to %d.\n",
+					     lport->host->can_queue);
 		}
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
-- 
1.8.5.6
