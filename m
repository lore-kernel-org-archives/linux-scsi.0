From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 00:33:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E30FA68.5010508@pacbell.net>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org>
 <200301231919.40422.oliver@neukum.name> <3E303D5E.5020000@splentec.com>
 <200301232040.41862.oliver@neukum.name> <20030123202835.GA25838@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pacbell.net ([67.118.247.147])
 by mta5.snfc21.pbi.net (iPlanet Messaging Server 5.1 HotFix 1.6 (built Oct 18
 2002)) with ESMTP id <0H9700J65M3FB1@mta5.snfc21.pbi.net> for
 linux-scsi@vger.kernel.org; Fri, 24 Jan 2003 00:26:06 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Doug Ledford wrote:

> Once all the commands are gone and no more are arriving, then if, and only 
> if, someone actually removes the device from the scsi subsystem (maybe 
> hotplug manager or something) then you will get the typical 
> slave_destroy() call to tell you that it is safe to release all resources 
> related to this device.  Otherwise, the device will hang around as an 
> offline device until someone does  

Does that mean there's no LLD state for that HBA (and/or devices
connected to it), so that some _other_ kind of state is representing
these zombie devices?

Seems like it must.  USB physical device model state must go away
when the device does, rather promptly ... the disconnect() is invoked
in a thread, so it can block for a very short while.   Blocking more
than a few milliseconds there is extremely antisocial though, so
that can't be the device state that will "hang around" until some user
mode agent does your suggested removal action.

I get the impression these zombie devices are largely what Linus has
recently asked to be removed from usb-storage.  Which has, so far,
been quite keen to re-animate them ... maybe a useful incremental
improvement would be just to give up the re-animation part, in such
a way that the scsi a/b/c/d identifiers eventually get recycled.


>   echo "scsi-remove-single-device a b c d" >/proc/scsi/scsi
> to remove it.

That ought to be trivial for some hotplug agent to do ... but there's
the issue of where "a b c d" come from.  Last I looked, there was no
obvious way to associate such data with the SCSI hotplug events; the
sysfs state wasn't very helpful.

- Dave







