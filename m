From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: SCSI dynamic power management
Date: Tue, 20 Nov 2007 14:03:24 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0711201350310.2906-100000@iolanthe.rowland.org>
References: <1195575333.3131.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54890 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757751AbXKTTD0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Nov 2007 14:03:26 -0500
In-Reply-To: <1195575333.3131.37.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Oliver Neukum <oliver@neukum.org>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 20 Nov 2007, James Bottomley wrote:

> > The main point I'm aiming for is to have the midlayer to inform the LLD 
> > when all the devices on a particular bus are "idle".
> 
> This is the wrong assumption ... the mid layer would provide an API to
> inform the transport.  Transport and host are separate things.  an 8
> port SAS card could suspend a single phy and device while still
> processing the others.  So what it sounds like you need is a transport
> API saying a given device has been suspended or is requested to be
> resumed?  What than means for the host would be transport class policy,
> I think.

Okay.  I know little about the intricacies of these newer, more exotic
transports; I'm pretty firmly rooted in the old SPI technology.

Anyway, yes, I want an API to inform the transport and/or host adapter 
driver that either a given device or all devices on a bus has been 
suspended or requests to be resumed.  For an 8-port SAS card the driver 
might want to know about each individual device; for a plain old SPI 
card the driver would care only about the entire bus.

> A little ... I think your wake on command idea above is policy rather
> than actual implementation ... so it would probably have to be
> selectable (either error or wake).

Yes.  That is already part of the USB dynamic PM implementation, and I
would copy it for the SCSI implementation.  There is a sysfs file
(/sys/devices/.../power/level) to which the user can write three
possible values:

	"on" means the device is permanently at full power;

	"auto" means the device is subject to autosuspend after
	an idle-timeout (the timeout value is stored in a separate
	sysfs file) with autoresume at the next I/O request;

	"suspend" means the device is permanently suspended
	and I/O requests will fail immediately.

My intention was to add a couple of method pointers to the SCSI
host_template structure, one for suspend notifications and one for
resume notifications.  Do you think this is the right way to do it, or
is something more complex called for?

Alan Stern

