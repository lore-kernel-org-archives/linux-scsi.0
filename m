From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Mon, 27 Oct 2008 11:25:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810271117530.4059-100000@iolanthe.rowland.org>
References: <4905D68D.7030407@interlog.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55573 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751568AbYJ0PZU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2008 11:25:20 -0400
In-Reply-To: <4905D68D.7030407@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Luciano Rocha <luciano@eurotux.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux-Kernel <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 27 Oct 2008, Douglas Gilbert wrote:

> > This looks exactly like the "infinite retry" problem I warned about 
> > earlier.  Here are the important parts of the log.  For people who 
> > don't know how to interpret these messages, the CDB starts in the 16th 
> > byte of the 31-byte messages.  For example, the first command here 
> > starts with 0x25 and so it is READ CAPACITY:
> > 
> >> f21e7cc0 3570408174 S Bo:1:008:1 -115 31 = 55534243 06000000 08000000 80000a25 00000000 00000000 00000000 000000
> >> f21e7cc0 3570408264 C Bo:1:008:1 0 31 >
> >> f21e72c0 3570408280 S Bi:1:008:2 -115 8 <
> >> f21e72c0 3570408389 C Bi:1:008:2 0 8 = 2e9390b0 00000200
> >> f21e7cc0 3570408400 S Bi:1:008:2 -115 13 <
> >> f21e7cc0 3570408513 C Bi:1:008:2 0 13 = 55534253 06000000 00000000 00
> > 
> > The response is 0x2e9390b0.  In typical broken fashion, that is 
> > undoubtedly the total number of sectors rather than the highest sector 
> > number.
> 
> Since the READ CAPACITY "off by one" error is so common,
> perhaps drivers such as usb-storage could have a hook to
> do a pseudo READ CAPACITY. Then if the capacity value
> looked odd (in both senses) the driver could do an IO to
> the suspect block and if that failed decrement the capacity
> value passed back to the mid level.

We thought of that years ago.  Unfortunately there is no reliable way
of telling when a capacity value is wrong.  There definitely do exist
disks with an odd number of sectors.

Furthermore, doing I/O to a suspect block is not a good idea.  There
are plenty of devices which simply crash when you try to access a
nonexistent sector.

> Put another way, why don't these defective devices trip up
> another OS?

I imagine they do.  However Linux has partition code that stores
information in the last sector of a partition (EFI GUID and md, for
example).  Other OS's apparently do not try to access the medium's last
sector under most circumstances.

> BTW a single disk in RAID 0 (seen on a HP E200 controller)
> has a shortened capacity value seen in the midlevel on the
> corresponding logical drive. That missing chunk is probably
> where the RAID controller puts its control information.
> Anyway, playing with the capacity value returned by READ
> CAPACITY certainly has a precedent.

usb-storage isn't in the business of altering the data it gets from a 
device.  It's just a transport.  That's why the sdev->fix_capacity flag 
exists; we tell the upper layer that the data it gets is going to be 
wrong and let the upper layer worry about fixing things up.

> > Later on the system tries to read the contents of what it thinks is the 
> > last sector:
> 
> I know that happens but it seems strange that upper levels
> are reading a block that has never been written to. Read ahead?

No, partition scanning.  Also maybe /lib/udev/vol_id, which seems to 
read an inordinate number of irrelevant sectors.

Alan Stern

