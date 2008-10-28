From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support via bsg
 interface - revised
Date: Tue, 28 Oct 2008 09:57:15 +0200
Message-ID: <4906C5DB.1010402@panasas.com>
References: <32C8BF3A-87D5-4F89-AF4B-7731548CCD4A@qlogic.com>	<20081024125449T.fujita.tomonori@lab.ntt.co.jp>	<49043A7C.8030105@panasas.com> <20081027131110Z.fujita.tomonori@lab.ntt.co.jp> <490579C5.5080102@panasas.com> <C411DA16-2D8D-4B06-91B4-EB2B2B1984E5@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:29717 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752673AbYJ1H5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2008 03:57:21 -0400
In-Reply-To: <C411DA16-2D8D-4B06-91B4-EB2B2B1984E5@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, James.Smart@Emulex.Com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, robert.w.love@intel.com

Seokmann Ju wrote:
> On Oct 27, 2008, at 1:20 AM, Boaz Harrosh wrote:
> 
>> FUJITA Tomonori wrote:
>>> On Sun, 26 Oct 2008 11:38:04 +0200
>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>
>>>> FUJITA Tomonori wrote:
>>>>> CC'ed Jens,
>>>>>
>>>>> On Wed, 22 Oct 2008 19:27:35 -0700
>>>>> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>>>>>
>>>>>> And it seems like that the panic is happening due to the fact that
>>>>>> blk_delete_timer() is not called upon having completion of the  
>>>>>> service.
>>>>>> In other words, the block layer calls blk_add_timer() prior to
>>>>>> dispatch the service but, it doesn't call blk_delete_timer()  
>>>>>> when it
>>>>>> returned.
>>>>> Yeah, we need to call blk_delete_timer somewhere.
>>>>>
>>>>>
>>>>>> Just for heck of it, I've tried out by adding blk_delete_timer()  
>>>>>> in
>>>>>> the ~/block/blk-exec.c:blk_end_sync_rq() and it seems fixes the  
>>>>>> problem.
>>>>> I think blk_end_sync_rq() is not the good place. From the  
>>>>> perspective
>>>>> of bsg, we need to handle both blk_execute_rq_nowait and
>>>>> blk_execute_rq.
>>>>>
>>>>>
>>>>>> Seems like that there are APIs in the block layer that are call  
>>>>>> the
>>>>>> blk_delete_timer(), including,
>>>>>> - blk_end_io()
>>>>>> - __blk_end_request()
>>>>>>
>>>>>> Could you guide me what is right way to fix the problem?
>>>>> Exporting blk_delete_timer is one option, but it doesn't look very
>>>>> nice (since the block layer doesn't export any details about its  
>>>>> timer
>>>>> infrastructure), I think. Modifying blk_end_io() to make it  
>>>>> usable for
>>>>> requests via something like bsg might be better.
>>>>>
>>>>> Anyway, we need to ask Jens.
>>>>>
>>>>> Jens, fc people have working on fc pass through support via bsg,  
>>>>> which
>>>>> hooks bsg's request queue on fc transport objects (We did the  
>>>>> similar
>>>>> thing for sas transport).
>>>>>
>>>>> We want the timeout feature for fc pass through and I think that  
>>>>> it's
>>>>> nice to use the block layer timeout feature for it. But the users  
>>>>> of
>>>>> bsg request queue don't need (or call) APIs such as
>>>>> end_that_request_last to call blk_delete_timer internally. How  
>>>>> should
>>>>> these users call blk_delete_timer?
>>>> TOMO Hi
>>>> If a command is queued by bsg to a scsi device, which is posible.  
>>>> Then
>>>> blk_end_request() is called by scsi-ml. So it does work.
>>> It doesn't work for bsg's scsi transport pass through stuff such as
>>> SMP (sas management protocol, we already support) and FC. Virtually,
>>> they don't use scsi-ml.
>>>
>> Right, I know that, that's why I say.
>>
>>>> I think that all block-queue consumers should call one of
>>>> blk_end_request(),
>>> This is kinda what I suggested in the previous mail but as I wrote,
>>> some of them don't now.
>>>
>> I think they should, specially if they're going to use the timer.
>> The way I see it they must. It's kind of a block layer API thing.
>> Someone calls blk_execute_xx then eventually someone needs to call
>> blk_end_request. You could call it from bsg but only temporary until
>> all are fixed. (because you will need an ugly check to see if request
>> was not already ended)
> I made following changes but, it seems not helpful for the issue.
> It, eventually, got failed to call blk_delete_timer() as ~/block/blk- 
> core.c:__end_that_request_first() returns non-zero.
> Inside of the __end_that_reqeust_first(), it detected 'nbytes' is  
> bigger than 'nr_bytes' in case of bidi (where req->next_rq is not NULL).
> I'm not sure whether we need to have chains of function calls  
> initiated by the blk_end_request() or blk_end_bidi_request().
> Would it create any problems if we directly call 'blk_delete_timer()'?
> 

Dear Seokmann. You miss understud me. What I'm saying is that you must
call blk_end_bidi_request at the FC end, just after you have finished
to consume the request, and before you return it upstream. it can be
some thing like:

+	blk_end_bidi_request(rq, 0, blk_rq_bytes(rq),
+	                     rq->next_rq ?  blk_rq_bytes(rq->next_rq) : 0);

In this case __end_that_reqeust_first should never return non-zero.

> Seokmann
> ---
> diff -Naurp a/blk-exec.c b/blk-exec.c
> --- a/blk-exec.c	2008-10-27 09:33:14.000000000 -0700
> +++ b/blk-exec.c	2008-10-27 09:34:08.000000000 -0700
> @@ -22,6 +22,13 @@ static void blk_end_sync_rq(struct reque
>   {
>   	struct completion *waiting = rq->end_io_data;
> 
> +	if (rq->next_rq) {
> +		blk_end_bidi_request(rq, error, rq->data_len,
> +		    rq->next_rq->data_len);
> +		// blk_end_request(rq);
> +		// blk_delete_timer(rq);
> +	}
> +
>   	rq->end_io_data = NULL;
>   	__blk_put_request(rq->q, rq);
> ---

Please don't change blk_end_sync_rq at blk-exec.c it is too
delicate here. At this stage rq->data_len is already holding
the residual count in most cases, and touching it would
be a bug

>>
>>>> there are lots to choose from. We don't need
>>>> a new API. It will work with or without data, and it does what
>>>> you want.
>> Boaz
> 

Do you have this code on a public git-web somewhere? I need
to look at the complete code, if you need that I advise you
where in the FC code to call blk_end_bidi_request()

Thanks
Boaz



