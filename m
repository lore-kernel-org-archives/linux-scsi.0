From: subhashj@codeaurora.org
Subject: Re: [PATCH v7 6/8] scsi: ufs: make the UFS variant a platform
 device
Date: Thu, 22 Oct 2015 07:02:14 -0000
Message-ID: <2dce3d8d918e124eb29afa7a59607bca.squirrel@codeaurora.org>
References: <1441205138-12664-1-git-send-email-ygardi@codeaurora.org>
    <1441205138-12664-7-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1441205138-12664-7-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
Cc: robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, Christoph Hellwig <hch@lst.de>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Sahitya Tummala <stummala@codeaurora.org>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kerne>
List-Id: linux-scsi@vger.kernel.org

Comments inline below:

> This change turns the UFS variant (SCSI_UFS_QCOM) into a UFS
> a platform device.
> In order to do so a few additional changes are required:
> 1. The ufshcd-pltfrm is no longer serves as a platform device.
>    Now it only serves as a group of platform APIs such as PM APIs
>    (runtime suspend/resume, system suspend/resume etc), parsers of
>    clocks, regulators and pm_levels from DT.
> 2. What used to be the old platform "probe" is now "only"
>    a pltfrm_init() routine, that does exactly the same, but only
>    being called by the new probe function of the UFS variant.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  Documentation/devicetree/bindings/ufs/ufs-qcom.txt | 57 +++++++++++++
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  4 +-
>  drivers/scsi/ufs/ufs-qcom.c                        | 62 +++++++++++++-
>  drivers/scsi/ufs/ufshcd-pltfrm.c                   | 98
> ++++++----------------
>  drivers/scsi/ufs/ufshcd-pltfrm.h                   | 41 +++++++++
>  drivers/scsi/ufs/ufshcd.c                          | 10 +++
>  drivers/scsi/ufs/ufshcd.h                          |  1 +
>  7 files changed, 199 insertions(+), 74 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-qcom.txt
>  create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.h
>
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-qcom.txt
> b/Documentation/devicetree/bindings/ufs/ufs-qcom.txt
> new file mode 100644
> index 0000000..452e4ef
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufs-qcom.txt
> @@ -0,0 +1,57 @@
> +* Qualcomm Technologies Inc Universal Flash Storage (UFS) PHY
> +
> +UFSPHY nodes are defined to describe on-chip UFS PHY hardware macro.
> +Each UFS PHY node should have its own node.
> +
> +To bind UFS PHY with UFS host controller, the controller node should
> +contain a phandle reference to UFS PHY node.
> +
> +Required properties:
> +- compatible        : compatible list, contains "qcom,ufs-phy-qmp-20nm"
> +		      or "qcom,ufs-phy-qmp-14nm" according to the relevant phy in use.
> +- reg               : should contain PHY register address space
> (mandatory),
> +- reg-names         : indicates various resources passed to driver (via
> reg proptery) by name.
> +                      Required "reg-names" is "phy_mem".
> +- #phy-cells        : This property shall be set to 0
> +- vdda-phy-supply   : phandle to main PHY supply for analog domain
> +- vdda-pll-supply   : phandle to PHY PLL and Power-Gen block power supply
> +- clocks	    : List of phandle and clock specifier pairs
> +- clock-names       : List of clock input name strings sorted in the same
> +		      order as the clocks property. "ref_clk_src", "ref_clk",
> +		      "tx_iface_clk" & "rx_iface_clk" are mandatory but
> +		      "ref_clk_parent" is optional
> +
> +Optional properties:
> +- vdda-phy-max-microamp : specifies max. load that can be drawn from phy
> supply
> +- vdda-pll-max-microamp : specifies max. load that can be drawn from pll
> supply
> +- vddp-ref-clk-supply   : phandle to UFS device ref_clk pad power supply
> +- vddp-ref-clk-max-microamp : specifies max. load that can be drawn from
> this supply
> +- vddp-ref-clk-always-on : specifies if this supply needs to be kept
> always on
> +
> +Example:
> +
> +	ufsphy1: ufsphy@0xfc597000 {
> +		compatible = "qcom,ufs-phy-qmp-20nm";
> +		reg = <0xfc597000 0x800>;
> +		reg-names = "phy_mem";
> +		#phy-cells = <0>;
> +		vdda-phy-supply = <&pma8084_l4>;
> +		vdda-pll-supply = <&pma8084_l12>;
> +		vdda-phy-max-microamp = <50000>;
> +		vdda-pll-max-microamp = <1000>;
> +		clock-names = "ref_clk_src",
> +			"ref_clk_parent",
> +			"ref_clk",
> +			"tx_iface_clk",
> +			"rx_iface_clk";
> +		clocks = <&clock_rpm clk_ln_bb_clk>,
> +			<&clock_gcc clk_pcie_1_phy_ldo >,
> +			<&clock_gcc clk_ufs_phy_ldo>,
> +			<&clock_gcc clk_gcc_ufs_tx_cfg_clk>,
> +			<&clock_gcc clk_gcc_ufs_rx_cfg_clk>;
> +	};
> +
> +	ufshc@0xfc598000 {
> +		...
> +		phys = <&ufsphy1>;
> +	};
> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> index 5357919..c0f10d3 100644
> --- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> @@ -4,7 +4,9 @@ UFSHC nodes are defined to describe on-chip UFS host
> controllers.
>  Each UFS controller instance should have its own node.
>
>  Required properties:
> -- compatible        : compatible list, contains "jedec,ufs-1.1"
> +- compatible        : compatible list, contains "jedec,ufs-1.1" or
> +		      "qcom,msm8994-ufshc" or "qcom,msm8996-ufshc"

