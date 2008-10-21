From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/22] libata-sff: ata_sff_irq_clear() is BMDMA specific
Date: Tue, 21 Oct 2008 18:17:56 +0900
Message-ID: <1224580680-13698-19-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:46069 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYJUJVA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 05:21:00 -0400
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>

ata_sff_irq_clear() is BMDMA specific.  Rename it to
ata_bmdma_irq_clear(), move it to ata_bmdma_port_ops and make
->sff_irq_clear() optional.

Note: ata_bmdma_irq_clear() is actually only needed by ata_piix and
      possibly by sata_sil.  This should be moved to respective low
      level drivers later.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-sff.c |   67 ++++++++++++++++++++++++++--------------------
 drivers/ata/pata_bf54x.c |    2 +-
 drivers/ata/pata_scc.c   |    2 +-
 drivers/ata/sata_nv.c    |    2 +-
 drivers/ata/sata_sil.c   |    4 +-
 drivers/ata/sata_via.c   |    2 +-
 include/linux/libata.h   |    2 +-
 7 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 197b8c3..96d93ce 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -62,7 +62,6 @@ const struct ata_port_operations ata_sff_port_ops = {
 	.sff_exec_command	= ata_sff_exec_command,
 	.sff_data_xfer		= ata_sff_data_xfer,
 	.sff_irq_on		= ata_sff_irq_on,
-	.sff_irq_clear		= ata_sff_irq_clear,
 };
 
 /**
@@ -356,33 +355,13 @@ u8 ata_sff_irq_on(struct ata_port *ap)
 		iowrite8(ap->ctl, ioaddr->ctl_addr);
 	tmp = ata_wait_idle(ap);
 
-	ap->ops->sff_irq_clear(ap);
+	if (ap->ops->sff_irq_clear)
+		ap->ops->sff_irq_clear(ap);
 
 	return tmp;
 }
 
 /**
- *	ata_sff_irq_clear - Clear PCI IDE BMDMA interrupt.
- *	@ap: Port associated with this ATA transaction.
- *
- *	Clear interrupt and error flags in DMA status register.
- *
- *	May be used as the irq_clear() entry in ata_port_operations.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_sff_irq_clear(struct ata_port *ap)
-{
-	void __iomem *mmio = ap->ioaddr.bmdma_addr;
-
-	if (!mmio)
-		return;
-
-	iowrite8(ioread8(mmio + ATA_DMA_STATUS), mmio + ATA_DMA_STATUS);
-}
-
-/**
  *	ata_sff_tf_load - send taskfile registers to host controller
  *	@ap: Port to which output is sent
  *	@tf: ATA taskfile register set
@@ -1422,7 +1401,8 @@ inline unsigned int ata_sff_host_intr(struct ata_port *ap,
 		goto idle_irq;
 
 	/* clear irq events */
-	ap->ops->sff_irq_clear(ap);
+	if (ap->ops->sff_irq_clear)
+		ap->ops->sff_irq_clear(ap);
 
 	ata_sff_hsm_move(ap, qc, status, 0);
 
@@ -1438,7 +1418,8 @@ idle_irq:
 #ifdef ATA_IRQ_TRAP
 	if ((ap->stats.idle_irq % 1000) == 0) {
 		ap->ops->sff_check_status(ap);
-		ap->ops->sff_irq_clear(ap);
+		if (ap->ops->sff_irq_clear)
+			ap->ops->sff_irq_clear(ap);
 		ata_port_printk(ap, KERN_WARNING, "irq trap\n");
 		return 1;
 	}
@@ -1509,7 +1490,8 @@ void ata_sff_freeze(struct ata_port *ap)
 	 */
 	ap->ops->sff_check_status(ap);
 
-	ap->ops->sff_irq_clear(ap);
+	if (ap->ops->sff_irq_clear)
+		ap->ops->sff_irq_clear(ap);
 }
 
 /**
@@ -1525,7 +1507,8 @@ void ata_sff_thaw(struct ata_port *ap)
 {
 	/* clear & re-enable interrupts */
 	ap->ops->sff_check_status(ap);
-	ap->ops->sff_irq_clear(ap);
+	if (ap->ops->sff_irq_clear)
+		ap->ops->sff_irq_clear(ap);
 	ap->ops->sff_irq_on(ap);
 }
 
@@ -2333,6 +2316,7 @@ const struct ata_port_operations ata_bmdma_port_ops = {
 	.qc_prep		= ata_bmdma_qc_prep,
 	.qc_issue		= ata_bmdma_qc_issue,
 
+	.sff_irq_clear		= ata_bmdma_irq_clear,
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
 	.bmdma_stop		= ata_bmdma_stop,
@@ -2588,7 +2572,8 @@ void ata_bmdma_error_handler(struct ata_port *ap)
 		/* if we're gonna thaw, make sure IRQ is clear */
 		if (thaw) {
 			ap->ops->sff_check_status(ap);
-			ap->ops->sff_irq_clear(ap);
+			if (ap->ops->sff_irq_clear)
+				ap->ops->sff_irq_clear(ap);
 		}
 	}
 
