From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 28/28] NCR5380: Clear all unissued commands on host reset
Date: Wed, 28 Jun 2017 10:25:16 +0200
Message-ID: <1498638316-44420-29-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53070 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751652AbdF1IbS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:18 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When doing a host reset we should be clearing all outstanding
commands, not just the command triggering the reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/NCR5380.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 8a08122..429cb00 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2313,7 +2313,7 @@ static int NCR5380_host_reset(struct scsi_cmnd *cmd)
 	spin_lock_irqsave(&hostdata->lock, flags);
 
 #if (NDEBUG & NDEBUG_ANY)
-	scmd_printk(KERN_INFO, cmd, __func__);
+	shost_printk(KERN_INFO, instance, __func__);
 #endif
 	NCR5380_dprint(NDEBUG_ANY, instance);
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
@@ -2331,10 +2331,13 @@ static int NCR5380_host_reset(struct scsi_cmnd *cmd)
 	 * commands!
 	 */
 
-	if (list_del_cmd(&hostdata->unissued, cmd)) {
+	list_for_each_entry(ncmd, &hostdata->unissued, list) {
+		struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
+
 		cmd->result = DID_RESET << 16;
 		cmd->scsi_done(cmd);
 	}
+	INIT_LIST_HEAD(&hostdata->unissued);
 
 	if (hostdata->selecting) {
 		hostdata->selecting->result = DID_RESET << 16;
-- 
1.8.5.6
