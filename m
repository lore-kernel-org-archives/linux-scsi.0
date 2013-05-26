From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 3/6] scsi_debug: fix NULL pointer dereference with parameters dif=0 dix=1
Date: Sun, 26 May 2013 17:01:19 +0900
Message-ID: <1369555282-17864-4-git-send-email-akinobu.mita@gmail.com>
References: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:64637 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206Ab3EZIBw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 May 2013 04:01:52 -0400
Received: by mail-pd0-f181.google.com with SMTP id bv13so3711558pdb.26
        for <linux-scsi@vger.kernel.org>; Sun, 26 May 2013 01:01:52 -0700 (PDT)
In-Reply-To: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
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
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Acked-by: "Martin K. Petersen" <martin.petersen@oracle.com>
---

* No changes from v1

 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index bcf73e4..e83e661 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3372,7 +3372,7 @@ static int __init scsi_debug_init(void)
 	if (scsi_debug_num_parts > 0)
 		sdebug_build_parts(fake_storep, sz);
 
-	if (scsi_debug_dif) {
+	if (scsi_debug_dix) {
 		int dif_size;
 
 		dif_size = sdebug_store_sectors * sizeof(struct sd_dif_tuple);
-- 
1.8.1.4

