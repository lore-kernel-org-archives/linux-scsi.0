Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72F542A92;
	Sun, 19 Jan 2025 07:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737272913; cv=none; b=Sop+5VvQ0Qyy+KCNX28Vw2awxNYlG+ED9lsH/llZKgeWv6UBvgPPkDzQbmpI28UAr3bZlIeD1mSxn5NFl/brIhcYb4dTxH4uSMos9iFK9jVcfvQj/9FcXLdjEMriCmWDBTEBw+8SGfLYwPkkz+6OCJSRgRegr9IKnh2tW3u+Ttk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737272913; c=relaxed/simple;
	bh=Jzh5oZhkSxj/zKuRJoxghIFNQepPTv/RCcOBvFcrjEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FAgNsqgnvFF4QVbjOu2EZYXM3K7JDcCnmw98ESIxaeouqF5pVVNM8VboOhrb/4q4eviADingKc2NialmVV02i8cu12h4bl/oZmXm3c1iggMOQY+fB9NJcC56JVO9zcru8+L1IolmyThXb3QBtJZOGAgYmAsKsEXAiIYCYBrafJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S21irgsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S21irgsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787FDC4CED6;
	Sun, 19 Jan 2025 07:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737272913;
	bh=Jzh5oZhkSxj/zKuRJoxghIFNQepPTv/RCcOBvFcrjEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S21irgsRHxAWkgJZztxhicSltotsv88Q7grYZMA2ZlWMushxwS/08o4+IsbXVcgCK
	 aArXsqoFpdJLul4aItgdH6pxOp4pR9QXjbfPDRH6VUQZf2RlLlol9c9KdVPBUwdLrG
	 S7PeDNsQBWf+6+HMCawojcHgdSeHCb55LvOHrhF97gpsG9EYv9p6QeIjPPv5HmzvBh
	 xJmr+SNUoCdOZO3gcVTFBWRBExCo+z6aLXBNPa6Knc4dzbT63chlCmAPc24hXMvSQe
	 MCUygWxVcaoc5iiVE0RqgMHwbq/rYlhkIkRuJuBpwm6UiYK0hBQZJz3ZlZMABcid/W
	 XmbJlvjxSRWRA==
Date: Sun, 19 Jan 2025 13:18:23 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Ziqi Chen <quic_ziqichen@quicinc.com>
Cc: quic_cang@quicinc.com, bvanassche@acm.org, beanhuo@micron.com,
	avri.altman@wdc.com, junwoo80.lee@samsung.com,
	martin.petersen@oracle.com, quic_nguyenb@quicinc.com,
	quic_nitirawa@quicinc.com, quic_rampraka@quicinc.com,
	linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] scsi: ufs: core: Enable multi-level gear scaling
Message-ID: <20250119074823.lnlppdpsfnkz7onx@thinkpad>
References: <20250116091150.1167739-1-quic_ziqichen@quicinc.com>
 <20250116091150.1167739-6-quic_ziqichen@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250116091150.1167739-6-quic_ziqichen@quicinc.com>

