From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 17 Jan 2003 21:26:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301172126.56014.oliver@neukum.name>
References: <10426732153816@kroah.com> <200301171155.36452.oliver@neukum.name> <20030117105414.E359@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030117105414.E359@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


> In a separate discussion with Mike, he mentioned that you can't
> scsi_remove_device() unless there are no pending commands.
>
> How the hell is an LLD supposed to assure that!?!?
>
> The minute I error a command and call scsi_done(), I can get a new one.
> Unless I lock out requests with scsi_block_requests(), but that comes with
> major warnings about needing to get unblocked.

If I understand the scsi code correctly, doing that will result in a memory
leak at least. Perhaps exporting a function to declare a host's devices
offline might do the trick. But as yet I havn't found out where the scsi layer
actually checks that flag.

> The way this should work is that the LLD calls scsi_remove_device(), and
> that cuts off the flow of commands.  The LLD can promise to error-out any
> pending commands in the device command queue.
>
> That is, unless scsi_block_requests() and scsi_unblock_requests() are more
> useful than the documentation suggests... block(), error all commands,
> unregister()... that would make some sense.  We could call
> scsi_block_request() as soon as we know the unit is gone, and unregister()
> as soon as the queue is empty.

Sounds reasonable.

	Regards
		Oliver

