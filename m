From: Jan Kara <jack@suse.cz>
Subject: Re: Proposal for annotating _unstable_ pages
Date: Thu, 21 May 2015 21:21:12 +0200
Message-ID: <20150521192112.GA2665@quack.suse.cz>
References: <20150515205825.GC24967@birch.djwong.org>
 <20150519154200.GA2559@kmo-pixel>
 <20150519201055.GD27115@birch.djwong.org>
 <20150521010440.GA17405@kmo-pixel>
 <20150521165453.GK27863@quack.suse.cz>
 <20150521180954.GA27397@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbbEUTVQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 May 2015 15:21:16 -0400
Content-Disposition: inline
In-Reply-To: <20150521180954.GA27397@kmo-pixel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-btrfs@vger.kernel.org, axboe@fb.com, zab@zabbo.net, neilb@suse.de

On Thu 21-05-15 11:09:55, Kent Overstreet wrote:
> On Thu, May 21, 2015 at 06:54:53PM +0200, Jan Kara wrote:
> > On Wed 20-05-15 18:04:40, Kent Overstreet wrote:
> > > > Yeah.  I never figured out a sane way to migrate pages and keep everything
> > > > else happy.  Daniel Phillips is having a go at page forking for tux3; let's
> > > > see if the questions about that get resolved.
> > > 
> > > That would be great, we need something.
> > > 
> > > I'd also be really curious what btrfs is doing today - is it just bouncing
> > > everything internally, or did they come up with something more clever?
> > 
> > Btrfs is just waiting for IO to complete.
> > 
> > > > > Also, there's probably always going to be situations where we're reading or
> > > > > writing to pages user space can stomp on (dio) - IMO we need to add a bio flag
> > > > > to annotate this - "if you need this to be stable you have to bounce it".
> > > > > Otherwise either filesystems/block drivers are going to be stuck bouncing
> > > > > everything, or it'll just (continue to be) buggy.
> > > > 
> > > > Well, for now there's BIO_SNAP_STABLE that forces the block layer to bounce it,
> > > > but right now ext3 is the last user of it, and afaict btrfs is the only other
> > > > FS that takes care of stable pages on its own.
> > > 
> > > I have no idea what BIO_SNAP_STABLE was supposed to be for, but I don't see how
> > > it's useful for anything sane.
> > 
> > It's for the case where lower layer requests it needs stable pages but
> > upper layer isn't able to provide them (as is the case of ext3). Then block
> > layer bounces the data for the caller.
> > 
> > > But that's the complete opposite of the problem stable pages are supposed to
> > > solve: stable pages are for when the _lower_ layer (be it filesystem, bcache,
> > > md, lvm) needs the memory being either read to or written from (both, it's not
> > > just writes) to not be diddled over while the IO is in flight.
> > > 
> > > Now, a point that I think has been missed is that stable pages are _not_ a
> > > complete solution, at least for consumers in the block layer.
> > > 
> > > The situation today is that if I'm in the block layer, and I get a handed a read
> > > or write bio, I _don't know_ if it's from something that's going to diddle over
> > > those pages or not. So if I require stable pages - be it for data checksumming
> > > or for other things - I've just got to bounce the bio myself.
> > > 
> > > And then the really annoying thing is that if you've got stacked things that all
> > > need stable pages (maybe btrfs on top of bcache on top of md) - they _all_ have
> > > to assume the pages aren't going to be stable, so if they need them they _all_
> > > have to bounce - even though once the first layer bounced the bio that made it
> > > stable for everything underneath it.
> > 
> > The current design is that if you need stable pages for your device, set
> > bdi capability BDI_CAP_STABLE_WRITES, fs then takes care of not scribbling
> > over your page while it is under writeback or uses BIO_SNAP_STABLE if it
> > cannot.
> 
> But if I need stable pages, I still have to bounce because that _does not_
> guarantee stable pages, it only gives me stable pages for some of the IOs and in
> the lower layers you can't tell which is which.
> 
> Do you see the problem? What good is BDI_CAP_STABLE_WRITES if it's not a
> guarantee and I can't tell if I need to bounce or not?
  So fix the upper layers to make it a guarantee? You mentioned direct IO
needs fixing. Anything else?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
