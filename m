From: akpm@osdl.org
Subject: [patch 10/17] scsi/megaraid/megaraid_mm.c: fix a NULL pointer dereference
Date: Tue, 18 Apr 2006 21:09:18 -0700
Message-ID: <200604190409.k3J49xpI008230@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:6862 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750801AbWDSENN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 00:13:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de


From: Adrian Bunk <bunk@stusta.de>

This patch fixes a NULL pointer dereference spotted by the Coverity
checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid/megaraid_mm.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/megaraid/megaraid_mm.c~scsi-megaraid-megaraid_mmc-fix-a-null-pointer-dereference drivers/scsi/megaraid/megaraid_mm.c
--- devel/drivers/scsi/megaraid/megaraid_mm.c~scsi-megaraid-megaraid_mmc-fix-a-null-pointer-dereference	2006-03-21 23:05:42.000000000 -0800
+++ devel-akpm/drivers/scsi/megaraid/megaraid_mm.c	2006-03-21 23:05:42.000000000 -0800
@@ -898,10 +898,8 @@ mraid_mm_register_adp(mraid_mmadp_t *lld
 
 	adapter = kmalloc(sizeof(mraid_mmadp_t), GFP_KERNEL);
 
-	if (!adapter) {
-		rval = -ENOMEM;
-		goto memalloc_error;
-	}
+	if (!adapter)
+		return -ENOMEM;
 
 	memset(adapter, 0, sizeof(mraid_mmadp_t));
 
_
