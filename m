From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] mptfusion: prevent some memory corruption
Date: Fri, 21 Aug 2015 18:42:21 +0300
Message-ID: <20150821154221.GS5610@mwanda>
References: <20150703085303.GA11901@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150703085303.GA11901@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Ping?

regards,
dan carpenter

On Fri, Jul 03, 2015 at 11:53:03AM +0300, Dan Carpenter wrote:
> These are signed values the come from the user, we put a cap on the
> upper bounds but not on the lower bounds.
> 
> We use "karg.dataSgeOffset" to calculate "sz".  We verify "sz" and
> proceed as if that means that "karg.dataSgeOffset" is correct but this
> fails to consider that the "sz" calculations can have integer overflows.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> During my QC process, I realized that I sent a similar patch last year,
> but never received a response.
> 
> http://permalink.gmane.org/gmane.linux.kernel.janitors/32590
> 
> Looking at both of them, I guess I prefer today's patch because it is
> simpler.
> 
> diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
> index 70bb753..fc73937 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -1859,6 +1859,15 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
>  	}
>  	spin_unlock_irqrestore(&ioc->taskmgmt_lock, flags);
>  
> +	/* Basic sanity checks to prevent underflows or integer overflows */
> +	if (karg.maxReplyBytes < 0 ||
> +	    karg.dataInSize < 0 ||
> +	    karg.dataOutSize < 0 ||
> +	    karg.dataSgeOffset < 0 ||
> +	    karg.maxSenseBytes < 0 ||
> +	    karg.dataSgeOffset > ioc->req_sz / 4)
> +		return -EINVAL;
> +
>  	/* Verify that the final request frame will not be too large.
>  	 */
>  	sz = karg.dataSgeOffset * 4;
