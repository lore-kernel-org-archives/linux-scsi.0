From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] scsi/sd: release scan_mutex during sync_cache and start_stop
Date: Tue, 7 Feb 2017 21:41:06 -0800
Message-ID: <20170208054106.2156053-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37912 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932093AbdBHGiH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 01:38:07 -0500
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v185cw0K017361
        for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2017 21:41:16 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 28fjcwj4te-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 07 Feb 2017 21:41:16 -0800
Received: from facebook.com (2401:db00:11:d0be:face:0:17:0)     by
 mx-out.facebook.com (10.212.232.59) with ESMTP id
 348f28aeedc111e6999f0002c991e86a-b81f5a50 for <linux-scsi@vger.kernel.org>;
        Tue, 07 Feb 2017 21:41:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>

When a device is deleted through sysfs handle "delete", the code
locks shost->scan_mutex. If multiple devices are deleted at the
same time, these deletes will be handled in series.

On the other hand, sd_shutdown() sometimes issues long latency
commands: sync cache and start_stop. It is not necessary for these
commands to run in series.

To reduce latency of parallel "delete" requests, this patch unlock
shost->scan_mutex before long latency commands and relock the mutex
after the command.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/scsi/sd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2ea3568..39aa209 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3241,6 +3241,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 static void sd_shutdown(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct scsi_device *sdev = sdkp->device;
+	struct Scsi_Host *shost = sdev->host;
 
 	if (!sdkp)
 		return;         /* this can happen */
@@ -3249,13 +3251,17 @@ static void sd_shutdown(struct device *dev)
 		return;
 
 	if (sdkp->WCE && sdkp->media_present) {
+		mutex_unlock(&shost->scan_mutex);
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		sd_sync_cache(sdkp);
+		mutex_lock(&shost->scan_mutex);
 	}
 
 	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
+		mutex_unlock(&shost->scan_mutex);
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
+		mutex_lock(&shost->scan_mutex);
 	}
 }
 
-- 
2.9.3
