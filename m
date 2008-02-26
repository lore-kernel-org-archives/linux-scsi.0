From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: regression: CD burning (k3b) went broke
Date: Tue, 26 Feb 2008 15:08:45 -0800
Message-ID: <20080226150845.2196bc1a.akpm@linux-foundation.org>
References: <1203583379.6244.27.camel@homer.simson.net>
	<20080222073228.GZ23197@kernel.dk>
	<1203752563.5225.4.camel@homer.simson.net>
	<1203839683.17463.9.camel@homer.simson.net>
	<1204019283.8731.11.camel@homer.simson.net>
	<1204033003.11828.22.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbYBZXKg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Feb 2008 18:10:36 -0500
In-Reply-To: <1204033003.11828.22.camel@homer.simson.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 26 Feb 2008 14:36:43 +0100 Mike Galbraith <efault@gmx.de> wrote:

> 
> On Tue, 2008-02-26 at 10:48 +0100, Mike Galbraith wrote:
> > Greetings,
> > 
> > I straced both a good and a bad kernel (good being .git with attached
> > revert patch applied) and filtered/diffed/merged the output.  Scroll
> > down to "HERE" to see the problem (resid).
> > 
> > I'm poking around, but not having much luck.

cc's added.

I'm told this is part of "Tejun's DMA drain handling".

> Seems the problem is data_len changes, but raw_data_len doesn't.  I've
> not the foggiest IO-land clue, but k3b works again, so the below may
> have some diagnostic value.

So this change fixes a bug?  Can we have a recap of how it does this?

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ba21d97..7a6f784 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -871,7 +871,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  			scsi_end_bidi_request(cmd);
>  			return;
>  		}
> -		req->data_len = scsi_get_resid(cmd);
> +		req->data_len = req->raw_data_len = scsi_get_resid(cmd);
>  	}
>  
>  	BUG_ON(blk_bidi_rq(req)); /* bidi not support for !blk_pc_request yet */
> 

Thanks.
