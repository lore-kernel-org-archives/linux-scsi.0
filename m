From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/3] SCSI: Fix hard lockup in scsi_remove_target()
Date: Thu, 15 Oct 2015 09:07:26 +0200
Message-ID: <1444892846.19542.22.camel@suse.de>
References: <cover.1444829611.git.jthumshirn@suse.de>
	 <1444833036.2220.38.camel@HansenPartnership.com>
	 <1444854130.26884.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444854130.26884.33.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: emilne@redhat.com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-10-14 at 16:22 -0400, Ewan Milne wrote:
> On Wed, 2015-10-14 at 07:30 -0700, James Bottomley wrote:
> > On Wed, 2015-10-14 at 15:50 +0200, Johannes Thumshirn wrote:
> > > Removing a SCSI target via scsi_remove_target() suspected to be
> > > racy. When a
> > > sibling get's removed from the list it can occassionly happen
> > > that one CPU is
> > > stuck endlessly looping around this code block
> > > 
> > > list_for_each_entry(starget, &shost->__targets, siblings) {
> > >         if (starget->state == STARGET_DEL)
> > >                 continue;
> > 
> > How long is the __targets list?  It seems a bit unlikely that this
> > is
> > the exact cause, because for a short list all in STARGET_DEL that
> > loop
> > should exit very quickly.  Where in the code does
> > scsi_remove_target
> > +0x68/0x240 actually point to?
> > 
> > Is it not a bit more likely that we're following a removed list
> > element?
> > Since that points back to itself, the list_for_each_entry() would
> > then
> > circulate forever.  If that's the case the simple fix would be to
> > use
> > the safe version of the list traversal macro.
> > 
> > James
> 
> For what it's worth, I've seen a dump where this was exactly the
> case.
> starget was in STARGET_DEL state, starget->siblings pointed to
> itself,
> kref was 0, reap_ref was 0 (this was a while back).
> 

That's exactly what I have here as well.

I'll give Christoph's patch a shot today and report back.

> The problem was not able to be reproduced at the time.
> 
> -Ewan
> 
> 
