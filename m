From: Luben Tuikov <luben@splentec.com>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Mon, 20 Jan 2003 12:36:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2C3380.3070700@splentec.com>
References: <10426732153816@kroah.com> <200301170043.36577.oliver@neukum.name> <20030117085047.GB2531@beaverton.ibm.com> <200301171155.36452.oliver@neukum.name> <20030117105414.E359@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Oliver Neukum <oliver@neukum.name>, Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Matthew Dharm wrote:
> In a separate discussion with Mike, he mentioned that you can't
> scsi_remove_device() unless there are no pending commands.
> 
> How the hell is an LLD supposed to assure that!?!?

ABORT TASK/ABORT TASK SET.

For a year now I've been trying to get something of the sort
scsi_cancel_task/set().  It will send the aforementioned task
management functions (TMF) (depending on the abilities of the device)
to the device server (LLD).  After which the initiator should
NOT get a response to any already queued commands in the LLD.
LLDD should be smarter if they do their own queuing and snoop this
and act accordingly.

After sending such a TMF to the LLD, one can clean all ULP queues
(scsi, block, etc), knowing that there'd be no response to
a command (which is now gone), and then actually remove
the device.

In my own drivers/mini-scsi-core, I do something like this:
1. mark the device off (stop queuing anything to it, return error or
    whatever),
2. send the aforementioned TMF,
    2a) wait for current transfers to complete
3. cancel ULP queues.

Now the device is cleanly off, and one can remove it/restart it/whatever.

Note that this method is cleanly reversible (1. turn on,
2. LUN/device RESET (scsi layer), 3. start queuing (block layer)).

(Note as well that I make distinction between LLD and LLDD, where the last D
stands for ``driver'' in LLDD.)

> The way this should work is that the LLD calls scsi_remove_device(), and
> that cuts off the flow of commands.  The LLD can promise to error-out any
> pending commands in the device command queue.

I take it you mean that the transport will tell the LLDD that the device
is gone and it (LLDD) call the one above, SCSI Core to remove the device.

Hmm, more thinking needs to be done here, as shouldn't this be handled
by hotplugging? I.e. Targets do not *initiate* events.

The transport can notify that the device is gone, but an ULP entity will
call scsi_remove_device() not the other way around.

-- 
Luben


