From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: usb-strage not working in the latest kernel 2.4
Date: Mon, 8 Sep 2003 10:12:21 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309081003080.928-100000@ida.rowland.org>
References: <200309070128.KAA28169@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3844 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262377AbTIHOMY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2003 10:12:24 -0400
In-Reply-To: <200309070128.KAA28169@toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, David Brownell <david-b@pacbell.net>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

On Sun, 7 Sep 2003, Tomita, Haruo wrote:

> I am also looking at this pattern repeatedly.
> It seems that a device does not answer in the case of kernel 2.4.
> However, when operating by kernel 2.6 and two or more devices
> are connected simultaneously, it operates. 
> I cannot think the error of a device.

Don't be too sure.  It could be that 2.4 and 2.6 are sending different 
data to the device, but for both systems the data is correct and the 
device _should_ work correctly.  Maybe it's a device error that causes it 
to work okay with the data from 2.6 but not the data from 2.4.

> Alan> This time the bus_reset() routine worked, which is an 
> Alan> improvement over 
> Alan> what you were seeing before.  But the device still didn't respond:
> 
> If a device becomes an error, it seems that reset is not effective.
> Using ioctl (fd, USBDEVFS_RESET, 0) and this device,  
> Is checking whether a device can reset correctly by 
> performing effective?

Go ahead and try it.  I expect it will reset correctly when you test it 
like this, but it won't reset correctly after one of those errors occurs 
and the device stops responding.  That's just a guess.

> Alan> Once that happened there were no error recovery procedures 
> Alan> left to try, so 
> Alan> the driver gave up and marked the device offline.
> 
> Doesn't a device receive any commands?

The system sent commands, but the device didn't respond to them.  However, 
it's possible that this patch will help.  Try it out and see what happens.

--- 2.4.22/drivers/usb/storage/protocol.c.orig	Mon Aug 25 07:44:42 2003
+++ 2.4.22/drivers/usb/storage/protocol.c	Fri Sep  5 16:20:26 2003
@@ -237,6 +237,10 @@
 	 * a unsigned char cmnd[12], so we know we have storage available
 	 */
 
+	/* Pad the ATAPI command with zeros */
+	for (; srb->cmd_len<12; srb->cmd_len++)
+		srb->cmnd[srb->cmd_len] = 0;
+
 	/* set command length to 12 bytes (this affects the transport layer) */
 	srb->cmd_len = 12;
 
> > > 2.  usb_stor_bulk_msg() returned -32
>  
> Alan> Under what circumstances did this error occur?  It must have 
> Alan> been quite different from the other error.
> 
> The used device(Logitec LCW-WIN40U2) is different. 
> It is the same circumstances except a device.

But when the error occurred, had you just plugged in the drive?  Or had it 
been running already for some time?  What were you doing when the error 
occurred?  Was there some reason that the drive returned an error code 
meaning it had just been reset?

> If a SCSI driver performs retry, 
> is it that usb-storage can also restart processing?

usb-storage doesn't do its own retries.  Only the SCSI driver does.  But
when the SCSI driver retries a command, it sends a new copy of the command
to usb-storage, so usb-storage sends the new copy of the command to the 
device.

Alan Stern

