From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 20/22] libata-sff: separate out BMDMA init
Date: Tue, 21 Oct 2008 18:17:58 +0900
Message-ID: <1224580680-13698-21-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:46091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbYJUJVT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 05:21:19 -0400
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>

Separate out ata_pci_bmdma_prepare_host() and ata_pci_bmdma_init_one()
from their SFF counterparts.  SFF ones no longer try to initialize
BMDMA or set PCI master.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/ata_piix.c          |    2 +-
 drivers/ata/libata-sff.c        |  135 ++++++++++++++++++++++++++++++++-------
 drivers/ata/pata_acpi.c         |    2 +-
 drivers/ata/pata_ali.c          |    5 +-
 drivers/ata/pata_amd.c          |    2 +-
 drivers/ata/pata_artop.c        |    2 +-
 drivers/ata/pata_atiixp.c       |    2 +-
 drivers/ata/pata_cmd64x.c       |    2 +-
 drivers/ata/pata_cs5530.c       |    2 +-
 drivers/ata/pata_cs5535.c       |    2 +-
 drivers/ata/pata_cs5536.c       |    2 +-
 drivers/ata/pata_cypress.c      |    2 +-
 drivers/ata/pata_efar.c         |    2 +-
 drivers/ata/pata_hpt366.c       |    2 +-
 drivers/ata/pata_hpt37x.c       |    2 +-
 drivers/ata/pata_hpt3x2n.c      |    2 +-
 drivers/ata/pata_it8213.c       |    2 +-
 drivers/ata/pata_it821x.c       |    2 +-
 drivers/ata/pata_jmicron.c      |    2 +-
 drivers/ata/pata_marvell.c      |    2 +-
 drivers/ata/pata_netcell.c      |    2 +-
 drivers/ata/pata_ns87415.c      |    2 +-
 drivers/ata/pata_oldpiix.c      |    2 +-
 drivers/ata/pata_optidma.c      |    2 +-
 drivers/ata/pata_pdc202xx_old.c |    2 +-
 drivers/ata/pata_radisys.c      |    2 +-
 drivers/ata/pata_sc1200.c       |    2 +-
 drivers/ata/pata_sch.c          |    2 +-
 drivers/ata/pata_serverworks.c  |    2 +-
 drivers/ata/pata_sil680.c       |    2 +-
 drivers/ata/pata_sis.c          |    2 +-
 drivers/ata/pata_sl82c105.c     |    2 +-
 drivers/ata/pata_triflex.c      |    2 +-
 drivers/ata/pata_via.c          |    2 +-
 drivers/ata/sata_nv.c           |    2 +-
 drivers/ata/sata_sis.c          |    2 +-
 drivers/ata/sata_via.c          |    2 +-
 include/linux/libata.h          |    7 ++
 38 files changed, 157 insertions(+), 60 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index c1da5e6..1959254 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1435,7 +1435,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 		hpriv->map = piix_init_sata_map(pdev, port_info,
 					piix_map_db_table[ent->driver_data]);
 
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 	host->private_data = hpriv;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 4655181..2a4e62d 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1974,13 +1974,13 @@ int ata_pci_sff_init_host(struct ata_host *host)
 }
 
 /**
- *	ata_pci_sff_prepare_host - helper to prepare native PCI ATA host
+ *	ata_pci_sff_prepare_host - helper to prepare PCI PIO-only SFF ATA host
  *	@pdev: target PCI device
  *	@ppi: array of port_info, must be enough for two ports
  *	@r_host: out argument for the initialized ATA host
  *
- *	Helper to allocate ATA host for @pdev, acquire all native PCI
- *	resources and initialize it accordingly in one go.
+ *	Helper to allocate PIO-only SFF ATA host for @pdev, acquire
+ *	all PCI resources and initialize it accordingly in one go.
  *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
@@ -2010,9 +2010,6 @@ int ata_pci_sff_prepare_host(struct pci_dev *pdev,
 	if (rc)
 		goto err_out;
 
-	/* init DMA related stuff */
-	ata_pci_bmdma_init(host);
-
 	devres_remove_group(&pdev->dev, NULL);
 	*r_host = host;
 	return 0;
@@ -2115,8 +2112,21 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 	return rc;
 }
 