Are we really using these "qcom,msm8994-ufshc" or "qcom,msm8996-ufshc"
compatible string anywhere?

> +		      followed by "qcom,ufshc"
>  - interrupts        : <interrupt mapping for UFS host controller IRQ>
>  - reg               : <registers mapping>
>
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 329ac84..b275a9a 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -19,6 +19,7 @@
>
>  #include <linux/phy/phy-qcom-ufs.h>
>  #include "ufshcd.h"
> +#include "ufshcd-pltfrm.h"
>  #include "unipro.h"
>  #include "ufs-qcom.h"
>  #include "ufshci.h"
> @@ -1036,7 +1037,7 @@ void ufs_qcom_clk_scale_notify(struct ufs_hba *hba)
>   * The variant operations configure the necessary controller and PHY
>   * handshake during initialization.
>   */
> -static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
> +static struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
>  	.name                   = "qcom",
>  	.init                   = ufs_qcom_init,
>  	.exit                   = ufs_qcom_exit,
> @@ -1050,4 +1051,63 @@ static const struct ufs_hba_variant_ops
> ufs_hba_qcom_vops = {
>  	.resume			= ufs_qcom_resume,
>  };
>
> +/**
> + * ufs_qcom_probe - probe routine of the driver
> + * @pdev: pointer to Platform device handle
> + *
> + * Return zero for success and non-zero for failure
> + */
> +static int ufs_qcom_probe(struct platform_device *pdev)
> +{
> +	int err;
> +	struct device *dev = &pdev->dev;
> +
> +	/* Perform generic probe */
> +	err = ufshcd_pltfrm_init(pdev, &ufs_hba_qcom_vops);
> +	if (err)
> +		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
> +
> +	return err;
> +}
> +
> +/**
> + * ufs_qcom_remove - set driver_data of the device to NULL
> + * @pdev: pointer to platform device handle
> + *
> + * Always return 0
> + */
> +static int ufs_qcom_remove(struct platform_device *pdev)
> +{
> +	struct ufs_hba *hba =  platform_get_drvdata(pdev);
> +
> +	pm_runtime_get_sync(&(pdev)->dev);
> +	ufshcd_remove(hba);
> +	return 0;
> +}
> +
> +static const struct of_device_id ufs_qcom_of_match[] = {
> +	{ .compatible = "qcom,ufshc"},
> +	{},
> +};
> +
> +static const struct dev_pm_ops ufs_qcom_pm_ops = {
> +	.suspend	= ufshcd_pltfrm_suspend,
> +	.resume		= ufshcd_pltfrm_resume,
> +	.runtime_suspend = ufshcd_pltfrm_runtime_suspend,
> +	.runtime_resume  = ufshcd_pltfrm_runtime_resume,
> +	.runtime_idle    = ufshcd_pltfrm_runtime_idle,
> +};
> +
> +static struct platform_driver ufs_qcom_pltform = {
> +	.probe	= ufs_qcom_probe,
> +	.remove	= ufs_qcom_remove,
> +	.shutdown = ufshcd_pltfrm_shutdown,
> +	.driver	= {
> +		.name	= "ufshcd-qcom",
> +		.pm	= &ufs_qcom_pm_ops,
> +		.of_match_table = of_match_ptr(ufs_qcom_of_match),
> +	},
> +};
> +module_platform_driver(ufs_qcom_pltform);
> +
>  MODULE_LICENSE("GPL v2");
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c
> b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index 7db9564..9714f2a 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -38,20 +38,7 @@
>  #include <linux/of.h>
>
>  #include "ufshcd.h"
> -
> -static const struct of_device_id ufs_of_match[];
> -static struct ufs_hba_variant_ops *get_variant_ops(struct device *dev)
> -{
> -	if (dev->of_node) {
> -		const struct of_device_id *match;
> -
> -		match = of_match_node(ufs_of_match, dev->of_node);
> -		if (match)
> -			return (struct ufs_hba_variant_ops *)match->data;
> -	}
> -
> -	return NULL;
> -}
> +#include "ufshcd-pltfrm.h"
>
>  static int ufshcd_parse_clock_info(struct ufs_hba *hba)
>  {
> @@ -245,10 +232,11 @@ out:
>   * Returns 0 if successful
>   * Returns non-zero otherwise
>   */
> -static int ufshcd_pltfrm_suspend(struct device *dev)
> +int ufshcd_pltfrm_suspend(struct device *dev)
>  {
>  	return ufshcd_system_suspend(dev_get_drvdata(dev));
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_pltfrm_suspend);
>
>  /**
>   * ufshcd_pltfrm_resume - resume power management function
> @@ -257,43 +245,47 @@ static int ufshcd_pltfrm_suspend(struct device *dev)
>   * Returns 0 if successful
>   * Returns non-zero otherwise
>   */
> -static int ufshcd_pltfrm_resume(struct device *dev)
> +int ufshcd_pltfrm_resume(struct device *dev)
>  {
>  	return ufshcd_system_resume(dev_get_drvdata(dev));
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_pltfrm_resume);
>
> -static int ufshcd_pltfrm_runtime_suspend(struct device *dev)
> +int ufshcd_pltfrm_runtime_suspend(struct device *dev)
>  {
>  	return ufshcd_runtime_suspend(dev_get_drvdata(dev));
>  }
> -static int ufshcd_pltfrm_runtime_resume(struct device *dev)
> +EXPORT_SYMBOL_GPL(ufshcd_pltfrm_runtime_suspend);
> +
> +int ufshcd_pltfrm_runtime_resume(struct device *dev)
>  {
>  	return ufshcd_runtime_resume(dev_get_drvdata(dev));
>  }
> -static int ufshcd_pltfrm_runtime_idle(struct device *dev)
> +EXPORT_SYMBOL_GPL(ufshcd_pltfrm_runtime_resume);
> +
> +int ufshcd_pltfrm_runtime_idle(struct device *dev)
>  {
>  	return ufshcd_runtime_idle(dev_get_drvdata(dev));
>  }
> -#else /* !CONFIG_PM */
> -#define ufshcd_pltfrm_suspend	NULL
> -#define ufshcd_pltfrm_resume	NULL
> -#define ufshcd_pltfrm_runtime_suspend	NULL
> -#define ufshcd_pltfrm_runtime_resume	NULL
> -#define ufshcd_pltfrm_runtime_idle	NULL
> +EXPORT_SYMBOL_GPL(ufshcd_pltfrm_runtime_idle);
> +
>  #endif /* CONFIG_PM */
>
> -static void ufshcd_pltfrm_shutdown(struct platform_device *pdev)
> +void ufshcd_pltfrm_shutdown(struct platform_device *pdev)
>  {
>  	ufshcd_shutdown((struct ufs_hba *)platform_get_drvdata(pdev));
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_pltfrm_shutdown);
>
>  /**
> - * ufshcd_pltfrm_probe - probe routine of the driver
> + * ufshcd_pltfrm_init - probe routine of the driver
>   * @pdev: pointer to Platform device handle
> + * @vops: pointer to variant ops
>   *
>   * Returns 0 on success, non-zero value on failure
>   */
> -static int ufshcd_pltfrm_probe(struct platform_device *pdev)
> +int ufshcd_pltfrm_init(struct platform_device *pdev,
> +		       struct ufs_hba_variant_ops *vops)
>  {
>  	struct ufs_hba *hba;
>  	void __iomem *mmio_base;
> @@ -321,19 +313,19 @@ static int ufshcd_pltfrm_probe(struct
> platform_device *pdev)
>  		goto out;
>  	}
>
> -	hba->vops = get_variant_ops(&pdev->dev);
> +	hba->vops = vops;
>
>  	err = ufshcd_parse_clock_info(hba);
>  	if (err) {
>  		dev_err(&pdev->dev, "%s: clock parse failed %d\n",
>  				__func__, err);
> -		goto out;
> +		goto dealloc_host;
>  	}
>  	err = ufshcd_parse_regulator_info(hba);
>  	if (err) {
>  		dev_err(&pdev->dev, "%s: regulator init failed %d\n",
>  				__func__, err);
> -		goto out;
> +		goto dealloc_host;
>  	}
>
>  	pm_runtime_set_active(&pdev->dev);
> @@ -352,50 +344,12 @@ static int ufshcd_pltfrm_probe(struct
> platform_device *pdev)
>  out_disable_rpm:
>  	pm_runtime_disable(&pdev->dev);
>  	pm_runtime_set_suspended(&pdev->dev);
> +dealloc_host:
> +	ufshcd_dealloc_host(hba);
>  out:
>  	return err;
>  }
> -
> -/**
> - * ufshcd_pltfrm_remove - remove platform driver routine
> - * @pdev: pointer to platform device handle
> - *
> - * Returns 0 on success, non-zero value on failure
> - */
> -static int ufshcd_pltfrm_remove(struct platform_device *pdev)
> -{
> -	struct ufs_hba *hba =  platform_get_drvdata(pdev);
> -
> -	pm_runtime_get_sync(&(pdev)->dev);
> -	ufshcd_remove(hba);
> -	return 0;
> -}
> -
> -static const struct of_device_id ufs_of_match[] = {
> -	{ .compatible = "jedec,ufs-1.1"},
> -	{},
> -};
> -
> -static const struct dev_pm_ops ufshcd_dev_pm_ops = {
> -	.suspend	= ufshcd_pltfrm_suspend,
> -	.resume		= ufshcd_pltfrm_resume,
> -	.runtime_suspend = ufshcd_pltfrm_runtime_suspend,
> -	.runtime_resume  = ufshcd_pltfrm_runtime_resume,
> -	.runtime_idle    = ufshcd_pltfrm_runtime_idle,
> -};
> -
> -static struct platform_driver ufshcd_pltfrm_driver = {
> -	.probe	= ufshcd_pltfrm_probe,
> -	.remove	= ufshcd_pltfrm_remove,
> -	.shutdown = ufshcd_pltfrm_shutdown,
> -	.driver	= {
> -		.name	= "ufshcd",
> -		.pm	= &ufshcd_dev_pm_ops,
> -		.of_match_table = ufs_of_match,
> -	},
> -};
> -
> -module_platform_driver(ufshcd_pltfrm_driver);
> +EXPORT_SYMBOL_GPL(ufshcd_pltfrm_init);
>
>  MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
>  MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.h
> b/drivers/scsi/ufs/ufshcd-pltfrm.h
> new file mode 100644
> index 0000000..df64c41
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.h
> @@ -0,0 +1,41 @@
> +/* Copyright (c) 2015, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef UFSHCD_PLTFRM_H_
> +#define UFSHCD_PLTFRM_H_
> +
> +#include "ufshcd.h"
> +
> +int ufshcd_pltfrm_init(struct platform_device *pdev,
> +		       struct ufs_hba_variant_ops *vops);
> +void ufshcd_pltfrm_shutdown(struct platform_device *pdev);
> +
> +#ifdef CONFIG_PM
> +
> +int ufshcd_pltfrm_suspend(struct device *dev);
> +int ufshcd_pltfrm_resume(struct device *dev);
> +int ufshcd_pltfrm_runtime_suspend(struct device *dev);
> +int ufshcd_pltfrm_runtime_resume(struct device *dev);
> +int ufshcd_pltfrm_runtime_idle(struct device *dev);
> +
> +#else /* !CONFIG_PM */
> +
> +#define ufshcd_pltfrm_suspend	NULL
> +#define ufshcd_pltfrm_resume	NULL
> +#define ufshcd_pltfrm_runtime_suspend	NULL
> +#define ufshcd_pltfrm_runtime_resume	NULL
> +#define ufshcd_pltfrm_runtime_idle	NULL
> +
> +#endif /* CONFIG_PM */
> +
> +#endif /* UFSHCD_PLTFRM_H_ */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9e79c33..2ef9834 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5348,6 +5348,16 @@ void ufshcd_remove(struct ufs_hba *hba)
>  EXPORT_SYMBOL_GPL(ufshcd_remove);
>
>  /**
> + * ufshcd_dealloc_host - deallocate Host Bus Adapter (HBA)
> + * @hba: pointer to Host Bus Adapter (HBA)
> + */
> +void ufshcd_dealloc_host(struct ufs_hba *hba)
> +{
> +	scsi_host_put(hba->host);
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_dealloc_host);
> +
> +/**
>   * ufshcd_set_dma_mask - Set dma mask based on the controller
>   *			 addressing capability
>   * @hba: per adapter instance
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index ce75626..f2aa47e 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -576,6 +576,7 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba,
> u32 mask, u32 val, u32 reg)
>  }
>
>  int ufshcd_alloc_host(struct device *, struct ufs_hba **);
> +void ufshcd_dealloc_host(struct ufs_hba *);
>  int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
>  void ufshcd_remove(struct ufs_hba *);
>
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
>
