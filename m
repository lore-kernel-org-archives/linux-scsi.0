From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [Suspected SPAM] Re: [Suspected SPAM] Re: [PATCH] fc-transport: BSG clean-up changes for normal and timeout completions (scsi-post-merge tree)
Date: Thu, 18 Jun 2009 17:36:11 -0700
Message-ID: <89F7BA77-707C-4842-8352-EFFF60F92605@qlogic.com>
References: <9A4AF066-850F-4EC0-A4A7-9850C73632E4@qlogic.com> <20090618093311K.fujita.tomonori@lab.ntt.co.jp> <58607277-D587-4B56-AB2F-361B486FAEBC@qlogic.com> <20090619082733Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:28819 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZFSAgL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2009 20:36:11 -0400
In-Reply-To: <20090619082733Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "James.Smart@Emulex.Com" <James.Smart@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>


On Jun 18, 2009, at 4:27 PM, FUJITA Tomonori wrote:

> On Thu, 18 Jun 2009 12:05:24 -0700
> Giridhar Malavali <giridhar.malavali@qlogic.com> wrote:
>
>>>> /**
>>>>  * fc_bsg_job_timeout - handler for when a bsg request timesout
>>>>  * @req:	request that timed out
>>>> @@ -3471,19 +3479,10 @@ fc_bsg_job_timeout(struct request *req)
>>>> 				"abort failed with status %d\n", err);
>>>> 	}
>>>>
>>>> -	if (!done) {
>>>> -		spin_lock_irqsave(&job->job_lock, flags);
>>>> -		job->ref_cnt--;
>>>> -		spin_unlock_irqrestore(&job->job_lock, flags);
>>>> -		fc_destroy_bsgjob(job);
>>>> -	}
>>>> -
>>>> 	/* the blk_end_sync_io() doesn't check the error */
>>>> 	return BLK_EH_HANDLED;
>>>
>>> I think that you need to return a proper value here; see my previous
>>> patch. If a job is done, we need to return BLK_EH_NOT_HANDLED here;
>>> otherwise the block layer calls __blk_complete_request for the job
>>> (and later we call blk_complete_request for the same job).
>>>
>>> The rest looks fine by me.
>>
>> static void blk_rq_timed_out(struct request *req)
>> {
>>         struct request_queue *q = req->q;
>>         enum blk_eh_timer_return ret;
>>
>>         ret = q->rq_timed_out_fn(req);
>>         switch (ret) {
>>         case BLK_EH_HANDLED:
>>                 __blk_complete_request(req);
>>                 break;
>>         case BLK_EH_RESET_TIMER:
>>                 blk_clear_rq_complete(req);
>>                 blk_add_timer(req);
>>                 break;
>>         case BLK_EH_NOT_HANDLED:
>>                 /*
>>                  * LLD handles this for now but in the future
>>                  * we can send a request msg to abort the command
>>                  * and we can move more of the generic scsi eh code  
>> to
>>                  * the blk layer.
>>                  */
>>                 break;
>>
>> 	As per this code, the completion routine will be called only if we
>> return BLK_EH_HANDLED from fc transport.
>
> Correct.
>
>
>> In our case the abort of the
>> timed out request
>> has been completed and handled. That's the reason I returned
>> BLK_EH_HANDLED always.
>
> Hmm, if the 'done' is not zero in fc_bsg_job_timeout, the request
> should not be aborted or completed?
>
> I mean that if (job->state_flags & FC_RQST_STATE_DONE) is true, the
> low level driver handler (such as zfcp_fc_generic_els_handler) is
> performing the request. So fc_bsg_job_timeout() can't abort or
> complete that request. fc_bsg_job_timeout() needs to ignore the
> request.

I agree, the code has to be changed to
if (done)
	return BLK_EH_NOT_HANDLED;
else
	return BLK_EH_HANDLED;


- Giridhar.M.B

>
>
>> 	In case of returning BLK_EH_NOT_HANDLED when does the bsg job
>> completion happens? I did see that by returning BLK_EH_NOT_HANDLED  
>> the
>> application never got response back.
>
> The low level driver handler will call job->job_done later.

