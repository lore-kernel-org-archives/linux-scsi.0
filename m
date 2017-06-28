From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/28] fnic: do not call host reset from command abort
Date: Wed, 28 Jun 2017 10:24:53 +0200
Message-ID: <1498638316-44420-6-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52976 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751642AbdF1IbF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:05 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

command abort already returns FAILED, which will then be escalated
to a host reset. So no need to call host_reset directly.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/fnic/fnic_scsi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 6c0646d..242e2ee 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1990,10 +1990,6 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 			"Issuing Host reset due to out of order IO\n");
 
-		if (fnic_host_reset(sc) == FAILED) {
-			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
-				"fnic_host_reset failed.\n");
-		}
 		ret = FAILED;
 		goto fnic_abort_cmd_end;
 	}
-- 
1.8.5.6
