From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [(re)Announce] Emulex LightPulse Device Driver
Date: Tue, 18 May 2004 09:08:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F9370@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:26557 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S263366AbUERNI2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 May 2004 09:08:28 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: 'Christoph Hellwig' [mailto:hch@infradead.org]
> Sent: Tuesday, May 18, 2004 5:59 AM
> To: Smart, James
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [(re)Announce] Emulex LightPulse Device Driver
> 
> 
> On Mon, May 17, 2004 at 05:25:26PM -0400, Smart, James wrote:
> > We could embed the timer into the associated object. This 
> is mainly an
> > approach issue - it was just a simplistic choice to track 
> the timers via the
> > hba object. Given the amount of code churn changing this 
> would incur, I'm
> > inclined to ask why, other than for style and approach, must this be
> > changed?
> 
> Because it makes the code extremly hard to read and 
> performing worse by
> all the allocations/dealloctions.  In addition you have a 
> nice use after
> free opportunity because you use del_timer (instead of del_timer_sync)
> before freeing it.  And when you have to look through all 
> callers to check
> whether they're allowed to sleep you could just fix it.

We'll see if there's some middle ground or something that we can do.


> 
> > > You have a structure type lpfcDRVR_t but just a single 
> global instance
> > > of it.  Aka the data structure is just obsfucation and each 
> > > member should
> > > be a driver-wide variable of it's own.
> > 
> > Ok - so I can see just killing the structure and making 
> it's elements
> > globals. But, is this all you are asking ?
> 
> Yes.

Great. Consider this done.
 
> > The elements are just a linked
> > list of the per-hba structures. You aren't recommending 
> that we make arrays
> > of the per-hba structures are you ? 
> 
> No arrays please.  In fact the per-hba item lists should go 
> away completely
> later on aswell, except for things like memory pools a driver 
> shouldn't have
> global state.

We're always going to have adapter state. Global state is minimal.  The
referenced link list is only to used when searching for a particular
instance when there isn't a better handle to dereference off of (and for
humans, when debugging).


> 
> > > It's really awkward to follow.  See qla1280.c to see how to 
> > > use 2.6-style
> > > probe/release calls in a 2.4ish enviroment.  Been there, 
> done that.
> > 
> > Ok - so why is this a significant issue ?
> 
> It's not really significant for probe, it just makes the code 
> a lot easier
> to follow and it's how all proper modern drivers are written. 
>  Remember that
> with submitting a driver on mainline you place a burden on us 
> folks doing
> work on the subsystem as we now have to fix up all drivers for global
> changes.
> 

I'll see what we can do.


> > > Dito.  Note that this one is especially awkward because of 
> > > the brainded
> > > pass index instead of object calling convention.
> > 
> > It is a little awkward, with the only difference whether 
> the base structure
> > is found in the lpfc_pci_release routine or not. Still 
> doesn't seem a
> > significant issue.
> 
> The indexing issue is really significant because a proper scsi driver
> should have index->object lookups anywhere (see above statement about
> lack of global state)

(same) - we'll do something here.


> 
> > > Still doesn't say why they can't be global.  You'd need 
> to uncomment
> > > mempool_resize in mm/mempool.c for that, though.
> > 
> > Also doesn't say they need to be global. Again - what's the 
> significant
> > issue ? Seems to be just a style - whether things are done 
> on a per-instance
> > basis or on a global basis. As the size requirements for 
> this pool is based
> > on the number of instances - per-hba pools scales with far 
> less effort when
> > more adapters are present. Growing/shrinking the pool each 
> time an instance
> > attaches/detaches actually makes the global pool implementation more
> > complex. Coding for a global vs per-hba pool is roughly 
> identical - the only
> > difference being whether the data structure is anchored 
> globally or in the
> > per-hba structure.  And if you've already got per-hba pool 
> code (the pre-dma
> > mapped pools), making the pool global seems to just add code.
> 
> It's wasting a mempool object per hba.  But this issue isn't 
> really important,
> so if you want leave it as-is.

Ok.

-- James S
