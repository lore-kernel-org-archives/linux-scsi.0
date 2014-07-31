From: scameron@beardog.cce.hp.com
Subject: Re: [RFC] hpsa: work in progress "lockless monster" patches
Date: Thu, 31 Jul 2014 11:35:25 -0500
Message-ID: <20140731163525.GC14599@beardog.cce.hp.com>
References: <20140725192859.GU14599@beardog.cce.hp.com> <53D519BE.9000204@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:40717 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaGaQgk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2014 12:36:40 -0400
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 2A33E64AB5
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2014 16:36:37 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <53D519BE.9000204@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, martin.petersen@oracle.com, thenzl@redhat.com, hch@infradead.org, bvanassche@acm.org, axboe@kernel.dk, elliott@hp.com, scott.teel@hp.com, webbnh@hp.com, joseph.t.handzik@hp.com, justin.lindley@hp.com, scameron@beardog.cce.hp.com

On Sun, Jul 27, 2014 at 05:24:46PM +0200, Hannes Reinecke wrote:
> On 07/25/2014 09:28 PM, scameron@beardog.cce.hp.com wrote:
> >
> >hpsa: Work In Progress: "lockless monster" patches
> >
> >To be clear, I am not suggesting that these patches be merged at this time.
> >
> >This patchset is vs. Christoph Hellwig's scsi-mq.4 branch which
> >may be found here: git://git.infradead.org/users/hch/scsi.git
> >
> >We've been working for a long time on a patchset for hpsa to remove
> >all the locks from the main i/o path in pursuit of high IOPS.  Some
> >of that work is already upstream, but a lot more of it is not quite
> >yet ready to be merged.  However, I think we've "gone dark" for a bit
> >too long on this, and even though the patches aren't really ready to
> >be merged just yet, I thought I should let other people who might be
> >interested have a look anyway, as things are starting to be at least
> >more stable than unstable.  Be warned though, there are still some
> >problems, esp. around error recovery.
> >
> >That being said, with the right hardware (fast SAS SSDs, recent Smart
> >Arrays e.g. P430, with up-to-date firmware, attached to recent disk 
> >enclosures)
> >with these patches and the scsi-mq patches, it is possible to get around
> >~970k IOPS from a single logical drive on a single controller.
> >
> >There are about 150 patches in this set.  Rather than bomb the list
> >with that, here is a link to a tarball of the patches in the form of
> >an stgit patch series:
> >
> >https://github.com/smcameron/hpsa-lockless-patches-work-in-progress/blob/master/hpsa-lockless-vs-hch-scsi-mq.4-2014-07-25-1415CDT.tar.bz2?raw=true
> >
> >In some cases, I have probably erred on the side of having too many too
> >small patches, on the theory that it is easier to bake a cake than to
> >unbake a cake.  Before these are submitted "for reals", there will be
> >some squashing of patches, along with other cleaning up.
> >
> >There are some patches in this set which are already upstream in
> >James's tree which do not happen to be in Christoph's tree
> >(most of which are named "*_sent_to_james").  There are also
> >quite a few patches which are strictly for debugging and are not
> >ever intended to be merged.
> >
> Hmm. While you're about to engage on a massive rewrite _and_ we're 
> having 64bit LUN support now, what about getting rid of the weird 
> internal LUN mapping? That way you would get rid of this LUN rescan 
> thingie and the driver would look more sane.

Sorry for my slow reply to this.

I can sympathize with this desire, the device scanning code in the driver
is not my favorite, and it can undoubtedly be improved.  However, there
are some problems.

> Plus the REPORT LUN command would actually return the correct data ...

No, it wouldn't.  Smart Arrays are unfortunately pretty weird.

SCSI REPORT LUNS issued to a smart array will report only the logical
drives.  No physical devices (tape drives, etc.) will be reported.

Instead of SCSI REPORT LUNS, the driver uses a couple of proprietary
variants of this, CISS_REPORT_LOGICAL and CISS_REPORT_PHYSICAL, which
report logical drives and physical devices, and have their own oddities.

