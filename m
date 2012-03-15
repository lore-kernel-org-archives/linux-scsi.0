From: Kent Overstreet <koverstreet@google.com>
Subject: Re: Bcache
Date: Thu, 15 Mar 2012 13:27:47 -0400
Message-ID: <20120315172746.GC8638@dhcp-172-18-216-138.mtv.corp.google.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120314155339.GC30235@redhat.com>
 <CAH+dOxKxZYSdZfewt5mHsvOk68VfNKzMQveibGLM+qunV6mOMw@mail.gmail.com>
 <20120314220150.GA15464@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42464 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964869Ab2COR1v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Mar 2012 13:27:51 -0400
Received: by yhmm54 with SMTP id m54so3353508yhm.19
        for <linux-scsi@vger.kernel.org>; Thu, 15 Mar 2012 10:27:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120314220150.GA15464@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, lsf-pc@lists.linux-foundation.org, nauman@google.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>

On Wed, Mar 14, 2012 at 06:01:50PM -0400, Mike Snitzer wrote:
> On Wed, Mar 14 2012 at  1:24pm -0400,
> Kent Overstreet <koverstreet@google.com> wrote:
> 
> > On Wed, Mar 14, 2012 at 11:53 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > On Wed, Mar 14, 2012 at 09:32:28AM -0400, Kent Overstreet wrote:
> > >> I'm already registered to attend, but would it be too late in the
> > >> process to give a talk? I'd like to give a short talk about bcache, what
> > >> it does and where it's going (more than just caching).
> > >
> > > [CCing dm-devel list]
> > >
> > > I am curious if you considered writing a device mapper driver for this? If
> > > yes, why that is not a good choice. It seems to be stacked device and device
> > > mapper should be good at that. All the configuration through sysfs seems
> > > little odd to me.
> > 
> > Everyone asks this. Yeah, I considered it, I tried to make it work for
> > a couple weeks but it was far more trouble than it was worth. I'm not
> > opposed to someone else working on it but I'm not going to spend any
> > more time on it myself.
> 
> I really wish you'd have worked with dm-devel more persistently, you did
> post twice to dm-devel (at an awkward time of year but whatever):
> http://www.redhat.com/archives/dm-devel/2010-December/msg00204.html
> http://www.redhat.com/archives/dm-devel/2010-December/msg00232.html

I spent quite a bit of time talking to Heinz Mauelshagen and someone
else who's name escapes me; I also spent around two weeks working on
bcache-dm code before I decided it was unworkable.

And bcache is two years old now, if the dm guys wanted bcache to use dm
there's been ample opportunity; nobody's been interested enough to do
anything about it. I'm still not against a bcache-dm interface, if
someone else can make it work - I just really have no interest or reason
to write the code myself. It works fine as it is.

> But somewhere along the way you privately gave up on DM... and have
> since repeatedly talked critically of DM.  Yet you have _never_
> substantiated _why_ DM is "far more trouble than it was worth", etc.

I have, can't blame you for missing it but honestly this comes up
constantly; people asking me (often accusitavely) why bcache doesn't use
dm and it gets really old. I've got better things to do.

Frankly, my biggest complaint with the DM is that the code is _terrible_
and very poorly documented. It's an inflexible framework that tries to
combine a bunch of things that should be orthogonal. My other complaints
all stem from that; it became very clear that it wasn't designed for
creating a block device from the kernel, which is kind of necessary (at
least the only sane way of doing it, IMO) when metadata is managed by
the kernel (and the kernel has to manage most metadata for bcache).

> Reading between the lines on a previous LKML bcache threads where the
> questions of "why not use DM or MD?" came up:
> https://lkml.org/lkml/2011/9/11/117
> https://lkml.org/lkml/2011/9/15/376
> 
> It seemed your primary focus was on getting into the details of the SSD
> caching ASAP -- because that is what interested you.  Both DM and MD
> have a learning curve, maybe it was too frustrating and/or
> distracting to tackle.
> 
> Anyway, I don't fault you for initially doing your own thing for a
> virtual device framework -- it allowed you to get to the stuff you
> really cared about sooner.
> 
> That said, it is frustrating that you are content to continue doing your
> own thing because I'm now tasked with implementing a DM target for
> caching/HSM, as I touched on here:
> http://www.redhat.com/archives/linux-lvm/2012-March/msg00007.html

Kind of presumptuous, don't you think?

I've nothing at all against collaborating, or you or other dm devs
adapting bcache code - I'd help out with that!

But I'm just not going to write my code a certain way just to suit you.

> I have little upfront incentive to make use of bcache because it doesn't
> use DM.  Not to mention DM already has its own b-tree implementation
> (granted bcache is much more than it's b+tree).  I obviously won't
> ignore bcache (or flashcache) but I'm setting out to build on DM
> infrastructure as effectively as possible.

Oh, darn.

> My initial take on how to factor things is to split into 2 DM targets:
> "hsm-cache" and "hsm".  These targets reuse the infrastructure that was
> recently introduced for dm-thinp: drivers/md/persistent-data/ and
> dm-bufio.
> 
> Like the "thin-pool" target, the "hsm-cache" target provides a central
> resource (cache) that "hsm" target device(s) will attach to.  The
> "hsm-cache" target, like thin-pool, will have a data and metadata
> device, constructor:
> hsm-cache <metadata dev> <data dev> <data block size (sectors)> 
> 
> The "hsm" target will pair an hsm-cache device with a backing device,
> constructor:
> hsm <dev_id> <cache_dev> <backing_dev>
> 
> The same hsm-cache device may be used by multiple hsm devices.  So I
> mean this is the same high-level architecture as bcache (shared SSD
> cache).
> 
> Where things get interesting is the mechanics of the caching and the
> metadata.  I'm coming to terms with the metadata now (based on desired
> features and cache replacement policies), once it is nailed down I
> expect things to fall into place pretty quickly.
> 
> I'm very early in the design but hope to have an initial functional
> version of the code together in time for LSF -- ~2 weeks may be too
> ambitious but it's my goal (could be more doable if I confine the
> initial code to writethrough with LRU).

Look forward to seeing the benchmarks.
