From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/6] scsi_debug: fix duplicate dif_errors increment
Date: Mon,  6 Jan 2014 08:33:09 +0900
Message-ID: <1388964792-3546-4-git-send-email-akinobu.mita@gmail.com>
References: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53849 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaAEXdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jan 2014 18:33:31 -0500
Received: by mail-pd0-f174.google.com with SMTP id x10so17227151pdj.5
        for <linux-scsi@vger.kernel.org>; Sun, 05 Jan 2014 15:33:30 -0800 (PST)
In-Reply-To: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

It is unnecessary to increase dif_errors in dif_verify(), because the
caller will increment it when dif_verify() detects failure.

This bug was introduced by commit beb40ea42bd6 ("[SCSI] scsi_debug:
reduce duplication between prot_verify_read and prot_verify_write")

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
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

