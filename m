From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/22] libata-sff: clean up BMDMA initialization
Date: Tue, 21 Oct 2008 18:17:48 +0900
Message-ID: <1224580680-13698-11-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:46063 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbYJUJU4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 05:20:56 -0400
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>

When BMDMA initialization failed or BMDMA was not available for
whatever reason, bmdma_addr was left at zero and used as indication
that BMDMA shouldn't be used.  This leads to the following problems.

p1. For BMDMA drivers which don't use traditional BMDMA register,
    ata_bmdma_mode_filter() incorrectly inhibits DMA modes.  Those
    drivers either have to inherit from ata_sff_port_ops or clear
    ->mode_filter explicitly.

p2. non-BMDMA drivers call into BMDMA PRD table allocation.  It
    doesn't actually allocate PRD table if bmdma_addr is not
    initialized but is still confusing.

p3. For BMDMA drivers which don't use traditional BMDMA register, some
    methods might not be invoked as expected (e.g. bmdma_stop from
    ata_sff_post_internal_cmd()).

p4. SFF drivers w/ custom DMA interface implement noop BMDMA ops
    worrying libata core might call into one of them.

These problems are caused by the muddy line between SFF and BMDMA and
the assumption that all BMDMA controllers initialize bmdma_addr.

This patch fixes #1 and #2 by removing the bmdma_addr assumption and
moving prd allocation to BMDMA port start.  Following patches will fix
the remaining issues.

This patch improves BMDMA initialization such that

* When BMDMA register initialization fails, falls back to PIO instead
  of failing.  ata_pci_bmdma_init() never fails now.

* When ata_pci_bmdma_init() falls back to PIO, it clears
  ap->mwdma_mask and udma_mask instead of depending on
  ata_bmdma_mode_filter().  This makes ata_bmdma_mode_filter()
  unnecessary and p1 is removed.

* ata_port_start() which actually is BMDMA specific is moved to
  ata_bmdma_port_start().  ata_port_start() and ata_sff_port_start()
  are killed.

Drivers which no longer calls into PRD table allocation are...

  pdc_adma, sata_inic162x, sata_qstor, sata_sx4, pata_cmd640 and all
  drivers which inherit from ata_sff_port_ops.

pata_icside sets ->port_start to ATA_OP_NULL as it doesn't need PRD
but is a BMDMA controller and doesn't have custom port_start like
other such controllers.

