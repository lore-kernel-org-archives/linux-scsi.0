From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/22] libata-sff: prd is BMDMA specific
Date: Tue, 21 Oct 2008 18:17:54 +0900
Message-ID: <1224580680-13698-17-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

struct ata_prd and ap->prd are BMDMA specific.  Add bmdma_ prefix to
them and move them inside CONFIG_ATA_SFF.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-sff.c   |   27 +++++++++++++++------------
 drivers/ata/pata_ns87415.c |    2 +-
 drivers/ata/pata_scc.c     |    4 ++--
 drivers/ata/sata_nv.c      |    4 ++--
 drivers/ata/sata_promise.c |   21 +++++++++++----------
 drivers/ata/sata_svw.c     |    2 +-
 include/linux/ata.h        |    2 +-
 include/linux/libata.h     |    2 ++
 8 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index ac041e2..de03c0b 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2394,6 +2394,7 @@ const struct ata_port_operations ata_bmdma_port_ops = {
 static void ata_bmdma_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
+	struct ata_bmdma_prd *prd = ap->bmdma_prd;
 	struct scatterlist *sg;
 	unsigned int si, pi;
 
@@ -2415,8 +2416,8 @@ static void ata_bmdma_fill_sg(struct ata_queued_cmd *qc)
 			if ((offset + sg_len) > 0x10000)
 				len = 0x10000 - offset;
 
-			ap->prd[pi].addr = cpu_to_le32(addr);
-			ap->prd[pi].flags_len = cpu_to_le32(len & 0xffff);
+			prd[pi].addr = cpu_to_le32(addr);
+			prd[pi].flags_len = cpu_to_le32(len & 0xffff);
 			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, len);
 
 			pi++;
@@ -2425,7 +2426,7 @@ static void ata_bmdma_fill_sg(struct ata_queued_cmd *qc)
 		}
 	}
 
-	ap->prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+	prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
 }
 
 /**
@@ -2444,6 +2445,7 @@ static void ata_bmdma_fill_sg(struct ata_queued_cmd *qc)
 static void ata_bmdma_fill_sg_dumb(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
+	struct ata_bmdma_prd *prd = ap->bmdma_prd;
 	struct scatterlist *sg;
 	unsigned int si, pi;
 
@@ -2466,15 +2468,15 @@ static void ata_bmdma_fill_sg_dumb(struct ata_queued_cmd *qc)
 				len = 0x10000 - offset;
 
 			blen = len & 0xffff;
-			ap->prd[pi].addr = cpu_to_le32(addr);
+			prd[pi].addr = cpu_to_le32(addr);
 			if (blen == 0) {
 			   /* Some PATA chipsets like the CS5530 can't
 			      cope with 0x0000 meaning 64K as the spec says */
-				ap->prd[pi].flags_len = cpu_to_le32(0x8000);
+				prd[pi].flags_len = cpu_to_le32(0x8000);
 				blen = 0x8000;
-				ap->prd[++pi].addr = cpu_to_le32(addr + 0x8000);
+				prd[++pi].addr = cpu_to_le32(addr + 0x8000);
 			}
-			ap->prd[pi].flags_len = cpu_to_le32(blen);
+			prd[pi].flags_len = cpu_to_le32(blen);
 			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, len);
 
 			pi++;
@@ -2483,7 +2485,7 @@ static void ata_bmdma_fill_sg_dumb(struct ata_queued_cmd *qc)
 		}
 	}
 
-	ap->prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+	prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
 }
 
 /**
@@ -2611,7 +2613,7 @@ void ata_bmdma_setup(struct ata_queued_cmd *qc)
 
 	/* load PRD table addr. */
 	mb();	/* make sure PRD table writes are visible to controller */
