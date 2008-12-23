From: Matthew Wilcox <matthew@wil.cx>
Subject: sd: Refactor sd_read_capacity()
Date: Tue, 23 Dec 2008 09:45:10 -0700
Message-ID: <20081223164509.GA19967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42426 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYLWQpL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Dec 2008 11:45:11 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The sd_read_capacity() function was about 180 lines long and
included a backwards goto and a tricky state variable.  Splitting out
read_capacity_10() and read_capacity_16() (about 50 lines each) reduces
sd_read_capacity to about 100 lines and gets rid of the backwards goto
and the state variable.  I've tried to avoid any behaviour change with
this patch.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sd.c |  241 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 155 insertions(+), 86 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5081b39..f244349 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1274,42 +1274,61 @@ disable:
 	sdkp->capacity = 0;
 }
 
-/*
- * read disk capacity
- */
-static void
-sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
+static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
+			struct scsi_sense_hdr *sshdr, int sense_valid,
+			int the_result)
+{
+	sd_print_result(sdkp, the_result);
+	if (driver_byte(the_result) & DRIVER_SENSE)
+		sd_print_sense_hdr(sdkp, sshdr);
+	else
+		sd_printk(KERN_NOTICE, sdkp, "Sense not available.\n");
+
+	/*
+	 * Set dirty bit for removable devices if not ready -
+	 * sometimes drives will not report this properly.
+	 */
+	if (sdp->removable &&
+	    sense_valid && sshdr->sense_key == NOT_READY)
+		sdp->changed = 1;
+
+	/*
+	 * We used to set media_present to 0 here to indicate no media
+	 * in the drive, but some drives fail read capacity even with
+	 * media present, so we can't do that.
+	 */
+	sdkp->capacity = 0; /* unknown mapped to zero - as usual */
+}
+
+#define RC16_LEN 13
+#if RC16_LEN > SD_BUF_SIZE
+#error RC16_LEN must not be more than SD_BUF_SIZE
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
 	int sense_valid = 0;
-	struct scsi_device *sdp = sdkp->device;
+	int the_result;
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
-					      SD_TIMEOUT, SD_MAX_RETRIES);
+					buffer, RC16_LEN, &sshdr,
+					SD_TIMEOUT, SD_MAX_RETRIES);
 
 		if (media_not_present(sdkp, &sshdr))
-			return;
+			return -ENODEV;
 
 		if (the_result)
 			sense_valid = scsi_sense_valid(&sshdr);
@@ -1317,72 +1336,122 @@ repeat:
 
 	} while (the_result && retries);
 
-	if (the_result && !longrc) {
+	if (the_result) {
+		sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY(16) failed\n");
+		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
+		return -EINVAL;
+	}
+
+	sector_size =	(buffer[8] << 24) | (buffer[9] << 16) |
+			(buffer[10] << 8) | buffer[11];
+	lba =  (((u64)buffer[0] << 56) | ((u64)buffer[1] << 48) |
+		((u64)buffer[2] << 40) | ((u64)buffer[3] << 32) |
+		((u64)buffer[4] << 24) | ((u64)buffer[5] << 16) |
+		((u64)buffer[6] << 8) | (u64)buffer[7]);
+
+	sd_read_protection_type(sdkp, buffer);
+
+	if ((sizeof(sdkp->capacity) == 4) && (lba >= 0xffffffffULL)) {
+		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
+			"kernel compiled with support for large block "
+			"devices.\n");
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
+	int sense_valid = 0;
+	int the_result;
+	int retries = 3;
+	sector_t lba;
+	unsigned sector_size;
+
+	do {
+		cmd[0] = READ_CAPACITY;
+		memset(&cmd[1], 0, 9);
+		memset(buffer, 0, 8);
+
+		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+					buffer, 8, &sshdr,
+					SD_TIMEOUT, SD_MAX_RETRIES);
+
+		if (media_not_present(sdkp, &sshdr))
+			return -ENODEV;
+
+		if (the_result)
+			sense_valid = scsi_sense_valid(&sshdr);
+		retries--;
+
+	} while (the_result && retries);
+
+	if (the_result) {
 		sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY failed\n");
-		sd_print_result(sdkp, the_result);
-		if (driver_byte(the_result) & DRIVER_SENSE)
-			sd_print_sense_hdr(sdkp, &sshdr);
-		else
-			sd_printk(KERN_NOTICE, sdkp, "Sense not available.\n");
+		read_capacity_error(sdkp, sdp, &sshdr, sense_valid, the_result);
+		return -EINVAL;
+	}
 
-		/* Set dirty bit for removable devices if not ready -
-		 * sometimes drives will not report this properly. */
-		if (sdp->removable &&
-		    sense_valid && sshdr.sense_key == NOT_READY)
-			sdp->changed = 1;
+	sector_size =	(buffer[4] << 24) | (buffer[5] << 16) |
+			(buffer[6] << 8) | buffer[7];
+	lba =	(buffer[0] << 24) | (buffer[1] << 16) |
+		(buffer[2] << 8) | buffer[3];
 
-		/* Either no media are present but the drive didn't tell us,
-		   or they are present but the read capacity command fails */
-		/* sdkp->media_present = 0; -- not always correct */
-		sdkp->capacity = 0; /* unknown mapped to zero - as usual */
+	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
+		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
+			"kernel compiled with support for large block "
+			"devices.\n");
+		sdkp->capacity = 0;
+		return -EOVERFLOW;
+	}
 
-		return;
-	} else if (the_result && longrc) {
-		/* READ CAPACITY(16) has been failed */
-		sd_printk(KERN_NOTICE, sdkp, "READ CAPACITY(16) failed\n");
-		sd_print_result(sdkp, the_result);
-		sd_printk(KERN_NOTICE, sdkp, "Use 0xffffffff as device size\n");
+	sdkp->capacity = lba + 1;
+	return sector_size;
+}
 
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
+/*
+ * read disk capacity
+ */
+static void
+sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+	int sector_size;
+	struct scsi_device *sdp = sdkp->device;
+
+	/* Force READ CAPACITY(16) when PROTECT=1 */
+	if (scsi_device_protection(sdp)) {
+		sector_size = read_capacity_16(sdkp, sdp, buffer);
+		if (sector_size == -EOVERFLOW)
 			goto got_data;
-		}
-		sdkp->capacity = 1 + (((sector_t)buffer[0] << 24) |
-			(buffer[1] << 16) |
-			(buffer[2] << 8) |
-			buffer[3]);			
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
+					"Trying to use READ CAPACITY(16).\n");
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
