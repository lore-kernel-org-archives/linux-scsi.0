From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Tue, 05 Dec 2006 16:55:52 -0500
Message-ID: <4575EAE8.7040303@interlog.com>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46777 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759885AbWLEV4C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2006 16:56:02 -0500
In-Reply-To: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Joerg Schilling <schilling@fokus.fraunhofer.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> I decided to do this by email instead of bugzilla so that it would be 
> visible to everyone on the linux-scsi mailing list.
> 
> Re: http://bugzilla.kernel.org/show_bug.cgi?id=7026
> 
> To recap: Joerg Schilling needs to be able to retrieve the max_sectors 
> value for a SCSI device's request queue.  Doing it via sysfs is rather 
> clumsy, especially when only a file descriptor is available and not the 
> device name.  He has asked for an ioctl interface to provide the 
> information.
> 
> Is the patch below acceptable?

Alan,
I just spent an hour thinking about how to data mine through
that dreadful mess that /sys has become as I try to add
transport information to lsscsi.

And then this post made my day. Fancy that, adding a new
ioctl!! I hope the ioctl police aren't watching :-)

Apart from sensibly yielding the max size in bytes, your patch
has the added benefit of allowing non-block devices (e.g. tape,
processor and enclosure services) to find out what limit the
OS/host has placed on each command's maximum transfer size.

If you manage to get that ioctl in, then ungrateful people
will ask for the corresponding "set" operation as well.


To illustrate the /sys mess look at naming of the sysfs approach
to this problem. For example:
  /sys/block/sde/queue/max_sectors_kb
    - it is not only a "block" property
    - sde is an "end device" and suggests information from that
      device's Block Limits VPD page, actually it is a limit
      imposed by the OS and the host used to access that device
    - what has "queue" got to do with it?
    - "max_sectors_kb" should have units of bytes
And /sys has the horrible side effect of enshrining a badly
conceived design in a user interface (and SAS comes to mind).


Best of luck
Doug Gilbert


BTW Joerg: SG_SET_RESERVED_SIZE simply makes it extremely
unlikely that the sg driver will not be able to fetch
enough memory from the kernel to move data associated with
a SCSI command. The block layer SG_IO just fudges that.
While a major concern in lk 2.0, memory starvation is typically
not a major concern in lk 2.6 assuming modern hardware.
The sg driver's reserved buffer has other uses as
FUJITA Tomonori pointed out yesterday on the linux-scsi list.


