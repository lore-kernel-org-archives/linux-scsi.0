From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Wed, 07 Sep 2005 17:05:32 -0500
Message-ID: <1126130732.4823.57.camel@mulgrave>
References: <Pine.LNX.4.44L0.0509071413070.4988-100000@iolanthe.rowland.org>
	 <1126123089.4823.48.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:6545 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750848AbVIGWFg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 18:05:36 -0400
In-Reply-To: <1126123089.4823.48.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2005-09-07 at 14:58 -0500, James Bottomley wrote:
> On Wed, 2005-09-07 at 14:27 -0400, Alan Stern wrote:
> > I'm going to argue strongly about this.  scsi_remove_host should _not_
> > wait for error recovery to complete -- to do so will invite deadlocks.  
> > (Suppose the error handler is waiting for a bus reset, but the bus reset
> > routine requires a semaphore held by the LLD during the call to
> > scsi_remove_host?)  Furthermore, error recovery can potentially take quite
> > a long time -- much longer than we want to wait during a removal event.  
> > Instead, the error handler should not be allowed to make the transition to
> > RUNNING once the removal has started.
> 
> I agree (about the deadlocks).  However, as things stand RECOVERY is a
> state in the model and the model can only be in a single state.  If you
> permit the transition, and recovery is going on in parallel with
> removal, they'll race to set the final state (removal wants DEL and the
> eh thread will set it to RUNNING).
> 
> Either we go back to having an in_recovery flag (i.e. lift recovery out
> of the state model) or we make the model more complex to cope with this.
> Since really the only thing we test is in_recovery, we could do a more
> complex model; something like:

OK, try this as an implementation of that model (except I junked the DEL
-> DEL_RECOVERY path).

There's a few nasties in this (notably that timed out commands will be
finished without error recovery from the DEL state).

