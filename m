From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support via bsg
 interface - revised
Date: Tue, 28 Oct 2008 16:38:32 +0200
Message-ID: <490723E8.9050801@panasas.com>
References: <32C8BF3A-87D5-4F89-AF4B-7731548CCD4A@qlogic.com>	<20081024125449T.fujita.tomonori@lab.ntt.co.jp>	<49043A7C.8030105@panasas.com> <20081027131110Z.fujita.tomonori@lab.ntt.co.jp> <490579C5.5080102@panasas.com> <C411DA16-2D8D-4B06-91B4-EB2B2B1984E5@qlogic.com> <4906C5DB.1010402@panasas.com> <EE6A1268-D18E-497E-AF5F-FF78F4A837E4@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:6835 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752134AbYJ1Oiq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2008 10:38:46 -0400
In-Reply-To: <EE6A1268-D18E-497E-AF5F-FF78F4A837E4@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, James.Smart@Emulex.Com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, robert.w.love@intel.com

Seokmann Ju wrote:
> On Oct 28, 2008, at 12:57 AM, Boaz Harrosh wrote:
> 
>> Seokmann Ju wrote:
>>> On Oct 27, 2008, at 1:20 AM, Boaz Harrosh wrote:
>>>
>>>> FUJITA Tomonori wrote:
>>>>> On Sun, 26 Oct 2008 11:38:04 +0200
>>>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>>>
>>>>>> FUJITA Tomonori wrote:
>>>>>>> CC'ed Jens,
>>>>>> I think that all block-queue consumers should call one of
>>>>>> blk_end_request(),
>>>>> This is kinda what I suggested in the previous mail but as I wrote,
>>>>> some of them don't now.
>>>>>
>>>> I think they should, specially if they're going to use the timer.
>>>> The way I see it they must. It's kind of a block layer API thing.
>>>> Someone calls blk_execute_xx then eventually someone needs to call
>>>> blk_end_request. You could call it from bsg but only temporary until
>>>> all are fixed. (because you will need an ugly check to see if  
>>>> request
>>>> was not already ended)
>>> I made following changes but, it seems not helpful for the issue.
>>> It, eventually, got failed to call blk_delete_timer() as ~/block/blk-
>>> core.c:__end_that_request_first() returns non-zero.
>>> Inside of the __end_that_reqeust_first(), it detected 'nbytes' is
>>> bigger than 'nr_bytes' in case of bidi (where req->next_rq is not  
>>> NULL).
>>> I'm not sure whether we need to have chains of function calls
>>> initiated by the blk_end_request() or blk_end_bidi_request().
>>> Would it create any problems if we directly call  
>>> 'blk_delete_timer()'?
>>>
>> Dear Seokmann. You miss understud me. What I'm saying is that you must
>> call blk_end_bidi_request at the FC end, just after you have finished
>> to consume the request, and before you return it upstream. it can be
>> some thing like:
>>
>> +	blk_end_bidi_request(rq, 0, blk_rq_bytes(rq),
>> +	                     rq->next_rq ?  blk_rq_bytes(rq->next_rq) : 0);
>>
>> In this case __end_that_reqeust_first should never return non-zero.
> Hello Boaz,
> Thank you for the clarification.
> I made the changes accordingly and tested it, but the problem is still
> there - same result of getting non-zero returns from
> __end_that_request_first().
> I guess that, either, I still get confused about the location or, there
> is something else going on...
> 
> Sorry, I don't have public git-web.
> Here is snaptshot of the FC transport layer changes.
> The fc_service_done() is the callback that the FC transport layer
> provides. And that is the callback called by LLD before returning.
> 
> Please let me know for any comments.
> 
> Thank you,
> Seokmann

if the attached file is the code you tested then it is wrong look here:

> +
> +	if (service->srv_reply.residual) {
> +		service->req->data_len = 0;
> +		service->req->next_rq->data_len = service->srv_reply.residual;
> +	} else {
> +		service->req->data_len = 0;
> +		service->req->next_rq->data_len = 0;
> +	}
> +

Move above to after the blk_end_bidi_request call

> +	blk_end_bidi_request(service->req, 0, blk_rq_bytes(service->req),
> +	    service->req->next_rq ? blk_rq_bytes(service->req->next_rq) : 0);

You must call blk_end_bidi_request before you change service->req->data_len
to hold the residual (or 0). Otherwise you damage the request.

> +	service->req->end_io(service->req, 0);
> +	kfree(service->payload_dma);
> +	kfree(service->response_dma);
> +	kfree(service);

With bsg the request is held by one more reference count in bsg, but in
general after the call to blk_end_bidi_request one/both request(s) may
die. In that case you need a code like:

	unsigned int dlen = blk_rq_bytes(req);
	unsigned int next_dlen = req->next_rq ? blk_rq_bytes(req->next_rq) : 0;

	req->data_len = resid;
	if (req->next_rq)
		req->next_rq->data_len = bidi_resid;

	/* The req and req->next_rq have not been completed */
	BUG_ON(blk_end_bidi_request(req, 0, dlen, next_dlen));

Boaz
 
