From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: bus:id:lun to device name
Date: Tue, 15 Jul 2003 10:03:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF19C5DBC5.6CF569E6-ON87256D64.005C1908-88256D64.005DBB45@us.ibm.com>
References: <1058280356.3983.29.camel@lt-sv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:18592 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S268915AbTGOQtq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2003 12:49:46 -0400
In-Reply-To: <1058280356.3983.29.camel@lt-sv>
List-Id: linux-scsi@vger.kernel.org
To: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Cc: Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org





>Theoretically /dev/foobar might be a scsi device, meaning that I
>must/should ioctl() all files under /dev/. Thats what I do not like
>about ioctl() :).

Even that is an oversimplification of the problem.  /home/bryanh/foo could
be a SCSI device.  It could be the same device as /dev/sda.  The device
could have no device special file at all (maybe a program that accesses the
device creates the device special file on the fly.  Maybe the file has been
deleted since the device was opened).

Once you admit that devices in Linux are not fundamentally associated with
names in the file tree, the problem takes on a whole new perspective.

On the other hand, if you're willing to constrain your world such that
there is such an association (by setting up rules about how you will and
will not use device special files), then there's really nothing wrong with
saying all SCSI devices will be accessed via device special file names in a
certain list, and then doing the ioctl to each file in that list to find
out which SCSI device it is.

>> Another option is to use scsidev
>> http://www.garloff.de/kurt/linux/scsidev/
>> where the device nodes are dynamically created and (by default) have
>> names which contain this information.
>
>AFAIR devfs does this too, depending on devfs would be an option.

Then it isn't clear which specific problem you're trying to solve.  Do you
mean you want _a_ device special file by which you can access the device,
and any will do?  In that case a scsidev/devfs solution would work.  You
could also use sg devices (via permanent device special files, or ones made
up on the fly).  Or do you want the name by which people normally know and
use the device?  E.g. "I have /dev/sda mounted, but what device is that?"

