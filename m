From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 4/6] scsi_debug: invalidate protection info for unmapped region
Date: Sat, 29 Jun 2013 17:59:17 +0900
Message-ID: <1372496359-21100-5-git-send-email-akinobu.mita@gmail.com>
References: <1372496359-21100-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54177 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3F2JAP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Jun 2013 05:00:15 -0400
Received: by mail-pd0-f182.google.com with SMTP id r10so1483210pdi.13
        for <linux-scsi@vger.kernel.org>; Sat, 29 Jun 2013 02:00:14 -0700 (PDT)
In-Reply-To: <1372496359-21100-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

When UNMAP command is issued with the data integrity support enabled,
the protection info for the unmapped region is remain unchanged.
So READ command for the region later on causes data integrity failure.

This fixes it by invalidating protection info for the unmapped region
by filling with 0xff pattern.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Acked-by: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
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