@@ -2620,6 +2605,30 @@ void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc)
 }
 
 /**
+ *	ata_bmdma_irq_clear - Clear PCI IDE BMDMA interrupt.
+ *	@ap: Port associated with this ATA transaction.
+ *
+ *	Clear interrupt and error flags in DMA status register.
+ *
+ *	May be used as the irq_clear() entry in ata_port_operations.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_bmdma_irq_clear(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->ioaddr.bmdma_addr;
+
+	/* This function is called for non-DMA commands too.  Check
+	 * whether bmdma_addr is valid.
+	 */
+	if (!mmio)
+		return;
+
+	iowrite8(ioread8(mmio + ATA_DMA_STATUS), mmio + ATA_DMA_STATUS);
+}
+
+/**
  *	ata_bmdma_setup - Set up PCI IDE BMDMA transaction
  *	@qc: Info associated with this ATA transaction.
  *
@@ -2916,7 +2925,6 @@ EXPORT_SYMBOL_GPL(ata_sff_exec_command);
 EXPORT_SYMBOL_GPL(ata_sff_data_xfer);
 EXPORT_SYMBOL_GPL(ata_sff_data_xfer_noirq);
 EXPORT_SYMBOL_GPL(ata_sff_irq_on);
-EXPORT_SYMBOL_GPL(ata_sff_irq_clear);
 EXPORT_SYMBOL_GPL(ata_sff_hsm_move);
 EXPORT_SYMBOL_GPL(ata_sff_qc_issue);
 EXPORT_SYMBOL_GPL(ata_sff_qc_fill_rtf);
@@ -2944,6 +2952,7 @@ EXPORT_SYMBOL_GPL(ata_bmdma_qc_issue);
 EXPORT_SYMBOL_GPL(ata_bmdma_dumb_qc_prep);
 EXPORT_SYMBOL_GPL(ata_bmdma_error_handler);
 EXPORT_SYMBOL_GPL(ata_bmdma_post_internal_cmd);
+EXPORT_SYMBOL_GPL(ata_bmdma_irq_clear);
 EXPORT_SYMBOL_GPL(ata_bmdma_setup);
 EXPORT_SYMBOL_GPL(ata_bmdma_start);
 EXPORT_SYMBOL_GPL(ata_bmdma_stop);
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index de3e45f..170a71e 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1203,7 +1203,7 @@ static unsigned int bfin_data_xfer(struct ata_device *dev, unsigned char *buf,
  *	bfin_irq_clear - Clear ATAPI interrupt.
  *	@ap: Port associated with this ATA transaction.
  *
- *	Note: Original code is ata_sff_irq_clear().
+ *	Note: Original code is ata_bmdma_irq_clear().
  */
 
 static void bfin_irq_clear(struct ata_port *ap)
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index c96b090..0ffe330 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -914,7 +914,7 @@ static void scc_postreset(struct ata_link *link, unsigned int *classes)
  *	scc_irq_clear - Clear PCI IDE BMDMA interrupt.
  *	@ap: Port associated with this ATA transaction.
  *
- *	Note: Original code is ata_sff_irq_clear().
+ *	Note: Original code is ata_bmdma_irq_clear().
  */
 
 static void scc_irq_clear (struct ata_port *ap)
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 3d77bc4..6f02be2 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1045,7 +1045,7 @@ static void nv_adma_irq_clear(struct ata_port *ap)
 	u32 notifier_clears[2];
 
 	if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
-		ata_sff_irq_clear(ap);
+		ata_bmdma_irq_clear(ap);
 		return;
 	}
 
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index dce3b91..70b62af 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -410,7 +410,7 @@ static void sil_host_intr(struct ata_port *ap, u32 bmdma2)
 		goto err_hsm;
 
 	/* ack bmdma irq events */
-	ata_sff_irq_clear(ap);
+	ata_bmdma_irq_clear(ap);
 
 	/* kick HSM in the ass */
 	ata_sff_hsm_move(ap, qc, status, 0);
@@ -478,7 +478,7 @@ static void sil_thaw(struct ata_port *ap)
 
 	/* clear IRQ */
 	ap->ops->sff_check_status(ap);
-	ata_sff_irq_clear(ap);
+	ata_bmdma_irq_clear(ap);
 
 	/* turn on SATA IRQ if supported */
 	if (!(ap->flags & SIL_FLAG_NO_SATA_IRQ))
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 1cfa745..282de39 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -174,7 +174,7 @@ static void svia_noop_freeze(struct ata_port *ap)
 	 * certain way.  Leave it alone and just clear pending IRQ.
 	 */
 	ap->ops->sff_check_status(ap);
-	ata_sff_irq_clear(ap);
+	ata_bmdma_irq_clear(ap);
 }
 
 /**
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 34adaca..5c06e5f 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1501,7 +1501,6 @@ extern unsigned int ata_sff_data_xfer(struct ata_device *dev,
 extern unsigned int ata_sff_data_xfer_noirq(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw);
 extern u8 ata_sff_irq_on(struct ata_port *ap);
-extern void ata_sff_irq_clear(struct ata_port *ap);
 extern int ata_sff_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,
 			    u8 status, int in_wq);
 extern unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc);
@@ -1542,6 +1541,7 @@ extern unsigned int ata_bmdma_qc_issue(struct ata_queued_cmd *qc);
 extern void ata_bmdma_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_bmdma_error_handler(struct ata_port *ap);
 extern void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc);
+extern void ata_bmdma_irq_clear(struct ata_port *ap);
 extern void ata_bmdma_setup(struct ata_queued_cmd *qc);
 extern void ata_bmdma_start(struct ata_queued_cmd *qc);
 extern void ata_bmdma_stop(struct ata_queued_cmd *qc);
-- 
1.5.4.5

