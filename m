From: Luben Tuikov <tluben@rogers.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: Thu, 17 Apr 2003 18:29:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E9F2AB7.5080903@rogers.com>
References: <20030325100704.GC3868@beaverton.ibm.com> <200304100032.11400.oliver@neukum.org> <3E94A5DB.2020007@rogers.com> <200304100951.13652.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-mail.bloor.is.net.cable.rogers.com ([66.185.86.71]:62737
	"EHLO fep01-mail.bloor.is.net.cable.rogers.com") by vger.kernel.org
	with ESMTP id S262642AbTDQWR2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Apr 2003 18:17:28 -0400
In-Reply-To: <200304100951.13652.oliver@neukum.org>
List-Id: linux-scsi@vger.kernel.org
To: oliver@neukum.name
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, linux-hotplug-devel@lists.sourceforge.net, Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

Oliver Neukum wrote:
>>*But*, the _important__point_ is that the LLDD must be able to handle
>>requests (queuecommand()) to non-existant (== just removed) devices,
>>and not oops, or whatever.
> 
> 
> For how long? That's the question.

As soon as scsi_dev_removal()/scsi_set_dev_offline() returns
you may assume you can free all _your_ resources.  I.e.
the upper subsystem should handle it from that point on.
 
>>So, in effect, you just call usb_dev_removal(dev) (to be written),
>>and free _your_ resources on the device. (note important point above)
> 
> 
> The way it is in USB is a little different as the USB device drivers do
> not go directly to the hardware. It would be:
> 
> HCD -> USB core -> LLDD -> generic SCSI -> ...
> Steps 1 to 3 work, 4 doesn't.

Not yet, soon maybe.

> If they can't block, they cannot clean up commands still in flight.
> Eventually something needs to wait for the outstanding commands.

I don't see it.

(Upper level: )
Pending commands could be invalidated at once, via their callback
to the upper subsystem; and any new incoming commands to device x
could be invalidated at the moment they come in.

(Lower level: )
Note that during the call to scsi_dev_removal() your driver
may get its host_reset/device_reset function called to abort all
pending commands (so as to leave the device in a predictable state).
At which point, depending on the transport, _your__driver_ may need
to sleep until the task management function response comes back (say over
a network).

All in all, it's not that bad.
-- 
Luben




