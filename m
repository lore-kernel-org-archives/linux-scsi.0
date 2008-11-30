From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] FC pass thru - Rev IV
Date: Sun, 30 Nov 2008 12:56:28 +0200
Message-ID: <4932715C.7050907@panasas.com>
References: <492E6143.2080407@panasas.com>	<20081127185406L.fujita.tomonori@lab.ntt.co.jp>	<492E89D7.1020502@panasas.com> <20081128105248K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:21102 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751428AbYK3K4d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 05:56:33 -0500
In-Reply-To: <20081128105248K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, seokmann.ju@qlogic.com, andrew.vasquez@qlogic.com, sven@linux.vnet.ibm.com

FUJITA Tomonori wrote:
> On Thu, 27 Nov 2008 13:51:51 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>>>>> +	spin_lock_irqsave(&job->job_lock, flags);
>>>>>> +	job->state_flags |= FC_RQST_STATE_DONE;
>>>>>> +	job->ref_cnt--;
>>>>>> +	spin_unlock_irqrestore(&job->job_lock, flags);
>>>>>> +
>>>>>> +	err = job->req->errors = job->reply->result;
>>>>>> +	if (err < 0)
>>>>>> +		/* we're only returning the result field in the reply */
>>>>>> +		job->req->sense_len = sizeof(uint32_t);
>>>>>> +	else
>>>>>> +		job->req->sense_len = job->reply_len;
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * we'll cheat: tell blk layer all of the xmt data was sent.
>>>>>> +	 * but try to be honest about the amount of rcv data received
>>>>>> +	 */
>>>>>> +	if (rsp)
>>>>>> +		blk_end_bidi_request(job->req, err, blk_rq_bytes(job->req),
>>>>>> +	    			     job->reply->reply_payload_rcv_len);
>>>>>> +	else
>>>>>> +		blk_end_request(job->req, err, blk_rq_bytes(job->req));
>>>>> I think that you can use blk_end_bidi_request() for non-bidi requests:
>>>>>
>>>>> 	blk_end_bidi_request(job->req, err, blk_rq_bytes(job->req),
>>>>> 			rsp ?
>>>>> 			 job->reply->reply_payload_rcv_len : 0);
>>>>>
>>>>>
>>>>> I guess that it would be better to have one function to complete a
>>>>> request, instead of blk_end_bidi_request and blk_end_request.
>>>>>
>>>>>
>>>> +	/*
>>>> +	 * tell blk layer all of the xmt data was sent.
>>>> +	 * but set residual count to: requested - received
>>>> +	 */
>>>> +
>>>> +	if (rsp) {
>>>> +		bytes_requested = blk_rq_bytes(rsp);
>>>> +		rsp->data_len = bytes_requested - job->reply->reply_payload_rcv_len;
>>>> +	}
>>>> +
>>>> +	blk_end_bidi_request(job->req, err, blk_rq_bytes(job->req), bytes_requested);
>>>>
>>>> The residual count is left in req->data_len. Does bsg have a way to return the
>>>> residual to user-mode? It must, since Pete was using that for sure. Note that
>>>> you are looking for the bidi_read residual count.
>>> Yeah, bsg has. struct sg_io_v4 has:
>>>
>>> __s32 din_resid;	/* [o] din_xfer_len - actual_din_xfer_len */
>>> __s32 dout_resid;	/* [o] dout_xfer_len - actual_dout_xfer_len */
>>>
>>>
>>>> As was said by people. You must complete ALL bytes on both sides. Residual information
>>>> is passed through req->data_len. Other wise the request is still active.
>>>>
>>>> (And yes blk_end_request uses blk_end_bidi_request internally)
>>> We always complete all bytes on both sides. So why we do something
>>> like:
>>>
>>> int blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
>>> {
>>> 	unsigned int bidi_bytes	= 0;
>>>
>>> 	if (blk_bidi_rq(rq))
>>> 		bidi_bytes = req->next_rq->data_len;
>>>
>>> 	return blk_end_io(rq, error, nr_bytes, bidi_bytes, NULL);
>>> }
>>>
>>> The callers can do something like:
>>>
>>> blk_end_request(rq, err, rq->data_len);
>>> rq-->next_rq->data_len = resid;
>> Sorry TOMO, I do not understand what you mean. Do you say that we should
>> change blk_end_request() in blk-core.c ?
> 
> Having two kinds of functions (blk_end_request and
> blk_end_bidi_request) to complete requests confuse people. As we saw,
> developers tend to do something like this:
> 
> +	if (rsp)
> +		blk_end_bidi_request(job->req, err, blk_rq_bytes(job->req),
> +	    			     job->reply->reply_payload_rcv_len);
> +	else
> +		blk_end_request(job->req, err, blk_rq_bytes(job->req));
> 
> 
> The callers don't care about whether a request is bidi or not. It's be
> simpler to have a single function to complete a request (whether a
> request is bidi or not) rather than having two different functions.
> 
> We must complete all bytes on both sides with a bidi request. So why
> can't we modify blk_end_request to handle both bidi and non-bidi
> requests:
> 
> int blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
> {
>  	unsigned int bidi_bytes	= 0;
> 
> 	if (blk_bidi_rq(rq))
> 		bidi_bytes = blk_rq_bytes(rq->next_rq);
> 
> 	return blk_end_io(rq, error, nr_bytes, bidi_bytes, NULL);
> }
> 
> 
>> In anyway, the code you suggest has a bug you can not use rq-> after call to blk_end_io()
>> because it might not exist at this point. You must set residual before. And also
> 
> What is 'rq->' exactly?
> 
> We must set residual before calling blk_end_request? Really?
> 
> Note that scsi-ml and bsg (blk_execute_rq) work differently. For
> scsi-ml, blk_end_io frees request structure (end_that_request_last)
> but for blk_execute_rq, it doesn't.
> 

It does not matter if bsg or any other user has an extra reference
on the request (so end_that_request_last does not deallocate the
request). The end_io function is called from within the end_that_request_last
so setting the residual into req->data_len will be to late.

> 
> Anyway, it's fine to set bidi_resid before blk_end_request, I
> guess. FC pass thru code could do something like this if we modify
> blk_end_request in the above way:
> 
> /* we calculate bidi_resid here */
> 
> if (blk_bidi_rq(req))
> 	req->next_rq->data_len = bidi_resid;
> 

No that will not work. You lost the req->next_rq->data_len byte-count
and blk_end_request() will not be able to complete all bytes of req->next_rq.

Please see scsi_end_bidi_request() for the only way to complete a bidi
request with returned residual count on both sides.

> blk_end_request(req, 0, blk_rq_bytes(req));

The way blk_end_request() is now it cannot complete bidi requests.
because of residual count missing. I have shown above the only way
that you can complete both bidi or uni request with a single call to
blk_end_bidi_request(). If you want people not to get confused it is
blk_end_request() that should be dropped.

Boaz

