From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Thu, 7 Aug 2014 11:58:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408071149100.912-100000@iolanthe.rowland.org>
References: <20140807063910.GB8151@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56766 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757509AbaHGP6i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Aug 2014 11:58:38 -0400
In-Reply-To: <20140807063910.GB8151@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tiziano Bacocco <tiziano.bacocco@gmail.com>, Douglas Gilbert <dgilbert@interlog.com>, bugzilla-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Wed, 6 Aug 2014, Christoph Hellwig wrote:

> On Wed, Aug 06, 2014 at 04:02:22PM -0400, Alan Stern wrote:
> > > I doubt either of them forces users to hack up flags for these cases.
> > 
> > Why was this change needed in the first place?  There's no explanation 
> > in the patch itself.
> 
> Which chance?  The one to not support SG_FLAG_LUN_INHIBIT?

No, the patch that started this Bugzilla entry.  Tiziano says it is 
needed in order to send vendor-specific commands that use the LUN bits 
in CDB[1].

> > > At least for windows I suspect it just never sends the LUN encoded
> > > in the CDB and treats USB devices special instead of our insistance
> > > on pretending they are SCSI-2.
> > 
> > We no longer pretend that USB mass-storage devices have any particular 
> > SCSI level.  See commit 09b6b51b0b6c.
> 
> So the origina reported device must report SCSI-2 all by itself if he's
> running a recent kernel, ok.
> 
> > > Maybe some of the USB people have on the wire traces or access to
> > > device or windows documentation on this?
> > 
> > Most likely it varies with the version of Windows and the INQUIRY data
> > returned by the device.
> > 
> > I can obtain hardware traces for the kinds of devices and computers 
> > lying around here.  But what sort of combinations should I test?
> 
> I'd mostly be interested to see if it actualy encodes the LUN in the CDB
> for any USB multi-LUN device.

I tried connecting a Linux mass-storage gadget with two logical units
to a host PC running Windows 7.  The host scanned the first logical
unit and completely ignored the second!  Didn't even send an INQUIRY 
command.

So the question remains unanswered...

Can someone tell me if anything special is needed to make Windows
recognize logical units beyond the first?

Alan Stern

