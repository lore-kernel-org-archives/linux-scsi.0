From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/5] SCSI: fix memory leak in scsi_report_lun_scan
Date: Fri, 12 Feb 2010 12:13:31 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002121208540.1307-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35473 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754766Ab0BLRNc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 12:13:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1333) fixes a bug in scsi_report_lun_scan().  If a
newly-allocated device can't be used, it should be deleted.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -1339,8 +1339,10 @@ static int scsi_report_lun_scan(struct s
 		sdev = scsi_alloc_sdev(starget, 0, NULL);
 		if (!sdev)
 			return 0;
-		if (scsi_device_get(sdev))
+		if (scsi_device_get(sdev)) {
+			__scsi_remove_device(sdev);
 			return 0;
+		}
 	}
 
 	sprintf(devname, "host %d channel %d id %d",

