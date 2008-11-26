From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 1/7] print eh activation
Date: Wed, 26 Nov 2008 18:44:01 +0100
Message-ID: <200811261844.02732.bs@q-leap.de>
References: <200811261840.45360.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:35911 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbYKZRoI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 12:44:08 -0500
In-Reply-To: <200811261840.45360.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>

Print activation of the scsi error handler to let the user know what was 
the the error handler was activated. These information are essential to
diagnose hardware issues.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

---
 drivers/scsi/scsi_error.c |   17 ++++++++++++-----
 drivers/scsi/scsi_lib.c   |    2 +-
 drivers/scsi/scsi_priv.h  |    2 +-
 3 files changed, 14 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c
+++ linux-2.6/drivers/scsi/scsi_error.c
@@ -48,12 +48,18 @@
 #define HOST_RESET_SETTLE_TIME  (10)
 
 /* called with shost->host_lock held */
-void scsi_eh_wakeup(struct Scsi_Host *shost)
+void scsi_eh_wakeup(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 {
 	if (shost->host_busy == shost->host_failed) {
-		wake_up_process(shost->ehandler);
-		SCSI_LOG_ERROR_RECOVERY(5,
+		if (scmd) {
+			scsi_print_result(scmd);
+			scsi_print_command(scmd);
+			sdev_printk(KERN_WARNING, scmd->device,
+				    "Activating error handler\n");
+		} else
+			SCSI_LOG_ERROR_RECOVERY(5,
 				printk("Waking error handler thread\n"));
+		wake_up_process(shost->ehandler);
 	}
 }
 
@@ -72,7 +78,7 @@ void scsi_schedule_eh(struct Scsi_Host *
 	if (scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
 	    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0) {
 		shost->host_eh_scheduled++;
-		scsi_eh_wakeup(shost);
+		scsi_eh_wakeup(shost, NULL);
 	}
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -105,7 +111,8 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 	scmd->eh_eflags |= eh_flag;
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
 	shost->host_failed++;
-	scsi_eh_wakeup(shost);
+
+	scsi_eh_wakeup(shost, scmd);
  out_unlock:
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return ret;
Index: linux-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_priv.h
+++ linux-2.6/drivers/scsi/scsi_priv.h
@@ -52,7 +52,7 @@ extern void scsi_exit_devinfo(void);
 extern enum blk_eh_timer_return scsi_times_out(struct request *req);
 extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
-extern void scsi_eh_wakeup(struct Scsi_Host *shost);
+extern void scsi_eh_wakeup(struct Scsi_Host *shost, struct scsi_cmnd *scmd);
 extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6/drivers/scsi/scsi_lib.c
@@ -476,7 +476,7 @@ void scsi_device_unbusy(struct scsi_devi
 	starget->target_busy--;
 	if (unlikely(scsi_host_in_recovery(shost) &&
 		     (shost->host_failed || shost->host_eh_scheduled)))
-		scsi_eh_wakeup(shost);
+		scsi_eh_wakeup(shost, NULL);
 	spin_unlock(shost->host_lock);
 	spin_lock(sdev->request_queue->queue_lock);
 	sdev->device_busy--;

-- 
Bernd Schubert
Q-Leap Networks GmbH