+static const struct ata_port_info *ata_sff_find_valid_pi(
+					const struct ata_port_info * const *ppi)
+{
+	int i;
+
+	/* look up the first valid port_info */
+	for (i = 0; i < 2 && ppi[i]; i++)
+		if (ppi[i]->port_ops != &ata_dummy_port_ops)
+			return ppi[i];
+
+	return NULL;
+}
+
 /**
- *	ata_pci_sff_init_one - Initialize/register PCI IDE host controller
+ *	ata_pci_sff_init_one - Initialize/register PIO-only PCI IDE controller
  *	@pdev: Controller to be initialized
  *	@ppi: array of port_info, must be enough for two ports
  *	@sht: scsi_host_template to use when registering the host
@@ -2124,11 +2134,7 @@ int ata_pci_sff_activate_host(struct ata_host *host,
  *
  *	This is a helper function which can be called from a driver's
  *	xxx_init_one() probe function if the hardware uses traditional
- *	IDE taskfile registers.
- *
- *	This function calls pci_enable_device(), reserves its register
- *	regions, sets the dma mask, enables bus master mode, and calls
- *	ata_device_add()
+ *	IDE taskfile registers and is PIO only.
  *
  *	ASSUMPTION:
  *	Nobody makes a single channel controller that appears solely as
@@ -2145,20 +2151,13 @@ int ata_pci_sff_init_one(struct pci_dev *pdev,
 			 struct scsi_host_template *sht, void *host_priv)
 {
 	struct device *dev = &pdev->dev;
-	const struct ata_port_info *pi = NULL;
+	const struct ata_port_info *pi;
 	struct ata_host *host = NULL;
-	int i, rc;
+	int rc;
 
 	DPRINTK("ENTER\n");
 
-	/* look up the first valid port_info */
-	for (i = 0; i < 2 && ppi[i]; i++) {
-		if (ppi[i]->port_ops != &ata_dummy_port_ops) {
-			pi = ppi[i];
-			break;
-		}
-	}
-
+	pi = ata_sff_find_valid_pi(ppi);
 	if (!pi) {
 		dev_printk(KERN_ERR, &pdev->dev,
 			   "no valid port_info specified\n");
@@ -2178,8 +2177,7 @@ int ata_pci_sff_init_one(struct pci_dev *pdev,
 		goto out;
 	host->private_data = host_priv;
 
-	pci_set_master(pdev);
-	rc = ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
+	rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
  out:
 	if (rc == 0)
 		devres_remove_group(&pdev->dev, NULL);
@@ -2914,6 +2912,93 @@ void ata_pci_bmdma_init(struct ata_host *host)
 	}
 }
 
+/**
+ *	ata_pci_bmdma_prepare_host - helper to prepare PCI BMDMA ATA host
+ *	@pdev: target PCI device
+ *	@ppi: array of port_info, must be enough for two ports
+ *	@r_host: out argument for the initialized ATA host
+ *
+ *	Helper to allocate BMDMA ATA host for @pdev, acquire all PCI
+ *	resources and initialize it accordingly in one go.
+ *
+ *	LOCKING:
+ *	Inherited from calling layer (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno otherwise.
+ */
+int ata_pci_bmdma_prepare_host(struct pci_dev *pdev,
+			       const struct ata_port_info * const * ppi,
+			       struct ata_host **r_host)
+{
+	int rc;
+
+	rc = ata_pci_sff_prepare_host(pdev, ppi, r_host);
+	if (rc)
+		return rc;
+
+	ata_pci_bmdma_init(*r_host);
+	return 0;
+}
+
+/**
+ *	ata_pci_bmdma_init_one - Initialize/register BMDMA PCI IDE controller
+ *	@pdev: Controller to be initialized
+ *	@ppi: array of port_info, must be enough for two ports
+ *	@sht: scsi_host_template to use when registering the host
+ *	@host_priv: host private_data
+ *
+ *	This function is similar to ata_pci_sff_init_one() but also
+ *	takes care of BMDMA initialization.
+ *
+ *	LOCKING:
+ *	Inherited from PCI layer (may sleep).
+ *
+ *	RETURNS:
+ *	Zero on success, negative on errno-based value on error.
+ */
+int ata_pci_bmdma_init_one(struct pci_dev *pdev,
+			   const struct ata_port_info * const * ppi,
+			   struct scsi_host_template *sht, void *host_priv)
+{
+	struct device *dev = &pdev->dev;
+	const struct ata_port_info *pi;
+	struct ata_host *host = NULL;
+	int rc;
+
+	DPRINTK("ENTER\n");
+
+	pi = ata_sff_find_valid_pi(ppi);
+	if (!pi) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "no valid port_info specified\n");
+		return -EINVAL;
+	}
+
+	if (!devres_open_group(dev, NULL, GFP_KERNEL))
+		return -ENOMEM;
+
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		goto out;
+
+	/* prepare and activate BMDMA host */
+	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
+	if (rc)
+		goto out;
+	host->private_data = host_priv;
+
+	pci_set_master(pdev);
+	rc = ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
+ out:
+	if (rc == 0)
+		devres_remove_group(&pdev->dev, NULL);
+	else
+		devres_release_group(&pdev->dev, NULL);
+
+	return rc;
+}
+
 #endif /* CONFIG_PCI */
 
 /**
@@ -3023,4 +3108,6 @@ EXPORT_SYMBOL_GPL(ata_bmdma_port_start);
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(ata_pci_bmdma_clear_simplex);
 EXPORT_SYMBOL_GPL(ata_pci_bmdma_init);
+EXPORT_SYMBOL_GPL(ata_pci_bmdma_prepare_host);
+EXPORT_SYMBOL_GPL(ata_pci_bmdma_init_one);
 #endif /* CONFIG_PCI */
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 49ccc2d..6e1bfda 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -265,7 +265,7 @@ static int pacpi_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 			return rc;
 		pcim_pin_device(pdev);
 	}
