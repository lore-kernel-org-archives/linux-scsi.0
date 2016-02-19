From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v9 3/3] add support for DWC UFS Host Controller
Date: Fri, 19 Feb 2016 16:03:04 +0100
Message-ID: <2698029.eKNCoG3LWy@wuerfel>
References: <cover.1455549221.git.jpinto@synopsys.com> <5c806ca29340923831e05a729bbb6557d7ce83cb.1455549222.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5c806ca29340923831e05a729bbb6557d7ce83cb.1455549222.git.jpinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 18 February 2016 17:20:27 Joao Pinto wrote:
> 
>  Documentation/devicetree/bindings/ufs/ufs-dwc.txt |  19 +
>  MAINTAINERS                                       |   6 +
>  drivers/scsi/ufs/Kconfig                          |  51 +++
>  drivers/scsi/ufs/Makefile                         |   3 +
>  drivers/scsi/ufs/ufs-dwc-pci.c                    | 172 +++++++++
>  drivers/scsi/ufs/ufs-dwc.c                        |  96 +++++
>  drivers/scsi/ufs/ufshcd-dwc.c                     | 431 ++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd-dwc.h                     |  18 +
>  drivers/scsi/ufs/ufshci-dwc.h                     |  42 +++
>  drivers/scsi/ufs/unipro.h                         |  39 ++

I still think this can be split up further. From your previous
explanation, I understand that there is a specific test chip
that uses the "snps,ufshcd-dwc" implementation along with some
other glue logic.

Please split this out so you have anything related to the test
chips separate from the patch that implements core logic.
 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-dwc.txt b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
> new file mode 100644
> index 0000000..59e9822
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-dwc.txt
> @@ -0,0 +1,19 @@
> +* Universal Flash Storage (UFS) DesignWare Host Controller
> +
> +DWC_UFSHC nodes are defined to describe on-chip UFS host controllers.
> +Each UFS controller instance should have its own node.
> +
> +Required properties:
> +- compatible        : compatible list must contain "snps,ufshcd-dwc" and should
> +		      also contain the JEDEC version of the controller:
> +			"jedec,ufs-1.1"
> +			"jedec,ufs-2.0"
> +- reg               : <registers mapping>
> +- interrupts        : <interrupt mapping for UFS host controller IRQ>


Based on your last reply to me (sorry for coming back to this so
late), I think having just "snps,ufshcd-dwc" as the compatible
string is not appropriate: This assumes that all "snps,ufshcd-dwc"
instances are 100% compatible, but your code makes it very clear
that this is not the case.

Please for the last time (!) add a proper version number of the
specific IP block to the compatible strings so you can identify
what hardware you are talking to.

You earlier confused the version number of the UFS standard with
the version number of the controller, and that has been clarified
now, but you really still need to use a version for the hardware
as well.

> +config SCSI_UFS_DWC_TC
> +	bool "Support for the Synopsys Test Chip"
> +	depends on SCSI_UFS_DWC_HOOKS && (SCSI_UFSHCD_PCI || SCSI_UFS_DWC_PLAT)
> +	---help---
> +	  Synopsys Test Chip is a Phy for prototyping purposes.
> +	  This selects the support for the Synopsys Test Chip.
> +
> +	  Select this if you have a Synopsys Test Chip.
> +	  If unsure, say N.
> +
> +config SCSI_UFS_DWC_20BIT_RMMI
> +	bool "20-bit RMMI support"
> +	depends on SCSI_UFS_DWC_TC
> +	---help---
> +	  This specifies that the Synopsys Test Chip supports 20-bit RMMI.
> +
> +	  Select this if you are using a 20-bit RMMI Synopsys Test Chip.
> +	  If unsure, say N.
> +
> +config SCSI_UFS_DWC_40BIT_RMMI
> +	bool "40-bit RMMI support"
> +	depends on SCSI_UFS_DWC_TC
> +	---help---
> +	  Synopsys Test Chip is a Phy for prototyping purposes.
> +
> +	  Select this if you are using a 40-bit RMMI Synopsys Test Chip.
> +	  If unsure, say N.

I think it would be better to remove the SCSI_UFS_DWC_20BIT_RMMI
and SCSI_UFS_DWC_40BIT_RMMI configuration options now, and always
support both. There is not really much need for the options
as this is just a test chip, and nobody is going to care much
about saving a few bytes of object code.

> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index 8303bcc..bab8c05 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -1,4 +1,7 @@
>  # UFSHCD makefile
> +obj-$(CONFIG_SCSI_UFS_DWC_HOOKS) += ufshcd-dwc.o
> +obj-$(CONFIG_SCSI_UFS_DWC_PLAT) += ufs-dwc.o
> +obj-$(CONFIG_SCSI_UFS_DWC_PCI) += ufs-dwc-pci.o
>  obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
>  obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
>  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o

However, please split out the SCSI_UFS_DWC_TC specific bits into
a separate file, and put the module_platform_driver() bits into
that file, to get the right abstraction where the most specific
driver calls into the next driver, like

dwc-test-chip -> dwc-platform -> dwc -> ufs

It's possible you can leave out the dwc-platform level here, as there
are no other users for now, we can add others later as needed.

> +/**
> + * ufshcd_dwc_setup_tc()
> + * This function configures Local (host) Synopsys TC specific attributes
> + *
> + * @hba: Pointer to drivers structure
> + *
> + * Returns 0 on success non-zero value on failure
> + */
> +static int ufshcd_dwc_setup_tc(struct ufs_hba *hba)
> +{
> +	int ret = 0;
> +
> +#ifdef CONFIG_SCSI_UFS_DWC_40BIT_RMMI
> +	dev_info(hba->dev, "Configuring Test Chip 40-bit RMMI\n");
> +	ret = ufshcd_dwc_setup_40bit_rmmi(hba);
> +	if (ret) {
> +		dev_err(hba->dev, "Configuration failed\n");
> +		goto out;
> +	}
> +#endif
> +
> +#ifdef CONFIG_SCSI_UFS_DWC_20BIT_RMMI
> +	dev_info(hba->dev, "Configuring Test Chip 20-bit RMMI\n");
> +	ret = ufshcd_dwc_setup_20bit_rmmi(hba);
> +	if (ret) {
> +		dev_err(hba->dev, "Configuration failed\n");
> +		goto out;
> +	}
> +#endif

You have changed the #if/#else into two #if sections, but this
still seems broken when both are enabled, it just cannot work
unless you have some runtime detection in place.

Depending on whether this is actually the same hardware with
different settings, or different variants of the test chip,
please use either a boolean DT property to determine which
one you need, or use a separate "compatible" string in DT
for each version of the test chip.

> +/**
> + * ufshcd_dwc_link_startup_notify()
> + * UFS Host DWC specific link startup sequence
> + * @hba: private structure poitner
> + * @status: Callback notify status
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
> +					enum ufs_notify_change_status status)
> +{
> +	int err = 0;
> +
> +	if (status == PRE_CHANGE) {
> +		ufshcd_dwc_program_clk_div(hba, DWC_UFS_REG_HCLKDIV_DIV_125);
> +#ifdef CONFIG_SCSI_UFS_DWC_TC
> +		err = ufshcd_dwc_setup_tc(hba);
> +		if (err) {
> +			dev_err(hba->dev, "Configuration failed (%d)\n",
> +									err);
> +			goto out;
> +		}
> +#endif
> +	} else { /* POST_CHANGE */

Similar, this #ifdef should almost certainly be rewritten so that
only a DT that identifies as the test chip will call that.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
