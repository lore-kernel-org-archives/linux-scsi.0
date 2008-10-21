From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/22] libata-sff: ata_sff_[dumb_]qc_prep are BMDMA specific
Date: Tue, 21 Oct 2008 18:17:53 +0900
Message-ID: <1224580680-13698-16-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:46066 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYJUJU6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 05:20:58 -0400
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>

Both qc_prep functions deal only with BMDMA PRD setup and PIO only SFF
drivers don't need them.  Move and rename to
ata_bmdma_[dumb_]qc_prep().

All usages are renamed except for pdc_adma and sata_qstor.  Those two
drivers are not BMDMA drivers and don't need to call BMDMA qc_prep
functions.  Calls to ata_sff_qc_prep() in the two drivers are removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-sff.c  |  288 +++++++++++++++++++++++----------------------
 drivers/ata/pata_atiixp.c |    2 +-
 drivers/ata/pata_cs5520.c |    2 +-
 drivers/ata/pata_cs5530.c |    2 +-
 drivers/ata/pata_sc1200.c |    2 +-
 drivers/ata/pdc_adma.c    |    4 +-
 drivers/ata/sata_nv.c     |    4 +-
 drivers/ata/sata_qstor.c  |    4 +-
 include/linux/libata.h    |    4 +-
 9 files changed, 155 insertions(+), 157 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index a7d35b6..ac041e2 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -44,7 +44,7 @@ static struct workqueue_struct *ata_sff_wq;
 const struct ata_port_operations ata_sff_port_ops = {
 	.inherits		= &ata_base_port_ops,
 
-	.qc_prep		= ata_sff_qc_prep,
+	.qc_prep		= ata_noop_qc_prep,
 	.qc_issue		= ata_sff_qc_issue,
 	.qc_fill_rtf		= ata_sff_qc_fill_rtf,
 
@@ -66,146 +66,6 @@ const struct ata_port_operations ata_sff_port_ops = {
 };
 
 /**
- *	ata_fill_sg - Fill PCI IDE PRD table
- *	@qc: Metadata associated with taskfile to be transferred
- *
- *	Fill PCI IDE PRD (scatter-gather) table with segments
- *	associated with the current disk command.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- *
- */
-static void ata_fill_sg(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct scatterlist *sg;
-	unsigned int si, pi;
-
-	pi = 0;
-	for_each_sg(qc->sg, sg, qc->n_elem, si) {
-		u32 addr, offset;
-		u32 sg_len, len;
-
-		/* determine if physical DMA addr spans 64K boundary.
-		 * Note h/w doesn't support 64-bit, so we unconditionally
-		 * truncate dma_addr_t to u32.
-		 */
-		addr = (u32) sg_dma_address(sg);
-		sg_len = sg_dma_len(sg);
-
-		while (sg_len) {
-			offset = addr & 0xffff;
-			len = sg_len;
-			if ((offset + sg_len) > 0x10000)
-				len = 0x10000 - offset;
-
-			ap->prd[pi].addr = cpu_to_le32(addr);
-			ap->prd[pi].flags_len = cpu_to_le32(len & 0xffff);
-			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, len);
-
-			pi++;
-			sg_len -= len;
-			addr += len;
-		}
-	}
-
-	ap->prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
-}
-
-/**
- *	ata_fill_sg_dumb - Fill PCI IDE PRD table
- *	@qc: Metadata associated with taskfile to be transferred
- *
- *	Fill PCI IDE PRD (scatter-gather) table with segments
- *	associated with the current disk command. Perform the fill
- *	so that we avoid writing any length 64K records for
- *	controllers that don't follow the spec.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- *
- */
-static void ata_fill_sg_dumb(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct scatterlist *sg;
-	unsigned int si, pi;
-
-	pi = 0;
-	for_each_sg(qc->sg, sg, qc->n_elem, si) {
-		u32 addr, offset;
-		u32 sg_len, len, blen;
-
-		/* determine if physical DMA addr spans 64K boundary.
-		 * Note h/w doesn't support 64-bit, so we unconditionally
-		 * truncate dma_addr_t to u32.
-		 */
-		addr = (u32) sg_dma_address(sg);
-		sg_len = sg_dma_len(sg);
-
-		while (sg_len) {
-			offset = addr & 0xffff;
-			len = sg_len;
-			if ((offset + sg_len) > 0x10000)
-				len = 0x10000 - offset;
-
-			blen = len & 0xffff;
-			ap->prd[pi].addr = cpu_to_le32(addr);
-			if (blen == 0) {
-			   /* Some PATA chipsets like the CS5530 can't
-			      cope with 0x0000 meaning 64K as the spec says */
-				ap->prd[pi].flags_len = cpu_to_le32(0x8000);
-				blen = 0x8000;
-				ap->prd[++pi].addr = cpu_to_le32(addr + 0x8000);
-			}
-			ap->prd[pi].flags_len = cpu_to_le32(blen);
-			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, len);
-
-			pi++;
-			sg_len -= len;
-			addr += len;
-		}
-	}
-
-	ap->prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
-}
-
-/**
- *	ata_sff_qc_prep - Prepare taskfile for submission
- *	@qc: Metadata associated with taskfile to be prepared
- *
- *	Prepare ATA taskfile for submission.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_sff_qc_prep(struct ata_queued_cmd *qc)
-{
-	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
-		return;
-
-	ata_fill_sg(qc);
-}
-
-/**
- *	ata_sff_dumb_qc_prep - Prepare taskfile for submission
- *	@qc: Metadata associated with taskfile to be prepared
- *
- *	Prepare ATA taskfile for submission.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_sff_dumb_qc_prep(struct ata_queued_cmd *qc)
-{
-	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
-		return;
-
-	ata_fill_sg_dumb(qc);
-}
-
-/**
  *	ata_sff_check_status - Read device status reg & clear interrupt
  *	@ap: port where the device is
  *
@@ -2510,6 +2370,8 @@ const struct ata_port_operations ata_bmdma_port_ops = {
 	.error_handler		= ata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 
+	.qc_prep		= ata_bmdma_qc_prep,
+
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
 	.bmdma_stop		= ata_bmdma_stop,
@@ -2519,6 +2381,146 @@ const struct ata_port_operations ata_bmdma_port_ops = {
 };
 
 /**
+ *	ata_bmdma_fill_sg - Fill PCI IDE PRD table
+ *	@qc: Metadata associated with taskfile to be transferred
+ *
+ *	Fill PCI IDE PRD (scatter-gather) table with segments
+ *	associated with the current disk command.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ */
+static void ata_bmdma_fill_sg(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct scatterlist *sg;
+	unsigned int si, pi;
+
+	pi = 0;
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		u32 addr, offset;
+		u32 sg_len, len;
+
+		/* determine if physical DMA addr spans 64K boundary.
+		 * Note h/w doesn't support 64-bit, so we unconditionally
+		 * truncate dma_addr_t to u32.
+		 */
+		addr = (u32) sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
+
+		while (sg_len) {
+			offset = addr & 0xffff;
+			len = sg_len;
+			if ((offset + sg_len) > 0x10000)
+				len = 0x10000 - offset;
+
+			ap->prd[pi].addr = cpu_to_le32(addr);
+			ap->prd[pi].flags_len = cpu_to_le32(len & 0xffff);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, len);
+
+			pi++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	ap->prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+}
+
+/**
+ *	ata_bmdma_fill_sg_dumb - Fill PCI IDE PRD table
+ *	@qc: Metadata associated with taskfile to be transferred
+ *
+ *	Fill PCI IDE PRD (scatter-gather) table with segments
+ *	associated with the current disk command. Perform the fill
+ *	so that we avoid writing any length 64K records for
+ *	controllers that don't follow the spec.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ */
+static void ata_bmdma_fill_sg_dumb(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct scatterlist *sg;
+	unsigned int si, pi;
+
+	pi = 0;
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		u32 addr, offset;
+		u32 sg_len, len, blen;
+
+		/* determine if physical DMA addr spans 64K boundary.
+		 * Note h/w doesn't support 64-bit, so we unconditionally
+		 * truncate dma_addr_t to u32.
+		 */
+		addr = (u32) sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
+
+		while (sg_len) {
+			offset = addr & 0xffff;
+			len = sg_len;
+			if ((offset + sg_len) > 0x10000)
+				len = 0x10000 - offset;
+
+			blen = len & 0xffff;
+			ap->prd[pi].addr = cpu_to_le32(addr);
+			if (blen == 0) {
+			   /* Some PATA chipsets like the CS5530 can't
+			      cope with 0x0000 meaning 64K as the spec says */
+				ap->prd[pi].flags_len = cpu_to_le32(0x8000);
+				blen = 0x8000;
+				ap->prd[++pi].addr = cpu_to_le32(addr + 0x8000);
+			}
+			ap->prd[pi].flags_len = cpu_to_le32(blen);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, len);
+
+			pi++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	ap->prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+}
+
+/**
+ *	ata_bmdma_qc_prep - Prepare taskfile for submission
+ *	@qc: Metadata associated with taskfile to be prepared
+ *
+ *	Prepare ATA taskfile for submission.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_bmdma_qc_prep(struct ata_queued_cmd *qc)
+{
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	ata_bmdma_fill_sg(qc);
+}
+
+/**
+ *	ata_bmdma_dumb_qc_prep - Prepare taskfile for submission
+ *	@qc: Metadata associated with taskfile to be prepared
+ *
+ *	Prepare ATA taskfile for submission.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_bmdma_dumb_qc_prep(struct ata_queued_cmd *qc)
+{
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	ata_bmdma_fill_sg_dumb(qc);
+}
+
+/**
  *	ata_bmdma_error_handler - Stock error handler for BMDMA controller
  *	@ap: port to handle error for
  *
@@ -2878,8 +2880,6 @@ void __exit ata_sff_exit(void)
 }
 
 EXPORT_SYMBOL_GPL(ata_sff_port_ops);
-EXPORT_SYMBOL_GPL(ata_sff_qc_prep);
-EXPORT_SYMBOL_GPL(ata_sff_dumb_qc_prep);
 EXPORT_SYMBOL_GPL(ata_sff_dev_select);
 EXPORT_SYMBOL_GPL(ata_sff_check_status);
 EXPORT_SYMBOL_GPL(ata_sff_dma_pause);
@@ -2915,6 +2915,8 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
 #endif /* CONFIG_PCI */
 EXPORT_SYMBOL_GPL(ata_bus_reset);
 EXPORT_SYMBOL_GPL(ata_bmdma_port_ops);
