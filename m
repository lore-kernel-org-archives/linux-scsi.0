From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 7/11] Implement scsi_configure_device()
Date: Mon, 18 Jun 2007 11:02:00 +0200
Message-ID: <20070618090200.88566D44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:56584 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983AbXFRJCB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jun 2007 05:02:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


This patch implements scsi_configure_device(). This function
elevates an sdev into SDEV_RUNNING and configures it properly so that
I/O is possible on the device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c |   67 +++++++++++++++++++++++++++++++++------------
 1 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 9195ffb..d1bca80 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -698,6 +698,43 @@ static int scsi_probe_lun(struct scsi_de
 }
 
 /**
+ * scsi_configure_device - configure a scsi_device
+ * @sdev:	The scsi_device to configure
+ *
+ * Description:
+ *    Configure an existing scsi_device. This function
+ *    elevates a scsi_device from state SDEV_CREATED or
+ *    SDEV_CANCEL into SDEV_RUNNING.
+ *
+ *    On failure the device is put into SDEV_CANCEL.
+ *
+ * Return:
+ *    0  On Success
+ *    <0 On failure.
+ *
+ **/
+int scsi_configure_device(struct scsi_device *sdev)
+{
+	int ret = 0;
+
+	/* set the device running here so that slave configure
+	 * may do I/O */
+	if (scsi_device_set_state(sdev, SDEV_RUNNING) != 0)
+		return -EBUSY;
+
+	transport_configure_device(&sdev->sdev_gendev);
+
+	if (sdev->host->hostt->slave_configure)
+		ret = sdev->host->hostt->slave_configure(sdev);
+
+	/* slave configure failed, device is not useable */
+	if (ret)
+		scsi_device_set_state(sdev, SDEV_CANCEL);
+
+	return ret;
+}
+
+/**
  * scsi_add_lun - allocate and fully initialze a scsi_device
  * @sdevscan:	holds information to be stored in the new scsi_device
  * @sdevnew:	store the address of the newly allocated scsi_device
@@ -717,6 +754,8 @@ static int scsi_probe_lun(struct scsi_de
 static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		int *bflags, int async)
 {
+	int ret;
+
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
 	 * save just vendor/model/rev.
@@ -880,10 +919,6 @@ static int scsi_add_lun(struct scsi_devi
 	if (*bflags & BLIST_USE_10_BYTE_MS)
 		sdev->use_10_for_ms = 1;
 
-	/* set the device running here so that slave configure
-	 * may do I/O */
-	scsi_device_set_state(sdev, SDEV_RUNNING);
-
 	if (*bflags & BLIST_MS_192_BYTES_FOR_3F)
 		sdev->use_192_bytes_for_3f = 1;
 
@@ -893,21 +928,17 @@ static int scsi_add_lun(struct scsi_devi
 	if (*bflags & BLIST_RETRY_HWERROR)
 		sdev->retry_hwerror = 1;
 
-	transport_configure_device(&sdev->sdev_gendev);
-
-	if (sdev->host->hostt->slave_configure) {
-		int ret = sdev->host->hostt->slave_configure(sdev);
-		if (ret) {
-			/*
-			 * if LLDD reports slave not present, don't clutter
-			 * console with alloc failure messages
-			 */
-			if (ret != -ENXIO) {
-				sdev_printk(KERN_ERR, sdev,
-					"failed to configure device\n");
-			}
-			return SCSI_SCAN_NO_RESPONSE;
+	ret = scsi_configure_device(sdev);
+	if (ret) {
+		/*
+		 * if LLDD reports slave not present, don't clutter
+		 * console with alloc failure messages
+		 */
+		if (ret != -ENXIO) {
+			sdev_printk(KERN_ERR, sdev,
+				    "failed to configure device\n");
 		}
+		return SCSI_SCAN_NO_RESPONSE;
 	}
 
 	/*
-- 
1.4.3.4

