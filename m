From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Set correct completion code in scsi_send_eh_cmnd()
Date: Thu,  8 May 2014 08:09:56 +0200
Message-ID: <1399529396-52685-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbaEHGJ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2014 02:09:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Stephen Cameron <scameron@beardog.cce.hp.com>

->queuecommand returns '0' for successful command submission,
so we need to set the correct SCSI midlayer return value
when calling scsi_log_completion().

Reported-by: Robert Elliott <elliott@hp.com>
Cc: Stephen Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f17aa7a..f4e0cad 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1029,6 +1029,7 @@ retry:
 		rtn = NEEDS_RETRY;
 	} else {
 		timeleft = wait_for_completion_timeout(&done, timeout);
+		rtn = SUCCESS;
 	}
 
 	shost->eh_action = NULL;
-- 
1.7.12.4

