From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Date: Thu, 19 Jun 2008 14:22:26 -0600
Message-ID: <20080619202226.GP4392@parisc-linux.org>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org> <20080619182310.GA30833@parisc-linux.org> <485AA7EA.6080105@s5r6.in-berlin.de> <20080619185419.GN4392@parisc-linux.org> <485AB95E.5070609@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38962 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYFSUWn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2008 16:22:43 -0400
Content-Disposition: inline
In-Reply-To: <485AB95E.5070609@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, dsd@gentoo.org, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, vegardno@ifi.uio.no, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

On Thu, Jun 19, 2008 at 09:54:06PM +0200, Stefan Richter wrote:
> [...]
> > The mail that I just pinged described a way to enhance the
> > API -- letting you tell scsi "I've started scanning, save me a place in
> > the queue" and "I've finished scanning, hook me up".
> 
> When would be the right time to say "I've started scanning"?  SCSI
> transport driver initialization?  Or end of USB/FireWire/... HCD
> registration?

You would need to call it before you could attempt to register any
devices.  So fairly early on in the initialisation of sbp2/usb-storage.

> When to say "I've finished scanning"? --- I think the answer is:  When
> (a) probing of a configurable number of SCSI targets or logical units
> was finished or (b) a configurable timeout occurs, whatever of the two
> happens first.
> 
> (Explanation, if one is necessary:  SCSI targets may pop out of the
> woods any time; it is impossible to say "from this moment on there won't
> show up any new ones anymore".  This is just as true for cold boot and
> warm boot as it is for subsequent operation.)

Yes, I do see the problem.  There's no way the SCSI core can know when
a driver has finished scanning, so I've punted to the driver to set its
own timeout here.  I know that new devices really can show up at any
time, but I think it's reasonable to say that if a machine is booted
with the same configuration as last time, the drives should show up with
the same names.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
