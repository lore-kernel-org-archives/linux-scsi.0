From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/14] scsi: add 'abort_completions' host template flag
Date: Thu,  2 Jun 2016 16:39:06 +0200
Message-ID: <1464878356-42407-5-git-send-email-hare@suse.de>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932992AbcFBOjW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:22 -0400
In-Reply-To: <1464878356-42407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Some HBAs will always send a command completion on the original
command after a ABORT TASK TMF has been send.
For those it's pointless to wait for the TMF itself to finish,
but we can as well reset the timer for the failed command and
wait for the command completion to finish up the command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c | 7 +++++--
 include/scsi/scsi_host.h  | 6 ++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a8b610e..e4a1592 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -285,8 +285,11 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 		rtn = host->hostt->eh_timed_out(scmd);
 
 	if (rtn == BLK_EH_NOT_HANDLED) {
-		if (!host->hostt->no_async_abort &&
-		    scsi_abort_command(scmd) == SUCCESS)
+		if (host->hostt->abort_completions &&
+		    scsi_try_to_abort_cmd(host->hostt, scmd) == SUCCESS)
+			return BLK_EH_RESET_TIMER;
+		else if (!host->hostt->no_async_abort &&
+			 scsi_abort_command(scmd) == SUCCESS)
 			return BLK_EH_NOT_HANDLED;
 
 		set_host_byte(scmd, DID_TIME_OUT);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 76e9d27..2af2397 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -449,6 +449,12 @@ struct scsi_host_template {
 	unsigned no_async_abort:1;
 
 	/*
+	 * True if aborts will trigger a command completion
+	 * of the failed command
+	 */
+	unsigned abort_completions:1;
+
+	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
 	unsigned int max_host_blocked;
-- 
1.8.5.6

