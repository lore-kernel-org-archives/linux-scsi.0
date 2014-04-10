From: Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: hpsa driver bug crack kernel down!
Date: Wed, 09 Apr 2014 17:19:40 -0700
Message-ID: <1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
	 <1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
	 <1397084904.9519.62.camel@dabdike> <1397085044.9519.63.camel@dabdike>
	 <1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>
	 <1397087425.9519.67.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1397087425.9519.67.camel@dabdike>
Sender: linux-pci-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, scameron@beardog.cce.hp.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-04-09 at 16:50 -0700, James Bottomley wrote:
> On Wed, 2014-04-09 at 16:40 -0700, Davidlohr Bueso wrote:
> > On Wed, 2014-04-09 at 16:10 -0700, James Bottomley wrote:
> > > On Wed, 2014-04-09 at 16:08 -0700, James Bottomley wrote:
> > > > [+linux-scsi]
> > > > On Wed, 2014-04-09 at 15:49 -0700, Davidlohr Bueso wrote:
> > > > > On Wed, 2014-04-09 at 10:39 +0800, Baoquan He wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > The kernel is 3.14.0+ which is pulled just now. 
> > > > > 
> > > > > Cc'ing more people.
> > > > > 
> > > > > While the hpsa driver appears to be involved in some way, I'm sure if
> > > > > this is a related issue, but as of today's pull I'm getting another
> > > > > problem that causes my DL980 not to come up.
> > > > > 
> > > > > *Massive* amounts of:
> > > > > 
> > > > > DMAR:[fault reason 02] Present bit in context entry is clear
> > > > > dmar: DRHD: handling fault status reg 602
> > > > > dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr 7f61e000
> > > > > 
> > > > > Then:
> > > > > 
> > > > > hpsa 0000:03:00.0: Controller lockup detected: 0xffff0000
> > > > > ...
> > > > > Workqueue: events hpsa_monitor_ctlr_worker [hpsa]
> > > > > ...
> > > > > 
> > > > > Screenshot of the actual LOCKUP: 
> > > > > http://stgolabs.net/hpsa-hard-lockup-3.14+.png
> > > > > 
> > > > > While I haven't bisected, things worked fine until at least until commit
> > > > > 39de65aa2c3e (April 2nd).
> > > > > 
> > > > > Any ideas?
> > > > 
> > > > Well, it's either a DMA remapping issue or a hpsa one.  Your assertion
> > > > that everything worked fine until 39de65aa2c3e would tend to vindicate
> > > > hpsa, 
> > 
> > Hmm here you mean DMA, right?
> 
> No, it vindicates the hpsa changes ... they don't seem to be causing
> problems until something goes wrong with dma remapping.
> 
> > > because all the hpsa changes went in before that under
> > > Missing crucial info:
> > > 
> > > commit 1a0b6abaea78f73d9bc0a2f6df2d9e4c917cade1
> > > 
> > > > Merge: 3e75c6d b2bff6c
> > > > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > > > Date:   Tue Apr 1 18:49:04 2014 -0700
> > > > 
> > > >     Merge tag 'scsi-misc' of
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
> > > > 
> > > > can you revalidate that this commit works OK just to make sure?
> > 
> > Ok so I don't see those DMA messages and system starts just fine. I'm
> > thinking perhaps something broke after the IO mmu stuff in commit 
> > 3f583bc21977a608908b83d03ee2250426a5695c... could this be indirectly
> > causing the CPU stalls and just blame hpsa in the path as a side effect?
> > 
> > /me goes out to try the commit.
> 
> That's my guess.  The DMAR messages are DMA remapping issues caused in
> the IOMMU.  If I had to guess, I'd say the DMAR fault message is
> indicating the IOMMU is calling for a mapping address before it can
> satisfy the driver read request, which is causing the hang apparently in
> the hpsa driver.
> 
> I've added linux-pci to the cc; I think they deal with iommu issues on
> x86.

So that merge commit appears to be the culprit, I see both the DMA
messages and the lockup blaming hpsa...
