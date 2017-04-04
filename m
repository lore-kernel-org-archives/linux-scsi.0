From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv5 3/8] scsi: always send command aborts
Date: Tue,  4 Apr 2017 16:26:47 +0200
Message-ID: <1491316012-105426-4-git-send-email-hare@suse.de>
References: <1491316012-105426-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752582AbdDDO0z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Apr 2017 10:26:55 -0400
In-Reply-To: <1491316012-105426-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>

When a command has timed out we always should be sending an
abort; with the previous code a failed abort might signal
SCSI EH to start, and all other timed out commands will
never be aborted, even though they might belong to a
different ITL nexus.

Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 370f6c0..cff7d9d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -196,19 +196,7 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 		return FAILED;
 	}
 
-	/*
-	 * Do not try a command abort if
-	 * SCSI EH has already started.
-	 */
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (scsi_host_in_recovery(shost)) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		SCSI_LOG_ERROR_RECOVERY(3,
-			scmd_printk(KERN_INFO, scmd,
-				    "not aborting, host in recovery\n"));
-		return FAILED;
-	}
-
 	if (shost->eh_deadline != -1 && !shost->last_reset)
 		shost->last_reset = jiffies;
 	spin_unlock_irqrestore(shost->host_lock, flags);
-- 
1.8.5.6
