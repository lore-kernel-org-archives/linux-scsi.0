From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/35] ibmvfc: Do not call fc_block_scsi_eh() on host reset
Date: Fri, 23 Jun 2017 15:02:23 +0200
Message-ID: <1498222975-71858-4-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60954 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751186AbdFWNDY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:24 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When we're resetting the host any remote port states will
be reset anyway, so it's pointless to wait for dev_loss_tmo
during host reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 26cd3c2..edf65df 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2531,13 +2531,9 @@ static int ibmvfc_eh_host_reset_handler(struct scsi_cmnd *cmd)
 	int rc, block_rc;
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
