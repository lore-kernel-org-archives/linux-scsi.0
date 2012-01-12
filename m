From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 7/15] drivers/scsi/mvsas/mv_init.c: add missing iounmap
Date: Thu, 12 Jan 2012 10:55:09 +0100
Message-ID: <1326362117-29371-7-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:41639 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab2ALJzb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2012 04:55:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Add missing iounmap in error handling code, in a case where the function
already preforms iounmap on some other execution path.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
statement S,S1;
int ret;
@@
e = \(ioremap\|ioremap_nocache\)(...)
... when != iounmap(e)
if (<+...e...+>) S
... when any
    when != iounmap(e)
*if (...)
   { ... when != iounmap(e)
     return ...; }
... when any
iounmap(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
This changes the semantics at the point of the first change, as it
introduces the setting of mvi->regs_ex to NULL.  I do not know if this is
correct.

It also assumes that if mvi->regs_ex is non-null, then bar_ex != -1.
This seems to be already assumed in the second block of error handling code.

 drivers/scsi/mvsas/mv_init.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 6f58919..adfd11f 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -350,7 +350,7 @@ int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
 	res_start = pci_resource_start(pdev, bar);
 	res_len = pci_resource_len(pdev, bar);
 	if (!res_start || !res_len)
-		goto err_out;
+		goto err_unmap;
 
 	res_flag = pci_resource_flags(pdev, bar);
 	if (res_flag & IORESOURCE_CACHEABLE)
@@ -358,14 +358,15 @@ int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
 	else
 		mvi->regs = ioremap_nocache(res_start, res_len);
 
-	if (!mvi->regs) {
-		if (mvi->regs_ex && (res_flag_ex & IORESOURCE_MEM))
-			iounmap(mvi->regs_ex);
-		mvi->regs_ex = NULL;
-		goto err_out;
-	}
+	if (!mvi->regs)
+		goto err_unmap;
 
 	return 0;
+err_unmap:
+	if (mvi->regs_ex && (res_flag_ex & IORESOURCE_MEM))
+		iounmap(mvi->regs_ex);
+	mvi->regs_ex = NULL;
+
 err_out:
 	return -1;
 }

