From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] add back single_lun support
Date: Wed, 5 Feb 2003 17:16:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030205171640.A7065@beaverton.ibm.com>
References: <20030205145104.A6169@beaverton.ibm.com> <1044486842.1773.89.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1044486842.1773.89.camel@mulgrave>; from James.Bottomley@steeleye.com on Wed, Feb 05, 2003 at 05:14:00PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Feb 05, 2003 at 05:14:00PM -0600, James Bottomley wrote:

> I don't see device_active getting set anywhere.
> 
> shouldn't we just dump device_active in favour of a non-zero check of
> device_busy (it's all done under the queue lock, anyway).
> 
> James

OK - once more.

This patch against the current scsi-misc-2.5 adds back the check for the
single_lun case and removes the unused device_active field.

I compiled and booted with this applied but don't have any devices (i.e.
CD ROM changer) for testing.

--- 1.58/drivers/scsi/scsi.h	Tue Feb  4 11:14:16 2003
+++ edited/drivers/scsi/scsi.h	Wed Feb  5 17:36:00 2003
@@ -570,7 +570,6 @@
 					   device is busy */
 	struct Scsi_Host *host;
 	request_queue_t *request_queue;
-        atomic_t                device_active; /* commands checked out for device */
 	volatile unsigned short device_busy;	/* commands actually active on low-level */
 	struct list_head free_cmnds;    /* list of available Scsi_Cmnd structs */
 	struct list_head busy_cmnds;    /* list of Scsi_Cmnd structs in use */
===== drivers/scsi/scsi_lib.c 1.66 vs edited =====
--- 1.66/drivers/scsi/scsi_lib.c	Wed Feb  5 08:33:15 2003
+++ edited/drivers/scsi/scsi_lib.c	Wed Feb  5 17:44:10 2003
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
+		if (sdev->device_busy)
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
