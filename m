From: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>
Subject: [PATCH] 2.4.X Avoid excessive recursion when setting device offline
Date: Mon, 29 Mar 2004 10:07:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <387680000.1080580020@aslan.btc.adaptec.com>
Reply-To: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:51140 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S263003AbUC2RHC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2004 12:07:02 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id i2TH71W20726
	for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2004 09:07:01 -0800
Received: from [10.100.253.70] (aslan.btc.adaptec.com [10.100.253.70])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id i2TH71827988
	for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2004 09:07:01 -0800
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

How to reproduce: Queue up lots of I/O to a device.  Set that device
		  offline.

Result: The SCSI mid-layer blows out the kernel stack due to the inherent
	recursion in its request function.  The repeating stack trace goes
	something like:

	scsi_request_fn
	__scsi_end_request
	scsi_release_command
	scsi_queue_next_request
	scsi_request_fn
	...

This patch prevents recursive calls through the scsi_request_fn
for the same queue:

===== scsi.h 1.9 vs edited =====
--- 1.9/drivers/scsi/scsi.h	Wed Jun 25 17:34:08 2003
+++ edited/scsi.h	Sun Mar 28 13:50:35 2004
@@ -609,6 +609,7 @@
 	unsigned starved:1;	/* unable to process commands because
 				   host busy */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
+	unsigned running_request_fn:1;
 
 	// Flag to allow revalidate to succeed in sd_open
 	int allow_revalidate;
===== scsi_lib.c 1.17 vs edited =====
--- 1.17/drivers/scsi/scsi_lib.c	Fri Jul  4 11:12:45 2003
+++ edited/scsi_lib.c	Sun Mar 28 14:07:48 2004
@@ -850,12 +850,20 @@
 	if (!SDpnt) {
 		panic("Missing device");
 	}
+
 	SHpnt = SDpnt->host;
 
 	/*
 	 * To start with, we keep looping until the queue is empty, or until
-	 * the host is no longer able to accept any more requests.
+	 * the host is no longer able to accept any more requests.  We avoid
+	 * excessive recursion through the SCSI layer by recording that we
+	 * are running this queue and rejecting requests to run it again. This
+	 * avoids blowing out the stack when multiple commands are failed
+	 * during our loop.
 	 */
+	if (SDpnt->running_request_fn)
+		return;
+	SDpnt->running_request_fn = 1;
 	while (1 == 1) {
 		/*
 		 * Check this again - each time we loop through we will have
@@ -863,7 +871,7 @@
 		 * we need to check to see if the queue is plugged or not.
 		 */
 		if (SHpnt->in_recovery || q->plugged)
-			return;
+			break;
 
 		/*
 		 * If the device cannot accept another request, then quit.
@@ -1099,6 +1107,7 @@
 		 */
 		spin_lock_irq(&io_request_lock);
 	}
+	SDpnt->running_request_fn = 0;
 }
 
 /*

