From: "Heiko Carstens" <Heiko.Carstens@de.ibm.com>
Subject: Re: linux-2.6.0-test11 [BUG] -- scsi_add/remove_device - out of memory
Date: Wed, 14 Jan 2004 11:39:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF8911B999.C4375764-ONC1256E1B.00394202-C1256E1B.003A9BC8@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:4275 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S265331AbUANKjh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 05:39:37 -0500
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Adam Radford <aradford@3WARE.com>, linux-scsi@vger.kernel.org

I guess you are right and I am wrong :)

What actually happened: when adding and removing scsi devices in an
endless loop the system ran out of memory and the oom killer started
killing processes. So I thought that there must be a memory leak.

But, if you only add and remove a certain amount of disks,then wait
a moment and then do it with the next bunch this will not happen.
The reason for the memory shortage was actually that the kernel
generated lots of hotplug events and each of these events started
/sbin/hotplug eating up some memory. This explains also why memory
was available again after waiting for a short moment.

So, the solution to this problem seems to be: don't do it.

Heiko

To:     Heiko Carstens/Germany/IBM@IBMDE
cc:     Adam Radford <aradford@3WARE.com>, linux-scsi@vger.kernel.org 
Subject:        Re: linux-2.6.0-test11 [BUG] -- scsi_add/remove_device - out of memory


Heiko Carstens [Heiko.Carstens@de.ibm.com] wrote:
> Hi,
> 
> yes, now that I had some more time to look into it I found a leak.
> Actually the scsi mid layer creates a lot of sysfs attributes but
> doesn't remove a single one if a scsi device or a host gets removed.
> Since e.g. device_del (as it is called by scsi_remove_device) does
> not automatically remove all previously registered sysfs
> attributes, we end up with objects that have a reference count > 0
> and thus will never be released and eat up memory.
> 
> Heiko

Maybe something has changed, but the device_del calls kobject_del which
calls sysfs_remove_dir. sysfs_remove_dir removes all children enteries
created by sysfs_create_file. This should clean up the attributes.

-andmike
--
Michael Anderson
andmike@us.ibm.com

