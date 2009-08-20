From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Management Ioctls Revisited
Date: Thu, 20 Aug 2009 16:23:42 -0600
Message-ID: <1250807022.4302.163.camel@mulgrave.site>
References: <b1bc6a000908191515yef38d4bxaeca8e6e3c761237@mail.gmail.com>
	 <b1bc6a000908201152s154ca680h14741dbfdaedcd01@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48570 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbZHTWXx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 18:23:53 -0400
In-Reply-To: <b1bc6a000908201152s154ca680h14741dbfdaedcd01@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Mukker, Atul" <Atul.Mukker@lsi.com>, bruce.allen@aei.mpg.de, Christoph Hellwig <hch@infradead.org>

On Thu, 2009-08-20 at 11:52 -0700, adam radford wrote:
> On Wed, Aug 19, 2009 at 3:15 PM, adam radford<aradford@gmail.com> wrote:
> > Linus,
> >
> > There seem to be quite a few new SCSI drivers being submitted to the
> > Linux kernel where the driver
> > authors have tried to implement a management interface ioctl(), only
> > to have it bounced out, without a
> > clear explanation of why it was not allowed.   There are often ramblings
> > about how it is 'hard to tell which ioctl crashed the system', etc.
> >
> > We have some custom ioctl interfaces in the 3w-9xxx and 3w-xxxx SCSI
> > drivers used by the open source
> > 'smartmontools' package to read smart data from the individual DISKS
> > underneath a RAID array.
> >
> > When we submit new driver support for our 6GB SAS-RAID card, a driver
> > with this (already tried and tested) interface apparently won't
> > be accepted.
> >
> > Should we re-write large parts of smartmontools (that are already
> > working and rock solid) to use a new
> > sysfs interface?  Is that really going to make it somehow 'better' or
> > more secure?  Isn't the whole point of sysfs 'one value per file' ?
> > We have a binary interface that sends back data, and bolting this onto
> > sysfs somehow doesn't seem like the right approach.
> >
> > Creating a dummy 'processor' device within the driver so we can take
> > scsi passthrough, ata passthrough, and other binary data commands
> > through /dev/sgX when there are no disks present on a RAID array seems
> > like a gigantic hack.  Processor devices are usually enclosures.
> >
> > I would like to open a discussion of this whole business of "NO NEW
> > IOCTLS".    I can see Greg KH, and others bouncing out drivers that
> > contain ioctl interfaces, and I see some of the biggest SCSI HBA
> > vendors asking what interface they should use and being told netlink,
> > sysfs, etc.
> >
> > What are the functional and security benefits of using SYSFS
> > (sysfs_create_bin_file()), and re-writing open source userspace
> > management software (like smartmontools) that already uses existing
> > ioctls in drivers VS. accepting new ioctls and enforcing
> > CAP_SYS_ADMIN(), ioctl numbering from Documentaiton/ioctl-number.txt
> > and some "__user" compiler annotations for safety?
> >
> > Will we be changing even 'fdisk' to not call BLKSSZGET, BLKRRPART,
> > etc in the future since 'ioctls are bad', or is the Linux kernel/scsi
> > community forcing these rules on driver writers only?
> >
> > -Adam
> >
> 
> James, Christoph,
> 
> Do you guys have any comments on this?

You mean beyond "I don't know where you're getting your information
from, but it doesn't seem to be entirely accurate"?

So the RAID HBA space is a total mess.  Basically every card has their
own proprietary management tool none of which looks the same as any
other and none of which is interchangeable.  The explosion in that
augean stable is too much to clean up now realistically.

However, for SCSI HBAs we have a good shot at a unified management
interface which we're pursuing with good co-operation from the various
vendors.  So for SCSI HBAs, non-standard interfaces to perform standard
tasks aren't allowed.

Are you talking about a SCSI HBA or a RAID one?

James


