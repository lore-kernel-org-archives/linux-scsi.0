From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH] drivers: message: fusion: Simplify rounding
Date: Thu, 3 Jul 2014 13:49:29 -0400
Message-ID: <alpine.DEB.2.02.1407031300280.9641@jlaw-desktop.mno.stratus.com>
References: <1404219380-2712-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1404219380-2712-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ALIGN is certainly more readable to me.

Reviewed-by: Joe Lawrence <joe.lawrence@stratus.com>

-- Joe

On Tue, 1 Jul 2014, Rasmus Villemoes wrote:

> Rounding up to a multiple of 4 should be done using the ALIGN
> macro. As a bonus, this also makes the generated code smaller.
> 
> In GetIocFacts(), sz is assigned to a few lines below without being
> read in the meantime, so it is ok that it doesn't end up with the same
> value as facts->FWImageSize.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/message/fusion/mptbase.c | 7 +------
>  drivers/message/fusion/mptctl.c  | 7 +------
>  2 files changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index ebc0af7..10b16a1 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -3175,12 +3175,7 @@ GetIocFacts(MPT_ADAPTER *ioc, int sleepFlag, int reason)
>  			facts->FWImageSize = le32_to_cpu(facts->FWImageSize);
>  		}
>  
> -		sz = facts->FWImageSize;
> -		if ( sz & 0x01 )
> -			sz += 1;
> -		if ( sz & 0x02 )
> -			sz += 2;
> -		facts->FWImageSize = sz;
> +		facts->FWImageSize = ALIGN(facts->FWImageSize, 4);
>  
>  		if (!facts->RequestFrameSize) {
>  			/*  Something is wrong!  */
> diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
> index 8a050e8..1004392 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -1749,12 +1749,7 @@ mptctl_replace_fw (unsigned long arg)
>  
>  	/* Allocate memory for the new FW image
>  	 */
> -	newFwSize = karg.newImageSize;
> -
> -	if (newFwSize & 0x01)
> -		newFwSize += 1;
> -	if (newFwSize & 0x02)
> -		newFwSize += 2;
> +	newFwSize = ALIGN(karg.newImageSize, 4);
>  
>  	mpt_alloc_fw_memory(ioc, newFwSize);
>  	if (ioc->cached_fw == NULL)
> -- 
> 1.9.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
