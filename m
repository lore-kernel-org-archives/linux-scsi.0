From: Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH] mvsas: fix unaligned-access kernel panic under heavy disk testing
Date: Tue, 23 Jul 2013 16:50:12 -0400
Message-ID: <201307232053.r6NKrkOh032171@farm-0012.internal.tilera.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Jianpeng Ma <majianpeng@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Xi Wang <xi.wang@gmail.com>, Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The slot->response value may not be aligned, so should be read
using the appropriate kernel "unaligned" accessor.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/scsi/mvsas/mv_sas.c | 5 +++--
 drivers/scsi/mvsas/mv_sas.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index f14665a..66aaa87 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1858,10 +1858,11 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 	}
 
 	/* error info record present */
-	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
+	if (unlikely((rx_desc & RXQ_ERR) &&
+		     get_unaligned_le64((u64 *) slot->response))) {
 		mv_dprintk("port %d slot %d rx_desc %X has error info"
 			"%016llX.\n", slot->port->sas_port.id, slot_idx,
-			 rx_desc, (u64)(*(u64 *)slot->response));
+			rx_desc, get_unaligned_le64((u64 *)slot->response));
 		tstat->stat = mvs_slot_err(mvi, task, slot_idx);
 		tstat->resp = SAS_TASK_COMPLETE;
 		goto out;
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 60e2fb7..d6b19dc 100644
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
1.8.3.1
