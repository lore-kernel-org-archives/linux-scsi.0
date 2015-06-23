From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] sd: Sanity check the optimal I/O size
Date: Tue, 23 Jun 2015 12:22:20 -0400
Message-ID: <1435076541-27253-1-git-send-email-martin.petersen@oracle.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We have come across a couple of devices that report unreasonable values
in the optimal I/O size in the Block Limits VPD page. Since this is a
32-bit entity that gets multiplied by the logical block size we can get
disproportionately large values reported to the block layer.

Cap io_opt at 256 MB.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Chris Friesen <chris.friesen@windriver.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/sd.c | 3 ++-
 drivers/scsi/sd.h | 9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a20da8c25b4f..118b336e0ddf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2560,7 +2560,8 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	blk_queue_io_min(sdkp->disk->queue,
 			 get_unaligned_be16(&buffer[6]) * sector_sz);
 	blk_queue_io_opt(sdkp->disk->queue,
-			 get_unaligned_be32(&buffer[12]) * sector_sz);
+			 min_t(unsigned int, SD_MAX_IO_OPT_BYTES,
+			       get_unaligned_be32(&buffer[12]) * sector_sz));
 
 	if (buffer[3] == 0x3c) {
 		unsigned int lba_count, desc_count;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 63ba5ca7f9a1..f175a3f2944a 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -44,10 +44,11 @@ enum {
 };
 
 enum {
-	SD_DEF_XFER_BLOCKS = 0xffff,
-	SD_MAX_XFER_BLOCKS = 0xffffffff,
-	SD_MAX_WS10_BLOCKS = 0xffff,
-	SD_MAX_WS16_BLOCKS = 0x7fffff,
+	SD_DEF_XFER_BLOCKS	= 0xffff,
+	SD_MAX_XFER_BLOCKS	= 0xffffffff,
+	SD_MAX_WS10_BLOCKS	= 0xffff,
+	SD_MAX_WS16_BLOCKS	= 0x7fffff,
+	SD_MAX_IO_OPT_BYTES	= 256 * 1024 * 1024,
 };
 
 enum {
-- 
2.4.3
