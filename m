From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/3] add support for DWC UFS Host Controller
Date: Wed, 03 Feb 2016 13:54:25 +0100
Message-ID: <2072510.CA47OHQsUN@wuerfel>
References: <cover.1454498292.git.jpinto@synopsys.com> <a519617624ecdc98be82c376d4359a91f6a823b0.1454498292.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:61218 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757693AbcBCMzB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2016 07:55:01 -0500
In-Reply-To: <a519617624ecdc98be82c376d4359a91f6a823b0.1454498292.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: santosh.sy@samsung.com, h.vinayak@samsung.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org

On Wednesday 03 February 2016 11:28:26 Joao Pinto wrote:
> 
> Signed-off-by: Joao Pinto <jpinto@synopsys.com>

This needs a changelog comment, like every patch.

> @@ -0,0 +1,16 @@
> +* Universal Flash Storage (UFS) DesignWare Host Controller
> +
> +DWC_UFSHC nodes are defined to describe on-chip UFS host controllers.
> +Each UFS controller instance should have its own node.
> +
> +Required properties:
> +- compatible        : compatible list, contains "snps,ufshcd"

Are there multiple versions of this controller? Usually for designware
parts the version is known, so we should document which versions exist

> +
> +config SCSI_UFS_DWC_HOOKS
> +	bool "DesignWare hooks to UFS controller"
> +	depends on SCSI_UFSHCD
> +	---help---
> +	  This selects the DesignWare hooks for the UFS host controller.
> +
> +	  Select this if you have a DesignWare UFS controller.
> +	  If unsure, say N.

This could be a silent symbol that gets selected by SCSI_UFS_DWC_PLAT

> +config SCSI_UFS_DWC_MPHY_TC
> +	bool "Support for the Synopsys MPHY Test Chip"
> +	depends on SCSI_UFS_DWC_HOOKS && (SCSI_UFSHCD_PCI || SCSI_UFS_DWC_PLAT)
> +	---help---
> +	  This selects the support for the Synopsys MPHY Test Chip.
> +
> +	  Select this if you have a Synopsys MPHY Test Chip.
> +	  If unsure, say N.
> +
> +config SCSI_UFS_DWC_20BIT_RMMI
> +	bool "20-bit RMMI MPHY"
> +	depends on SCSI_UFS_DWC_MPHY_TC
> +	---help---
> +	  This specifies that the Synopsys MPHY supports 40-bit RMMI operations.
> +
> +	  Select this if you are using a 40-bit RMMI Synopsys MPHY.
> +	  If unsure, say N.
> +
> +config SCSI_UFS_DWC_40BIT_RMMI
> +	bool "40-bit RMMI MPHY"
> +	depends on SCSI_UFS_DWC_MPHY_TC
> +	---help---
> +	  This specifies that the Synopsys MPHY supports 40-bit RMMI operations.
> +
> +	  Select this if you are using a 40-bit RMMI Synopsys MPHY.
> +	  If unsure, say N.

Move the PHY config options to drivers/phy/ along with the respective
drivers, the device using the PHY should not need to be aware which
one is being used.

> +/**
> + * ufshcd_dwc_setup_mphy()
> + * This function configures Local (host) Synopsys MPHY specific attributes
> + *
> + * @hba: Pointer to drivers structure
> + *
> + * Returns 0 on success non-zero value on failure
> + */
> +int ufshcd_dwc_setup_mphy(struct ufs_hba *hba)
> +{
> +	int ret = 0;
> +
> +#ifdef CONFIG_SCSI_UFS_DWC_40BIT_RMMI
> +	dev_info(hba->dev, "Configuring MPHY 40-bit RMMI");
> +	ret = ufshcd_dwc_setup_40bit_rmmi(hba);
> +	if (ret) {
> +		dev_err(hba->dev, "40-bit RMMI configuration failed");
> +		goto out;
> +	}
> +#else
> +#ifdef CONFIG_SCSI_UFS_DWC_20BIT_RMMI
> +	dev_info(hba->dev, "Configuring MPHY 20-bit RMMI");
> +	ret = ufshcd_dwc_setup_20bit_rmmi(hba);
> +	if (ret) {
> +		dev_err(hba->dev, "20-bit RMMI configuration failed");
> +		goto out;
> +	}
> +#endif
> +#endif
> +	/* To write Shadow register bank to effective configuration block */
> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_MPHYCFGUPDT), 0x01);
> +	if (ret)
> +		goto out;
> +
> +	/* To configure Debug OMC */
> +	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_DEBUGOMC), 0x01);
> +
> +out:
> +	return ret;
> +}

Try to use the generic PHY abstraction here and remove all the #ifdef etc.

> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
> index d15eaa4..66518a1 100644
> --- a/drivers/scsi/ufs/ufshcd-pci.c
> +++ b/drivers/scsi/ufs/ufshcd-pci.c
> @@ -34,6 +34,9 @@
>   */
>  
>  #include "ufshcd.h"
> +#ifdef CONFIG_SCSI_UFS_DWC_HOOKS
> +#include "ufshcd-dwc.h"
> +#endif
>  #include <linux/pci.h>
>  #include <linux/pm_runtime.h>
>  
> @@ -83,6 +86,16 @@ static int ufshcd_pci_runtime_idle(struct device *dev)
>  #define ufshcd_pci_runtime_idle	NULL
>  #endif /* CONFIG_PM */
>  
> +#ifdef CONFIG_SCSI_UFS_DWC_HOOKS
> +/**
> + * struct ufs_hba_dwc_vops - UFS DWC specific variant operations
> + */
> +static struct ufs_hba_variant_ops ufs_dwc_pci_hba_vops = {
> +	.name                   = "dwc-pci",
> +	.custom_probe_hba	= ufshcd_dwc_configuration,
> +};
> +#endif
> +
>  /**
>   * ufshcd_pci_shutdown - main function to put the controller in reset state
>   * @pdev: pointer to PCI device handle
> @@ -144,6 +157,9 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	INIT_LIST_HEAD(&hba->clk_list_head);
>  
> +#ifdef CONFIG_SCSI_UFS_DWC_HOOKS
> +	hba->vops = &ufs_dwc_pci_hba_vops;
> +#endif
>  	err = ufshcd_init(hba, mmio_base, pdev->irq);
>  	if (err) {
>  		dev_err(&pdev->dev, "Initialization failed\n");
> @@ -167,6 +183,10 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
>  
>  static const struct pci_device_id ufshcd_pci_tbl[] = {
>  	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> +#ifdef CONFIG_SCSI_UFS_DWC_HOOKS
> +	{ PCI_VENDOR_ID_SYNOPSYS, 0xB101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> +	{ PCI_VENDOR_ID_SYNOPSYS, 0xB102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> +#endif
>  	{ }	/* terminate list */
>  };

I think you're better off with a separate PCI driver for this. Remove
all the #ifdef mess here, put whatever is dwc specific into a new file,
and perhaps move the common parts into a shared file that can be used
by both the samsung and designware drivers.

	Arnd
