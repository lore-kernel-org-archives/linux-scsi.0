From: Matthew Wilcox <matthew@wil.cx>
Subject: [RFC] read_capacity rewrite
Date: Thu, 18 Dec 2008 15:52:15 -0700
Message-ID: <20081218225215.GM19967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49167 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbYLRWwc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 17:52:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I found the existing sd_read_capacity() rather tortuous to follow
(backwards gotos?  Just Say No!) so I've rewritten it.  It factors out
the READ CAPACITY 10 and READ CAPACITY 16 paths into their own functions
and then invokes them as needed from sd_read_capacity().

I also added the new algorithm for choosing between RC16 and RC10 based
on scsi_level and request 16 bytes using RC16 instead of 13.

I've only compiled this code, not actually booted it, so this is just
for comments.

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5081b39..fcb81e3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1275,41 +1275,91 @@ disable:
 }
 
 /*
- * read disk capacity
+ * READ CAPACITY 16 currently only defines the first 16 bytes of result, but
+ * could return more information in the future.
  */
-static void
-sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
+#define RC16_LEN 16
+#if RC16_LEN > SD_BUF_SIZE
+#error RC16_LEN must be less than SD_BUF_SIZE
+#endif
+
+static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
+						unsigned char *buffer)
 {
 	unsigned char cmd[16];
-	int the_result, retries;
-	int sector_size = 0;
-	/* Force READ CAPACITY(16) when PROTECT=1 */
-	int longrc = scsi_device_protection(sdkp->device) ? 1 : 0;
 	struct scsi_sense_hdr sshdr;
+	int the_result;
 	int sense_valid = 0;
-	struct scsi_device *sdp = sdkp->device;
+	int retries = 3;
+	unsigned long long lba;
+	unsigned sector_size;
 
-repeat:
-	retries = 3;
 	do {
-		if (longrc) {
-			memset((void *) cmd, 0, 16);
-			cmd[0] = SERVICE_ACTION_IN;
-			cmd[1] = SAI_READ_CAPACITY_16;
-			cmd[13] = 13;
-			memset((void *) buffer, 0, 13);
-		} else {
-			cmd[0] = READ_CAPACITY;
-			memset((void *) &cmd[1], 0, 9);
-			memset((void *) buffer, 0, 8);
-		}
-		
+		memset(cmd, 0, 16);
+		cmd[0] = SERVICE_ACTION_IN;
+		cmd[1] = SAI_READ_CAPACITY_16;
+		cmd[13] = RC16_LEN;
+		memset(buffer, 0, RC16_LEN);
+
 		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					      buffer, longrc ? 13 : 8, &sshdr,
+					      buffer, RC16_LEN, &sshdr,
 					      SD_TIMEOUT, SD_MAX_RETRIES);
 
 		if (media_not_present(sdkp, &sshdr))
-			return;
+			return -ENODEV;
+
+		if (the_result)
+			sense_valid = scsi_sense_valid(&sshdr);
+		retries--;
+
+	} while (the_result && retries);
+
+	if (the_result) {
+		/* READ CAPACITY(16) has been failed */
+		sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY(16) failed\n");
+		sd_print_result(sdkp, the_result);
+	}
+
+	sector_size =   (buffer[8] << 24) | (buffer[9] << 16) |
+			(buffer[10] << 8) | buffer[11];
+
+	lba =  (((u64)buffer[0] << 56) | ((u64)buffer[1] << 48) |
+		((u64)buffer[2] << 40) | ((u64)buffer[3] << 32) |
+		((u64)buffer[4] << 24) | ((u64)buffer[5] << 16) |
+		((u64)buffer[6] << 8 ) | (u64)buffer[7]);
+
+	sd_read_protection_type(sdkp, buffer);
+
+	if ((sizeof(sdkp->capacity) == 4) && (lba >= 0xffffffffULL)) {
+		sdkp->capacity = 0;
+		return -EOVERFLOW;
+	}
+
+	sdkp->capacity = lba + 1;
+	return sector_size;
+}
+
+static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
+						unsigned char *buffer)
+{
+	unsigned char cmd[16];
+	struct scsi_sense_hdr sshdr;
+	int the_result;
+	int sense_valid = 0;
+	int retries = 3;
+	unsigned sector_size;
+
+	do {
+		cmd[0] = READ_CAPACITY;
+		memset(&cmd[1], 0, 9);
+		memset(buffer, 0, 8);
+
+		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+					      buffer, 8, &sshdr,
+					      SD_TIMEOUT, SD_MAX_RETRIES);
+
+		if (media_not_present(sdkp, &sshdr))
+			return -ENODEV;
 
 		if (the_result)
 			sense_valid = scsi_sense_valid(&sshdr);
@@ -1317,7 +1367,7 @@ repeat:
 
 	} while (the_result && retries);
 
