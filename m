From: Greg KH <gregkh@suse.de>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Wed, 26 Mar 2008 20:52:57 -0700
Message-ID: <20080327035257.GB9566@suse.de>
References: <ablib-2zv-65@gated-at.bofh.it> <abn0B-735-35@gated-at.bofh.it> <abna7-7jK-3@gated-at.bofh.it> <abo6b-11J-9@gated-at.bofh.it> <aboSP-2Wf-29@gated-at.bofh.it> <aboSP-2Wf-27@gated-at.bofh.it> <abqrq-6eX-29@gated-at.bofh.it> <abqrq-6eX-27@gated-at.bofh.it> <abqKM-6Ka-13@gated-at.bofh.it> <E1JeTq5-00018y-MO@be1.7eggert.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:33963 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYC0ECA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 00:02:00 -0400
Content-Disposition: inline
In-Reply-To: <E1JeTq5-00018y-MO@be1.7eggert.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bodo Eggert <7eggert@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Mar 26, 2008 at 12:30:40PM +0100, Bodo Eggert wrote:
> Greg KH <gregkh@suse.de> wrote:
> > On Tue, Mar 25, 2008 at 04:05:32PM -0700, H. Peter Anvin wrote:
> 
> >>> How does this have anything to do with boot times?  Do you really have a
> >>> foolish shell script that iteratorates over every single disk in the
> >>> sysfs tree for every disk?  What does it do that for?
> >>
> >> Any time you want to get the sysfs information for a filesystem which is
> >> already mounted, that's what you're forced to do.
> >>
> >>> I thought we were talking about 2TB disks here, with a proposed new
> >>> ioctl, not foolishness of boot scripts...
> >>
> >> I pointed out that having a way to map device numbers to sysfs directories
> >> would have the same effect, *and* would be usable for other purposes.  I'd
> >> rather see that than a new ioctl, and another, and another...
> > 
> > Again, a simple udev rule will give you that today if you really want
> > it...
> 
> So e.g. lilo should depend on sysfs and *a*special*configuration* of udev,
> while the admin MUST NOT use mknod'ed device files nor manually create
> symlinks pointing to them, and not use relative path names?
> That's plain stupid.

If sysfs is stupid, then use an ioctl, have I objected to that?

> > And I think 'udevinfo' can be used to retrieve this information as well.
> 
> $ udevinfo /dev/hda
> missing option
> $ udevinfo /dev/hda --help
> Usage: udevinfo OPTIONS
>   --query=<type>    query database for the specified value:
>     name            name of device node
>     symlink         pointing to node
>     path            sysfs device path
>     env             the device related imported environment
>     all             all values
> 
>   --path=<devpath>  sysfs device path used for query or chain
>   --name=<name>     node or symlink name used for query
> 
>   --root            prepend to query result or print udev_root
>   --attribute-walk  print all SYSFS_attributes along the device chain
>   --export-db       export the content of the udev database
>   --help            print this text
> $ udevinfo --name=/dev/hda
> missing option
> $ udevinfo --name=/dev/hda --query=all
> P: /block/hda
> N: hda
> S: disk/by-id/ata-Maxtor_2F040L0_F1748ZQE
> S: disk/by-path/pci-0000:00:0f.0-ide-0:0
> E: DEVTYPE=disk
> E: ID_TYPE=disk
> E: ID_MODEL=Maxtor_2F040L0
> E: ID_SERIAL=F1748ZQE
> E: ID_REVISION=VAM51JJ0
> E: ID_BUS=ata
> E: ID_PATH=pci-0000:00:0f.0-ide-0:0
> 
> 
> As you can see, it gives no major:minor information. But it is in the DB:

That should be easy to add, no one has ever asked for this information
from udevinfo before.  If it's needed, it can be provided.

> $ cd /dev/.udev/db
> $ grep -l hda * 2>/dev/null
> \x2fblock\x2fhda
> \x2fblock\x2fhda\x2fhda1
> $ cat "\x2fblock\x2fhda"
> N:hda
> S:disk/by-id/ata-Maxtor_2F040L0_F1748ZQE
> S:disk/by-path/pci-0000:00:0f.0-ide-0:0
> M:3:0
> E:DEVTYPE=disk
> E:ID_TYPE=disk
> E:ID_MODEL=Maxtor_2F040L0
> E:ID_SERIAL=F1748ZQE
> E:ID_REVISION=VAM51JJ0
> E:ID_BUS=ata
> E:ID_PATH=pci-0000:00:0f.0-ide-0:0
> 
> What a great tool - for making linux look bad.

Your constructive criticism is greatly appreciated, please continue.
