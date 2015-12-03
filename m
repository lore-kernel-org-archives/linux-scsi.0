From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/5] scsi_error: do not escalate failed EH command
Date: Thu,  3 Dec 2015 08:17:43 +0100
Message-ID: <1449127063-94512-6-git-send-email-hare@suse.de>
References: <1449127063-94512-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbbLCHRr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 02:17:47 -0500
In-Reply-To: <1449127063-94512-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When a command is sent as part of the error handling there
is not point whatsoever to start EH escalation when that
command fails; we are _already_ in the error handler,
and the escalation is about to commence anyway.
So just call 'scsi_try_to_abort_cmd()' to abort outstanding
commands and let the main EH routine handle the rest.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cf47b81..0159498 100644
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
@@ -1063,7 +1054,7 @@ retry:
 			break;
 		}
 	} else if (rtn != FAILED) {
-		scsi_abort_eh_cmnd(scmd);
+		scsi_try_to_abort_cmd(shost->hostt, scmd);
 		rtn = FAILED;
 	}
 
-- 
1.8.5.6

