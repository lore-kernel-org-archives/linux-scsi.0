From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] FW: USB 2.0 external hard drive problem
Date: Fri, 6 Feb 2004 09:59:49 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0402060946350.830-100000@ida.rowland.org>
References: <200402061211.i16CBSIw001678@burner.fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2052 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265471AbUBFO7u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2004 09:59:50 -0500
In-Reply-To: <200402061211.i16CBSIw001678@burner.fokus.fraunhofer.de>
List-Id: linux-scsi@vger.kernel.org
To: Joerg Schilling <schilling@fokus.fraunhofer.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: magliery@csb.yale.edu, appro@fy.chalmers.se, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 6 Feb 2004, Joerg Schilling wrote:

> What you see, is that some instance in the Linux kernel completely
> misshandles this transfer:
> 
> -	The drive seems to return only 34 bytes although it did advertise
> 	to return 36.
> 
> 	The correct behavior for Linux would be to set sg_io.resid = 2;
> 	and _not_ to return any error.

You're quite right that the residue value should have been set.  This is a
known bug in the usb-storage driver and a patch (as173) has already been
submitted, though not yet accepted, to fix it.  For Linux 2.6 that is, 
although the same fix will work just as well for 2.4.

> But as you may know, there is a Linux bug that causes the status to be 0 when
> sense data (correctly) is available. Libscg _needs_ to add a workarounf for
> this bug or nothing would work!

What bug is that?  Or rather, under what circumstances is the status equal 
to 0 when it shouldn't be?

> It is definitely a severe bug in the kernel to retrieve sense data in case
> of a DMA size error.

> -	The Linux kernel issues a REQUEST SENSE command ---> this is the first
> 	severe bug. It is completely wrong to issue a REQUEST SENSE in
> 	case of a DMA Size error.

> And there exactly is the bug (which is most likely in usb-storage but
> definitely in the Linux kernel:
> 
>       In case of _only_ a DMA size error, a request sense must not be
>       issued by the driver.
> 
> If you are the maintainer of this piece of software, please fix this.

(I'm not the maintainer; Matthew Dharm is.)

Who says it's wrong to retrieve sense information when there is an
underrun but not Check Condition?  Can you provide a reference to a
published (or draft) document that states this?

Bear in mind that there are some transports which do not provide any
status at all.  The _only_ way for a driver to determine whether an
error occurred is to get the sense data.

In the absence of any official statement to the contrary, the logical
conclusion is that whether or not the driver gets the sense data is a
low-level matter.  It should only be of interest to the driver and the
device.  Higher-level drivers and user programs should not care one way or
the other.

Alan Stern

