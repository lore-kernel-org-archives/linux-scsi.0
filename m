From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Wed, 16 May 2007 19:53:22 +0200
Message-ID: <20070516175322.GS23798@kernel.dk>
References: <20070508112553C.fujita.tomonori@lab.ntt.co.jp> <4640C724.8030409@panasas.com> <1178654497.3737.81.camel@mulgrave.il.steeleye.com> <46417C5A.1090707@panasas.com> <464B3F91.1010102@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:18041 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759987AbXEPRyz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2007 13:54:55 -0400
Content-Disposition: inline
In-Reply-To: <464B3F91.1010102@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

On Wed, May 16 2007, Boaz Harrosh wrote:
> Boaz Harrosh wrote:
> > James Bottomley wrote:
> >> 
> >> There's actually a fourth option you haven't considered:
> >>
> >> Roll all the required sglist definitions (request_bufflen,
> >> request_buffer, use_sg and sglist_len) into the sgtable pools.
> >>
> > This is a grate Idea. Let me see if I understand what you mean.
> > ...
> > ...
> 
> Hi Dear James, list.
> I have worked on proposed solution (If anyone is interested see
> url blow)
> 
> Now it works and all but I hit some problems.
> What happens is that in 64 bit architectures, well in x86_64,
> the sizeof scatterlist structure is 32 bytes which means that
> we can only fit exactly 128 of them in a page. But together with
> the scsi_sg_table header we are down to 127. Also if we want
> good alignment/packing of other sized pools we want:
> static struct scsi_host_sg_pool scsi_sg_pools[] = {
> 	SP(7),
> 	SP(15),
> 	SP(31),
> 	SP(63),
> 	SP(127)
> };
> 
> now there are 2 issues with this:
> 1. Even if I do blk_queue_max_phys_segments(q, 127); I still get
>    requests for use_sg=128 which will crash the kernel.

That sounds like a serious issue, it should definitely not happen. Stuff
like that would bite other drivers as well, are you absolutely sure that
is happening? Power-of-2 bug in your code, or in the SCSI code?

> 2. If I do SPs of 7,15,31,63,128 or even 8,16,32,64,128 it will
>    boot and work but clearly it does not fit in one page. So either
>    my sata drivers and iSCSI, which I test, are not sensitive to
>    scatterlists fit one page. Or kernel gives me 2 contiguous pages?

The 1-page thing isn't a restriction as such, it's just an optimization.
The scatterlist allocated is purely a kernel entity, so you could do 4
contig pages and larger ios that way, if higher order allocations were
reliable.

But you are right in that we need to tweak the sg pool size so that it
ends up being a nice size, and not something that either spans a little
bit into a second page or doesn't fill a page nicely. On my x86-64 here,
a 128 segment sg table is exactly one page (looking at slabinfo). It
depends on the allocator whether that is just right, or just a little
too much due to management information.

> I do not see away out of this problem. I think that even with Jens's
> chaining of sg_tables 128 is a magic number that we don't want to cross

Label me skeptical of your findings so far :-)

> It leaves me with option 3 on the bidi front. I think it would be best
> to Just allocate another global mem_pool of scsi_data_buffer(s) just like
> we do for scsi_io_context. The uni scsi_data_buffer will be embedded in
> struct scsi_cmnd and the bidi one will be allocated from this pool.
> I am open to any suggestions.

To statements on this affair:

- Any sg table size should work, provided that we can safely and
  reliably allocate it. We stay with 1 page max for that reason alone.

- The max sg number has no magic beyond staying within a single page for
  allocation reasons.

The scattertable really only exists as a temporary way to store and
setup transfer, until it's mapped to a driver private sg structure. That
is why the phys segments limit is purely a driver property, it has
nothing to do with the hardware or the hardware limits.

> If anyone wants to see I have done 2 versions of this work. One on top
> of Jens's sg-chaining work (ver 5). And one on top of Tomo's cleanup
> git. both can be found here:
>   http://www.bhalevy.com/open-osd/download/scsi_sg_table/

+#define scsi_for_each_sg(cmd, sg, nseg, __i)                   \
+       for (__i = 0, sg = scsi_sglist(cmd); __i < (nseg); __i++, (sg)++)

Hmm?

-- 
Jens Axboe

