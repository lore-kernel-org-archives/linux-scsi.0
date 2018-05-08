From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Extract devfreq registration
Date: Tue, 08 May 2018 10:59:52 +0900
Message-ID: <5AF10498.1000408@samsung.com>
References: <20180504224427.32606-1-bjorn.andersson@linaro.org>
        <CGME20180504224510epcas4p2e6a1303ea814642ad851bc6072be6089@epcas4p2.samsung.com>
        <20180504224427.32606-2-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20180504224427.32606-2-bjorn.andersson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 2018년 05월 05일 07:44, Bjorn Andersson wrote:
> Failing to register with devfreq leaves hba->devfreq assigned, which
> causes the error path to dereference the ERR_PTR(). Rather than bolting
> on more conditionals, move the call of devm_devfreq_add_device() into
> it's own function and only update hba->devfreq once it's successfully
> registered.
> 
> The subsequent patch builds upon this to make UFS actually work again,
> as it's been broken since f1d981eaecf8 ("PM / devfreq: Use the available
> min/max frequency")
> 
> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> 
> Changes since v1:
> - None
> 
>  drivers/scsi/ufs/ufshcd.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 8f22a980b1a7..2253f24309ec 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1255,6 +1255,26 @@ static struct devfreq_dev_profile ufs_devfreq_profile = {
>  	.get_dev_status	= ufshcd_devfreq_get_dev_status,
>  };
>  
> +static int ufshcd_devfreq_init(struct ufs_hba *hba)
> +{
> +	struct devfreq *devfreq;
> +	int ret;
> +
> +	devfreq = devm_devfreq_add_device(hba->dev,
> +			&ufs_devfreq_profile,
> +			"simple_ondemand",

You better to use 'DEVFREQ_GOV_SIMPLE_ONDEMAND' definition
in include/linux/devfreq.h in order to prevent the some typo.
- aa7c352f9841 ("PM / devfreq: Define the constant governor name")


> +			NULL);
> +	if (IS_ERR(devfreq)) {
> +		ret = PTR_ERR(devfreq);
> +		dev_err(hba->dev, "Unable to register with devfreq %d\n", ret);
> +		return ret;
> +	}
> +
> +	hba->devfreq = devfreq;
> +
> +	return 0;
> +}
> +
>  static void __ufshcd_suspend_clkscaling(struct ufs_hba *hba)
>  {
>  	unsigned long flags;
> @@ -6399,16 +6419,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  				sizeof(struct ufs_pa_layer_attr));
>  			hba->clk_scaling.saved_pwr_info.is_valid = true;
>  			if (!hba->devfreq) {
> -				hba->devfreq = devm_devfreq_add_device(hba->dev,
> -							&ufs_devfreq_profile,
> -							"simple_ondemand",
> -							NULL);
> -				if (IS_ERR(hba->devfreq)) {
> -					ret = PTR_ERR(hba->devfreq);
> -					dev_err(hba->dev, "Unable to register with devfreq %d\n",
> -							ret);
> +				ret = ufshcd_devfreq_init(hba);
> +				if (ret)
>  					goto out;
> -				}
>  			}
>  			hba->clk_scaling.is_allowed = true;
>  		}
> 

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
