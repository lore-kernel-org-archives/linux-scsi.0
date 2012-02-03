From: Wu Fengguang <fengguang.wu@gmail.com>
Subject: Re: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Fri, 3 Feb 2012 20:55:43 +0800
Message-ID: <20120203125543.GA13410@localhost>
References: <20120124190732.GH4387@shiny>
 <x49vco0kj5l.fsf@segfault.boston.devel.redhat.com>
 <20120124200932.GB20650@quack.suse.cz>
 <x49pqe8kgej.fsf@segfault.boston.devel.redhat.com>
 <20120124203936.GC20650@quack.suse.cz>
 <20120125032932.GA7150@localhost>
 <F6F2DEB8-F096-4A3B-89E3-3A132033BC76@dilger.ca>
 <1327502034.2720.23.camel@menhir>
 <D3F292ADF945FB49B35E96C94C2061B915A638A6@nsmail.netscout.com>
 <1327509623.2720.52.camel@menhir>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48902 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2BCMzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2012 07:55:55 -0500
Content-Disposition: inline
In-Reply-To: <1327509623.2720.52.camel@menhir>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: "Loke, Chetan" <Chetan.Loke@netscout.com>, Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, neilb@suse.de, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Boaz Harrosh <bharrosh@panasas.com>, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, Chris Mason <chris.mason@oracle.com>, "Darrick J.Wong" <djwong@us.ibm.com>, Dan Magenheimer <dan.magenheimer@oracle.com>

On Wed, Jan 25, 2012 at 04:40:23PM +0000, Steven Whitehouse wrote:
> Hi,
> 
> On Wed, 2012-01-25 at 11:22 -0500, Loke, Chetan wrote:
> > > If the reason for not setting a larger readahead value is just that it
> > > might increase memory pressure and thus decrease performance, is it
> > > possible to use a suitable metric from the VM in order to set the value
> > > automatically according to circumstances?
> > > 
> > 
> > How about tracking heuristics for 'read-hits from previous read-aheads'? If the hits are in acceptable range(user-configurable knob?) then keep seeking else back-off a little on the read-ahead?
> > 
> > > Steve.
> > 
> > Chetan Loke
> 
> I'd been wondering about something similar to that. The basic scheme
> would be:
> 
>  - Set a page flag when readahead is performed
>  - Clear the flag when the page is read (or on page fault for mmap)
> (i.e. when it is first used after readahead)
> 
> Then when the VM scans for pages to eject from cache, check the flag and
> keep an exponential average (probably on a per-cpu basis) of the rate at
> which such flagged pages are ejected. That number can then be used to
> reduce the max readahead value.
> 
> The questions are whether this would provide a fast enough reduction in
> readahead size to avoid problems? and whether the extra complication is
> worth it compared with using an overall metric for memory pressure?
> 
> There may well be better solutions though,

The caveat is, on a consistently thrashed machine, the readahead size
should better be determined for each read stream.

Repeated readahead thrashing typically happen in a file server with
large number of concurrent clients. For example, if there are 1000
read streams each doing 1MB readahead, since there are 2 readahead
window for each stream, there could be up to 2GB readahead pages that
will sure be thrashed in a server with only 1GB memory.

Typically the 1000 clients will have different read speeds. A few of
them will be doing 1MB/s, most others may be doing 100KB/s. In this
case, we shall only decrease readahead size for the 100KB/s clients.
The 1MB/s clients actually won't see readahead thrashing at all and
we'll want them to do large 1MB I/O to achieve good disk utilization.

So we need something better than the "global feedback" scheme, and we
do have such a solution ;)  As said in my other email, the number of
history pages remained in the page cache is a good estimation of that
particular read stream's thrashing safe readahead size.

Thanks,
Fengguang
