From: Paul Guo <ggang@tilera.com>
Subject: [SCSI] mvsas: Fix the kernel panic due to unaligned data access
Date: Wed, 8 May 2013 15:01:56 +0800
Message-ID: <5189F864.5080808@tilera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usmamail.tilera.com ([12.216.194.151]:46663 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3EHHCB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 May 2013 03:02:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org
Cc: JBottomley@Parallels.com

It's easy to find the address and symbol that causes the unalignd data
access according to the stack dump information. The following small
patch will fix it.

This change is harmless for platforms (like x86/x64) which support
unaligned data access but is critical for platforms those do not support
unaligned data access (like our platform: arch/tile).

I sent the patch but did not ping the status. I sync-up the workspace
and re-generate the patch again. Feel free to give me any feedback. It's
really annoying to maintain the change internally.

Thanks,
Paul


Signed-off-by: Paul Guo <ggang@tilera.com>
---
 drivers/scsi/mvsas/mv_sas.c |    5 +++--
 drivers/scsi/mvsas/mv_sas.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index fd3b283..18e133e 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1852,10 +1852,11 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 	}
 
 	/* error info record present */
-	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
+	if (unlikely((rx_desc & RXQ_ERR) &&
+		      get_unaligned_le64((u64 *) slot->response))) {
 		mv_dprintk("port %d slot %d rx_desc %X has error info"
 			"%016llX.\n", slot->port->sas_port.id, slot_idx,
-			 rx_desc, (u64)(*(u64 *)slot->response));
+			 rx_desc, get_unaligned_le64((u64 *) slot->response));
 		tstat->stat = mvs_slot_err(mvi, task, slot_idx);
 		tstat->resp = SAS_TASK_COMPLETE;
 		goto out;
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index c04a4f5..c89c145 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -39,6 +39,7 @@
 #include <linux/irq.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/unaligned.h>
 #include <scsi/libsas.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
-- 
1.7.10.3