-	return ata_pci_sff_init_one(pdev, ppi, &pacpi_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &pacpi_sht, NULL);
 }
 
 static const struct pci_device_id pacpi_pci_tbl[] = {
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 171a49e..8ccf889 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -553,7 +553,10 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	pci_dev_put(isa_bridge);
 
-	return ata_pci_sff_init_one(pdev, ppi, &ali_sht, NULL);
+	if (!ppi[0]->mwdma_mask && !ppi[0]->udma_mask)
+		return ata_pci_sff_init_one(pdev, ppi, &ali_sht, NULL);
+	else
+		return ata_pci_bmdma_init_one(pdev, ppi, &ali_sht, NULL);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 57dd00f..19de535 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -523,7 +523,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* And fire it up */
-	return ata_pci_sff_init_one(pdev, ppi, &amd_sht, hpriv);
+	return ata_pci_bmdma_init_one(pdev, ppi, &amd_sht, hpriv);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 0f513bc..80cff6f 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -400,7 +400,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 
 	BUG_ON(ppi[0] == NULL);
 
-	return ata_pci_sff_init_one(pdev, ppi, &artop_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &artop_sht, NULL);
 }
 
 static const struct pci_device_id artop_pci_tbl[] = {
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 3fae282..60ffd04 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -243,7 +243,7 @@ static int atiixp_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &atiixp_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
-	return ata_pci_sff_init_one(dev, ppi, &atiixp_sht, NULL);
+	return ata_pci_bmdma_init_one(dev, ppi, &atiixp_sht, NULL);
 }
 
 static const struct pci_device_id atiixp[] = {
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index ddd09b7..a770b37 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -373,7 +373,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
 #endif
 
-	return ata_pci_sff_init_one(pdev, ppi, &cmd64x_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &cmd64x_sht, NULL);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index f267953..6c8ee7d 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -325,7 +325,7 @@ static int cs5530_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ppi[1] = &info_palmax_secondary;
 
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(pdev, ppi, &cs5530_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &cs5530_sht, NULL);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index f1b6556..6d9cc80 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -199,7 +199,7 @@ static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	rdmsr(ATAC_CH0D1_PIO, timings, dummy);
 	if (CS5535_BAD_PIO(timings))
 		wrmsr(ATAC_CH0D1_PIO, 0xF7F4F7F4UL, 0);
-	return ata_pci_sff_init_one(dev, ppi, &cs5535_sht, NULL);
+	return ata_pci_bmdma_init_one(dev, ppi, &cs5535_sht, NULL);
 }
 
 static const struct pci_device_id cs5535[] = {
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 73f8332..2310acb 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -261,7 +261,7 @@ static int cs5536_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		return -ENODEV;
 	}
 
