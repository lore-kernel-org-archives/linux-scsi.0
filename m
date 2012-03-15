From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Bcache
Date: Thu, 15 Mar 2012 16:17:32 -0400
Message-ID: <20120315201732.GA23403@redhat.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120314155339.GC30235@redhat.com>
 <CAH+dOxKxZYSdZfewt5mHsvOk68VfNKzMQveibGLM+qunV6mOMw@mail.gmail.com>
 <20120314220150.GA15464@redhat.com>
 <20120315172746.GC8638@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161335Ab2COURo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2012 16:17:44 -0400
Content-Disposition: inline
In-Reply-To: <20120315172746.GC8638@dhcp-172-18-216-138.mtv.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, lsf-pc@lists.linux-foundation.org, nauman@google.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>

On Thu, Mar 15 2012 at  1:27pm -0400,
Kent Overstreet <koverstreet@google.com> wrote:

> On Wed, Mar 14, 2012 at 06:01:50PM -0400, Mike Snitzer wrote:
> > I really wish you'd have worked with dm-devel more persistently, you did
> > post twice to dm-devel (at an awkward time of year but whatever):
> > http://www.redhat.com/archives/dm-devel/2010-December/msg00204.html
> > http://www.redhat.com/archives/dm-devel/2010-December/msg00232.html
> 
> I spent quite a bit of time talking to Heinz Mauelshagen and someone
> else who's name escapes me; I also spent around two weeks working on
> bcache-dm code before I decided it was unworkable.
> 
> And bcache is two years old now, if the dm guys wanted bcache to use dm
> there's been ample opportunity; nobody's been interested enough to do
> anything about it. I'm still not against a bcache-dm interface, if
> someone else can make it work - I just really have no interest or reason
> to write the code myself. It works fine as it is.

Your interest should be in getting the hard work you've put into bcache
upstream.  That's unlikely to happen until you soften on your reluctance
to embrace existing appropriate kernel interfaces.

> Frankly, my biggest complaint with the DM is that the code is _terrible_
> and very poorly documented. It's an inflexible framework that tries to
> combine a bunch of things that should be orthogonal. My other complaints
> all stem from that; it became very clear that it wasn't designed for
> creating a block device from the kernel, which is kind of necessary (at
> least the only sane way of doing it, IMO) when metadata is managed by
> the kernel (and the kernel has to manage most metadata for bcache).

Baseless and unspecific assertions don't help your cause -- dm-thinp
disproves your unconvincing position (manages it's metadata in kernel,
etc).

Seems pretty clear you could care less about _really_ working together
-- maybe it is just this DM/kernel interface thing gets you down.

Regardless, the burden is on me (and all developers who have a desire to
see a caching/HSM driver get upstream) to evaluate bcache.  That process
has started -- hopefully it'll be as simple as:

1) put a DM target wrapper in place of your sysfs interface.
2) switch/port bcache's btree over to drivers/md/persistent-data/
3) dm-bcache FTW

One could dream.

The little bit I've looked at bcache it already seems unrealistic; for
starters you have the btree wired directly to bio submission.
drivers/md/persistent-data/ offers a layered approach,
dm-block-manager.c brokers the IO submission (via dm-bufio) so the
management of the btree(s) doesn't need to be concerned with actual IO.

bcache is _very_ tightly coupled with your btree implementation.

> > Reading between the lines on a previous LKML bcache threads where the
> > questions of "why not use DM or MD?" came up:
> > https://lkml.org/lkml/2011/9/11/117
> > https://lkml.org/lkml/2011/9/15/376
> > 
> > It seemed your primary focus was on getting into the details of the SSD
> > caching ASAP -- because that is what interested you.  Both DM and MD
> > have a learning curve, maybe it was too frustrating and/or
> > distracting to tackle.
> > 
> > Anyway, I don't fault you for initially doing your own thing for a
> > virtual device framework -- it allowed you to get to the stuff you
> > really cared about sooner.
> > 
> > That said, it is frustrating that you are content to continue doing your
> > own thing because I'm now tasked with implementing a DM target for
> > caching/HSM, as I touched on here:
> > http://www.redhat.com/archives/linux-lvm/2012-March/msg00007.html
> 
> Kind of presumptuous, don't you think?

Not really, considering what I'm responding to at the moment ;)

> I've nothing at all against collaborating, or you or other dm devs
> adapting bcache code - I'd help out with that!

OK.

> But I'm just not going to write my code a certain way just to suit you.

upstream kumbaya: more cooperative eyes on the problem, working to hook
into established interfaces, will produce a solution that is worthy of
upstream inclusion.

> Look forward to seeing the benchmarks.

Speaking of which, weren't you saying you'd show bcache benchmarks in a
previous LKML thread?
