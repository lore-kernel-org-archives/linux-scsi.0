From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: don't reap targets upon registration failure
Date: Thu, 18 Mar 2010 15:41:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1003181530100.1325-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46536 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751514Ab0CRTlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2010 15:41:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1358) fixes a bug in the error pathway of
scsi_target_add().  If registration fails, the target should not be
reaped.  The reaping occurs later, when scanning is finished and all
the child devices are removed.  The current code leaves an unbalanced
value in starget->reap_ref.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -852,9 +852,6 @@ static int scsi_target_add(struct scsi_t
 	error = device_add(&starget->dev);
 	if (error) {
 		dev_err(&starget->dev, "target device_add failed, error %d\n", error);
-		get_device(&starget->dev);
-		scsi_target_reap(starget);
-		put_device(&starget->dev);
 		return error;
 	}
 	transport_add_device(&starget->dev);

