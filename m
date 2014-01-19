From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 1/7] scsi_debug: fix false positive logical block reference tag check fail
Date: Sun, 19 Jan 2014 22:51:37 +0900
Message-ID: <1390139503-11519-2-git-send-email-akinobu.mita@gmail.com>
References: <1390139503-11519-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57432 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaASNv4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2014 08:51:56 -0500
Received: by mail-pd0-f176.google.com with SMTP id w10so547333pde.7
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2014 05:51:55 -0800 (PST)
In-Reply-To: <1390139503-11519-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <JBottomley@Parallels.com>

Reading partially unwritten sectors generates a false positive logical
block reference tag check failure when DIF is enabled.

This bug is caused by missing ei_lba increment in loop of dif_verify()
when unwritten sector is skipped.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org
---
No change from previous version

 drivers/scsi/scsi_debug.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2decc64..bdfb9be 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1832,7 +1832,7 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 	struct sd_dif_tuple *sdt;
 	sector_t sector;
 
-	for (i = 0; i < sectors; i++) {
+	for (i = 0; i < sectors; i++, ei_lba++) {
 		int ret;
 
 		sector = start_sec + i;
@@ -1846,8 +1846,6 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			dif_errors++;
 			return ret;
 		}
-
-		ei_lba++;
 	}
 
 	dif_copy_prot(SCpnt, start_sec, sectors, true);
-- 
1.8.3.2

