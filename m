From: Doug Ledford <dledford@redhat.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Fri, 25 Oct 2002 00:06:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021025040659.GB3556@redhat.com>
References: <3DB8A0CC.1804DF79@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DB8A0CC.1804DF79@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Jens Axboe <axboe@suse.de>

On Thu, Oct 24, 2002 at 06:39:24PM -0700, Andrew Morton wrote:
> 
> Gents,
> 
> we have some code in the -mm patchsets which adds a per-cpu
> LIFO pool which frontends the page allocator.  To return pages
> which are cache-warm on the calling CPU.
> 
> That code has been stable and unchanging since 2.5.40.  But in
> 2.5.44, Badari's machines are crashing when those patches are
> applied.  Memory corruption deep in the scsi softirq callbacks.
> 
> There were no significant memory allocator changes between 2.5.43
> and 2.5.44, but there were a lot of scsi changes.

[ snip ]

Sorry I haven't been able to do anything since Tuesday and won't be able 
to again until next week around Wednesday or so (company meeting stuff the 
entire time :-(

Anyway, I've got all my current updates pushed to
linux-scsi.bkbits.net/scsi-misc-2.5 and I know James and Patrick have some
fixes in there as well.  I also know someone has been changing around the
scsi merge function and the scsi init io function recently, and it hasn't
been me ;-)  In any case, the thing appears to be leaking memory and might
be partially related to this problem.  If you touch any device on the scsi
bus such that it results in an actual merge between two requests, and a sg
table has to be realloced to a larger size in order to accomodate the
combined sg table size, then it appears that the smaller table(s) are
leaked.  Just try hitting the disk with an e2fsck or similar program and
then try unloading the complete scsi stack to see the failure on attempt
to free the sg table caches when unloading scsi_mod.  Debugging takes a
bit too since it means you have to reboot the machine to be able to load
the scsi modules again :-/ If someone could look into that specific
problem it might give a clue into this other problem (and sorry I can't do
more about it myself right now, it's what I was just starting to look into
when I ran out of time and into meetings).

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
