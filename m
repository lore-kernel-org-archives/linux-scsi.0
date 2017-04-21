From: Song Liu <songliubraving@fb.com>
Subject: [RFC] scsi: reduce protection of scan_mutex in scsi_remove_device
Date: Fri, 21 Apr 2017 14:13:02 -0700
Message-ID: <20170421211302.2667649-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48941 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1042338AbdDUVNR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Apr 2017 17:13:17 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3LLDGiu011750
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2017 14:13:16 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 29ysarr3c1-5
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2017 14:13:16 -0700
Received: from facebook.com (2401:db00:2120:20f2:face:0:9:0)    by
 mx-out.facebook.com (10.102.107.97) with ESMTP id
 527a777026d711e7bc070002c99331b0-295f99a0 for <linux-scsi@vger.kernel.org>;
        Fri, 21 Apr 2017 14:13:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, Bart.VanAssche@sandisk.com, Song Liu <songliubraving@fb.com>

When a device is deleted through sysfs handle "delete", the code
locks shost->scan_mutex. If multiple devices are deleted at the
same time, these deletes will be handled in series.

On the other hand, some devices do long latency IO during deletion,
for example, sd_shutdown() may do sync cache and/or start_stop.
It is not necessary for these commands to run in series.

To reduce latency of parallel "delete" requests, this patch reduces
the protection of scan_mutex. The only function with Scsi_Host
called in __scsi_remove_device() is the optional slave_destroy().
Therefore, the protection of scan_mutex is only necessary for this
function.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/scsi/scsi_sysfs.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 82dfe07..e7a9e28 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -610,7 +610,7 @@ static int scsi_sdev_check_buf_bit(const char *buf)
 			return 1;
 		else if (buf[0] == '0')
 			return 0;
-		else 
+		else
 			return -EINVAL;
 	} else
 		return -EINVAL;
@@ -774,7 +774,7 @@ store_queue_type_field(struct device *dev, struct device_attribute *attr,
 
 	if (!sdev->tagged_supported)
 		return -EINVAL;
-		
+
 	sdev_printk(KERN_INFO, sdev,
 		    "ignoring write to deprecated queue_type attribute");
 	return count;
@@ -1302,8 +1302,11 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
-	if (sdev->host->hostt->slave_destroy)
+	if (sdev->host->hostt->slave_destroy) {
+		mutex_lock(&sdev->host->scan_mutex);
 		sdev->host->hostt->slave_destroy(sdev);
+		mutex_unlock(&sdev->host->scan_mutex);
+	}
 	transport_destroy_device(dev);
 
 	/*
@@ -1322,11 +1325,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
  **/
 void scsi_remove_device(struct scsi_device *sdev)
 {
-	struct Scsi_Host *shost = sdev->host;
-
-	mutex_lock(&shost->scan_mutex);
 	__scsi_remove_device(sdev);
-	mutex_unlock(&shost->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_remove_device);
 
-- 
2.9.3
