Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4ED9C77B60
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Apr 2023 06:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbjDZGIZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Apr 2023 02:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239547AbjDZGIT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2023 02:08:19 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CD92681
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 23:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682489262; x=1714025262;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0WrebCdiok+P4L0gnz0DY8O4pNfPNu+Qxrc9eb4YEDA=;
  b=gu434KQSKVOV38n+VnRUqPcB1HejFehlAlC9Qu7kFGLDeagMUOQt6LfH
   whd76J+Qr8Yk38pFWpWyBjbBkgmilCK2baYRhBHvKBp9Zcp5s/41WXIUF
   QmiqAgxQFCNVQOiroigS46var10wlYjb0JOl8+uuhtLKTq0lpjonG65G5
   XUdGg5oaI3MTOxO7zJtYHA+T3qSCLU9vjH3GdeXDV+DrwdRO5Fj26Oh78
   DfaFWVpbMrEDXXQYNIR+MZGMePeB6pJcJWDdYhaPE4XlxHi1JBYD6dooQ
   hgMqOweCC5ebduSD9wx66gTNlaptqf9fQLlcuXjak3oB7iZ9tQgVgBjB1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="412316908"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="412316908"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 23:07:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10691"; a="671212031"
X-IronPort-AV: E=Sophos;i="5.99,227,1677571200"; 
   d="scan'208";a="671212031"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.249.37.127])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2023 23:07:20 -0700
Message-ID: <91efe449-0000-8e1a-afb8-2628d46dd245@intel.com>
Date:   Wed, 26 Apr 2023 09:07:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH 4/4] scsi: ufs: Simplify driver shutdown
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Zhe Wang <zhe.wang1@unisoc.com>,
        Daniil Lunev <dlunev@chromium.org>, Liang He <windhl@126.com>,
        Can Guo <quic_cang@quicinc.com>
References: <20230425232954.1229916-1-bvanassche@acm.org>
 <20230425232954.1229916-5-bvanassche@acm.org>
Content-Language: en-US
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230425232954.1229916-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/04/23 02:29, Bart Van Assche wrote:
> All UFS host drivers call ufshcd_shutdown(). Hence, instead of calling
> ufshcd_shutdown() from the host driver .shutdown() callback, inline that
> function into ufshcd_wl_shutdown().

Pedantically, this seems like a bit of a layering violation: the child
is doing the parent's shutdown.  It assumes host shutdown is not needed
if ufs_device_wlun does not exist or did not successfully probe.

At least it could use a comment in the code.

> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c             | 15 ---------------
>  drivers/ufs/host/cdns-pltfrm.c        |  1 -
>  drivers/ufs/host/tc-dwc-g210-pci.c    | 10 ----------
>  drivers/ufs/host/tc-dwc-g210-pltfrm.c |  1 -
>  drivers/ufs/host/ufs-exynos.c         |  1 -
>  drivers/ufs/host/ufs-hisi.c           |  1 -
>  drivers/ufs/host/ufs-mediatek.c       |  1 -
>  drivers/ufs/host/ufs-qcom.c           |  1 -
>  drivers/ufs/host/ufs-sprd.c           |  1 -
>  drivers/ufs/host/ufshcd-pci.c         | 10 ----------
>  drivers/ufs/host/ufshcd-pltfrm.c      |  6 ------
>  drivers/ufs/host/ufshcd-pltfrm.h      |  1 -
>  include/ufs/ufshcd.h                  |  1 -
>  13 files changed, 50 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 215a7f713b46..7b1e7d7091ff 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9965,27 +9965,12 @@ static void ufshcd_wl_shutdown(struct device *dev)
>  		scsi_device_quiesce(sdev);
>  	}
>  	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
> -}
>  
> -/**
> - * ufshcd_shutdown - shutdown routine
> - * @hba: per adapter instance
> - *
> - * This function would turn off both UFS device and UFS hba
> - * regulators. It would also disable clocks.
> - *
> - * Returns 0 always to allow force shutdown even in case of errors.
> - */
> -int ufshcd_shutdown(struct ufs_hba *hba)
> -{
>  	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
>  		ufshcd_suspend(hba);
>  
>  	hba->is_powered = false;
> -	/* allow force shutdown even in case of errors */
> -	return 0;
>  }
> -EXPORT_SYMBOL(ufshcd_shutdown);
>  
>  /**
>   * ufshcd_remove - de-allocate SCSI host and host memory space
> diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.c
> index e05c0ae64eea..26761425a76c 100644
> --- a/drivers/ufs/host/cdns-pltfrm.c
> +++ b/drivers/ufs/host/cdns-pltfrm.c
> @@ -328,7 +328,6 @@ static const struct dev_pm_ops cdns_ufs_dev_pm_ops = {
>  static struct platform_driver cdns_ufs_pltfrm_driver = {
>  	.probe	= cdns_ufs_pltfrm_probe,
>  	.remove	= cdns_ufs_pltfrm_remove,
> -	.shutdown = ufshcd_pltfrm_shutdown,
>  	.driver	= {
>  		.name   = "cdns-ufshcd",
>  		.pm     = &cdns_ufs_dev_pm_ops,
> diff --git a/drivers/ufs/host/tc-dwc-g210-pci.c b/drivers/ufs/host/tc-dwc-g210-pci.c
> index 92b8ad4b58fe..f96fe5855841 100644
> --- a/drivers/ufs/host/tc-dwc-g210-pci.c
> +++ b/drivers/ufs/host/tc-dwc-g210-pci.c
> @@ -32,15 +32,6 @@ static struct ufs_hba_variant_ops tc_dwc_g210_pci_hba_vops = {
>  	.link_startup_notify	= ufshcd_dwc_link_startup_notify,
>  };
>  
> -/**
> - * tc_dwc_g210_pci_shutdown - main function to put the controller in reset state
> - * @pdev: pointer to PCI device handle
> - */
> -static void tc_dwc_g210_pci_shutdown(struct pci_dev *pdev)
> -{
> -	ufshcd_shutdown((struct ufs_hba *)pci_get_drvdata(pdev));
> -}
> -
>  /**
>   * tc_dwc_g210_pci_remove - de-allocate PCI/SCSI host and host memory space
>   *		data structure memory
> @@ -137,7 +128,6 @@ static struct pci_driver tc_dwc_g210_pci_driver = {
>  	.id_table = tc_dwc_g210_pci_tbl,
>  	.probe = tc_dwc_g210_pci_probe,
>  	.remove = tc_dwc_g210_pci_remove,
> -	.shutdown = tc_dwc_g210_pci_shutdown,
>  	.driver = {
>  		.pm = &tc_dwc_g210_pci_pm_ops
>  	},
> diff --git a/drivers/ufs/host/tc-dwc-g210-pltfrm.c b/drivers/ufs/host/tc-dwc-g210-pltfrm.c
> index f15a84d0c176..4d5389dd9585 100644
> --- a/drivers/ufs/host/tc-dwc-g210-pltfrm.c
> +++ b/drivers/ufs/host/tc-dwc-g210-pltfrm.c
> @@ -92,7 +92,6 @@ static const struct dev_pm_ops tc_dwc_g210_pltfm_pm_ops = {
>  static struct platform_driver tc_dwc_g210_pltfm_driver = {
>  	.probe		= tc_dwc_g210_pltfm_probe,
>  	.remove		= tc_dwc_g210_pltfm_remove,
> -	.shutdown = ufshcd_pltfrm_shutdown,
>  	.driver		= {
>  		.name	= "tc-dwc-g210-pltfm",
>  		.pm	= &tc_dwc_g210_pltfm_pm_ops,
> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
> index 0bf5390739e1..f41056f57fd7 100644
> --- a/drivers/ufs/host/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -1757,7 +1757,6 @@ static const struct dev_pm_ops exynos_ufs_pm_ops = {
>  static struct platform_driver exynos_ufs_pltform = {
>  	.probe	= exynos_ufs_probe,
>  	.remove	= exynos_ufs_remove,
> -	.shutdown = ufshcd_pltfrm_shutdown,
>  	.driver	= {
>  		.name	= "exynos-ufshc",
>  		.pm	= &exynos_ufs_pm_ops,
> diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
> index 4c423eba8aa9..18b72e2e68c1 100644
> --- a/drivers/ufs/host/ufs-hisi.c
> +++ b/drivers/ufs/host/ufs-hisi.c
> @@ -593,7 +593,6 @@ static const struct dev_pm_ops ufs_hisi_pm_ops = {
>  static struct platform_driver ufs_hisi_pltform = {
>  	.probe	= ufs_hisi_probe,
>  	.remove	= ufs_hisi_remove,
> -	.shutdown = ufshcd_pltfrm_shutdown,
>  	.driver	= {
>  		.name	= "ufshcd-hisi",
>  		.pm	= &ufs_hisi_pm_ops,
> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
> index 73e217260390..e89b625d3c5a 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1650,7 +1650,6 @@ static const struct dev_pm_ops ufs_mtk_pm_ops = {
>  static struct platform_driver ufs_mtk_pltform = {
>  	.probe      = ufs_mtk_probe,
>  	.remove     = ufs_mtk_remove,
> -	.shutdown   = ufshcd_pltfrm_shutdown,
>  	.driver = {
>  		.name   = "ufshcd-mtk",
>  		.pm     = &ufs_mtk_pm_ops,
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 82d02e7f3b4f..059de74dfea3 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1723,7 +1723,6 @@ static const struct dev_pm_ops ufs_qcom_pm_ops = {
>  static struct platform_driver ufs_qcom_pltform = {
>  	.probe	= ufs_qcom_probe,
>  	.remove	= ufs_qcom_remove,
> -	.shutdown = ufshcd_pltfrm_shutdown,
>  	.driver	= {
>  		.name	= "ufshcd-qcom",
>  		.pm	= &ufs_qcom_pm_ops,
> diff --git a/drivers/ufs/host/ufs-sprd.c b/drivers/ufs/host/ufs-sprd.c
> index 051f3f40d92c..2bad75dd6d58 100644
> --- a/drivers/ufs/host/ufs-sprd.c
> +++ b/drivers/ufs/host/ufs-sprd.c
> @@ -444,7 +444,6 @@ static const struct dev_pm_ops ufs_sprd_pm_ops = {
>  static struct platform_driver ufs_sprd_pltform = {
>  	.probe = ufs_sprd_probe,
>  	.remove = ufs_sprd_remove,
> -	.shutdown = ufshcd_pltfrm_shutdown,
>  	.driver = {
>  		.name = "ufshcd-sprd",
>  		.pm = &ufs_sprd_pm_ops,
> diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
> index 9c911787f84c..38276dac8e52 100644
> --- a/drivers/ufs/host/ufshcd-pci.c
> +++ b/drivers/ufs/host/ufshcd-pci.c
> @@ -504,15 +504,6 @@ static int ufshcd_pci_restore(struct device *dev)
>  }
>  #endif
>  
> -/**
> - * ufshcd_pci_shutdown - main function to put the controller in reset state
> - * @pdev: pointer to PCI device handle
> - */
> -static void ufshcd_pci_shutdown(struct pci_dev *pdev)
> -{
> -	ufshcd_shutdown((struct ufs_hba *)pci_get_drvdata(pdev));
> -}
> -
>  /**
>   * ufshcd_pci_remove - de-allocate PCI/SCSI host and host memory space
>   *		data structure memory
> @@ -618,7 +609,6 @@ static struct pci_driver ufshcd_pci_driver = {
>  	.id_table = ufshcd_pci_tbl,
>  	.probe = ufshcd_pci_probe,
>  	.remove = ufshcd_pci_remove,
> -	.shutdown = ufshcd_pci_shutdown,
>  	.driver = {
>  		.pm = &ufshcd_pci_pm_ops
>  	},
> diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
> index 5739ff007828..0b7430033047 100644
> --- a/drivers/ufs/host/ufshcd-pltfrm.c
> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
> @@ -190,12 +190,6 @@ static int ufshcd_parse_regulator_info(struct ufs_hba *hba)
>  	return err;
>  }
>  
> -void ufshcd_pltfrm_shutdown(struct platform_device *pdev)
> -{
> -	ufshcd_shutdown((struct ufs_hba *)platform_get_drvdata(pdev));
> -}
> -EXPORT_SYMBOL_GPL(ufshcd_pltfrm_shutdown);
> -
>  static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
>  {
>  	struct device *dev = hba->dev;
> diff --git a/drivers/ufs/host/ufshcd-pltfrm.h b/drivers/ufs/host/ufshcd-pltfrm.h
> index 2e4ba2bfbcad..2df108f4ac13 100644
> --- a/drivers/ufs/host/ufshcd-pltfrm.h
> +++ b/drivers/ufs/host/ufshcd-pltfrm.h
> @@ -31,7 +31,6 @@ int ufshcd_get_pwr_dev_param(const struct ufs_dev_params *dev_param,
>  void ufshcd_init_pwr_dev_param(struct ufs_dev_params *dev_param);
>  int ufshcd_pltfrm_init(struct platform_device *pdev,
>  		       const struct ufs_hba_variant_ops *vops);
> -void ufshcd_pltfrm_shutdown(struct platform_device *pdev);
>  int ufshcd_populate_vreg(struct device *dev, const char *name,
>  			 struct ufs_vreg **out_vreg);
>  
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 721ae4cd3702..d6da1efb0212 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1278,7 +1278,6 @@ extern int ufshcd_system_freeze(struct device *dev);
>  extern int ufshcd_system_thaw(struct device *dev);
>  extern int ufshcd_system_restore(struct device *dev);
>  #endif
> -extern int ufshcd_shutdown(struct ufs_hba *hba);
>  
>  extern int ufshcd_dme_configure_adapt(struct ufs_hba *hba,
>  				      int agreed_gear,

