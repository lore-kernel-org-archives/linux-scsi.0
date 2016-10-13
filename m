From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/24] libfc: Clarify ramp-down messages
Date: Thu, 13 Oct 2016 15:10:48 +0200
Message-ID: <1476364260-12191-13-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40759 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755654AbcJMNXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:23:49 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When the queue depth is reduced we should print out the reason
for this; it might be due to a queue full condition.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_fcp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 0e2a201..f7700cc 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -403,8 +403,6 @@ static void fc_fcp_can_queue_ramp_down(struct fc_lport *lport)
 	if (!can_queue)
 		can_queue = 1;
 	lport->host->can_queue = can_queue;
-	shost_printk(KERN_ERR, lport->host, "libfc: Could not allocate frame.\n"
-		     "Reducing can_queue to %d.\n", can_queue);
 
 unlock:
 	spin_unlock_irqrestore(lport->host->host_lock, flags);
@@ -431,6 +429,9 @@ static inline struct fc_frame *fc_fcp_frame_alloc(struct fc_lport *lport,
 	put_cpu();
 	/* error case */
 	fc_fcp_can_queue_ramp_down(lport);
+	shost_printk(KERN_ERR, lport->host,
+		     "libfc: Could not allocate frame, "
+		     "reducing can_queue to %d.\n", lport->host->can_queue);
 	return NULL;
 }
 
@@ -1860,8 +1861,13 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 	rpriv = rport->dd_data;
 
 	if (!fc_fcp_lport_queue_ready(lport)) {
-		if (lport->qfull)
+		if (lport->qfull) {
 			fc_fcp_can_queue_ramp_down(lport);
+			shost_printk(KERN_ERR, lport->host,
+				     "libfc: queue full, "
+				     "reducing can_queue to %d.\n",
+				     lport->host->can_queue);
+		}
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 		goto out;
 	}
-- 
1.8.5.6