+EXPORT_SYMBOL_GPL(ata_bmdma_qc_prep);
+EXPORT_SYMBOL_GPL(ata_bmdma_dumb_qc_prep);
 EXPORT_SYMBOL_GPL(ata_bmdma_error_handler);
 EXPORT_SYMBOL_GPL(ata_bmdma_post_internal_cmd);
 EXPORT_SYMBOL_GPL(ata_bmdma_setup);
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index e8a0d99..3fae282 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -223,7 +223,7 @@ static struct scsi_host_template atiixp_sht = {
 static struct ata_port_operations atiixp_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 
-	.qc_prep 	= ata_sff_dumb_qc_prep,
+	.qc_prep 	= ata_bmdma_dumb_qc_prep,
 	.bmdma_start 	= atiixp_bmdma_start,
 	.bmdma_stop	= atiixp_bmdma_stop,
 
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 1186bcd..d5fe2b1 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -146,7 +146,7 @@ static struct scsi_host_template cs5520_sht = {
 
 static struct ata_port_operations cs5520_port_ops = {
 	.inherits		= &ata_bmdma_port_ops,
-	.qc_prep		= ata_sff_dumb_qc_prep,
+	.qc_prep		= ata_bmdma_dumb_qc_prep,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= cs5520_set_piomode,
 	.set_dmamode		= cs5520_set_dmamode,
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index 0c4b271..6dae09a 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -168,7 +168,7 @@ static struct scsi_host_template cs5530_sht = {
 static struct ata_port_operations cs5530_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 
-	.qc_prep 	= ata_sff_dumb_qc_prep,
+	.qc_prep 	= ata_bmdma_dumb_qc_prep,
 	.qc_issue	= cs5530_qc_issue,
 
 	.cable_detect	= ata_cable_40wire,
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 0278fd2..cee8eb9 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -185,7 +185,7 @@ static struct scsi_host_template sc1200_sht = {
 
 static struct ata_port_operations sc1200_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
-	.qc_prep 	= ata_sff_dumb_qc_prep,
+	.qc_prep 	= ata_bmdma_dumb_qc_prep,
 	.qc_issue	= sc1200_qc_issue,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= sc1200_set_piomode,
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 943f204..17fd1d5 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -321,10 +321,8 @@ static void adma_qc_prep(struct ata_queued_cmd *qc)
 	VPRINTK("ENTER\n");
 
 	adma_enter_reg_mode(qc->ap);
-	if (qc->tf.protocol != ATA_PROT_DMA) {
-		ata_sff_qc_prep(qc);
+	if (qc->tf.protocol != ATA_PROT_DMA)
 		return;
-	}
 
 	buf[i++] = 0;	/* Response flags */
 	buf[i++] = 0;	/* reserved */
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 1e67c17..72a8630 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1354,7 +1354,7 @@ static void nv_adma_qc_prep(struct ata_queued_cmd *qc)
 		BUG_ON(!(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) &&
 			(qc->flags & ATA_QCFLAG_DMAMAP));
 		nv_adma_register_mode(qc->ap);
-		ata_sff_qc_prep(qc);
+		ata_bmdma_qc_prep(qc);
 		return;
 	}
 
@@ -1937,7 +1937,7 @@ static int nv_swncq_port_start(struct ata_port *ap)
 static void nv_swncq_qc_prep(struct ata_queued_cmd *qc)
 {
 	if (qc->tf.protocol != ATA_PROT_NCQ) {
-		ata_sff_qc_prep(qc);
+		ata_bmdma_qc_prep(qc);
 		return;
 	}
 
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index a130c83..b8783bc 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -301,10 +301,8 @@ static void qs_qc_prep(struct ata_queued_cmd *qc)
 	VPRINTK("ENTER\n");
 
 	qs_enter_reg_mode(qc->ap);
-	if (qc->tf.protocol != ATA_PROT_DMA) {
-		ata_sff_qc_prep(qc);
+	if (qc->tf.protocol != ATA_PROT_DMA)
 		return;
-	}
 
 	nelem = qs_fill_sg(qc);
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index f53f828..197ce14 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1483,8 +1483,6 @@ extern const struct ata_port_operations ata_bmdma_port_ops;
 	.sg_tablesize		= LIBATA_MAX_PRD,		\
 	.dma_boundary		= ATA_DMA_BOUNDARY
 
-extern void ata_sff_qc_prep(struct ata_queued_cmd *qc);
-extern void ata_sff_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sff_dev_select(struct ata_port *ap, unsigned int device);
 extern u8 ata_sff_check_status(struct ata_port *ap);
 extern void ata_sff_pause(struct ata_port *ap);
@@ -1537,6 +1535,8 @@ extern int ata_pci_sff_init_one(struct pci_dev *pdev,
 
 extern void ata_bus_reset(struct ata_port *ap);		/* deprecated */
 
+extern void ata_bmdma_qc_prep(struct ata_queued_cmd *qc);
+extern void ata_bmdma_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_bmdma_error_handler(struct ata_port *ap);
 extern void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc);
 extern void ata_bmdma_setup(struct ata_queued_cmd *qc);
-- 
1.5.4.5

