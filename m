From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Fw: [BUG] USB Storage OOPS and a D state
 process in 2.6.10
Date: Sun, 9 Jan 2005 12:32:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0501091225010.19950-100000@netrider.rowland.org>
References: <200501091526.22408.harisri@internode.on.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:58382 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S261654AbVAIRci
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jan 2005 12:32:38 -0500
In-Reply-To: <200501091526.22408.harisri@internode.on.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Srihari Vijayaraghavan <harisri@internode.on.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 9 Jan 2005, Srihari Vijayaraghavan wrote:

> On Saturday 08 January 2005 14:51, Alan Stern wrote:
> > ...
> > I see you didn't have CONFIG_USB_STORAGE_DEBUG set when you ran this test.
> 
> Actually I did. I do not know what log level the USB debug messages were, but 
> the silly syslog did not capture them. Now I have set it to write all kernel 
> messages.

It's a very common thing to overlook.  And by the way, the log level for 
the debug messages is DEBUG (what a surprise!).

> > Or else you didn't have your syslog daemon configured to store the
> > debugging messages.  If you can get anything unusual to happen with the
> > debugging enabled, it would make things much easier to track down.
> 
> That is right. I am trying to trigger the bug, and I have ensured that the USB 
> debug messages are being written to the log file. But I have not triggered 
> the bug yet.

If you're unable to trigger the bug, you can try turning the debug 
configuration option back off and using that patch I sent earlier.  It 
wouldn't hurt to use that patch even with the debugging messages...


> > Those errors are quite unusual.  They seem to indicate there's a problem
> > with your computer's USB hardware, as do the numerous spontaneous (?)
> > disconnections in your log.  However I'm not familiar with all the details
> > of the EHCI driver.  It's faintly possible that plugging the drive into a
> > different USB port would work better.
> 
> The numerous disconnections (because without debug, I can trigger the D state 
> process and oops within a dozen connection/disconnection, but with debug it 
> takes 10 times more connection/disconnection to trigger D state process, and 
> I do not know how many are needed for oops :-( ) are purposefully generated 
> to trigger the bug.

Oh, so you did those by hand.  All right.  Probably the fact that they 
come fairly close together is related to the bug.  I wonder if something 
could be causing the SCSI error handler to run when it shouldn't, using an 
out-of-date host structure?

> Of course UHCI (USB 1) is not as fast as EHCI (USB 2). Would that not matter 
> for CD/DVD burning?

It definitely will slow things down a lot.  For normal operation you would 
not want to rely on it.

Alan Stern

