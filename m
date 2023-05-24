Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E5EC77B73
	for <linux-scsi@archiver.kernel.org>; Wed, 24 May 2023 12:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjEXMst (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 May 2023 08:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjEXMss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 May 2023 08:48:48 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1161B1
        for <linux-scsi@vger.kernel.org>; Wed, 24 May 2023 05:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684932512; x=1716468512;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QGnqzU4LHisiwFD3YH6TvyoRjgVmWBdntYK+/3kCIjY=;
  b=dz2TNpBCRlGZ94UfxWsdhZ2E8/RifiNmLa2bHIJYl1tV3McI5qbO1ijb
   HFKW/yA4TvZ8XcZN0LJZqlivh7RXIhun+FwOAHE6aDqdeU+ZJf/8XbGUd
   MWUCrAPlMZ+s0bX8GXJfmfLFeiRWciNtMBIQ7qFdoRaYoNgZgW/jo78Vv
   mgs3g0IziavOa/1jRmEOs+NmQoPlIp53BMPiuql8Udrb+Nz9r4rE27f4S
   pYe4YAHTZg1tjQ1YPTou4RVcljY3B1FHbVU8EQCBBnV/OWCE1SGjIFNst
   WHdrPmZ4dHvv2DxjeRQ2SnJaNeuqRaooGNmltjfkowinwBaL1odESSWl3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="417010762"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="417010762"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 05:48:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="794176446"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="794176446"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.251.223.197])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 05:48:29 -0700
Message-ID: <f282ff01-96b6-195e-5c3f-8aa9138c3f68@intel.com>
Date:   Wed, 24 May 2023 15:48:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.0
Subject: Re: [PATCH v2 4/4] scsi: ufs: Simplify driver shutdown
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20230517223157.1068210-1-bvanassche@acm.org>
 <20230517223157.1068210-5-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20230517223157.1068210-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/05/23 01:31, Bart Van Assche wrote:
> All UFS host drivers call ufshcd_shutdown(). Hence, instead of calling
> ufshcd_shutdown() from the host driver .shutdown() callback, inline that
> function into ufshcd_wl_shutdown().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>


> ---
>  drivers/ufs/core/ufshcd.c             | 23 +++++------------------
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
>  13 files changed, 5 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0f426d46d91e..7ee150d67d49 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9933,9 +9933,7 @@ EXPORT_SYMBOL(ufshcd_runtime_resume);
>  static void ufshcd_wl_shutdown(struct device *dev)
>  {
>  	struct scsi_device *sdev = to_scsi_device(dev);
> -	struct ufs_hba *hba;
> -
> -	hba = shost_priv(sdev->host);
> +	struct ufs_hba *hba = shost_priv(sdev->host);
>  
>  	down(&hba->host_sem);
>  	hba->shutting_down = true;
> @@ -9950,27 +9948,16 @@ static void ufshcd_wl_shutdown(struct device *dev)
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
> +	/*
> +	 * Next, turn off the UFS controller and the UFS regulators. Disable
> +	 * clocks.
> +	 */
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
> index a054810e321d..33b301649757 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1647,7 +1647,6 @@ static const struct dev_pm_ops ufs_mtk_pm_ops = {
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
> index f7553293ba98..db2e669985d5 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1277,7 +1277,6 @@ extern int ufshcd_system_freeze(struct device *dev);
>  extern int ufshcd_system_thaw(struct device *dev);
>  extern int ufshcd_system_restore(struct device *dev);
>  #endif
> -extern int ufshcd_shutdown(struct ufs_hba *hba);
>  
>  extern int ufshcd_dme_configure_adapt(struct ufs_hba *hba,
>  				      int agreed_gear,
> 