-	return ata_pci_sff_init_one(dev, ppi, &cs5536_sht, NULL);
+	return ata_pci_bmdma_init_one(dev, ppi, &cs5536_sht, NULL);
 }
 
 static const struct pci_device_id cs5536[] = {
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index 2ff6260..43c4571 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -136,7 +136,7 @@ static int cy82c693_init_one(struct pci_dev *pdev, const struct pci_device_id *i
 	if (PCI_FUNC(pdev->devfn) != 1)
 		return -ENODEV;
 
-	return ata_pci_sff_init_one(pdev, ppi, &cy82c693_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &cy82c693_sht, NULL);
 }
 
 static const struct pci_device_id cy82c693[] = {
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 9fba829..67a0ff0 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -262,7 +262,7 @@ static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &efar_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &efar_sht, NULL);
 }
 
 static const struct pci_device_id efar_pci_tbl[] = {
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index d7b0bc5..f0e6c4c 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -393,7 +393,7 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			break;
 	}
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(dev, ppi, &hpt36x_sht, hpriv);
+	return ata_pci_bmdma_init_one(dev, ppi, &hpt36x_sht, hpriv);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index b380d57..fe654ae 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -1019,7 +1019,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	}
 
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(dev, ppi, &hpt37x_sht, private_data);
+	return ata_pci_bmdma_init_one(dev, ppi, &hpt37x_sht, private_data);
 }
 
 static const struct pci_device_id hpt37x[] = {
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 4fb82d1..5d1ef7e 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -554,7 +554,7 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	}
 
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(dev, ppi, &hpt3x2n_sht, hpriv);
+	return ata_pci_bmdma_init_one(dev, ppi, &hpt3x2n_sht, hpriv);
 }
 
 static const struct pci_device_id hpt3x2n[] = {
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index c113d7c..f6dff1e 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -274,7 +274,7 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &it8213_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &it8213_sht, NULL);
 }
 
 static const struct pci_device_id it8213_pci_tbl[] = {
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 8a65309..fd5af2b 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -923,7 +923,7 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		else
 			ppi[0] = &info_smart;
 	}
-	return ata_pci_sff_init_one(pdev, ppi, &it821x_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &it821x_sht, NULL);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 73b7596..5d220fc 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -144,7 +144,7 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	return ata_pci_sff_init_one(pdev, ppi, &jmicron_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &jmicron_sht, NULL);
 }
 
 static const struct pci_device_id jmicron_pci_tbl[] = {
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 0d87eec..f5c8db5 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -153,7 +153,7 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 		return -ENODEV;
 	}
 #endif
-	return ata_pci_sff_init_one(pdev, ppi, &marvell_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &marvell_sht, NULL);
 }
 
 static const struct pci_device_id marvell_pci_tbl[] = {
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index d9719c8..c540c90 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -71,7 +71,7 @@ static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	ata_pci_bmdma_clear_simplex(pdev);
 
 	/* And let the library code do the work */
-	return ata_pci_sff_init_one(pdev, port_info, &netcell_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, port_info, &netcell_sht, NULL);
 }
 
 static const struct pci_device_id netcell_pci_tbl[] = {
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index 260e0b0..31e7f83 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -375,7 +375,7 @@ static int ns87415_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	pci_write_config_byte(pdev, 0x55, 0xEE);
 	/* Select PIO0 8bit clocking */
 	pci_write_config_byte(pdev, 0x54, 0xB7);
-	return ata_pci_sff_init_one(pdev, ppi, &ns87415_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &ns87415_sht, NULL);
 }
 
 static const struct pci_device_id ns87415_pci_tbl[] = {
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 5c073ca..ef637c0 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -249,7 +249,7 @@ static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &oldpiix_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &oldpiix_sht, NULL);
 }
 
 static const struct pci_device_id oldpiix_pci_tbl[] = {
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 4cd7444..522b0ca 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -430,7 +430,7 @@ static int optidma_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (optiplus_with_udma(dev))
 		ppi[0] = &info_82c700_udma;
 
-	return ata_pci_sff_init_one(dev, ppi, &optidma_sht, NULL);
+	return ata_pci_bmdma_init_one(dev, ppi, &optidma_sht, NULL);
 }
 
 static const struct pci_device_id optidma[] = {
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index b452e4a..43ec5e6 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -324,7 +324,7 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 				return -ENODEV;
 		}
 	}
