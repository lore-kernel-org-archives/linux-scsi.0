From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v4] scsi/sd: release scan_mutex during sync_cache and start_stop
Date: Wed, 8 Feb 2017 17:01:16 -0800
Message-ID: <20170209010116.362206-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60066 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751317AbdBIBBV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 20:01:21 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v190xljp009657
        for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2017 17:01:20 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 28g8avhdrj-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 17:01:20 -0800
Received: from facebook.com (2401:db00:11:d0be:face:0:17:0)     by
 mx-out.facebook.com (10.212.232.63) with ESMTP id
 43f026f2ee6311e6adea0002c992ebde-295eaa00 for <linux-scsi@vger.kernel.org>;
        Wed, 08 Feb 2017 17:01:19 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bart.vanassche@sandisk.com, hch@lst.de, hch@infradead.org, Song Liu <songliubraving@fb.com>

When a device is deleted through sysfs handle "delete", the code
locks shost->scan_mutex. If multiple devices are deleted at the
same time, these deletes will be handled in series.

On the other hand, sd_shutdown() sometimes issues long latency
commands: sync cache and start_stop. It is not necessary for these
commands to run in series.

To reduce latency of parallel "delete" requests, this patch unlock
shost->scan_mutex before calling sd_shutdown(), relock the mutex
afterwards.

Fixed bug from previous version.

Reported-by: kernel test robot <fengguang.wu@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/scsi/sd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9e0783b..61ea308 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3211,9 +3211,13 @@ static int sd_probe(struct device *dev)
 static int sd_remove(struct device *dev)
 {
 	struct scsi_disk *sdkp;
+	struct scsi_device *sdev;
+	struct Scsi_Host *shost;
 	dev_t devt;
 
 	sdkp = dev_get_drvdata(dev);
+	sdev = sdkp->device;
+	shost = sdev->host;
 	devt = disk_devt(sdkp->disk);
 	scsi_autopm_get_device(sdkp->device);
 
@@ -3221,7 +3225,9 @@ static int sd_remove(struct device *dev)
 	async_synchronize_full_domain(&scsi_sd_probe_domain);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
+	mutex_unlock(&shost->scan_mutex);
 	sd_shutdown(dev);
+	mutex_lock(&shost->scan_mutex);
 
 	sd_zbc_remove(sdkp);
 
-- 
2.9.3
