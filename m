From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 21:39:36 +0100
Message-ID: <20120124203936.GC20650@quack.suse.cz>
References: <x49r4yq9suf.fsf@segfault.boston.devel.redhat.com>
 <20120124151504.GQ4387@shiny>
 <20120124165631.GA8941@infradead.org>
 <186EA560-1720-4975-AC2F-8C72C4A777A9@dilger.ca>
 <x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com>
 <20120124184054.GA23227@infradead.org>
 <20120124190732.GH4387@shiny>
 <x49vco0kj5l.fsf@segfault.boston.devel.redhat.com>
 <20120124200932.GB20650@quack.suse.cz>
 <x49pqe8kgej.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756790Ab2AXUjj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2012 15:39:39 -0500
Content-Disposition: inline
In-Reply-To: <x49pqe8kgej.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>, Andrea Arcangeli <aarcange@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, "neilb@suse.de" <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, fengguang.wu@gmail.com, Boaz Harrosh <bharrosh@panasas.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Chris Mason <chris.mason@oracle.com>, "Darrick J.Wong" <djwong@us.ibm.com>

On Tue 24-01-12 15:13:40, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Tue 24-01-12 14:14:14, Jeff Moyer wrote:
> >> Chris Mason <chris.mason@oracle.com> writes:
> >> 
> >> >> All three filesystems use the generic mpages code for reads, so they
> >> >> all get the same (bad) I/O patterns.  Looks like we need to fix this up
> >> >> ASAP.
> >> >
> >> > Can you easily run btrfs through the same rig?  We don't use mpages and
> >> > I'm curious.
> >> 
> >> The readahead code was to blame, here.  I wonder if we can change the
> >> logic there to not break larger I/Os down into smaller sized ones.
> >> Fengguang, doing a dd if=file of=/dev/null bs=1M results in 128K I/Os,
> >> when 128KB is the read_ahead_kb value.  Is there any heuristic you could
> >> apply to not break larger I/Os up like this?  Does that make sense?
> >   Well, not breaking up I/Os would be fairly simple as ondemand_readahead()
> > already knows how much do we want to read. We just trim the submitted I/O to
> > read_ahead_kb artificially. And that is done so that you don't trash page
> > cache (possibly evicting pages you have not yet copied to userspace) when
> > there are several processes doing large reads.
> 
> Do you really think applications issue large reads and then don't use
> the data?  I mean, I've seen some bad programming, so I can believe that
> would be the case.  Still, I'd like to think it doesn't happen.  ;-)
  No, I meant a cache thrashing problem. Suppose that we always readahead
as much as user asks and there are say 100 processes each wanting to read 4
MB.  Then you need to find 400 MB in the page cache so that all reads can
fit.  And if you don't have them, reads for process 50 may evict pages we
already preread for process 1, but process one didn't yet get to CPU to
copy the data to userspace buffer. So the read becomes wasted.

> > Maybe 128 KB is a too small default these days but OTOH noone prevents you
> > from raising it (e.g. SLES uses 1 MB as a default).
> 
> For some reason, I thought it had been bumped to 512KB by default.  Must
> be that overactive imagination I have...  Anyway, if all of the distros
> start bumping the default, don't you think it's time to consider bumping
> it upstream, too?  I thought there was a lot of work put into not being
> too aggressive on readahead, so the downside of having a larger
> read_ahead_kb setting was fairly small.
  Yeah, I believe 512KB should be pretty safe these days except for
embedded world. OTOH average desktop user doesn't really care so it's
mostly servers with beefy storage that care... (note that I wrote we raised
the read_ahead_kb for SLES but not for openSUSE or SLED (desktop enterprise
distro)).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
