From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: 21 Jan 2003 03:31:54 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1043119913.13397.14.camel@dhcp22.swansea.linux.org.uk>
References: <10426732153816@kroah.com>
	 <20030117105414.E359@one-eyed-alien.net> <3E2C3380.3070700@splentec.com>
	 <200301201923.50467.oliver@neukum.name>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200301201923.50467.oliver@neukum.name>
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, 2003-01-20 at 18:23, Oliver Neukum wrote:
> > The transport can notify that the device is gone, but an ULP entity will
> > call scsi_remove_device() not the other way around.
> 
> NO!
> 
> This is an insanely complicated scheme.
> We have no notification beforehand. User yanks out cable.
> That's it. No preperation at all.
> 
> We as the writers of device drivers need a way to get rid of the device
> as we are notified of the physical disconnect. It is not our job to maintain
> devices in an undead state.

If you think about it rationally there isnt a lot that can be done higher
up. At the point the hardware vanishes there may be other threads of execution
already in your driver, so undead state is a reality you have to live with, at
least briefly.

Providing you refcount objects and defer freeing of resources its not normally
too terrible 

