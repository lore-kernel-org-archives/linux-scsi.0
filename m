From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: SCSI HBA in wrong order
Date: Fri, 9 Jul 2004 14:08:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF6670F869.849872F3-ON85256ECC.0072A27A-88256ECC.00741F12@us.ibm.com>
References: <Pine.LNX.4.58.0407091417080.16287@rray1.jam.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:57744 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265009AbUGIVI0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2004 17:08:26 -0400
In-Reply-To: <Pine.LNX.4.58.0407091417080.16287@rray1.jam.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: raray@jam.rr.com
Cc: linux-scsi@vger.kernel.org

>I did a bit of reading about udev and I'm uncertain how this will help.

I don't know enough about either udev or what problem the changing host 
numbers is causing for you to give specific instructions, but I can at 
least explain the idea.

>At present running RH 9.0 and 2.4.23 kernel the 2 internal harddrives are
>mapped as sda and sdb.

The names "sda" and "sdb" are all but meaningless.  What you probably mean 
is that they map to the device special files /dev/sda and /dev/sdb.

The problem you have, then, is that /dev/sda is defined as the device with 
major number 8, minor number 0, which in turn is defined roughly as the 
first SCSI device that Linux noticed.

But whatever you're using /dev/sda for, I doubt that you really mean to 
say, "use the first disk that Linux noticed."  You probably really mean 
something like, "use the internal SCSI disk on the lefthand side" or "use 
the disk that contains the volume with volume ID XYZ."

Until now, you (and the rest of the satisfied Linux world) have been lucky 
in that Linux always noticed the internal SCSI disk on the lefthand side 
first.  Many, many things, including the kernel upgrade you did, can 
change the correspondence between discovery order and useful disk 
identity.

That's where udev comes in, because you can use it to create device 
special files whose names identify your disks in meaningful name spaces, 
not just discovery order.  You could have /dev/sd/internal_left if you 
wanted, and no matter how you upgraded your kernel, installed new HBAs, 
etc, it would always be the same disk.  The fact that it's in user space 
is fine, because only a user space program would access the disk by the 
name /dev/sda anyway.

If your problem has nothing to do with the device special file /dev/sda, 
then I haven't explained anything.  But there's probably still some way 
you can identify a device by something other than its discovery order.

