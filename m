From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: Changeable queue depth
Date: Tue, 29 May 2007 13:00:24 -0500
Message-ID: <2838.23623690314$1180461642@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40590 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267AbXE2SA1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 May 2007 14:00:27 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4TI1TJo007675
	for <linux-scsi@vger.kernel.org>; Tue, 29 May 2007 14:01:29 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4TI0Qv6521600
	for <linux-scsi@vger.kernel.org>; Tue, 29 May 2007 14:00:26 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4TI0Quc007942
	for <linux-scsi@vger.kernel.org>; Tue, 29 May 2007 14:00:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santil@linux.vnet.ibm.com
Cc: rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Adds support for a changeable queue depth to ibmvscsi.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_change_q_depth drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_change_q_depth	2007-05-29 09:31:43.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2007-05-29 09:31:43.000000000 -0500
@@ -1375,6 +1375,20 @@ static int ibmvscsi_slave_configure(stru
 	return 0;
 }
 
+/**
+ * ibmvscsi_change_queue_depth - Change the device's queue depth
+ * @sdev:	scsi device struct
+ * @qdepth:	depth to set
+ *
+ * Return value:
+ * 	actual depth set
+ **/
+static int ibmvscsi_change_queue_depth(struct scsi_device *sdev, int qdepth)
+{
+	scsi_adjust_queue_depth(sdev, 0, qdepth);
+	return sdev->queue_depth;
+}
+
 /* ------------------------------------------------------------
  * sysfs attributes
  */
@@ -1521,6 +1535,7 @@ static struct scsi_host_template driver_
 	.eh_abort_handler = ibmvscsi_eh_abort_handler,
 	.eh_device_reset_handler = ibmvscsi_eh_device_reset_handler,
 	.slave_configure = ibmvscsi_slave_configure,
+	.change_queue_depth = ibmvscsi_change_queue_depth,
 	.cmd_per_lun = 16,
 	.can_queue = IBMVSCSI_MAX_REQUESTS_DEFAULT,
 	.this_id = -1,
_
