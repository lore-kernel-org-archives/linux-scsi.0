From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Thu, 10 Apr 2003 09:51:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200304100951.13652.oliver@neukum.org>
References: <20030325100704.GC3868@beaverton.ibm.com> <200304100032.11400.oliver@neukum.org> <3E94A5DB.2020007@rogers.com>
Reply-To: oliver@neukum.name
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mail1.KONTENT.De ([81.88.34.36]:19181 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S263994AbTDJHji (for <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2003 03:39:38 -0400
In-Reply-To: <3E94A5DB.2020007@rogers.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, linux-hotplug-devel@lists.sourceforge.net, Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>


> *But*, the _important__point_ is that the LLDD must be able to handle
> requests (queuecommand()) to non-existant (== just removed) devices,
> and not oops, or whatever.

For how long? That's the question.

> So, in effect, you just call usb_dev_removal(dev) (to be written),
> and free _your_ resources on the device. (note important point above)

The way it is in USB is a little different as the USB device drivers do
not go directly to the hardware. It would be:

HCD -> USB core -> LLDD -> generic SCSI -> ...
Steps 1 to 3 work, 4 doesn't.
For a PCMCIA LLDD it would be different, but that really doesn't
matter to the generic SCSI layer.

> > We have indeed discussed this before and the need to notify
> > user space was never questioned, as far as I recall.
> > The point of contention always was whether the notification
> > had to do specific things for the process of unplugging to finish
> > as far as it concerns the low level driver.
>
> Right.  As far as I can see, those subsystem entries, xxx_dev_removal(dev),
> would do things which do not block, like flip a bit, flags, integer,
> wake up a thread, etc, call the above subsystem's xxx_dev_removal(dev),
> and return immediately. (as per my other posting)
> (this needs more thinking though)

If they can't block, they cannot clean up commands still in flight.
Eventually something needs to wait for the outstanding commands.

	Regards
		Oliver

