From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Correctly release and allocate a new request on TUR	retries
Date: Mon, 8 Dec 2008 14:20:58 +0100
Message-ID: <20081208132058.GB18255@kernel.dk>
References: <49393C88.8080103@hp.com> <20081205144954.GO18255@kernel.dk> <20081205180851.GA9671@linux.vnet.ibm.com> <493D1DE2.5090907@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:4741 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbYLHNVL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2008 08:21:11 -0500
Content-Disposition: inline
In-Reply-To: <493D1DE2.5090907@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, James.Bottomley@HansenPartnership.com

On Mon, Dec 08 2008, Alan D. Brunelle wrote:
> Mike Anderson wrote:
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> >> On Fri, Dec 05 2008, Alan D. Brunelle wrote:
> >>> Commands needing to be retried (TUR in this case) would result in a block
> >>> I/O request being re-used, without being re-initialized properly. This
> >>> patch ensures that the requests are correctly re-initialized via
> >>> standard allocation means.
> >>>
> >>> Prior to this patch, boots were failing consistently as in:
> >>> http://lkml.org/lkml/2008/12/5/161
> >>>
> >>> With this patch in place, the system is booting reliably.
> >>>
> >>> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
> >>> Cc: Jens Axboe <jens.axboe@oracle.com>
> >> Looks good.
> >>
> >> Acked-by: Jens Axboe <jens.axboe@oracle.com>
> >>
> >> Perhaps James can push it in, I'm about to shutdown for the day...
> >>
> > 
> > I know a failure was not detected in the hp_sw_start_stop function, but it
> > uses the same retry method as hp_sw_tur we should update this function
> > also.
> > 
> > I made a quick scope of callers of blk_get_request and I did not see a
> > repeated of this retry usage model. I will make another pass to see if I
> > missed something.
> 
> drivers/cdrom/cdrom.c:cdrom_read_cdda_bpc() is even worse: it gets one
> request, then sits in a while loop re-using the same request over and
> over again.

Sigh, it does indeed look messy...

> Since blk_rq_init() is an exported symbol, perhaps instead of having the
> three callers realloc, it _may_ be sufficient to just have them call
> that before re-use? (See attached un-tested patch for an example.)

I think that's a really bad idea, since it basically just clears the
'rq'. If you have that rq on some list (timeout, for instance), the
kernel will not be happy. I think we have to, for now at least, put and
get a request before looping. Then for 2.6.29 we can hopefully improve
this situation!


> 
> Regards,
> Alan

> 
> Commands needing to be retried would result in a block I/O request being
> re-used, without being re-initialized properly.  This patch ensures that
> the requests are correctly re-initialized via standard allocation means.
> 
> Prior to this patch, boots were failing consistently as in:
> http://lkml.org/lkml/2008/12/5/161
> 
> With this patch in place, the system is booting reliably.
> 
> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/cdrom/cdrom.c                       |    2 ++
>  drivers/scsi/device_handler/scsi_dh_hp_sw.c |    8 ++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
> index d16b024..0b86d8a 100644
> --- a/drivers/cdrom/cdrom.c
> +++ b/drivers/cdrom/cdrom.c
> @@ -2131,6 +2131,8 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
>  		nframes -= nr;
>  		lba += nr;
>  		ubuf += len;
> +
> +		blk_rq_init(q, rq);
>  	}
>  
>  	blk_put_request(rq);
> diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> index 9aec4ca..075ae35 100644
> --- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> +++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> @@ -136,8 +136,10 @@ retry:
>  		h->path_state = HP_SW_PATH_ACTIVE;
>  		ret = SCSI_DH_OK;
>  	}
> -	if (ret == SCSI_DH_IMM_RETRY)
> +	if (ret == SCSI_DH_IMM_RETRY) {
> +		blk_rq_init(req->q, q);
>  		goto retry;
> +	}
>  	if (ret == SCSI_DH_DEV_OFFLINED) {
>  		h->path_state = HP_SW_PATH_PASSIVE;
>  		ret = SCSI_DH_OK;
> @@ -231,8 +233,10 @@ retry:
>  		ret = SCSI_DH_OK;
>  
>  	if (ret == SCSI_DH_RETRY) {
> -		if (--retry)
> +		if (--retry) {
> +			blk_rq_init(req->q, req);
>  			goto retry;
> +		}
>  		ret = SCSI_DH_IO;
>  	}
>  
> -- 
> 1.5.6.3
> 


-- 
Jens Axboe

