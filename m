From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v2 04/10] phy: qcom-ufs-qmp-xx: Discard remove callback
 for drivers.
Date: Thu, 27 Oct 2016 01:50:46 +0530
Message-ID: <35ce06b5-8d80-57b4-1c27-4be57be1ecbc@ti.com>
References: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
 <1476800897-19898-5-git-send-email-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35189 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933022AbcJZUUx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2016 16:20:53 -0400
In-Reply-To: <1476800897-19898-5-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org



On Tuesday 18 October 2016 07:58 PM, Vivek Gautam wrote:
> remove() callback does a phy_exit() only and nothing else now.

remove callback calls a phy_power_off() ;-)

-Kishon

> The phy_exit() over the generic phy is called from the phy
> consumer, and phy provider driver should not explicitly need to
> call any phy_exit().
> So discard the remove callback for qcom-ufs phy platform drivers.
> 
> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
> ---
> 
> No change since v1.
> 
>  drivers/phy/phy-qcom-ufs-qmp-14nm.c | 16 ----------------
>  drivers/phy/phy-qcom-ufs-qmp-20nm.c | 16 ----------------
>  drivers/phy/phy-qcom-ufs.c          |  9 ---------
>  3 files changed, 41 deletions(-)
> 
> diff --git a/drivers/phy/phy-qcom-ufs-qmp-14nm.c b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
> index 6ee5149..a305016 100644
> --- a/drivers/phy/phy-qcom-ufs-qmp-14nm.c
> +++ b/drivers/phy/phy-qcom-ufs-qmp-14nm.c
> @@ -163,21 +163,6 @@ out:
>  	return err;
>  }
>  
> -static int ufs_qcom_phy_qmp_14nm_remove(struct platform_device *pdev)
> -{
> -	struct device *dev = &pdev->dev;
> -	struct phy *generic_phy = to_phy(dev);
> -	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
> -	int err = 0;
> -
> -	err = ufs_qcom_phy_remove(generic_phy, ufs_qcom_phy);
> -	if (err)
> -		dev_err(dev, "%s: ufs_qcom_phy_remove failed = %d\n",
> -			__func__, err);
> -
> -	return err;
> -}
> -
>  static const struct of_device_id ufs_qcom_phy_qmp_14nm_of_match[] = {
>  	{.compatible = "qcom,ufs-phy-qmp-14nm"},
>  	{},
> @@ -186,7 +171,6 @@ MODULE_DEVICE_TABLE(of, ufs_qcom_phy_qmp_14nm_of_match);
>  
>  static struct platform_driver ufs_qcom_phy_qmp_14nm_driver = {
>  	.probe = ufs_qcom_phy_qmp_14nm_probe,
> -	.remove = ufs_qcom_phy_qmp_14nm_remove,
>  	.driver = {
>  		.of_match_table = ufs_qcom_phy_qmp_14nm_of_match,
>  		.name = "ufs_qcom_phy_qmp_14nm",
> diff --git a/drivers/phy/phy-qcom-ufs-qmp-20nm.c b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
> index 770087a..2db1fbb 100644
> --- a/drivers/phy/phy-qcom-ufs-qmp-20nm.c
> +++ b/drivers/phy/phy-qcom-ufs-qmp-20nm.c
> @@ -219,21 +219,6 @@ out:
>  	return err;
>  }
>  
> -static int ufs_qcom_phy_qmp_20nm_remove(struct platform_device *pdev)
> -{
> -	struct device *dev = &pdev->dev;
> -	struct phy *generic_phy = to_phy(dev);
> -	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
> -	int err = 0;
> -
> -	err = ufs_qcom_phy_remove(generic_phy, ufs_qcom_phy);
> -	if (err)
> -		dev_err(dev, "%s: ufs_qcom_phy_remove failed = %d\n",
> -			__func__, err);
> -
> -	return err;
> -}
> -
>  static const struct of_device_id ufs_qcom_phy_qmp_20nm_of_match[] = {
>  	{.compatible = "qcom,ufs-phy-qmp-20nm"},
>  	{},
> @@ -242,7 +227,6 @@ MODULE_DEVICE_TABLE(of, ufs_qcom_phy_qmp_20nm_of_match);
>  
>  static struct platform_driver ufs_qcom_phy_qmp_20nm_driver = {
>  	.probe = ufs_qcom_phy_qmp_20nm_probe,
> -	.remove = ufs_qcom_phy_qmp_20nm_remove,
>  	.driver = {
>  		.of_match_table = ufs_qcom_phy_qmp_20nm_of_match,
>  		.name = "ufs_qcom_phy_qmp_20nm",
> diff --git a/drivers/phy/phy-qcom-ufs.c b/drivers/phy/phy-qcom-ufs.c
> index f639a7c..b8f9286 100644
> --- a/drivers/phy/phy-qcom-ufs.c
> +++ b/drivers/phy/phy-qcom-ufs.c
> @@ -645,15 +645,6 @@ int ufs_qcom_phy_calibrate_phy(struct phy *generic_phy, bool is_rate_B)
>  }
>  EXPORT_SYMBOL_GPL(ufs_qcom_phy_calibrate_phy);
>  
> -int ufs_qcom_phy_remove(struct phy *generic_phy,
> -			struct ufs_qcom_phy *ufs_qcom_phy)
> -{
> -	phy_power_off(generic_phy);
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(ufs_qcom_phy_remove);
> -
>  int ufs_qcom_phy_exit(struct phy *generic_phy)
>  {
>  	struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
> 
