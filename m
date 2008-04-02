From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [9/20] Add blk_kmalloc/blk_alloc_pages
Date: Wed, 02 Apr 2008 14:32:10 +0300
Message-ID: <47F36EBA.3040207@panasas.com>
References: <20080317213422.GA11966@one.firstfloor.org>	<20080402123727B.tomof@acm.org>	<47F34729.6060608@panasas.com> <20080402200815I.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:59345 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYDBLcr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 07:32:47 -0400
In-Reply-To: <20080402200815I.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, tomof@acm.org

FUJITA Tomonori wrote:
> On Wed, 02 Apr 2008 11:43:21 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> On Wed, Apr 02 2008 at 6:37 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>> On Mon, 17 Mar 2008 22:34:22 +0100
>>> Andi Kleen <andi@firstfloor.org> wrote:
>>>
>>>>> Look further down in the email, queue_bounce_to_mask() or whatever you
>>>>> would want to call it. As also written there, the PRINCIPLE is the same.
>>>>> And that is that exporting a to_allocator_mask() helper is a lot saner
>>>>> than exporting an allocator api tied to the queue.
>>>>>
>>>>> Can we get over this, please?
>>>> Ok it would have helped if you had explained why it is saner, but I 
>>>> bow to your superior experience on block layer issues.
>>>>
>>>> The only open issue is right now if it isn't better to go back
>>>> for automatic bouncing for SCSI scan and the other users. Do you
>>>> have an opinion on that too? If you have one can you please convince
>>>> James of it too.
>>> There are other things that don't want the automatic bouncing; sg, st,
>>> and osst.
>>>
>>> Your patches remove unchecked_isa_dma in them and Boaz said that they
>>> are fine since they get bounced anyway, however, it's not correct.
>>>
>>> As Doug said in another thread (about your patch to change GFP_ATOMIC
>>> to GFP_KERNEL in sg), they try to avoid waiting for a long time and
>>> want an early failure (though they are not complete; can't avoid non
>>> unchecked_isa_dma bouncing) .
>>>
>>> We can change the bounce path in that way, but I think it's better if
>>> they can allocate memory that will not get bounced.
>> I was looking in blk_queue_bounce (in mm/bounce.c) and have not seen any
>> case of q->bounce_gfp with __GFP_WAIT. Are you sure we are waiting for
>> the bounce buffers? It will take few more CPU cycles, but I don't see
>> where it will sleep.
> 
> Hmm, q->bounce_gfp is GFP_NOIO or (GFP_NOIO | __GFP_DMA). And
> __blk_queue_bounce also allocates bio with GFP_NOIO. So the bounce
> path always use __GFP_WAIT.

OK, Thanks, GFP_NOIO is __GFP_WAIT I didn't realize that.
Any way in my new patchset we do not use bouncing and we use
the new mask allocator so every one should be happy.

Boaz

