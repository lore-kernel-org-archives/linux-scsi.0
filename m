From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 17 May 2007 11:46:48 +0300
Message-ID: <464C1678.2090608@panasas.com>
References: <20070508112553C.fujita.tomonori@lab.ntt.co.jp> <4640C724.8030409@panasas.com> <1178654497.3737.81.camel@mulgrave.il.steeleye.com> <46417C5A.1090707@panasas.com> <464B3F91.1010102@panasas.com> <20070516175322.GS23798@kernel.dk> <1179338812.9602.4.camel@mulgrave.il.steeleye.com> <20070516181325.GT23798@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:37180 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753875AbXEQIvg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 04:51:36 -0400
In-Reply-To: <20070516181325.GT23798@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

Jens Axboe wrote:
> On Wed, May 16 2007, James Bottomley wrote:
>> On Wed, 2007-05-16 at 19:53 +0200, Jens Axboe wrote:
>>> The 1-page thing isn't a restriction as such, it's just an optimization.
>>> The scatterlist allocated is purely a kernel entity, so you could do 4
>>> contig pages and larger ios that way, if higher order allocations were
>>> reliable.
>>>
>>> But you are right in that we need to tweak the sg pool size so that it
>>> ends up being a nice size, and not something that either spans a little
>>> bit into a second page or doesn't fill a page nicely. On my x86-64 here,
>>> a 128 segment sg table is exactly one page (looking at slabinfo). It
>>> depends on the allocator whether that is just right, or just a little
>>> too much due to management information.
>> Actually, if you look at the slab allocation algorithm (particularly
>> calculate_slab_order()) you'll find it's not as simplistic as you're
>> assuming ... what it actually does is try to allocate > 1 item in n
>> pages to reduce the leftovers.
> 
> I'm not assuming anything, I was just being weary of having elements
> that are exactly page sized if that would cause a bit of spill into a
> second page. Don't tell me that PAGE_SIZE+10 (or whatever it might be)
> would ever be an optimal allocation size.
> 
>> Additionally, remember that turning on redzoning, which seems to be
>> quite popular nowadays, actually blows out the slab size calculations
>> anyway.
> 
> Debugging will always throw these things out the window, we can't and
> should not optimize for that. That goes for slab, and for lots of other
> things.
> 
>> The bottom line is that it's better for us just to do exactly what we
>> need and let the allocation algorithms figure out how to do it
>> efficiently rather than trying to second guess them.
> 
> Partly true, it's also silly to just hardcore power-of-2 numbers without
> ever bothering to look at what that results in (or even if it fits
> normal use patterns).
> 
> We can easily be flexible, so it seems silly not to at least do a bit of
> background research.
> 
The thing is that now every thing fits like a glove. i386/32bit-arch
have 16 bytes scatterlist struct, 256 in a page. x86_64/64bit-arch 32
byte and 128 fit exactly in a page. If we do any code that throws this
off it will be a performance regression. Call it beginners luck, call
it someone spent a long night handcrafting it this way. Just that I
think the current system is perfect and we should not touch it. There
are other options for bidi. (just my $0.02)

Boaz

