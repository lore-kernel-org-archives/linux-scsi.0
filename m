From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 22/26] 53c700: move bus reset to host reset
Date: Fri, 25 Aug 2017 13:57:17 +0200
Message-ID: <1503662241-127788-23-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49608 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756495AbdHYL6F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:58:05 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

bus reset always returns SUCCESS, meaning host reset was never
tested. At the same time the only difference to the HBA is a
missing call to NCR_700_chip_reset().
So add the missing call to bus reset, drop host reset, and move
bus reset to host reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/53c700.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 4b3b080..6be77b3 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -168,7 +168,6 @@
 
 STATIC int NCR_700_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *);
 STATIC int NCR_700_abort(struct scsi_cmnd * SCpnt);
-STATIC int NCR_700_bus_reset(struct scsi_cmnd * SCpnt);
 STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
@@ -315,7 +314,6 @@ struct Scsi_Host *
 	/* Fill in the missing routines from the host template */
 	tpnt->queuecommand = NCR_700_queuecommand;
 	tpnt->eh_abort_handler = NCR_700_abort;
-	tpnt->eh_bus_reset_handler = NCR_700_bus_reset;
 	tpnt->eh_host_reset_handler = NCR_700_host_reset;
 	tpnt->can_queue = NCR_700_COMMAND_SLOTS_PER_HOST;
 	tpnt->sg_tablesize = NCR_700_SG_SEGMENTS;
@@ -1938,14 +1936,14 @@ STATIC DEF_SCSI_QCMD(NCR_700_queuecommand)
 }
 
 STATIC int
-NCR_700_bus_reset(struct scsi_cmnd * SCp)
+NCR_700_host_reset(struct scsi_cmnd * SCp)
 {
 	DECLARE_COMPLETION_ONSTACK(complete);
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SCp->device->host->hostdata[0];
 
 	scmd_printk(KERN_INFO, SCp,
-		"New error handler wants BUS reset, cmd %p\n\t", SCp);
+		"New error handler wants HOST reset, cmd %p\n\t", SCp);
 	scsi_print_command(SCp);
 
 	/* In theory, eh_complete should always be null because the
@@ -1960,6 +1958,7 @@ STATIC DEF_SCSI_QCMD(NCR_700_queuecommand)
 
 	hostdata->eh_complete = &complete;
 	NCR_700_internal_bus_reset(SCp->device->host);
+	NCR_700_chip_reset(SCp->device->host);
 
 	spin_unlock_irq(SCp->device->host->host_lock);
 	wait_for_completion(&complete);
@@ -1974,22 +1973,6 @@ STATIC DEF_SCSI_QCMD(NCR_700_queuecommand)
 	return SUCCESS;
 }
 
-STATIC int
-NCR_700_host_reset(struct scsi_cmnd * SCp)
-{
-	scmd_printk(KERN_INFO, SCp, "New error handler wants HOST reset\n\t");
-	scsi_print_command(SCp);
-
-	spin_lock_irq(SCp->device->host->host_lock);
-
-	NCR_700_internal_bus_reset(SCp->device->host);
-	NCR_700_chip_reset(SCp->device->host);
-
-	spin_unlock_irq(SCp->device->host->host_lock);
-
-	return SUCCESS;
-}
-
 STATIC void
 NCR_700_set_period(struct scsi_target *STp, int period)
 {
-- 
1.8.5.6
