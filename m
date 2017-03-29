From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 6/6] scsi: ufs: just use sizeof() for snprintf()
Date: Tue, 28 Mar 2017 22:08:59 -0700
Message-ID: <b574d6038c62c14466099cb3216b4746@codeaurora.org>
References: <20170328134929.25599-1-tkusumi@tuxera.com>
 <20170328134929.25599-6-tkusumi@tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50620 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752554AbdC2FJB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2017 01:09:01 -0400
In-Reply-To: <20170328134929.25599-6-tkusumi@tuxera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kusumi.tomohiro@gmail.com
Cc: martin.petersen@oracle.com, vinholikatti@gmail.com, linux-scsi@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>, linux-scsi-owner@vger.kernel.org

On 2017-03-28 06:49, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> Not much reason to use ARRAY_SIZE() when we know it's for a C string.
> 
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 109a762..790c19c 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7880,7 +7880,7 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  		INIT_WORK(&hba->clk_scaling.resume_work,
>  			  ufshcd_clk_scaling_resume_work);
> 
> -		snprintf(wq_name, ARRAY_SIZE(wq_name), "ufs_clkscaling_%d",
> +		snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
>  			 host->host_no);
>  		hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);


Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
