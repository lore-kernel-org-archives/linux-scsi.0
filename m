From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH v3 5/5] Revert
 "scsi: ufs: disable vccq if it's not needed by UFS device"
Date: Tue, 5 Feb 2019 10:28:43 +0530
Message-ID: <5f2a8378-1f22-6a52-356d-56d3b393ab1d@samsung.com>
References: <e3c82a49-c601-effc-348f-f768656c659f@free.fr>
        <CGME20190204174549epcas4p4682667176f55101f69cc24cc455c9f3c@epcas4p4.samsung.com>
        <70618c25-83f0-b9db-51a3-c1d74b605a45@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <70618c25-83f0-b9db-51a3-c1d74b605a45@free.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>, MSM <linux-arm-msm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Subhash Jadavani <subhashj@codeaurora.org>, Bart Van Assche <bvanassche@acm.org>, SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Marc,

On 04/02/19 11:12 PM, Marc Gonzalez wrote:
> This reverts commit 60f0187031c05e04cbadffb62f557d0ff3564490.
> 
> Calling ufshcd_set_vccq_rail_unused hangs my system.
> It seems vccq is not *not* needed.
> 
> Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
> ---

AFAIK Samsung and Toshiba UFS devices does not use VCCQ (this pin is 
either floating or connected to Ground, at least on the devices that I 
have worked on).
You said your system hanged, I believe you have set UFS_DEVICE_NO_VCCQ 
quirks, in that case VCCQ regulator should having been disabled.
So you mean your system hanged because vccq regulator got disabled?

>   drivers/scsi/ufs/ufs.h    |  1 -
>   drivers/scsi/ufs/ufshcd.c | 59 +++------------------------------------
>   2 files changed, 4 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index dd65fea07687..7da7318eb6a6 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -514,7 +514,6 @@ struct ufs_vreg {
>   	struct regulator *reg;
>   	const char *name;
>   	bool enabled;
> -	bool unused;
>   	int min_uV;
>   	int max_uV;
>   	int min_uA;
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9ba7671b84f8..8b9a01073d62 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -245,7 +245,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba);
>   static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
>   				 bool skip_ref_clk);
>   static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
> -static int ufshcd_set_vccq_rail_unused(struct ufs_hba *hba, bool unused);
>   static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
>   static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
>   static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
> @@ -6819,11 +6818,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>   	ufs_fixup_device_setup(hba, &card);
>   	ufshcd_tune_unipro_params(hba);
>   
> -	ret = ufshcd_set_vccq_rail_unused(hba,
> -		(hba->dev_quirks & UFS_DEVICE_NO_VCCQ) ? true : false);
> -	if (ret)
> -		goto out;
> -
>   	/* UFS device is also active now */
>   	ufshcd_set_ufs_dev_active(hba);
>   	ufshcd_force_reset_auto_bkops(hba);
> @@ -7007,24 +7001,13 @@ static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
>   static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
>   					 struct ufs_vreg *vreg)
>   {
> -	if (!vreg)
> -		return 0;
> -	else if (vreg->unused)
> -		return 0;
> -	else
> -		return ufshcd_config_vreg_load(hba->dev, vreg,
> -					       UFS_VREG_LPM_LOAD_UA);
> +	return ufshcd_config_vreg_load(hba->dev, vreg, UFS_VREG_LPM_LOAD_UA);
>   }
>   
>   static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
>   					 struct ufs_vreg *vreg)
>   {
> -	if (!vreg)
> -		return 0;
> -	else if (vreg->unused)
> -		return 0;
> -	else
> -		return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
> +	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
>   }
>   
>   static int ufshcd_config_vreg(struct device *dev,
> @@ -7062,9 +7045,7 @@ static int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
>   {
>   	int ret = 0;
>   
> -	if (!vreg)
> -		goto out;
> -	else if (vreg->enabled || vreg->unused)
> +	if (!vreg || vreg->enabled)
>   		goto out;
>   
>   	ret = ufshcd_config_vreg(dev, vreg, true);
> @@ -7084,9 +7065,7 @@ static int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
>   {
>   	int ret = 0;
>   
> -	if (!vreg)
> -		goto out;
> -	else if (!vreg->enabled || vreg->unused)
> +	if (!vreg || !vreg->enabled)
>   		goto out;
>   
>   	ret = regulator_disable(vreg->reg);
> @@ -7192,36 +7171,6 @@ static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
>   	return 0;
>   }
>   
> -static int ufshcd_set_vccq_rail_unused(struct ufs_hba *hba, bool unused)
> -{
> -	int ret = 0;
> -	struct ufs_vreg_info *info = &hba->vreg_info;
> -
> -	if (!info)
> -		goto out;
> -	else if (!info->vccq)
> -		goto out;
> -
> -	if (unused) {
> -		/* shut off the rail here */
> -		ret = ufshcd_toggle_vreg(hba->dev, info->vccq, false);
> -		/*
> -		 * Mark this rail as no longer used, so it doesn't get enabled
> -		 * later by mistake
> -		 */
> -		if (!ret)
> -			info->vccq->unused = true;
> -	} else {
> -		/*
> -		 * rail should have been already enabled hence just make sure
> -		 * that unused flag is cleared.
> -		 */
> -		info->vccq->unused = false;
> -	}
> -out:
> -	return ret;
> -}
> -
>   static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
>   					bool skip_ref_clk)
>   {
> 
