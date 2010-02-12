From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/5] SCSI: fix refcounting bug in scsi_get_host_dev
Date: Fri, 12 Feb 2010 12:13:39 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002121209360.1307-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35475 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757310Ab0BLRNk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 12:13:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1334) fixes a bug in scsi_get_host_dev().  It
incorrectly calls get_device() on the new device's target.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -1909,10 +1909,9 @@ struct scsi_device *scsi_get_host_dev(st
 		goto out;
 
 	sdev = scsi_alloc_sdev(starget, 0, NULL);
-	if (sdev) {
-		sdev->sdev_gendev.parent = get_device(&starget->dev);
+	if (sdev)
 		sdev->borken = 0;
-	} else
+	else
 		scsi_target_reap(starget);
 	put_device(&starget->dev);
  out:

