From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 19/22] libata-sff: separate out BMDMA irq handler
Date: Tue, 21 Oct 2008 18:17:57 +0900
Message-ID: <1224580680-13698-20-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:46086 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbYJUJVO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 05:21:14 -0400
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>

Separate out BMDMA irq handler from SFF irq handler.  The misnamed
host_intr() functions are renamed to ata_sff_port_intr() and
ata_bmdma_port_intr().

All BMDMA drivers now use ata_bmdma_interrupt() or
ata_bmdma_port_intr() while all non-BMDMA SFF ones use
ata_sff_interrupt() or ata_sff_port_intr().

For now, ata_pci_sff_init_one() uses ata_bmdma_interrupt() as it's
used by both SFF and BMDMA drivers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/ata_piix.c      |    2 +-
 drivers/ata/libata-sff.c    |  172 +++++++++++++++++++++++++++++--------------
 drivers/ata/pata_cs5520.c   |    2 +-
 drivers/ata/pata_hpt3x3.c   |    2 +-
 drivers/ata/pata_icside.c   |    2 +-
 drivers/ata/pata_ninja32.c  |    2 +-
 drivers/ata/pata_pdc2027x.c |    2 +-
 drivers/ata/pata_scc.c      |    2 +-
 drivers/ata/pata_sil680.c   |    2 +-
 drivers/ata/sata_mv.c       |    2 +-
 drivers/ata/sata_nv.c       |    4 +-
 drivers/ata/sata_qstor.c    |    2 +-
 drivers/ata/sata_sis.c      |    2 +-
 drivers/ata/sata_svw.c      |    2 +-
 drivers/ata/sata_uli.c      |    2 +-
 drivers/ata/sata_via.c      |    2 +-
 drivers/ata/sata_vsc.c      |    2 +-
 include/linux/libata.h      |    5 +-
 18 files changed, 138 insertions(+), 73 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index e9e32ed..c1da5e6 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1471,7 +1471,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	}
 
 	pci_set_master(pdev);
-	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &piix_sht);
+	return ata_pci_sff_activate_host(host, ata_bmdma_interrupt, &piix_sht);
 }
 
 static int __init piix_init(void)
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 96d93ce..4655181 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1328,14 +1328,28 @@ bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc)
 	return true;
 }
 
+static unsigned int ata_sff_idle_irq(struct ata_port *ap)
+{
+	ap->stats.idle_irq++;
+
+#ifdef ATA_IRQ_TRAP
+	if ((ap->stats.idle_irq % 1000) == 0) {
+		ap->ops->sff_check_status(ap);
+		if (ap->ops->sff_irq_clear)
+			ap->ops->sff_irq_clear(ap);
+		ata_port_printk(ap, KERN_WARNING, "irq trap\n");
+		return 1;
+	}
+#endif
+	return 0;	/* irq not handled */
+}
+
 /**
- *	ata_sff_host_intr - Handle host interrupt for given (port, task)
+ *	ata_sff_port_intr - Handle SFF port interrupt
  *	@ap: Port on which interrupt arrived (possibly...)
  *	@qc: Taskfile currently active in engine
  *
- *	Handle host interrupt for given queued command.  Currently,
- *	only DMA interrupts are handled.  All other commands are
- *	handled via polling with interrupts disabled (nIEN bit).
+ *	Handle port interrupt for given queued command.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
@@ -1343,11 +1357,10 @@ bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc)
  *	RETURNS:
  *	One if interrupt was handled, zero if not (shared irq).
  */
-inline unsigned int ata_sff_host_intr(struct ata_port *ap,
+inline unsigned int ata_sff_port_intr(struct ata_port *ap,
 				      struct ata_queued_cmd *qc)
 {
-	struct ata_eh_info *ehi = &ap->link.eh_info;
-	u8 status, host_stat = 0;
+	u8 status;
 
 	VPRINTK("ata%u: protocol %d task_state %d\n",
 		ap->print_id, qc->tf.protocol, ap->hsm_task_state);
@@ -1364,41 +1377,20 @@ inline unsigned int ata_sff_host_intr(struct ata_port *ap,
 		 * need to check ata_is_atapi(qc->tf.protocol) again.
 		 */
 		if (!(qc->dev->flags & ATA_DFLAG_CDB_INTR))
-			goto idle_irq;
-		break;
-	case HSM_ST_LAST:
-		if (qc->tf.protocol == ATA_PROT_DMA ||
-		    qc->tf.protocol == ATAPI_PROT_DMA) {
-			/* check status of DMA engine */
-			host_stat = ap->ops->bmdma_status(ap);
-			VPRINTK("ata%u: host_stat 0x%X\n",
-				ap->print_id, host_stat);
-
-			/* if it's not our irq... */
-			if (!(host_stat & ATA_DMA_INTR))
-				goto idle_irq;
-
-			/* before we do anything else, clear DMA-Start bit */
-			ap->ops->bmdma_stop(qc);
-
-			if (unlikely(host_stat & ATA_DMA_ERR)) {
-				/* error when transfering data to/from memory */
-				qc->err_mask |= AC_ERR_HOST_BUS;
-				ap->hsm_task_state = HSM_ST_ERR;
-			}
-		}
+			return ata_sff_idle_irq(ap);
 		break;
 	case HSM_ST:
+	case HSM_ST_LAST:
 		break;
 	default:
-		goto idle_irq;
+		return ata_sff_idle_irq(ap);
 	}
 
 
 	/* check main status, clearing INTRQ if needed */
 	status = ata_sff_irq_status(ap);
 	if (status & ATA_BUSY)
-		goto idle_irq;
+		return ata_sff_idle_irq(ap);
 
 	/* clear irq events */
 	if (ap->ops->sff_irq_clear)
@@ -1406,34 +1398,16 @@ inline unsigned int ata_sff_host_intr(struct ata_port *ap,
 
 	ata_sff_hsm_move(ap, qc, status, 0);
 
-	if (unlikely(qc->err_mask) && (qc->tf.protocol == ATA_PROT_DMA ||
-				       qc->tf.protocol == ATAPI_PROT_DMA))
-		ata_ehi_push_desc(ehi, "BMDMA stat 0x%x", host_stat);
-
 	return 1;	/* irq handled */
-
-idle_irq:
-	ap->stats.idle_irq++;
-
-#ifdef ATA_IRQ_TRAP
-	if ((ap->stats.idle_irq % 1000) == 0) {
-		ap->ops->sff_check_status(ap);
-		if (ap->ops->sff_irq_clear)
-			ap->ops->sff_irq_clear(ap);
-		ata_port_printk(ap, KERN_WARNING, "irq trap\n");
-		return 1;
-	}
-#endif
-	return 0;	/* irq not handled */
 }
 
 /**
- *	ata_sff_interrupt - Default ATA host interrupt handler
+ *	ata_sff_interrupt - Default SFF ATA host interrupt handler
  *	@irq: irq line (unused)
  *	@dev_instance: pointer to our ata_host information structure
  *
  *	Default interrupt handler for PCI IDE devices.  Calls
- *	ata_sff_host_intr() for each port that is not disabled.
+ *	ata_sff_port_intr() for each port that is not disabled.
  *
  *	LOCKING:
  *	Obtains host lock during operation.
@@ -1457,7 +1431,7 @@ irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 
 		qc = ata_qc_from_tag(ap, ap->link.active_tag);
 		if (qc && !(qc->tf.flags & ATA_TFLAG_POLLING))
-			handled |= ata_sff_host_intr(ap, qc);
+			handled |= ata_sff_port_intr(ap, qc);
 	}
 
 	spin_unlock_irqrestore(&host->lock, flags);
@@ -2205,7 +2179,7 @@ int ata_pci_sff_init_one(struct pci_dev *pdev,
 	host->private_data = host_priv;
 
 	pci_set_master(pdev);
-	rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
+	rc = ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
  out:
 	if (rc == 0)
 		devres_remove_group(&pdev->dev, NULL);
@@ -2528,6 +2502,92 @@ unsigned int ata_bmdma_qc_issue(struct ata_queued_cmd *qc)
 }
 
 /**
+ *	ata_bmdma_port_intr - Handle BMDMA port interrupt
+ *	@ap: Port on which interrupt arrived (possibly...)
+ *	@qc: Taskfile currently active in engine
+ *
+ *	Handle port interrupt for given queued command.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	One if interrupt was handled, zero if not (shared irq).
+ */
+inline unsigned int ata_bmdma_port_intr(struct ata_port *ap,
+					struct ata_queued_cmd *qc)
+{
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	u8 host_stat = 0;
+	unsigned int handled;
+
+	if (ap->hsm_task_state == HSM_ST_LAST && ata_is_dma(qc->tf.protocol)) {
+		/* check status of DMA engine */
+		host_stat = ap->ops->bmdma_status(ap);
+		VPRINTK("ata%u: host_stat 0x%X\n",
+			ap->print_id, host_stat);
+
+		/* if it's not our irq... */
+		if (!(host_stat & ATA_DMA_INTR))
+			return ata_sff_idle_irq(ap);
+
+		/* before we do anything else, clear DMA-Start bit */
+		ap->ops->bmdma_stop(qc);
+
+		if (unlikely(host_stat & ATA_DMA_ERR)) {
+			/* error when transfering data to/from memory */
+			qc->err_mask |= AC_ERR_HOST_BUS;
+			ap->hsm_task_state = HSM_ST_ERR;
+		}
+	}
+
+	handled = ata_sff_port_intr(ap, qc);
+
+	if (unlikely(qc->err_mask) && ata_is_dma(qc->tf.protocol))
+		ata_ehi_push_desc(ehi, "BMDMA stat 0x%x", host_stat);
+
+	return handled;
+}
+
+/**
+ *	ata_bmdma_interrupt - Default BMDMA ATA host interrupt handler
+ *	@irq: irq line (unused)
+ *	@dev_instance: pointer to our ata_host information structure
+ *
+ *	Default interrupt handler for PCI IDE devices.  Calls
+ *	ata_bmdma_port_intr() for each port that is not disabled.
+ *
+ *	LOCKING:
+ *	Obtains host lock during operation.
+ *
+ *	RETURNS:
+ *	IRQ_NONE or IRQ_HANDLED.
+ */
+irqreturn_t ata_bmdma_interrupt(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	unsigned int i;
+	unsigned int handled = 0;
+	unsigned long flags;
+
+	/* TODO: make _irqsave conditional on x86 PCI IDE legacy mode */
+	spin_lock_irqsave(&host->lock, flags);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		struct ata_queued_cmd *qc;
+
+		qc = ata_qc_from_tag(ap, ap->link.active_tag);
+		if (qc && !(qc->tf.flags & ATA_TFLAG_POLLING))
+			handled |= ata_bmdma_port_intr(ap, qc);
+	}
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return IRQ_RETVAL(handled);
+}
+
+/**
  *	ata_bmdma_error_handler - Stock error handler for BMDMA controller
  *	@ap: port to handle error for
  *
@@ -2928,7 +2988,7 @@ EXPORT_SYMBOL_GPL(ata_sff_irq_on);
 EXPORT_SYMBOL_GPL(ata_sff_hsm_move);
 EXPORT_SYMBOL_GPL(ata_sff_qc_issue);
 EXPORT_SYMBOL_GPL(ata_sff_qc_fill_rtf);
-EXPORT_SYMBOL_GPL(ata_sff_host_intr);
+EXPORT_SYMBOL_GPL(ata_sff_port_intr);
 EXPORT_SYMBOL_GPL(ata_sff_interrupt);
 EXPORT_SYMBOL_GPL(ata_sff_freeze);
 EXPORT_SYMBOL_GPL(ata_sff_thaw);
@@ -2950,6 +3010,8 @@ EXPORT_SYMBOL_GPL(ata_bmdma_port_ops);
 EXPORT_SYMBOL_GPL(ata_bmdma_qc_prep);
 EXPORT_SYMBOL_GPL(ata_bmdma_qc_issue);
 EXPORT_SYMBOL_GPL(ata_bmdma_dumb_qc_prep);
+EXPORT_SYMBOL_GPL(ata_bmdma_port_intr);
+EXPORT_SYMBOL_GPL(ata_bmdma_interrupt);
 EXPORT_SYMBOL_GPL(ata_bmdma_error_handler);
 EXPORT_SYMBOL_GPL(ata_bmdma_post_internal_cmd);
 EXPORT_SYMBOL_GPL(ata_bmdma_irq_clear);
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index d5fe2b1..8cd06e4 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -258,7 +258,7 @@ static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_devi
 			continue;
 
 		rc = devm_request_irq(&pdev->dev, irq[ap->port_no],
-				      ata_sff_interrupt, 0, DRV_NAME, host);
+				      ata_bmdma_interrupt, 0, DRV_NAME, host);
 		if (rc)
 			return rc;
 
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index f11a320..8ac65cb 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -209,7 +209,7 @@ static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ata_port_pbar_desc(ap, 4, offset_cmd[i], "cmd");
 	}
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &hpt3x3_sht);
 }
 
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 6ab3ada..4cbef74 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -482,7 +482,7 @@ static int __devinit pata_icside_add_ports(struct pata_icside_info *info)
 		pata_icside_setup_ioaddr(ap, info->base, info, info->port[i]);
 	}
 
-	return ata_host_activate(host, ec->irq, ata_sff_interrupt, 0,
+	return ata_host_activate(host, ec->irq, ata_bmdma_interrupt, 0,
 				 &pata_icside_sht);
 }
 
diff --git a/drivers/ata/pata_ninja32.c b/drivers/ata/pata_ninja32.c
index 565e67c..8f6b64d 100644
--- a/drivers/ata/pata_ninja32.c
+++ b/drivers/ata/pata_ninja32.c
@@ -142,7 +142,7 @@ static int ninja32_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	iowrite8(0xa4, base + 0x1c);	/* Unknown */
 	iowrite8(0x83, base + 0x1d);	/* BMDMA control: WAIT0 */
 	/* FIXME: Should we disable them at remove ? */
-	return ata_host_activate(host, dev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, dev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &ninja32_sht);
 }
 
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index dfecd1a..76727aa 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -759,7 +759,7 @@ static int __devinit pdc2027x_init_one(struct pci_dev *pdev, const struct pci_de
 		return -EIO;
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &pdc2027x_sht);
 }
 
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 0ffe330..7a5b49c 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -1145,7 +1145,7 @@ static int scc_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &scc_sht);
 }
 
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index a598bb3..9fffab2 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -355,7 +355,7 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 	ata_sff_std_ports(&host->ports[1]->ioaddr);
 
 	/* Register & activate */
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &sil680_sht);
 
 use_ioports:
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 20e926c..d9cfbf4 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2074,7 +2074,7 @@ static void mv_port_intr(struct ata_port *ap, u32 port_cause)
 	} else if (!edma_was_enabled) {
 		struct ata_queued_cmd *qc = mv_get_active_qc(ap);
 		if (qc)
-			ata_sff_host_intr(ap, qc);
+			ata_sff_port_intr(ap, qc);
 		else
 			mv_unexpected_intr(ap, edma_was_enabled);
 	}
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 6f02be2..0806f65 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -866,7 +866,7 @@ static int nv_host_intr(struct ata_port *ap, u8 irq_stat)
 	}
 
 	/* handle interrupt */
-	return ata_sff_host_intr(ap, qc);
+	return ata_bmdma_port_intr(ap, qc);
 }
 
 static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
@@ -1450,7 +1450,7 @@ static irqreturn_t nv_generic_interrupt(int irq, void *dev_instance)
 
 		qc = ata_qc_from_tag(ap, ap->link.active_tag);
 		if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)))
-			handled += ata_sff_host_intr(ap, qc);
+			handled += ata_bmdma_port_intr(ap, qc);
 		else
 			// No request pending?  Clear interrupt status
 			// anyway, in case there's one pending.
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index b8783bc..44ff556 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -452,7 +452,7 @@ static inline unsigned int qs_intr_mmio(struct ata_host *host)
 		if (!pp || pp->state != qs_state_mmio)
 			continue;
 		if (!(qc->tf.flags & ATA_TFLAG_POLLING))
-			handled |= ata_sff_host_intr(ap, qc);
+			handled |= ata_sff_port_intr(ap, qc);
 	}
 	return handled;
 }
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 9c43b4e..6104df7 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -333,7 +333,7 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 	pci_intx(pdev, 1);
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &sis_sht);
 }
 
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 43e0024..b1049bd 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -502,7 +502,7 @@ static int k2_sata_init_one(struct pci_dev *pdev, const struct pci_device_id *en
 	writel(0x0, mmio_base + K2_SATA_SIM_OFFSET);
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &k2_sata_sht);
 }
 
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 4801689..5753e89 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -241,7 +241,7 @@ static int uli_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 	pci_intx(pdev, 1);
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &uli_sht);
 }
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 282de39..7ebc406 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -448,7 +448,7 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	svia_configure(pdev);
 
 	pci_set_master(pdev);
