From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: Check return code from scsi_sysfs_add_sdev
Date: Mon, 25 Jul 2005 10:51:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0507251045480.5068-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38091 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261243AbVGYOvb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 10:51:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch (as541) adds a missing check for an error return code from 
scsi_sysfs_add_sdev.  This resolves entry #4863 in the OSDL bugzilla.  
Although in that bug report the failure occurred because of a confusion 
over scanning vs. rescanning, in general add_sdev can fail for a number of 
reasons (the simplest being insufficient memory) and the caller should 
cope properly.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: 2.6.13-rc2/drivers/scsi/scsi_scan.c
===================================================================
--- 2.6.13-rc2.orig/drivers/scsi/scsi_scan.c
+++ 2.6.13-rc2/drivers/scsi/scsi_scan.c
@@ -756,7 +756,8 @@ static int scsi_add_lun(struct scsi_devi
 	 * register it and tell the rest of the kernel
 	 * about it.
 	 */
-	scsi_sysfs_add_sdev(sdev);
+	if (scsi_sysfs_add_sdev(sdev) != 0)
+		return SCSI_SCAN_NO_RESPONSE;
 
 	return SCSI_SCAN_LUN_PRESENT;
 }

