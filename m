From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/3] scsi_debug: fix NULL pointer dereference with parameters dif=0 dix=1
Date: Sun, 21 Apr 2013 18:17:58 +0900
Message-ID: <1366535879-20775-3-git-send-email-akinobu.mita@gmail.com>
References: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:62307 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3DUJS3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Apr 2013 05:18:29 -0400
Received: by mail-da0-f53.google.com with SMTP id n34so105697dal.12
        for <linux-scsi@vger.kernel.org>; Sun, 21 Apr 2013 02:18:28 -0700 (PDT)
In-Reply-To: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

The protection info dif_storep is allocated only when parameter dif is
not zero.  But it will be accessed when reading or writing to the storage
installed with parameter dix is not zero.

So kernel crashes if scsi_debug module is loaded with parameters dix=1 and
dif=0.

This fixes it by making dif_storep available if parameter dix is not zero
instead of checking if parameter dif is not zero.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8fd30a5..ffbdb4c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3306,7 +3306,7 @@ static int __init scsi_debug_init(void)
 	if (scsi_debug_num_parts > 0)
 		sdebug_build_parts(fake_storep, sz);
 
-	if (scsi_debug_dif) {
+	if (scsi_debug_dix) {
 		int dif_size;
 
 		dif_size = sdebug_store_sectors * sizeof(struct sd_dif_tuple);
-- 
1.8.1.4

