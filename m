From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] scsi_debug: add LBPRZ support
Date: Wed, 07 Mar 2012 14:09:05 -0600
Message-ID: <4F57C061.9020807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048Ab2CGUJJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Mar 2012 15:09:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: mkp@mkp.net, =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>

Add LBPRZ support to scsi_debug; i.e. return zero for
unmapped blocks.

Rather than checking for unmapped blocks at
read time, this just zeroes them on the backing store
at unmap time so it behaves the same way.

This also adds a module parameter to disable it, since
some SSDs have this behavior.

unmap_zeroes, "unmapped blocks return 0 on read (def=1)"

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Note: This was sent long ago as "TPRZ" support, but lost, I guess.

Note2: dgilbert preferred "zeros" to "zeroes" at the time,
but since we have "discard_zeroes_data" in sysfs it seems like
we should be consistent with the kernel precedent, rather than
the spec spelling.

But I really don't are if this gets searched & replaced before 
commit.  :)

Thanks,
-Eric

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6888b2c..32e6c19 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -114,6 +114,7 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_UNMAP_GRANULARITY 1
 #define DEF_UNMAP_MAX_BLOCKS 0xFFFFFFFF
 #define DEF_UNMAP_MAX_DESC 256
+#define DEF_UNMAP_ZEROES 1
 #define DEF_VIRTUAL_GB   0
 #define DEF_VPD_USE_HOSTNO 1
 #define DEF_WRITESAME_LENGTH 0xFFFF
@@ -189,6 +190,7 @@ static unsigned int scsi_debug_unmap_alignment = DEF_UNMAP_ALIGNMENT;
 static unsigned int scsi_debug_unmap_granularity = DEF_UNMAP_GRANULARITY;
 static unsigned int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
 static unsigned int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
+static unsigned int scsi_debug_unmap_zeroes = DEF_UNMAP_ZEROES;
 static unsigned int scsi_debug_write_same_length = DEF_WRITESAME_LENGTH;
 
 static int scsi_debug_cmnd_count = 0;
@@ -1070,8 +1072,11 @@ static int resp_readcap16(struct scsi_cmnd * scp,
 	arr[13] = scsi_debug_physblk_exp & 0xf;
 	arr[14] = (scsi_debug_lowest_aligned >> 8) & 0x3f;
 
-	if (scsi_debug_lbp())
+	if (scsi_debug_lbp()) {
 		arr[14] |= 0x80; /* LBPME */
+		if (scsi_debug_unmap_zeroes)
+			arr[14] |= 0x40; /* LBPRZ */
+	}
 
 	arr[15] = scsi_debug_lowest_aligned & 0xff;
 
@@ -2045,10 +2050,13 @@ static void unmap_region(sector_t lba, unsigned int len)
 		block = lba + alignment;
 		rem = do_div(block, granularity);
 
-		if (rem == 0 && lba + granularity <= end &&
-		    block < map_size)
+		if (rem == 0 && lba + granularity <= end && block < map_size) {
 			clear_bit(block, map_storep);
-
+			if (scsi_debug_unmap_zeroes)
+				memset(fake_storep +
+				       block * scsi_debug_sector_size, 0,
+				       scsi_debug_sector_size);
+		}
 		lba += granularity - rem;
 	}
 }
@@ -2747,6 +2755,7 @@ module_param_named(unmap_alignment, scsi_debug_unmap_alignment, int, S_IRUGO);
 module_param_named(unmap_granularity, scsi_debug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_max_blocks, scsi_debug_unmap_max_blocks, int, S_IRUGO);
 module_param_named(unmap_max_desc, scsi_debug_unmap_max_desc, int, S_IRUGO);
+module_param_named(unmap_zeroes, scsi_debug_unmap_zeroes, int, S_IRUGO);
 module_param_named(virtual_gb, scsi_debug_virtual_gb, int, S_IRUGO | S_IWUSR);
 module_param_named(vpd_use_hostno, scsi_debug_vpd_use_hostno, int,
 		   S_IRUGO | S_IWUSR);
@@ -2788,6 +2797,7 @@ MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)"
 MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
 MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0xffffffff)");
 MODULE_PARM_DESC(unmap_max_desc, "max # of ranges that can be unmapped in one cmd (def=256)");
+MODULE_PARM_DESC(unmap_zeroes, "unmapped blocks return 0 on read (def=1)");
 MODULE_PARM_DESC(virtual_gb, "virtual gigabyte size (def=0 -> use dev_size_mb)");
 MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
 MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xffff)");

