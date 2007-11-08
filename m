From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 2/3] scsi_data_buffer
Date: Thu, 8 Nov 2007 22:03:15 +0900
Message-ID: <20071108220324Y.tomof@acm.org>
References: <4730B034.6050309@panasas.com>
	<20071108121435S.fujita.tomonori@lab.ntt.co.jp>
	<4732D5D4.9030109@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:44534 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbXKHNEu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Nov 2007 08:04:50 -0500
In-Reply-To: <4732D5D4.9030109@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, pw@osc.edu, bhalevy@panasas.com

On Thu, 08 Nov 2007 11:24:36 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> >> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> >> index 18343a6..28cf6fe 100644
> >> --- a/drivers/scsi/sd.c
> >> +++ b/drivers/scsi/sd.c
> >> @@ -448,9 +448,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
> >>  	} else if (rq_data_dir(rq) == READ) {
> >>  		SCpnt->cmnd[0] = READ_6;
> >>  		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
> >> -	} else {
> >> -		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n", rq->cmd_flags);
> >> -		goto out;
> > 
> > This should go to the bidi patch?
> > 
> >>  	}
> >>  
> This is just a dead code cleanup. It is got nothing to do with bidi or scsi_data_buffer
> for that matter. It could be in it's own patch, but surly it will not go into the bidi
> patch. I will submit a new patch just for that code. Independent of these.
> (I was hoping to save the extra effort)

Hm, is it dead code? I think it's kinda BUG_ON, that is, we should not
hit that code. sd only accetps READ and WRITE requests. It prevents
funcy requests like BIDI from accidentally comming.
