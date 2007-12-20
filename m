From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/5] sg_ring for scsi
Date: Thu, 20 Dec 2007 15:55:09 +0200
Message-ID: <476A743D.2080506@panasas.com>
References: <200712201645.19035.rusty@rustcorp.com.au> <20071220160741K.fujita.tomonori@lab.ntt.co.jp> <200712201853.48643.rusty@rustcorp.com.au> <20071220075814.GH13958@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:34273 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbXLTN5K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Dec 2007 08:57:10 -0500
In-Reply-To: <20071220075814.GH13958@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dougg@torque.net

On Thu, Dec 20 2007 at 9:58 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, Dec 20 2007, Rusty Russell wrote:
>> On Thursday 20 December 2007 18:07:41 FUJITA Tomonori wrote:
>>> On Thu, 20 Dec 2007 16:45:18 +1100
>>>
>>> Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>> OK, some fixes since last time, as I wade through more SCSI drivers. 
>>>> Some drivers use "use_sg" as a flag to know whether the request_buffer is
>>>> a scatterlist: I don't need the counter, but I still need the flag, so I
>>>> fixed that in a more intuitive way (an explicit ->sg pointer in the cmd).
>>> use_sg and the request_buffer will be removed shortly.
>>>
>>> http://marc.info/?l=linux-scsi&m=119754650614813&w=2
>> Thanks!  Is there a git tree somewhere with these changes?
>>
>>> I think that we tried the similar idea before, scsi_sgtable, but we
>>> seem to settle in the current simple approach.
>> Yes, a scsi-specific solution is a bad idea: other people use sg.  
>> Manipulating the magic chains is horrible; it looks simple to the places 
>> which simply want to iterate through it, but it's awful for code which wants 
>> to create them.
> 
> The current code looks like that to minimize impact on 2.6.24, see this
> branch:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=sg
> 
> for how it folds into lib/sg.c and the magic disappears from SCSI.
> Rusty, nobody claimed the sg code in 2.6.24 is perfect. I like to get
> things incrementally there.
> 
Dear Jens.

Is this code scheduled for 2.6.25? I cannot find it in mm tree.

Because above code conflicts with the scsi_data_buffer patch,
that is in mm tree and I hope will get accepted into 2.6.25.
Now the concepts are not at all conflicting, only that they
both bang in the same places.
(And by the way it does not apply on scsi-misc either.
And it did not compile in your tree, a missing bit in 
ide-scsi.c)

I have rebase and fixed your code on top of scsi_data_buffer patchset.
Please review. (Patchset posted as reply to this mail)

They are totaly untested, based on -mm tree.
We should decide the order of these patches and rebase
accordingly.

AND ...
Please send, to-be-included-in-next-kernel patches to Morton. 
This way we can account for them. Also I do not see Ack-by: 
of the scsi maintainer in the scsi bits of your patches.
Is it not a costume to Ack-on bits that belong to other maintainers, 
even for maintainers?

Boaz
