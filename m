From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v6 2/2] add support for DWC UFS Host Controller
Date: Wed, 10 Feb 2016 21:50:28 +0100
Message-ID: <6667560.LIsUD7xT9u@wuerfel>
References: <cover.1455120183.git.jpinto@synopsys.com> <0787e532da876f7f38b4f439ec2e16bfcbaa9cb3.1455120183.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:65223 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbcBJUvJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2016 15:51:09 -0500
In-Reply-To: <0787e532da876f7f38b4f439ec2e16bfcbaa9cb3.1455120183.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, mark.rutland@arm.com, martin.petersen@oracle.com, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org

On Wednesday 10 February 2016 16:06:13 Joao Pinto wrote:
> This patch has the goal to add support for DesignWare UFS Controller
> specific operations and to add specific platform and pci drivers.
> 
> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
>  Documentation/devicetree/bindings/ufs/ufs-dwc.txt |  17 +
>  MAINTAINERS                                       |   6 +
>  drivers/scsi/ufs/Kconfig                          |  41 ++
>  drivers/scsi/ufs/Makefile                         |   3 +
>  drivers/scsi/ufs/ufs-dwc-pci.c                    | 180 ++++++
>  drivers/scsi/ufs/ufs-dwc.c                        | 102 +++
>  drivers/scsi/ufs/ufshcd-dwc.c                     | 736 ++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd-dwc.h                     |  18 +
>  drivers/scsi/ufs/ufshcd.c                         |  50 +-
>  drivers/scsi/ufs/ufshcd.h                         |  13 +
>  drivers/scsi/ufs/ufshci-dwc.h                     |  42 ++
>  drivers/scsi/ufs/ufshci.h                         |   1 +
>  drivers/scsi/ufs/unipro.h                         |  39 ++

Can you split this into separate patches for changes to the common code,
the addition of the PCI driver and the addition of the platform driver?

> diff --git a/Documentation/devicetree/bindings/ufs/ufs-dwc.txt b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
> new file mode 100644
> index 0000000..f38a3f5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
> @@ -0,0 +1,17 @@
> +* Universal Flash Storage (UFS) DesignWare Host Controller
> +
> +DWC_UFSHC nodes are defined to describe on-chip UFS host controllers.
> +Each UFS controller instance should have its own node.
> +
> +Required properties:
> +- compatible        : compatible string ("snps,ufshcd-1.0", "snps,ufshcd-1.1"
> +  or "snps,ufshcd-2.0")
> +- reg               : <registers mapping>
> +- interrupts        : <interrupt mapping for UFS host controller IRQ>
> +
> +Example:
> +	dwc_ufshcd@0xD0000000 {

Please fix the node name and address in the example. I think you want "ufs@d0000000".

> +config SCSI_UFS_DWC_MPHY_TC
> +	bool "Support for the Synopsys MPHY Test Chip"
> +	depends on SCSI_UFS_DWC_HOOKS && (SCSI_UFSHCD_PCI || SCSI_UFS_DWC_PLAT)
> +	---help---
> +	  This selects the support for the Synopsys MPHY Test Chip.
> +
> +	  Select this if you have a Synopsys MPHY Test Chip.
> +	  If unsure, say N.
> +
> +config SCSI_UFS_DWC_40BIT_RMMI
> +	bool "40-bit RMMI MPHY"
> +	depends on SCSI_UFS_DWC_MPHY_TC
> +	---help---
> +	  This specifies that the Synopsys MPHY supports 40-bit RMMI operations.
> +
> +	  Select this if you are using a 40-bit RMMI Synopsys MPHY.

I don't think I understood you explanation why this has to be here,
rather than using a proper PHY driver. Please try again.

> +
> +#ifdef CONFIG_PM
> +/**
> + * ufs_dw_pci_suspend - suspend power management function
> + * @pdev: pointer to PCI device handle
> + * @state: power state
> + *
> + * Returns 0 if successful
> + * Returns non-zero otherwise
> + */
> +static int ufs_dw_pci_suspend(struct device *dev)
> +{
> +	return ufshcd_system_suspend(dev_get_drvdata(dev));
> +}

Please remove the #ifdef here.

> +
> +static const struct dev_pm_ops ufs_dw_pci_pm_ops = {
> +	.suspend	= ufs_dw_pci_suspend,
> +	.resume		= ufs_dw_pci_resume,
> +	.runtime_suspend = ufs_dw_pci_runtime_suspend,
> +	.runtime_resume  = ufs_dw_pci_runtime_resume,
> +	.runtime_idle    = ufs_dw_pci_runtime_idle,
> +};

Instead, use the macros from include/linux/pm.h

> +#ifdef CONFIG_SCSI_UFS_DWC_40BIT_RMMI
> +/**
> + * ufshcd_dwc_setup_40bit_rmmi()
> + * This function configures Synopsys MPHY specific atributes (40-bit RMMI)
> + * @hba: Pointer to drivers structure
> + *
> + * Returns 0 on success or non-zero value on failure
> + */
> +static int ufshcd_dwc_setup_40bit_rmmi(struct ufs_hba *hba)
> +{
> +	int ret = 0;

This looks like it should go into the external driver

> +
> +#ifdef CONFIG_SCSI_UFS_DWC_40BIT_RMMI
> +	dev_info(hba->dev, "Configuring MPHY 40-bit RMMI");
> +	ret = ufshcd_dwc_setup_40bit_rmmi(hba);
> +	if (ret) {
> +		dev_err(hba->dev, "40-bit RMMI configuration failed");
> +		goto out;
> +	}
> +#else
> +	dev_info(hba->dev, "Configuring MPHY 20-bit RMMI");
> +	ret = ufshcd_dwc_setup_20bit_rmmi(hba);
> +	if (ret) {
> +		dev_err(hba->dev, "20-bit RMMI configuration failed");
> +		goto out;
> +	}
> +#endif

In particular, the part above cannot possibly work: When a distro ships a kernel
with CONFIG_SCSI_UFS_DWC_40BIT_RMMI set, it won't ever call the 
ufshcd_dwc_setup_20bit_rmmi() function, regardless of what the hardware is.

	Arnd
