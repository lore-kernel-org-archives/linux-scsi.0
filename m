From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 3/7] scsi_debug: fix duplicate dif_errors increment
Date: Wed, 26 Feb 2014 22:57:00 +0900
Message-ID: <1393423024-8063-4-git-send-email-akinobu.mita@gmail.com>
References: <1393423024-8063-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44259 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaBZN50 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Feb 2014 08:57:26 -0500
Received: by mail-pa0-f50.google.com with SMTP id kp14so998091pab.37
        for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2014 05:57:25 -0800 (PST)
In-Reply-To: <1393423024-8063-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

It is unnecessary to increase dif_errors in dif_verify(), because the
caller will increment it when dif_verify() detects failure.

This bug was introduced by commit beb40ea42bd6 ("[SCSI] scsi_debug:
reduce duplication between prot_verify_read and prot_verify_write")

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9cd211e..1a42880 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1780,7 +1780,6 @@ static int dif_verify(struct sd_dif_tuple *sdt, const void *data,
 	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
 		pr_err("%s: REF check failed on sector %lu\n",
 			__func__, (unsigned long)sector);
-			dif_errors++;
 		return 0x03;
 	}
 	return 0;
-- 
1.8.3.2

