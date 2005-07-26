From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5/5] SCSI scanning and removal fixes
Date: Tue, 26 Jul 2005 10:30:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0507261027110.4746-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:62609 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261804AbVGZOak
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2005 10:30:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch (as546) fixes an oops-causing failure to check the return code
from scsi_device_get.  The call can return an error if the LLD is being
unloaded from memory.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: 2613/drivers/scsi/scsi_scan.c
===================================================================
--- 2613.orig/drivers/scsi/scsi_scan.c
+++ 2613/drivers/scsi/scsi_scan.c
@@ -867,8 +867,12 @@ static int scsi_probe_and_add_lun(struct
  out_free_sdev:
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (sdevp) {
-			scsi_device_get(sdev);
-			*sdevp = sdev;
+			if (scsi_device_get(sdev) == 0) {
+				*sdevp = sdev;
+			} else {
+				__scsi_remove_device(sdev);
+				res = SCSI_SCAN_NO_RESPONSE;
+			}
 		}
 	} else {
 		if (sdev->host->hostt->slave_destroy)

