From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v6 2/2] add support for DWC UFS Host Controller
Date: Thu, 11 Feb 2016 10:25:59 +0000
Message-ID: <56BC61B7.2070507@synopsys.com>
References: <cover.1455120183.git.jpinto@synopsys.com>
 <0787e532da876f7f38b4f439ec2e16bfcbaa9cb3.1455120183.git.jpinto@synopsys.com>
 <6667560.LIsUD7xT9u@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6667560.LIsUD7xT9u@wuerfel>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 2/10/2016 8:50 PM, Arnd Bergmann wrote:
> On Wednesday 10 February 2016 16:06:13 Joao Pinto wrote:
>> This patch has the goal to add support for DesignWare UFS Controller
>> specific operations and to add specific platform and pci drivers.
>>
>> Signed-off-by: Joao Pinto <jpinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
>>  Documentation/devicetree/bindings/ufs/ufs-dwc.txt |  17 +
>>  MAINTAINERS                                       |   6 +
>>  drivers/scsi/ufs/Kconfig                          |  41 ++
>>  drivers/scsi/ufs/Makefile                         |   3 +
>>  drivers/scsi/ufs/ufs-dwc-pci.c                    | 180 ++++++
>>  drivers/scsi/ufs/ufs-dwc.c                        | 102 +++
>>  drivers/scsi/ufs/ufshcd-dwc.c                     | 736 ++++++++++++++++++++++
>>  drivers/scsi/ufs/ufshcd-dwc.h                     |  18 +
>>  drivers/scsi/ufs/ufshcd.c                         |  50 +-
>>  drivers/scsi/ufs/ufshcd.h                         |  13 +
>>  drivers/scsi/ufs/ufshci-dwc.h                     |  42 ++
>>  drivers/scsi/ufs/ufshci.h                         |   1 +
>>  drivers/scsi/ufs/unipro.h                         |  39 ++
> 
> Can you split this into separate patches for changes to the common code,
> the addition of the PCI driver and the addition of the platform driver?

I can split it in these parts:
- Fix typo
- Add UFS 2.0 support to core driver
- Changes to core driver + dwc platform driver + dwc pci driver

The last one cannot be split because the glue drivers depends on the changes of
common code, including the creation of ufshcd-dwc.

> 
>> diff --git a/Documentation/devicetree/bindings/ufs/ufs-dwc.txt b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
>> new file mode 100644
>> index 0000000..f38a3f5
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
>> @@ -0,0 +1,17 @@
>> +* Universal Flash Storage (UFS) DesignWare Host Controller
>> +
>> +DWC_UFSHC nodes are defined to describe on-chip UFS host controllers.
>> +Each UFS controller instance should have its own node.
>> +
>> +Required properties:
>> +- compatible        : compatible string ("snps,ufshcd-1.0", "snps,ufshcd-1.1"
>> +  or "snps,ufshcd-2.0")
>> +- reg               : <registers mapping>
>> +- interrupts        : <interrupt mapping for UFS host controller IRQ>
>> +
>> +Example:
>> +	dwc_ufshcd@0xD0000000 {
> 
> Please fix the node name and address in the example. I think you want "ufs@d0000000".

Sure.

> 
>> +config SCSI_UFS_DWC_MPHY_TC
>> +	bool "Support for the Synopsys MPHY Test Chip"
>> +	depends on SCSI_UFS_DWC_HOOKS && (SCSI_UFSHCD_PCI || SCSI_UFS_DWC_PLAT)
>> +	---help---
>> +	  This selects the support for the Synopsys MPHY Test Chip.
>> +
>> +	  Select this if you have a Synopsys MPHY Test Chip.
>> +	  If unsure, say N.
>> +
>> +config SCSI_UFS_DWC_40BIT_RMMI
>> +	bool "40-bit RMMI MPHY"
>> +	depends on SCSI_UFS_DWC_MPHY_TC
>> +	---help---
>> +	  This specifies that the Synopsys MPHY supports 40-bit RMMI operations.
>> +
>> +	  Select this if you are using a 40-bit RMMI Synopsys MPHY.
> 
> I don't think I understood you explanation why this has to be here,
> rather than using a proper PHY driver. Please try again.

This initialization is for Synopsys Test Chip which needs only some Unipro
attribute configuration, which needs to be close to the UFS core since it uses
its dme set/get functions. Qcom phy driver is differente, because you are really
managing the phy itself, here in the Synopsys Test Chip you only set some Unipro
attributes to put controller+Test Chip working together as one.

> 
>> +
>> +#ifdef CONFIG_PM
>> +/**
>> + * ufs_dw_pci_suspend - suspend power management function
>> + * @pdev: pointer to PCI device handle
>> + * @state: power state
>> + *
>> + * Returns 0 if successful
>> + * Returns non-zero otherwise
>> + */
>> +static int ufs_dw_pci_suspend(struct device *dev)
>> +{
>> +	return ufshcd_system_suspend(dev_get_drvdata(dev));
>> +}
> 
> Please remove the #ifdef here.


> 
>> +
>> +static const struct dev_pm_ops ufs_dw_pci_pm_ops = {
>> +	.suspend	= ufs_dw_pci_suspend,
>> +	.resume		= ufs_dw_pci_resume,
>> +	.runtime_suspend = ufs_dw_pci_runtime_suspend,
>> +	.runtime_resume  = ufs_dw_pci_runtime_resume,
>> +	.runtime_idle    = ufs_dw_pci_runtime_idle,
>> +};
> 
> Instead, use the macros from include/linux/pm.h


> 
>> +#ifdef CONFIG_SCSI_UFS_DWC_40BIT_RMMI
>> +/**
>> + * ufshcd_dwc_setup_40bit_rmmi()
>> + * This function configures Synopsys MPHY specific atributes (40-bit RMMI)
>> + * @hba: Pointer to drivers structure
>> + *
>> + * Returns 0 on success or non-zero value on failure
>> + */
>> +static int ufshcd_dwc_setup_40bit_rmmi(struct ufs_hba *hba)
>> +{
>> +	int ret = 0;
> 
> This looks like it should go into the external driver

This is common init code for platform glue driver and pci glue driver, so it
should remain in a common spot and in my option ufshcd-dwc is the right spot.

> 
>> +
>> +#ifdef CONFIG_SCSI_UFS_DWC_40BIT_RMMI
>> +	dev_info(hba->dev, "Configuring MPHY 40-bit RMMI");
>> +	ret = ufshcd_dwc_setup_40bit_rmmi(hba);
>> +	if (ret) {
>> +		dev_err(hba->dev, "40-bit RMMI configuration failed");
>> +		goto out;
>> +	}
>> +#else
>> +	dev_info(hba->dev, "Configuring MPHY 20-bit RMMI");
>> +	ret = ufshcd_dwc_setup_20bit_rmmi(hba);
>> +	if (ret) {
>> +		dev_err(hba->dev, "20-bit RMMI configuration failed");
>> +		goto out;
>> +	}
>> +#endif
> 
> In particular, the part above cannot possibly work: When a distro ships a kernel
> with CONFIG_SCSI_UFS_DWC_40BIT_RMMI set, it won't ever call the 
> ufshcd_dwc_setup_20bit_rmmi() function, regardless of what the hardware is.

You are right... never thought about it that way... I am going to check with the
IP guys the best way to go.

> 
> 	Arnd
> 

Joao
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
