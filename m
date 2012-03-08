From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] scsi_debug: add LBPRZ support
Date: Thu, 08 Mar 2012 00:03:59 -0600
Message-ID: <4F584BCF.7030803@redhat.com>
References: <4F57C061.9020807@redhat.com> <4F58049C.5010505@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab2CHGEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Mar 2012 01:04:06 -0500
In-Reply-To: <4F58049C.5010505@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, mkp@mkp.net, =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>

Add LBPRZ support to scsi_debug; i.e. read zeros for
unmapped blocks.

Rather than checking for unmapped blocks at
read time, this just zeroes them on the backing store
at unmap time so it behaves the same way.

This also adds a module parameter to disable it.

lbprz, "unmapped blocks return 0 on read (def=1)"

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: set flag in inquiry_evpd_b2() as well, and rename *_zeroes
type symbols to *_lbprz

note, I didn't change the return value of inquiry_evpd_b2();
that seems unrelated to this change, and should be a separate
patch, no?

Thanks,
-Eric

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6888b2c..fc12a39 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -101,6 +101,7 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_LBPU 0
 #define DEF_LBPWS 0
 #define DEF_LBPWS10 0
+#define DEF_LBPRZ 1
 #define DEF_LOWEST_ALIGNED 0
 #define DEF_NO_LUN_0   0
 #define DEF_NUM_PARTS   0
@@ -185,6 +186,7 @@ static int scsi_debug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
 static unsigned int scsi_debug_lbpu = DEF_LBPU;
 static unsigned int scsi_debug_lbpws = DEF_LBPWS;
 static unsigned int scsi_debug_lbpws10 = DEF_LBPWS10;
+static unsigned int scsi_debug_lbprz = DEF_LBPRZ;
 static unsigned int scsi_debug_unmap_alignment = DEF_UNMAP_ALIGNMENT;
 static unsigned int scsi_debug_unmap_granularity = DEF_UNMAP_GRANULARITY;
 static unsigned int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
@@ -774,7 +776,7 @@ static int inquiry_evpd_b1(unsigned char *arr)
 	return 0x3c;
 }
 
-/* Thin provisioning VPD page (SBC-3) */
+/* Logical block provisioning VPD page (SBC-3) */
 static int inquiry_evpd_b2(unsigned char *arr)
 {
 	memset(arr, 0, 0x8);
@@ -789,6 +791,9 @@ static int inquiry_evpd_b2(unsigned char *arr)
 	if (scsi_debug_lbpws10)
 		arr[1] |= 1 << 5;
 
+	if (scsi_debug_lbprz)
+		arr[1] |= 1 << 2; 
+
 	return 0x8;
 }
 
@@ -1070,8 +1075,11 @@ static int resp_readcap16(struct scsi_cmnd * scp,
 	arr[13] = scsi_debug_physblk_exp & 0xf;
 	arr[14] = (scsi_debug_lowest_aligned >> 8) & 0x3f;
 
-	if (scsi_debug_lbp())
+	if (scsi_debug_lbp()) {
 		arr[14] |= 0x80; /* LBPME */
+		if (scsi_debug_lbprz)
+			arr[14] |= 0x40; /* LBPRZ */
+	}
 
 	arr[15] = scsi_debug_lowest_aligned & 0xff;
 
@@ -2045,10 +2053,13 @@ static void unmap_region(sector_t lba, unsigned int len)
 		block = lba + alignment;
 		rem = do_div(block, granularity);
 
-		if (rem == 0 && lba + granularity <= end &&
-		    block < map_size)
+		if (rem == 0 && lba + granularity <= end && block < map_size) {
 			clear_bit(block, map_storep);
-
+			if (scsi_debug_lbprz)
+				memset(fake_storep +
+				       block * scsi_debug_sector_size, 0,
+				       scsi_debug_sector_size);
+		}
 		lba += granularity - rem;
 	}
 }
@@ -2730,6 +2741,7 @@ module_param_named(guard, scsi_debug_guard, int, S_IRUGO);
 module_param_named(lbpu, scsi_debug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, scsi_debug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, scsi_debug_lbpws10, int, S_IRUGO);
+module_param_named(lbprz, scsi_debug_lbprz, int, S_IRUGO);
 module_param_named(lowest_aligned, scsi_debug_lowest_aligned, int, S_IRUGO);
 module_param_named(max_luns, scsi_debug_max_luns, int, S_IRUGO | S_IWUSR);
 module_param_named(max_queue, scsi_debug_max_queue, int, S_IRUGO | S_IWUSR);
@@ -2771,6 +2783,7 @@ MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
+MODULE_PARM_DESC(lbprz, "unmapped blocks return 0 on read (def=1)");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
 MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to 255(def))");

