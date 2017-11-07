From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] sd: Fix a disk probing hang
Date: Tue, 7 Nov 2017 09:38:07 -0800
Message-ID: <20171107173807.14396-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:60917 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbdKGRiL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 12:38:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Avoid that disk probing hangs as follows if a SCSI host is removed
after disk scanning started and before it completed:

Call Trace:
 __schedule+0x2fa/0xbb0
 schedule+0x36/0x90
 schedule_timeout+0x22c/0x570
 io_schedule_timeout+0x1e/0x50
 wait_for_completion_io_timeout+0x11f/0x180
 blk_execute_rq+0x86/0xc0
 scsi_execute+0xdb/0x1f0
 sd_revalidate_disk+0xed/0x1c70 [sd_mod]
 sd_probe_async+0xc3/0x1d0 [sd_mod]
 async_run_entry_fn+0x38/0x160
 process_one_work+0x20a/0x660
 worker_thread+0x3d/0x3b0
 kthread+0x13a/0x150
 ret_from_fork+0x27/0x40

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/sd.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0313486d85c8..d5e2b73c02ea 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3225,11 +3225,13 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 {
 	struct scsi_disk *sdkp = data;
 	struct scsi_device *sdp;
+	struct Scsi_Host *host;
 	struct gendisk *gd;
 	u32 index;
 	struct device *dev;
 
 	sdp = sdkp->device;
+	host = sdp->host;
 	gd = sdkp->disk;
 	index = sdkp->index;
 	dev = &sdp->sdev_gendev;
@@ -3253,6 +3255,13 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	sdkp->first_scan = 1;
 	sdkp->max_medium_access_timeouts = SD_MAX_MEDIUM_TIMEOUTS;
 
+	mutex_lock(&host->scan_mutex);
+	if (!scsi_host_scan_allowed(host)) {
+		sd_printk(KERN_NOTICE, sdkp, "%s: host being removed\n",
+			  __func__);
+		goto unlock;
+	}
+
 	sd_revalidate_disk(gd);
 
 	gd->flags = GENHD_FL_EXT_DEVT;
@@ -3276,8 +3285,12 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
+unlock:
+	mutex_unlock(&host->scan_mutex);
+	scsi_host_put(host);
 	scsi_autopm_put_device(sdp);
 	put_device(&sdkp->dev);
+	return;
 }
 
 /**
@@ -3377,7 +3390,15 @@ static int sd_probe(struct device *dev)
 	get_device(dev);
 	dev_set_drvdata(dev, sdkp);
 
-	get_device(&sdkp->dev);	/* prevent release before async_schedule */
+	/* prevent release before async_schedule */
+	error = -ENODEV;
+	if (scsi_host_get(sdp->host) == NULL) {
+		sd_printk(KERN_NOTICE, sdkp, "%s: host being removed\n",
+			  __func__);
+		put_device(&sdkp->dev);
+		goto out;
+	}
+	get_device(&sdkp->dev);
 	async_schedule_domain(sd_probe_async, sdkp, &scsi_sd_probe_domain);
 
 	return 0;
-- 
2.14.3
