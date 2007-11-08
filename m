From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] scsi_data_buffer
Date: Thu, 08 Nov 2007 15:53:36 +0200
Message-ID: <473314E0.1030409@panasas.com>
References: <4730B034.6050309@panasas.com>	<20071108121435S.fujita.tomonori@lab.ntt.co.jp>	<4732D5D4.9030109@panasas.com> <20071108220324Y.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa4.bezeqint.net ([192.115.104.18]:49085 "EHLO sa4.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbXKHNy3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Nov 2007 08:54:29 -0500
In-Reply-To: <20071108220324Y.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, pw@osc.edu, bhalevy@panasas.com

On Thu, Nov 08 2007 at 15:03 +0200, FUJITA Tomonori <tomof@acm.org> wrote:
> On Thu, 08 Nov 2007 11:24:36 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>>>> index 18343a6..28cf6fe 100644
>>>> --- a/drivers/scsi/sd.c
>>>> +++ b/drivers/scsi/sd.c
>>>> @@ -448,9 +448,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
>>>>  	} else if (rq_data_dir(rq) == READ) {
>>>>  		SCpnt->cmnd[0] = READ_6;
>>>>  		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
>>>> -	} else {
>>>> -		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n", rq->cmd_flags);
>>>> -		goto out;
>>> This should go to the bidi patch?
>>>
>>>>  	}
>>>>  
>> This is just a dead code cleanup. It is got nothing to do with bidi or scsi_data_buffer
>> for that matter. It could be in it's own patch, but surly it will not go into the bidi
>> patch. I will submit a new patch just for that code. Independent of these.
>> (I was hoping to save the extra effort)
> 
> Hm, is it dead code? I think it's kinda BUG_ON, that is, we should not
> hit that code. sd only accetps READ and WRITE requests. It prevents
> funcy requests like BIDI from accidentally comming.
It is dead code. The rq_data_dir(rq) does a (->flags & 0x1) inline
the compiler will remove the extra code.

Also with bidi rq_data_dir(rq) is decided to return WRITE, a bidi
request is blk_bidi_rq(rq).

(I have separated this to a patch of it's own.)

Boaz
