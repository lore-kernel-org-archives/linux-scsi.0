From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 09/33] x86-64: update iommu/dma mapping functions to sg
	helpers
Date: Tue, 17 Jul 2007 09:56:37 +0200
Message-ID: <20070717075637.GH5195@kernel.dk>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792681830-git-send-email-jens.axboe@oracle.com> <20070716130608.4d096e29.akpm@linux-foundation.org> <20070716201002.GQ5195@kernel.dk> <20070716133427.e212b753.akpm@linux-foundation.org> <20070717070217.GB5195@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:21155 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbXGQH5N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 03:57:13 -0400
Content-Disposition: inline
In-Reply-To: <20070717070217.GB5195@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, ak@suse.de

On Tue, Jul 17 2007, Jens Axboe wrote:
> On Mon, Jul 16 2007, Andrew Morton wrote:
> > On Mon, 16 Jul 2007 22:10:03 +0200
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Mon, Jul 16 2007, Andrew Morton wrote:
> > > > On Mon, 16 Jul 2007 11:47:23 +0200
> > > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > 
> > > > > This prepares x86-64 for sg chaining support.
> > > > > 
> > > > > Additional improvements/fixups for pci-gart from
> > > > > Benny Halevy <bhalevy@panasas.com>
> > > > > 
> > > > > Cc: ak@suse.de
> > > > > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > > > > ---
> > > > >  arch/x86_64/kernel/pci-calgary.c |   25 ++++++++------
> > > > >  arch/x86_64/kernel/pci-gart.c    |   63 ++++++++++++++++++++-----------------
> > > > >  arch/x86_64/kernel/pci-nommu.c   |    5 ++-
> > > > >  3 files changed, 51 insertions(+), 42 deletions(-)
> > > > 
> > > > This causes fairly extensive destruction of 2.6.23 changes which are
> > > > pending in Andi's tree.
> > > > 
> > > > I shall drop the block tree until a) Andi has merged the pending Calgary
> > > > changes and b) the block tree has been fixed up to account for those (and
> > > > other) changes.
> > > > 
> > > > Really, this was the perfectly worst time possible to go tromping all over
> > > > everyone else's trees.
> > > 
> > > Well, that's a bit hard for me to know, all I can do is push my stuff to
> > > for-akpm so that it gets -mm exposure. If I don't, then you are yelling
> > > at me as well :-)
> > 
> > It is to be expected that there will be conflicts when making large-scale
> > changes like this while there is 25MB of unmerged diff sitting out in 50
> > different trees.  Doing it around the -rc1 time would be better.
> > 
> > Even better would be not doing it at all: add the necessary stuff into the
> > block core and then send the followup work to the relevant maintainers. ie:
> > standard practice.
> 
> I'll do that. Most of the stuff is trivial, but the x86-64 iommu changes
> are probably the most tricky and invasive of them all.

OK, this is what I did:

Split the set into 3, in the following order:

CORE -> DRIVERS -> ARCH

So that's 3 branches, core is based off master, drivers off core, and
arch off drivers. I'll push core+drivers into #for-akpm for testing,
then the arch bits will stay undisturbed until acked by maintainers.

-- 
Jens Axboe

