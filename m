From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [scsi] scsi: ufs: don't check unsigned type for a negative value
Date: Mon, 13 Mar 2017 17:19:01 -0700
Message-ID: <cf0e9b50910b10166d23cb37e9f5b4b0@codeaurora.org>
References: <20170312102202.9889-1-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170312102202.9889-1-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2017-03-12 03:22, Tomas Winkler wrote:
> Fix compilation warning
> 
> drivers/scsi/ufs/ufshcd.c:7645:13: warning: comparison of unsigned
> expression < 0 is always false [-Wtype-limits]
> if ((value < UFS_PM_LVL_0) || (value >= UFS_PM_LVL_MAX))
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1359913bf840..e8c26e6e6237 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7642,7 +7642,7 @@ static inline ssize_t ufshcd_pm_lvl_store(struct
> device *dev,
>  	if (kstrtoul(buf, 0, &value))
>  		return -EINVAL;
> 
> -	if ((value < UFS_PM_LVL_0) || (value >= UFS_PM_LVL_MAX))
> +	if (value >= UFS_PM_LVL_MAX)
>  		return -EINVAL;
> 
>  	spin_lock_irqsave(hba->host->host_lock, flags);

LGTM.
Reviewed-by: Subhash Jadavani <subhashj@codaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
