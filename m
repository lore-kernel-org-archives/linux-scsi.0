From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] add back single_lun support
Date: Wed, 5 Feb 2003 14:51:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030205145104.A6169@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

This patch against the current scsi-misc-2.5 adds back the check for the
single_lun case.

I compiled and booted with this applied but don't have any devices (i.e.
CD ROM changer) for testing.

--- 1.66/drivers/scsi/scsi_lib.c	Wed Feb  5 08:33:15 2003
+++ edited/drivers/scsi/scsi_lib.c	Tue Feb 11 14:27:08 2003
@@ -787,6 +787,22 @@
 	return ret;
 }
 
+/*
+ * The target associated with myself can only handle one active command at
+ * a time. Scan through all of the luns on the same target as myself,
+ * return 1 if any are active.
+ */
+static int check_all_luns(struct scsi_device *myself)
+{
+	struct scsi_device *sdev;
+
+	list_for_each_entry(sdev, &myself->same_target_siblings,
+			    same_target_siblings)
+		if (atomic_read(&sdev->device_active))
+			return 1;
+	return 0;
+}
+
 int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
 	struct Scsi_Device_Template *STpnt;
@@ -948,6 +964,9 @@
 		req = elv_next_request(q);
 
 		if (SDpnt->device_busy >= SDpnt->queue_depth)
+			break;
+
+		if (SDpnt->single_lun && check_all_luns(SDpnt))
 			break;
 
 		if(SHpnt->host_busy == 0 && SHpnt->host_blocked) {


-- Patrick Mansfield