And it gets weirder.  This will require some exposition, so bear with me.

What's driving this giant patchball to remove locks from the driver is SSDs.
Suddenly, the assumption that disks are dirt slow relative to the host is not
quite so true anymore.  Smart Array looks something like this:

               +---------------+
               | host          |
               +---------+-----+
                         |
                         | PCI bus
                         |
               +---------|------------------+
               |         |                  |
               |         +--RAID stack      |<--- smart array
               |            running on      |
               |            embedded system |
               |            on PCI board    |
               |                 |          |
               |-----------------|----------|
               |                 |          |
               |  Back end firmware         |
               |            |               |
               +------------|---------------+
                            |
                            | SAS
                            |
               +----------------------------------+
               | physical devices (disks, etc.)   |
               +----------------------------------+

with the advent of SSDs, it turns out the RAID stack firmware
running on the little embedded system on the PCI board becomes
a bottleneck and hurts performance.

It turns out that with a (significant) firmware change, we
can do something like this:

               +---------------+
               | host          |
               +--------+------+
                        |
                        | PCI bus
                        |
               +--------|-------------------+
               |        |                   |
               |   +---/ \--RAID stack      |<--- smart array
               |   |        running on      |
               |   |        embedded system |
               |   |        on PCI board    |
               |   |             |          |
               |---|-------------|----------|
               |   |             |          |
               |  Back end firmware         |
               |            |               |
               +------------|---------------+
                            |
                            | SAS
                            |
               +----------------------------------+
               | physical devices (disks, etc.)   |
               +----------------------------------+

That is, a few new registers can be made to allow the host to 
submit commands directly to the "back end" of the smart array
bypassing the RAID stack part.  Now, if the host has an idea about
the layout of various RAID volumes, it can examine i/o requests,
look at the LBA ranges, and if it turns out that a particular
i/o request has an LBA range on the logical drive that translates
to an LBA range on a single physical disk, then we can bypass the
RAID stack and send the i/o down this 2nd path to the physical
device in a more direct way, and get a _significant_ performance
boost.  It turns out that there are a couple different backends,
and the firmware changes to expose these to host cannot be done
in a way that makes these paths identical to each other, so you
end up with a couple different ways to do this (these are the
"ioaccel1" and "ioaccel2" that you see in this patch set.)

What about error handling?  Let's say you have a RAID5 volume, and
you determine at runtime that an i/o is reading from a single physical
disk, so you send it down this fast path right to the disk, and it
comes back with a URE?  Turn it around and send it down the RAID
stack path and let the RAID stack sort it out.

What if the RAID volume goes degraded due to a disk failure?
What if a RAID migration is underway and the mapping of logical
LBAs to physical disks and physical LBAs is changing?  What if
any of many many such scenarios are in progress?  Firmware shuts
down this alternate fast path, and driver notices (via a register
it's polling periodically) that something is changed and the
driver needs to query the device to figure out what's changed.
That is, the driver needs to do a rescan of all the devices.

There's a lot more going on in the device rescanning code now than
just discovering devices.  We are also checking to see if this alternate
fast path is enabled (controller wide, or per logical drive) and
finding (or updating) the raid map data which determines the mapping
of logical LBAs to physical disks and physical disk LBAs (driver has
essentially become *partially* a software raid driver, but only
partially.)

CISS_REPORT_PHYSICAL has an 'extended' flag which will make it
report extra information besides just the 8-byte LUNID of the 
physical devices (e.g. device type) but also, for example an
"ioaccel handle" which is just a number that is used to address
the device via the "fast path" described above.

There are other oddities, for example the way that multi-lun devices
like tape libraries are reported by CISS_REPORT_PHYSICAL, with byte 4
of the 8-byte lunid containing the lun number of the device.

So, unfortunately, this rescan code has probably become more entrenched
rather than less entrenched.

None of this is to suggest that this area of the code cannot be improved though.

-- steve

