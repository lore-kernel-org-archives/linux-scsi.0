From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-usb-devel] oops on usb storage device disconnect with
	2.6.14-rc1
Date: Sat, 17 Sep 2005 19:35:17 -0500
Message-ID: <1127003717.4794.10.camel@mulgrave>
References: <20050915190338.GA6807@kroah.com>
	 <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org>
	 <20050915192912.GA7077@kroah.com> <1126814226.4821.48.camel@mulgrave>
	 <1126818483.4821.60.camel@mulgrave>  <20050915221946.GA28441@us.ibm.com>
	 <1126823917.4821.70.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:49049 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751247AbVIRAfb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 20:35:31 -0400
In-Reply-To: <1126823917.4821.70.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net

On Thu, 2005-09-15 at 18:38 -0400, James Bottomley wrote:
> On Thu, 2005-09-15 at 15:19 -0700, Mike Anderson wrote:
> > In looking at the state model introduced by your patch I believe there may
> > still be a state model race issue if the recovery completes just after
> > the "if (!scsi_host_set_state(shost, SHOST_CANCEL))" call in
> > scsi_remove_host (maybe I am just looking to quickly at the state
> > updates).
> 
> No, that's true; there's a tiny race that can be mediated by doing
> locking around the state changes ... that was one of the feedback
> comments from Alan.

The attached should be that patch with the race window closed.

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
@@ -134,13 +154,24 @@ EXPORT_SYMBOL(scsi_host_set_state);
  **/
 void scsi_remove_host(struct Scsi_Host *shost)
 {
+	unsigned long flags;
 	down(&shost->scan_mutex);
-	scsi_host_set_state(shost, SHOST_CANCEL);
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (!scsi_host_set_state(shost, SHOST_CANCEL))
+		if (!scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY)) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			up(&shost->scan_mutex);
+			return;
+		}
+	spin_unlock_irqrestore(shost->host_lock, flags);
 	up(&shost->scan_mutex);
 	scsi_forget_host(shost);
 	scsi_proc_host_rm(shost);
 
-	scsi_host_set_state(shost, SHOST_DEL);
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (!scsi_host_set_state(shost, SHOST_DEL))
+		BUG_ON(!scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
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
 
@@ -1441,6 +1445,7 @@ static void scsi_eh_lock_door(struct scs
 static void scsi_restart_operations(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
+	unsigned long flags;
 
 	/*
 	 * If the door was locked, we need to insert a door lock request
@@ -1460,7 +1465,11 @@ static void scsi_restart_operations(stru
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: waking up host to restart\n",
 					  __FUNCTION__));
 
-	scsi_host_set_state(shost, SHOST_RUNNING);
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (!scsi_host_set_state(shost, SHOST_RUNNING))
+		if (!scsi_host_set_state(shost, SHOST_CANCEL))
+			BUG_ON(!scsi_host_set_state(shost, SHOST_DEL));
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
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
@@ -447,7 +447,7 @@ void scsi_device_unbusy(struct scsi_devi
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_busy--;
-	if (unlikely((shost->shost_state == SHOST_RECOVERY) &&
+	if (unlikely(scsi_host_in_recovery(shost) &&
 		     shost->host_failed))
 		scsi_eh_wakeup(shost);
 	spin_unlock(shost->host_lock);
@@ -1339,7 +1339,7 @@ static inline int scsi_host_queue_ready(
 				   struct Scsi_Host *shost,
 				   struct scsi_device *sdev)
 {
-	if (shost->shost_state == SHOST_RECOVERY)
+	if (scsi_host_in_recovery(shost))
 		return 0;
 	if (shost->host_busy == 0 && shost->host_blocked) {
 		/*
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
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
 


