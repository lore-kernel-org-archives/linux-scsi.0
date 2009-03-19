From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCHSET  0/2] Don't let blk_put_request leak BIOs
Date: Thu, 19 Mar 2009 16:18:19 +0200
Message-ID: <49C2542B.70604@panasas.com>
References: <49C21C5A.6030105@panasas.com> <20090319113343.GF27476@kernel.dk> <49C24B55.3040609@panasas.com> <20090319134500.GO27476@kernel.dk> <49C24D1E.6000105@panasas.com> <20090319135630.GP27476@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:6889 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754609AbZCSOTe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 10:19:34 -0400
In-Reply-To: <20090319135630.GP27476@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Jens Axboe wrote:
> On Thu, Mar 19 2009, Boaz Harrosh wrote:
>> Jens Axboe wrote:
>>> On Thu, Mar 19 2009, Boaz Harrosh wrote:
>>>> Jens Axboe wrote:
>>>>> On Thu, Mar 19 2009, Boaz Harrosh wrote:
>>>>>> Hi Jens
>>>>>>
>>>>>> You never commented on these patches. Please have a look?
>>>>>>
>>>>>> The issue is that if we map some memory into a request but then
>>>>>> do not execute it. Then calling blk_put_request() will leak the bio(s)
>>>>>> unless one does an ugly code like:
>>>>>> -	struct bio *bio;
>>>>>> -
>>>>>> -	while ((bio = rq->bio) != NULL) {
>>>>>> -		rq->bio = bio->bi_next;
>>>>>> -		bio_endio(bio, 0);
>>>>>> -	}
>>>> This is the code I have today in osd_initiator.c (In scsi-misc tree)
>>>>
>>>>> Sorry, I think this is a horrible design. blk_put_request() doesn't care
>>>>> about any data attachments, in fact (if possible) it should go BUG() if
>>>>> the request hasn't been completed in some way or other. It deals with
>>>>> the deallocation part, blk_get_request() doesn't attach any data. The
>>>>> end result with code like the above is an assymmetric API.
>>>>>
>>>>>> This problem arise in OSD when we can fail to setup the write
>>>>>> or the read side and then we must cleanup the other half.
>>>>>> Same problem exist in bsg, on bidi commands. But there the bio
>>>>>> is just leaked on the error path, it does not do the ugly loop above.
>>>>> These drivers should just be fixed, then.
>>>>>
>>>>> So if you have spotted this problem in eg bsg, then please send a patch
>>>>> for that to Tomo!
>>>>>
>>>> Then the above code taken from today's osd_initiator is good? People where
>>>> complaining that it is not good, because it is messing up with internal
>>>> block structures.
>>>>
>>>> What about just exporting an blk_rq_abort(struct request *req) that is
>>>> the same as PATCH 1/2. But is not called from blk_put_request ?
>>> Well no, the approach isn't that good either. How did you map these
>>> request? Most logical API would have something to unmap them again.
>>>
>> I'm not sure I understand.
>> I use a combination of map functions to build a complex bio. But more
>> specifically I do not want to use any unmap function because I do not
>> want to call the end_bio() function I want to not allow any bouncing
>> unmapping or hooking to occur. "Abort" is the only write name for it.
> 
> I'm not sure I understand what you are saying here either. So if you
> build these bios up manually, then you will need to tear them down
> manually as well.
> 
> Doing panic style cleanup at blk_put_request() time is definitely not
> the right approach. And you can't just export a blk_rq_abort() type
> functionality, since you don't don't know what you are trying to abort.
> You assume that bio_endio() will always do the right thing, that may not
> be enough. Hence you need the caller to cleanup after themselves.
> 

So current (above) code in osd_initiator.c is correct and should stay
as it is? that's fine by me.

Thanks for you consideration
Boaz


