From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Tue, 22 Apr 2003 14:13:17 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304221404210.644-100000@ida.rowland.org>
References: <1051033033.1768.65.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2564 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263319AbTDVSBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 14:01:12 -0400
In-Reply-To: <1051033033.1768.65.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andries.Brouwer@cwi.nl, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, mdharm-scsi@one-eyed-alien.net, mike@hingston.demon.co.uk, torvalds@transmeta.com, USB Storage List <usb-storage@one-eyed-alien.net>

On 22 Apr 2003, James Bottomley wrote:

> On Tue, 2003-04-22 at 12:22, Andries.Brouwer@cwi.nl wrote:
> [...]
> 
> Actually, could this
> 
> > Apr  9 17:34:55 lemon: usb-storage: Invoking Mode Translation
> 
> Be the root cause?  It indicates that usb storage modified the command.

No, most likely it's not the cause.

> In 2.5.68 that's doing a translation from MODE SENSE(6) to MODE
> SENSE(10) inside the driver.
> 
> But the odd thing in usb/storage/protocol.c is this (about line 354):
> 
>                 case MODE_SENSE:
>                 case MODE_SELECT:
>                         srb->cmd_len = 12;
>                         srb->cmnd[11] = 0;
>                         srb->cmnd[10] = 0;
> 
> Why is a 10 byte command given a command length of 12?

The USB protocol used by this device is presumably one that requires all
commands to be 0-padded to 12 bytes.

More interesting is this:

> Apr  9 17:34:55 lemon: usb-storage: Command MODE_SENSE (6 bytes)
> Apr  9 17:34:55 lemon: usb-storage:  1a 00 3f 00 04 00

<snip>

> Apr  9 17:34:55 lemon: usb-storage: usb_stor_bulk_transfer_buf(): xfer 4 bytes
> Apr  9 17:34:55 lemon: usb-storage: Status code -75; transferred 4/4

The error is -EOVERFLOW, which means that the device tried to send back 
more data than we were prepared to receive, i.e., more than 4 bytes.  That 
4 comes from the second-to-last byte of the MODE-SENSE command.  But there 
is a comment in drivers/storage/usb/protocol.c indicating that 8 is the 
minimum size for a MODE-SENSE (line 257).  That might or might not be 
accurate, or it might not apply to this sort of device.  But it is 
suggestive.

Alan Stern

