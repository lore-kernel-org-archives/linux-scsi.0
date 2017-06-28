From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/28] 53c700: move bus reset to host reset
Date: Wed, 28 Jun 2017 10:25:10 +0200
Message-ID: <1498638316-44420-23-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52979 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751722AbdF1IbN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:13 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

bus reset always returns SUCCESS, meaning host reset was never
tested. At the same time the only difference to the HBA is a
missing call to NCR_700_chip_reset().
So add the missing call to bus reset, drop host reset, and move
bus reset to host reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/53c700.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 4b3b080..2b8cc32 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -168,7 +168,6 @@
 
 STATIC int NCR_700_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *);
 STATIC int NCR_700_abort(struct scsi_cmnd * SCpnt);
-STATIC int NCR_700_bus_reset(struct scsi_cmnd * SCpnt);
 STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
@@ -1938,14 +1937,14 @@ STATIC DEF_SCSI_QCMD(NCR_700_queuecommand)
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
@@ -1960,6 +1959,7 @@ STATIC DEF_SCSI_QCMD(NCR_700_queuecommand)
 
 	hostdata->eh_complete = &complete;
 	NCR_700_internal_bus_reset(SCp->device->host);
+	NCR_700_chip_reset(SCp->device->host);
 
 	spin_unlock_irq(SCp->device->host->host_lock);
 	wait_for_completion(&complete);
@@ -1974,22 +1974,6 @@ STATIC DEF_SCSI_QCMD(NCR_700_queuecommand)
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
