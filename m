From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] scsi_debug: add TPRZ support
Date: Mon, 23 Aug 2010 14:24:39 -0500
Message-ID: <4C72CAF7.8020601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab0HWTYp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2010 15:24:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mkp@mkp.net

Add TPRZ support to scsi_debug; i.e. return zero for
unmapped blocks.

Rather than checking for unmapped blocks at
read time, this just zeroes them on the backing store
at unmap time so it behaves the same way.

This also adds a module parameter to disable it, since
some SSDs have this behavior.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b02bdc6..bf9a729 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -113,6 +113,7 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_UNMAP_MAX_DESC 0
 #define DEF_UNMAP_GRANULARITY 0
 #define DEF_UNMAP_ALIGNMENT 0
+#define DEF_UNMAP_ZEROES 1
 
 /* bit mask values for scsi_debug_opts */
 #define SCSI_DEBUG_OPT_NOISE   1
@@ -181,6 +182,7 @@ static int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
 static int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
 static int scsi_debug_unmap_granularity = DEF_UNMAP_GRANULARITY;
 static int scsi_debug_unmap_alignment = DEF_UNMAP_ALIGNMENT;
+static int scsi_debug_unmap_zeroes = DEF_UNMAP_ZEROES;
 
 static int scsi_debug_cmnd_count = 0;
 
@@ -1038,8 +1040,12 @@ static int resp_readcap16(struct scsi_cmnd * scp,
 	arr[13] = scsi_debug_physblk_exp & 0xf;
 	arr[14] = (scsi_debug_lowest_aligned >> 8) & 0x3f;
 
-	if (scsi_debug_unmap_granularity)
+
+	if (scsi_debug_unmap_granularity) {
 		arr[14] |= 0x80; /* TPE */
+		if (scsi_debug_unmap_zeroes)
+			arr[14] |= 0x40; /* TPRZ */
+	}
 
 	arr[15] = scsi_debug_lowest_aligned & 0xff;
 
@@ -2012,9 +2018,13 @@ static void unmap_region(sector_t lba, unsigned int len)
 		block = lba + alignment;
 		rem = do_div(block, granularity);
 
-		if (rem == 0 && lba + granularity <= end &&
-		    block < map_size)
+		if (rem == 0 && lba + granularity <= end && block < map_size) {
 			clear_bit(block, map_storep);
+			if (scsi_debug_unmap_zeroes)
+				memset(fake_storep + 
+				       block * scsi_debug_sector_size, 0,
+				       scsi_debug_sector_size);
+		}
 
 		lba += granularity - rem;
 	}
@@ -2708,6 +2718,7 @@ module_param_named(unmap_max_blocks, scsi_debug_unmap_max_blocks, int, S_IRUGO);
 module_param_named(unmap_max_desc, scsi_debug_unmap_max_desc, int, S_IRUGO);
 module_param_named(unmap_granularity, scsi_debug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_alignment, scsi_debug_unmap_alignment, int, S_IRUGO);
+module_param_named(unmap_zeroes, scsi_debug_unmap_zeroes, int, S_IRUGO);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -2743,6 +2754,7 @@ MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (
 MODULE_PARM_DESC(unmap_max_desc, "max # of ranges that can be unmapped in one cmd (def=0)");
 MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=0)");
 MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
+MODULE_PARM_DESC(unmap_zeroes, "unmapped blocks return 0 on read (def=1)");
 
 static char sdebug_info[256];
 
@@ -3350,6 +3362,12 @@ static int __init scsi_debug_init(void)
 		/* Map first 1KB for partition table */
 		if (scsi_debug_num_parts)
 			map_region(0, 2);
+	} else if (scsi_debug_unmap_zeroes) {
+		printk(KERN_ERR
+		       "%s: ERR: unmap_zeroes set without unmap_granularity\n",
+		       __func__);
+		ret = -EINVAL;
+		goto free_vm;
 	}
 
 	ret = device_register(&pseudo_primary);