Note that with the previous patch which makes all and only BMDMA
drivers inherit from ata_bmdma_port_ops, this change doesn't break
drivers which need PRD table.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-core.c       |   25 --------
 drivers/ata/libata-sff.c        |  122 +++++++++++++++++++--------------------
 drivers/ata/pata_acpi.c         |    4 +-
 drivers/ata/pata_ali.c          |    2 +-
 drivers/ata/pata_bf54x.c        |    2 -
 drivers/ata/pata_cmd640.c       |    6 +--
 drivers/ata/pata_hpt366.c       |    2 +-
 drivers/ata/pata_hpt37x.c       |    4 +-
 drivers/ata/pata_icside.c       |    2 +-
 drivers/ata/pata_it821x.c       |    2 +-
 drivers/ata/pata_pdc2027x.c     |    4 +-
 drivers/ata/pata_pdc202xx_old.c |    2 +-
 drivers/ata/pata_platform.c     |    1 -
 drivers/ata/pata_scc.c          |    6 +-
 drivers/ata/pata_serverworks.c  |    6 +-
 drivers/ata/pdc_adma.c          |    4 -
 drivers/ata/sata_inic162x.c     |    5 --
 drivers/ata/sata_nv.c           |    6 +-
 drivers/ata/sata_promise.c      |    3 +-
 drivers/ata/sata_qstor.c        |    4 -
 drivers/ata/sata_sx4.c          |    5 --
 drivers/ata/sata_uli.c          |    4 +-
 include/linux/libata.h          |    7 +--
 23 files changed, 87 insertions(+), 141 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 231e967..05e31c2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5148,30 +5148,6 @@ void ata_host_resume(struct ata_host *host)
 #endif
 
 /**
- *	ata_port_start - Set port up for dma.
- *	@ap: Port to initialize
- *
- *	Called just after data structures for each port are
- *	initialized.  Allocates space for PRD table.
- *
- *	May be used as the port_start() entry in ata_port_operations.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-int ata_port_start(struct ata_port *ap)
-{
-	struct device *dev = ap->dev;
-
-	ap->prd = dmam_alloc_coherent(dev, ATA_PRD_TBL_SZ, &ap->prd_dma,
-				      GFP_KERNEL);
-	if (!ap->prd)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/**
  *	ata_dev_init - Initialize an ata_device structure
  *	@dev: Device structure to initialize
  *
@@ -6403,7 +6379,6 @@ EXPORT_SYMBOL_GPL(ata_xfer_mode2mask);
 EXPORT_SYMBOL_GPL(ata_xfer_mode2shift);
 EXPORT_SYMBOL_GPL(ata_mode_string);
 EXPORT_SYMBOL_GPL(ata_id_xfermask);
-EXPORT_SYMBOL_GPL(ata_port_start);
 EXPORT_SYMBOL_GPL(ata_do_set_mode);
 EXPORT_SYMBOL_GPL(ata_std_qc_defer);
 EXPORT_SYMBOL_GPL(ata_noop_qc_prep);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 2c5ebd1..0e4814b 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -63,8 +63,6 @@ const struct ata_port_operations ata_sff_port_ops = {
 	.sff_data_xfer		= ata_sff_data_xfer,
 	.sff_irq_on		= ata_sff_irq_on,
 	.sff_irq_clear		= ata_sff_irq_clear,
-
-	.port_start		= ata_sff_port_start,
 };
 
 /**
@@ -2152,26 +2150,6 @@ void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc)
 }
 
 /**
- *	ata_sff_port_start - Set port up for dma.
- *	@ap: Port to initialize
- *
- *	Called just after data structures for each port are
- *	initialized.  Allocates space for PRD table if the device
- *	is DMA capable SFF.
- *
- *	May be used as the port_start() entry in ata_port_operations.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-int ata_sff_port_start(struct ata_port *ap)
-{
-	if (ap->ioaddr.bmdma_addr)
-		return ata_port_start(ap);
-	return 0;
-}
-
-/**
  *	ata_sff_std_ports - initialize ioaddr with standard port offsets.
  *	@ioaddr: IO address structure to be initialized
  *
@@ -2328,21 +2306,12 @@ int ata_pci_sff_prepare_host(struct pci_dev *pdev,
 		goto err_out;
 
 	/* init DMA related stuff */
-	rc = ata_pci_bmdma_init(host);
-	if (rc)
-		goto err_bmdma;
+	ata_pci_bmdma_init(host);
 
 	devres_remove_group(&pdev->dev, NULL);
 	*r_host = host;
 	return 0;
 
- err_bmdma:
-	/* This is necessary because PCI and iomap resources are
-	 * merged and releasing the top group won't release the
-	 * acquired resources if some of those have been acquired
-	 * before entering this function.
-	 */
-	pcim_iounmap_regions(pdev, 0xf);
  err_out:
 	devres_release_group(&pdev->dev, NULL);
 	return rc;
@@ -2610,24 +2579,13 @@ err_out:
 const struct ata_port_operations ata_bmdma_port_ops = {
 	.inherits		= &ata_sff_port_ops,
 
-	.mode_filter		= ata_bmdma_mode_filter,
-
 	.bmdma_setup		= ata_bmdma_setup,
 	.bmdma_start		= ata_bmdma_start,
 	.bmdma_stop		= ata_bmdma_stop,
 	.bmdma_status		= ata_bmdma_status,
-};
 
