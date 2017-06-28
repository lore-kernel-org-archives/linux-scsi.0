From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/28] ibmvfc: Do not call fc_block_scsi_eh() on host reset
Date: Wed, 28 Jun 2017 10:24:51 +0200
Message-ID: <1498638316-44420-4-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52879 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751515AbdF1IbB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:01 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When we're resetting the host any remote port states will
be reset anyway, so it's pointless to wait for dev_loss_tmo
during host reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 26cd3c2..bb033ce 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2528,16 +2528,12 @@ static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
  **/
 static int ibmvfc_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
-	int rc, block_rc;
+	int rc;
 	struct ibmvfc_host *vhost = shost_priv(cmd->device->host);
 
-	block_rc = fc_block_scsi_eh(cmd);
 	dev_err(vhost->dev, "Resetting connection due to error recovery\n");
 	rc = ibmvfc_issue_fc_host_lip(vhost->host);
 
-	if (block_rc == FAST_IO_FAIL)
-		return FAST_IO_FAIL;
-
 	return rc ? FAILED : SUCCESS;
 }
 
-- 
1.8.5.6
