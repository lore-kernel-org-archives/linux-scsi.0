From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 3/4] sd: Make synchronize cache upon shutdown asynchronous
Date: Mon, 10 Apr 2017 10:54:01 -0700
Message-ID: <20170410175402.9003-4-bart.vanassche@sandisk.com>
References: <20170410175402.9003-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:48433 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753376AbdDJRyL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2017 13:54:11 -0400
In-Reply-To: <20170410175402.9003-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Hannes Reinecke <hare@suse.de>

This patch avoids that sd_shutdown() hangs on the SYNCHRONIZE CACHE
command if the block layer queue has been stopped by
scsi_target_block().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Israel Rukshin <israelr@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fe0f7997074e..8e98b7684893 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1489,6 +1489,22 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	return retval;
 }
 
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
+	return scsi_execute_async(sdp, cmd, DMA_NONE, NULL, 0, timeout,
+				  SD_MAX_RETRIES, 0, 0);
+}
+
 static int sd_sync_cache(struct scsi_disk *sdkp)
 {
 	int retries, res;
@@ -3356,6 +3372,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 static void sd_shutdown(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	const bool stop_disk = system_state != SYSTEM_RESTART &&
+		sdkp->device->manage_start_stop;
 
 	if (!sdkp)
 		return;         /* this can happen */
@@ -3365,10 +3383,13 @@ static void sd_shutdown(struct device *dev)
 
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
2.12.0
