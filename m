From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v3] scsi/sd: release scan_mutex during sync_cache and start_stop
Date: Wed, 8 Feb 2017 14:53:53 -0800
Message-ID: <20170208225353.82334-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57299 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751149AbdBHWyq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 17:54:46 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v18MoDok032430
        for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2017 14:54:02 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 28gatc8dtv-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 14:54:02 -0800
Received: from facebook.com (2401:db00:11:d0be:face:0:17:0)     by
 mx-out.facebook.com (10.212.236.89) with ESMTP id
 7b6355b2ee5111e68f980002c95209d8-61f8a00 for <linux-scsi@vger.kernel.org>;
        Wed, 08 Feb 2017 14:54:01 -0800
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

Fixed bug from previous version.

Reported-by: kernel test robot <fengguang.wu@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/scsi/sd.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9e0783b..14c5815 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3304,6 +3304,9 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 static void sd_shutdown(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct scsi_device *sdev;
+	struct Scsi_Host *shost;
+	int try_lock_scan_mutex;
 
 	if (!sdkp)
 		return;         /* this can happen */
@@ -3311,15 +3314,26 @@ static void sd_shutdown(struct device *dev)
 	if (pm_runtime_suspended(dev))
 		return;
 
+	sdev = sdkp->device;
+	shost = sdev->host;
+	try_lock_scan_mutex = mutex_trylock(&shost->scan_mutex);
+
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
+
+	if (try_lock_scan_mutex)
+		mutex_unlock(&shost->scan_mutex);
 }
 
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
-- 
2.9.3
