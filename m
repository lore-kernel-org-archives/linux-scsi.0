From: Fam Zheng <famz@redhat.com>
Subject: [PATCH 2/3] sd: Return error in sd_revalidate_disk if read capacity failed
Date: Tue, 24 Mar 2015 18:16:14 +0800
Message-ID: <1427192175-23802-3-git-send-email-famz@redhat.com>
References: <1427192175-23802-1-git-send-email-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427192175-23802-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, famz@redhat.com
List-Id: linux-scsi@vger.kernel.org

When the read capacity commands failed, we should return an error to
caller instead of silently continuing as normal.

Most importantly, this fixes the error code of BLKRRPART ioctl. Also if
the device is down, the following commands also likely to time
out, and we could waste more time than necessary.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 drivers/scsi/sd.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6b78476..7e5ca3b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -113,7 +113,7 @@ static int sd_init_command(struct scsi_cmnd *SCpnt);
 static void sd_uninit_command(struct scsi_cmnd *SCpnt);
 static int sd_done(struct scsi_cmnd *);
 static int sd_eh_action(struct scsi_cmnd *, int);
-static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
+static int sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(const struct scsi_disk *, const char *, int);
@@ -2145,7 +2145,7 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
 /*
  * read disk capacity
  */
-static void
+static int
 sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	int sector_size;
@@ -2157,17 +2157,17 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 		if (sector_size == -EOVERFLOW)
 			goto got_data;
 		if (sector_size == -ENODEV)
-			return;
+			return -ENODEV;
 		if (sector_size < 0)
 			sector_size = read_capacity_10(sdkp, sdp, buffer);
 		if (sector_size < 0)
-			return;
+			return sector_size;
 	} else {
 		sector_size = read_capacity_10(sdkp, sdp, buffer);
 		if (sector_size == -EOVERFLOW)
 			goto got_data;
 		if (sector_size < 0)
-			return;
+			return sector_size;
 		if ((sizeof(sdkp->capacity) > 4) &&
 		    (sdkp->capacity > 0xffffffffULL)) {
 			int old_sector_size = sector_size;
@@ -2274,6 +2274,7 @@ got_data:
 	blk_queue_physical_block_size(sdp->request_queue,
 				      sdkp->physical_block_size);
 	sdkp->device->sector_size = sector_size;
+	return 0;
 }
 
 /* called with buffer of length 512 */
@@ -2753,6 +2754,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	struct scsi_device *sdp = sdkp->device;
 	unsigned char *buffer;
 	unsigned int max_xfer;
+	int ret = 0;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
@@ -2778,7 +2780,9 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 * react badly if we do.
 	 */
 	if (sdkp->media_present) {
-		sd_read_capacity(sdkp, buffer);
+		ret = sd_read_capacity(sdkp, buffer);
+		if (ret)
+			goto out;
 
 		if (sd_try_extended_inquiry(sdp)) {
 			sd_read_block_provisioning(sdkp);
@@ -2811,7 +2815,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	kfree(buffer);
 
  out:
-	return 0;
+	return ret;
 }
 
 /**
-- 
1.9.3
