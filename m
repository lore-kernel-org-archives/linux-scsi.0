From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/5] SCSI scanning and removal fixes
Date: Tue, 26 Jul 2005 10:12:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0507261008540.4746-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54976 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261795AbVGZOMd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 10:12:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch (as542) fixes a few loose ends left by Mike's patches.  It adds 
a declaration for the new scsi_host_set_state routine, adds an allowed 
transition from the SHOST_RECOVERY state to the SHOST_CANCEL state, and 
avoids returning an uninitialized value in __scsi_add_device.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: 2613/include/scsi/scsi_host.h
===================================================================
--- 2613.orig/include/scsi/scsi_host.h
+++ 2613/include/scsi/scsi_host.h
@@ -636,6 +636,7 @@ extern void scsi_remove_host(struct Scsi
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern void scsi_host_put(struct Scsi_Host *t);
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
+extern int scsi_host_set_state(struct Scsi_Host *, enum scsi_host_state);
 extern const char *scsi_host_state_name(enum scsi_host_state);
 
 extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
Index: 2613/drivers/scsi/hosts.c
===================================================================
--- 2613.orig/drivers/scsi/hosts.c
+++ 2613/drivers/scsi/hosts.c
@@ -97,6 +97,7 @@ int scsi_host_set_state(struct Scsi_Host
 		switch (oldstate) {
 		case SHOST_CREATED:
 		case SHOST_RUNNING:
+		case SHOST_RECOVERY:
 			break;
 		default:
 			goto illegal;
Index: 2613/drivers/scsi/scsi_scan.c
===================================================================
--- 2613.orig/drivers/scsi/scsi_scan.c
+++ 2613/drivers/scsi/scsi_scan.c
@@ -1210,25 +1210,28 @@ struct scsi_device *__scsi_add_device(st
 				      uint id, uint lun, void *hostdata)
 {
 	struct scsi_device *sdev;
-	struct device *parent = &shost->shost_gendev;
-	int res;
-	struct scsi_target *starget = scsi_alloc_target(parent, channel, id);
-
-	if (!starget)
-		return ERR_PTR(-ENOMEM);
+	struct scsi_target *starget;
 
-	get_device(&starget->dev);
 	down(&shost->scan_mutex);
-	if (scsi_host_scan_allowed(shost)) {
-		res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1,
-					     hostdata);
-		if (res != SCSI_SCAN_LUN_PRESENT)
-			sdev = ERR_PTR(-ENODEV);
+	if (!scsi_host_scan_allowed(shost)) {
+		sdev = ERR_PTR(-ENODEV);
+		goto out;
 	}
-	up(&shost->scan_mutex);
+	starget = scsi_alloc_target(&shost->shost_gendev, channel, id);
+	if (!starget) {
+		sdev = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+
+	get_device(&starget->dev);
+	if (scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata)
+			!= SCSI_SCAN_LUN_PRESENT)
+		sdev = ERR_PTR(-ENODEV);
 	scsi_target_reap(starget);
 	put_device(&starget->dev);
 
+ out:
+	up(&shost->scan_mutex);
 	return sdev;
 }
 EXPORT_SYMBOL(__scsi_add_device);

