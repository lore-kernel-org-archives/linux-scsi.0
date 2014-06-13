From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] scsi: Do not complete timed-out command
Date: Fri, 13 Jun 2014 14:01:46 +0200
Message-ID: <1402660906-74661-3-git-send-email-hare@suse.de>
References: <1402660906-74661-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbaFMMB5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2014 08:01:57 -0400
In-Reply-To: <1402660906-74661-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bart vn Assche <bvanassche@acm.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

There is a possible race between scsi_times_out() and scsi_done();
the LLDD is only notified about a timed out command by calling
scsi_try_to_abort_command(). Anytime before that the LLDD is
free to complete the command via scsi_done().
By this time, however, the command might've been timed-out already,
leaving us with a stale command in the error handler.
Fix this by separating out the two meanings of the
SCSI_EH_ABORT_SCHEDULED flag; it's used to signal that
a) the asynchronous abort has been schedule
and
b) that an asynchronous abourt had been running, the command
   has been retried, and has timed out again.

This patch implements a new flag SCSI_EH_CMD_TIMEOUT to signal
that a command has run into a timeout (and thus can be used
to detect case b) above). The existing flag
SCSI_EH_CMD_ABORT_SCHEDULED is now restricted to signal
'the asynchronous abort has been scheduled', and thus should be
checked in scsi_done() to avoid the mentioned race.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c       | 2 ++
 drivers/scsi/scsi_error.c | 6 ++++--
 drivers/scsi/scsi_priv.h  | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88d46fe..7a58fbe 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -739,6 +739,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
  */
 static void scsi_done(struct scsi_cmnd *cmd)
 {
+	if (WARN_ON_ONCE(cmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED))
+		return;
 	trace_scsi_dispatch_cmd_done(cmd);
 	blk_complete_request(cmd->request);
 }
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ff176a6..cde9c11 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -125,11 +125,13 @@ scmd_eh_abort_handler(struct work_struct *work)
 			scmd_printk(KERN_INFO, scmd,
 				    "scmd %p eh timeout, not aborting\n",
 				    scmd));
+		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
 	} else {
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "aborting command %p\n", scmd));
 		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
+		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
 		if (rtn == SUCCESS) {
 			scmd->result |= DID_TIME_OUT << 16;
 			if (scsi_host_eh_past_deadline(sdev->host)) {
@@ -185,17 +187,17 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags;
 
-	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
+	if (scmd->eh_eflags & SCSI_EH_CMD_TIMEOUT) {
 		/*
 		 * Retry after abort failed, escalate to next level.
 		 */
-		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "scmd %p previous abort failed\n", scmd));
 		cancel_delayed_work(&scmd->abort_work);
 		return FAILED;
 	}
+	scmd->eh_eflags |= SCSI_EH_CMD_TIMEOUT;
 
 	/*
 	 * Do not try a command abort if
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 48e5b65..66b387d 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -20,6 +20,7 @@ struct scsi_nl_hdr;
  */
 #define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
 #define SCSI_EH_ABORT_SCHEDULED	0x0002	/* Abort has been scheduled */
+#define SCSI_EH_CMD_TIMEOUT	0x0004	/* Command has timed out */
 
 #define SCSI_SENSE_VALID(scmd) \
 	(((scmd)->sense_buffer[0] & 0x70) == 0x70)
-- 
1.7.12.4

