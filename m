From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH v2] use dynamically allocated sense buffer
Date: Fri, 18 Jan 2008 05:56:08 +0900
Message-ID: <20080118055603P.tomof@acm.org>
References: <478DFA26.2020706@panasas.com>
	<20080117181356Z.fujita.tomonori@lab.ntt.co.jp>
	<1200585491.3255.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:36049 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbYAQU4a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jan 2008 15:56:30 -0500
In-Reply-To: <1200585491.3255.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: fujita.tomonori@lab.ntt.co.jp, bhalevy@panasas.com, linux-scsi@vger.kernel.org, tomof@acm.orgfujita.tomonori@lab.ntt.co.jp

On Thu, 17 Jan 2008 09:58:11 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> 
> On Thu, 2008-01-17 at 18:13 +0900, FUJITA Tomonori wrote:
> > On Wed, 16 Jan 2008 14:35:50 +0200
> > Benny Halevy <bhalevy@panasas.com> wrote:
> > 
> > > On Jan. 15, 2008, 17:20 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > > On Tue, 2008-01-15 at 18:23 +0900, FUJITA Tomonori wrote:
> > > >> This is the second version of
> > > >>
> > > >> http://marc.info/?l=linux-scsi&m=119933628210006&w=2
> > > >>
> > > >> I gave up once, but I found that the performance loss is negligible
> > > >> (within 1%) by using kmem_cache_alloc instead of mempool.
> > > >>
> > > >> I use scsi_debug with fake_rw=1 and disktest (DIO reads with 8
> > > >> threads) again:
> > > >>
> > > >> scsi-misc (slub)         | 486.9 MB/s  IOPS 124652.9/s
> > > >> dynamic sense buf (slub) | 483.2 MB/s  IOPS 123704.1/s
> > > >>
> > > >> scsi-misc (slab)         | 467.0 MB/s  IOPS 119544.3/s
> > > >> dynamic sense buf (slab) | 468.7 MB/s  IOPS 119986.0/s
> > > >>
> > > >> The results are the averages of three runs with a server using two
> > > >> dual-core 1.60 GHz Xeon processors with DDR2 memory.
> > > >>
> > > >>
> > > >> I doubt think that someone will complain about the performance
> > > >> regression due to this patch. In addition, unlike scsi_debug, the real
> > > >> LLDs allocate the own data structure per scsi_cmnd so the performance
> > > >> differences would be smaller (and with the real hard disk overheads).
> > > >>
> > > >> Here's the full results:
> > > >>
> > > >> http://www.kernel.org/pub/linux/kernel/people/tomo/sense/results.txt
> > > > 
> > > > Heh, that's one of those good news, bad news things.  Certainly good
> > > > news for you.  The bad news for the rest of us is that you just
> > > > implicated mempool in a performance problem  and since they're the core
> > > > of the SCSI scatterlist allocations and sit at the heart of the critical
> > > > path in SCSI, we have a potential performance issue in the whole of
> > > > SCSI.
> > > 
> > > Looking at mempool's code this is peculiar as what seems to be its
> > > critical path for alloc and free looks pretty harmless and lightweight.
> > > Maybe an extra memory barrier, spin_{,un}lock_* and two extra function call
> > > (one of them can be eliminated BTW if the order of arguments to the
> > > mempool_{alloc,free}_t functions were the same as for kmem_cache_{alloc,free}).
> > 
> > Yeah, so I wondered why the change made a big difference. After more
> > testing, it turned out that mempool is not so slow.
> > 
> > v1 patch reserves as many buffers as can_queue per shost. My test
> > server allocates 1519 sense buffers in total and then needs to
> > allocate more. Seems that it hurts the performance.
> 
> I would bet it does.  Mempools aren't a performance enhancer, they're a
> deadlock avoider.  So you don't prefill them with 1519 entries per host,
> you prefill them with at most two so that we can always guarantee
> getting a writeout command down in the event the system is totally out
> of GFP_ATOMIC memory and needs to free something.

Yes, I misunderstood how mempool works.

BTW, I preallocated as many buffers as can_queue an then the server
allocates 1519 buffers in total (with five scsi hosts).


> Plus, pool allocations of that size will get me hunted down and shot by
> the linux tiny (or other embedded) community.

Definitely.


> > I modified v3 patch to allocate unused 1519 sense buffers via
> > kmem_cache_alloc. It achieved 96.2% of the scsi-misc performance (note
> > that v1 patch achieved 94.6% of the scsi-misc).
> > 
> > I modified v3 patch to use mempool to allocate one buffer per host. It
> > achieved 98.3% of the scsi-misc (note that v3 patch achieved 99.3% of
> > the scsi-misc).
> 
> This is about the correct thing to do.

Will you merge the v3 patch or the modified v3 patch to use mempool to
allocate one buffer per host? Or always allocating sense buffer costs
too much?
