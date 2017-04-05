From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2] scsi: sd: Fix capacity calculation with 32-bit sector_t
Date: Wed,  5 Apr 2017 06:15:29 -0400
Message-ID: <20170405101529.30787-1-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48200 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932586AbdDEKP4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 06:15:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org, Bart Van Assche <Bart.VanAssche@sandisk.com>

We previously made sure that the reported disk capacity was less than
0xffffffff blocks when the kernel was not compiled with large sector_t
support (CONFIG_LBDAF). However, this check assumed that the capacity
was reported in units of 512 bytes.

Add a sanity check function to ensure that we only enable disks if the
entire reported capacity can be expressed in terms of sector_t.

Cc: <stable@vger.kernel.org>
Reported-by: Steve Magnani <steve.magnani@digidescorp.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fb9b4d29af0b..08117e8cfe0b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2102,6 +2102,22 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 #define READ_CAPACITY_RETRIES_ON_RESET	10
 
+/*
+ * Ensure that we don't overflow sector_t when CONFIG_LBDAF is not set
+ * and the reported logical block size is bigger than 512 bytes. Note
+ * that last_sector is a u64 and therefore logical_to_sectors() is not
+ * applicable.
+ */
+static bool sd_addressable_capacity(u64 lba, unsigned int sector_size)
+{
+	u64 last_sector = (lba + 1ULL) << (ilog2(sector_size) - 9);
+
+	if (sizeof(sector_t) == 4 && last_sector > U32_MAX)
+		return false;
+
+	return true;
+}
+
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
@@ -2167,7 +2183,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return -ENODEV;
 	}
 
-	if ((sizeof(sdkp->capacity) == 4) && (lba >= 0xffffffffULL)) {
+	if (!sd_addressable_capacity(lba, sector_size)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
 			"devices.\n");
@@ -2256,7 +2272,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return sector_size;
 	}
 
-	if ((sizeof(sdkp->capacity) == 4) && (lba == 0xffffffff)) {
+	if (!sd_addressable_capacity(lba, sector_size)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
 			"devices.\n");
-- 
2.12.0
