From: adam radford <aradford@gmail.com>
Subject: Management Ioctls Revisited
Date: Wed, 19 Aug 2009 15:15:39 -0700
Message-ID: <b1bc6a000908191515yef38d4bxaeca8e6e3c761237@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f205.google.com ([209.85.217.205]:32958 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbZHSWPi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Aug 2009 18:15:38 -0400
Received: by gxk1 with SMTP id 1so6417290gxk.17
        for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2009 15:15:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Mukker, Atul" <Atul.Mukker@lsi.com>, bruce.allen@aei.mpg.de

Linus,

There seem to be quite a few new SCSI drivers being submitted to the
Linux kernel where the driver
authors have tried to implement a management interface ioctl(), only
to have it bounced out, without a
clear explanation of why it was not allowed.   There are often ramblings
about how it is 'hard to tell which ioctl crashed the system', etc.

We have some custom ioctl interfaces in the 3w-9xxx and 3w-xxxx SCSI
drivers used by the open source
'smartmontools' package to read smart data from the individual DISKS
underneath a RAID array.

When we submit new driver support for our 6GB SAS-RAID card, a driver
with this (already tried and tested) interface apparently won't
be accepted.

Should we re-write large parts of smartmontools (that are already
working and rock solid) to use a new
sysfs interface?  Is that really going to make it somehow 'better' or
more secure?  Isn't the whole point of sysfs 'one value per file' ?
We have a binary interface that sends back data, and bolting this onto
sysfs somehow doesn't seem like the right approach.

Creating a dummy 'processor' device within the driver so we can take
scsi passthrough, ata passthrough, and other binary data commands
through /dev/sgX when there are no disks present on a RAID array seems
like a gigantic hack.  Processor devices are usually enclosures.

I would like to open a discussion of this whole business of "NO NEW
IOCTLS".    I can see Greg KH, and others bouncing out drivers that
contain ioctl interfaces, and I see some of the biggest SCSI HBA
vendors asking what interface they should use and being told netlink,
sysfs, etc.

What are the functional and security benefits of using SYSFS
(sysfs_create_bin_file()), and re-writing open source userspace
management software (like smartmontools) that already uses existing
ioctls in drivers VS. accepting new ioctls and enforcing
CAP_SYS_ADMIN(), ioctl numbering from Documentaiton/ioctl-number.txt
and some "__user" compiler annotations for safety?

Will we be changing even 'fdisk' to not call BLKSSZGET, BLKRRPART,
etc in the future since 'ioctls are bad', or is the Linux kernel/scsi
community forcing these rules on driver writers only?

-Adam
