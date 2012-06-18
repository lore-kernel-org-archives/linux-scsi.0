From: Paul Guo <ggang@tilera.com>
Subject: [PATCH] Unaligned data access in mvsas causes panic
Date: Mon, 18 Jun 2012 21:49:22 +0800
Message-ID: <4FDF31E2.2090305@tilera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usmamail.tilera.com ([12.216.194.151]:48810 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2FRNtc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2012 09:49:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Xiangliang Yu <yuxiangl@marvell.com>

We encountered panic during stress tesing on our platform,
due to unaligned data access in the mvsas driver.


Signed-off-by: Paul Guo <ggang@tilera.com>
---
 drivers/scsi/mvsas/mv_sas.c |    5 +++--
 drivers/scsi/mvsas/mv_sas.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index fd3b283..be4989e 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1852,10 +1852,11 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 	}
 
 	/* error info record present */
-	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
+	if (unlikely((rx_desc & RXQ_ERR) &&
+		     get_unaligned_le64((u64 *) slot->response))) {
 		mv_dprintk("port %d slot %d rx_desc %X has error info"
 			"%016llX.\n", slot->port->sas_port.id, slot_idx,
-			 rx_desc, (u64)(*(u64 *)slot->response));
+			 rx_desc, get_unaligned_le64((u64 *)slot->response));
 		tstat->stat = mvs_slot_err(mvi, task, slot_idx);
 		tstat->resp = SAS_TASK_COMPLETE;
 		goto out;
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index c04a4f5..1bc093a 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -39,6 +39,7 @@
 #include <linux/irq.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <asm/unaligned.h>
 #include <scsi/libsas.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
-- 
1.7.10.3

