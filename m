From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: Inhibit auto-attach of scsi disks ?
Date: Thu, 3 Oct 2002 10:09:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFCF4B9C86.34AEB8AC-ON87256C47.005D2898@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, Scott Merritt <Scsi@PragmaSoft.com>

>We should have a "partition driver", which will
>pass the requests it gets on to a lowlevel driver with an 
>offset.

That sounds exactly right to me.  Very much like the raw device driver.

But this driver should not read the partition table.  A user space program 
is perfectly capable of reading the partition table, and it can use ioctls 
to create partition devices and bind them to base devices.  Even 
overlapping if the user is serious.  This opens up a whole wide world of 
partitioning schemes.

Root filesystems are always a pain, but every SCSI root filesystem system 
I've seen (which is not many) uses an initial ramdisk and a fair amount of 
intelligence to load the proper SCSI adapter driver.  The initrd level 
system could easily establish the partitions too.

And a special case hack for simple systems whose original root filesystem 
really is on a SCSI partition would be OK by me.  It would be just like 
the hack that figures out which filesystem driver to use for that 
partition. (For those who don't know -- the kernel simply tries to mount 
with every bound-in filesystem driver it has until one succeeds.  And it 
has a special mount option that says "don't get excited if you're unable 
to do this mount -- I'm just fishing.")

