From: Philippe Troin <phil@fifi.org>
Subject: Re: iRiver H100 series and usb-storage issues
Date: 07 Jun 2004 14:18:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <87y8mzukwk.fsf@ceramic.fifi.org>
References: <Pine.LNX.4.44L0.0406071616200.666-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tantale.fifi.org ([216.27.190.146]:15005 "EHLO tantale.fifi.org")
	by vger.kernel.org with ESMTP id S265064AbUFGVSl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2004 17:18:41 -0400
In-Reply-To: <Pine.LNX.4.44L0.0406071616200.666-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern <stern@rowland.harvard.edu> writes:

> On 7 Jun 2004, Philippe Troin wrote:
> 
> > Alan Stern <stern@rowland.harvard.edu> writes:
> > 
> > > I just noticed this thread on linux-kernel:
> > > 
> > > http://marc.theaimsgroup.com/?l=linux-kernel&m=108372064000188&w=2
> > > 
> > > Apparently under some circumstances the iRiver H100 returns 0 bytes 
> > > transferred with GOOD status and residue=512 for a READ(10) command 
> > > asking for 1 sector.  As far as I know this is legal, and it indicates the 
> > > command should simply be retried.
> > 
> > That's correct.  However, the iRiver H1xx will also commit a USB
> > protocol violation by not returning a CSW (Command Status
> > Wrapper).  That's what screws up the transfer.
> 
> In the log you posted (at the URL above) the CSW was returned correctly.  
> The same is true for the messages you referred to.  So that was not the 
> source of the problem.

Okay, quite possibly, as I was pointing out I am mostly clueless
w.r.t. USB.  But what about:

  usb-storage: usb_stor_transfer_partial(): xfer 512 bytes
  usb-storage: usb_stor_bulk_msg() returned 0 xferred 0/512
  usb-storage: Bulk data transfer result 0x1
  usb-storage: Attempting to get CSW...
               ^^^^^^^^^^^^^^^^^^^^^^^^
  usb-storage: clearing endpoint halt for pipe 0xc0011e80
  usb-storage: usb_stor_clear_halt: result=0
  usb-storage: Attempting to get CSW (2nd try)...
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  usb-storage: Bulk status result = 0
  usb-storage: Bulk status Sig 0x53425355 T 0x945 R 512 Stat 0x0
  usb-storage: -- unexpectedly short transfer
  usb-storage: Issuing auto-REQUEST_SENSE

> > Please note that:
> > 
> >  1. I am just repeating what I have been told by various people and
> >     claim no knowledge of the USB or SCSI layers.  In other words, I
> >     could be all wrong :-)
> > 
> >  2. I do not own a H1xx anymore, having returned mine.
> 
> Do you know of anyone who has contributed to any versions of this thread 
> and still does have an H1xx?

No, I did not keep track.  Nothing prevents me from "trying" another
one if you're serious about fixing the above issues.

Phil.
