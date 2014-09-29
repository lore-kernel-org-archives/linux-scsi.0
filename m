From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 38/38] scsi_error: document scsi_try_to_abort_cmd
Date: Mon, 29 Sep 2014 13:59:07 +0200
Message-ID: <1411991947-130166-39-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbaI2L7S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:18 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
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
index 0d977d3..c165550 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -153,8 +153,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 			}
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3,
-				scmd_printk(KERN_INFO, scmd,
-					    "abort failed, rtn %d\n", rtn));
+				scmd_printk(KERN_INFO, scmd, "abort failed\n"));
 		}
 	}
 
@@ -862,7 +861,22 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
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

