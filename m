From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: MPIO HS200 Gigabox weird behaviour again
Date: Fri, 11 Feb 2005 11:00:34 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502111054040.937-100000@ida.rowland.org>
References: <20050210134432.GA12229@kassiopeia.juls.savba.sk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from ida.rowland.org ([192.131.102.52]:5892 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262262AbVBKQAg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 11:00:36 -0500
In-Reply-To: <20050210134432.GA12229@kassiopeia.juls.savba.sk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Radovan Garabik <garabik@kassiopeia.juls.savba.sk>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 10 Feb 2005, Radovan Garabik wrote:

> I put the dmesg output to:
> http://kassiopeia.juls.savba.sk/~garabik/junk/gigabox.txt
> 
> the exact sequence to reproduce the behaviour is:
> 1) modprobe ehci-hcd
> 2) plug in gigabox, wait a second till the message about a new usb
>    device appears
> 3) modprobe usb-storage delay_use=10

I see.  The drive reports a failure with Sense Key = 0x04.  According to 
the SCSI specification, this indicates a _nonrecoverable_ hardware 
failure.  So you can't blame the SCSI drivers for not retrying the 
request, even though a later attempt to read the partition did end up 
succeeding.

Maybe the SCSI midlayer could be changed to retry anyway, just as an
optimistic workaround for buggy devices like yours.

SCSI developers: Is there any hope of this?

> > What patch did you apply to the driver, to treat the Gigabox the same as a
> > Genesys drive?  And what's in your /proc/bus/usb/devices entry for the Gigabox?
> 
> see
> https://lists.one-eyed-alien.net/pipermail/usb-storage/2004-November/001154.html
> you responded to that mail :-)

Ah yes.  That contains your original bug report.  I didn't remember that
was from you, because the message was resent by Matt Dharm.

Alan Stern

