From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 11/13] scsi_debug: Add support for physical block exponent and alignment
Date: Fri, 15 May 2009 00:40:33 -0400
Message-ID: <1242362435-11953-12-git-send-email-martin.petersen@oracle.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:16994 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbZEOEmb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 00:42:31 -0400
In-Reply-To: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

From: Martin K. Petersen <martin.petersen@oracle.com>

This patch adds support for setting the physical block exponent and
lowest aligned LBA in the READ CAPACITY(16) response.

The B0 VPD page is adjusted accordingly.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_debug.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 213123b..f0198e0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -101,6 +101,8 @@ static const char * scsi_debug_version_date = "20070104";
 #define DEF_DIF 0
 #define DEF_GUARD 0
 #define DEF_ATO 1
+#define DEF_PHYSBLK_EXP 0
+#define DEF_LOWEST_ALIGNED 0
 
 /* bit mask values for scsi_debug_opts */
 #define SCSI_DEBUG_OPT_NOISE   1
@@ -156,6 +158,8 @@ static int scsi_debug_dix = DEF_DIX;
 static int scsi_debug_dif = DEF_DIF;
 static int scsi_debug_guard = DEF_GUARD;
 static int scsi_debug_ato = DEF_ATO;
+static int scsi_debug_physblk_exp = DEF_PHYSBLK_EXP;
+static int scsi_debug_lowest_aligned = DEF_LOWEST_ALIGNED;
 
 static int scsi_debug_cmnd_count = 0;
 
@@ -657,7 +661,12 @@ static unsigned char vpdb0_data[] = {
 
 static int inquiry_evpd_b0(unsigned char * arr)
 {
+	unsigned int gran;
+
 	memcpy(arr, vpdb0_data, sizeof(vpdb0_data));
+	gran = 1 << scsi_debug_physblk_exp;
+	arr[2] = (gran >> 8) & 0xff;
+	arr[3] = gran & 0xff;
 	if (sdebug_store_sectors > 0x400) {
 		arr[4] = (sdebug_store_sectors >> 24) & 0xff;
 		arr[5] = (sdebug_store_sectors >> 16) & 0xff;
@@ -945,6 +954,9 @@ static int resp_readcap16(struct scsi_cmnd * scp,
 	arr[9] = (scsi_debug_sector_size >> 16) & 0xff;
 	arr[10] = (scsi_debug_sector_size >> 8) & 0xff;
 	arr[11] = scsi_debug_sector_size & 0xff;
+	arr[13] = scsi_debug_physblk_exp & 0xf;
+	arr[14] = (scsi_debug_lowest_aligned >> 8) & 0x3f;
+	arr[15] = scsi_debug_lowest_aligned & 0xff;
 
 	if (scsi_debug_dif) {
 		arr[12] = (scsi_debug_dif - 1) << 1; /* P_TYPE */
@@ -2380,6 +2392,8 @@ module_param_named(dix, scsi_debug_dix, int, S_IRUGO);
 module_param_named(dif, scsi_debug_dif, int, S_IRUGO);
 module_param_named(guard, scsi_debug_guard, int, S_IRUGO);
 module_param_named(ato, scsi_debug_ato, int, S_IRUGO);
+module_param_named(physblk_exp, scsi_debug_physblk_exp, int, S_IRUGO);
+module_param_named(lowest_aligned, scsi_debug_lowest_aligned, int, S_IRUGO);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -2401,7 +2415,9 @@ MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=5[SPC-3])");
 MODULE_PARM_DESC(virtual_gb, "virtual gigabyte size (def=0 -> use dev_size_mb)");
 MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
-MODULE_PARM_DESC(sector_size, "hardware sector size in bytes (def=512)");
+MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
+MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
+MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
 MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
 MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
@@ -2874,6 +2890,18 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
+	if (scsi_debug_physblk_exp > 15) {
+		printk(KERN_ERR "scsi_debug_init: invalid physblk_exp %u\n",
+		       scsi_debug_physblk_exp);
+		return -EINVAL;
+	}
+
+	if (scsi_debug_lowest_aligned > 0x3fff) {
+		printk(KERN_ERR "scsi_debug_init: lowest_aligned too big: %u\n",
+		       scsi_debug_lowest_aligned);
+		return -EINVAL;
+	}
+
 	if (scsi_debug_dev_size_mb < 1)
 		scsi_debug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
 	sz = (unsigned long)scsi_debug_dev_size_mb * 1048576;
-- 
1.6.0.6

