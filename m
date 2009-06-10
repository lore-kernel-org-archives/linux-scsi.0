From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Revert "block: WARN in __blk_put_request() for potential
 bio leak"
Date: Wed, 10 Jun 2009 12:48:01 +0300
Message-ID: <4A2F8151.3010104@panasas.com>
References: <4A2F729A.1060101@panasas.com>	<20090610175238P.fujita.tomonori@lab.ntt.co.jp>	<4A2F7B0F.1030205@panasas.com> <20090610183618T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:9505
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750736AbZFJJsB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 05:48:01 -0400
In-Reply-To: <20090610183618T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On 06/10/2009 12:36 PM, FUJITA Tomonori wrote:
> On Wed, 10 Jun 2009 12:21:19 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> On 06/10/2009 11:52 AM, FUJITA Tomonori wrote:
>>> On Wed, 10 Jun 2009 11:45:14 +0300
>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>
>>>> The fact that ALL block drivers call it for proper service of ALL ULDS,
>>>> does it not make it a rule?
>>> BSG SMP code is not ULD.
>>>
>> BSG is certainly a ULD, Upper-Layer-Driver that can issue block commands
>> through block layer and block-queue.
>>
>> SMP is a block device class that has it's own LLDs.
>>
>> The way I understand
>>
>> |---------|      |--------------|      |-----------|
>> | ULD     |----->|  block layer |----->| block LLD |
>> |---------|      |--------------|      |-----------|
>>
>> So I meant block ULD or block layer user code. That is what I meant
>> by ULD, what do you mean?
> 
> To me, ULD means SCSI upper layer driver, which is documented.
> 
> Where can I find a document about your definition of Block ULD, block
> LLD, etc?
> 
> 
> To me, looks like there is a different place for you.
> 

Sorry then, My bad. I though ULD/LLD is just Upper/Lower drivers of any
sub-system.
If it is only used for SCSI, then sorry I will not use it for any thing else.

> BTW, if you try to find a bio leak in the BSG SMP path, I guess that
> it's worth looking at the bounce path. There might be a leak.

once a request was put on the queue, or even before that, once some
memory was mapped. blk_end_request must be called by someone.
More and more code relays on that. Not doing so is just plain playing
with fire. Will you not agree?

Boaz
