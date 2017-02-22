From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 11/12] mpt3sas: simplify _wait_for_commands_to_complete()
Date: Wed, 22 Feb 2017 11:31:51 +0100
Message-ID: <1487759512-3873-12-git-send-email-hare@suse.de>
References: <1487759512-3873-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49705 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932133AbdBVKcC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 05:32:02 -0500
In-Reply-To: <1487759512-3873-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Use 'host_busy' instead of counting outstanding commands by hand.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index e6aafa5..169d185 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2408,9 +2408,9 @@ struct scsiio_tracker *
 	 * See _wait_for_commands_to_complete() call with regards to this code.
 	 */
 	if (ioc->shost_recovery && ioc->pending_io_count) {
-		if (ioc->pending_io_count == 1)
+		ioc->pending_io_count = atomic_read(&ioc->shost->host_busy);
+		if (ioc->pending_io_count == 0)
 			wake_up(&ioc->reset_wq);
-		ioc->pending_io_count--;
 	}
 }
 
@@ -5687,15 +5687,13 @@ struct scsiio_tracker *
  * _wait_for_commands_to_complete - reset controller
  * @ioc: Pointer to MPT_ADAPTER structure
  *
- * This function waiting(3s) for all pending commands to complete
+ * This function is waiting 10s for all pending commands to complete
  * prior to putting controller in reset.
  */
 static void
 _wait_for_commands_to_complete(struct MPT3SAS_ADAPTER *ioc)
 {
 	u32 ioc_state;
-	unsigned long flags;
-	u16 i;
 
 	ioc->pending_io_count = 0;
 
@@ -5704,11 +5702,7 @@ struct scsiio_tracker *
 		return;
 
 	/* pending command count */
-	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
-	for (i = 0; i < ioc->scsiio_depth; i++)
-		if (ioc->scsi_lookup[i].cb_idx != 0xFF)
-			ioc->pending_io_count++;
-	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	ioc->pending_io_count = atomic_read(&ioc->shost->host_busy);
 
 	if (!ioc->pending_io_count)
 		return;
-- 
1.8.5.6
