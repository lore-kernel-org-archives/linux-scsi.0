From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] ufs: qcom: Properly clear hba priv on failure
Date: Sat, 19 Nov 2016 12:30:24 -0800
Message-ID: <99d75f263b7b973ddbe5031d8500048c@codeaurora.org>
References: <1479502542-1136-1-git-send-email-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1479502542-1136-1-git-send-email-bjorn.andersson@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Yaniv Gardi <ygardi@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2016-11-18 12:55, Bjorn Andersson wrote:
> In the case where we fail to acquire the phy the hba priv will be set
> already, so during cleanup ufs_qcom_setup_clocks() will dereference the
> now free, but still "valid looking" pointer "host".

host (ufs_qcom_host) was allocated with devm_kzalloc() so i am not sure 
why it would be freed up before probe() returns failure.

> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index d345434b084f..7bd88ffee47a 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1197,7 +1197,7 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  	if (IS_ERR(host->generic_phy)) {
>  		err = PTR_ERR(host->generic_phy);
>  		dev_err(dev, "%s: PHY get failed %d\n", __func__, err);
> -		goto out;
> +		goto out_host_free;
>  	}
> 
>  	err = ufs_qcom_bus_register(host);

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
