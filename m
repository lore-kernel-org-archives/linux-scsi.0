From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: increase default timeout for INQUIRY
Date: Thu, 12 Mar 2009 11:08:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0903121106480.3155-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50157 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754571AbZCLPIx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2009 11:08:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Paul Wellner Bou <paul@purecodes.org>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1224) changes the default timeout for INQUIRY commands
from 3 seconds to 20 seconds, which is the value used by Windows for
USB Mass-Storage devices.  Some of these devices, like the Corsair
Flash Voyager (see Bugzilla #12188) really do need a long timeout.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

It's hard to see how this could cause any signficant problems, unless 
somebody actually depends on INQUIRY timing out.



Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -115,12 +115,12 @@ MODULE_PARM_DESC(max_report_luns,
 		 "REPORT LUNS maximum number of LUNS received (should be"
 		 " between 1 and 16384)");
 
-static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+3;
+static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ + 18;
 
 module_param_named(inq_timeout, scsi_inq_timeout, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(inq_timeout, 
 		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
-		 " Default is 5. Some non-compliant devices need more.");
+		 " Default is 20. Some devices may need more; most need less.");
 
 /* This lock protects only this list */
 static DEFINE_SPINLOCK(async_scan_lock);