-	return ata_pci_sff_init_one(dev, ppi, &pdc202xx_sht, NULL);
+	return ata_pci_bmdma_init_one(dev, ppi, &pdc202xx_sht, NULL);
 }
 
 static const struct pci_device_id pdc202xx[] = {
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index aa38e6d..8e4c519 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -228,7 +228,7 @@ static int radisys_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &radisys_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &radisys_sht, NULL);
 }
 
 static const struct pci_device_id radisys_pci_tbl[] = {
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index a1db07a..c836e1b 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -213,7 +213,7 @@ static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* Can't enable port 2 yet, see top comments */
 	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 
-	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL);
+	return ata_pci_bmdma_init_one(dev, ppi, &sc1200_sht, NULL);
 }
 
 static const struct pci_device_id sc1200[] = {
diff --git a/drivers/ata/pata_sch.c b/drivers/ata/pata_sch.c
index 4c77d63..0b381f1 100644
--- a/drivers/ata/pata_sch.c
+++ b/drivers/ata/pata_sch.c
@@ -179,7 +179,7 @@ static int __devinit sch_init_one(struct pci_dev *pdev,
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &sch_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &sch_sht, NULL);
 }
 
 static int __init sch_init(void)
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index d1be370..3a15ac5 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -461,7 +461,7 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 	if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE)
 		ata_pci_bmdma_clear_simplex(pdev);
 
-	return ata_pci_sff_init_one(pdev, ppi, &serverworks_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &serverworks_sht, NULL);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 9fffab2..7c85227 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -359,7 +359,7 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 				 IRQF_SHARED, &sil680_sht);
 
 use_ioports:
-	return ata_pci_sff_init_one(pdev, ppi, &sil680_sht, NULL);
+	return ata_pci_bmdma_init_one(pdev, ppi, &sil680_sht, NULL);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 26345d7..cda3338 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -822,7 +822,7 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	sis_fixup(pdev, chipset);
 
-	return ata_pci_sff_init_one(pdev, ppi, &sis_sht, chipset);
+	return ata_pci_bmdma_init_one(pdev, ppi, &sis_sht, chipset);
 }
 
 static const struct pci_device_id sis_pci_tbl[] = {
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 69877bd..51d1481 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -317,7 +317,7 @@ static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id
 	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
 	pci_write_config_dword(dev, 0x40, val);
 
-	return ata_pci_sff_init_one(dev, ppi, &sl82c105_sht, NULL);
+	return ata_pci_bmdma_init_one(dev, ppi, &sl82c105_sht, NULL);
 }
 
 static const struct pci_device_id sl82c105[] = {
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index b181261..fa1b074 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -201,7 +201,7 @@ static int triflex_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(dev, ppi, &triflex_sht, NULL);
+	return ata_pci_bmdma_init_one(dev, ppi, &triflex_sht, NULL);
 }
 
 static const struct pci_device_id triflex[] = {
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 8fdb2ce..fdd132e 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -537,7 +537,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* We have established the device type, now fire it up */
-	return ata_pci_sff_init_one(pdev, ppi, &via_sht, (void *)config);
+	return ata_pci_bmdma_init_one(pdev, ppi, &via_sht, (void *)config);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 0806f65..ca132c5 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -2360,7 +2360,7 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ppi[0] = &nv_port_info[type];
 	ipriv = ppi[0]->private_data;
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 6104df7..b65eb71 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -315,7 +315,7 @@ static int sis_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		break;
 	}
 
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 7ebc406..1d40df1 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -316,7 +316,7 @@ static int vt6420_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
 	struct ata_host *host;
 	int rc;
 
-	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 	*r_host = host;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 8cc0a9b..d500200 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1554,6 +1554,13 @@ extern int ata_bmdma_port_start(struct ata_port *ap);
 #ifdef CONFIG_PCI
 extern int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev);
 extern void ata_pci_bmdma_init(struct ata_host *host);
+extern int ata_pci_bmdma_prepare_host(struct pci_dev *pdev,
+				      const struct ata_port_info * const * ppi,
+				      struct ata_host **r_host);
+extern int ata_pci_bmdma_init_one(struct pci_dev *pdev,
+				  const struct ata_port_info * const * ppi,
+				  struct scsi_host_template *sht,
+				  void *host_priv);
 #endif /* CONFIG_PCI */
 
 /**
-- 
1.5.4.5

