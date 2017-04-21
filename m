From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 3/4] sd: Make synchronize cache upon shutdown asynchronous
Date: Fri, 21 Apr 2017 14:26:35 -0700
Message-ID: <20170421212636.14376-4-bart.vanassche@sandisk.com>
References: <20170421212636.14376-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:50048 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422806AbdDUV0y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 17:26:54 -0400
In-Reply-To: <20170421212636.14376-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Hannes Reinecke <hare@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, Song Liu <songliubraving@fb.com>

This patch avoids that sd_shutdown() hangs on the SYNCHRONIZE CACHE
command if the block layer queue has been stopped by
scsi_target_block().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Israel Rukshin <israelr@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: Song Liu <songliubraving@fb.com>
---
 drivers/scsi/sd.c | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fe0f7997074e..354ec47584fe 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1489,6 +1489,27 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	return retval;
 }
 
+static void sd_sync_cache_done(struct request *rq, int e)
+{
+	blk_put_request(rq);
+}
+
+/*
+ * Issue a SYNCHRONIZE CACHE command asynchronously. Since blk_cleanup_queue()
+ * waits for all commands to finish, __scsi_remove_device() will wait for the
+ * SYNCHRONIZE CACHE command to finish.
+ */
+static int sd_sync_cache_async(struct scsi_disk *sdkp)
+{
+	const struct scsi_device *sdp = sdkp->device;
+	const int timeout = sdp->request_queue->rq_timeout *
+			    SD_FLUSH_TIMEOUT_MULTIPLIER;
+	const unsigned char cmd[10] = { SYNCHRONIZE_CACHE };
+
+	return scsi_execute_async(sdp, NULL, cmd, DMA_NONE, NULL, 0, timeout,
+				  SD_MAX_RETRIES, 0, 0, sd_sync_cache_done);
+}
+
 static int sd_sync_cache(struct scsi_disk *sdkp)
 {
 	int retries, res;
@@ -3349,13 +3370,15 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 }
 
 /*
- * Send a SYNCHRONIZE CACHE instruction down to the device through
- * the normal SCSI command structure.  Wait for the command to
- * complete.
+ * Send a SYNCHRONIZE CACHE instruction down to the device through the normal
+ * SCSI command structure. When stopping the disk, wait for the command to
+ * complete. When not stopping the disk, the blk_cleanup_queue() call in
+ * __scsi_remove_device() will wait for this command to complete.
  */
 static void sd_shutdown(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	bool stop_disk;
 
 	if (!sdkp)
 		return;         /* this can happen */
@@ -3363,12 +3386,18 @@ static void sd_shutdown(struct device *dev)
 	if (pm_runtime_suspended(dev))
 		return;
 
+	stop_disk = system_state != SYSTEM_RESTART &&
+		sdkp->device->manage_start_stop;
+
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		sd_sync_cache(sdkp);
+		if (stop_disk)
+			sd_sync_cache(sdkp);
+		else
+			sd_sync_cache_async(sdkp);
 	}
 
-	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
+	if (stop_disk) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
-- 
2.12.2
