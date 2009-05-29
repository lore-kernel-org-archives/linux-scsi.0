From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/6] SCSI: fix scsi_wait_scan
Date: Fri, 29 May 2009 16:06:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905291552520.2648-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40236 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753055AbZE2UGB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2009 16:06:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1246) fixes a bug in the scsi_wait_scan module.  It's
supposed to wait until all SCSI probing is finished -- but it doesn't,
because of sd_probe_async().  This routine is run by async_schedule(),
not the SCSI async mechanism.  Consequently we have to make an extra
call to async_synchronize_full() to wait for it.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Arjan van de Ven <arjan@linux.intel.com>

---

Index: usb-2.6/drivers/scsi/scsi_wait_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_wait_scan.c
+++ usb-2.6/drivers/scsi/scsi_wait_scan.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/async.h>
 #include <scsi/scsi_scan.h>
 
 static int __init wait_scan_init(void)
@@ -27,6 +28,13 @@ static int __init wait_scan_init(void)
 	 * to finish.
 	 */
 	scsi_complete_async_scans();
+	/*
+	 * If any of those asynchronous SCSI scans called sd_probe()
+	 * then it probably queued another job to run sd_probe_async().
+	 * Wait for that to finish.
+	 */
+	async_synchronize_full();
+
 	return 0;
 }
 