On Thu, Jan 16, 2025 at 05:11:46PM +0800, Ziqi Chen wrote:
> From: Can Guo <quic_cang@quicinc.com>
> 
> With OPP V2 enabled, devfreq can scale clocks amongst multiple frequency
> plans. However, the gear speed is only toggled between min and max during
> clock scaling. Enable multi-level gear scaling by mapping clock frequencies
> to gear speeds, so that when devfreq scales clock frequencies we can put
> the UFS link at the appropraite gear speeds accordingly.
> 
> Co-developed-by: Ziqi Chen <quic_ziqichen@quicinc.com>
> Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
> Signed-off-by: Can Guo <quic_cang@quicinc.com>
> ---
>  drivers/ufs/core/ufshcd.c | 46 ++++++++++++++++++++++++++++++---------
>  1 file changed, 36 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 8d295cc827cc..839bc23aeda0 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1308,16 +1308,28 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
>  /**
>   * ufshcd_scale_gear - scale up/down UFS gear
>   * @hba: per adapter instance
> + * @target_gear: target gear to scale to
>   * @scale_up: True for scaling up gear and false for scaling down
>   *
>   * Return: 0 for success; -EBUSY if scaling can't happen at this time;
>   * non-zero for any other errors.
>   */
> -static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
> +static int ufshcd_scale_gear(struct ufs_hba *hba, u32 target_gear, bool scale_up)
>  {
>  	int ret = 0;
>  	struct ufs_pa_layer_attr new_pwr_info;
>  
> +	if (target_gear) {
> +		memcpy(&new_pwr_info, &hba->pwr_info,
> +		       sizeof(struct ufs_pa_layer_attr));
> +
> +		new_pwr_info.gear_tx = target_gear;
> +		new_pwr_info.gear_rx = target_gear;
> +
> +		goto do_pmc;

goto config_pwr_mode;

> +	}
> +
> +	/* Legacy gear scaling, in case vops_freq_to_gear_speed() is not implemented */
>  	if (scale_up) {
>  		memcpy(&new_pwr_info, &hba->clk_scaling.saved_pwr_info,
>  		       sizeof(struct ufs_pa_layer_attr));
> @@ -1338,6 +1350,7 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
>  		}
>  	}
>  
> +do_pmc:
>  	/* check if the power mode needs to be changed or not? */
>  	ret = ufshcd_config_pwr_mode(hba, &new_pwr_info);
>  	if (ret)
> @@ -1408,15 +1421,19 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err, bool sc
>  static int ufshcd_devfreq_scale(struct ufs_hba *hba, unsigned long freq,
>  				bool scale_up)
>  {
> +	u32 old_gear = hba->pwr_info.gear_rx;
> +	u32 new_gear = 0;
>  	int ret = 0;
>  
> +	ufshcd_vops_freq_to_gear_speed(hba, freq, &new_gear);
> +
>  	ret = ufshcd_clock_scaling_prepare(hba, 1 * USEC_PER_SEC);
>  	if (ret)
>  		return ret;
>  
>  	/* scale down the gear before scaling down clocks */
>  	if (!scale_up) {
> -		ret = ufshcd_scale_gear(hba, false);
> +		ret = ufshcd_scale_gear(hba, new_gear, false);
>  		if (ret)
>  			goto out_unprepare;
>  	}
> @@ -1424,13 +1441,13 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, unsigned long freq,
>  	ret = ufshcd_scale_clks(hba, freq, scale_up);
>  	if (ret) {
>  		if (!scale_up)
> -			ufshcd_scale_gear(hba, true);
> +			ufshcd_scale_gear(hba, old_gear, true);
>  		goto out_unprepare;
>  	}
>  
>  	/* scale up the gear after scaling up clocks */
>  	if (scale_up) {
> -		ret = ufshcd_scale_gear(hba, true);
> +		ret = ufshcd_scale_gear(hba, new_gear, true);
>  		if (ret) {
>  			ufshcd_scale_clks(hba, hba->devfreq->previous_freq,
>  					  false);
> @@ -1723,6 +1740,8 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
>  		struct device_attribute *attr, const char *buf, size_t count)
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	struct ufs_clk_info *clki;
> +	unsigned long freq;
>  	u32 value;
>  	int err = 0;
>  
> @@ -1746,14 +1765,21 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
>  
>  	if (value) {
>  		ufshcd_resume_clkscaling(hba);
> -	} else {
> -		ufshcd_suspend_clkscaling(hba);
> -		err = ufshcd_devfreq_scale(hba, ULONG_MAX, true);
> -		if (err)
> -			dev_err(hba->dev, "%s: failed to scale clocks up %d\n",
> -					__func__, err);
> +		goto out_rel;
>  	}
>  
> +	clki = list_first_entry(&hba->clk_list_head, struct ufs_clk_info, list);
> +	freq = clki->max_freq;
> +
> +	ufshcd_suspend_clkscaling(hba);
> +	err = ufshcd_devfreq_scale(hba, freq, true);
> +	if (err)
> +		dev_err(hba->dev, "%s: failed to scale clocks up %d\n",
> +				__func__, err);
> +	else
> +		hba->clk_scaling.target_freq = freq;
> +

Just noticed that the 'clkscale_enable', 'clkgate_{delay_ms}/enable' sysfs
attributes have no ABI documentation. Please add them also in a separate patch.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
