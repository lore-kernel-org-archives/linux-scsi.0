From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 25 Mar 2008 12:32:15 -0700
Message-ID: <1206473536.3273.14.camel@localhost.localdomain>
References: <47E875AD.1000901@rtr.ca>  <47E87942.2020409@rtr.ca>
	 <1206458278.3273.5.camel@localhost.localdomain>  <47E936E5.7090506@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47E936E5.7090506@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-03-25 at 13:31 -0400, Mark Lord wrote:
> James Bottomley wrote:
> > On Tue, 2008-03-25 at 00:02 -0400, Mark Lord wrote:
> >..
> >> Practically all utilities that care about it,
> >> use ioctl(fd, HDIO_GETGEO) to determine the starting
> >> sector offset of a hard disk partition.
> ..
> > Perhaps I've missed something, but surely geometry doesn't make sense on
> > a >2TB drive does it?  The only reason we use it on modern disks (which
> > usually make it up specially for us) is that the DOS partition scheme
> > requires it.  Once we're over 2TB, isn't it impossible to use DOS
> > partitions (well, OK, unless you increase the sector size, but that's
> > only delaying the inevitable), so we can just go with a proper disk
> > labelling scheme and use BLKGETSIZE64 all the time.
> ..
> 
> I haven't thought much about problems with the virtual geometry,
> because, as you say, we really don't care about it for the most part.
> We use LBA values from the partition tables rather than CHS.
> I suppose those also likely to be 32-bit limited.
> 
> The "partition offset", or "starting sector" is the important
> bit of information for most things.  And that's currently available
> from HDIO_GETGEO, and from /sys/block/XXX/XXXn/start, if sysfs is mounted.
> 
> We just need an easy way to get it, given a dev_t from stat(2).
> Currently there isn't an easy way, and HDIO_GETGEO returns
> only 32-bits on a 32-bit system.

But I think where this is leading is that you've been using the geometry
call, but all you really want to know is the actual partition start in
sector units, so a new BLKGETPARTSTART (or something) ioctl that was
designed to return a u64 would work for you?  That sounds reasonable to
me; so not a HDIO_GETGEO64 which gets us into trouble with geometries,
but a simple ioctl that gives you exactly what you're looking for.

James


