From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Suggested patch for testing last sector of USB devices
Date: Sun, 21 Dec 2008 19:51:49 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0812211947430.30767-100000@netrider.rowland.org>
References: <494E8531.3000205@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1879 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751273AbYLVAvv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Dec 2008 19:51:51 -0500
In-Reply-To: <494E8531.3000205@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Sun, 21 Dec 2008, Stefan Richter wrote:

> Alan Stern wrote:
> > --- usb-2.6.orig/include/scsi/scsi_device.h
> > +++ usb-2.6/include/scsi/scsi_device.h
> > @@ -142,6 +142,7 @@ struct scsi_device {
> >  	unsigned select_no_atn:1;
> >  	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
> >  	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
> > +	unsigned check_capacity:1;	/* Verify READ_CAPACITY result */
> 
> Maybe add "ignored if no USB_STORAGE support is built" to the comment
> since it is a no-op otherwise:

Yes.  As it happens I wrote this comment before writing the rest of the
patch, and the "#if" protection around the code was an afterthought.  
In practice, if other transports can make use of this test then the
"#if" can be removed.

Since only one or two firewire/ieee1394 devices have the FIX_CAPACITY 
quirk, it didn't look like you'd be very interested in using the test.

Alan Stern

