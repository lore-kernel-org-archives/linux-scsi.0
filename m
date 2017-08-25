From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 03/26] ibmvfc: Do not call fc_block_scsi_eh() on host reset
Date: Fri, 25 Aug 2017 13:56:58 +0200
Message-ID: <1503662241-127788-4-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49533 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756497AbdHYL57 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:57:59 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When we're resetting the host any remote port states will
be reset anyway, so it's pointless to wait for dev_loss_tmo
during host reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index cc4e05b..51f5248 100644
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
