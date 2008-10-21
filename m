From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/22] libata-sff: separate out BMDMA EHs
Date: Tue, 21 Oct 2008 18:17:52 +0900
Message-ID: <1224580680-13698-15-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

All of error handling logic in ata_sff_error_handler() and
ata_sff_post_internal_cmd() are for BMDMA.  Create
ata_bmdma_error_handler() and ata_bmdma_post_internal_cmd() and move
BMDMA error handling logic into those.

While at it, change DMA protocol check to ata_is_dma() and fix
post_internal_cmd to call ap->ops->bmdma_stop instead of directly
calling ata_bmdma_stop().

As these functions are BMDMA specific, there's no reason to check for
bmdma_addr before calling bmdma methods if the protocol of the failed
command is DMA.  sata_mv and pata_mpc52xx now don't need to set
.post_internal_cmd to ATA_OP_NULL and pata_icside and sata_qstor don't
need to set it to their bmdma_stop routines.

softreset/hardreset selection is now done by ata_std_error_handler()
with the help of ata_sff_check_reset() and both
ata_sff_error_handler() and ata_sff_post_internal_cmd() are noop and
removed.

This fixes p3 described in clean-up-BMDMA-initialization patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-eh.c    |    7 +-
 drivers/ata/libata-sff.c   |  202 +++++++++++++++++++++++---------------------
 drivers/ata/libata.h       |   17 ++---
 drivers/ata/pata_icside.c  |    1 -
 drivers/ata/pata_mpc52xx.c |    1 -
 drivers/ata/pata_scc.c     |    1 -
 drivers/ata/sata_mv.c      |    2 -
 drivers/ata/sata_nv.c      |    6 +-
 drivers/ata/sata_qstor.c   |    1 -
 include/linux/libata.h     |    4 +-
 10 files changed, 122 insertions(+), 120 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 0ee48f7..7f87156 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3294,13 +3294,16 @@ void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
 void ata_std_error_handler(struct ata_port *ap)
 {
 	struct ata_port_operations *ops = ap->ops;
+	ata_reset_fn_t softreset = ops->softreset;
 	ata_reset_fn_t hardreset = ops->hardreset;
 
 	/* ignore built-in hardreset if SCR access is not available */
-	if (ata_is_builtin_hardreset(hardreset) && !sata_scr_valid(&ap->link))
+	if (hardreset == sata_std_hardreset && !sata_scr_valid(&ap->link))
 		hardreset = NULL;
 
-	ata_do_eh(ap, ops->prereset, ops->softreset, hardreset, ops->postreset);
+	ata_sff_check_reset(ap, &softreset, &hardreset);
+
+	ata_do_eh(ap, ops->prereset, softreset, hardreset, ops->postreset);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 4c9adc6..a7d35b6 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -54,8 +54,6 @@ const struct ata_port_operations ata_sff_port_ops = {
 	.softreset		= ata_sff_softreset,
 	.hardreset		= sata_sff_hardreset,
 	.postreset		= ata_sff_postreset,
-	.error_handler		= ata_sff_error_handler,
-	.post_internal_cmd	= ata_sff_post_internal_cmd,
 
 	.sff_dev_select		= ata_sff_dev_select,
 	.sff_check_status	= ata_sff_check_status,
@@ -2080,98 +2078,6 @@ void ata_sff_postreset(struct ata_link *link, unsigned int *classes)
 }
 
 /**
- *	ata_sff_error_handler - Stock error handler for BMDMA controller
- *	@ap: port to handle error for
- *
- *	Stock error handler for SFF controller.  It can handle both
- *	PATA and SATA controllers.  Many controllers should be able to
- *	use this EH as-is or with some added handling before and
- *	after.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep)
- */
-void ata_sff_error_handler(struct ata_port *ap)
-{
-	ata_reset_fn_t softreset = ap->ops->softreset;
-	ata_reset_fn_t hardreset = ap->ops->hardreset;
-	struct ata_queued_cmd *qc;
-	unsigned long flags;
-	int thaw = 0;
-
-	qc = __ata_qc_from_tag(ap, ap->link.active_tag);
-	if (qc && !(qc->flags & ATA_QCFLAG_FAILED))
-		qc = NULL;
-
-	/* reset PIO HSM and stop DMA engine */
-	spin_lock_irqsave(ap->lock, flags);
-
-	if (ap->ioaddr.bmdma_addr &&
-	    qc && (qc->tf.protocol == ATA_PROT_DMA ||
-		   qc->tf.protocol == ATAPI_PROT_DMA)) {
-		u8 host_stat;
-
-		host_stat = ap->ops->bmdma_status(ap);
-
-		/* BMDMA controllers indicate host bus error by
-		 * setting DMA_ERR bit and timing out.  As it wasn't
-		 * really a timeout event, adjust error mask and
-		 * cancel frozen state.
-		 */
-		if (qc->err_mask == AC_ERR_TIMEOUT && (host_stat & ATA_DMA_ERR)) {
-			qc->err_mask = AC_ERR_HOST_BUS;
-			thaw = 1;
-		}
-
-		ap->ops->bmdma_stop(qc);
-
-		/* if we're gonna thaw, make sure IRQ is clear */
-		if (thaw) {
-			ap->ops->sff_check_status(ap);
-			ap->ops->sff_irq_clear(ap);
-		}
-	}
-
-	spin_unlock_irqrestore(ap->lock, flags);
-
-	if (thaw)
-		ata_eh_thaw_port(ap);
-
-	/* PIO and DMA engines have been stopped, perform recovery */
-
-	/* Ignore ata_sff_softreset if ctl isn't accessible and
-	 * built-in hardresets if SCR access isn't available.
-	 */
-	if (softreset == ata_sff_softreset && !ap->ioaddr.ctl_addr)
-		softreset = NULL;
-	if (ata_is_builtin_hardreset(hardreset) && !sata_scr_valid(&ap->link))
-		hardreset = NULL;
-
-	ata_do_eh(ap, ap->ops->prereset, softreset, hardreset,
-		  ap->ops->postreset);
-}
-
-/**
- *	ata_sff_post_internal_cmd - Stock post_internal_cmd for SFF controller
- *	@qc: internal command to clean up
- *
- *	LOCKING:
- *	Kernel thread context (may sleep)
- */
-void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	unsigned long flags;
-
-	spin_lock_irqsave(ap->lock, flags);
-
-	if (ap->ioaddr.bmdma_addr)
-		ata_bmdma_stop(qc);
-
-	spin_unlock_irqrestore(ap->lock, flags);
-}
-
-/**
  *	ata_sff_std_ports - initialize ioaddr with standard port offsets.
  *	@ioaddr: IO address structure to be initialized
  *
@@ -2601,6 +2507,9 @@ err_out:
 const struct ata_port_operations ata_bmdma_port_ops = {
 	.inherits		= &ata_sff_port_ops,
 
+	.error_handler		= ata_bmdma_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
 	.bmdma_stop		= ata_bmdma_stop,
@@ -2610,6 +2519,82 @@ const struct ata_port_operations ata_bmdma_port_ops = {
 };
 
 /**
+ *	ata_bmdma_error_handler - Stock error handler for BMDMA controller
+ *	@ap: port to handle error for
+ *
+ *	Stock error handler for BMDMA controller.  It can handle both
+ *	PATA and SATA controllers.  Most BMDMA controllers should be
+ *	able to use this EH as-is or with some added handling before
+ *	and after.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ */
+void ata_bmdma_error_handler(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc;
+	unsigned long flags;
+	int thaw = 0;
+
+	qc = __ata_qc_from_tag(ap, ap->link.active_tag);
+	if (qc && !(qc->flags & ATA_QCFLAG_FAILED))
+		qc = NULL;
+
+	/* reset PIO HSM and stop DMA engine */
+	spin_lock_irqsave(ap->lock, flags);
+
+	if (qc && ata_is_dma(qc->tf.protocol)) {
+		u8 host_stat;
+
+		host_stat = ap->ops->bmdma_status(ap);
+
+		/* BMDMA controllers indicate host bus error by
+		 * setting DMA_ERR bit and timing out.  As it wasn't
+		 * really a timeout event, adjust error mask and
+		 * cancel frozen state.
+		 */
+		if (qc->err_mask == AC_ERR_TIMEOUT && (host_stat & ATA_DMA_ERR)) {
+			qc->err_mask = AC_ERR_HOST_BUS;
+			thaw = 1;
+		}
+
+		ap->ops->bmdma_stop(qc);
+
+		/* if we're gonna thaw, make sure IRQ is clear */
+		if (thaw) {
+			ap->ops->sff_check_status(ap);
+			ap->ops->sff_irq_clear(ap);
+		}
+	}
+
+	spin_unlock_irqrestore(ap->lock, flags);
+
+	if (thaw)
+		ata_eh_thaw_port(ap);
+
+	ata_std_error_handler(ap);
+}
+
+/**
+ *	ata_bmdma_post_internal_cmd - Stock post_internal_cmd for BMDMA
+ *	@qc: internal command to clean up
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ */
+void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	unsigned long flags;
+
+	if (ata_is_dma(qc->tf.protocol)) {
+		spin_lock_irqsave(ap->lock, flags);
+		ap->ops->bmdma_stop(qc);
+		spin_unlock_irqrestore(ap->lock, flags);
+	}
+}
+
+/**
  *	ata_bmdma_setup - Set up PCI IDE BMDMA transaction
  *	@qc: Info associated with this ATA transaction.
  *
@@ -2837,6 +2822,31 @@ void ata_pci_bmdma_init(struct ata_host *host)
 #endif /* CONFIG_PCI */
 
 /**
+ *	ata_sff_check_reset - Check whether standard reset methods are valid
+ *	@ap: Port of interest
+ *	@softresetp: I/O parameter for softreset
+ *	@hardresetp: I/O parameter for hardreset
+ *
+ *	Verify whether soft and hard resets are valid and if not
+ *	nullify them.  Called from ata_std_error_handler() to verify
+ *	stock reset methods.
+ *
+ *	LOCKING:
+ *	None.
+ */
+void ata_sff_check_reset(struct ata_port *ap, ata_reset_fn_t *softresetp,
+			 ata_reset_fn_t *hardresetp)
+{
+	/* ignore ata_sff_softreset if ctl isn't accessible */
+	if (*softresetp == ata_sff_softreset && !ap->ioaddr.ctl_addr)
+		*softresetp = NULL;
+
+	/* ignore built-in hardreset if SCR access is not available */
+	if (*hardresetp == sata_sff_hardreset && !sata_scr_valid(&ap->link))
+		*hardresetp = NULL;
+}
+
+/**
  *	ata_sff_port_init - Initialize SFF/BMDMA ATA port
  *	@ap: Port to initialize
  *
@@ -2896,8 +2906,6 @@ EXPORT_SYMBOL_GPL(ata_sff_wait_after_reset);
 EXPORT_SYMBOL_GPL(ata_sff_softreset);
 EXPORT_SYMBOL_GPL(sata_sff_hardreset);
 EXPORT_SYMBOL_GPL(ata_sff_postreset);
-EXPORT_SYMBOL_GPL(ata_sff_error_handler);
-EXPORT_SYMBOL_GPL(ata_sff_post_internal_cmd);
 EXPORT_SYMBOL_GPL(ata_sff_std_ports);
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(ata_pci_sff_init_host);
@@ -2907,6 +2915,8 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
 #endif /* CONFIG_PCI */
 EXPORT_SYMBOL_GPL(ata_bus_reset);
 EXPORT_SYMBOL_GPL(ata_bmdma_port_ops);
