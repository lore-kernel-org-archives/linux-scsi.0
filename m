From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH] mptbase: use kmemdup
Date: Thu, 19 May 2016 19:20:47 +0530
Message-ID: <1463665851-16334-1-git-send-email-falakreyaz@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36850 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbcESNvC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2016 09:51:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Use kmemdup when some other buffer is immediately copied into allocated
region. It replaces call to allocation followed by memcpy, by a single
call to kmemdup.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 drivers/message/fusion/mptbase.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5537f8d..4cad96e 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -5997,13 +5997,12 @@ mpt_findImVolumes(MPT_ADAPTER *ioc)
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
1.9.1

