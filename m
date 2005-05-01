From: Jeremy Higdon <jeremy@sgi.com>
Subject: [PATCH 2.6.12-rc3] qla1280.c - fix result for device Busy and Queue Full
Date: Sat, 30 Apr 2005 22:18:48 -0700
Message-ID: <20050501051847.GA1147569@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:36529 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S261527AbVEAFS4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 May 2005 01:18:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jes@wildopensource.com, hch@lst.de

I discovered that the qla1280 driver does not send the correct status
to the midlayer when it gets Queue Full or Busy from a device.

Signed-off-by: Jeremy Higdon <jeremy@sgi.com>

--- drivers/scsi/qla1280.c.orig	2005-04-30 02:21:08.000000000 -0700
+++ drivers/scsi/qla1280.c	2005-04-30 21:57:21.000000000 -0700
@@ -4038,11 +4038,10 @@
 			scsi_status, handle);
 	}
 
-	/* Target busy */
-	if (scsi_status & SS_BUSY_CONDITION &&
-	    scsi_status != SS_RESERVE_CONFLICT) {
-		CMD_RESULT(cmd) =
-			DID_BUS_BUSY << 16 | (scsi_status & 0xff);
+	/* Target busy or queue full */
+	if ((scsi_status & 0xFF) == SAM_STAT_TASK_SET_FULL ||
+	    (scsi_status & 0xFF) == SAM_STAT_BUSY) {
+		CMD_RESULT(cmd) = scsi_status & 0xff;
 	} else {
 
 		/* Save ISP completion status */