-unsigned long ata_bmdma_mode_filter(struct ata_device *adev,
-				    unsigned long xfer_mask)
-{
-	/* Filter out DMA modes if the device has been configured by
-	   the BIOS as PIO only */
-
-	if (adev->link->ap->ioaddr.bmdma_addr == NULL)
-		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
-	return xfer_mask;
-}
+	.port_start		= ata_bmdma_port_start,
+};
 
 /**
  *	ata_bmdma_setup - Set up PCI IDE BMDMA transaction
@@ -2729,6 +2687,30 @@ u8 ata_bmdma_status(struct ata_port *ap)
 	return ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
 }
 
+/**
+ *	ata_bmdma_port_start - Set port up for bmdma.
+ *	@ap: Port to initialize
+ *
+ *	Called just after data structures for each port are
+ *	initialized.  Allocates space for PRD table.
+ *
+ *	May be used as the port_start() entry in ata_port_operations.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+int ata_bmdma_port_start(struct ata_port *ap)
+{
+	if (ap->mwdma_mask || ap->udma_mask) {
+		ap->prd = dmam_alloc_coherent(ap->host->dev, ATA_PRD_TBL_SZ,
+					      &ap->prd_dma, GFP_KERNEL);
+		if (!ap->prd)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_PCI
 
 /**
@@ -2756,6 +2738,19 @@ int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev)
 	return 0;
 }
 
+static void ata_bmdma_nodma(struct ata_host *host, const char *reason)
+{
+	int i;
+
+	dev_printk(KERN_ERR, host->dev, "BMDMA: %s, falling back to PIO\n",
+		   reason);
+
+	for (i = 0; i < 2; i++) {
+		host->ports[i]->mwdma_mask = 0;
+		host->ports[i]->udma_mask = 0;
+	}
+}
+
 /**
  *	ata_pci_bmdma_init - acquire PCI BMDMA resources and init ATA host
  *	@host: target ATA host
@@ -2764,33 +2759,39 @@ int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev)
  *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
- *
- *	RETURNS:
- *	0 on success, -errno otherwise.
  */
-int ata_pci_bmdma_init(struct ata_host *host)
+void ata_pci_bmdma_init(struct ata_host *host)
 {
 	struct device *gdev = host->dev;
 	struct pci_dev *pdev = to_pci_dev(gdev);
 	int i, rc;
 
 	/* No BAR4 allocation: No DMA */
-	if (pci_resource_start(pdev, 4) == 0)
-		return 0;
+	if (pci_resource_start(pdev, 4) == 0) {
+		ata_bmdma_nodma(host, "BAR4 is zero");
+		return;
+	}
 
-	/* TODO: If we get no DMA mask we should fall back to PIO */
+	/* Some controllers require BMDMA region to be initialized
+	 * even if DMA is not in use to clear IRQ status via
+	 * ->sff_irq_clear method.  Try to initialize bmdma_addr
+	 * regardless of dma masks.
+	 */
 	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
 	if (rc)
-		return rc;
-	rc = pci_set_consistent_dma_mask(pdev, ATA_DMA_MASK);
-	if (rc)
-		return rc;
+		ata_bmdma_nodma(host, "failed to set dma mask");
+	if (!rc) {
+		rc = pci_set_consistent_dma_mask(pdev, ATA_DMA_MASK);
+		if (rc)
+			ata_bmdma_nodma(host,
+					"failed to set consistent dma mask");
+	}
 
 	/* request and iomap DMA region */
 	rc = pcim_iomap_regions(pdev, 1 << 4, dev_driver_string(gdev));
 	if (rc) {
-		dev_printk(KERN_ERR, gdev, "failed to request/iomap BAR4\n");
-		return -ENOMEM;
+		ata_bmdma_nodma(host, "failed to request/iomap BAR4");
+		return;
 	}
 	host->iomap = pcim_iomap_table(pdev);
 
@@ -2809,8 +2810,6 @@ int ata_pci_bmdma_init(struct ata_host *host)
 		ata_port_desc(ap, "bmdma 0x%llx",
 			(unsigned long long)pci_resource_start(pdev, 4) + 8 * i);
 	}
-
-	return 0;
 }
 
 #endif /* CONFIG_PCI */
@@ -2846,7 +2845,6 @@ EXPORT_SYMBOL_GPL(sata_sff_hardreset);
 EXPORT_SYMBOL_GPL(ata_sff_postreset);
 EXPORT_SYMBOL_GPL(ata_sff_error_handler);
 EXPORT_SYMBOL_GPL(ata_sff_post_internal_cmd);
-EXPORT_SYMBOL_GPL(ata_sff_port_start);
 EXPORT_SYMBOL_GPL(ata_sff_std_ports);
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(ata_pci_sff_init_host);
@@ -2856,11 +2854,11 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
 #endif /* CONFIG_PCI */
 EXPORT_SYMBOL_GPL(ata_bus_reset);
 EXPORT_SYMBOL_GPL(ata_bmdma_port_ops);
