From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v11 6/9] Make scsi_remove_host() wait until error handling
 finished
Date: Wed, 12 Jun 2013 14:55:29 +0200
Message-ID: <51B86FC1.6000103@acm.org>
References: <51B86E26.6030108@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:50437 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3FLMzb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jun 2013 08:55:31 -0400
In-Reply-To: <51B86E26.6030108@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>Tejun Heo <tj@kernel.org>

A SCSI LLD may start cleaning up host resources as soon as
scsi_remove_host() returns. These host resources may be needed by
the LLD in an implementation of one of the eh_* functions. So if
one of the eh_* functions is in progress when scsi_remove_host()
is invoked, wait until the eh_* function has finished. Also, do
not invoke any of the eh_* functions after scsi_remove_host() has
started. Remove Scsi_Host.tmf_in_progress because it is now
superfluous.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/hosts.c      |    6 ++++
 drivers/scsi/scsi_error.c |   86 ++++++++++++++++++++++++++++++++++++++-------
 include/scsi/scsi_host.h  |    6 ++--
 3 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 034a567..17e2ccb 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -176,6 +176,12 @@ void scsi_remove_host(struct Scsi_Host *shost)
 		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
 	spin_unlock_irq(shost->host_lock);
 
+	/*
+	 * Wait until the error handler has finished invoking LLD callbacks
+	 * before allowing the LLD to proceed.
+	 */
+	wait_event(shost->host_wait, shost->eh_active == 0);
+
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f43de1e..1f2f593 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -537,8 +537,53 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 }
 
 /**
+ * scsi_begin_eh - start host-related error handling
+ *
+ * Must be called before invoking an LLD callback function to avoid that
+ * scsi_remove_host() returns while one of these callback functions is in
+ * progress.
+ *
+ * Returns 0 if invoking an eh_* function is allowed and a negative value if
+ * not. If this function returns 0 then scsi_end_eh() must be called
+ * eventually.
+ */
+static int scsi_begin_eh(struct Scsi_Host *host)
+{
+	int res;
+
+	spin_lock_irq(host->host_lock);
+	switch (host->shost_state) {
+	case SHOST_DEL:
+	case SHOST_DEL_RECOVERY:
+		res = -ENODEV;
+		break;
+	default:
+		WARN_ON_ONCE(host->eh_active < 0);
+		host->eh_active++;
+		res = 0;
+		break;
+	}
+	spin_unlock_irq(host->host_lock);
+
+	return res;
+}
+
+/**
+ * scsi_end_eh - finish host-related error handling
+ */
+static void scsi_end_eh(struct Scsi_Host *host)
+{
+	spin_lock_irq(host->host_lock);
+	host->eh_active--;
+	WARN_ON_ONCE(host->eh_active < 0);
+	if (host->eh_active == 0)
+		wake_up(&host->host_wait);
+	spin_unlock_irq(host->host_lock);
+}
+
+/**
  * scsi_try_host_reset - ask host adapter to reset itself
- * @scmd:	SCSI cmd to send hsot reset.
+ * @scmd:	SCSI cmd to send host reset.
  */
 static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
@@ -553,6 +598,9 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_host_reset_handler)
 		return FAILED;
 
+	if (scsi_begin_eh(host))
+		return FAST_IO_FAIL;
+
 	rtn = hostt->eh_host_reset_handler(scmd);
 
 	if (rtn == SUCCESS) {
@@ -562,6 +610,7 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 		scsi_report_bus_reset(host, scmd_channel(scmd));
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
+	scsi_end_eh(host);
 
 	return rtn;
 }
@@ -583,6 +632,9 @@ static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_bus_reset_handler)
 		return FAILED;
 
+	if (scsi_begin_eh(host))
+		return FAST_IO_FAIL;
+
 	rtn = hostt->eh_bus_reset_handler(scmd);
 
 	if (rtn == SUCCESS) {
@@ -592,6 +644,7 @@ static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 		scsi_report_bus_reset(host, scmd_channel(scmd));
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
+	scsi_end_eh(host);
 
 	return rtn;
 }
