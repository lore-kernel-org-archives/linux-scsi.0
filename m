From: Dirk Hohndel <hohndel@infradead.org>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 12:01:29 -0800
Message-ID: <20090128120129.68d04cd6@infradead.org>
References: <20090127200607.369a1693@infradead.org>
	<Pine.LNX.4.44L0.0901281141300.3134-100000@iolanthe.rowland.org>
	<20090128091406.316a80fc@infradead.org>
	<1233165551.3236.99.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47347 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbZA1UBh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jan 2009 15:01:37 -0500
In-Reply-To: <1233165551.3236.99.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Wed, 28 Jan 2009 17:59:11 +0000
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > The USB stack doesn't do any filtering.  The SCSI stack is supposed to 
> > > know what commands should and should not be sent.
> > > 
> > > Furthermore, it seems quite likely this command was sent by userspace, 
> > > not by the SCSI stack -- in which case the program is supposed to know 
> > > what commands it shouldn't send.
> > 
> > Not sure I agree with that logic. If the USB stack KNOWS that
> > non-removable devices get upset by this command, then it would be
> > appropriate for it to filter those out - to protect from bugs as much
> > as to protect from denial of service attacks.
> 
> Well, I really don't think we want to get into vetting SCSI commands
> over SG_IO ... that would just trip us up on the enterprise (and
> probably never work anyway).

Yeah, I understand now and agree with you and Alan on that one...

> The problem is that hal wants to send its own SCSI commands over SG_IO.
> We've spent years trying to persuade it to put the crackpipe down and
> back away from the window ledge on this (because SCSI in the kernel
> knows better how to handle problem devices).  We have been having some
> limited success recently ... we keep enhancing what sysfs provides
> (safely) so that hal doesn't have to poke in with SG_IO unsafely.
> 
> If you can find out what the actual reason hal or whatever is doing
> this, we can have another go at them.

Any recommendations how to best approach debugging this? Attaching
strace to some processes before inserting the usb stick?

/D

-- 
Dirk Hohndel
Intel Open Source Technology Center
