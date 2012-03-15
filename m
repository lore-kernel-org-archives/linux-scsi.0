From: Kent Overstreet <koverstreet@google.com>
Subject: Re: Bcache
Date: Thu, 15 Mar 2012 18:59:52 -0400
Message-ID: <20120315225952.GA8564@dhcp-172-18-216-138.mtv.corp.google.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120314155339.GC30235@redhat.com>
 <CAH+dOxKxZYSdZfewt5mHsvOk68VfNKzMQveibGLM+qunV6mOMw@mail.gmail.com>
 <20120314220150.GA15464@redhat.com>
 <20120315172746.GC8638@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120315201732.GA23403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52185 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275Ab2COW75 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Mar 2012 18:59:57 -0400
Received: by iagz16 with SMTP id z16so4510978iag.19
        for <linux-scsi@vger.kernel.org>; Thu, 15 Mar 2012 15:59:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120315201732.GA23403@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, lsf-pc@lists.linux-foundation.org, nauman@google.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>

On Thu, Mar 15, 2012 at 04:17:32PM -0400, Mike Snitzer wrote:
> Your interest should be in getting the hard work you've put into bcache
> upstream.  That's unlikely to happen until you soften on your reluctance
> to embrace existing appropriate kernel interfaces.

I don't really care what you think my priorities should be. I write code
first and foremost for myself, and the one thing I care about is good
code.

I'd love to have bcache in mainline, seeing more use and getting more
improvements - but if that's contingent on making it work through dm,
sorry, not interested.

If you want to convince me that dm is the right way to go you'll have
much better luck with technical arguments.

Besides which, I'm planning on (and very soon going to be working on)
growing bcache down into an FTL and up into the bottom half of a
filesystem. As far as I can tell integrating with dm would only get in
the way of that.

It's actually not as crazy as it sounds - the basic idea is to make the
index the central abstraction, and allocation policies sit conceptually
underneath and are abstracted out - and sitting top, some filesystem
code (and possibly other things) uses the existing code as if it were
some kind of object storage like thing; the existing bcache code maps
inode number:offset -> lba instead of cached device:offset.

I'll explain more at LSF, but eventually it ought to look vaguely like
btrfs/zfs but with better abstraction and better performance.

> > Frankly, my biggest complaint with the DM is that the code is _terrible_
> > and very poorly documented. It's an inflexible framework that tries to
> > combine a bunch of things that should be orthogonal. My other complaints
> > all stem from that; it became very clear that it wasn't designed for
> > creating a block device from the kernel, which is kind of necessary (at
> > least the only sane way of doing it, IMO) when metadata is managed by
> > the kernel (and the kernel has to manage most metadata for bcache).
> 
> Baseless and unspecific assertions don't help your cause -- dm-thinp
> disproves your unconvincing position (manages it's metadata in kernel,
> etc).

I'm not the only one who's read the dm code and found it lacking - and
anyways, I'm not really out to convince anyone. 

> Seems pretty clear you could care less about _really_ working together
> -- maybe it is just this DM/kernel interface thing gets you down.

Dude, I reached out to dm developers ages ago. Maybe if you guys had
shown some interest we wouldn't be having this conversation now.

This finger pointing is ridiculous and getting us nowhere.

> Regardless, the burden is on me (and all developers who have a desire to
> see a caching/HSM driver get upstream) to evaluate bcache.  That process
> has started -- hopefully it'll be as simple as:
> 
> 1) put a DM target wrapper in place of your sysfs interface.
> 2) switch/port bcache's btree over to drivers/md/persistent-data/
> 3) dm-bcache FTW

Replacing bcache's persistent metadata code? Hah. That's the central
part of the design!

Is this the way new filesystems are evaluated? No, it's not. What makes
you more special than ext4?

> One could dream.
> 
> The little bit I've looked at bcache it already seems unrealistic; for
> starters you have the btree wired directly to bio submission.
> drivers/md/persistent-data/ offers a layered approach,
> dm-block-manager.c brokers the IO submission (via dm-bufio) so the
> management of the btree(s) doesn't need to be concerned with actual IO.
> 
> bcache is _very_ tightly coupled with your btree implementation.

Yes, it is! It really has to be, efficiently allocating buckets and
invalidating cached data relies on specific details of the btree
implementation.

The btree is _central_ to bcache, ignoring that the rest of the code
isn't all that interesting.

> > > That said, it is frustrating that you are content to continue doing your
> > > own thing because I'm now tasked with implementing a DM target for
> > > caching/HSM, as I touched on here:
> > > http://www.redhat.com/archives/linux-lvm/2012-March/msg00007.html
> > 
> > Kind of presumptuous, don't you think?
> 
> Not really, considering what I'm responding to at the moment ;)

Maybe you should consider how you word things...

> > I've nothing at all against collaborating, or you or other dm devs
> > adapting bcache code - I'd help out with that!
> 
> OK.
> 
> > But I'm just not going to write my code a certain way just to suit you.
> 
> upstream kumbaya: more cooperative eyes on the problem, working to hook
> into established interfaces, will produce a solution that is worthy of
> upstream inclusion.

Let me be clear: All I care about is the best solution. I'm more than
happy to work with other people to achieve that, but I don't give a damn
about anything else.

> > Look forward to seeing the benchmarks.
> 
> Speaking of which, weren't you saying you'd show bcache benchmarks in a
> previous LKML thread?

Yeah I did, but as usual I got distracted. I'm travelling for the next
three weeks, but maybe I can get someone else to get some numbers that
we can publish...
