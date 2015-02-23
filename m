From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 3/4] scsi: ufs: add trace events and dump prints for
 debug
Date: Mon, 23 Feb 2015 12:12:42 -0500
Message-ID: <20150223121242.08d4c008@gandalf.local.home>
References: <1424678898-3723-1-git-send-email-gbroner@codeaurora.org>
	<1424678898-3723-4-git-send-email-gbroner@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424678898-3723-4-git-send-email-gbroner@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Gilad Broner <gbroner@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, draviv@codeaurora.org, Lee Susman <lsusman@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 23 Feb 2015 10:08:16 +0200
Gilad Broner <gbroner@codeaurora.org> wrote:

> @@ -5551,14 +5956,23 @@ EXPORT_SYMBOL(ufshcd_system_suspend);
>  
>  int ufshcd_system_resume(struct ufs_hba *hba)
>  {
> +	int ret = 0;
> +	ktime_t start = ktime_get();
> +
>  	if (!hba || !hba->is_powered || pm_runtime_suspended(hba->dev))
>  		/*
>  		 * Let the runtime resume take care of resuming
>  		 * if runtime suspended.
>  		 */
> -		return 0;
> -
> -	return ufshcd_resume(hba, UFS_SYSTEM_PM);
> +		goto out;
> +	else
> +		ret = ufshcd_resume(hba, UFS_SYSTEM_PM);
> +out:

If I understand the patch above, you basically have:

	if (....)
		goto out;
	else
		ret = ufshcd_resume();
out:

Wouldn't it be better to just reverse the above if condition?

	if (!...)
		ret = ufshcd_resume();

That would be much less confusing.


> +	trace_ufshcd_system_resume(dev_name(hba->dev), ret,
> +		ktime_to_us(ktime_sub(ktime_get(), start)),
> +		ufschd_ufs_dev_pwr_mode_to_string(hba->curr_dev_pwr_mode),
> +		ufschd_uic_link_state_to_string(hba->uic_link_state));
> +	return ret;
>  }
>  EXPORT_SYMBOL(ufshcd_system_resume);
>  
> @@ -5572,10 +5986,19 @@ EXPORT_SYMBOL(ufshcd_system_resume);
>   */
>  int ufshcd_runtime_suspend(struct ufs_hba *hba)
>  {
> -	if (!hba || !hba->is_powered)
> -		return 0;
> +	int ret = 0;
> +	ktime_t start = ktime_get();
>  
> -	return ufshcd_suspend(hba, UFS_RUNTIME_PM);
> +	if (!hba || !hba->is_powered)
> +		goto out;
> +	else
> +		ret = ufshcd_suspend(hba, UFS_RUNTIME_PM);
> +out:

Here too.

> +	trace_ufshcd_runtime_suspend(dev_name(hba->dev), ret,
> +		ktime_to_us(ktime_sub(ktime_get(), start)),
> +		ufschd_ufs_dev_pwr_mode_to_string(hba->curr_dev_pwr_mode),
> +		ufschd_uic_link_state_to_string(hba->uic_link_state));
> +	return ret;
>  }
>  EXPORT_SYMBOL(ufshcd_runtime_suspend);
>  
> @@ -5602,10 +6025,19 @@ EXPORT_SYMBOL(ufshcd_runtime_suspend);
>   */
>  int ufshcd_runtime_resume(struct ufs_hba *hba)
>  {
> +	int ret = 0;
> +	ktime_t start = ktime_get();
> +
>  	if (!hba || !hba->is_powered)
> -		return 0;
> +		goto out;
>  	else
> -		return ufshcd_resume(hba, UFS_RUNTIME_PM);
> +		ret = ufshcd_resume(hba, UFS_RUNTIME_PM);
> +out:

And here.

-- Steve

> +	trace_ufshcd_runtime_resume(dev_name(hba->dev), ret,
> +		ktime_to_us(ktime_sub(ktime_get(), start)),
> +		ufschd_ufs_dev_pwr_mode_to_string(hba->curr_dev_pwr_mode),
> +		ufschd_uic_link_state_to_string(hba->uic_link_state));
> +	return ret;
>  }
>  EXPORT_SYMBOL(ufshcd_runtime_resume);
> 
