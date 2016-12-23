From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] message: fusion: Use kmemdup instead of kmalloc and memcpy
Date: Sat, 24 Dec 2016 00:54:04 +0530
Message-ID: <1482521044-30178-1-git-send-email-mayhs11saini@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36070 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755225AbcLWTYT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Dec 2016 14:24:19 -0500
Received: by mail-pg0-f68.google.com with SMTP id n5so1372606pgh.3
        for <linux-scsi@vger.kernel.org>; Fri, 23 Dec 2016 11:24:19 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sathya.prakash@broadcom.com
Cc: chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-scsi@vger.kernel.org, Shyam Saini <mayhs11saini@gmail.com>

When some other buffer is immediately copied into allocated region.
Replace calls to kmalloc followed by a memcpy with a direct
call to kmemdup.

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/message/fusion/mptbase.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 1e73064..7b46462 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -5995,13 +5995,12 @@ mpt_findImVolumes(MPT_ADAPTER *ioc)
 	if (mpt_config(ioc, &cfg) != 0)
 		goto out;
 
-	mem = kmalloc(iocpage2sz, GFP_KERNEL);
+	mem = kmemdup((u8 *)pIoc2, iocpage2sz, GFP_KERNEL);
 	if (!mem) {
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	memcpy(mem, (u8 *)pIoc2, iocpage2sz);
 	ioc->raid_data.pIocPg2 = (IOCPage2_t *) mem;
 
 	mpt_read_ioc_pg_3(ioc);
-- 
2.7.4

