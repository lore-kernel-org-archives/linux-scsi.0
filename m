From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 21:09:32 +0100
Message-ID: <20120124200932.GB20650@quack.suse.cz>
References: <20120123161857.GC28526@quack.suse.cz>
 <20120123175353.GD30782@redhat.com>
 <x49r4yq9suf.fsf@segfault.boston.devel.redhat.com>
 <20120124151504.GQ4387@shiny>
 <20120124165631.GA8941@infradead.org>
 <186EA560-1720-4975-AC2F-8C72C4A777A9@dilger.ca>
 <x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com>
 <20120124184054.GA23227@infradead.org>
 <20120124190732.GH4387@shiny>
 <x49vco0kj5l.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49vco0kj5l.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>, Andreas Dilger <adilger@dilger.ca>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, "neilb@suse.de" <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, fengguang.wu@gmail.com, Boaz Harrosh <bharrosh@panasas.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "Darrick J.Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue 24-01-12 14:14:14, Jeff Moyer wrote:
> Chris Mason <chris.mason@oracle.com> writes:
> 
> >> All three filesystems use the generic mpages code for reads, so they
> >> all get the same (bad) I/O patterns.  Looks like we need to fix this up
> >> ASAP.
> >
> > Can you easily run btrfs through the same rig?  We don't use mpages and
> > I'm curious.
> 
> The readahead code was to blame, here.  I wonder if we can change the
> logic there to not break larger I/Os down into smaller sized ones.
> Fengguang, doing a dd if=file of=/dev/null bs=1M results in 128K I/Os,
> when 128KB is the read_ahead_kb value.  Is there any heuristic you could
> apply to not break larger I/Os up like this?  Does that make sense?
  Well, not breaking up I/Os would be fairly simple as ondemand_readahead()
already knows how much do we want to read. We just trim the submitted I/O to
read_ahead_kb artificially. And that is done so that you don't trash page
cache (possibly evicting pages you have not yet copied to userspace) when
there are several processes doing large reads.

Maybe 128 KB is a too small default these days but OTOH noone prevents you
from raising it (e.g. SLES uses 1 MB as a default).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
