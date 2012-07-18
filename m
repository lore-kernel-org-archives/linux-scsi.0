From: olaf@aepfle.de
Subject: [PATCH] scsi/ibmvscsi: add module alias for ibmvscsic
Date: Wed, 18 Jul 2012 18:49:18 +0200
Message-ID: <1342630158-16510-1-git-send-email-olaf@aepfle.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:56726 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2GRQtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2012 12:49:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, Olaf Hering <olaf@aepfle.de>

From: Olaf Hering <olaf@aepfle.de>

The driver is named ibmvscsic, at runtime it its name is advertised as
ibmvscsi. For this reason mkinitrd wont pickup the driver properly.
Reported by IBM during SLES11 beta testing:

https://bugzilla.novell.com/show_bug.cgi?id=459933
LTC50724

Signed-off-by: Olaf Hering <olaf@aepfle.de>

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 3a6c474..e580aa4 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -100,6 +100,9 @@ static struct scsi_transport_template *ibmvscsi_transport_template;
 
 static struct ibmvscsi_ops *ibmvscsi_ops;
 
+/* The driver is named ibmvscsic, map ibmvscsi to module name */
+#define IBMVSCSI_NAME "ibmvscsi"
+MODULE_ALIAS(IBMVSCSI_NAME);
 MODULE_DESCRIPTION("IBM Virtual SCSI");
 MODULE_AUTHOR("Dave Boutcher");
 MODULE_LICENSE("GPL");
@@ -1796,7 +1799,7 @@ static struct device_attribute *ibmvscsi_attrs[] = {
 static struct scsi_host_template driver_template = {
 	.module = THIS_MODULE,
 	.name = "IBM POWER Virtual SCSI Adapter " IBMVSCSI_VERSION,
-	.proc_name = "ibmvscsi",
+	.proc_name = IBMVSCSI_NAME,
 	.queuecommand = ibmvscsi_queuecommand,
 	.eh_abort_handler = ibmvscsi_eh_abort_handler,
 	.eh_device_reset_handler = ibmvscsi_eh_device_reset_handler,
@@ -1936,7 +1939,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	}
 
 	hostdata->work_thread = kthread_run(ibmvscsi_work, hostdata, "%s_%d",
-					    "ibmvscsi", host->host_no);
+					    IBMVSCSI_NAME, host->host_no);
 
 	if (IS_ERR(hostdata->work_thread)) {
 		dev_err(&vdev->dev, "couldn't initialize kthread. rc=%ld\n",
@@ -2061,7 +2064,7 @@ static struct vio_driver ibmvscsi_driver = {
 	.probe = ibmvscsi_probe,
 	.remove = ibmvscsi_remove,
 	.get_desired_dma = ibmvscsi_get_desired_dma,
-	.name = "ibmvscsi",
+	.name = IBMVSCSI_NAME,
 	.pm = &ibmvscsi_pm_ops,
 };
 
-- 
1.7.10.4

