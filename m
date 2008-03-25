From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 25 Mar 2008 13:45:35 -0400
Message-ID: <87f94c370803251045h46cbdc0auc541302fbad4a3b9@mail.gmail.com>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca>
	 <1206458278.3273.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1206458278.3273.5.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Mark Lord <lkml@rtr.ca>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 25, 2008 at 11:17 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2008-03-25 at 00:02 -0400, Mark Lord wrote:
>  > (resending .. forgot to copy the lists originally)
>  >
>  > We have a problem coming down the pipeline.
>  >
>  > Practically all utilities that care about it,
>  > use ioctl(fd, HDIO_GETGEO) to determine the starting
>  > sector offset of a hard disk partition.
>  >
>  > SCSI, libata, IDE, USB, Firewire.. you name it.
>  >
>  > The return value uses "unsigned long",
>  > which on a 32-bit system limits drive offsets to 2TB.
>  >
>  > There will be single drives exceeding this limit within
>  > the next 12 months or less, and we already have RAID arrays
>  > that exceed 2TB.
>  >
>  > So.. what's the replacement for HDIO_GETGEO on 32-bits ?
>  >
>  > One candidate might seem to be the existing /sys/block/dev/partition/start
>  > which I expect is already 64-bit friendly.
>  >
>  > But this requires about 150 lines of somewhat complex C code to access,
>  > using only the dev_t (from stat(2) on a file) as a starting point,
>  > or less if one relies upon the udev device name matching the sysfs device name.
>  >
>  > Is it time now for HDIO_GETGEO64 to make an appearance?
>  > Similar to how the existing BLKGETSIZE64 is supplanting BLKGETSIZE ?
>
>  Perhaps I've missed something, but surely geometry doesn't make sense on
>  a >2TB drive does it?  The only reason we use it on modern disks (which
>  usually make it up specially for us) is that the DOS partition scheme
>  requires it.  Once we're over 2TB, isn't it impossible to use DOS
>  partitions (well, OK, unless you increase the sector size, but that's
>  only delaying the inevitable), so we can just go with a proper disk
>  labelling scheme and use BLKGETSIZE64 all the time.
>

I believe GUID Partition Tables (GPTs) are the answer.

I believe one of the features of GPT is the elimination of the 32-bit
sector restrictions.

http://en.wikipedia.org/wiki/GUID_Partition_Table

Windows VISTA 64-bit supports GPTs on data disks and new Mac OS based
systems have been using it on internal drives for a couple years at
least.

GPTs are part of the Extensible Firmware Interface (EFI), so they
should be usable for PC bootable disks at some point.  (Maybe now in
some cases?)

I'm not sure what the Linux Kernel support is for GPTs.

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
