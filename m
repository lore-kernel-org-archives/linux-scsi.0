From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Mon, 20 Jan 2003 19:23:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301201923.50467.oliver@neukum.name>
References: <10426732153816@kroah.com> <20030117105414.E359@one-eyed-alien.net> <3E2C3380.3070700@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E2C3380.3070700@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


> I take it you mean that the transport will tell the LLDD that the device
> is gone and it (LLDD) call the one above, SCSI Core to remove the device.
>
> Hmm, more thinking needs to be done here, as shouldn't this be handled
> by hotplugging? I.e. Targets do not *initiate* events.
>
> The transport can notify that the device is gone, but an ULP entity will
> call scsi_remove_device() not the other way around.

NO!

This is an insanely complicated scheme.
We have no notification beforehand. User yanks out cable.
That's it. No preperation at all.

We as the writers of device drivers need a way to get rid of the device
as we are notified of the physical disconnect. It is not our job to maintain
devices in an undead state.

And a scheme that goes subsystem driver -> hotplugging -> script finding
corresponding devices -> script doing proc magic -> scsi layer notifying
low level driver is _not_ sensible. It triples the amount of complexity.

We need a simple scheme like
1. block further requests
2. kill old requests
3. remove device

	Regards
		Oliver