James

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -98,6 +98,7 @@ int scsi_host_set_state(struct Scsi_Host
 		switch (oldstate) {
 		case SHOST_CREATED:
 		case SHOST_RUNNING:
+		case SHOST_CANCEL_RECOVERY:
 			break;
 		default:
 			goto illegal;
@@ -107,12 +108,31 @@ int scsi_host_set_state(struct Scsi_Host
 	case SHOST_DEL:
 		switch (oldstate) {
 		case SHOST_CANCEL:
+		case SHOST_DEL_RECOVERY:
 			break;
 		default:
 			goto illegal;
 		}
 		break;
 
+	case SHOST_CANCEL_RECOVERY:
+		switch (oldstate) {
+		case SHOST_CANCEL:
+		case SHOST_RECOVERY:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
+	case SHOST_DEL_RECOVERY:
+		switch (oldstate) {
+		case SHOST_CANCEL_RECOVERY:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
 	}
 	shost->shost_state = state;
 	return 0;
@@ -135,12 +155,17 @@ EXPORT_SYMBOL(scsi_host_set_state);
 void scsi_remove_host(struct Scsi_Host *shost)
 {
 	down(&shost->scan_mutex);
-	scsi_host_set_state(shost, SHOST_CANCEL);
+	if (!scsi_host_set_state(shost, SHOST_CANCEL))
+		if (!scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY)) {
+			up(&shost->scan_mutex);
+			return;
+		}
 	up(&shost->scan_mutex);
 	scsi_forget_host(shost);
 	scsi_proc_host_rm(shost);
 
-	scsi_host_set_state(shost, SHOST_DEL);
+	if (!scsi_host_set_state(shost, SHOST_DEL))
+		BUG_ON(!scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
 
 	transport_unregister_device(&shost->shost_gendev);
 	class_device_unregister(&shost->shost_classdev);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -68,19 +68,24 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 {
 	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
+	int ret = 0;
 
 	if (shost->eh_wait == NULL)
 		return 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
+	if (!scsi_host_set_state(shost, SHOST_RECOVERY))
+		if (!scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
+			goto out_unlock;
 
+	ret = 1;
 	scmd->eh_eflags |= eh_flag;
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
-	scsi_host_set_state(shost, SHOST_RECOVERY);
 	shost->host_failed++;
 	scsi_eh_wakeup(shost);
+ out_unlock:
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	return 1;
+	return ret;
 }
 
 /**
@@ -176,8 +181,8 @@ void scsi_times_out(struct scsi_cmnd *sc
 		}
 
 	if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
-		panic("Error handler thread not present at %p %p %s %d",
-		      scmd, scmd->device->host, __FILE__, __LINE__);
+		scmd->result |= DID_TIME_OUT << 16;
+		__scsi_done(scmd);
 	}
 }
 
@@ -196,8 +201,7 @@ int scsi_block_when_processing_errors(st
 {
 	int online;
 
-	wait_event(sdev->host->host_wait, (sdev->host->shost_state !=
-					   SHOST_RECOVERY));
+	wait_event(sdev->host->host_wait, !scsi_host_in_recovery(sdev->host));
 
 	online = scsi_device_online(sdev);
 
@@ -1460,7 +1464,9 @@ static void scsi_restart_operations(stru
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: waking up host to restart\n",
 					  __FUNCTION__));
 
-	scsi_host_set_state(shost, SHOST_RUNNING);
+	if (!scsi_host_set_state(shost, SHOST_RUNNING))
+		if (!scsi_host_set_state(shost, SHOST_CANCEL))
+			BUG_ON(!scsi_host_set_state(shost, SHOST_DEL));
 
 	wake_up(&shost->host_wait);
 
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -458,7 +458,7 @@ int scsi_nonblockable_ioctl(struct scsi_
 	 * error processing, as long as the device was opened
 	 * non-blocking */
 	if (filp && filp->f_flags & O_NONBLOCK) {
-		if (sdev->host->shost_state == SHOST_RECOVERY)
+		if (scsi_host_in_recovery(sdev->host))
 			return -ENODEV;
 	} else if (!scsi_block_when_processing_errors(sdev))
 		return -ENODEV;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -424,7 +424,7 @@ void scsi_device_unbusy(struct scsi_devi
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_busy--;
-	if (unlikely((shost->shost_state == SHOST_RECOVERY) &&
+	if (unlikely(scsi_host_in_recovery(shost) &&
 		     shost->host_failed))
 		scsi_eh_wakeup(shost);
 	spin_unlock(shost->host_lock);
@@ -1306,7 +1306,7 @@ static inline int scsi_host_queue_ready(
 				   struct Scsi_Host *shost,
 				   struct scsi_device *sdev)
 {
-	if (shost->shost_state == SHOST_RECOVERY)
+	if (scsi_host_in_recovery(shost))
 		return 0;
 	if (shost->host_busy == 0 && shost->host_blocked) {
 		/*
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -57,6 +57,8 @@ static struct {
 	{ SHOST_CANCEL, "cancel" },
 	{ SHOST_DEL, "deleted" },
 	{ SHOST_RECOVERY, "recovery" },
+	{ SHOST_CANCEL_RECOVERY, "cancel/recovery" },
+	{ SHOST_DEL_RECOVERY, "deleted/recovery", },
 };
 const char *scsi_host_state_name(enum scsi_host_state state)
 {
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1027,7 +1027,7 @@ sg_ioctl(struct inode *inode, struct fil
 		if (sdp->detached)
 			return -ENODEV;
 		if (filp->f_flags & O_NONBLOCK) {
-			if (sdp->device->host->shost_state == SHOST_RECOVERY)
+			if (scsi_host_in_recovery(sdp->device->host))
 				return -EBUSY;
 		} else if (!scsi_block_when_processing_errors(sdp->device))
 			return -EBUSY;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -439,6 +439,8 @@ enum scsi_host_state {
 	SHOST_CANCEL,
 	SHOST_DEL,
 	SHOST_RECOVERY,
+	SHOST_CANCEL_RECOVERY,
+	SHOST_DEL_RECOVERY,
 };
 
 struct Scsi_Host {
@@ -621,6 +623,13 @@ static inline struct Scsi_Host *dev_to_s
 	return container_of(dev, struct Scsi_Host, shost_gendev);
 }
 
+static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
+{
+	return shost->shost_state == SHOST_RECOVERY ||
+		shost->shost_state == SHOST_CANCEL_RECOVERY ||
+		shost->shost_state == SHOST_DEL_RECOVERY;
+}
+
 extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
 extern void scsi_flush_work(struct Scsi_Host *);
 


