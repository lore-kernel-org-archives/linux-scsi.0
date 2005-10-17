From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI core code cleanup
Date: Mon, 17 Oct 2005 12:07:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0510171203330.4446-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:29145 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751417AbVJQQHk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 12:07:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch (as583) makes some minor cleanups and improvements to some 
newly-added sections of code.  The primary benefits are removal of 
misleading error messages in the system log, and moving two BUG_ON lines 
outside spinlock-protected areas (so they won't crash the entire system).

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_error.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_error.c
+++ usb-2.6/drivers/scsi/scsi_error.c
@@ -74,9 +74,10 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 		return 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (scsi_host_set_state(shost, SHOST_RECOVERY))
-		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
-			goto out_unlock;
+	if (scsi_host_set_state(shost,
+			(shost->shost_state == SHOST_CANCEL) ?
+				SHOST_CANCEL_RECOVERY : SHOST_RECOVERY))
+		goto out_unlock;
 
 	ret = 1;
 	scmd->eh_eflags |= eh_flag;
@@ -1446,6 +1447,8 @@ static void scsi_restart_operations(stru
 {
 	struct scsi_device *sdev;
 	unsigned long flags;
+	enum scsi_host_state newstate;
+	int rc;
 
 	/*
 	 * If the door was locked, we need to insert a door lock request
@@ -1466,10 +1469,20 @@ static void scsi_restart_operations(stru
 					  __FUNCTION__));
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (scsi_host_set_state(shost, SHOST_RUNNING))
-		if (scsi_host_set_state(shost, SHOST_CANCEL))
-			BUG_ON(scsi_host_set_state(shost, SHOST_DEL));
+	switch (shost->shost_state) {
+	default:
+		newstate = SHOST_RUNNING;
+		break;
+	case SHOST_CANCEL_RECOVERY:
+		newstate = SHOST_CANCEL;
+		break;
+	case SHOST_DEL_RECOVERY:
+		newstate = SHOST_DEL;
+		break;
+	}
+	rc = scsi_host_set_state(shost, newstate);
 	spin_unlock_irqrestore(shost->host_lock, flags);
+	BUG_ON(rc);
 
 	wake_up(&shost->host_wait);
 
Index: usb-2.6/drivers/scsi/hosts.c
===================================================================
--- usb-2.6.orig/drivers/scsi/hosts.c
+++ usb-2.6/drivers/scsi/hosts.c
@@ -154,24 +154,27 @@ EXPORT_SYMBOL(scsi_host_set_state);
  **/
 void scsi_remove_host(struct Scsi_Host *shost)
 {
+	int rc;
 	unsigned long flags;
+
 	down(&shost->scan_mutex);
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (scsi_host_set_state(shost, SHOST_CANCEL))
-		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
-			up(&shost->scan_mutex);
-			return;
-		}
+	rc = scsi_host_set_state(shost,
+			(shost->shost_state == SHOST_RECOVERY) ?
+				SHOST_CANCEL_RECOVERY : SHOST_CANCEL);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	up(&shost->scan_mutex);
+	if (rc)
+		return;
 	scsi_forget_host(shost);
 	scsi_proc_host_rm(shost);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (scsi_host_set_state(shost, SHOST_DEL))
-		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
+	rc = scsi_host_set_state(shost,
+			(shost->shost_state == SHOST_CANCEL_RECOVERY) ?
+				SHOST_DEL_RECOVERY : SHOST_DEL);
 	spin_unlock_irqrestore(shost->host_lock, flags);
+	BUG_ON(rc);
 
 	transport_unregister_device(&shost->shost_gendev);
 	class_device_unregister(&shost->shost_classdev);

