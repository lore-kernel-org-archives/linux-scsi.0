From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: SCSI dynamic power management
Date: Tue, 20 Nov 2007 10:49:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0711201037590.3931-100000@iolanthe.rowland.org>
References: <4742F151.9020602@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52221 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759993AbXKTPth (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Nov 2007 10:49:37 -0500
In-Reply-To: <4742F151.9020602@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 20 Nov 2007, Douglas Gilbert wrote:

> There should have always been at least two types of "block":
>    a) block media access commands
>    b) block all commands because the transport has told us
>       (or we know that we are about to remove some component)
>       that commands cannot be delivered to the device (logical
>       unit)

That sounds reasonable.  I'm talking about some other kinds of "block":

     c) Temporarily block all commands other than START-STOP UNIT or 
	TEST UNIT READY because the device has been idle for N seconds
	and we want to prepare it prior to powering-down the
	transport.

     d) Temporarily block all commands because we have told the
	transport that it can power down; after we ask the transport
	to resume normal operation the commands will be delivered.

     e) Fail all commands immediately because the user has told us
	that no I/O to the device should be permitted and the device 
	must remain "idle".

> For case a) all SCSI commands apart from those that explicitly
> access the media (e.g. READ, WRITE, VERIFY) should be sent to
> the device. Some commands, such as MODE SENSE, may fail since
> they might depend on data held on the media. Such failures
> will be fast with appropriate sense_key/asc/ascq codes returned.
> 
> 
> IMO if a transport tells us that a SCSI device (i.e. target
> device and/or logical unit) is accessible and the SCSI subsystem
> stops us sending an INQUIRY to that device then the SCSI
> subsystem is broken.

What if the SCSI subsystem prevents you from sending an INQUIRY (or any 
other command) because the user/administrator has told it to do so?

Alan Stern

