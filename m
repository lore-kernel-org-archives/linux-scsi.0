From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Mon, 8 Aug 2005 18:30:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0508081829070.4470-100000@iolanthe.rowland.org>
References: <42F7DAA5.7070208@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:20352 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932304AbVHHWat
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 18:30:49 -0400
In-Reply-To: <42F7DAA5.7070208@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Mike Anderson <andmike@us.ibm.com>

On Mon, 8 Aug 2005, Luben Tuikov wrote:

> On 08/08/05 16:41, Alan Stern wrote:
> > I still have one related question.  This is a little bit off to one 
> > side, but maybe you folks can suggest possible solutions.  The question 
> > concerns a deadlock I _was_ able to generate earlier today with a patched
> > usb-storage.
> > 
> > My USB mass-storage test device doesn't respond to TEST UNIT READY, so it
> > causes a timeout and kicks the error handler into action.  This happens 
> > during device scanning, just prior to reading the partition table.  The 
> > error handler goes through various stages of processing, leading up to a 
> > bus reset.  I disconnected the USB device just before the bus reset 
> > routine was called.
> 
> I think that "scanning" is a special process which should involve
> the minimum of error handling, by either ignoring errors and trying
> to connect to the device anyway, or on the first error, give up
> the device.  Which policy would one follow depends on the transport.

No, that's not feasible.  We can't just ignore errors, and we do have to 
cope with them.  Scanning is a particular vulnerable time, since it 
involves sending commands that don't occur most of the time during normal 
operation.

> If the latter, you need to blacklist the device as not supporting
> TUR.  Then on any error, like you pulling the cable during scanning,
> the scanning process will give up and all will be well.

You can't blacklist devices you don't know about.  The kernel should work 
regardless.

Alan Stern

