From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Bcache
Date: Wed, 14 Mar 2012 18:01:50 -0400
Message-ID: <20120314220150.GA15464@redhat.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120314155339.GC30235@redhat.com>
 <CAH+dOxKxZYSdZfewt5mHsvOk68VfNKzMQveibGLM+qunV6mOMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031096Ab2CNWCG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2012 18:02:06 -0400
Content-Disposition: inline
In-Reply-To: <CAH+dOxKxZYSdZfewt5mHsvOk68VfNKzMQveibGLM+qunV6mOMw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, lsf-pc@lists.linux-foundation.org, nauman@google.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>

On Wed, Mar 14 2012 at  1:24pm -0400,
Kent Overstreet <koverstreet@google.com> wrote:

> On Wed, Mar 14, 2012 at 11:53 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Mar 14, 2012 at 09:32:28AM -0400, Kent Overstreet wrote:
> >> I'm already registered to attend, but would it be too late in the
> >> process to give a talk? I'd like to give a short talk about bcache, what
> >> it does and where it's going (more than just caching).
> >
> > [CCing dm-devel list]
> >
> > I am curious if you considered writing a device mapper driver for this? If
> > yes, why that is not a good choice. It seems to be stacked device and device
> > mapper should be good at that. All the configuration through sysfs seems
> > little odd to me.
> 
> Everyone asks this. Yeah, I considered it, I tried to make it work for
> a couple weeks but it was far more trouble than it was worth. I'm not
> opposed to someone else working on it but I'm not going to spend any
> more time on it myself.

I really wish you'd have worked with dm-devel more persistently, you did
post twice to dm-devel (at an awkward time of year but whatever):
http://www.redhat.com/archives/dm-devel/2010-December/msg00204.html
http://www.redhat.com/archives/dm-devel/2010-December/msg00232.html

But somewhere along the way you privately gave up on DM... and have
since repeatedly talked critically of DM.  Yet you have _never_
substantiated _why_ DM is "far more trouble than it was worth", etc.

Reading between the lines on a previous LKML bcache threads where the
questions of "why not use DM or MD?" came up:
https://lkml.org/lkml/2011/9/11/117
https://lkml.org/lkml/2011/9/15/376

It seemed your primary focus was on getting into the details of the SSD
caching ASAP -- because that is what interested you.  Both DM and MD
have a learning curve, maybe it was too frustrating and/or
distracting to tackle.

Anyway, I don't fault you for initially doing your own thing for a
virtual device framework -- it allowed you to get to the stuff you
really cared about sooner.

That said, it is frustrating that you are content to continue doing your
own thing because I'm now tasked with implementing a DM target for
caching/HSM, as I touched on here:
http://www.redhat.com/archives/linux-lvm/2012-March/msg00007.html

I have little upfront incentive to make use of bcache because it doesn't
use DM.  Not to mention DM already has its own b-tree implementation
(granted bcache is much more than it's b+tree).  I obviously won't
ignore bcache (or flashcache) but I'm setting out to build on DM
infrastructure as effectively as possible.

My initial take on how to factor things is to split into 2 DM targets:
"hsm-cache" and "hsm".  These targets reuse the infrastructure that was
recently introduced for dm-thinp: drivers/md/persistent-data/ and
dm-bufio.

Like the "thin-pool" target, the "hsm-cache" target provides a central
resource (cache) that "hsm" target device(s) will attach to.  The
"hsm-cache" target, like thin-pool, will have a data and metadata
device, constructor:
hsm-cache <metadata dev> <data dev> <data block size (sectors)> 

The "hsm" target will pair an hsm-cache device with a backing device,
constructor:
hsm <dev_id> <cache_dev> <backing_dev>

The same hsm-cache device may be used by multiple hsm devices.  So I
mean this is the same high-level architecture as bcache (shared SSD
cache).

Where things get interesting is the mechanics of the caching and the
metadata.  I'm coming to terms with the metadata now (based on desired
features and cache replacement policies), once it is nailed down I
expect things to fall into place pretty quickly.

I'm very early in the design but hope to have an initial functional
version of the code together in time for LSF -- ~2 weeks may be too
ambitious but it's my goal (could be more doable if I confine the
initial code to writethrough with LRU).

Mike
