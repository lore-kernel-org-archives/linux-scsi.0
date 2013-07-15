From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/4] scsi_debug: fix logical block provisioning support when unmap_alignment != 0
Date: Mon, 15 Jul 2013 20:52:05 +0900
Message-ID: <1373889127-17083-3-git-send-email-akinobu.mita@gmail.com>
References: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57568 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab3GOLxD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 07:53:03 -0400
Received: by mail-pa0-f51.google.com with SMTP id lf11so11050974pab.38
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jul 2013 04:53:02 -0700 (PDT)
In-Reply-To: <1373889127-17083-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Commit b90ebc3d5c41c9164ae04efd2e4f8204c2a186f1 ("[SCSI] scsi_debug:
fix logical block provisioning support") fixed several issues with
logical block provisioning support, but it still doesn't properly fix
the cases when unmap_alignment > 0.  (for example, unmap_alignment=1
and unmap_granularity=3)

The problem is in map_index_to_lba(), which should return the first
LBA which is corresponding to a given index of provisioning map
(map_storep).

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
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

