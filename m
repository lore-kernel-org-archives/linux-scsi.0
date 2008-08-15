From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/2] drop vmerge accounting
Date: Fri, 15 Aug 2008 11:48:00 +0200
Message-ID: <20080815094800.GI20055@kernel.dk>
References: <20080808055405.GF20055@kernel.dk> <20080808151147J.fujita.tomonori@lab.ntt.co.jp> <20080808061537.GI20055@kernel.dk> <20080808152845N.fujita.tomonori@lab.ntt.co.jp> <20080808063527.GJ20055@kernel.dk> <Pine.LNX.4.64.0808081247430.11647@devserv.devel.redhat.com> <Pine.LNX.4.64.0808081254000.11647@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:2587 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbYHOJsC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2008 05:48:02 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808081254000.11647@devserv.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net

On Fri, Aug 08 2008, Mikulas Patocka wrote:
> On Fri, 8 Aug 2008, Mikulas Patocka wrote:
> 
> > On Fri, 8 Aug 2008, Jens Axboe wrote:
> > 
> > > On Fri, Aug 08 2008, FUJITA Tomonori wrote:
> > > > On Fri, 8 Aug 2008 08:15:37 +0200
> > > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > 
> > > > > > BTW, we also wait for your verdict on:
> > > > > > 
> > > > > > http://marc.info/?t=121611935500002&r=1&w=2
> > > > > 
> > > > > I've always hated the iommu virtual merging complexity. My plan is to
> > > > > rip it out.
> > > > 
> > > > No complaint from me. I'm just happy to see the verdict at length.
> > > 
> > > Mikulas, you had a patch for this. Can you strip out the arch bits and
> > > just send me the block bits? The arch bits should go in via the arch
> > > maintainers.
> > > 
> > > The iommu code may still do virtual merging, it would be silly not to do
> > > that if possible. Now that later kernels expose the necessary parameters
> > > at that level as well, it's perfectly feasible.
> > 
> > Here I'm sending the first one, it removes virtual merge accounting from 
> > blk-merge.c (it acts as if all architectures undefined 
> > BIO_VMERGE_BOUNDARY). I also created second patch that removes 
> > bi_hw_segments field from struct bio and struct request. The next task 
> > would be to remove nr_hw_segments from the request_queue, but it will 
> > require changing the drivers.
> > 
> > Mikulas
> 
> (note: raid5 uses nr_hw_segments field for some other purpose, so this 
> patch will break it. It should be fixed by raid5 maintainers)
> 
> Remove hw_segments field from struct bio and struct request. Without virtual
> merge accounting they have no purpose.

I have applied this and the previous, with a fixup to raid5 to overload
both active stripe and process count in bi_phys_segments.

-- 
Jens Axboe

