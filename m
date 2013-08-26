From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/2] scsi_debug: fix logical block provisioning support when unmap_alignment != 0
Date: Mon, 26 Aug 2013 22:08:41 +0900
Message-ID: <1377522521-9371-3-git-send-email-akinobu.mita@gmail.com>
References: <1377522521-9371-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:35904 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab3HZNKC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 09:10:02 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so3428570pbb.27
        for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 06:10:01 -0700 (PDT)
In-Reply-To: <1377522521-9371-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Commit b90ebc3d5c41c9164ae04efd2e4f8204c2a186f1 ("[SCSI] scsi_debug:
fix logical block provisioning support") fixed several issues with
logical block provisioning support, but it still doesn't properly fix
the cases when unmap_alignment > 0.

For example, load scsi_debug module with the following module parameters
and make all blocks mapped by filling the storage with zero.

        # modprobe scsi_debug lbpu=1 unmap_alignment=1 unmap_granularity=4
        # dd if=/dev/zero of=$DEV

Then, try to unmap the first unmappable blocks at lba=1, but GET LBA STATUS
unexpectedly reports that the last UNMAP has done nothing.

        # sg_unmap --lba=1 --num=4 $DEV
        # sg_get_lba_status --lba=1 $DEV
        descriptor LBA: 0x0000000000000001  blocks: 16383  mapped

The problem is in map_index_to_lba(), which should return the first
LBA which is corresponding to a given index of provisioning map
(map_storep).

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Acked-by: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2f39b13..01c0ffa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1997,8 +1997,14 @@ static unsigned long lba_to_map_index(sector_t lba)
 
 static sector_t map_index_to_lba(unsigned long index)
 {
-	return index * scsi_debug_unmap_granularity -
-		scsi_debug_unmap_alignment;
+	sector_t lba = index * scsi_debug_unmap_granularity;
+
+	if (scsi_debug_unmap_alignment) {
+		lba -= scsi_debug_unmap_granularity -
+			scsi_debug_unmap_alignment;
+	}
+
+	return lba;
 }
 
 static unsigned int map_state(sector_t lba, unsigned int *num)
-- 
1.8.3.1

