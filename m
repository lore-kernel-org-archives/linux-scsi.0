From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ibmvscsi: add slave_configure to allow device restart
Date: Fri, 09 Feb 2007 11:50:00 -0600
Message-ID: <20070209175000.5080.69780.sendpatchset@toy>
References: <20070209174949.5080.69663.sendpatchset@toy>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:54589 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992459AbXBIRuC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2007 12:50:02 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l19Ho2XU017926
	for <linux-scsi@vger.kernel.org>; Fri, 9 Feb 2007 12:50:02 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l19Ho1s6543424
	for <linux-scsi@vger.kernel.org>; Fri, 9 Feb 2007 10:50:01 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l19Ho0iR024942
	for <linux-scsi@vger.kernel.org>; Fri, 9 Feb 2007 10:50:00 -0700
In-Reply-To: <20070209174949.5080.69663.sendpatchset@toy>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>

Adding a slave_configure function for the driver. Now the disks can be
restarted by the scsi mid-layer when the are disconnected and reconnected.

Signed-off-by: "Robert Jennings" <rcj@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: ibmvscsi-23509/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- ibmvscsi-23509.orig/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ ibmvscsi-23509/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1354,6 +1354,23 @@
 	return rc;
 }
 
+/**
+ * ibmvscsi_slave_configure: For each slave device that is a disk,
+ * ensure that the "allow_restart" flag is enabled.
+ */
+static int ibmvscsi_slave_configure(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	int lock_flags = 0;
+
+	spin_lock_irqsave(shost->host_lock, lock_flags);
+	if (sdev->type == TYPE_DISK)
+		sdev->allow_restart = 1;
+	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
+	spin_unlock_irqrestore(shost->host_lock, lock_flags);
+	return 0;
+}
+
 /* ------------------------------------------------------------
  * sysfs attributes
  */
@@ -1499,6 +1516,7 @@
 	.queuecommand = ibmvscsi_queuecommand,
 	.eh_abort_handler = ibmvscsi_eh_abort_handler,
 	.eh_device_reset_handler = ibmvscsi_eh_device_reset_handler,
+	.slave_configure = ibmvscsi_slave_configure,
 	.cmd_per_lun = 16,
 	.can_queue = IBMVSCSI_MAX_REQUESTS_DEFAULT,
 	.this_id = -1,
