From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sd: fixup capacity calculation for 4k drives
Date: Tue, 29 Mar 2016 10:06:55 +0200
Message-ID: <1459238815-15053-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbcC2IG7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2016 04:06:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

in sd_read_capacity() the sdkp->capacity field changes its meaning:
after the call to read_capacity_XX() it carries the _unscaled_ values,
making the comparison between the original value and the new value
always false for drives with a sector size != 512.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 69 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 39 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5a5457a..0afe113 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2046,7 +2046,7 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 #define READ_CAPACITY_RETRIES_ON_RESET	10
 
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
-						unsigned char *buffer)
+			    unsigned char *buffer, u64 *capacity)
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
@@ -2054,8 +2054,8 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	int the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
-	unsigned long long lba;
-	unsigned sector_size;
+	u64 lba;
+	u32 sector_size;
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
@@ -2114,7 +2114,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
 			"devices.\n");
-		sdkp->capacity = 0;
+		*capacity = 0;
 		return -EOVERFLOW;
 	}
 
@@ -2137,20 +2137,20 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		sd_config_discard(sdkp, SD_LBP_WS16);
 	}
 
-	sdkp->capacity = lba + 1;
+	*capacity = lba + 1;
 	return sector_size;
 }
 
 static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
-						unsigned char *buffer)
+			    unsigned char *buffer, u64 *capacity)
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
-	sector_t lba;
-	unsigned sector_size;
+	u32 lba;
+	u32 sector_size;
 
 	do {
 		cmd[0] = READ_CAPACITY;
@@ -2191,7 +2191,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		/* Some buggy (usb cardreader) devices return an lba of
 		   0xffffffff when the want to report a size of 0 (with
 		   which they really mean no media is present) */
-		sdkp->capacity = 0;
+		*capacity = 0;
 		sdkp->physical_block_size = sector_size;
 		return sector_size;
 	}
@@ -2200,11 +2200,11 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
 			"devices.\n");
-		sdkp->capacity = 0;
+		*capacity = 0;
 		return -EOVERFLOW;
 	}
 
-	sdkp->capacity = lba + 1;
+	*capacity = (u64)lba + 1;
 	sdkp->physical_block_size = sector_size;
 	return sector_size;
 }
@@ -2230,34 +2230,38 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	int sector_size;
 	struct scsi_device *sdp = sdkp->device;
-	sector_t old_capacity = sdkp->capacity;
+	u64 old_capacity = sdkp->capacity, new_capacity;
 
 	if (sd_try_rc16_first(sdp)) {
-		sector_size = read_capacity_16(sdkp, sdp, buffer);
+		sector_size = read_capacity_16(sdkp, sdp, buffer,
+					       &new_capacity);
 		if (sector_size == -EOVERFLOW)
 			goto got_data;
 		if (sector_size == -ENODEV)
 			return;
 		if (sector_size < 0)
-			sector_size = read_capacity_10(sdkp, sdp, buffer);
+			sector_size = read_capacity_10(sdkp, sdp, buffer,
+						       &new_capacity);
 		if (sector_size < 0)
 			return;
 	} else {
-		sector_size = read_capacity_10(sdkp, sdp, buffer);
+		sector_size = read_capacity_10(sdkp, sdp, buffer,
+					       &new_capacity);
 		if (sector_size == -EOVERFLOW)
 			goto got_data;
 		if (sector_size < 0)
 			return;
 		if ((sizeof(sdkp->capacity) > 4) &&
-		    (sdkp->capacity > 0xffffffffULL)) {
+		    (new_capacity > 0xffffffffULL)) {
 			int old_sector_size = sector_size;
 			sd_printk(KERN_NOTICE, sdkp, "Very big device. "
 					"Trying to use READ CAPACITY(16).\n");
-			sector_size = read_capacity_16(sdkp, sdp, buffer);
+			sector_size = read_capacity_16(sdkp, sdp, buffer,
+						       &new_capacity);
 			if (sector_size < 0) {
 				sd_printk(KERN_NOTICE, sdkp,
 					"Using 0xffffffff as device size\n");
-				sdkp->capacity = 1 + (sector_t) 0xffffffff;
+				new_capacity = 1 + (u64) 0xffffffff;
 				sector_size = old_sector_size;
 				goto got_data;
 			}
@@ -2275,11 +2279,11 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 	 * the capacity.
 	 */
 	if (sdp->fix_capacity ||
-	    (sdp->guess_capacity && (sdkp->capacity & 0x01))) {
+	    (sdp->guess_capacity && (new_capacity & 0x01))) {
 		sd_printk(KERN_INFO, sdkp, "Adjusting the sector count "
 				"from its reported value: %llu\n",
-				(unsigned long long) sdkp->capacity);
-		--sdkp->capacity;
+				(unsigned long long) new_capacity);
+		--new_capacity;
 	}
 
 got_data:
@@ -2301,7 +2305,7 @@ got_data:
 		 * would be relatively trivial to set the thing up.
 		 * For this reason, we leave the thing in the table.
 		 */
-		sdkp->capacity = 0;
+		new_capacity = 0;
 		/*
 		 * set a bogus sector size so the normal read/write
 		 * logic in the block layer will eventually refuse any
@@ -2312,6 +2316,19 @@ got_data:
 	}
 	blk_queue_logical_block_size(sdp->request_queue, sector_size);
 
+	/*
+	 * Note: up to this point new_capacity carries the
+	 * _unscaled_ capacity. So rescale capacity to 512-byte units.
+	 */
+	if (sector_size == 4096)
+		sdkp->capacity = new_capacity << 3;
+	else if (sector_size == 2048)
+		sdkp->capacity = new_capacity << 2;
+	else if (sector_size == 1024)
+		sdkp->capacity = new_capacity << 1;
+	else
+		sdkp->capacity = new_capacity;
+
 	{
 		char cap_str_2[10], cap_str_10[10];
 
@@ -2337,14 +2354,6 @@ got_data:
 	if (sdkp->capacity > 0xffffffff)
 		sdp->use_16_for_rw = 1;
 
-	/* Rescale capacity to 512-byte units */
-	if (sector_size == 4096)
-		sdkp->capacity <<= 3;
-	else if (sector_size == 2048)
-		sdkp->capacity <<= 2;
-	else if (sector_size == 1024)
-		sdkp->capacity <<= 1;
-
 	blk_queue_physical_block_size(sdp->request_queue,
 				      sdkp->physical_block_size);
 	sdkp->device->sector_size = sector_size;
-- 
1.8.5.6

