From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 34/47] aha152x: look for stuck command when resetting device
Date: Wed, 28 Jun 2017 10:33:00 +0200
Message-ID: <1498638793-44672-35-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53784 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751522AbdF1Id1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:27 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

From: Hannes Reinecke <hare@suse.com>

The LLDD needs a command to send the reset with, so look at the
list of outstanding commands to get one.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aha152x.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 857884a..896c36e 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1055,23 +1055,27 @@ static int aha152x_abort(Scsi_Cmnd *SCpnt)
 static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
+	struct scsi_cmnd *SCprev = NULL;
 	DECLARE_COMPLETION(done);
 	int ret, issued, disconnected;
-	unsigned char old_cmd_len = SCpnt->cmd_len;
+	unsigned char old_cmd_len;
 	unsigned long flags;
 	unsigned long timeleft;
 
-	if(CURRENT_SC==SCpnt) {
-		scmd_printk(KERN_ERR, SCpnt, "cannot reset current device\n");
-		return FAILED;
-	}
-
 	DO_LOCK(flags);
-	issued       = remove_SC(&ISSUE_SC, SCpnt) == NULL;
-	disconnected = issued && remove_SC(&DISCONNECTED_SC, SCpnt);
+	/* Look for the stuck command */
+	SCpnt = remove_lun_SC(&ISSUE_SC, sdev->id, sdev->lun);
+	if (SCpnt)
+		issued = 1;
+	else
+		SCpnt = remove_lun_SC(&DISCONNECTED_SC, sdev->id, sdev->lun);
+	if (!issued && SCpnt)
+		disconnected = 1;
 	DO_UNLOCK(flags);
-
-	SCpnt->cmd_len         = 0;
+	if (!SCpnt)
+		return FAILED;
+	old_cmd_len = SCpnt->cmd_len;
+	SCpnt->cmd_len = 0;
 
 	aha152x_internal_queue(SCpnt, &done, resetting, reset_done);
 
-- 
1.8.5.6
