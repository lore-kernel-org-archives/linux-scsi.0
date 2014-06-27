From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/7] ibmvfc: Do not call fc_block_scsi_eh() on host reset
Date: Fri, 27 Jun 2014 08:27:01 +0200
Message-ID: <1403850425-89297-4-git-send-email-hare@suse.de>
References: <1403850425-89297-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbaF0G1J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 02:27:09 -0400
In-Reply-To: <1403850425-89297-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Brian King <brking@linux.vnet.ibm.com>

When we're resetting the host any remote port states will
be reset anyway, so it's pointless to wait for dev_loss_tmo
during host reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 6eb47b6..e258594 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2530,13 +2530,9 @@ static int ibmvfc_eh_host_reset_handler(struct scsi_cmnd *cmd)
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
1.7.12.4

