From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 05/08] scsi: remove a timer race from scsi_queue_insert() and cleanup timer
Date: Wed, 23 Mar 2005 11:14:44 +0900 (KST)
Message-ID: <20050323021335.88C511CE@htj.dyndns.org>
References: <20050323021335.960F95F8@htj.dyndns.org>
Content-Type: text/plain; charset=US-ASCII
Received: from rproxy.gmail.com ([64.233.170.198]:3979 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262716AbVCWCOt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 21:14:49 -0500
Received: by rproxy.gmail.com with SMTP id j1so40546rnf
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2005 18:14:49 -0800 (PST)
In-Reply-To: <20050323021335.960F95F8@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, axboe@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

05_scsi_timer_cleanup.patch

	scsi_queue_insert() has four callers.  Three callers call with
	timer disabled and one (the second invocation in
	scsi_dispatch_cmd()) calls with timer activated.
	scsi_queue_insert() used to always call scsi_delete_timer()
	and ignore the return value.  This results in race with timer
	expiration.  Remove scsi_delete_timer() call from
	scsi_queue_insert() and make the caller delete timer and check
	the return value.

	While at it, as, once a scsi timer is added, it should expire
	or be deleted before reused, make scsi_add_timer() strict
	about timer reuses.  Now timer expiration function clears
	->function and all timer deletion should go through
	scsi_delete_timer().  Also, remove bogus ->eh_action tests
	from scsi_eh_{done|times_out} functions.  The condition is
	always true and the test is somewhat misleading.

Signed-off-by: Tejun Heo <htejun@gmail.com>

 aic7xxx/aic79xx_osm.c |    1 +
 aic7xxx/aic7xxx_osm.c |    1 +
 scsi.c                |    7 ++++---
 scsi_error.c          |   24 +++++++-----------------
 scsi_lib.c            |    6 ------
 5 files changed, 13 insertions(+), 26 deletions(-)

Index: scsi-export/drivers/scsi/aic7xxx/aic79xx_osm.c
===================================================================
--- scsi-export.orig/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-03-23 09:39:36.000000000 +0900
+++ scsi-export/drivers/scsi/aic7xxx/aic79xx_osm.c	2005-03-23 09:40:10.000000000 +0900
@@ -2725,6 +2725,7 @@ ahd_linux_dv_target(struct ahd_softc *ah
 		/* Queue the command and wait for it to complete */
 		/* Abuse eh_timeout in the scsi_cmnd struct for our purposes */
 		init_timer(&cmd->eh_timeout);
+		cmd->eh_timeout.function = NULL;
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_MESSAGES) != 0)
 			/*
Index: scsi-export/drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- scsi-export.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-03-23 09:39:36.000000000 +0900
+++ scsi-export/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-03-23 09:40:10.000000000 +0900
@@ -2409,6 +2409,7 @@ ahc_linux_dv_target(struct ahc_softc *ah
 		/* Queue the command and wait for it to complete */
 		/* Abuse eh_timeout in the scsi_cmnd struct for our purposes */
 		init_timer(&cmd->eh_timeout);
+		cmd->eh_timeout.function = NULL;
 #ifdef AHC_DEBUG
 		if ((ahc_debug & AHC_SHOW_MESSAGES) != 0)
 			/*
Index: scsi-export/drivers/scsi/scsi.c
===================================================================
--- scsi-export.orig/drivers/scsi/scsi.c	2005-03-23 09:40:09.000000000 +0900
+++ scsi-export/drivers/scsi/scsi.c	2005-03-23 09:40:10.000000000 +0900
@@ -639,9 +639,10 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	spin_unlock_irqrestore(host->host_lock, flags);
 	if (rtn) {
 		atomic_inc(&cmd->device->iodone_cnt);
-		scsi_queue_insert(cmd,
-				(rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
-				 rtn : SCSI_MLQUEUE_HOST_BUSY);
+		if (scsi_delete_timer(cmd))
+			scsi_queue_insert(cmd,
+					  (rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
+					  rtn : SCSI_MLQUEUE_HOST_BUSY);
 		SCSI_LOG_MLQUEUE(3,
 		    printk("queuecommand : request rejected\n"));
 	}
Index: scsi-export/drivers/scsi/scsi_error.c
===================================================================
--- scsi-export.orig/drivers/scsi/scsi_error.c	2005-03-23 09:40:10.000000000 +0900
+++ scsi-export/drivers/scsi/scsi_error.c	2005-03-23 09:40:10.000000000 +0900
@@ -107,14 +107,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 void scsi_add_timer(struct scsi_cmnd *scmd, int timeout,
 		    void (*complete)(struct scsi_cmnd *))
 {
-
-	/*
-	 * If the clock was already running for this command, then
-	 * first delete the timer.  The timer handling code gets rather
-	 * confused if we don't do this.
-	 */
-	if (scmd->eh_timeout.function)
-		del_timer(&scmd->eh_timeout);
+	BUG_ON(scmd->eh_timeout.function);
 
 	scmd->eh_timeout.data = (unsigned long)scmd;
 	scmd->eh_timeout.expires = jiffies + timeout;
@@ -170,6 +163,9 @@ void scsi_times_out(struct scsi_cmnd *sc
 {
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
+	scmd->eh_timeout.data = (unsigned long)NULL;
+	scmd->eh_timeout.function = NULL;
+
 	if (scmd->device->host->hostt->eh_timed_out)
 		switch (scmd->device->host->hostt->eh_timed_out(scmd)) {
 		case EH_HANDLED:
@@ -442,9 +438,7 @@ static void scsi_eh_times_out(struct scs
 	scsi_eh_eflags_set(scmd, SCSI_EH_REC_TIMEOUT);
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd:%p\n", __FUNCTION__,
 					  scmd));
-
-	if (scmd->device->host->eh_action)
-		up(scmd->device->host->eh_action);
+	up(scmd->device->host->eh_action);
 }
 
 /**
@@ -459,15 +453,12 @@ static void scsi_eh_done(struct scsi_cmn
 	 * way of stopping the timeout handler from running, so we must
 	 * always defer to it.
 	 */
-	if (del_timer(&scmd->eh_timeout)) {
+	if (scsi_delete_timer(scmd)) {
 		scmd->request->rq_status = RQ_SCSI_DONE;
 		scmd->owner = SCSI_OWNER_ERROR_HANDLER;
-
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s scmd: %p result: %x\n",
 					   __FUNCTION__, scmd, scmd->result));
-
-		if (scmd->device->host->eh_action)
-			up(scmd->device->host->eh_action);
+		up(scmd->device->host->eh_action);
 	}
 }
 
@@ -1881,7 +1872,6 @@ scsi_reset_provider(struct scsi_device *
 		rtn = FAILED;
 	}
 
-	scsi_delete_timer(scmd);
 	scsi_next_command(scmd);
 	return rtn;
 }
Index: scsi-export/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-export.orig/drivers/scsi/scsi_lib.c	2005-03-23 09:40:09.000000000 +0900
+++ scsi-export/drivers/scsi/scsi_lib.c	2005-03-23 09:40:10.000000000 +0900
@@ -229,12 +229,6 @@ int scsi_queue_insert(struct scsi_cmnd *
 		 printk("Inserting command %p into mlqueue\n", cmd));
 
 	/*
-	 * We are inserting the command into the ml queue.  First, we
-	 * cancel the timer, so it doesn't time out.
-	 */
-	scsi_delete_timer(cmd);
-
-	/*
 	 * Next, set the appropriate busy bit for the device/host.
 	 *
 	 * If the host/device isn't busy, assume that something actually

