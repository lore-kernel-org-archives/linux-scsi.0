From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Wed, 22 Jan 2003 13:30:12 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2F0D64.3070609@pacbell.net>
References: <10426732153816@kroah.com> <200301210000.24705.oliver@neukum.name>
 <3E2C97D7.1070406@pacbell.net> <200301210150.55286.oliver@neukum.name>
 <3E2D8E78.4050405@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pacbell.net ([67.118.247.16])
 by mta6.snfc21.pbi.net (iPlanet Messaging Server 5.1 HotFix 1.6 (built Oct 18
 2002)) with ESMTP id <0H94008JCYYIED@mta6.snfc21.pbi.net> for
 linux-scsi@vger.kernel.org; Wed, 22 Jan 2003 14:11:11 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Oliver Neukum <oliver@neukum.name>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> 
> When the Low Level Device Driver (LLDD), being the transport portal,
> notices that the device is going away or has gone away from the
> ``fabric'' (wlg), it will fire a device-gone event with the kernel.
> *Not* necessarily with SCSI Core, in fact I'd rather it didn't,
> but with a well defined kernel entry for device-gone events.
> 
> At the same time the LLDD will start returning TARGET gone, or
> whatever is appropriate to newly queued commands, and error out
> all internally queued commands (if it does it's own queuing).
> (I've seen this work nicely on mount and read/write(2) and fsck.)
> 
> I.e. the ``synchronization'' has started already by the LLDD erroring
> out commands, new and queued.

This model I like, though FWIW the USB code has pretty messy
handling of the (a) cancel queued requests and (b) reject new
requests parts of that model.  All the updates to handle that
would be transparent to device drivers (other than HCDs); we've
discussed it a bit.


> All the while the kernel has started higher level cleaning up,
> decrementing ref counts, etc, 

... Invoking some hotplug event that might unmount filesystems,
so _all_ relevant kernel state can be cleaned up ...


> But there's no such thing as ``waiting around indefinitely'' or
> ``blocking wait'' as you've suggested in some of your emails.

Right.  Though I can wish the driver model core actually used
its "enum device_state" and had an instance variable of that
type in "struct device".  That'd help the bus level driver
(for SCSI, an LLDD or LLD; for USB, an HCD) with (a) and (b).

The "no waiting indefinitely" is in part that because knowing
both (a) and (b) happen means you know the device quiesces.

- Dave



