From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH] Eliminate error handler overload of the SCSI serial number
Date: Wed, 17 Nov 2010 10:10:57 -0600
Message-ID: <1290010257.4736.50.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43133 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934741Ab0KQQLB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 11:11:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Mike Anderson <andmike@linux.vnet.ibm.com>

The error handler is using the test cmd->serial_number == 0 in the
abort routines to signal that the command to be aborted has already
completed normally.  This design was to close a race window in the
original error handler where a command could go through the normal
completion routines after it timed out but before error handling was
started.

Mike Anderson pointed out that when we converted our timeout and
softirq completions, we picked up atomicity here because the block
layer now mediates this with the REQ_ATOM_COMPLETE flag and guarantees
that *either* the command times out or our done routine is called, but
ensures we can't get both occurring.  That makes the serial number
zero check redundant and it can be removed.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/scsi_error.c |   26 ++------------------------
 drivers/scsi/scsi_lib.c   |    5 -----
 2 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 824b8fc..30ac116 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -615,7 +615,7 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 	return rtn;
 }
 
-static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
+static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
 	if (!scmd->device->host->hostt->eh_abort_handler)
 		return FAILED;
@@ -623,31 +623,9 @@ static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 	return scmd->device->host->hostt->eh_abort_handler(scmd);
 }
 
-/**
- * scsi_try_to_abort_cmd - Ask host to abort a running command.
- * @scmd:	SCSI cmd to abort from Lower Level.
- *
- * Notes:
- *    This function will not return until the user's completion function
- *    has been called.  there is no timeout on this operation.  if the
- *    author of the low-level driver wishes this operation to be timed,
- *    they can provide this facility themselves.  helper functions in
- *    scsi_error.c can be supplied to make this easier to do.
- */
-static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
-{
-	/*
-	 * scsi_done was called just after the command timed out and before
-	 * we had a chance to process it. (db)
-	 */
-	if (scmd->serial_number == 0)
-		return SUCCESS;
-	return __scsi_try_to_abort_cmd(scmd);
-}
-
 static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 {
-	if (__scsi_try_to_abort_cmd(scmd) != SUCCESS)
+	if (scsi_try_to_abort_cmd(scmd) != SUCCESS)
 		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
 			if (scsi_try_target_reset(scmd) != SUCCESS)
 				if (scsi_try_bus_reset(scmd) != SUCCESS)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index eafeeda..5b6bbae 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1403,11 +1403,6 @@ static void scsi_softirq_done(struct request *rq)
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
-	/*
-	 * Set the serial numbers back to zero
-	 */
-	cmd->serial_number = 0;
-
 	atomic_inc(&cmd->device->iodone_cnt);
 	if (cmd->result)
 		atomic_inc(&cmd->device->ioerr_cnt);
-- 
1.7.2.3



