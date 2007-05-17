From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 17 May 2007 07:48:13 +0200
Message-ID: <20070517054811.GV23798@kernel.dk>
References: <46417C5A.1090707@panasas.com> <464B3F91.1010102@panasas.com> <20070516175322.GS23798@kernel.dk> <20070517115722T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9390 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbXEQFtv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2007 01:49:51 -0400
Content-Disposition: inline
In-Reply-To: <20070517115722T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bharrosh@panasas.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

On Thu, May 17 2007, FUJITA Tomonori wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: [PATCH v2] add bidi support for block pc requests
> Date: Wed, 16 May 2007 19:53:22 +0200
> 
> > On Wed, May 16 2007, Boaz Harrosh wrote:
> > > Boaz Harrosh wrote:
> > > > James Bottomley wrote:
> > > >> 
> > > >> There's actually a fourth option you haven't considered:
> > > >>
> > > >> Roll all the required sglist definitions (request_bufflen,
> > > >> request_buffer, use_sg and sglist_len) into the sgtable pools.
> > > >>
> > > > This is a grate Idea. Let me see if I understand what you mean.
> > > > ...
> > > > ...
> > > 
> > > Hi Dear James, list.
> > > I have worked on proposed solution (If anyone is interested see
> > > url blow)
> > > 
> > > Now it works and all but I hit some problems.
> > > What happens is that in 64 bit architectures, well in x86_64,
> > > the sizeof scatterlist structure is 32 bytes which means that
> > > we can only fit exactly 128 of them in a page. But together with
> > > the scsi_sg_table header we are down to 127. Also if we want
> > > good alignment/packing of other sized pools we want:
> > > static struct scsi_host_sg_pool scsi_sg_pools[] = {
> > > 	SP(7),
> > > 	SP(15),
> > > 	SP(31),
> > > 	SP(63),
> > > 	SP(127)
> > > };
> > > 
> > > now there are 2 issues with this:
> > > 1. Even if I do blk_queue_max_phys_segments(q, 127); I still get
> > >    requests for use_sg=128 which will crash the kernel.
> > 
> > That sounds like a serious issue, it should definitely not happen. Stuff
> > like that would bite other drivers as well, are you absolutely sure that
> > is happening? Power-of-2 bug in your code, or in the SCSI code?
> 
> Boaz, how do you send requests to the scsi-ml, via fs, sg, or bsg?
> 
> 
> > > If anyone wants to see I have done 2 versions of this work. One on top
> > > of Jens's sg-chaining work (ver 5). And one on top of Tomo's cleanup
> > > git. both can be found here:
> > >   http://www.bhalevy.com/open-osd/download/scsi_sg_table/
> > 
> > +#define scsi_for_each_sg(cmd, sg, nseg, __i)                   \
> > +       for (__i = 0, sg = scsi_sglist(cmd); __i < (nseg); __i++, (sg)++)
> > 
> > Hmm?
> 
> When for_each_sg is ready, we convert scsi_for_each_sg to use
> for_each_sg. I finished the cleanups on more than 40 drivers on the
> top of your patches.

But this is from the patch that is based on my sglist branch, so it
looked somewhat odd.

-- 
Jens Axboe

