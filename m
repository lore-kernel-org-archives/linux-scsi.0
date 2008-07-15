From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
	blk_recalc_rq_segments about VMERGE
Date: Tue, 15 Jul 2008 11:36:32 -0500
Message-ID: <1216139792.3312.74.camel@localhost.localdomain>
References: <1216118676-13625-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <Pine.LNX.4.64.0807150924250.21598@devserv.devel.redhat.com>
	 <20080715231956A.fujita.tomonori@lab.ntt.co.jp>
	 <1216133421.3312.30.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0807151104450.26824@devserv.devel.redhat.com>
	 <1216136503.3312.48.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0807151147040.29803@devserv.devel.redhat.com>
	 <1216138072.3312.54.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0807151210400.31336@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807151210400.31336@devserv.devel.redhat.com>
Sender: linux-parisc-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, davem@davemloft.net, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-07-15 at 12:20 -0400, Mikulas Patocka wrote:
> On Tue, 15 Jul 2008, James Bottomley wrote:
> 
> > On Tue, 2008-07-15 at 11:58 -0400, Mikulas Patocka wrote:
> >> You are mixing two ideas here:
> >>
> >> (1) virtual merging --- IOMMU maps discontinuous segments into continuous
> >> area that it presents to the device.
> >>
> >> (2) virtual merge accounting --- block layer tries to guess how many
> >> segments will be created by (1) and merges small requests into big ones.
> >> The resulting requests are as big that they can't be processed by the
> >> device if (1) weren't in effect.
> >
> > No ... I'm not ... the virtual merge implementation requires the block
> > layer to get this accounting right, otherwise the iommu code can end up
> > doing the wrong thing.
> 
> The virtual merge (1) can work even without accounting (2). IOMMU can 
> always create less sg entries then the block layer expects.

It can, but it's not optimal ... and depends on max_phys_segments ==
max_hw_segments.

> > You're proposing to eliminate the difference between max_phys_segments
> > and max_hw_segments without actually removing them.
> 
> Yes. Only for alpha and pa-risc, there is difference between these values. 
> And both of these architectures are being discontinued.
> 
> >> That's why I'm proposing to remove virtual merge accounting (2), but leave
> >> virtual merging (1) itself. The accounting doesn't reduce number of sg
> >> slots.
> >
> > Yes, but it's gains very little ... architectures that don't want it can
> > already turn it off, and it's useful for those, like parisc, who do.
> 
> It increases maintainability of the code, reduces bloat and bugs.

That's not really a good reason.  You can eliminate code because it's
unused and unikely to be used or you redo it to better or fix it to be
less buggy.  You don't simply eliminate useful functionality that
currently has in-tree users, however marginal you might opine those
users to be.

James


