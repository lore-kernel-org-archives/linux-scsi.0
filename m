From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Thu, 24 Oct 2002 21:07:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021024210725.A23739@eng2.beaverton.ibm.com>
References: <3DB8A0CC.1804DF79@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DB8A0CC.1804DF79@digeo.com>; from akpm@digeo.com on Thu, Oct 24, 2002 at 06:39:24PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Badari Pulavarty <pbadari@us.ibm.com>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Jens Axboe <axboe@suse.de>, Doug Ledford <dledford@redhat.com>

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
> 
> These LIFO pools have a significant sideeffect: is a CPU frees
> a page and then allocates a page it will get the same page back.
> So if some code is using some memory for a few microseconds after
> freeing it, there's a good chance that this bug will not exhibit
> with the stock kernel's allocator but _will_ exhibit when the
> per-cpu LIFO queues are present.
> 
> I'm suspecting that this is what is happening.  A use-after-free
> bug may have been introduced in the 2.5.44 SCSI changes.
> 

I hit these also with the qla + 2.5.44-mm3 + multi-path patch, I could
only hit it with file system access.

I've otherwise run fine - building kernels (not on disks attached via
the qla driver), and running tons of raw IO requests using the qla driver
with no problems at all (large block size 64k).

I had a horrible time trying to use the qla driver with switch attached
storage (with nearly identical drives/enclosures that Badari uses), and
finally gave up after having odd problems and crashes, but I only hit it
with multi-path patch installed. I went to direct attached storage (no FC
switch) and had no problems until Badari asked me to try some file 
system IO.

There were also recent comments on lkml about qla users (on 2.4) being 
unable to run qla + LVM, perhaps because of stack overflow.

Has it been hit it with something other than the qla driver, or without
file system access?

-- Patrick Mansfield