-EXPORT_SYMBOL_GPL(ata_bmdma_mode_filter);
 EXPORT_SYMBOL_GPL(ata_bmdma_setup);
 EXPORT_SYMBOL_GPL(ata_bmdma_start);
 EXPORT_SYMBOL_GPL(ata_bmdma_stop);
 EXPORT_SYMBOL_GPL(ata_bmdma_status);
+EXPORT_SYMBOL_GPL(ata_bmdma_port_start);
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(ata_pci_bmdma_clear_simplex);
 EXPORT_SYMBOL_GPL(ata_pci_bmdma_init);
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index eb919c1..d701e28 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -106,7 +106,7 @@ static unsigned long pacpi_discover_modes(struct ata_port *ap, struct ata_device
 static unsigned long pacpi_mode_filter(struct ata_device *adev, unsigned long mask)
 {
 	struct pata_acpi *acpi = adev->link->ap->private_data;
-	return ata_bmdma_mode_filter(adev, mask & acpi->mask[adev->devno]);
+	return mask & acpi->mask[adev->devno];
 }
 
 /**
@@ -210,7 +210,7 @@ static int pacpi_port_start(struct ata_port *ap)
 		return -ENOMEM;
 	acpi->mask[0] = pacpi_discover_modes(ap, &ap->link.device[0]);
 	acpi->mask[1] = pacpi_discover_modes(ap, &ap->link.device[1]);
-	ret = ata_sff_port_start(ap);
+	ret = ata_bmdma_port_start(ap);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 5ca70fa..171a49e 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -121,7 +121,7 @@ static unsigned long ali_20_filter(struct ata_device *adev, unsigned long mask)
 	ata_id_c_string(adev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 	if (strstr(model_num, "WDC"))
 		return mask &= ~ATA_MASK_UDMA;
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 /**
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 27cd40a..de3e45f 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1490,8 +1490,6 @@ static struct ata_port_operations bfin_pata_ops = {
 
 	.port_start		= bfin_port_start,
 	.port_stop		= bfin_port_stop,
-
-	.mode_filter		= ATA_OP_NULL,	/* will be removed soon */
 };
 
 static struct ata_port_info bfin_port_info[] = {
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 4b2612b..32f0602 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -153,16 +153,12 @@ static int cmd640_port_start(struct ata_port *ap)
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct cmd640_reg *timing;
 
-	int ret = ata_sff_port_start(ap);
-	if (ret < 0)
-		return ret;
-
 	timing = devm_kzalloc(&pdev->dev, sizeof(struct cmd640_reg), GFP_KERNEL);
 	if (timing == NULL)
 		return -ENOMEM;
 	timing->last = -1;	/* Force a load */
 	ap->private_data = timing;
-	return ret;
+	return 0;
 }
 
 static struct scsi_host_template cmd640_sht = {
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index f2b83ea..d7b0bc5 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -184,7 +184,7 @@ static unsigned long hpt366_filter(struct ata_device *adev, unsigned long mask)
 		if (hpt_dma_blacklisted(adev, "UDMA4", bad_ata66_4))
 			mask &= ~(0xF0 << ATA_SHIFT_UDMA);
 	}
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 /**
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 4216399..b380d57 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -283,7 +283,7 @@ static unsigned long hpt370_filter(struct ata_device *adev, unsigned long mask)
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
 			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 /**
@@ -299,7 +299,7 @@ static unsigned long hpt370a_filter(struct ata_device *adev, unsigned long mask)
 		if (hpt_dma_blacklisted(adev, "UDMA100", bad_ata100_5))
 			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 /**
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index f2623c6..4485e86 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -347,7 +347,7 @@ static struct ata_port_operations pata_icside_port_ops = {
 	.postreset		= pata_icside_postreset,
 	.post_internal_cmd	= pata_icside_bmdma_stop,
 
-	.mode_filter		= ATA_OP_NULL,	/* will be removed soon */
+	.port_start		= ATA_OP_NULL,	/* don't need PRD table */
 };
 
 static void __devinit
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 0221c9a..27c5968 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -740,7 +740,7 @@ static int it821x_port_start(struct ata_port *ap)
 	struct it821x_dev *itdev;
 	u8 conf;
 
-	int ret = ata_sff_port_start(ap);
+	int ret = ata_bmdma_port_start(ap);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 0e1c2c1..dfecd1a 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -265,7 +265,7 @@ static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long
 	struct ata_device *pair = ata_dev_pair(adev);
 
 	if (adev->class != ATA_DEV_ATA || adev->devno == 0 || pair == NULL)
