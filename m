From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Wed, 09 May 2007 10:46:34 +0300
Message-ID: <46417C5A.1090707@panasas.com>
References: <20070508112553C.fujita.tomonori@lab.ntt.co.jp>	 <4640C724.8030409@panasas.com> <1178654497.3737.81.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:56383 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751682AbXEIHr0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2007 03:47:26 -0400
In-Reply-To: <1178654497.3737.81.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, bhalevy@panasas.com, jens.axboe@oracle.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

James Bottomley wrote:
> I think you'll find that kzalloc comes directly out of a slab for this
> size of allocation anyway ... you mean you want to see a dedicated pool
> for this specific allocation?
Yes, As you said below so we can always send IO for "forward progress
of freeing memory". My test machine is a Linux cluster in front of a
pNFS over OSD. The HPC cluster is diskless. It will reach this
situation very fast.

> There's another problem in that it destroys our forward progress
> guarantee.  There's always a single reserve command for every HBA so
> that forward progress for freeing memory can always be made in the
> system even if the command slab is out and we have to reclaim memory
> through a HBA with no outstanding commands.  Allocating two commands per
> bidirectional request hoses that guarantee ... it could be fixed up by
> increasing the reserve pool to 2, but that's adding further unwanted
> complexity ...
> 
Thanks for catching it! I was afraid of that. If we stick with this solution
in the interim until we do what you suggested below, we will need to put one
more for bidi. It should not be a complicated pool thing, just a reserved one
for the bidi case.

> 
> There's actually a fourth option you haven't considered:
> 
> Roll all the required sglist definitions (request_bufflen,
> request_buffer, use_sg and sglist_len) into the sgtable pools.
> 
> We're getting very close to the point where someone gets to sweep
> through the drivers eliminating the now superfluous non-sg path in the
> queuecommand.  When that happens the only cases become no transfer or SG
> backed commands.  At this point we can do a consolidation of the struct
> scsi_cmnd fields.  This does represent the ideal time to sweep the sg
> list handling fields into the sgtable and simply have a single pointer
> to struct sgtable in the scsi_cmnd (== NULL is the signal for a no
> transfer command).
> 
This is a grate Idea. Let me see if I understand what you mean.
1. An sgtable is a single allocation with an sgtable header type
   at the begining and a veriable size array of struct scatterlist.
   something like:
   struct sgtable {
   	struct sgtable_header {
		unsigned sg_count, sglist_len, length;
		struct sgtable* next; //for Jens's big io
   	} hdr;
	struct scatterlist sglist[];
   }
   Slabs are put up for above sgtable of different sizes as
   done today. (Should they be sized on different ARCHs to
   align on page boundaries?)

2. The way we can do this in stages: Meaning put up code that has
   both sets of API, Transfer drivers one-by-one to new API, deprecate
   old API for a kernel cycle or two. Than submit last piece of
   code that removes the old API.
   It can be done. We just need to copy sgtable_header fields
   to the old fields, and let them stick around for a while.

3. The second bidi sgtable will hang on request->next_rq->special.

> James
> 
> 
If everyone agrees on something like above. I can do it right away.
It's a solution I wouldn't even dream of. Thanks

Boaz
