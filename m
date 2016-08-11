From: tom.ty89@gmail.com
Subject: [RFC] sd: dynamically adjust SD_MAX_WS16_BLOCKS as per the actual logical block size
Date: Fri, 12 Aug 2016 06:29:43 +0800
Message-ID: <b7f44789e0e68fa57d2e3cd059ac3a5bc6d53495.1470954520.git.tom.ty89@gmail.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: martin.petersen@oracle.com, shaun@tancheff.com
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, shaun.tancheff@seagate.com, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

WRITE SAME (16) command can technically handle up to 32-bit
number of blocks. However, since 32-bit is also the limitation of
the maximum number of bytes that can be represented in the block
layer, the current SD_MAX_WS16_BLOCKS was hence derived from the
technical limit devided by 512.

However, SD_MAX_WS16_BLOCKS is used to check values that are, for
example, orignated from Maximum Write Same Length field on the
Block Limit VPD. Such field expresses the number of blocks in
terms of the actual logical sector size of the specific drive
instead of the block size that the block layer is based on (512).

Therefore, the original hack would work fine for drives with
512-byte logical sectors. However, for drives with larger logical
sector size (e.g. AF 4Kn drives), the hack would be in vain.

So let's bump the macro set in sd.h back to the technical limit,
and adjust it as per the actual logical block size when it is used.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d3e852a..601afd6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -452,6 +452,8 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct scsi_device *sdp = sdkp->device;
+	unsigned int logical_block_size = sdp->sector_size;
+	unsigned int max_ws16_blocks = SD_MAX_WS16_BLOCKS / logical_block_size;
 	unsigned long max;
 	int err;
 
@@ -468,7 +470,7 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
 
 	if (max == 0)
 		sdp->no_write_same = 1;
-	else if (max <= SD_MAX_WS16_BLOCKS) {
+	else if (max <= max_ws16_blocks) {
 		sdp->no_write_same = 0;
 		sdkp->max_ws_blocks = max;
 	}
@@ -635,6 +637,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 {
 	struct request_queue *q = sdkp->disk->queue;
 	unsigned int logical_block_size = sdkp->device->sector_size;
+	unsigned int max_ws16_blocks = SD_MAX_WS16_BLOCKS / logical_block_size;
 	unsigned int max_blocks = 0;
 
 	q->limits.discard_zeroes_data = 0;
@@ -668,12 +671,12 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 
 	case SD_LBP_UNMAP:
 		max_blocks = min_not_zero(sdkp->max_unmap_blocks,
-					  (u32)SD_MAX_WS16_BLOCKS);
+					  (u32)max_ws16_blocks);
 		break;
 
 	case SD_LBP_WS16:
 		max_blocks = min_not_zero(sdkp->max_ws_blocks,
-					  (u32)SD_MAX_WS16_BLOCKS);
+					  (u32)max_ws16_blocks);
 		q->limits.discard_zeroes_data = sdkp->lbprz;
 		break;
 
@@ -793,6 +796,7 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 {
 	struct request_queue *q = sdkp->disk->queue;
 	unsigned int logical_block_size = sdkp->device->sector_size;
+	unsigned int max_ws16_blocks = SD_MAX_WS16_BLOCKS / logical_block_size;
 
 	if (sdkp->device->no_write_same) {
 		sdkp->max_ws_blocks = 0;
@@ -806,7 +810,7 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 	 */
 	if (sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS)
 		sdkp->max_ws_blocks = min_not_zero(sdkp->max_ws_blocks,
-						   (u32)SD_MAX_WS16_BLOCKS);
+						   (u32)max_ws16_blocks);
 	else if (sdkp->ws16 || sdkp->ws10 || sdkp->device->no_report_opcodes)
 		sdkp->max_ws_blocks = min_not_zero(sdkp->max_ws_blocks,
 						   (u32)SD_MAX_WS10_BLOCKS);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 765a6f1..56ff88c 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -47,7 +47,7 @@ enum {
 	SD_DEF_XFER_BLOCKS = 0xffff,
 	SD_MAX_XFER_BLOCKS = 0xffffffff,
 	SD_MAX_WS10_BLOCKS = 0xffff,
-	SD_MAX_WS16_BLOCKS = 0x7fffff,
+	SD_MAX_WS16_BLOCKS = 0xffffffff,
 };
 
 enum {
-- 
2.9.2