+EXPORT_SYMBOL_GPL(ata_bmdma_error_handler);
+EXPORT_SYMBOL_GPL(ata_bmdma_post_internal_cmd);
 EXPORT_SYMBOL_GPL(ata_bmdma_setup);
 EXPORT_SYMBOL_GPL(ata_bmdma_start);
 EXPORT_SYMBOL_GPL(ata_bmdma_stop);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 81b6852..b9e0463 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -38,17 +38,6 @@ struct ata_scsi_args {
 	void			(*done)(struct scsi_cmnd *);
 };
 
-static inline int ata_is_builtin_hardreset(ata_reset_fn_t reset)
-{
-	if (reset == sata_std_hardreset)
-		return 1;
-#ifdef CONFIG_ATA_SFF
-	if (reset == sata_sff_hardreset)
-		return 1;
-#endif
-	return 0;
-}
-
 /* libata-core.c */
 enum {
 	/* flags for ata_dev_read_id() */
@@ -200,6 +189,8 @@ static inline int sata_pmp_attach(struct ata_device *dev)
 #ifdef CONFIG_ATA_SFF
 extern void ata_sff_flush_pio_task(struct ata_port *ap);
 extern void ata_sff_port_init(struct ata_port *ap);
+extern void ata_sff_check_reset(struct ata_port *ap, ata_reset_fn_t *softresetp,
+				ata_reset_fn_t *hardresetp);
 extern int ata_sff_init(void);
 extern void ata_sff_exit(void);
 #else /* CONFIG_ATA_SFF */
@@ -207,6 +198,10 @@ static inline void ata_sff_flush_pio_task(struct ata_port *ap)
 { }
 static inline void ata_sff_port_init(struct ata_port *ap)
 { }
+static inline void ata_sff_check_reset(struct ata_port *ap,
+				       ata_reset_fn_t *softresetp,
+				       ata_reset_fn_t *hardresetp)
+{ }
 static inline int ata_sff_init(void)
 { return 0; }
 static inline void ata_sff_exit(void)
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 4485e86..6ab3ada 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -345,7 +345,6 @@ static struct ata_port_operations pata_icside_port_ops = {
 	.cable_detect		= ata_cable_40wire,
 	.set_dmamode		= pata_icside_set_dmamode,
 	.postreset		= pata_icside_postreset,
-	.post_internal_cmd	= pata_icside_bmdma_stop,
 
 	.port_start		= ATA_OP_NULL,	/* don't need PRD table */
 };
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index a9e8273..e176bb4 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -264,7 +264,6 @@ static struct ata_port_operations mpc52xx_ata_port_ops = {
 	.sff_dev_select		= mpc52xx_ata_dev_select,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= mpc52xx_ata_set_piomode,
-	.post_internal_cmd	= ATA_OP_NULL,
 };
 
 static int __devinit
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 12b9f43..46a62f2 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -990,7 +990,6 @@ static struct ata_port_operations scc_pata_ops = {
 	.prereset		= scc_pata_prereset,
 	.softreset		= scc_softreset,
 	.postreset		= scc_postreset,
-	.post_internal_cmd	= scc_bmdma_stop,
 
 	.sff_irq_clear		= scc_irq_clear,
 	.sff_irq_on		= scc_irq_on,
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 13368cb..20e926c 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -579,8 +579,6 @@ static struct ata_port_operations mv5_ops = {
 	.freeze			= mv_eh_freeze,
 	.thaw			= mv_eh_thaw,
 	.hardreset		= mv_hardreset,
-	.error_handler		= ata_std_error_handler, /* avoid SFF EH */
-	.post_internal_cmd	= ATA_OP_NULL,
 
 	.scr_read		= mv5_scr_read,
 	.scr_write		= mv5_scr_write,
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 1a9b8e6..1e67c17 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1076,7 +1076,7 @@ static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc)
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 
 	if (pp->flags & NV_ADMA_PORT_REGISTER_MODE)
-		ata_sff_post_internal_cmd(qc);
+		ata_bmdma_post_internal_cmd(qc);
 }
 
 static int nv_adma_port_start(struct ata_port *ap)
@@ -1664,7 +1664,7 @@ static void nv_adma_error_handler(struct ata_port *ap)
 		readw(mmio + NV_ADMA_CTL);	/* flush posted write */
 	}
 
