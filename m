From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Fix SATA ATAPI error handling
Date: Wed, 23 Mar 2005 16:28:16 +0100
Message-ID: <42418B10.6090009@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080109040205030400040809"
Sender: linux-ide-owner@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@suse.de>, Kurt Garloff <garloff@suse.de>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080109040205030400040809
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi all,

the attached patch tries to fix SATA ATAPI error handling.
The original code invokes scsi_finish_command() regardless whether this
command is processed normally or by scsi_eh.
This looks quite dangerous to me as this might trigger a recovery for a
command which already is in recovery (as it's processed by scsi_eh).
Plus the error handling _never_ clears eh_cmd_q, leaving failed command
forever on that queue.

The attached patch models the error handling closely to the existing
error handling in scsi_unjam_host(), with the execption that we rely on
a proper sense code being returned by the strategy handler.

Comments are welcome.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------080109040205030400040809
Content-Type: text/plain;
 name="atapi-fix-error-handling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="atapi-fix-error-handling.patch"

From: Hannes Reinecke <hare@suse.de>
Subject: Fix sata atapi error handling
References: 70918

SCSI commands which end up on the error handler need special attention;
we have to make sure that eh_cmd_q is properly emptied or scsi_eh will
try to forever finalize the command.

With this patch eh_cmd_q is explicitely emptied if not done so in the
strategy handler and a proper abort sequence is executed for each
command if required.
We rely on the strategy handler to fill out proper sense information for
us as SATA is 'special' when it comes to command sense gathering.

Signed-off-by: Kurt Garloff <garloff@suse.de>
Signed-off-by: Jens Axboe <axboe@suse.de>
Acked-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6.11/drivers/scsi/libata-core.c
===================================================================
--- linux-2.6.11.orig/drivers/scsi/libata-core.c
+++ linux-2.6.11/drivers/scsi/libata-core.c
@@ -41,6 +41,7 @@
 #include <scsi/scsi.h>
 #include "scsi.h"
 #include "scsi_priv.h"
+#include "scsi_logging.h"
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 #include <asm/io.h>
@@ -2587,6 +2588,11 @@ static void atapi_request_sense(struct a
 	DPRINTK("EXIT\n");
 }
 
+void ata_qc_timeout_done(struct scsi_cmnd *scmd)
+{
+	return;
+}
+
 /**
  *	ata_qc_timeout - Handle timeout of queued command
  *	@qc: Command that timed out
@@ -2618,17 +2624,16 @@ static void ata_qc_timeout(struct ata_qu
 		struct scsi_cmnd *cmd = qc->scsicmd;
 
 		if (!scsi_eh_eflags_chk(cmd, SCSI_EH_CANCEL_CMD)) {
-
 			/* finish completing original command */
+			qc->scsidone = ata_qc_timeout_done;
+
 			__ata_qc_complete(qc);
 
 			atapi_request_sense(ap, dev, cmd);
 
 			cmd->result = (CHECK_CONDITION << 1) | (DID_OK << 16);
-			scsi_finish_command(cmd);
-
-			goto out;
 		}
+		goto out;
 	}
 
 	/* hack alert!  We cannot use the supplied completion
Index: linux-2.6.11/drivers/scsi/libata-scsi.c
===================================================================
--- linux-2.6.11.orig/drivers/scsi/libata-scsi.c
+++ linux-2.6.11/drivers/scsi/libata-scsi.c
@@ -633,12 +633,6 @@ int ata_scsi_error(struct Scsi_Host *hos
 	ap = (struct ata_port *) &host->hostdata[0];
 	ap->ops->eng_timeout(ap);
 
-	/* TODO: this is per-command; when queueing is supported
-	 * this code will either change or move to a more
-	 * appropriate place
-	 */
-	host->host_failed--;
-
 	DPRINTK("EXIT\n");
 	return 0;
 }
Index: linux-2.6.11/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.11.orig/drivers/scsi/scsi_error.c
+++ linux-2.6.11/drivers/scsi/scsi_error.c
@@ -1610,6 +1610,40 @@ static void scsi_unjam_host(struct Scsi_
 	scsi_eh_flush_done_q(&eh_done_q);
 }
 
+static void scsi_invoke_strategy_handler(struct Scsi_Host *shost)
+{
+	int rtn;
+	struct list_head *lh, *lh_sf;
+	struct scsi_cmnd *scmd;
+	unsigned long flags;
+	LIST_HEAD(eh_work_q);
+	LIST_HEAD(eh_done_q);
+
+	rtn = shost->hostt->eh_strategy_handler(shost);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	SCSI_LOG_ERROR_RECOVERY(1, scsi_eh_prt_fail_stats(shost, &eh_work_q));
+
+	list_for_each_safe(lh, lh_sf, &eh_work_q) {
+		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
+
+		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD) ||
+		    !SCSI_SENSE_VALID(scmd))
+			continue;
+		scmd->retries = scmd->allowed;
+		scsi_eh_finish_cmd(scmd, &eh_done_q);
+	}
+
+	if (!list_empty(&eh_work_q))
+		if (!scsi_eh_abort_cmds(&eh_work_q, &eh_done_q))
+			scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
+
+	scsi_eh_flush_done_q(&eh_done_q);
+}
+
 /**
  * scsi_error_handler - Handle errors/timeouts of SCSI cmds.
  * @data:	Host for which we are running.
@@ -1624,7 +1658,6 @@ static void scsi_unjam_host(struct Scsi_
 int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = (struct Scsi_Host *) data;
-	int rtn;
 	DECLARE_MUTEX_LOCKED(sem);
 
 	/*
@@ -1680,8 +1713,8 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (shost->hostt->eh_strategy_handler) 
-			rtn = shost->hostt->eh_strategy_handler(shost);
+		if (shost->hostt->eh_strategy_handler)
+			scsi_invoke_strategy_handler(shost);
 		else
 			scsi_unjam_host(shost);
 

--------------080109040205030400040809--
