From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI core: better initialization for sdev->scsi_level
Date: Fri, 16 Feb 2007 14:42:54 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0702161439050.3490-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43454 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1946076AbXBPTmz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Feb 2007 14:42:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Douglas Gilbert <dougg@torque.net>, SCSI development list <linux-scsi@vger.kernel.org>

Both scsi_device and scsi_target include a scsi_level field, and the
SCSI core makes a half-hearted effort to keep the values equal.
Ultimately this effort may be doomed, since as far as I know there is
no reason why all LUNs in a target must report the same "ANSI-approved
version" number.  But for the most part it should work okay.

This patch (as834) changes the SCSI core so that after the first LUN
has been probed and the target's scsi_level is known, further LUNs
default to the target's scsi_level and not to SCSI_2.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

James, this is another resubmission.  Regarding the original submission,
Doug commented that it didn't seem to make things any better than the
current situation.  I pointed out that it did, even though it may not be a
perfect solution.  He didn't reply, which I assume means he agrees.

Alan Stern


Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -382,6 +382,7 @@ static struct scsi_target *scsi_alloc_ta
 	INIT_LIST_HEAD(&starget->siblings);
 	INIT_LIST_HEAD(&starget->devices);
 	starget->state = STARGET_RUNNING;
+	starget->scsi_level = SCSI_2;
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -922,7 +922,7 @@ void scsi_sysfs_device_initialize(struct
 	snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
 		 "%d:%d:%d:%d", sdev->host->host_no,
 		 sdev->channel, sdev->id, sdev->lun);
-	sdev->scsi_level = SCSI_2;
+	sdev->scsi_level = starget->scsi_level;
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);