@@ -622,6 +675,9 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_target_reset_handler)
 		return FAILED;
 
+	if (scsi_begin_eh(host))
+		return FAST_IO_FAIL;
+
 	rtn = hostt->eh_target_reset_handler(scmd);
 	if (rtn == SUCCESS) {
 		spin_lock_irqsave(host->host_lock, flags);
@@ -629,6 +685,7 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 					  __scsi_report_device_reset);
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
+	scsi_end_eh(host);
 
 	return rtn;
 }
@@ -646,14 +703,20 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
 	int rtn;
-	struct scsi_host_template *hostt = scmd->device->host->hostt;
+	struct Scsi_Host *host = scmd->device->host;
+	struct scsi_host_template *hostt = host->hostt;
 
 	if (!hostt->eh_device_reset_handler)
 		return FAILED;
 
+	if (scsi_begin_eh(host))
+		return FAST_IO_FAIL;
+
 	rtn = hostt->eh_device_reset_handler(scmd);
 	if (rtn == SUCCESS)
 		__scsi_report_device_reset(scmd->device, NULL);
+	scsi_end_eh(host);
+
 	return rtn;
 }
 
@@ -797,6 +860,9 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	const unsigned long stall_for = msecs_to_jiffies(100);
 	int rtn;
 
+	if (scsi_begin_eh(shost))
+		return FAILED;
+
 retry:
 	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
 	shost->eh_action = &done;
@@ -867,6 +933,8 @@ retry:
 			rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
 	}
 
+	scsi_end_eh(shost);
+
 	return rtn;
 }
 
@@ -1894,6 +1962,9 @@ int scsi_error_handler(void *data)
 	}
 	__set_current_state(TASK_RUNNING);
 
+	WARN_ONCE(shost->eh_active, "scsi_eh_%d: eh_active = %d\n",
+		  shost->host_no, shost->eh_active);
+
 	SCSI_LOG_ERROR_RECOVERY(1,
 		printk("Error handler scsi_eh_%d exiting\n", shost->host_no));
 	shost->ehandler = NULL;
@@ -1990,7 +2061,6 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 	struct scsi_cmnd *scmd;
 	struct Scsi_Host *shost = dev->host;
 	struct request req;
-	unsigned long flags;
 	int rtn;
 
 	if (scsi_autopm_get_host(shost) < 0)
@@ -2009,10 +2079,6 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 
 	scmd->sc_data_direction		= DMA_BIDIRECTIONAL;
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->tmf_in_progress = 1;
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
 	switch (flag) {
 	case SCSI_TRY_RESET_DEVICE:
 		rtn = scsi_try_bus_device_reset(scmd);
@@ -2036,10 +2102,6 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 		rtn = FAILED;
 	}
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->tmf_in_progress = 0;
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
 	/*
 	 * be sure to wake up anyone who was sleeping or had their queue
 	 * suspended while we performed the TMF.
@@ -2048,8 +2110,6 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 		printk("%s: waking up host to restart after TMF\n",
 		__func__));
 
-	wake_up(&shost->host_wait);
-
 	scsi_run_host_queues(shost);
 
 	scsi_next_command(scmd);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7552435..9785e51 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -578,6 +578,7 @@ struct Scsi_Host {
 	struct task_struct    * ehandler;  /* Error recovery thread. */
 	struct completion     * eh_action; /* Wait for specific actions on the
 					      host. */
+	int			eh_active;
 	wait_queue_head_t       host_wait;
 	struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
@@ -665,9 +666,6 @@ struct Scsi_Host {
 	 */
 	unsigned ordered_tag:1;
 
-	/* Task mgmt function in progress */
-	unsigned tmf_in_progress:1;
-
 	/* Asynchronous scan in progress */
 	unsigned async_scan:1;
 
@@ -771,7 +769,7 @@ static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
 	return shost->shost_state == SHOST_RECOVERY ||
 		shost->shost_state == SHOST_CANCEL_RECOVERY ||
 		shost->shost_state == SHOST_DEL_RECOVERY ||
-		shost->tmf_in_progress;
+		shost->eh_active;
 }
 
 extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
-- 
1.7.10.4

