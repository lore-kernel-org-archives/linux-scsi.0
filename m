From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 21/22] sata_qstor: kill dummy BMDMA ops
Date: Tue, 21 Oct 2008 18:17:59 +0900
Message-ID: <1224580680-13698-22-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Now that SFF and BMDMA are completely separate, sata_qstor which
inherits from ata_sff_port_ops doesn't have anything to worry about
its BMDMA ops being called.  Kill the dummy BMDMA ops.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/sata_qstor.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 44ff556..5912f80 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -119,8 +119,6 @@ static void qs_host_stop(struct ata_host *host);
 static void qs_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int qs_qc_issue(struct ata_queued_cmd *qc);
 static int qs_check_atapi_dma(struct ata_queued_cmd *qc);
-static void qs_bmdma_stop(struct ata_queued_cmd *qc);
-static u8 qs_bmdma_status(struct ata_port *ap);
 static void qs_freeze(struct ata_port *ap);
 static void qs_thaw(struct ata_port *ap);
 static int qs_prereset(struct ata_link *link, unsigned long deadline);
@@ -136,8 +134,6 @@ static struct ata_port_operations qs_ata_ops = {
 	.inherits		= &ata_sff_port_ops,
 
 	.check_atapi_dma	= qs_check_atapi_dma,
-	.bmdma_stop		= qs_bmdma_stop,
-	.bmdma_status		= qs_bmdma_status,
 	.qc_prep		= qs_qc_prep,
 	.qc_issue		= qs_qc_issue,
 
@@ -188,16 +184,6 @@ static int qs_check_atapi_dma(struct ata_queued_cmd *qc)
 	return 1;	/* ATAPI DMA not supported */
 }
 
-static void qs_bmdma_stop(struct ata_queued_cmd *qc)
-{
-	/* nothing */
-}
-
-static u8 qs_bmdma_status(struct ata_port *ap)
-{
-	return 0;
-}
-
 static inline void qs_enter_reg_mode(struct ata_port *ap)
 {
 	u8 __iomem *chan = qs_mmio_base(ap->host) + (ap->port_no * 0x4000);
-- 
1.5.4.5

