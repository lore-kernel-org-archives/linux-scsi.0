From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v6 15/17] scsi: ufs-qcom: set PA_Local_TX_LCC_Enable
 before link startup
Date: Mon, 7 Mar 2016 08:56:03 -0000
Message-ID: <66541a52dc89452bf63b07e743e26ed1.squirrel@us.codeaurora.org>
References: <1457265358-31635-1-git-send-email-ygardi@codeaurora.org>
    <1457265358-31635-16-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32784 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbcCGI4F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2016 03:56:05 -0500
In-Reply-To: <1457265358-31635-16-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>

> Some UFS devices (and may be host) have issues if LCC is
> enabled. So we are setting PA_Local_TX_LCC_Enable to 0
> before link startup which will make sure that both host
> and device TX LCC are disabled once link startup is
> completed.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 27 ++++++++++++++++++++-------
>  drivers/scsi/ufs/unipro.h   |  1 +
>  2 files changed, 21 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index ed57729..966bacf 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -16,8 +16,8 @@
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/phy/phy.h>
> -
>  #include <linux/phy/phy-qcom-ufs.h>
> +
>  #include "ufshcd.h"
>  #include "ufshcd-pltfrm.h"
>  #include "unipro.h"
> @@ -106,9 +106,11 @@ static void ufs_qcom_disable_lane_clks(struct
> ufs_qcom_host *host)
>  	if (!host->is_lane_clks_enabled)
>  		return;
>
> -	clk_disable_unprepare(host->tx_l1_sync_clk);
> +	if (host->hba->lanes_per_direction > 1)
> +		clk_disable_unprepare(host->tx_l1_sync_clk);
>  	clk_disable_unprepare(host->tx_l0_sync_clk);
> -	clk_disable_unprepare(host->rx_l1_sync_clk);
> +	if (host->hba->lanes_per_direction > 1)
> +		clk_disable_unprepare(host->rx_l1_sync_clk);
>  	clk_disable_unprepare(host->rx_l0_sync_clk);
>
>  	host->is_lane_clks_enabled = false;
> @@ -272,9 +274,8 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba
> *hba)
>  	ret = ufs_qcom_phy_calibrate_phy(phy, is_rate_B);
>
>  	if (ret) {
> -		dev_err(hba->dev,
> -		"%s: ufs_qcom_phy_calibrate_phy()failed, ret = %d\n",
> -		__func__, ret);
> +		dev_err(hba->dev, "%s: ufs_qcom_phy_calibrate_phy() failed, ret =
> %d\n",
> +			__func__, ret);
>  		goto out;
>  	}
>
> @@ -524,6 +525,18 @@ static int ufs_qcom_link_startup_notify(struct
> ufs_hba *hba,
>  			err = ufs_qcom_set_dme_vs_core_clk_ctrl_clear_div(hba,
>  									  150);
>
> +		/*
> +		 * Some UFS devices (and may be host) have issues if LCC is
> +		 * enabled. So we are setting PA_Local_TX_LCC_Enable to 0
> +		 * before link startup which will make sure that both host
> +		 * and device TX LCC are disabled once link startup is
> +		 * completed.
> +		 */
> +		if (ufshcd_get_local_unipro_ver(hba) != UFS_UNIPRO_VER_1_41)
> +			err = ufshcd_dme_set(hba,
> +					UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE),
> +					0);
> +
>  		break;
>  	case POST_CHANGE:
>  		ufs_qcom_link_startup_post_change(hba);
> @@ -1542,7 +1555,7 @@ static int ufs_qcom_probe(struct platform_device
> *pdev)
>   * ufs_qcom_remove - set driver_data of the device to NULL
>   * @pdev: pointer to platform device handle
>   *
> - * Always return 0
> + * Always returns 0
>   */
>  static int ufs_qcom_remove(struct platform_device *pdev)
>  {
> diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
> index 8082020..e2854e4 100644
> --- a/drivers/scsi/ufs/unipro.h
> +++ b/drivers/scsi/ufs/unipro.h
> @@ -75,6 +75,7 @@
>  #define PA_MAXRXSPEEDFAST	0x1541
>  #define PA_MAXRXSPEEDSLOW	0x1542
>  #define PA_TXLINKSTARTUPHS	0x1544
> +#define PA_LOCAL_TX_LCC_ENABLE	0x155E
>  #define PA_TXSPEEDFAST		0x1565
>  #define PA_TXSPEEDSLOW		0x1566
>  #define PA_REMOTEVERINFO	0x15A0
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

