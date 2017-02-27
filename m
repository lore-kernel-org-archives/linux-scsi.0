From: "Steven J. Magnani" <steve.magnani@digidescorp.com>
Subject: [PATCH] sd: close hole in > 2T device rejection when !CONFIG_LBDAF
Date: Mon, 27 Feb 2017 09:22:29 -0600
Message-ID: <1488208949-3811-1-git-send-email-steve@digidescorp.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:35239 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbdB0PbP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 10:31:15 -0500
Received: by mail-it0-f41.google.com with SMTP id 203so61597226ith.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2017 07:29:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'James E . J . Bottomley'" <jejb@linux.vnet.ibm.com>, "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Steven J . Magnani" <steve@digidescorp.com>

When the kernel is compiled _without_ support for large (>= 2TiB) block
devices, code in the sd driver's read_capacity() routines rejects devices
whose count of native-sized blocks does not fit in the 32 bit sector_t
type. A device reporting 4294967296 512-byte blocks will be rejected, but
a device of equal capacity reporting 2147483648 1024-byte blocks will not.

The latter case causes problems, for example misreporting of device
capacity by BLKGETSIZE64. This is because the kernel converts a device's
capacity in native-sized blocks to an equivalent number of 512-byte units
and stores the result in a sector_t - which is too small for devices such
as those noted above.

To prevent this, when the kernel is compiled without support for large
block devices, the read_capacity() routines must reject any device whose
capacity is 2 TiB or greater regardless of its count of native-sized
blocks.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
--- a/drivers/scsi/sd.c	2017-02-24 20:29:44.510036363 -0600
+++ b/drivers/scsi/sd.c	2017-02-27 08:19:37.864786958 -0600
@@ -2066,7 +2066,7 @@ static int read_capacity_16(struct scsi_
 	int the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
-	unsigned long long lba;
+	unsigned long long lba, lba_in_sectors;
 	unsigned sector_size;
 
 	if (sdp->no_read_capacity_16)
@@ -2122,7 +2122,10 @@ static int read_capacity_16(struct scsi_
 		return -ENODEV;
 	}
 
-	if ((sizeof(sdkp->capacity) == 4) && (lba >= 0xffffffffULL)) {
+	/* Make sure logical_to_sectors() won't overflow */
+	lba_in_sectors = lba << (ilog2(sector_size) - 9);
+	if ((sizeof(sdkp->capacity) == 4) &&
+	    ((lba >= 0xffffffffULL) || (lba_in_sectors >= 0xffffffffULL))) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
 			"devices.\n");
@@ -2162,6 +2165,7 @@ static int read_capacity_10(struct scsi_
 	int the_result;
 	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	sector_t lba;
+	unsigned long long lba_in_sectors;
 	unsigned sector_size;
 
 	do {
@@ -2208,7 +2212,10 @@ static int read_capacity_10(struct scsi_
 		return sector_size;
 	}
 
-	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
+	/* Make sure logical_to_sectors() won't overflow */
+	lba_in_sectors = ((unsigned long long) lba) << (ilog2(sector_size) - 9);
+	if ((sizeof(sdkp->capacity) == 4) &&
+	    (lba_in_sectors >= 0xffffffffULL)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
 			"devices.\n");
