From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Tue, 11 Feb 2003 00:13:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030211081351.GA1368@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e33.co.us.ibm.com (8.12.7/8.12.2) with ESMTP id h1B8C5ca131488
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2003 03:12:05 -0500
Received: from hmsbounty (sig-9-65-26-42.mts.ibm.com [9.65.26.42])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.5) with ESMTP id h1B8C4ih147624
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2003 01:12:04 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch series is against scsi-misc-2.5.

These patches modify the scsi error handler to process cmds needing
recovery off a list. The error handler policy has been altered to do the
following:
	1.) Check for legacy behavior of requesting sense.
	2.) Abort commands marked needing to be canceled.
	3.) Ready devices through tur and eh handlers.
	4.) disposition each command on the list to be retried or
	finished.

00_serror-cmd-list-1.diff:
	- Add per host eh_cmd_list list head.
	- Add per cmd eh_list list head.

01_serror-scmd-add-1.diff:
	- Add scsi_eh_scmd_add function.

02_serror-hndlr-1.diff:
	- Change to using eh_cmd_list.
	- Change scsi_unjam_host to get sense, abort cmds, ready
	  devices, and disposition cmds for retry or finish.
	- Moved retries outside of eh.

03_serror-dev-offline-1.diff:
	- Add scsi_set_device_offline interface.

I have tested both the timeout and offline cases with the scsi_debug. I
have ran some other testing, but my machine stability is causing it to
oops in other areas.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 hosts.c |   16 +---------------
 hosts.h |    2 +-
 scsi.h  |    9 +++++----
 3 files changed, 7 insertions(+), 20 deletions(-)
------

diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Mon Feb 10 22:25:47 2003
+++ b/drivers/scsi/hosts.c	Mon Feb 10 22:25:47 2003
@@ -397,6 +397,7 @@
 	spin_lock_init(&shost->default_lock);
 	scsi_assign_lock(shost, &shost->default_lock);
 	INIT_LIST_HEAD(&shost->my_devices);
+	INIT_LIST_HEAD(&shost->eh_cmd_list);
 
 	init_waitqueue_head(&shost->host_wait);
 	shost->dma_channel = 0xff;
@@ -635,21 +636,6 @@
 	shost->host_busy--;
 	sdev->device_busy--;
 	if (shost->in_recovery && (shost->host_busy == shost->host_failed)) {
-		up(shost->eh_wait);
-		SCSI_LOG_ERROR_RECOVERY(5, printk("Waking error handler"
-					  " thread\n"));
-	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-}
-
-void scsi_host_failed_inc_and_test(struct Scsi_Host *shost)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->in_recovery = 1;
-	shost->host_failed++;
-	if (shost->host_busy == shost->host_failed) {
 		up(shost->eh_wait);
 		SCSI_LOG_ERROR_RECOVERY(5, printk("Waking error handler"
 					  " thread\n"));
diff -Nru a/drivers/scsi/hosts.h b/drivers/scsi/hosts.h
--- a/drivers/scsi/hosts.h	Mon Feb 10 22:25:47 2003
+++ b/drivers/scsi/hosts.h	Mon Feb 10 22:25:47 2003
@@ -385,6 +385,7 @@
     spinlock_t		  default_lock;
     spinlock_t		  *host_lock;
 
+    struct list_head	eh_cmd_list;
     struct task_struct    * ehandler;  /* Error recovery thread. */
     struct semaphore      * eh_wait;   /* The error recovery thread waits on
                                           this. */
@@ -595,7 +596,6 @@
  */
 extern void scsi_host_busy_inc(struct Scsi_Host *, Scsi_Device *);
 extern void scsi_host_busy_dec_and_test(struct Scsi_Host *, Scsi_Device *);
-extern void scsi_host_failed_inc_and_test(struct Scsi_Host *);
 
 /**
  * scsi_find_device - find a device given the host

diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Mon Feb 10 22:25:47 2003
+++ b/drivers/scsi/scsi.h	Mon Feb 10 22:25:47 2003
@@ -727,6 +728,7 @@
 
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 
+	struct list_head eh_list; /* Used to place us on the host eh list */
 	int eh_state;		/* Used for state tracking in error handlr */
 	int eh_eflags;		/* Used by error handlr */
 	void (*done) (struct scsi_cmnd *);	/* Mid-level done function */
@@ -961,12 +963,12 @@
 /*
  * Scsi Error Handler Flags
  */
-#define SCSI_EH_CMD_ERR	0x0001	/* Orig cmd error'd */
-#define SCSI_EH_CMD_FAILED	0x0002	/* Orig cmd error type failed */
-#define SCSI_EH_CMD_TIMEOUT	0x0004	/* Orig cmd error type timeout */
-#define SCSI_EH_REC_TIMEOUT	0x0008	/* Recovery cmd timeout */
+#define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
+#define SCSI_EH_REC_TIMEOUT	0x0002	/* EH retry timed out */
 
 #define SCSI_SENSE_VALID(scmd) ((scmd->sense_buffer[0] & 0x70) == 0x70)
+
+extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
 
 int scsi_set_medium_removal(Scsi_Device *dev, char state);

