From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Tue, 21 Jan 2003 00:27:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301210027.56824.oliver@neukum.name>
References: <10426732153816@kroah.com> <3E2C753B.3090805@splentec.com> <3E2C7D87.6050804@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E2C7D87.6050804@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>, Luben Tuikov <luben@splentec.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


> > By transport I mean USB, FC, SPI, etc; LLDD is the transport portal
> > and the initiator (aka the initiator port).  This terminology is not
> > really that new, but still not that old, and described in SAM-3.
>
> I was hoping for something described in the 2.5.58 kernel docs,
> which only talks about LLD (Documentation/scsi) except in one case
> (looked like a typo) ... I remember SAM-3 as a kind of missile!

Possibly the view people at IBM have of SCSI is more comprehensive
than ordinarily used. We are probably better of talking about low
level drivers (LLDs). Whether these drive devices, busses or
transport mechanisms is not really relevant here.

> > We just cannot let a transport event just wipe out a device,
> > without consulting hotplugging first -- think security.
>
> Certainly "device gone" would be an auditable event, but this is
> primarily an integrity issue:  don't free objects until other
> components have stopped using them.

Right. There's nothing wrong with a LLD having to wait for
a _limited_ time by making a blocking call to the midlayer.
But that call must finish within a limited,reasonable time and it must
succeed. The complexity for handling hotunplugging belongs
squarely in a centralised place, but not every LLD. 

It is true that currently hotplugging is a generic safety problem
(unless you use devfs).
The problem is reuse of device nodes leading to a race with
the hotplug skripts. Old permissions may for a time be applied
to a new device. But that just means that the hotplugging
user space notification model is incomplete. Now the simple fix with
a callback into the LLD which would allow simply waiting for the
unplugging skript to run is true madness. You cannot stall a hotpluggable
subsystem waiting on a skript, neither can you do sane error handling.
Problem should be fixed where they arise, eg. "lock" a new hotplugged
device.

> If any components attach security policies to that "gone" state
> transition, that'd be atypical but purely their own business.
> (Like a transport erasing session master keys ... most transports
> wouldn't have them, and would likely erase them as soon as the
> device is known to be gone, no hotplug involved.)

Right.

> > That is, when a transport event takes place, the LLDD doesn't
> > have to ``run to'' SCSI Core right away. Just let the kernel
> > know about this event, and start returning errors, on newly
> > queued commands.
> >
> > The kernel will decide what to do about this device going away,
> > i.e. hotplugging, sysop notification, etc.
>
> Sounds right. Except that it'd normally be the SCSI core that
> we "let" know about the event. (Not always, I can imagine that
> some transports might be able to kick in recovery procedures
> and find some other path for accessing the device.  But in
> such cases, SCSI might never see the device as "gone" ... )

I must disagree. There's no decision involved here. You handle
tasks having the device open, clean things up, free up the resources
and fire off a user space notification.
Decisions get made in user space where policy can be reasonably
implemented.

	Regards
		Oliver

