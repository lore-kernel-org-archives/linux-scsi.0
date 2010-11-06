From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix put operation on scsi device in scsi scan
Date: Sat, 6 Nov 2010 19:55:38 +0800
Message-ID: <AANLkTi=5sK0jbiVZHsHmMj+kKZXVZebTZGtTbeyf+y5F@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49554 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab0KFLzk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Nov 2010 07:55:40 -0400
Received: by wwb39 with SMTP id 39so2296996wwb.1
        for <linux-scsi@vger.kernel.org>; Sat, 06 Nov 2010 04:55:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

After lookup, that sdev is put opens the time window in which
subsequent operations on sdev are based upon no reliability until get
operation is issued.

The window is closed in this work by deferring the put operation until
necessary.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_scan.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/scsi_scan.c	2010-11-06 19:23:30.000000000 +0800
@@ -1006,7 +1006,7 @@ static int scsi_probe_and_add_lun(struct
 				  struct scsi_device **sdevp, int rescan,
 				  void *hostdata)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *found;
 	unsigned char *result;
 	int bflags, res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -1015,7 +1015,7 @@ static int scsi_probe_and_add_lun(struct
 	 * The rescan flag is used as an optimization, the first scan of a
 	 * host adapter calls into here with rescan == 0.
 	 */
-	sdev = scsi_device_lookup_by_target(starget, lun);
+	found = sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
 		if (rescan || !scsi_device_created(sdev)) {
 			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
@@ -1032,7 +1032,6 @@ static int scsi_probe_and_add_lun(struct
 								 sdev->model);
 			return SCSI_SCAN_LUN_PRESENT;
 		}
-		scsi_device_put(sdev);
 	} else
 		sdev = scsi_alloc_sdev(starget, lun, hostdata);
 	if (!sdev)
@@ -1125,15 +1124,22 @@ static int scsi_probe_and_add_lun(struct
  out_free_sdev:
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (sdevp) {
-			if (scsi_device_get(sdev) == 0) {
+			if (found)
+				*sdevp = found;
+			else if (scsi_device_get(sdev) == 0) {
 				*sdevp = sdev;
 			} else {
 				__scsi_remove_device(sdev);
 				res = SCSI_SCAN_NO_RESPONSE;
 			}
-		}
-	} else
-		__scsi_remove_device(sdev);
+		} else if (found)
+			scsi_device_put(found);
+	} else {
+		if (found)
+			scsi_device_put(found);
+		else
+			__scsi_remove_device(sdev);
+	}
  out:
 	return res;
 }
