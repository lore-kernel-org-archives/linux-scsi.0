From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 3/3] scsi: ufs: Use freq table with devfreq
Date: Tue, 24 Apr 2018 15:08:52 -0700
Message-ID: <5e59150bf025e2caa1deadfec7293ecd@codeaurora.org>
References: <20180424002016.9205-1-bjorn.andersson@linaro.org>
 <20180424002016.9205-4-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180424002016.9205-4-bjorn.andersson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MyungJoo Ham <myungjoo.ham@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-04-23 17:20, Bjorn Andersson wrote:
> devfreq requires that the client operates on actual frequencies, not
> only 0 and UMAX_INT and as such UFS brok with the introduction of
> f1d981eaecf8 ("PM / devfreq: Use the available min/max frequency").
> 
> This patch registers the frequencies of the first clock with devfreq 
> and
> use these to determine if we're trying to step up or down.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 39 ++++++++++++++++++++++++++++++++-------
>  1 file changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 2253f24309ec..07b1f3c7bd2d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1168,16 +1168,13 @@ static int ufshcd_devfreq_target(struct device 
> *dev,
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
>  	ktime_t start;
>  	bool scale_up, sched_clk_scaling_suspend_work = false;
> +	struct list_head *clk_list = &hba->clk_list_head;
> +	struct ufs_clk_info *clki;
>  	unsigned long irq_flags;
> 
>  	if (!ufshcd_is_clkscaling_supported(hba))
>  		return -EINVAL;
> 
> -	if ((*freq > 0) && (*freq < UINT_MAX)) {
> -		dev_err(hba->dev, "%s: invalid freq = %lu\n", __func__, *freq);
> -		return -EINVAL;
> -	}
> -
>  	spin_lock_irqsave(hba->host->host_lock, irq_flags);
>  	if (ufshcd_eh_in_progress(hba)) {
>  		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
> @@ -1187,7 +1184,13 @@ static int ufshcd_devfreq_target(struct device 
> *dev,
>  	if (!hba->clk_scaling.active_reqs)
>  		sched_clk_scaling_suspend_work = true;
> 
> -	scale_up = (*freq == UINT_MAX) ? true : false;
> +	if (list_empty(clk_list)) {
> +		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
> +		goto out;
> +	}
> +
> +	clki = list_first_entry(&hba->clk_list_head, struct ufs_clk_info, 
> list);
> +	scale_up = (*freq == clki->max_freq) ? true : false;
>  	if (!ufshcd_is_devfreq_scaling_required(hba, scale_up)) {
>  		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
>  		ret = 0;
> @@ -1257,11 +1260,33 @@ static struct devfreq_dev_profile
> ufs_devfreq_profile = {
> 
>  static int ufshcd_devfreq_init(struct ufs_hba *hba)
>  {
> +	struct devfreq_dev_profile *profile;
> +	struct list_head *clk_list = &hba->clk_list_head;
> +	struct ufs_clk_info *clki;
>  	struct devfreq *devfreq;
>  	int ret;
> 
> +	/* Skip devfreq if we don't have any clocks in the list */
> +	if (list_empty(clk_list))
> +		return 0;
> +
> +	profile = devm_kmemdup(hba->dev, &ufs_devfreq_profile,
> +			       sizeof(ufs_devfreq_profile), GFP_KERNEL);
> +	if (!profile)
> +		return -ENOMEM;
> +
> +	profile->max_state = 2;
> +	profile->freq_table = devm_kcalloc(hba->dev, profile->max_state,
> +					   sizeof(unsigned long), GFP_KERNEL);
> +	if (!profile->freq_table)
> +		return -ENOMEM;
> +
> +	clki = list_first_entry(&hba->clk_list_head, struct ufs_clk_info, 
> list);
> +	profile->freq_table[0] = clki->min_freq;
> +	profile->freq_table[1] = clki->max_freq;
> +
>  	devfreq = devm_devfreq_add_device(hba->dev,
> -			&ufs_devfreq_profile,
> +			profile,
>  			"simple_ondemand",
>  			NULL);
>  	if (IS_ERR(devfreq)) {

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
