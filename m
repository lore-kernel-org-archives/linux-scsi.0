From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 1/5] scsi_debug: fix invalid address passed to kunmap_atomic()
Date: Sun, 19 May 2013 22:42:05 +0900
Message-ID: <1368970929-20006-2-git-send-email-akinobu.mita@gmail.com>
References: <1368970929-20006-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:53667 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3ESNme (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 May 2013 09:42:34 -0400
Received: by mail-pd0-f179.google.com with SMTP id q10so4636203pdj.38
        for <linux-scsi@vger.kernel.org>; Sun, 19 May 2013 06:42:33 -0700 (PDT)
In-Reply-To: <1368970929-20006-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

In the function prot_verify_write(), the kmap address 'daddr' is
incremented in the loop for each data page.  Finally 'daddr' reaches
the next page boundary in the end of the loop, and the invalid address
is passed to kunmap_atomic().

Fix it by passing original value to kunmap_atomic().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
---

* New patch from v2
- Splitted from the patch "fix data integrity support on highmem machine" in v1

 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0a537a0..caf6a94 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1981,7 +1981,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			ppage_offset += sizeof(struct sd_dif_tuple);
 		}
 
-		kunmap_atomic(daddr);
+		kunmap_atomic(daddr - dsgl->length);
 	}
 
 	kunmap_atomic(paddr);
-- 
1.8.1.4

