From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: iRiver H100 series and usb-storage issues
Date: Tue, 8 Jun 2004 10:19:23 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406081016280.1222-100000@ida.rowland.org>
References: <87y8mzukwk.fsf@ceramic.fifi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:4612 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265210AbUFHOTY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2004 10:19:24 -0400
In-Reply-To: <87y8mzukwk.fsf@ceramic.fifi.org>
List-Id: linux-scsi@vger.kernel.org
To: Philippe Troin <phil@fifi.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On 7 Jun 2004, Philippe Troin wrote:

> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > In the log you posted (at the URL above) the CSW was returned correctly.  
> > The same is true for the messages you referred to.  So that was not the 
> > source of the problem.
> 
> Okay, quite possibly, as I was pointing out I am mostly clueless
> w.r.t. USB.  But what about:
> 
>   usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
>   usb-storage: usb_stor_bulk_msg() returned 0 xferred 0/512
>   usb-storage: Bulk data transfer result 0x1
>   usb-storage: Attempting to get CSW...
>                ^^^^^^^^^^^^^^^^^^^^^^^^
>   usb-storage: clearing endpoint halt for pipe 0xc0011e80
>   usb-storage: usb_stor_clear_halt: result=0
>   usb-storage: Attempting to get CSW (2nd try)...
>                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   usb-storage: Bulk status result = 0
>   usb-storage: Bulk status Sig 0x53425355 T 0x945 R 512 Stat 0x0
>   usb-storage: -- unexpectedly short transfer
>   usb-storage: Issuing auto-REQUEST_SENSE

Those are perfectly normal.  The spec allows a device to halt the 
bulk-in endpoint the first time the host tries to read the CSW.  The 
second attempted read is supposed to succeed, and indeed it did.

> > Do you know of anyone who has contributed to any versions of this thread 
> > and still does have an H1xx?
> 
> No, I did not keep track.  Nothing prevents me from "trying" another
> one if you're serious about fixing the above issues.

I am serious about fixing this.  At the moment we don't have anything new
for you to try, but maybe we'll come up with something soon.  I'm still
waiting to hear from the SCSI people about how this should be handled...

Alan Stern