-	iowrite32(ap->prd_dma, ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
+	iowrite32(ap->bmdma_prd_dma, ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
 
 	/* specify data direction, triple-check start bit is clear */
 	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
@@ -2711,9 +2713,10 @@ u8 ata_bmdma_status(struct ata_port *ap)
 int ata_bmdma_port_start(struct ata_port *ap)
 {
 	if (ap->mwdma_mask || ap->udma_mask) {
-		ap->prd = dmam_alloc_coherent(ap->host->dev, ATA_PRD_TBL_SZ,
-					      &ap->prd_dma, GFP_KERNEL);
-		if (!ap->prd)
+		ap->bmdma_prd =
+			dmam_alloc_coherent(ap->host->dev, ATA_PRD_TBL_SZ,
+					    &ap->bmdma_prd_dma, GFP_KERNEL);
+		if (!ap->bmdma_prd)
 			return -ENOMEM;
 	}
 
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index e0aa7ea..260e0b0 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -126,7 +126,7 @@ static void ns87415_bmdma_setup(struct ata_queued_cmd *qc)
 
 	/* load PRD table addr. */
 	mb();	/* make sure PRD table writes are visible to controller */
-	iowrite32(ap->prd_dma, ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
+	iowrite32(ap->bmdma_prd_dma, ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
 
 	/* specify data direction, triple-check start bit is clear */
 	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 46a62f2..c96b090 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -431,7 +431,7 @@ static void scc_bmdma_setup (struct ata_queued_cmd *qc)
 	void __iomem *mmio = ap->ioaddr.bmdma_addr;
 
 	/* load PRD table addr */
-	out_be32(mmio + SCC_DMA_TABLE_OFS, ap->prd_dma);
+	out_be32(mmio + SCC_DMA_TABLE_OFS, ap->bmdma_prd_dma);
 
 	/* specify data direction, triple-check start bit is clear */
 	dmactl = in_be32(mmio + SCC_DMA_CMD);
@@ -944,7 +944,7 @@ static int scc_port_start (struct ata_port *ap)
 	if (rc)
 		return rc;
 
-	out_be32(mmio + SCC_DMA_PTERADD, ap->prd_dma);
+	out_be32(mmio + SCC_DMA_PTERADD, ap->bmdma_prd_dma);
 	return 0;
 }
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 72a8630..e30ce2e 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -271,7 +271,7 @@ enum ncq_saw_flag_list {
 };
 
 struct nv_swncq_port_priv {
-	struct ata_prd	*prd;	 /* our SG list */
+	struct ata_bmdma_prd *prd;	 /* our SG list */
 	dma_addr_t	prd_dma; /* and its DMA mapping */
 	void __iomem	*sactive_block;
 	void __iomem	*irq_block;
@@ -1952,7 +1952,7 @@ static void nv_swncq_fill_sg(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg;
 	struct nv_swncq_port_priv *pp = ap->private_data;
-	struct ata_prd *prd;
+	struct ata_bmdma_prd *prd;
 	unsigned int si, idx;
 
 	prd = pp->prd + ATA_MAX_PRD * qc->tag;
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index d65b5a6..4d7a400 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -408,7 +408,7 @@ static int pdc_sata_scr_write(struct ata_link *link,
 static void pdc_atapi_pkt(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	dma_addr_t sg_table = ap->prd_dma;
+	dma_addr_t sg_table = ap->bmdma_prd_dma;
 	unsigned int cdb_len = qc->dev->cdb_len;
 	u8 *cdb = qc->cdb;
 	struct pdc_port_priv *pp = ap->private_data;
@@ -496,6 +496,7 @@ static void pdc_atapi_pkt(struct ata_queued_cmd *qc)
 static void pdc_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
+	struct ata_bmdma_prd *prd = ap->bmdma_prd;
 	struct scatterlist *sg;
 	const u32 SG_COUNT_ASIC_BUG = 41*4;
 	unsigned int si, idx;
@@ -522,8 +523,8 @@ static void pdc_fill_sg(struct ata_queued_cmd *qc)
 			if ((offset + sg_len) > 0x10000)
 				len = 0x10000 - offset;
 
-			ap->prd[idx].addr = cpu_to_le32(addr);
-			ap->prd[idx].flags_len = cpu_to_le32(len & 0xffff);
+			prd[idx].addr = cpu_to_le32(addr);
+			prd[idx].flags_len = cpu_to_le32(len & 0xffff);
 			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
 
 			idx++;
@@ -532,27 +533,27 @@ static void pdc_fill_sg(struct ata_queued_cmd *qc)
 		}
 	}
 
-	len = le32_to_cpu(ap->prd[idx - 1].flags_len);
+	len = le32_to_cpu(prd[idx - 1].flags_len);
 
 	if (len > SG_COUNT_ASIC_BUG) {
 		u32 addr;
 
 		VPRINTK("Splitting last PRD.\n");
 
-		addr = le32_to_cpu(ap->prd[idx - 1].addr);
-		ap->prd[idx - 1].flags_len = cpu_to_le32(len - SG_COUNT_ASIC_BUG);
+		addr = le32_to_cpu(prd[idx - 1].addr);
+		prd[idx - 1].flags_len = cpu_to_le32(len - SG_COUNT_ASIC_BUG);
 		VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx - 1, addr, SG_COUNT_ASIC_BUG);
 
 		addr = addr + len - SG_COUNT_ASIC_BUG;
 		len = SG_COUNT_ASIC_BUG;
-		ap->prd[idx].addr = cpu_to_le32(addr);
-		ap->prd[idx].flags_len = cpu_to_le32(len);
+		prd[idx].addr = cpu_to_le32(addr);
+		prd[idx].flags_len = cpu_to_le32(len);
 		VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
 
 		idx++;
 	}
 
-	ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+	prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
 }
 
 static void pdc_qc_prep(struct ata_queued_cmd *qc)
@@ -567,7 +568,7 @@ static void pdc_qc_prep(struct ata_queued_cmd *qc)
 		pdc_fill_sg(qc);
 		/*FALLTHROUGH*/
 	case ATA_PROT_NODATA:
-		i = pdc_pkt_header(&qc->tf, qc->ap->prd_dma,
+		i = pdc_pkt_header(&qc->tf, qc->ap->bmdma_prd_dma,
 				   qc->dev->devno, pp->pkt);
 		if (qc->tf.flags & ATA_TFLAG_LBA48)
 			i = pdc_prep_lba48(&qc->tf, pp->pkt, i);
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 609d147..43e0024 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -224,7 +224,7 @@ static void k2_bmdma_setup_mmio(struct ata_queued_cmd *qc)
 
 	/* load PRD table addr. */
 	mb();	/* make sure PRD table writes are visible to controller */
-	writel(ap->prd_dma, mmio + ATA_DMA_TABLE_OFS);
+	writel(ap->bmdma_prd_dma, mmio + ATA_DMA_TABLE_OFS);
 
 	/* specify data direction, triple-check start bit is clear */
 	dmactl = readb(mmio + ATA_DMA_CMD);
diff --git a/include/linux/ata.h b/include/linux/ata.h
index a53318b..a4e55f0 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -418,7 +418,7 @@ enum ata_ioctls {
 
 /* core structures */
 
-struct ata_prd {
+struct ata_bmdma_prd {
 	__le32			addr;
 	__le32			flags_len;
 };
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 197ce14..5256be0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -682,6 +682,8 @@ struct ata_port {
 	u8			ctl;	/* cache of ATA control register */
 	u8			last_ctl;	/* Cache last written value */
 	struct delayed_work	sff_pio_task;
+	struct ata_bmdma_prd	*bmdma_prd;	/* BMDMA SG list */
+	dma_addr_t		bmdma_prd_dma;	/* and its DMA mapping */
 #endif /* CONFIG_ATA_SFF */
 
 	unsigned int		pio_mask;
-- 
1.5.4.5

