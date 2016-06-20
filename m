From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/5] scsi: Do not escalate failed EH command
Date: Mon, 20 Jun 2016 11:35:40 +0200
Message-ID: <1466415340-104465-6-git-send-email-hare@suse.de>
References: <1466415340-104465-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbcFTJfv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 05:35:51 -0400
In-Reply-To: <1466415340-104465-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

If an EH command fails there is no need to escalate; we are already
in EH and the escalation will start anyway.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cf47b81..7df6818 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -870,15 +870,6 @@ static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt,
 	return hostt->eh_abort_handler(scmd);
 }
 
-static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
-{
-	if (scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd) != SUCCESS)
-		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
-			if (scsi_try_target_reset(scmd) != SUCCESS)
-				if (scsi_try_bus_reset(scmd) != SUCCESS)
-					scsi_try_host_reset(scmd);
-}
-
 /**
  * scsi_eh_prep_cmnd  - Save a scsi command info as part of error recovery
  * @scmd:       SCSI command structure to hijack
@@ -1062,10 +1053,8 @@ retry:
 			rtn = FAILED;
 			break;
 		}
-	} else if (rtn != FAILED) {
-		scsi_abort_eh_cmnd(scmd);
+	} else if (rtn != FAILED)
 		rtn = FAILED;
-	}
 
 	scsi_eh_restore_cmnd(scmd, &ses);
 
-- 
1.8.5.6

