From: Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: hpsa driver bug crack kernel down!
Date: Wed, 09 Apr 2014 16:40:17 -0700
Message-ID: <1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
	 <1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
	 <1397084904.9519.62.camel@dabdike> <1397085044.9519.63.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:48970 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaDIXkU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2014 19:40:20 -0400
In-Reply-To: <1397085044.9519.63.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, scameron@beardog.cce.hp.com, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2014-04-09 at 16:10 -0700, James Bottomley wrote:
> On Wed, 2014-04-09 at 16:08 -0700, James Bottomley wrote:
> > [+linux-scsi]
> > On Wed, 2014-04-09 at 15:49 -0700, Davidlohr Bueso wrote:
> > > On Wed, 2014-04-09 at 10:39 +0800, Baoquan He wrote:
> > > > Hi,
> > > > 
> > > > The kernel is 3.14.0+ which is pulled just now. 
> > > 
> > > Cc'ing more people.
> > > 
> > > While the hpsa driver appears to be involved in some way, I'm sure if
> > > this is a related issue, but as of today's pull I'm getting another
> > > problem that causes my DL980 not to come up.
> > > 
> > > *Massive* amounts of:
> > > 
> > > DMAR:[fault reason 02] Present bit in context entry is clear
> > > dmar: DRHD: handling fault status reg 602
> > > dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr 7f61e000
> > > 
> > > Then:
> > > 
> > > hpsa 0000:03:00.0: Controller lockup detected: 0xffff0000
> > > ...
> > > Workqueue: events hpsa_monitor_ctlr_worker [hpsa]
> > > ...
> > > 
> > > Screenshot of the actual LOCKUP: 
> > > http://stgolabs.net/hpsa-hard-lockup-3.14+.png
> > > 
> > > While I haven't bisected, things worked fine until at least until commit
> > > 39de65aa2c3e (April 2nd).
> > > 
> > > Any ideas?
> > 
> > Well, it's either a DMA remapping issue or a hpsa one.  Your assertion
> > that everything worked fine until 39de65aa2c3e would tend to vindicate
> > hpsa, 

Hmm here you mean DMA, right?

> because all the hpsa changes went in before that under
> Missing crucial info:
> 
> commit 1a0b6abaea78f73d9bc0a2f6df2d9e4c917cade1
> 
> > Merge: 3e75c6d b2bff6c
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Tue Apr 1 18:49:04 2014 -0700
> > 
> >     Merge tag 'scsi-misc' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
> > 
> > can you revalidate that this commit works OK just to make sure?

Ok so I don't see those DMA messages and system starts just fine. I'm
thinking perhaps something broke after the IO mmu stuff in commit 
3f583bc21977a608908b83d03ee2250426a5695c... could this be indirectly
causing the CPU stalls and just blame hpsa in the path as a side effect?

/me goes out to try the commit.


