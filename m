From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (2/4)
Date: Tue, 11 Feb 2003 00:15:36 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030211081536.GB1368@beaverton.ibm.com>
References: <20030211081351.GA1368@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e35.co.us.ibm.com (8.12.7/8.12.2) with ESMTP id h1B8DoKo105776
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2003 03:13:50 -0500
Received: from hmsbounty (sig-9-65-26-42.mts.ibm.com [9.65.26.42])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.5) with ESMTP id h1B8Dnih055794
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2003 01:13:49 -0700
Content-Disposition: inline
In-Reply-To: <20030211081351.GA1368@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch series is against scsi-misc-2.5.
 
01_serror-scmd-add-1.diff:
 	- Add scsi_eh_scmd_add function.
 
-andmike
--
Michael Anderson
andmike@us.ibm.com

 scsi.c       |    8 ++------
 scsi_error.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 49 insertions(+), 18 deletions(-)
------

diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Mon Feb 10 22:25:47 2003
+++ b/drivers/scsi/scsi.c	Mon Feb 10 22:25:47 2003
@@ -1017,13 +1017,9 @@
 				if ((status_byte(SCpnt->result) & CHECK_CONDITION) != 0) {
 					SCSI_LOG_MLCOMPLETE(3, print_sense("bh", SCpnt));
 				}
-				if (SCpnt->device->host->eh_wait != NULL) {
-					scsi_eh_eflags_set(SCpnt, SCSI_EH_CMD_FAILED | SCSI_EH_CMD_ERR);
-					SCpnt->owner = SCSI_OWNER_ERROR_HANDLER;
-					SCpnt->state = SCSI_STATE_FAILED;
 
-					scsi_host_failed_inc_and_test(SCpnt->device->host);
-				} else {
+				if (!scsi_eh_scmd_add(SCpnt, 0))
+				{
 					/*
 					 * We only get here if the error
 					 * recovery thread has died.
diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Mon Feb 10 22:25:47 2003
+++ b/drivers/scsi/scsi_error.c	Mon Feb 10 22:25:47 2003
@@ -56,6 +56,49 @@
 #define HOST_RESET_SETTLE_TIME  10*HZ
 
 /**
+ * scsi_eh_scmd_add - add scsi cmd to error handling.
+ * @scmd:	scmd to run eh on.
+ * @eh_flag:	optional SCSI_EH flag.
+ *
+ * Return value:
+ *	0 on failure.
+ **/
+int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
+{
+	struct Scsi_Host *shost = scmd->device->host;
+	unsigned long flags;
+
+	if (shost->eh_wait == NULL)
+		return 0;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	scsi_eh_eflags_set(scmd, eh_flag);
+	/*
+	 * FIXME: Can we stop setting owner and state.
+	 */
+	scmd->owner = SCSI_OWNER_ERROR_HANDLER;
+	scmd->state = SCSI_STATE_FAILED;
+	/*
+	 * Set the serial_number_at_timeout to the current
+	 * serial_number
+	 */
+	scmd->serial_number_at_timeout = scmd->serial_number;
+	list_add_tail(&scmd->eh_list, &shost->eh_cmd_list);
+	shost->in_recovery = 1;
+	shost->host_failed++;
+	if (shost->host_busy == shost->host_failed) {
+		up(shost->eh_wait);
+		SCSI_LOG_ERROR_RECOVERY(5, printk("Waking error handler"
+					  " thread\n"));
+	}
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	return 1;
+}
+
+/**
  * scsi_add_timer - Start timeout timer for a single scsi command.
  * @scmd:	scsi command that is about to start running.
  * @timeout:	amount of time to allow this command to run.
@@ -131,22 +174,14 @@
  **/
 void scsi_times_out(Scsi_Cmnd *scmd)
 {
-	struct Scsi_Host *shost = scmd->device->host;
-
-	/* Set the serial_number_at_timeout to the current serial_number */
-	scmd->serial_number_at_timeout = scmd->serial_number;
-
-	scsi_eh_eflags_set(scmd, SCSI_EH_CMD_TIMEOUT | SCSI_EH_CMD_ERR);
-
-	if (unlikely(shost->eh_wait == NULL)) {
+	if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
 		panic("Error handler thread not present at %p %p %s %d",
-		      scmd, shost, __FILE__, __LINE__);
+		      scmd, scmd->device->host, __FILE__, __LINE__);
 	}
 
-	scsi_host_failed_inc_and_test(shost);
-
 	SCSI_LOG_TIMEOUT(3, printk("Command timed out busy=%d failed=%d\n",
-				   shost->host_busy, shost->host_failed));
+				   scmd->device->host->host_busy,
+				   scmd->device->host->host_failed));
 }
 
 /**
