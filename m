From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/2] target refcounting infrastructure fixes for usb
Date: Sat, 21 Dec 2013 15:51:25 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312211547490.12252-100000@netrider.rowland.org>
References: <20131220231810.GA2835@xanatos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:43945 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755870Ab3LUUv0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Dec 2013 15:51:26 -0500
In-Reply-To: <20131220231810.GA2835@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Fri, 20 Dec 2013, Sarah Sharp wrote:

> On Thu, Dec 19, 2013 at 11:48:47AM -0800, James Bottomley wrote:
> > It should apply incrementally on top of the previous two.  If it
> > actually works, I'll fold it into the first patch.
> 
> Well, it doesn't oops anymore, but it does generate a pile of warnings:

This was a simple oversight.  scsi_target_reap() was called at the
start of __scsi_remove_device(), but it should be called at the end.
The patch below, applied on top of James's three patches, will fix the
warnings.

Alan Stern

P.S.: The comment isn't entirely correct any more...



Index: usb-3.13/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-3.13.orig/drivers/scsi/scsi_sysfs.c
+++ usb-3.13/drivers/scsi/scsi_sysfs.c
@@ -1028,13 +1028,6 @@ void __scsi_remove_device(struct scsi_de
 {
 	struct device *dev = &sdev->sdev_gendev;
 
-	/*
-	 * Paired with the kref_get() in scsi_sysfs_initialize().  We're
-	 * removing sysfs visibility from the device, so make the target
-	 * invisible if this was the last device underneath it.
-	 */
-	scsi_target_reap(scsi_target(sdev));
-
 	if (sdev->is_visible) {
 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 			return;
@@ -1059,6 +1052,13 @@ void __scsi_remove_device(struct scsi_de
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
 
+	/*
+	 * Paired with the kref_get() in scsi_sysfs_initialize().  We're
+	 * removing sysfs visibility from the device, so make the target
+	 * invisible if this was the last device underneath it.
+	 */
+	scsi_target_reap(scsi_target(sdev));
+
 	put_device(dev);
 }
 

