From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Tue, 21 Jan 2003 00:00:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301210000.24705.oliver@neukum.name>
References: <10426732153816@kroah.com> <200301202251.08356.oliver@neukum.name> <3E2C7780.2080307@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E2C7780.2080307@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


> So the SCSI stack needs to support more than one model for
> device/bus detection.  This can't be news.  And some of them
> have to handle "conventional" busses, like USB and PCI; maybe
> even handle booting off them...

Until very recently it was news. And they still haven't fully
comprehended the implications.

> If you mean that HCs hook up to a different bus (often PCI), with its
> own hotplug support, that doesn't seem so different from SCSI HBAs
> hooking up to such busses (often PCI) and cascading the same hotplug
> support...

Right. Only that in SCSI it's that way for devices as well, not just busses.
Therefore removal detection and notification is a strict bottom to top
process.

> >>Erm ... which of the three SCSI layers are you talking about?  I was
> >>talking about the highest level,..
> >
> > In SCSI view device and bus disconnection is recognised by the lowest
> > level. As it knows nothing about the high layers, it notifies the
> > midlayer
>
> So you were talking past what I said about notifying that highest level,
> not disagreeing with it.

I was trying to make the point that callbacks have no place in that process.
It must go bottom to top and that's it. And there must be no error conditions
on the way. Refusing to take notice of a device removal is just not an option.
This is exactly what the current SCSI idea of an API to do bus removal does.

	Regards
		Oliver

