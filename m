From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/6] scsi_debug: clear correct memory region when LBPRZ is enabled
Date: Tue, 16 Apr 2013 22:11:57 +0900
Message-ID: <1366117920-11740-4-git-send-email-akinobu.mita@gmail.com>
References: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:40221 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933715Ab3DPNM3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 09:12:29 -0400
Received: by mail-pb0-f50.google.com with SMTP id jt11so287754pbb.9
        for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 06:12:29 -0700 (PDT)
In-Reply-To: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

The function unmap_region() clears memory region specified as the logical
block address and the number of logical blocks in ramdisk storage
(fake_storep) if lbpu and lbprz module parameters are enabled.

In the while loop of unmap_region(), it advances optimal unmap granularity
in logical blocks.  But it only clears one logical block at LBA 'block' per
loop iteration.  And furthermore, the 'block' is not pointing to a logical
block address which should be cleared, it is a index of probisioning map
(map_storep).

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5c32140..4b5d388 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2059,8 +2059,9 @@ static void unmap_region(sector_t lba, unsigned int len)
 			clear_bit(block, map_storep);
 			if (scsi_debug_lbprz)
 				memset(fake_storep +
-				       block * scsi_debug_sector_size, 0,
-				       scsi_debug_sector_size);
+				       lba * scsi_debug_sector_size, 0,
+				       scsi_debug_sector_size *
+				       scsi_debug_unmap_granularity);
 		}
 		lba += granularity - rem;
 	}
-- 
1.8.1.4

