From: Srihari Vijayaraghavan <harisri@internode.on.net>
Subject: Re: [linux-usb-devel] Fw: [BUG] USB Storage OOPS and a D state process in 2.6.10
Date: Sun, 9 Jan 2005 15:26:22 +1100
Message-ID: <200501091526.22408.harisri@internode.on.net>
References: <Pine.LNX.4.44L0.0501072239270.13748-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3.adl2.internode.on.net ([203.16.214.203]:6917 "EHLO
	smtp3.adl2.internode.on.net") by vger.kernel.org with ESMTP
	id S262247AbVAIEUL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jan 2005 23:20:11 -0500
In-Reply-To: <Pine.LNX.4.44L0.0501072239270.13748-100000@netrider.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Saturday 08 January 2005 14:51, Alan Stern wrote:
> ...
> I see you didn't have CONFIG_USB_STORAGE_DEBUG set when you ran this test.

Actually I did. I do not know what log level the USB debug messages were, but 
the silly syslog did not capture them. Now I have set it to write all kernel 
messages.

> Or else you didn't have your syslog daemon configured to store the
> debugging messages.  If you can get anything unusual to happen with the
> debugging enabled, it would make things much easier to track down.

That is right. I am trying to trigger the bug, and I have ensured that the USB 
debug messages are being written to the log file. But I have not triggered 
the bug yet.

> ...
> > Jan  8 12:35:10 desktop kernel: ehci_hcd 0000:00:10.4: port 5 reset error
> > -110 Jan  8 12:35:10 desktop kernel: hub 1-0:1.0: hub_port_status failed
> > (err = -32)
> > Jan  8 12:35:10 desktop kernel: ehci_hcd 0000:00:10.4: port 5 reset error
> > -110 Jan  8 12:35:10 desktop kernel: hub 1-0:1.0: hub_port_status failed
> > (err = -32)
>
> Those errors are quite unusual.  They seem to indicate there's a problem
> with your computer's USB hardware, as do the numerous spontaneous (?)
> disconnections in your log.  However I'm not familiar with all the details
> of the EHCI driver.  It's faintly possible that plugging the drive into a
> different USB port would work better.

The numerous disconnections (because without debug, I can trigger the D state 
process and oops within a dozen connection/disconnection, but with debug it 
takes 10 times more connection/disconnection to trigger D state process, and 
I do not know how many are needed for oops :-( ) are purposefully generated 
to trigger the bug.

Of course UHCI (USB 1) is not as fast as EHCI (USB 2). Would that not matter 
for CD/DVD burning?

> If you still can't get anything with the debugging option, try running
> without the debugging code and rmmod ehci-hcd before plugging in the
> device.  Maybe if you use a UHCI controller instead the errors won't
> occur.

OK I shall try with UHCI.

Thank you.
Hari
