From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] USB Storage oops in 2.5.69-bk8
Date: Sat, 17 May 2003 11:29:30 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0305171108050.26146-100000@netrider.rowland.org>
References: <20030516222900.GA3236@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:17416 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S261580AbTEQPQg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 11:16:36 -0400
In-Reply-To: <20030516222900.GA3236@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Florin Iucha <florin@iucha.net>, David Brownell <david-b@pacbell.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

On Fri, 16 May 2003, Mike Anderson wrote:

> I remember the previous conversation on the MODE-SENSE, but I think
> there might be more here.
> 
> I do not believe the oops is related to the lack of proper hot-plugging
> support (unless this is another way it will manifest itself). The issue
> is more the interaction of the error handler and the usb storage driver.
> 
> The sequence:
> "drivers/usb/core/message.c: usb_control/bulk_msg: timeout
> Error handler scsi_eh_1 waking up
> scsi_eh_prt_fail_stats: 1:0:0:0 cmds failed: 0, cancel: 1"
> 
> would lead one two believe that a timeout was detected both in the usb
> core and in the mid layer. This would not be a good thing to have two
> timeout recovery actions happening. I am not familiar with the usb
> storage code so this may be incorrect. 

I think this is a red herring, and the sequence of log messages above is
not especially pertinent.  I don't have my copy of the original system log
with me here, so this is relying on memory and might be wrong -- end
disclaimer.

What happens is that the device crashes because of the 3-byte 
MODE-SENSE(6) request.  The scsi error handler tries various levels of 
fault recovery, all the way up to a bus reset.  Usb-storage implements the 
bus reset as a USB port reset, which requires usbcore to re-enumerate 
the device.  The line

   drivers/usb/core/message.c: usb_control/bulk_msg: timeout

refers to a failure during the re-enumeration.  Apparently even the port
reset was not enough to revive the device.  I don't know the reason for
the line

   Error handler scsi_eh_1 waking up

since the error handler is already running -- maybe it's related to the 
hot-unplug sequence that usb-storage goes through.  That sequence is 
pretty much guaranteed to cause an OOPS if the device is busy at the time, 
since it hasn't yet been updated properly.  (I think Matt Dharm is waiting 
to hear from someone -- like you, Mike -- that the SCSI core is ready for 
hot-unplugging.)

When the USB port reset fails as it did here, it automatically causes a 
hot-unplug event.  Usb-storage currently handles the SCSI part of that as 
follows:

	// Lock the host
	for each device on the host: sdev->online = 0;
	// Unlock the host
	scsi_remove_host(host);
	scsi_unregister_host(host);

My guess is that this sequence provokes that error handler message and 
causes the crash.

At any rate, the two timeout messages are referring to two different 
things.  One is the failure of the MODE-SENSE and the other is the failure 
of the re-enumeration.  They do not in themselves indicate a problem.

Alan Stern