-	ata_sff_error_handler(ap);
+	ata_bmdma_error_handler(ap);
 }
 
 static void nv_swncq_qc_to_dq(struct ata_port *ap, struct ata_queued_cmd *qc)
@@ -1790,7 +1790,7 @@ static void nv_swncq_error_handler(struct ata_port *ap)
 		ehc->i.action |= ATA_EH_RESET;
 	}
 
-	ata_sff_error_handler(ap);
+	ata_bmdma_error_handler(ap);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 62403a8..a130c83 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -146,7 +146,6 @@ static struct ata_port_operations qs_ata_ops = {
 	.prereset		= qs_prereset,
 	.softreset		= ATA_OP_NULL,
 	.error_handler		= qs_error_handler,
-	.post_internal_cmd	= ATA_OP_NULL,
 
 	.scr_read		= qs_scr_read,
 	.scr_write		= qs_scr_write,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 43b13cd..f53f828 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1521,8 +1521,6 @@ extern int ata_sff_softreset(struct ata_link *link, unsigned int *classes,
 extern int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
 			       unsigned long deadline);
 extern void ata_sff_postreset(struct ata_link *link, unsigned int *classes);
-extern void ata_sff_error_handler(struct ata_port *ap);
-extern void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc);
 extern void ata_sff_std_ports(struct ata_ioports *ioaddr);
 #ifdef CONFIG_PCI
 extern int ata_pci_sff_init_host(struct ata_host *host);
@@ -1539,6 +1537,8 @@ extern int ata_pci_sff_init_one(struct pci_dev *pdev,
 
 extern void ata_bus_reset(struct ata_port *ap);		/* deprecated */
 
+extern void ata_bmdma_error_handler(struct ata_port *ap);
+extern void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc);
 extern void ata_bmdma_setup(struct ata_queued_cmd *qc);
 extern void ata_bmdma_start(struct ata_queued_cmd *qc);
 extern void ata_bmdma_stop(struct ata_queued_cmd *qc);
-- 
1.5.4.5

