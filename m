From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] use scsi_report_bus_reset() in scsi_erroc.c
Date: Sun, 27 Apr 2003 13:42:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427134254.A27685@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:48395 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263931AbTD0Lam (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 07:30:42 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Currently scsi_error.c has two opencoded copies for
scsi_report_bus_reset.  Get rid of them.


--- 1.48/drivers/scsi/scsi_error.c	Mon Apr 21 10:17:33 2003
+++ edited/drivers/scsi/scsi_error.c	Sun Apr 27 10:46:14 2003
@@ -916,7 +913,6 @@
  **/
 static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 {
-	struct scsi_device *sdev;
 	unsigned long flags;
 	int rtn;
 
@@ -934,16 +930,9 @@
 
 	if (rtn == SUCCESS) {
 		scsi_sleep(BUS_RESET_SETTLE_TIME);
-		/*
-		 * Mark all affected devices to expect a unit attention.
-		 */
-		list_for_each_entry(sdev, &scmd->device->host->my_devices,
-				    siblings)
-			if (scmd->device->channel == sdev->channel) {
-				sdev->was_reset = 1;
-				sdev->expecting_cc_ua = 1;
-			}
+		scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
 	}
+
 	return rtn;
 }
 
@@ -953,7 +942,6 @@
  **/
 static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
-	struct scsi_device *sdev;
 	unsigned long flags;
 	int rtn;
 
@@ -971,16 +959,9 @@
 
 	if (rtn == SUCCESS) {
 		scsi_sleep(HOST_RESET_SETTLE_TIME);
-		/*
-		 * Mark all affected devices to expect a unit attention.
-		 */
-		list_for_each_entry(sdev, &scmd->device->host->my_devices,
-				    siblings)
-			if (scmd->device->channel == sdev->channel) {
-				sdev->was_reset = 1;
-				sdev->expecting_cc_ua = 1;
-			}
+		scsi_report_bus_reset(scmd->device->host, scmd->device->channel);
 	}
+
 	return rtn;
 }
 
