From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Tue, 23 Sep 2003 11:16:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309231114050.15373-100000@home.osdl.org>
References: <3F708718.4050401@xs4all.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:14259 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263397AbTIWSQh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 14:16:37 -0400
In-Reply-To: <3F708718.4050401@xs4all.nl>
List-Id: linux-scsi@vger.kernel.org
To: Ruud Linders <rkmp@xs4all.nl>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andries.Brouwer@cwi.nl


On Tue, 23 Sep 2003, Ruud Linders wrote:
> 
> I tried the patch but it doesn't work for me using an USB-2 Memory stick
> "DiskonKey" on an USB-2 port (with uhci_hcd & ehci_hcd loaded).
> 
> After a 3 minute time-out I get
>      "SCSI device sda: drive cache: write through"
> and the device starts working just fine.

Is this different from a plain kernel _without_ the patch?

> Unloading the ehci_hcd module doesn't make any difference.
> Only when ripping out the whole mode-sense call it works immediately :-)
> so it appears the device is just unhappy about the sd_do_mode_sense.

Yes, I think we might want to mark USB devices as being write-through by 
default. That said, I think the patch is still better than what we have 
now (which just doesn't make any sense at all).

		Linus

