From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Fw: garbled usb storage scsi vendor & model
 in 2.6.19-rc1
Date: Mon, 23 Oct 2006 10:05:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0610231002400.6401-100000@iolanthe.rowland.org>
References: <Pine.SOC.4.61.0610230724360.15328@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49157 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751094AbWJWOFS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Oct 2006 10:05:18 -0400
In-Reply-To: <Pine.SOC.4.61.0610230724360.15328@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Andrew Morton <akpm@osdl.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 23 Oct 2006, Meelis Roos wrote:

> >> scsi 2:0:0:0: Direct-Access     ugin.upd .dpkg-new  PQ: 0 ANSI: 0 CCS
> >>
> >> The data is garbage here (obviously I'm running debian and have done
> >> daily upgrade recently). Other than that message, the device appeared
> >> running fine. But it still worries.
> >
> > Try using the patch below.  If you still see the same garbage showing up,
> > it must be because the drive is sending this garbage to your computer.
> 
> Tried the patch, still garbage. It returns different garbage each time, 
> and it has returned sensible data before. Since the garbage contains 
> debian-specific strings sometimes, it seems to come from system RAM 
> (someone is overwriting scsi data?).
> 
> This is not x86_64 specific, the same happened on yesterdays 
> 2.6.19-rc2+git on i386. Have not yet compiled and older kernel to really 
> see if it still works with older kernel.

Here's the best thing to do to find out what is really happening:  Use the
usbmon facility to see exactly what data bytes are being sent to the
computer (instructions in Documentation/usb/usbmon.txt).  This will tell
us for certain whether those garbage bytes are left-over junk in RAM or
the device is actually sending them.

You don't even need to use the patch I sent for this test, although it 
won't hurt.

Alan Stern

