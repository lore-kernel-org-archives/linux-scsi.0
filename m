From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Wed, 22 Jan 2003 23:46:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301222346.30329.oliver@neukum.name>
References: <Pine.LNX.4.44L0.0301211546410.6926-100000@ida.rowland.org> <3E2F1213.8090400@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E2F1213.8090400@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


> > Whose responsibility is it to fail these interactions?
>
> The transport.
>
> When a device is plugged to the SAN/fabric (wlg) it may not be the case
> that all initiators will know about it.  For this reason the transport
> itself, not SCSI Core, not LLDD*, will decide if the CDB is deliverable.
>
> * An LLDD may keep a table of seen devices (depending on the transport
> it provides a portal to), and thus the decision may be made there, but
> this doesn't have to be the case.
>
> (Just think of SANs/IP SANs.)

Not all the world is a SAN. USB has no possibility to even try an interaction
after the device is gone. We have to handle this flexibly. In fact, if a device
can vanish without a LLDD knowing about it, this is purely a problem of the
SCSI layer.

> > For something simple, like a USB serial port, it might turn out that the
> > low-level device driver gets all these requests and then fails them. 
> > That means the driver has to keep track of the fact that the device is no
> > longer connected until some reference count goes to 0.
>
> A LLDD doesn't have to keep reference counts.  In the simple case
> you mention above, it will check that the device is no longer reachable
> and will return TARGET error, which will bubble up the layers, or the

That is something that is impossible to some LLDDs. We have to keep
a record about devices and busses we can reach and can delete these
records only after we positively know that no more commands will come
down to the LLDD.

The alternative would be to check a table of available devices for every
command.

That means that we have to have a way to ensure that no more commands
will reach the LLDD which can be triggered without any commands to be
executed at all. This functionality has to come from the scsi mid layer.

> Newer drivers will make use of Service Response code, and be able to
> address only by (target, lun) rather than (bus, target, lun), and
> target may not be an int anymore.  But this is 2.7 stuff, or maybe
> a separately distributed SCSI Core and LLDDs subsystem...

Yes, but we need a solution for 2.6.
And it has to be reasonably simple.

	Regards
		Oliver

