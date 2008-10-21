From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/22] pata_cmd640/bf54x/icside: fix inheritance
Date: Tue, 21 Oct 2008 18:17:47 +0900
Message-ID: <1224580680-13698-10-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

cmd640 is PIO only while bf54x and icside are BMDMAs.  Fix
inheritance.  bf54x and icside are quasi-BMDMA controllers which don't
use the standard BMDMA registers so they don't initialize bmdma_addr
and inherited from sff to avoid the default mode_filter which disables
DMA modes if bmdma_addr is not initialized.

This patch makes both drivers explicitly specify ->mode_filter to
ATA_OP_NULL while inheriting from ata_bmdma_port_ops.  These will be
removed by the next patch.

This patch makes all and only BMDMA drivers inherit from
ata_bmdma_port_ops to ease further SFF/BMDMA separation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/pata_bf54x.c  |    4 +++-
 drivers/ata/pata_cmd640.c |    4 ++--
 drivers/ata/pata_icside.c |    4 +++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index b833328..27cd40a 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1460,7 +1460,7 @@ static struct scsi_host_template bfin_sht = {
 };
 
 static struct ata_port_operations bfin_pata_ops = {
-	.inherits		= &ata_sff_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 
 	.set_piomode		= bfin_set_piomode,
 	.set_dmamode		= bfin_set_dmamode,
@@ -1490,6 +1490,8 @@ static struct ata_port_operations bfin_pata_ops = {
 
 	.port_start		= bfin_port_start,
 	.port_stop		= bfin_port_stop,
+
+	.mode_filter		= ATA_OP_NULL,	/* will be removed soon */
 };
 
 static struct ata_port_info bfin_port_info[] = {
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 2de30b9..4b2612b 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -166,11 +166,11 @@ static int cmd640_port_start(struct ata_port *ap)
 }
 
 static struct scsi_host_template cmd640_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
+	ATA_PIO_SHT(DRV_NAME),
 };
 
 static struct ata_port_operations cmd640_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_sff_port_ops,
 	/* In theory xfer_noirq is not needed once we kill the prefetcher */
 	.sff_data_xfer	= ata_sff_data_xfer_noirq,
 	.qc_issue	= cmd640_qc_issue,
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index cf9e984..f2623c6 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -333,7 +333,7 @@ static void pata_icside_postreset(struct ata_link *link, unsigned int *classes)
 }
 
 static struct ata_port_operations pata_icside_port_ops = {
-	.inherits		= &ata_sff_port_ops,
+	.inherits		= &ata_bmdma_port_ops,
 	/* no need to build any PRD tables for DMA */
 	.qc_prep		= ata_noop_qc_prep,
 	.sff_data_xfer		= ata_sff_data_xfer_noirq,
@@ -346,6 +346,8 @@ static struct ata_port_operations pata_icside_port_ops = {
 	.set_dmamode		= pata_icside_set_dmamode,
 	.postreset		= pata_icside_postreset,
 	.post_internal_cmd	= pata_icside_bmdma_stop,
+
+	.mode_filter		= ATA_OP_NULL,	/* will be removed soon */
 };
 
 static void __devinit
-- 
1.5.4.5

