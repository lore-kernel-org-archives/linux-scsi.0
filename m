From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] split busy check out of scsi_remove_host
Date: Thu, 21 Nov 2002 00:39:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121003956.B8517@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

just a simple code cleanup


--- 1.31/drivers/scsi/hosts.c	Sun Nov 17 16:47:02 2002
+++ edited/drivers/scsi/hosts.c	Wed Nov 20 02:20:15 2002
@@ -208,6 +208,48 @@
 	return 0;
 }
 
+static int scsi_check_device_busy(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_cmnd *scmd;
+
+	/*
+	 * Loop over all of the commands associated with the
+	 * device.  If any of them are busy, then set the state
+	 * back to inactive and bail.
+	 */
+	for (scmd = sdev->device_queue; scmd; scmd = scmd->next) {
+		if (scmd->request && scmd->request->rq_status != RQ_INACTIVE)
+			goto active;
+
+		/*
+		 * No, this device is really free.  Mark it as such, and
+		 * continue on.
+		 */
+		scmd->state = SCSI_STATE_DISCONNECTING;
+		if (scmd->request)
+			scmd->request->rq_status = RQ_SCSI_DISCONNECTING;
+	}
+
+	return 0;
+
+active:
+	printk(KERN_ERR "SCSI device not inactive - rq_status=%d, target=%d, "
+			"pid=%ld, state=%d, owner=%d.\n",
+			scmd->request->rq_status, scmd->target,
+			scmd->pid, scmd->state, scmd->owner);
+
+	for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
+		for (scmd = sdev->device_queue; scmd; scmd = scmd->next) {
+			if (scmd->request->rq_status == RQ_SCSI_DISCONNECTING)
+				scmd->request->rq_status = RQ_INACTIVE;
+		}
+	}
+
+	printk(KERN_ERR "Device busy???\n");
+	return 1;
+}
+
 /**
  * scsi_remove_host - check a scsi host for release and release
  * @shost:	a pointer to a scsi host to release
@@ -218,7 +260,6 @@
 int scsi_remove_host(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
-	struct scsi_cmnd *scmd;
 
 	/*
 	 * FIXME Do ref counting.  We force all of the devices offline to
@@ -228,43 +269,9 @@
 	for (sdev = shost->host_queue; sdev; sdev = sdev->next) 
 		sdev->online = FALSE;
 
-	for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
-		/*
-		 * Loop over all of the commands associated with the
-		 * device.  If any of them are busy, then set the state
-		 * back to inactive and bail.
-		 */
-		for (scmd = sdev->device_queue; scmd; scmd = scmd->next) {
-			if (scmd->request && scmd->request->rq_status !=
-			    RQ_INACTIVE) {
-				printk(KERN_ERR "SCSI device not inactive"
-				       "- rq_status=%d, target=%d, pid=%ld,"
-				       "state=%d, owner=%d.\n",
-				       scmd->request->rq_status,
-				       scmd->target, scmd->pid,
-				       scmd->state, scmd->owner);
-				for (sdev = shost->host_queue; sdev;
-				     sdev = sdev->next) {
-					for (scmd = sdev->device_queue; scmd;
-					     scmd = scmd->next)
-						if (scmd->request->rq_status ==
-						    RQ_SCSI_DISCONNECTING)
-							scmd->request->rq_status = RQ_INACTIVE;
-				}
-				printk(KERN_ERR "Device busy???\n");
-				return 1;
-			}
-			/*
-			 * No, this device is really free.  Mark it as such, and
-			 * continue on.
-			 */
-			scmd->state = SCSI_STATE_DISCONNECTING;
-			if (scmd->request)
-				scmd->request->rq_status =
-					RQ_SCSI_DISCONNECTING;	/* Mark as
-								   busy */
-		}
-	}
+	for (sdev = shost->host_queue; sdev; sdev = sdev->next)
+		if (scsi_check_device_busy(sdev))
+			return 1;
 
 	/*
 	 * Next we detach the high level drivers from the Scsi_Device
