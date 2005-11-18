From: mikem <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [PATCH 2/3] cciss: bug fix for BIG_PASS_THRU
Date: Fri, 18 Nov 2005 15:32:17 -0600
Message-ID: <20051118213217.GA23551@beardog.cca.cpqcorp.net>
References: <20051118164112.GA14937@beardog.cca.cpqcorp.net> <20051118210123.GC25454@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:3514 "EHLO
	ccerelbas04.cce.hp.com") by vger.kernel.org with ESMTP
	id S1751006AbVKRVc3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 16:32:29 -0500
Content-Disposition: inline
In-Reply-To: <20051118210123.GC25454@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Nov 18, 2005 at 10:01:24PM +0100, Jens Axboe wrote:
> On Fri, Nov 18 2005, mikem wrote:
> > Patch 2 of 3
> > 
> > Applications using CCISS_BIG_PASSTHRU complained that the data written
> > was zeros.  The code looked alright, but it seems that copy_from_user 
> > already does a memset on the buffer. Removing it from the pass-through
> > fixes the apps.
> 
> Hmm, I don't like this patch, since you never clear the buffer for reads
> now. If the controller for some reason doesn't overwrite this buffer,
> you could be leaking privileged data! Your bug is because you do:
> 
>         if (write && copy_from_user(...))
>                 fail
>         else
>                 clear
> 
> so you end up in the clear case for any case where copy_from_user()
> doesn't fail. I've fixed it up for you, this is what I committed:

Thanks, Jens.

> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index e239a6c..33f8341 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -1017,10 +1017,11 @@ static int cciss_ioctl(struct inode *ino
>  				status = -ENOMEM;
>  				goto cleanup1;
>  			}
> -			if (ioc->Request.Type.Direction == XFER_WRITE &&
> -				copy_from_user(buff[sg_used], data_ptr, sz)) {
> +			if (ioc->Request.Type.Direction == XFER_WRITE) {
> +				if (copy_from_user(buff[sg_used], data_ptr, sz)) {
>  					status = -ENOMEM;
> -					goto cleanup1;			
> +					goto cleanup1;
> +				}
>  			} else {
>  				memset(buff[sg_used], 0, sz);
>  			}
> 
> -- 
> Jens Axboe
> 
