From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Wed, 5 Mar 2008 04:19:33 +0900
Message-ID: <20080305041914V.tomof@acm.org>
References: <47CD53BA.5040908@gmail.com>
	<47CD7611.2030606@gmail.com>
	<47CD7C05.1080707@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:35055 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbYCDTYF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 14:24:05 -0500
In-Reply-To: <47CD7C05.1080707@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: htejun@gmail.com
Cc: tomof@acm.org, efault@gmx.de, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.comfujita.tomonori@lab.ntt.co.jp

On Wed, 05 Mar 2008 01:42:45 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Tejun Heo wrote:
> > Tejun Heo wrote:
> >> FUJITA Tomonori wrote:
> >>>> Aiee... device going down after timing out on READ_DISC_INFO.  That's
> >>>> gruesome.  Can you please try the other patches?
> >>> Tejun, I thought that libata needs a fix for sum(sg) != rq->data_len. No?
> >> The extra_len you added to qc->nbytes should be it.  The only other
> >> place to pay attention is the ATAPI transfer chunk size and your patch
> >> seems to get it right.
> >>
> >>> Now Jens' git tree should work with all the non libata stuff, ide,
> >>> firewire, bsg, etc. But I'm not sure about libata.
> >> With the second patch, all others should be fine no matter what.  I'll
> >> go check libata part again.
> > 
> > I can reproduce the problem here and it's very weird.  I'll report back
> > when I know more.
> 
> Okay, I got it.  Heh, it turns out SCSI and/or block layer is not
> ready for rq->data_len != sum(sg).  When adjusted command completes,
> SCSI midlayer completes the command with rq->data_len for PC commands
> which eventually ends up in __end_that_request_first().  As there are
> extra sg area left after completing rq->data_len, blk layer says so to
> SCSI layer and SCSI layer retries the command only with the appended
> area.

Ah, thanks!


> The following patch gets the writing going.  I really think it's a
> serious mistake to break rq->data_len == sum(sg).  If we break
> rq->data_len == requested size, the worst bugs are giving wrong size
> when issuing commands to application layer of devices which is
> relatively easy to spot and not all that command anyway.  Breaking
> rq->data_len == sum(sg), bugs will be in internal mechanics, DMA
> engine programming and transport layer.  Oh well...
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index fecba05..32439ac 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -757,7 +757,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>  				"Notifying upper driver of completion "
>  				"(result %x)\n", cmd->result));
>  
> -	good_bytes = scsi_bufflen(cmd);
> +	good_bytes = scsi_bufflen(cmd) + cmd->request->data_len;
>          if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
>  		drv = scsi_cmd_to_driver(cmd);
>  		if (drv->done)
> 
> 

Hmm, does SCSI mid-layer need to care about how many bytes the block
layer allocates? I don't think that extra_len is NOT good_bytes.

I think that the block layer had better take care about it (fix
__end_that_request_first?).
