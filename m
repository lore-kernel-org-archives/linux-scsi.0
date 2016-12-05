From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH] sd: make ->no_write_same independent of reported ->max_ws_blocks
Date: Tue,  6 Dec 2016 00:56:38 +0100
Message-ID: <20161205235638.11539-1-nicstange@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Chaitanya Kulkarni <chaitanya.kulkarni@hgst.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Due to reported problems with Write Same on ATA devices,
commit 0ce1b18c42a5 ("libata: Some drives failing on SCT Write Same")
strived to report non-support for Write Same on non-zoned ATA devices.

However, due to the following control flow in sd_config_write_same() this
doesn't always take effect, namely if the ->max_ws_blocks as set in the
by the ATA Identify Device exceeds SD_WS10_BLOCKS:

  if (sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS)
    [...]
  else if (sdkp->ws16 || sdkp->ws10 || sdkp->device->no_report_opcodes)
    [...]
  else {
    sdkp->device->no_write_same = 1;
    sdkp->max_ws_blocks = 0;
  }

Since commit e73c23ff736e ("block: add async variant of
blkdev_issue_zeroout"), blkdev_issue_zeroout() got a little bit more
sensitive towards failing Write Sames on devices that claim to support them
and this results in messages like

  EXT4-fs (dm-1): Delayed block allocation failed for inode 2625094 at
                  logical offset 2032 with max blocks 2 with error 121
  EXT4-fs (dm-1): This should not happen!! Data will be lost

The block limits VPD page of the device in question quotes a value of
0x3fffc0 > 0xffff == SD_MAX_WS10_BLOCKS for the device in question.

The error code 121 is EREMOTEIO which gets asserted by scsi_io_completion()
in case of invalid requests due to invalid command opcodes.

Fix this by doing the sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS handling
only if some kind of Write Same support is reported, i.e. only if
  sdkp->ws16 || sdkp->ws10 || sdkp->device->no_report_opcodes
holds. Let the handling code for the non-support case thus take effect,
if needed.

Fixes: e73c23ff736e ("block: add async variant of blkdev_issue_zeroout")
Fixes: 0ce1b18c42a5 ("libata: Some drives failing on SCT Write Same")
Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
Applicable to next-20161202.

 drivers/scsi/sd.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2cfeb3c..ef1bab5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -806,18 +806,21 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 		goto out;
 	}
 
-	/* Some devices can not handle block counts above 0xffff despite
-	 * supporting WRITE SAME(16). Consequently we default to 64k
-	 * blocks per I/O unless the device explicitly advertises a
-	 * bigger limit.
-	 */
-	if (sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS)
-		sdkp->max_ws_blocks = min_not_zero(sdkp->max_ws_blocks,
-						   (u32)SD_MAX_WS16_BLOCKS);
-	else if (sdkp->ws16 || sdkp->ws10 || sdkp->device->no_report_opcodes)
-		sdkp->max_ws_blocks = min_not_zero(sdkp->max_ws_blocks,
-						   (u32)SD_MAX_WS10_BLOCKS);
-	else {
+	if (sdkp->ws16 || sdkp->ws10 || sdkp->device->no_report_opcodes) {
+		/*
+		 * Some devices can not handle block counts above 0xffff despite
+		 * supporting WRITE SAME(16). Consequently we default to 64k
+		 * blocks per I/O unless the device explicitly advertises a
+		 * bigger limit.
+		 */
+		if (sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS) {
+			sdkp->max_ws_blocks = min_not_zero(sdkp->max_ws_blocks,
+						(u32)SD_MAX_WS16_BLOCKS);
+		} else {
+			sdkp->max_ws_blocks = min_not_zero(sdkp->max_ws_blocks,
+						(u32)SD_MAX_WS10_BLOCKS);
+		}
+	} else {
 		sdkp->device->no_write_same = 1;
 		sdkp->max_ws_blocks = 0;
 	}
-- 
2.10.2
