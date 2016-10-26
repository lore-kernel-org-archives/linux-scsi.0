From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 2/2] scsi: ufs: Use the resource-managed function to add
 devfreq device
Date: Wed, 26 Oct 2016 10:23:03 -0700
Message-ID: <5742aac5e4d5e4c550a7c073047e2426@codeaurora.org>
References: <1477467350-27059-1-git-send-email-cw00.choi@samsung.com>
 <1477467498-27145-1-git-send-email-cw00.choi@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477467498-27145-1-git-send-email-cw00.choi@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, rjw@rjwysocki.net, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, cpgs@samsung.com, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2016-10-26 00:38, Chanwoo Choi wrote:
> This patch uses the resource-managed to add the devfreq device.
> This function will make it easy to handle the devfreq device.
> 
> - struct devfreq *devm_devfreq_add_device(struct device *dev,
> 				  struct devfreq_dev_profile *profile,
> 				  const char *governor_name,
> 				  void *data);
> Cc: Vinayak Holikatti <vinholikatti@gmail.com>
> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f08d41a2d70b..e639071fd3a1 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6198,8 +6198,6 @@ void ufshcd_remove(struct ufs_hba *hba)
>  	scsi_host_put(hba->host);
> 
>  	ufshcd_exit_clk_gating(hba);
> -	if (ufshcd_is_clkscaling_enabled(hba))
> -		devfreq_remove_device(hba->devfreq);
>  	ufshcd_hba_exit(hba);
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_remove);
> @@ -6495,7 +6493,7 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  	}
> 
>  	if (ufshcd_is_clkscaling_enabled(hba)) {
> -		hba->devfreq = devfreq_add_device(dev, &ufs_devfreq_profile,
> +		hba->devfreq = devm_devfreq_add_device(dev, &ufs_devfreq_profile,
>  						   "simple_ondemand", NULL);
>  		if (IS_ERR(hba->devfreq)) {
>  			dev_err(hba->dev, "Unable to register with devfreq %ld\n",

This change looks good to me but this will have merge conflicts if this 
gets in after my patch series "	[PATCH v1 00/11] scsi: ufs: bug fixes 
patch series #1" (due to "[PATCH v1 06/11] scsi: ufs: suspend clock 
scaling for failed runtime_resume"). so if you can, please pull in my 
patch series and rebase your change on top of it and send it out again.

Thanks,
Subhash

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
