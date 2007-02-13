From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH 2/2] [v2] ibmvscsi: add slave_configure to allow device restart
Date: Tue, 13 Feb 2007 10:51:46 -0600
Message-ID: <20070213165146.GA19964@austin.ibm.com>
References: <20070209174949.5080.69663.sendpatchset@toy> <20070209175000.5080.69780.sendpatchset@toy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52106 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbXBMQvv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Feb 2007 11:51:51 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l1DGpmvI009363
	for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2007 11:51:48 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1DGpmCu302114
	for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2007 11:51:48 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1DGplCd011591
	for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2007 11:51:47 -0500
Content-Disposition: inline
In-Reply-To: <20070209175000.5080.69780.sendpatchset@toy>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The first version of this patch had the incorrect type for the
lock_flags variable.

Adding a slave_configure function for the driver. Now the disks can be
restarted by the scsi mid-layer when the are disconnected and reconnected.

Signed-off-by: "Robert Jennings" <rcj@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: b/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
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
+	unsigned long lock_flags = 0;
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
