From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: [PATCH v2] notify block layer when using temporary change to cache_type
Date: Tue,  3 Jun 2014 17:37:30 +0800
Message-ID: <1401788250-8457-1-git-send-email-vaughan.cao@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41695 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaFCJhf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2014 05:37:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vaughan.cao@oracle.com

This is a fix for commit:
  39c60a0948cc06139e2fbfe084f83cb7e7deae3b sd: fix array cache flushing bug causing performance problems
We must notify the block layer via q->flush_flags after temporary change the cache_type to write through.
If not, SYNCHRONIZE CACHE command will still be generated.
This patch factors out a helper that can be called from sd_revalidate_disk and cache_type_store.

Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
---
 drivers/scsi/sd.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index efcbcd1..e4774aa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -132,6 +132,19 @@ static const char *sd_cache_types[] = {
 	"write back, no read (daft)"
 };
 
+static void sd_set_flush_flag(struct scsi_disk *sdkp)
+{
+	unsigned flush = 0;
+
+	if (sdkp->WCE) {
+		flush |= REQ_FLUSH;
+		if (sdkp->DPOFUA)
+			flush |= REQ_FUA;
+	}
+
+	blk_queue_flush(sdkp->disk->queue, flush);
+}
+
 static ssize_t
 cache_type_store(struct device *dev, struct device_attribute *attr,
 		 const char *buf, size_t count)
@@ -175,6 +188,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	if (sdkp->cache_override) {
 		sdkp->WCE = wce;
 		sdkp->RCD = rcd;
+		sd_set_flush_flag(sdkp);
 		return count;
 	}
 
@@ -2712,7 +2726,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
 	unsigned char *buffer;
-	unsigned flush = 0;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
@@ -2758,13 +2771,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 * We now have all cache related info, determine how we deal
 	 * with flush requests.
 	 */
-	if (sdkp->WCE) {
-		flush |= REQ_FLUSH;
-		if (sdkp->DPOFUA)
-			flush |= REQ_FUA;
-	}
-
-	blk_queue_flush(sdkp->disk->queue, flush);
+	sd_set_flush_flag(sdkp);
 
 	set_capacity(disk, sdkp->capacity);
 	sd_config_write_same(sdkp);
-- 
1.9.0

