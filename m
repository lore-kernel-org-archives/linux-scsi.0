From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2] ufs: qcom: Properly clear hba priv on failure
Date: Mon, 21 Nov 2016 10:33:32 -0800
Message-ID: <2a5a8cf3b6eb25c4def4a03d879208e3@codeaurora.org>
References: <1479623691-7612-1-git-send-email-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43624 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754576AbcKUSde (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2016 13:33:34 -0500
In-Reply-To: <1479623691-7612-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Yaniv Gardi <ygardi@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-11-19 22:34, Bjorn Andersson wrote:
> ufs_qcom_init() sets the hba priv data before attempting to acquire the
> phy handle, so make sure to clear this in the case of an error. Failing
> to do this will make ufs_qcom_setup_clocks() operate on the 
> uninitalized
> host object.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index d345434b084f..4de372d271b0 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1197,12 +1197,12 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  	if (IS_ERR(host->generic_phy)) {
>  		err = PTR_ERR(host->generic_phy);
>  		dev_err(dev, "%s: PHY get failed %d\n", __func__, err);
> -		goto out;
> +		goto out_variant_clear;
>  	}
> 
>  	err = ufs_qcom_bus_register(host);
>  	if (err)
> -		goto out_host_free;
> +		goto out_variant_clear;
> 
>  	ufs_qcom_get_controller_revision(hba, &host->hw_ver.major,
>  		&host->hw_ver.minor, &host->hw_ver.step);
> @@ -1267,7 +1267,7 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  	phy_power_off(host->generic_phy);
>  out_unregister_bus:
>  	phy_exit(host->generic_phy);
> -out_host_free:
> +out_variant_clear:
>  	ufshcd_set_variant(hba, NULL);
>  out:
>  	return err;

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
