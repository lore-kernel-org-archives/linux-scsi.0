From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: sd: Optimal I/O size should be a multiple of physical block size
Date: Fri,  8 Feb 2019 18:41:47 -0500
Message-ID: <20190208234147.1316-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It was reported that some devices report an OPTIMAL TRANSFER LENGTH of
0xFFFF blocks. That looks bogus, especially for a device with a
4096-byte physical block size.

Ignore OPTIMAL TRANSFER LENGTH if it is not a multiple of the device's
reported physical block size.

Cc: <stable@vger.kernel.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199759
Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

Before:

NAME ALIGNMENT MIN-IO   OPT-IO PHY-SEC LOG-SEC ROTA SCHED      RQ-SIZE  RA WSAME
sda          0   4096 33553920    4096     512    0 mq-deadline    256 128   32M

After:

NAME ALIGNMENT MIN-IO OPT-IO PHY-SEC LOG-SEC ROTA SCHED       RQ-SIZE   RA WSAME
sda          0   4096      0    4096     512    0 mq-deadline     256 4096   32M
---
 drivers/scsi/sd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9aa409b38765..d5ede5d65838 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3060,7 +3060,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	struct request_queue *q = sdkp->disk->queue;
 	sector_t old_capacity = sdkp->capacity;
 	unsigned char *buffer;
-	unsigned int dev_max, rw_max;
+	unsigned int dev_max, rw_max, opt_xfer_bytes;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
@@ -3119,13 +3119,16 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 	/*
 	 * Determine the device's preferred I/O size for reads and writes
-	 * unless the reported value is unreasonably small, large, or
-	 * garbage.
+	 * unless the reported value is unreasonably small, large, not a
+	 * multiple of the physical block size, or simply garbage.
 	 */
+	opt_xfer_bytes = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
+
 	if (sdkp->opt_xfer_blocks &&
 	    sdkp->opt_xfer_blocks <= dev_max &&
 	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
-	    logical_to_bytes(sdp, sdkp->opt_xfer_blocks) >= PAGE_SIZE) {
+	    opt_xfer_bytes >= PAGE_SIZE &&
+	    (opt_xfer_bytes & (sdkp->physical_block_size - 1)) != 0) {
 		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
 	} else
-- 
2.19.2
