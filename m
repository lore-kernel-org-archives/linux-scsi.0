From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] helper for device list traversal
Date: Sat, 20 Sep 2003 15:24:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030920132411.GA23038@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:52353 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261884AbTITNYQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2003 09:24:16 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

This patch adds shost_for_each_device().  It's used to abstract out
scsi_host.my_devices traversal.  The next step will be to replace
the current simple implementation with one that's fully locked down
an reference counted.


--- 1.34/drivers/scsi/dpt_i2o.c	Tue Aug 26 18:25:41 2003
+++ edited/drivers/scsi/dpt_i2o.c	Sat Sep 20 14:04:56 2003
@@ -2483,7 +2483,7 @@
 	Scsi_Cmnd* 	cmd = NULL;
 	Scsi_Device* 	d = NULL;
 
-	list_for_each_entry(d, &pHba->host->my_devices, siblings) {
+	shost_for_each_device(d, pHba->host) {
 		unsigned long flags;
 		spin_lock_irqsave(&d->list_lock, flags);
 		list_for_each_entry(cmd, &d->cmd_list, list) {
--- 1.12/drivers/scsi/fcal.c	Fri May  2 21:29:48 2003
+++ edited/drivers/scsi/fcal.c	Sat Sep 20 14:06:41 2003
@@ -245,7 +245,7 @@
 				 alpa, u1[0], u1[1], u2[0], u2[1]);
 		} else {
 			Scsi_Device *scd;
-			list_for_each_entry (scd, &host->my_devices, siblings)
+			shost_for_each_device(scd, host)
 				if (scd->id == target) {
 					SPRINTF ("  [AL-PA: %02x, Id: %02d, Port WWN: %08x%08x, Node WWN: %08x%08x]  ",
 						alpa, target, u1[0], u1[1], u2[0], u2[1]);
--- 1.22/drivers/scsi/g_NCR5380.c	Thu Aug 21 10:36:23 2003
+++ edited/drivers/scsi/g_NCR5380.c	Sat Sep 20 14:07:14 2003
@@ -825,7 +825,7 @@
 		PRINTP("  %d pending writes" ANDP hostdata->pendingw);
 	if (hostdata->pendingr || hostdata->pendingw)
 		PRINTP("\n");
-	list_for_each_entry (dev, &scsi_ptr->my_devices, siblings) {
+	shost_for_each_device(dev, scsi_ptr) {
 		unsigned long br = hostdata->bytes_read[dev->id];
 		unsigned long bw = hostdata->bytes_write[dev->id];
 		long tr = hostdata->time_read[dev->id] / HZ;
--- 1.63/drivers/scsi/scsi_error.c	Sat Sep 20 11:11:42 2003
+++ edited/drivers/scsi/scsi_error.c	Sat Sep 20 13:53:02 2003
@@ -211,8 +211,7 @@
 	int cmd_cancel = 0;
 	int devices_failed = 0;
 
-
-	list_for_each_entry(sdev, &shost->my_devices, siblings) {
+	shost_for_each_device(sdev, shost) {
 		list_for_each_entry(scmd, work_q, eh_entry) {
 			if (scmd->device == sdev) {
 				++total_failures;
@@ -850,7 +849,7 @@
 	struct scsi_device *sdev;
 	int rtn;
 
-	list_for_each_entry(sdev, &shost->my_devices, siblings) {
+	shost_for_each_device(sdev, shost) {
 		bdr_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
 			if (scmd->device == sdev) {
@@ -1363,9 +1362,10 @@
 	 * onto the head of the SCSI request queue for the device.  There
 	 * is no point trying to lock the door of an off-line device.
 	 */
-	list_for_each_entry(sdev, &shost->my_devices, siblings)
+	shost_for_each_device(sdev, shost) {
 		if (sdev->online && sdev->locked)
 			scsi_eh_lock_door(sdev);
+	}
 
 	/*
 	 * next free up anything directly waiting upon the host.  this
@@ -1621,7 +1621,7 @@
 {
 	struct scsi_device *sdev;
 
-	list_for_each_entry(sdev, &shost->my_devices, siblings) {
+	shost_for_each_device(sdev, shost) {
 		if (channel == sdev->channel) {
 			sdev->was_reset = 1;
 			sdev->expecting_cc_ua = 1;
@@ -1655,7 +1655,7 @@
 {
 	struct scsi_device *sdev;
 
-	list_for_each_entry(sdev, &shost->my_devices, siblings) {
+	shost_for_each_device(sdev, shost) {
 		if (channel == sdev->channel &&
 		    target == sdev->id) {
 			sdev->was_reset = 1;
--- 1.112/drivers/scsi/scsi_lib.c	Sat Sep 20 11:11:42 2003
+++ edited/drivers/scsi/scsi_lib.c	Sat Sep 20 13:53:02 2003
@@ -462,7 +462,7 @@
 {
 	struct scsi_device *sdev;
 
-	list_for_each_entry(sdev, &shost->my_devices, siblings)
+	shost_for_each_device(sdev, shost)
 		scsi_run_queue(sdev->request_queue);
 }
 
--- 1.25/drivers/scsi/arm/fas216.c	Mon Aug 25 15:37:34 2003
+++ edited/drivers/scsi/arm/fas216.c	Sat Sep 20 14:08:01 2003
@@ -2592,7 +2592,7 @@
 	 * all command structures.  Leave the running
 	 * command in place.
 	 */
-	list_for_each_entry(SDpnt, &info->host->my_devices, siblings) {
+	shost_for_each_device(SDpnt, info->host) {
 		int i;
 
 		if (SDpnt->soft_reset)
@@ -3007,7 +3007,7 @@
 
 	p += sprintf(p, "Device/Lun TaggedQ       Parity   Sync\n");
 
-	list_for_each_entry(scd, &info->host->my_devices, siblings) {
+	shost_for_each_device(scd, info->host) {
 		dev = &info->device[scd->id];
 		p += sprintf(p, "     %d/%d   ", scd->id, scd->lun);
 		if (scd->tagged_supported)
--- 1.6/include/scsi/scsi_device.h	Mon Aug 25 15:37:34 2003
+++ edited/include/scsi/scsi_device.h	Sat Sep 20 14:10:27 2003
@@ -111,6 +111,9 @@
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 
+#define shost_for_each_device(sdev, shost) \
+	list_for_each_entry((sdev), &((shost)->my_devices), siblings)
+
 extern void scsi_adjust_queue_depth(struct scsi_device *, int, int);
 extern int scsi_track_queue_full(struct scsi_device *, int);
 
