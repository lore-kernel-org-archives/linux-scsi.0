From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Thu, 23 Jan 2003 20:40:41 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301232040.41862.oliver@neukum.name>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <200301231919.40422.oliver@neukum.name> <3E303D5E.5020000@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E303D5E.5020000@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Am Donnerstag, 23. Januar 2003 20:07 schrieb Luben Tuikov:
> Oliver Neukum wrote:
> > Very well, so you agree that the SCSI layer should export to the LLDD
> > a function to set devices offline?
>
> I've never really disagreed -- simpler transports will make use
> of such a function.  The important point to note is that the error

Good.

> return value for simpler and more complicated transports has to
> be the same (i.e. ones which know about the device disconnect and
> others which send out the CDB and which will return with error).

Why? It throws away information needlessly. If the LLDD knows
that the reason is unplugging why not report it? A LLDD that doesn't
know about devices going away on the other hand can just report
an error. Can the higher layers simply assume that the device was unplugged?
IMHO they can't and should at least try to recover from the error.

> I forgot to mention this with my previous email: think of a LLDD
> more as part of the transport than of SCSI Core.

Hard to do. The scsi mid layer does timing out and error handling.
There's a relatively tight connection.

> > So the first thing a LLDD has to do after it has learned about a device
> > being removed is to have the device block.
>
> ``block'' (verb) is such a strong word.

What do you prefer ? ;-) I'll certainly use another word if you like me to
do so.

> * Simple transports: call scsi_set_device_offline(dev) or something like
> this.
>
> * More complicated transports: SCSI Core sees Service Response of Service
> Delivery Failure and it itself calls scsi_set_device_offline(dev).
>
> scsi_set_device_offline(dev) calls a high-level kernel function to start
> higher level things (block queue cut off, etc) which *may* need to be done.

How do you differentiate between real failure and device removal?

> > So it should be the LLDD's responsibility to finish the outstanding
> > commands.
>
> LLDD cannot really ``finish'' outstanding commands, it's just a transport
> portal.

Well, report back the results, if you prefer, thus returning ownership to
higher layers.

> > Furthermore, there's a window for commands already having passed the
> > check for offline but not yet being noticed by the LLDD.
>
> They will return with an appropriate error.

Not quite so simple. Some LLDDs need to know at some point that
no more commands will arrive for sure and none are still in flight.

> > The simplest solution is to
> > use a waiting primitive from RCU. So we are at:
> >
> > 1. set device offline
> > 2. synchronize the kernel
> > 3. finish all pending commands
>
> I told you before: 3 starts *before* 2 and 3 is *part* of 2.
> Furthermore, after 1 has happened in time, all pending commands
> will error out (wrt a time line).

That's not enough. The LLDD has to know that they've errored
in order to free associated data structures. The simplest way to
do so is returning them to higher layers.

> 2 is what I call ``higher-level hook'', but it's not really
> ``synchronization''. Synchronization will take delta-time, it
> will not happen instantaneously.

Please explain.

> I.e. you have to allow for the possibility of a command
> being sent to a non-existent device through LLDD, in which
> case the LLDD/transport will have to error it out.

Non existant is OK. For a device already flagged offline is not OK.

	Regards
		Oliver

