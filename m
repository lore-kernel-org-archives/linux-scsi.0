From: adam radford <aradford@gmail.com>
Subject: Re: Management Ioctls Revisited
Date: Thu, 20 Aug 2009 11:52:31 -0700
Message-ID: <b1bc6a000908201152s154ca680h14741dbfdaedcd01@mail.gmail.com>
References: <b1bc6a000908191515yef38d4bxaeca8e6e3c761237@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f205.google.com ([209.85.217.205]:38760 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZHTSwa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 14:52:30 -0400
Received: by gxk1 with SMTP id 1so135906gxk.17
        for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2009 11:52:32 -0700 (PDT)
In-Reply-To: <b1bc6a000908191515yef38d4bxaeca8e6e3c761237@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Mukker, Atul" <Atul.Mukker@lsi.com>, bruce.allen@aei.mpg.de
Cc: Christoph Hellwig <hch@infradead.org>, James.Bottomley@suse.de

On Wed, Aug 19, 2009 at 3:15 PM, adam radford<aradford@gmail.com> wrote=
:
> Linus,
>
> There seem to be quite a few new SCSI drivers being submitted to the
> Linux kernel where the driver
> authors have tried to implement a management interface ioctl(), only
> to have it bounced out, without a
> clear explanation of why it was not allowed. =A0 There are often ramb=
lings
> about how it is 'hard to tell which ioctl crashed the system', etc.
>
> We have some custom ioctl interfaces in the 3w-9xxx and 3w-xxxx SCSI
> drivers used by the open source
> 'smartmontools' package to read smart data from the individual DISKS
> underneath a RAID array.
>
> When we submit new driver support for our 6GB SAS-RAID card, a driver
> with this (already tried and tested) interface apparently won't
> be accepted.
>
> Should we re-write large parts of smartmontools (that are already
> working and rock solid) to use a new
> sysfs interface? =A0Is that really going to make it somehow 'better' =
or
> more secure? =A0Isn't the whole point of sysfs 'one value per file' ?
> We have a binary interface that sends back data, and bolting this ont=
o
> sysfs somehow doesn't seem like the right approach.
>
> Creating a dummy 'processor' device within the driver so we can take
> scsi passthrough, ata passthrough, and other binary data commands
> through /dev/sgX when there are no disks present on a RAID array seem=
s
> like a gigantic hack. =A0Processor devices are usually enclosures.
>
> I would like to open a discussion of this whole business of "NO NEW
> IOCTLS". =A0 =A0I can see Greg KH, and others bouncing out drivers th=
at
> contain ioctl interfaces, and I see some of the biggest SCSI HBA
> vendors asking what interface they should use and being told netlink,
> sysfs, etc.
>
> What are the functional and security benefits of using SYSFS
> (sysfs_create_bin_file()), and re-writing open source userspace
> management software (like smartmontools) that already uses existing
> ioctls in drivers VS. accepting new ioctls and enforcing
> CAP_SYS_ADMIN(), ioctl numbering from Documentaiton/ioctl-number.txt
> and some "__user" compiler annotations for safety?
>
> Will we be changing even 'fdisk' to not call BLKSSZGET, BLKRRPART,
> etc in the future since 'ioctls are bad', or is the Linux kernel/scsi
> community forcing these rules on driver writers only?
>
> -Adam
>

James, Christoph,

Do you guys have any comments on this?

-Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