-	if (the_result && !longrc) {
+	if (the_result) {
 		sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY failed\n");
 		sd_print_result(sdkp, the_result);
 		if (driver_byte(the_result) & DRIVER_SENSE)
@@ -1336,53 +1386,67 @@ repeat:
 		/* sdkp->media_present = 0; -- not always correct */
 		sdkp->capacity = 0; /* unknown mapped to zero - as usual */
 
-		return;
-	} else if (the_result && longrc) {
-		/* READ CAPACITY(16) has been failed */
-		sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY(16) failed\n");
-		sd_print_result(sdkp, the_result);
-		sd_printk(KERN_NOTICE, sdkp, "Use 0xffffffff as device size\n");
+		return -EINVAL;
+	}
 
-		sdkp->capacity = 1 + (sector_t) 0xffffffff;		
-		goto got_data;
-	}	
-	
-	if (!longrc) {
-		sector_size = (buffer[4] << 24) |
-			(buffer[5] << 16) | (buffer[6] << 8) | buffer[7];
-		if (buffer[0] == 0xff && buffer[1] == 0xff &&
-		    buffer[2] == 0xff && buffer[3] == 0xff) {
-			if(sizeof(sdkp->capacity) > 4) {
-				sd_printk(KERN_NOTICE, sdkp, "Very big device. "
-					  "Trying to use READ CAPACITY(16).\n");
-				longrc = 1;
-				goto repeat;
-			}
-			sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use "
-				  "a kernel compiled with support for large "
-				  "block devices.\n");
-			sdkp->capacity = 0;
+	sector_size = (buffer[4] << 24) |
+		(buffer[5] << 16) | (buffer[6] << 8) | buffer[7];
+	if (buffer[0] == 0xff && buffer[1] == 0xff &&
+	    buffer[2] == 0xff && buffer[3] == 0xff) {
+		if (sizeof(sdkp->capacity) > 4)
+			goto out;
+		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
+			  "kernel compiled with support for large block "
+			  "devices.\n");
+		sdkp->capacity = 0;
+		return -EOVERFLOW;
+	}
+ out:
+	sdkp->capacity = 1 + (((sector_t)buffer[0] << 24) |
+		(buffer[1] << 16) | (buffer[2] << 8) | buffer[3]);
+	return sector_size;
+}
+
+/*
+ * read disk capacity
+ */
+static void
+sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+	int sector_size;
+	struct scsi_device *sdp = sdkp->device;
+
+	if (sdp->scsi_level > SCSI_2) {
+		sector_size = read_capacity_16(sdkp, sdp, buffer);
+		if (sector_size == -EOVERFLOW)
 			goto got_data;
-		}
-		sdkp->capacity = 1 + (((sector_t)buffer[0] << 24) |
-			(buffer[1] << 16) |
-			(buffer[2] << 8) |
-			buffer[3]);			
+		if (sector_size == -ENODEV)
+			return;
+		if (sector_size < 0)
+			sector_size = read_capacity_10(sdkp, sdp, buffer);
+		if (sector_size < 0)
+			return;
 	} else {
-		sdkp->capacity = 1 + (((u64)buffer[0] << 56) |
-			((u64)buffer[1] << 48) |
-			((u64)buffer[2] << 40) |
-			((u64)buffer[3] << 32) |
-			((sector_t)buffer[4] << 24) |
-			((sector_t)buffer[5] << 16) |
-			((sector_t)buffer[6] << 8)  |
-			(sector_t)buffer[7]);
-			
-		sector_size = (buffer[8] << 24) |
-			(buffer[9] << 16) | (buffer[10] << 8) | buffer[11];
-
-		sd_read_protection_type(sdkp, buffer);
-	}	
+		sector_size = read_capacity_10(sdkp, sdp, buffer);
+		if (sector_size == -EOVERFLOW)
+			goto got_data;
+		if (sector_size < 0)
+			return;
+		if ((sizeof(sdkp->capacity) > 4) &&
+		    (sdkp->capacity > 0xffffffffULL)) {
+			int old_sector_size = sector_size;
+			sd_printk(KERN_NOTICE, sdkp, "Very big device. "
+				  "Trying to use READ CAPACITY(16).\n");
+			sector_size = read_capacity_16(sdkp, sdp, buffer);
+			if (sector_size < 0) {
+				sd_printk(KERN_NOTICE, sdkp,
+					"Using 0xffffffff as device size\n");
+				sdkp->capacity = 1 + (sector_t) 0xffffffff;
+				sector_size = old_sector_size;
+				goto got_data;
+			}
+		}
+	}
 
 	/* Some devices return the total number of sectors, not the
 	 * highest sector number.  Make the necessary adjustment. */

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
