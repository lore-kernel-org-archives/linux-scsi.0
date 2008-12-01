From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] block: integrate blk_end_bidi_request into blk_end_request
Date: Mon, 01 Dec 2008 12:42:53 +0200
Message-ID: <4933BFAD.6060605@panasas.com>
References: <4933B198.7090309@panasas.com>	<20081201185955R.fujita.tomonori@lab.ntt.co.jp>	<4933BA1D.6090800@panasas.com> <20081201192610B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:31588 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYLAKnB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 05:43:01 -0500
Received: by ug-out-1314.google.com with SMTP id 39so2612265ugf.37
        for <linux-scsi@vger.kernel.org>; Mon, 01 Dec 2008 02:42:59 -0800 (PST)
In-Reply-To: <20081201192610B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

FUJITA Tomonori wrote:
> On Mon, 01 Dec 2008 12:19:09 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> FUJITA Tomonori wrote:
>>> On Mon, 01 Dec 2008 11:42:48 +0200
>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>
>>>>>> No. I do not want a loop to calculate the size here. This is ugly.
>>>>>> I have this information, and I just lost it do to BAD API.
>>>>> IMO, being ugly is better than confusing people.
>>>> Come on man. Ugly was an understatement. Can't you see?
>>>> Make a loop for information we have and decided to drop on the floor.
>>> Honestly, I can't see. Whatever you call the patch, the current API is
>>> worse than it for me.
>>>
>>>
>>>>> Do you think that the current API is good, which make developers
>>>>> always wrongly use it and feel that they have to ask how to use and
>>>>> add comments about necessary tricks to use it?
>>>>>
>>>> No I think (and said) that the API is crap. But not that bad that I want to
>>>> take the effort and change it.
>>>>
>>>>>> Since we do not want to change all users of blk_end_request. (We should,
>>>>>> but we are too lazy. I'm). Then please just let blk_end_bidi_request()
>>>>>> be. Confused users will be corrected.
>>>>> No. blk_end_bidi_request interface and the name is confusing. So
>>>>> forcing everyone to use blk_end_bidi_request doesn't help.
>>>>>
>>>> We should rename blk_end_bidi_request => blk_end_request() and
>>>> change all users to add an extra 0, and the original blk_end_request()
>>>> should be dropped.
>>> That might be better than the current situation but why do we need
>>> bidi_bytes (number of bytes to complete for bidi) in blk_end_request?
>>>
>>> Having bidi_bytes is theoretically correct but we always must complete
>>> all the bytes with bidi. Do you say that someone might need it in the
>>> future?
>> I will try to explain. The situation was bad for a long time. Not at
>> all because of the amount of bytes to complete but because of the residual
>> count. Look at current code that wants to return residual. It needs to save
>> on the side what ever was there in req->data_len then set req->data_len
>> to residual and call blk_end_request with the saved count. Now the thing
>> became worse because we have two of these.
>>
>> Yes sure I want to complete both sides and I don't mind calling
>> blk_end_io( req, error, ~0U, ~0U, ...) so lets make a compromise
>> in your patch, don't loop on the bio's just set bidi_bytes = ~0U;
>> that is:
>>
>>  int blk_end_request(struct request *rq, int error, unsigned int nr_bytes)
>>  {
>> -	return blk_end_io(rq, error, nr_bytes, 0, NULL);
>> + 	unsigned int bidi_bytes	= 0;
>> +
>> +	if (blk_bidi_rq(rq)) 
>> +		bidi_bytes = ~0U;
>> +
>> +	return blk_end_io(rq, error, nr_bytes, bidi_bytes, NULL);
>>  }
>>  EXPORT_SYMBOL_GPL(blk_end_request);
> 
> Well, I also thought about the exact same approach.
> 
> I guess that this taints part_stat_add() in
> __end_that_request_first()? Well, bidi is not fs requests for now (or
> forever?) so the patch should be fine now.

Thanks TOMO. I appreciate this very much.

Boaz
