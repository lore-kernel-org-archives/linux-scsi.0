From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/4] block: use the same failfast bits for bio and request
Date: Thu, 09 Jul 2009 12:12:51 +0300
Message-ID: <4A55B493.6070402@panasas.com>
References: <1246610898-22350-1-git-send-email-tj@kernel.org> <1246610898-22350-3-git-send-email-tj@kernel.org> <4A5071E5.8030908@panasas.com> <4A553DA4.4080408@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:15269
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756084AbZGIJM7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2009 05:12:59 -0400
In-Reply-To: <4A553DA4.4080408@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Niel Lambrechts <niel.lambrechts@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>

On 07/09/2009 03:45 AM, Tejun Heo wrote:
> Hello, Boaz.
> 
> Boaz Harrosh wrote:
>> Thanks for doing this, it has been neglected for a long time.
>> However, it will happen again, I don't like these implicit matches
>> which are not enforced, They get to drift away. There are several ways
>> to make sure two sets of enums stay in sync. (I'll have a try at it
>> tomorrow. if you want). 
> 
> They don't share the exact same set of bits, so it's a bit blurry but
> yeah it would be better if the bits are defined in more systematic
> way.
> 

I meant something simple like:

	__REQ_RW = BIO_RW,
	__REQ_FAILFAST_DEV = BIO_RW_FAILFAST_DEV,
	__REQ_FAILFAST_TRANSPORT = BIO_RW_FAILFAST_TRANSPORT,
	__REQ_FAILFAST_DRIVER = BIO_RW_FAILFAST_DRIVER,
	...

And a fat comment which you did

>>> @@ -142,37 +142,40 @@ struct bio {
>>>   *
>>>   * bit 0 -- data direction
>>>   *	If not set, bio is a read from device. If set, it's a write to device.
>>> - * bit 1 -- rw-ahead when set
>>> - * bit 2 -- barrier
>>> + * bit 1 -- fail fast device errors
>>> + * bit 2 -- fail fast transport errors
>>> + * bit 3 -- fail fast driver errors
>>> + * bit 4 -- rw-ahead when set
>>> + * bit 5 -- barrier
>> Please kill all these evil bit 1, bit 2 ,bit n comments. The ways we
>> invent to torture ourselfs...
>>
>> Just move all the comments to the enums declarations below. And be done
>> with it, also for the next time.
> 
> Heh... I agree too.  Unless ABI is fixed, this type of comments are
> often painful.  Care to submit a patch.  This series is already in
> block#for-next.
> 

It's becoming futile to comments on patches these days they get submitted
before and during any comments. ;-)

>>>  #define bio_rw_flagged(bio, flag)	((bio)->bi_rw & (1 << (flag)))
>>>  
>> I wish there was also an helper to set these bits. it gives me an heart attack
>> every time I need to:
>> 	bio->bi_rw &= ~(1 << BIO_RW);
> 
> What's more disturbing to me is the different between RQ and BIO
> flags.  __REQ_* are bit positions, REQ_* are masks while BIO_* are bit
> positions.  Sadly it seems it's already too late to change that.  I
> personally an not a big fan of simple accessors or flags defined as
> bit positions.  They seem to obscure things without much benefit.
> 

I think that everywhere we should use __set_bit() __clear_bit() and
test_bit() with enums defined as bit-positions. It is most clear readable
code wise, least error prone, and easiest to maintain.
Perhaps a new:
	test_bits(void *flag, unsigned bit1, ...);
for testing bunch of bits at once

Please note that with inlines and constant bits the generated code is
just as fast as bit-mask. Without slaving over double definitions.
(and accessors)

> Thanks.
> 

Boaz
