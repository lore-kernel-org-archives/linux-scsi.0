From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 user per-device spare command
Date: Fri, 25 Apr 2003 09:37:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425093718.A8776@beaverton.ibm.com>
References: <20030424100229.A32098@beaverton.ibm.com> <20030424100317.A32134@beaverton.ibm.com> <20030425111227.B28577@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:5617 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S263459AbTDYQ3Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 12:29:16 -0400
Content-Disposition: inline
In-Reply-To: <20030425111227.B28577@infradead.org>; from hch@infradead.org on Fri, Apr 25, 2003 at 11:12:27AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Christoph -

On Fri, Apr 25, 2003 at 11:12:27AM +0100, Christoph Hellwig wrote:
> On Thu, Apr 24, 2003 at 10:03:17AM -0700, Patrick Mansfield wrote:
> > Patch against scsi-misc-2.5
> > 
> > Use a per-device spare command rather than a per-host spare.
> 
> Why?  This means we'll have a much bigger number of spare commands
> around.

So we are guaranteed to be able to have at least one IO in flight for all
devices. With a per-host spare, some device(s) might have to wait
(generally polling based on an interval dependent on whatever blk_plug_device
gives us) for a command to become available, and it is not clear what the
IO behaviour - especially for swap - will be in such cases.

It simplifies the code, and allows removal of a lock from the IO
completion path.

[I'm not sure what happens for swap striping or md. Is swap stripe size
always a multiple of the page size?  So one IO completion to a swap device
(striped or not) is guaranteed to free up at least one page? What about
users putting swap on top of md, RAID-0 or RAID-5? Is this not allowed,
or considered a dumb configuration?]

For systems with one disk we are better off (than with a per host spare) -
we have one spare, we always use it, and we don't allocate or use the per
host free_list_lock.

For larger numbers of disks, if we normally have IO in flight to all
devices, there is not much difference. Generally, we have one extra
command per device that does not have IO in flight.

Ideally we should have some sysfs attribute to specify whether a spare (or
spares) is needed or not, default to no spare, and then have some user
land method to normally add a spare for any scsi swap devices (maybe
swapon?).

But, a sysfs attribute (one inode) would use almost as much memory as the
spare command itself (340 bytes, but should be smaller), and adds a bit of
code to the put case. (we could save almost as much memory as we are
allocating for the spare just by removing for example the scsi "rev" sysfs
attribute, or even more by exposing all of the inquiry as a binary file).

If the sysfs attributes were lighter, something lighter is available, or
general sentiment is to just go ahead and use a sysfs attribute, I can
change the code to use it. (I don't think having more than one spare per
device is useful.)

> > +	/*
> > +	 * Use any spare command first.
> > +	 */
> > +	cmd = sdev->spare_cmd;
> > +	if (cmd != NULL)
> > +		sdev->spare_cmd = NULL;
> > +	else 
> > +		cmd = kmem_cache_alloc(sdev->host->cmd_pool->slab,
> > +				gfp_mask | sdev->host->cmd_pool->gfp_mask);
> 
> This logical is flawed.  We don't need a spare command if we always use
> it first.  In addition the sdev->spare_cmd access is racy.

I had originally coded it to only use the spare on failure of the cache,
but then we would normally never use the spare (similiar to our per-host
spare today).

The sdev->sdev_lock (i.e. queue_lock) protects access to sdev->spare_cmd.

-- Patrick Mansfield
