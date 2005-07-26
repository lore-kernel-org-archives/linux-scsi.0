From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/5] SCSI scanning and removal fixes
Date: Tue, 26 Jul 2005 10:18:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0507261012340.4746-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:662 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261782AbVGZOSq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 10:18:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch (as543) adds a private entry point to scsi_scan_target, for use
when the caller already owns the scan_mutex, and updates the kerneldoc for
that routine (which was badly out-of-date).  It converts scsi_scan_channel
to use the new entry point.  Lastly, it modifies scsi_get_host_dev to make 
it acquire the scan_mutex, necessary since the routine adds a new 
scsi_device even if it doesn't do any actual scanning.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: 2613/drivers/scsi/scsi_scan.c
===================================================================
--- 2613.orig/drivers/scsi/scsi_scan.c
+++ 2613/drivers/scsi/scsi_scan.c
@@ -1252,27 +1252,8 @@ void scsi_rescan_device(struct device *d
 }
 EXPORT_SYMBOL(scsi_rescan_device);
 
-/**
- * scsi_scan_target - scan a target id, possibly including all LUNs on the
- *     target.
- * @sdevsca:	Scsi_Device handle for scanning
- * @shost:	host to scan
- * @channel:	channel to scan
- * @id:		target id to scan
- *
- * Description:
- *     Scan the target id on @shost, @channel, and @id. Scan at least LUN
- *     0, and possibly all LUNs on the target id.
- *
- *     Use the pre-allocated @sdevscan as a handle for the scanning. This
- *     function sets sdevscan->host, sdevscan->id and sdevscan->lun; the
- *     scanning functions modify sdevscan->lun.
- *
- *     First try a REPORT LUN scan, if that does not scan the target, do a
- *     sequential scan of LUNs on the target id.
- **/
-void scsi_scan_target(struct device *parent, unsigned int channel,
-		      unsigned int id, unsigned int lun, int rescan)
+static void __scsi_scan_target(struct device *parent, unsigned int channel,
+		unsigned int id, unsigned int lun, int rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	int bflags = 0;
@@ -1286,9 +1267,7 @@ void scsi_scan_target(struct device *par
 		 */
 		return;
 
-
 	starget = scsi_alloc_target(parent, channel, id);
-
 	if (!starget)
 		return;
 
@@ -1334,6 +1313,33 @@ void scsi_scan_target(struct device *par
 
 	put_device(&starget->dev);
 }
+
+/**
+ * scsi_scan_target - scan a target id, possibly including all LUNs on the
+ *     target.
+ * @parent:	host to scan
+ * @channel:	channel to scan
+ * @id:		target id to scan
+ * @lun:	Specific LUN to scan or SCAN_WILD_CARD
+ * @rescan:	passed to LUN scanning routines
+ *
+ * Description:
+ *     Scan the target id on @parent, @channel, and @id. Scan at least LUN 0,
+ *     and possibly all LUNs on the target id.
+ *
+ *     First try a REPORT LUN scan, if that does not scan the target, do a
+ *     sequential scan of LUNs on the target id.
+ **/
+void scsi_scan_target(struct device *parent, unsigned int channel,
+		      unsigned int id, unsigned int lun, int rescan)
+{
+	struct Scsi_Host *shost = dev_to_shost(parent);
+
+	down(&shost->scan_mutex);
+	if (scsi_host_scan_allowed(shost))
+		__scsi_scan_target(parent, channel, id, lun, rescan);
+	up(&shost->scan_mutex);
+}
 EXPORT_SYMBOL(scsi_scan_target);
 
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
@@ -1359,10 +1365,12 @@ static void scsi_scan_channel(struct Scs
 				order_id = shost->max_id - id - 1;
 			else
 				order_id = id;
-			scsi_scan_target(&shost->shost_gendev, channel, order_id, lun, rescan);
+			__scsi_scan_target(&shost->shost_gendev, channel,
+					order_id, lun, rescan);
 		}
 	else
-		scsi_scan_target(&shost->shost_gendev, channel, id, lun, rescan);
+		__scsi_scan_target(&shost->shost_gendev, channel,
+				id, lun, rescan);
 }
 
 int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
@@ -1460,12 +1468,15 @@ void scsi_forget_host(struct Scsi_Host *
  */
 struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev = NULL;
 	struct scsi_target *starget;
 
+	down(&shost->scan_mutex);
+	if (!scsi_host_scan_allowed(shost))
+		goto out;
 	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
 	if (!starget)
-		return NULL;
+		goto out;
 
 	sdev = scsi_alloc_sdev(starget, 0, NULL);
 	if (sdev) {
@@ -1473,6 +1484,8 @@ struct scsi_device *scsi_get_host_dev(st
 		sdev->borken = 0;
 	}
 	put_device(&starget->dev);
+ out:
+	up(&shost->scan_mutex);
 	return sdev;
 }
 EXPORT_SYMBOL(scsi_get_host_dev);

