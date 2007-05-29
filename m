From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: Changeable queue depth
Date: Tue, 29 May 2007 15:46:14 -0500
Message-ID: <465C9116.6050600@linux.vnet.ibm.com>
References: <11804616242477-patch-mail.ibm.com> <1180462468.3700.65.camel@mulgrave.il.steeleye.com>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:45307 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396AbXE2UqS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 May 2007 16:46:18 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4TKkHBm031330
	for <linux-scsi@vger.kernel.org>; Tue, 29 May 2007 16:46:17 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4TKkHWg064032
	for <linux-scsi@vger.kernel.org>; Tue, 29 May 2007 14:46:17 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4TKkGSW009369
	for <linux-scsi@vger.kernel.org>; Tue, 29 May 2007 14:46:16 -0600
In-Reply-To: <1180462468.3700.65.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: santil@linux.vnet.ibm.com, rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

Adds support for a changeable queue depth to ibmvscsi.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

James Bottomley wrote:
> Don't you want to check this against some system limit ... or will the
> driver cope just fine when the user sets it to machine infinity and we
> diligently try blasting away at it through the queuecommand() routine?
> 
> The usual limit, if you have variable queues ... is the maximum the
> device could ever accept ... although some people adjust that downwards
> because of device starvation fears.

There isn't anything coming back from the VIO server to indicate what this
max value is for the LUN, so we have to use an arbitrary value. I chose 64
since its generally the max queue depth supported by a single disk supported
on pSeries. Here is an updated patch.

-Brian

---

 linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c |   18 ++++++++++++++++++
 linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.h |    1 +
 2 files changed, 19 insertions(+)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_change_q_depth drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_change_q_depth	2007-05-29 12:57:20.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2007-05-29 15:27:23.000000000 -0500
@@ -1375,6 +1375,23 @@ static int ibmvscsi_slave_configure(stru
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
+	if (qdepth > IBMVSCSI_MAX_CMDS_PER_LUN)
+		qdepth = IBMVSCSI_MAX_CMDS_PER_LUN;
+
+	scsi_adjust_queue_depth(sdev, 0, qdepth);
+	return sdev->queue_depth;
+}
+
 /* ------------------------------------------------------------
  * sysfs attributes
  */
@@ -1521,6 +1538,7 @@ static struct scsi_host_template driver_
 	.eh_abort_handler = ibmvscsi_eh_abort_handler,
 	.eh_device_reset_handler = ibmvscsi_eh_device_reset_handler,
 	.slave_configure = ibmvscsi_slave_configure,
+	.change_queue_depth = ibmvscsi_change_queue_depth,
 	.cmd_per_lun = 16,
 	.can_queue = IBMVSCSI_MAX_REQUESTS_DEFAULT,
 	.this_id = -1,
diff -puN drivers/scsi/ibmvscsi/ibmvscsi.h~ibmvscsi_change_q_depth drivers/scsi/ibmvscsi/ibmvscsi.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.h~ibmvscsi_change_q_depth	2007-05-29 15:25:24.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.h	2007-05-29 15:29:11.000000000 -0500
@@ -45,6 +45,7 @@ struct Scsi_Host;
 #define MAX_INDIRECT_BUFS 10
 
 #define IBMVSCSI_MAX_REQUESTS_DEFAULT 100
+#define IBMVSCSI_MAX_CMDS_PER_LUN 64
 
 /* ------------------------------------------------------------
  * Data Structures
_
