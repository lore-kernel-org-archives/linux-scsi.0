From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 3/6] scsi_debug: fix NULL pointer dereference with parameters dif=0 dix=1
Date: Sat, 29 Jun 2013 17:59:16 +0900
Message-ID: <1372496359-21100-4-git-send-email-akinobu.mita@gmail.com>
References: <1372496359-21100-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48287 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab3F2JAO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Jun 2013 05:00:14 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so3258942pad.23
        for <linux-scsi@vger.kernel.org>; Sat, 29 Jun 2013 02:00:12 -0700 (PDT)
In-Reply-To: <1372496359-21100-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

The protection info dif_storep is allocated only when parameter dif is
not zero.  But it will be accessed when reading or writing to the storage
installed with parameter dix is not zero.

So kernel crashes if scsi_debug module is loaded with parameters dix=1 and
dif=0.

This fixes it by making dif_storep available if parameter dix is not zero
instead of checking if parameter dif is not zero.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Acked-by: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
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

