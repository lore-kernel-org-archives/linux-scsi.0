From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] Alter the scsi_add_device() API to conform to what users
	expect
Date: Sat, 10 Sep 2005 12:44:09 -0500
Message-ID: <1126374249.4813.54.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:47795 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932125AbVIJRoL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 13:44:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: linux1394-devel@lists.sourceforge.net, Stefan Richter <stefanr@s5r6.in-berlin.de>

The original API returned either an ERR_PTR() or a refcounted sdev.
Unfortunately, if it's successful, you need to do a scsi_device_put() on
the sdev otherwise the refcounting is wrong.

Everyone seems to expect that scsi_add_device() should be callable
without doing the ref put, so alter the API so it is (we still have
__scsi_add_device with the original behaviour).

The only actual caller that needs altering is the one in firewire ...
not because it gets this right, but because it acts on the error if one
is returned.

James

diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -790,7 +790,7 @@ static void sbp2_host_reset(struct hpsb_
 static int sbp2_start_device(struct scsi_id_instance_data *scsi_id)
 {
 	struct sbp2scsi_host_info *hi = scsi_id->hi;
-	struct scsi_device *sdev;
+	int error;
 
 	SBP2_DEBUG("sbp2_start_device");
 
@@ -939,10 +939,10 @@ alloc_fail:
 	sbp2_max_speed_and_size(scsi_id);
 
 	/* Add this device to the scsi layer now */
-	sdev = scsi_add_device(scsi_id->scsi_host, 0, scsi_id->ud->id, 0);
-	if (IS_ERR(sdev)) {
+	error = scsi_add_device(scsi_id->scsi_host, 0, scsi_id->ud->id, 0);
+	if (error) {
 		SBP2_ERR("scsi_add_device failed");
-		return PTR_ERR(sdev);
+		return error;
 	}
 
 	return 0;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1264,6 +1264,19 @@ struct scsi_device *__scsi_add_device(st
 }
 EXPORT_SYMBOL(__scsi_add_device);
 
+int scsi_add_device(struct Scsi_Host *host, uint channel,
+		    uint target, uint lun)
+{
+	struct scsi_device *sdev = 
+		__scsi_add_device(host, channel, target, lun, NULL);
+	if (IS_ERR(sdev))
+		return PTR_ERR(sdev);
+
+	scsi_device_put(sdev);
+	return 0;
+}
+EXPORT_SYMBOL(scsi_add_device);
+
 void scsi_rescan_device(struct device *dev)
 {
 	struct scsi_driver *drv;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -178,8 +178,8 @@ static inline struct scsi_target *scsi_t
 
 extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
 		uint, uint, uint, void *hostdata);
-#define scsi_add_device(host, channel, target, lun) \
-	__scsi_add_device(host, channel, target, lun, NULL)
+extern int scsi_add_device(struct Scsi_Host *host, uint channel,
+			   uint target, uint lun);
 extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_device_cancel(struct scsi_device *, int);
 


