From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Problems with USB disk [solved]
Date: Thu, 13 Sep 2007 10:12:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709131008360.3619-100000@iolanthe.rowland.org>
References: <46E863EA.4060806@rtr.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35086 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751977AbXIMOMN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Sep 2007 10:12:13 -0400
In-Reply-To: <46E863EA.4060806@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: Chuck Ebbert <cebbert@redhat.com>, Niels <zorglub_olsen@hotmail.com>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Wed, 12 Sep 2007, Mark Lord wrote:

> Chuck Ebbert wrote:

> >>> =========
> >>> sd 1:0:0:0: Device not ready: <6>: Current: sense key=0x2
> >>>     ASC=0x4 ASCQ=0x2
> >>> end_request: I/O error, dev sda, sector 126693711
> >>> sd 1:0:0:0: Device not ready: <6>: Current: sense key=0x2
> >>>     ASC=0x4 ASCQ=0x2
> >>> end_request: I/O error, dev sda, sector 126693711
> >>> sd 1:0:0:0: Device not ready: <6>: Current: sense key=0x2
> >>>     ASC=0x4 ASCQ=0x2
> >>> end_request: I/O error, dev sda, sector 126693711
> >>> =========
> >>>
> >> Using a new PSU and a powered hub made no difference. But I found a solution
> >> here:
> >>
> >> http://alienghic.livejournal.com/382903.html
> >>
> >> Basically, the problem is, as suspected, that the drive spins down / goes to
> >> suspend. This can be disabled with "sdparm --clear STANDBY -6 /dev/sda".
> >>
> >> It seems to me to be an error that the kernel reports this as something like
> >> a hardware failure. Or at least very misleading.
> >>
> > 
> > Oh, nice. The usb-storage (SCSI) disk spins itself down and we can't handle that.
> > Should we be disabling auto-spindown when we connect the device, or be able to
> > handle this by sending the start command when needed?
> 
> There's more to this.
> 
> My Sandisk Cruzer Micro 1GB USB sticks suffer from this regression.

I seriously doubt that.  Are you claiming that your USB stick spins 
itself down during a suspend?  And then requires to be spun back up 
before it will resume proper operation?

(Hint: Flash memory devices don't contain rotating media...)

Alan Stern

