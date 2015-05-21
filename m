From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Proposal for annotating _unstable_ pages
Date: Wed, 20 May 2015 18:04:40 -0700
Message-ID: <20150521010440.GA17405@kmo-pixel>
References: <20150515205825.GC24967@birch.djwong.org>
 <20150519154200.GA2559@kmo-pixel>
 <20150519201055.GD27115@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150519201055.GD27115@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-btrfs@vger.kernel.org, axboe@fb.com, zab@zabbo.net, neilb@suse.de
List-Id: linux-scsi@vger.kernel.org

On Tue, May 19, 2015 at 01:10:55PM -0700, Darrick J. Wong wrote:
> On Tue, May 19, 2015 at 08:42:00AM -0700, Kent Overstreet wrote:
> > Also, stable pages - what's been going on there? Last I heard you were talking
> > about using the page migration code to do COW, did anything come of that? I just
> > added data checksumming/compression to bcachefs, so that's been fresh on my
> > mind.
> 
> Yeah.  I never figured out a sane way to migrate pages and keep everything
> else happy.  Daniel Phillips is having a go at page forking for tux3; let's
> see if the questions about that get resolved.

That would be great, we need something.

I'd also be really curious what btrfs is doing today - is it just bouncing
everything internally, or did they come up with something more clever?

> > Also, there's probably always going to be situations where we're reading or
> > writing to pages user space can stomp on (dio) - IMO we need to add a bio flag
> > to annotate this - "if you need this to be stable you have to bounce it".
> > Otherwise either filesystems/block drivers are going to be stuck bouncing
> > everything, or it'll just (continue to be) buggy.
> 
> Well, for now there's BIO_SNAP_STABLE that forces the block layer to bounce it,
> but right now ext3 is the last user of it, and afaict btrfs is the only other
> FS that takes care of stable pages on its own.

I have no idea what BIO_SNAP_STABLE was supposed to be for, but I don't see how
it's useful for anything sane.

I'm _guessing_ it's to get atomic snapshots? But if the upper layer is modifying
the data being written while the write is in flight, the memcpy() for the bounce
still isn't going to be atomic. If the upper layer cares about atomicity, it
needs to not diddle over the memory its writing while the write is in flight.

But that's the complete opposite of the problem stable pages are supposed to
solve: stable pages are for when the _lower_ layer (be it filesystem, bcache,
md, lvm) needs the memory being either read to or written from (both, it's not
just writes) to not be diddled over while the IO is in flight.

Now, a point that I think has been missed is that stable pages are _not_ a
complete solution, at least for consumers in the block layer.

The situation today is that if I'm in the block layer, and I get a handed a read
or write bio, I _don't know_ if it's from something that's going to diddle over
those pages or not. So if I require stable pages - be it for data checksumming
or for other things - I've just got to bounce the bio myself.

And then the really annoying thing is that if you've got stacked things that all
need stable pages (maybe btrfs on top of bcache on top of md) - they _all_ have
to assume the pages aren't going to be stable, so if they need them they _all_
have to bounce - even though once the first layer bounced the bio that made it
stable for everything underneath it.

Stable pages for IO to/from the pagecache are _not_ going to solve this problem,
because the page cache is not the only source of IO to non stable pages (Direct
IO will always be, even if everything else gets fixed).

So what I'm proposing is:

 - Add a new bio flag: BIO_PAGES_NOT_STABLE

 - Everything that submits a bio and _doesn't_ guarantee that the pages won't be
   touched while the IO is in flight has to set that flag.  This flag will have
   to be preserved when cloning a bio, but not when cloning a bio and its pages
   (i.e. bouncing it).

This is going to be a lot of not-fun work auditing code, but IMO it really needs
to be done. As a bonus, once it's done everything that generates IO that must be
expensively bounced will be nicely annotated.

To verify that the annotations are correct, for writes we can add some debug
code to the generic IO path that checksums the data before and after the IO and
complains loudly if the checksums don't match. Dunno what we can do for reads.

Thoughts?
