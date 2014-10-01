From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/24] scsi_error: document scsi_try_to_abort_cmd
Date: Wed,  1 Oct 2014 08:23:00 +0200
Message-ID: <1412144580-72880-25-git-send-email-hare@suse.de>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaJAGXJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 02:23:09 -0400
In-Reply-To: <1412144580-72880-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

scsi_try_to_abort_cmd() should only return
SUCCESS or FAILED. So document that in the
function description and simplify the
logging message.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Robert Elliott <elliott@hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a41ef5b..75dd203 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -157,8 +157,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
-					    "scmd %p abort failed, rtn %d\n",
-					    scmd, rtn));
+					    "scmd %p abort failed\n", scmd));
 		}
 	}
 
@@ -869,7 +868,22 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 	return rtn;
 }
 
-static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt, struct scsi_cmnd *scmd)
+/**
+ * scsi_try_to_abort_cmd - Ask host to abort a SCSI command
+ * @scmd:	SCSI cmd used to send a target reset
+ *
+ * Return value:
+ *	SUCCESS or FAILED
+ *
+ * Notes:
+ *    SUCCESS does not necessarily indicate that the command
+ *    has been aborted; it only indicates that the LLDDs
+ *    has cleared all references to that command.
+ *    LLDDs should return FAILED only if an abort was required
+ *    but could not be executed.
+ */
+static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt,
+				 struct scsi_cmnd *scmd)
 {
 	if (!hostt->eh_abort_handler)
 		return FAILED;
-- 
1.8.5.2

