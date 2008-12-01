From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] block: integrate blk_end_bidi_request into blk_end_request
Date: Mon, 01 Dec 2008 11:42:48 +0200
Message-ID: <4933B198.7090309@panasas.com>
References: <20081128145221I.fujita.tomonori@lab.ntt.co.jp>	<493274A7.5050404@panasas.com> <20081201170000N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:23474 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750824AbYLAJmz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 04:42:55 -0500
In-Reply-To: <20081201170000N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

FUJITA Tomonori wrote:
> On Sun, 30 Nov 2008 13:10:31 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> FUJITA Tomonori wrote:
>>> Hi Jens,
>>>
>>> FC people have been working on FC pass thru feature using bsg bidi
>>> support. Seems that the bidi API confuse them:
>>>
>>> http://marc.info/?l=linux-scsi&m=122704347209856&w=2
>>>
>>> =
>>> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>>> [PATCH] block: integrate blk_end_bidi_request with blk_end_request
>>>
>>> This integrates blk_end_bidi_request into blk_end_request. IOW, it
>>> changes blk_end_request to handle both bidi and non-bidi requests and
>>> removes blk_end_bidi_request.
>>>
>>> Currently, we have two functions to complete a request,
>>> blk_end_bidi_request and blk_end_request. The former is for bidi
>>> requests and the latter is for non-bidi. This seems to confuse
>>> developers. Questions like "can blk_end_bidi_request be used with
>>> non-bidi requests?", "what should be passed as the bidi_bytes argument
>>> in blk_end_bidi_request" are often asked.
>>>
>>> The callers don't care about whether a request is bidi or not. All
>>> they want to do is to complete a request. I think that a single
>>> function that can complete any request would be easy to understand.
>>>
>>> We always must complete all bytes on both sides with bidi. So
>>> blk_end_request easily can do it for the callers and handle both both
>>> bidi and non-bidi requests.
>>>
>>>
>>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> NACK by Boaz Harrosh.
>>
>>> ---
>>>  block/blk-core.c        |   35 +++++++++++++----------------------
>>>  drivers/scsi/scsi_lib.c |    3 +--
>>>  include/linux/blkdev.h  |    2 --
>>>  3 files changed, 14 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index 10e8a64..634f918 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -1943,7 +1943,19 @@ static int blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
>>>   **/
>>>  int blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
>>>  {
>>> -	return blk_end_io(rq, error, nr_bytes, 0, NULL);
>>> + 	unsigned int bidi_bytes	= 0;
>>> +
>>> +	if (blk_bidi_rq(rq)) {
>>> +		struct bio *bio;
>>> +		/*
>>> +		 * We can't use rq->next_rq->data_len here because the
>>> +		 * callers might set it to a residual length.
>>> +		 */
>>> +		__rq_for_each_bio(bio, rq->next_rq)
>>> +			bidi_bytes += bio->bi_size;
>> No. I do not want a loop to calculate the size here. This is ugly.
>> I have this information, and I just lost it do to BAD API.
> 
> IMO, being ugly is better than confusing people.

Come on man. Ugly was an understatement. Can't you see?
Make a loop for information we have and decided to drop on the floor.

> 
> Do you think that the current API is good, which make developers
> always wrongly use it and feel that they have to ask how to use and
> add comments about necessary tricks to use it?
> 

No I think (and said) that the API is crap. But not that bad that I want to
take the effort and change it.

> 
>> Since we do not want to change all users of blk_end_request. (We should,
>> but we are too lazy. I'm). Then please just let blk_end_bidi_request()
>> be. Confused users will be corrected.
> 
> No. blk_end_bidi_request interface and the name is confusing. So
> forcing everyone to use blk_end_bidi_request doesn't help.
> 

We should rename blk_end_bidi_request => blk_end_request() and
change all users to add an extra 0, and the original blk_end_request()
should be dropped.

But since the big majority is uni and could careless, then the two
bidi drivers can take the extra effort and a bang on the head when
they get it wrong, just for the sake of the majority.

> And it's better to name a function to complete a request
> blk_end_request(). The callers doesn't care if a request is bidi or
> not.
> 

Right and the API for that is with 2 length(s) and even better with
2 residuals. But do you want to change all users for that?

> 
>> Perhaps we can put a comment above blk_end_bidi_request() that it can
>> be used for both bidi or uni commands, so users will confuse less.
> 
> I don't think that it's a good idea to make up the confusion.

And a loop is? better a comment then a loop any day in my book.
I don't mind changing the name though. perhaps:
	blk_end_bidi_request() => blk_complete_request()
So new users get tempted to use that and eventually blk_end_request()
will be dropped?

Boaz
