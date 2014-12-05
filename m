From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] SCSI: SD: set max_ws_blocks as max_unmap_blocks if it
 isn't provided
Date: Fri, 05 Dec 2014 16:43:50 +0100
Message-ID: <5481D2B6.2050104@redhat.com>
References: <1417782952-19908-1-git-send-email-ming.lei@canonical.com>	<yq1r3wefe6o.fsf@sermon.lab.mkp.net>	<CACVXFVMB4GT2XewVh3CbamJUqb2VbaW=4yxJnQjw39z1rBgdNw@mail.gmail.com>	<yq1mw72fczo.fsf@sermon.lab.mkp.net>	<CACVXFVO-faCX-yHhrvb=Rt8TS9WcVT2nSMXEbss6mOhaKfC49g@mail.gmail.com>	<yq1iohqfc7i.fsf@sermon.lab.mkp.net>	<CACVXFVM7A2Y+g8gQL4-LMcvp-qpx6kuKbr51gx4paGe1NLyb2A@mail.gmail.com> <yq1egsefbbo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaLEPoE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 10:44:04 -0500
In-Reply-To: <yq1egsefbbo.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Lei <ming.lei@canonical.com>
Cc: James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Linux SCSI List <linux-scsi@vger.kernel.org>



On 05/12/2014 14:58, Martin K. Petersen wrote:
>>>>>> "Ming" == Ming Lei <ming.lei@canonical.com> writes:
> 
>>> What about in READ CAPACITY(16)?
> 
> Ming> It isn't set too.
> 
> Please try the following patch:
> 
> 
> [SCSI] sd: Tweak discard heuristics to work around QEMU SCSI issue
> 
> 7985090aa020 changed the discard heuristics to give preference to the
> WRITE SAME commands that (unlike UNMAP) guarantee deterministic results.
> 
> Ming Lei discovered that QEMU SCSI's WRITE SAME implementation
> internally relied on limits that were only communicated for the UNMAP
> case. And therefore discard commands backed by WRITE SAME would fail.
> 
> Tweak the heuristics so we still pick UNMAP in the LBPRZ=0 case and only
> prefer the WRITE SAME variants if the device has the LBPRZ flag set.
> 
> Reported-by: Ming Lei <ming.lei@canonical.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 95bfb7bfbb9d..76c5d1388417 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2623,8 +2623,9 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
>  				sd_config_discard(sdkp, SD_LBP_WS16);
>  
>  		} else {	/* LBP VPD page tells us what to use */
> -
> -			if (sdkp->lbpws)
> +			if (sdkp->lbpu && sdkp->max_unmap_blocks && !sdkp->lbprz)
> +				sd_config_discard(sdkp, SD_LBP_UNMAP);
> +			else if (sdkp->lbpws)
>  				sd_config_discard(sdkp, SD_LBP_WS16);
>  			else if (sdkp->lbpws10)
>  				sd_config_discard(sdkp, SD_LBP_WS10);
> 

This is the right fix.  Ming, how do you reproduce the QEMU bug?

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
