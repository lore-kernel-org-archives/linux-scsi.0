From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 15:01:17 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309221455280.2524-100000@ida.rowland.org>
References: <20030922182142.A26720@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:54788 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263271AbTIVTBS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 15:01:18 -0400
In-Reply-To: <20030922182142.A26720@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Linus Torvalds <torvalds@osdl.org>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 22 Sep 2003, Christoph Hellwig wrote:

> If we want drivers to mess with blist flags that's the more general
> solution, yes.  But the blist flags really are a target thing and
> I'd prefer to keep host drivers a bit away from this.  Of course
> this doesn't really work for the usb case where the host driver only
> deals with emulated targets that are all completly hosed.
> 
> Maybe sdev->scsi_level should recognize a new level, SCSI_TOTALLY_B0RKED
> for those usb-storage devices where the vendor somehow heard of the
> spec but nothing that isn't excercised by the windows drivers has
> the slightest chance of working..

Please be careful when setting this up.  The mode-sense pages are vitally
important for USB CD devices, and they all seem to work fine.  It's just
the disk-type devices that have been causing trouble.

Many of them seem to share the failure mode observed by Linus: when asked
to send 128 bytes of m-s page 8 they apparently forget that the connection
is only full-speed with a 64-byte packet maximum, and they try to send all
128 bytes in a single packet.  But other failure modes have cropped up as
well.

Alan Stern

