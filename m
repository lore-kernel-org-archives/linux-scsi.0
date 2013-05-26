From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 4/6] scsi_debug: invalidate protection info for unmapped region
Date: Sun, 26 May 2013 17:01:20 +0900
Message-ID: <1369555282-17864-5-git-send-email-akinobu.mita@gmail.com>
References: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38751 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759209Ab3EZIBy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 May 2013 04:01:54 -0400
Received: by mail-pd0-f173.google.com with SMTP id v14so4354402pde.32
        for <linux-scsi@vger.kernel.org>; Sun, 26 May 2013 01:01:54 -0700 (PDT)
In-Reply-To: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

When UNMAP command is issued with the data integrity support enabled,
the protection info for the unmapped region is remain unchanged.
So READ command for the region later on causes data integrity failure.

This fixes it by invalidating protection info for the unmapped region
by filling with 0xff pattern.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---

* New patch from v3

 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index e83e661..83efec2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2064,6 +2064,11 @@ static void unmap_region(sector_t lba, unsigned int len)
 				       scsi_debug_sector_size *
 				       scsi_debug_unmap_granularity);
 			}
+			if (dif_storep) {
+				memset(dif_storep + lba, 0xff,
+				       sizeof(*dif_storep) *
+				       scsi_debug_unmap_granularity);
+			}
 		}
 		lba = map_index_to_lba(index + 1);
 	}
-- 
1.8.1.4

