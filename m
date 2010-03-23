From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi_debug: Block Limits VPD page fixes
Date: Tue, 23 Mar 2010 01:12:27 -0400
Message-ID: <yq1k4t3hb9g.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:41286 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab0CWFOX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2010 01:14:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>


Add a few clarifying comments in the B0 page function and allow the
optimal transfer length field to be specified on the command line using
opt_blks=N.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0b575c8..6ebcdd1 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -107,6 +107,7 @@ static const char * scsi_debug_version_date = "20070104";
 #define DEF_ATO 1
 #define DEF_PHYSBLK_EXP 0
 #define DEF_LOWEST_ALIGNED 0
+#define DEF_OPT_BLKS 64
 #define DEF_UNMAP_MAX_BLOCKS 0
 #define DEF_UNMAP_MAX_DESC 0
 #define DEF_UNMAP_GRANULARITY 0
@@ -168,6 +169,7 @@ static int scsi_debug_guard = DEF_GUARD;
 static int scsi_debug_ato = DEF_ATO;
 static int scsi_debug_physblk_exp = DEF_PHYSBLK_EXP;
 static int scsi_debug_lowest_aligned = DEF_LOWEST_ALIGNED;
+static int scsi_debug_opt_blks = DEF_OPT_BLKS;
 static int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
 static int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
 static int scsi_debug_unmap_granularity = DEF_UNMAP_GRANULARITY;
@@ -698,9 +700,13 @@ static int inquiry_evpd_b0(unsigned char * arr)
 	unsigned int gran;
 
 	memcpy(arr, vpdb0_data, sizeof(vpdb0_data));
+
+	/* Optimal transfer length granularity */
 	gran = 1 << scsi_debug_physblk_exp;
 	arr[2] = (gran >> 8) & 0xff;
 	arr[3] = gran & 0xff;
+
+	/* Maximum Transfer Length */
 	if (sdebug_store_sectors > 0x400) {
 		arr[4] = (sdebug_store_sectors >> 24) & 0xff;
 		arr[5] = (sdebug_store_sectors >> 16) & 0xff;
@@ -708,6 +714,9 @@ static int inquiry_evpd_b0(unsigned char * arr)
 		arr[7] = sdebug_store_sectors & 0xff;
 	}
 
+	/* Optimal Transfer Length */
+	put_unaligned_be32(scsi_debug_opt_blks, &arr[8]);
+
 	if (scsi_debug_unmap_max_desc) {
 		unsigned int blocks;
 
@@ -716,15 +725,20 @@ static int inquiry_evpd_b0(unsigned char * arr)
 		else
 			blocks = 0xffffffff;
 
+		/* Maximum Unmap LBA Count */
 		put_unaligned_be32(blocks, &arr[16]);
+
+		/* Maximum Unmap Block Descriptor Count */
 		put_unaligned_be32(scsi_debug_unmap_max_desc, &arr[20]);
 	}
 
+	/* Unmap Granularity Alignment */
 	if (scsi_debug_unmap_alignment) {
 		put_unaligned_be32(scsi_debug_unmap_alignment, &arr[28]);
 		arr[28] |= 0x80; /* UGAVALID */
 	}
 
+	/* Optimal Unmap Granularity */
 	if (scsi_debug_unmap_granularity) {
 		put_unaligned_be32(scsi_debug_unmap_granularity, &arr[24]);
 		return 0x3c; /* Mandatory page length for thin provisioning */
@@ -2675,6 +2689,7 @@ module_param_named(dif, scsi_debug_dif, int, S_IRUGO);
 module_param_named(guard, scsi_debug_guard, int, S_IRUGO);
 module_param_named(ato, scsi_debug_ato, int, S_IRUGO);
 module_param_named(physblk_exp, scsi_debug_physblk_exp, int, S_IRUGO);
+module_param_named(opt_blks, scsi_debug_opt_blks, int, S_IRUGO);
 module_param_named(lowest_aligned, scsi_debug_lowest_aligned, int, S_IRUGO);
 module_param_named(unmap_max_blocks, scsi_debug_unmap_max_blocks, int, S_IRUGO);
 module_param_named(unmap_max_desc, scsi_debug_unmap_max_desc, int, S_IRUGO);
@@ -2703,6 +2718,7 @@ MODULE_PARM_DESC(virtual_gb, "virtual gigabyte size (def=0 -> use dev_size_mb)")
 MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
 MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
 MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
+MODULE_PARM_DESC(opt_blks, "optimal transfer length in block (def=64)");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
 MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
