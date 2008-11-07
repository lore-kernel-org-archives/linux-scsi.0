From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] usb-storage: Error in queuecommand: us->srb = ffff88006a338480
Date: Fri, 7 Nov 2008 10:00:29 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811070953460.2437-100000@iolanthe.rowland.org>
References: <20081107005438.GA26198@ezra.hsd1.tn.comcast.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44738 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751449AbYKGPAa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2008 10:00:30 -0500
In-Reply-To: <20081107005438.GA26198@ezra.hsd1.tn.comcast.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian Kysela <brian.kysela@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 6 Nov 2008, Brian Kysela wrote:

> On 2008-11-06 at 14:36 -0500, Alan Stern wrote: 
> > On Thu, 6 Nov 2008, Andrew Morton wrote:
> > 
> > > > The error message:
> > > > 
> > > > > [  152.701070] usb-storage: Error in queuecommand: us->srb = ffff88007dfd0680
> > > > 
> > > > means that the SCSI layer has told usb-storage to start a new command 
> > > > before the old one completed.  This could happen, for example, if the 
> > > > SCSI layer had gotten confused and tried to cancel a command that 
> > > > wasn't running -- then it would think usb-storage was idle when in fact 
> > > > it was still busy.  (This was the failure mechanism resulting from the 
> > > > timeout changes.)
> > > > 
> > > 
> > > OK, thanks.  I'll cc linux-scsi, but I have this-wont-be-getting-fixed
> > > feelings on this one :(
> > > 
> > > I wonder what's special about Brian's setup.
> > 
> > Brian, if you can use usbmon to monitor what happens during the file 
> > copy and subsequent error, it might provide a clue.  Instructions are 
> > in the kernel source file Documentation/usb/usbmon.txt.
> 
> Since it's a large file, I have posted the content of usbmon here:
> 
> http://www.kysela.org/pub/1.mon.out
> 
> I also got another kernel bug and system freeze on that copy, after the
> copy process hung, when I pulled the drive out:

This is exactly the failure mechanism I described earlier.  The usbmon
log shows that a communications error occurred and usb-storage tried to
carry out error recovery.  The drive apparently did not reset itself,
because when the READ was reissued no data was received.  In fact, the
log _ends_ at the point where the READ was reissued; no more data was
transferred in either direction.  Presumably the next thing to occur
was a command timeout.

And since the block-layer timeout code in 2.6.28-rc2 is known to be
buggy, it's not surprising that the copy process hung at that point.  
It would be better to run this test under 2.6.27; that way we might
learn something new.

Alan Stern

