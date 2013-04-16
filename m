From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 5/6] scsi_debug: fix initialization of provisioning map
Date: Tue, 16 Apr 2013 22:11:59 +0900
Message-ID: <1366117920-11740-6-git-send-email-akinobu.mita@gmail.com>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:52298 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934807Ab3DPNMd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 09:12:33 -0400
Received: by mail-pb0-f52.google.com with SMTP id mc8so289786pbc.11
        for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 06:12:32 -0700 (PDT)
In-Reply-To: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

provisioning map (map_storep) is a bitmap accessed by bitops.

So the allocation size should be a multiple of sizeof(unsigned long) and
also the bitmap should be cleared by using bitmap_clear() instead of
memset().

Otherwise it will cause problem on big-endian architecture if the number of
bits is not a multiple of BITS_PER_LONG.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c6de36c..6581549 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3419,8 +3419,6 @@ static int __init scsi_debug_init(void)
 
 	/* Logical Block Provisioning */
 	if (scsi_debug_lbp()) {
-		unsigned int map_bytes;
-
 		scsi_debug_unmap_max_blocks =
 			clamp(scsi_debug_unmap_max_blocks, 0U, 0xffffffffU);
 
@@ -3439,9 +3437,8 @@ static int __init scsi_debug_init(void)
 			return -EINVAL;
 		}
 
-		map_size = (sdebug_store_sectors / scsi_debug_unmap_granularity);
-		map_bytes = map_size >> 3;
-		map_storep = vmalloc(map_bytes);
+		map_size = lba_to_map_index(sdebug_store_sectors - 1) + 1;
+		map_storep = vmalloc(BITS_TO_LONGS(map_size) * sizeof(long));
 
 		printk(KERN_INFO "scsi_debug_init: %lu provisioning blocks\n",
 		       map_size);
@@ -3452,7 +3449,7 @@ static int __init scsi_debug_init(void)
 			goto free_vm;
 		}
 
-		memset(map_storep, 0x0, map_bytes);
+		bitmap_zero(map_storep, map_size);
 
 		/* Map first 1KB for partition table */
 		if (scsi_debug_num_parts)
-- 
1.8.1.4