-	return ata_host_activate(host, pdev->irq, ata_sff_interrupt,
+	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
 				 IRQF_SHARED, &svia_sht);
 }
 
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 45bd21c..a0cba98 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -245,7 +245,7 @@ static void vsc_port_intr(u8 port_status, struct ata_port *ap)
 
 	qc = ata_qc_from_tag(ap, ap->link.active_tag);
 	if (qc && likely(!(qc->tf.flags & ATA_TFLAG_POLLING)))
-		handled = ata_sff_host_intr(ap, qc);
+		handled = ata_bmdma_port_intr(ap, qc);
 
 	/* We received an interrupt during a polled command,
 	 * or some other spurious condition.  Interrupt reporting
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 5c06e5f..8cc0a9b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1505,7 +1505,7 @@ extern int ata_sff_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,
 			    u8 status, int in_wq);
 extern unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc);
 extern bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc);
-extern unsigned int ata_sff_host_intr(struct ata_port *ap,
+extern unsigned int ata_sff_port_intr(struct ata_port *ap,
 				      struct ata_queued_cmd *qc);
 extern irqreturn_t ata_sff_interrupt(int irq, void *dev_instance);
 extern void ata_sff_freeze(struct ata_port *ap);
@@ -1539,6 +1539,9 @@ extern void ata_bus_reset(struct ata_port *ap);		/* deprecated */
 extern void ata_bmdma_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_bmdma_qc_issue(struct ata_queued_cmd *qc);
 extern void ata_bmdma_dumb_qc_prep(struct ata_queued_cmd *qc);
+extern unsigned int ata_bmdma_port_intr(struct ata_port *ap,
+				      struct ata_queued_cmd *qc);
+extern irqreturn_t ata_bmdma_interrupt(int irq, void *dev_instance);
 extern void ata_bmdma_error_handler(struct ata_port *ap);
 extern void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc);
 extern void ata_bmdma_irq_clear(struct ata_port *ap);
-- 
1.5.4.5