-		return ata_bmdma_mode_filter(adev, mask);
+		return mask;
 
 	/* Check for slave of a Maxtor at UDMA6 */
 	ata_id_c_string(pair->id, model_num, ATA_ID_PROD,
@@ -274,7 +274,7 @@ static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long
 	if (strstr(model_num, "Maxtor") == NULL && pair->dma_mode == XFER_UDMA_6)
 		mask &= ~ (1 << (6 + ATA_SHIFT_UDMA));
 
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 /**
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index d267306..b452e4a 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -240,7 +240,7 @@ static int pdc2026x_port_start(struct ata_port *ap)
 		u8 burst = ioread8(bmdma + 0x1f);
 		iowrite8(burst | 0x01, bmdma + 0x1f);
 	}
-	return ata_sff_port_start(ap);
+	return ata_bmdma_port_start(ap);
 }
 
 /**
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 8f65ad6..ddf315a 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -55,7 +55,6 @@ static struct ata_port_operations pata_platform_port_ops = {
 	.sff_data_xfer		= ata_sff_data_xfer_noirq,
 	.cable_detect		= ata_cable_unknown,
 	.set_mode		= pata_platform_set_mode,
-	.port_start		= ATA_OP_NULL,
 };
 
 static void pata_platform_setup_port(struct ata_ioports *ioaddr,
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 16673d1..12b9f43 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -266,7 +266,7 @@ unsigned long scc_mode_filter(struct ata_device *adev, unsigned long mask)
 		printk(KERN_INFO "%s: limit ATAPI UDMA to UDMA4\n", DRV_NAME);
 		mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 /**
@@ -931,7 +931,7 @@ static void scc_irq_clear (struct ata_port *ap)
  *	scc_port_start - Set port up for dma.
  *	@ap: Port to initialize
  *
- *	Allocate space for PRD table using ata_port_start().
+ *	Allocate space for PRD table using ata_bmdma_port_start().
  *	Set PRD table address for PTERADD. (PRD Transfer End Read)
  */
 
@@ -940,7 +940,7 @@ static int scc_port_start (struct ata_port *ap)
 	void __iomem *mmio = ap->ioaddr.bmdma_addr;
 	int rc;
 
-	rc = ata_port_start(ap);
+	rc = ata_bmdma_port_start(ap);
 	if (rc)
 		return rc;
 
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index ffd26d0..d1be370 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -199,7 +199,7 @@ static unsigned long serverworks_osb4_filter(struct ata_device *adev, unsigned l
 {
 	if (adev->class == ATA_DEV_ATA)
 		mask &= ~ATA_MASK_UDMA;
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 
@@ -219,7 +219,7 @@ static unsigned long serverworks_csb_filter(struct ata_device *adev, unsigned lo
 
 	/* Disk, UDMA */
 	if (adev->class != ATA_DEV_ATA)
-		return ata_bmdma_mode_filter(adev, mask);
+		return mask;
 
 	/* Actually do need to check */
 	ata_id_c_string(adev->id, model_num, ATA_ID_PROD, sizeof(model_num));
@@ -228,7 +228,7 @@ static unsigned long serverworks_csb_filter(struct ata_device *adev, unsigned lo
 		if (!strcmp(p, model_num))
 			mask &= ~(0xE0 << ATA_SHIFT_UDMA);
 	}
-	return ata_bmdma_mode_filter(adev, mask);
+	return mask;
 }
 
 /**
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index b8cc349..943f204 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -553,11 +553,7 @@ static int adma_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->host->dev;
 	struct adma_port_priv *pp;
-	int rc;
 
-	rc = ata_port_start(ap);
-	if (rc)
-		return rc;
 	adma_enter_reg_mode(ap);
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index e87349d..eabf7dd 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -681,7 +681,6 @@ static int inic_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->host->dev;
 	struct inic_port_priv *pp;
-	int rc;
 
 	/* alloc and initialize private data */
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
@@ -690,10 +689,6 @@ static int inic_port_start(struct ata_port *ap)
 	ap->private_data = pp;
 
 	/* Alloc resources */
-	rc = ata_port_start(ap);
-	if (rc)
-		return rc;
-
 	pp->pkt = dmam_alloc_coherent(dev, sizeof(struct inic_pkt),
 				      &pp->pkt_dma, GFP_KERNEL);
 	if (!pp->pkt)
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 521dcd3..1a9b8e6 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1101,7 +1101,8 @@ static int nv_adma_port_start(struct ata_port *ap)
 	if (rc)
 		return rc;
 
-	rc = ata_port_start(ap);
+	/* we might fallback to bmdma, allocate bmdma resources */
+	rc = ata_bmdma_port_start(ap);
 	if (rc)
 		return rc;
 
@@ -1910,7 +1911,8 @@ static int nv_swncq_port_start(struct ata_port *ap)
 	struct nv_swncq_port_priv *pp;
 	int rc;
 
-	rc = ata_port_start(ap);
+	/* we might fallback to bmdma, allocate bmdma resources */
+	rc = ata_bmdma_port_start(ap);
 	if (rc)
 		return rc;
 
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 3c440e5..d65b5a6 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -310,7 +310,8 @@ static int pdc_common_port_start(struct ata_port *ap)
 	struct pdc_port_priv *pp;
 	int rc;
 
-	rc = ata_port_start(ap);
+	/* we use the same prd table as bmdma, allocate it */
+	rc = ata_bmdma_port_start(ap);
 	if (rc)
 		return rc;
 
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 48a3756..62403a8 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -502,11 +502,7 @@ static int qs_port_start(struct ata_port *ap)
 	void __iomem *mmio_base = qs_mmio_base(ap->host);
 	void __iomem *chan = mmio_base + (ap->port_no * 0x4000);
 	u64 addr;
-	int rc;
 
-	rc = ata_port_start(ap);
-	if (rc)
-		return rc;
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
 		return -ENOMEM;
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 8027f64..1a6ab4c 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -291,11 +291,6 @@ static int pdc_port_start(struct ata_port *ap)
 {
 	struct device *dev = ap->host->dev;
 	struct pdc_port_priv *pp;
-	int rc;
-
-	rc = ata_port_start(ap);
-	if (rc)
-		return rc;
 
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 019575b..4801689 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -180,9 +180,7 @@ static int uli_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	rc = ata_pci_bmdma_init(host);
-	if (rc)
-		return rc;
+	ata_pci_bmdma_init(host);
 
 	iomap = host->iomap;
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c7fb1a2..ea415aa 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -949,7 +949,6 @@ extern unsigned long ata_xfer_mode2mask(u8 xfer_mode);
 extern int ata_xfer_mode2shift(unsigned long xfer_mode);
 extern const char *ata_mode_string(unsigned long xfer_mask);
 extern unsigned long ata_id_xfermask(const u16 *id);
-extern int ata_port_start(struct ata_port *ap);
 extern int ata_std_qc_defer(struct ata_queued_cmd *qc);
 extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
@@ -1521,7 +1520,6 @@ extern int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
 extern void ata_sff_postreset(struct ata_link *link, unsigned int *classes);
 extern void ata_sff_error_handler(struct ata_port *ap);
 extern void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc);
-extern int ata_sff_port_start(struct ata_port *ap);
 extern void ata_sff_std_ports(struct ata_ioports *ioaddr);
 #ifdef CONFIG_PCI
 extern int ata_pci_sff_init_host(struct ata_host *host);
@@ -1538,16 +1536,15 @@ extern int ata_pci_sff_init_one(struct pci_dev *pdev,
 
 extern void ata_bus_reset(struct ata_port *ap);		/* deprecated */
 
-extern unsigned long ata_bmdma_mode_filter(struct ata_device *dev,
-					   unsigned long xfer_mask);
 extern void ata_bmdma_setup(struct ata_queued_cmd *qc);
 extern void ata_bmdma_start(struct ata_queued_cmd *qc);
 extern void ata_bmdma_stop(struct ata_queued_cmd *qc);
 extern u8 ata_bmdma_status(struct ata_port *ap);
+extern int ata_bmdma_port_start(struct ata_port *ap);
 
 #ifdef CONFIG_PCI
 extern int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev);
-extern int ata_pci_bmdma_init(struct ata_host *host);
+extern void ata_pci_bmdma_init(struct ata_host *host);
 #endif /* CONFIG_PCI */
 
 /**
-- 
1.5.4.5

