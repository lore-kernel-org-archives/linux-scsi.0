From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] FW: USB 2.0 external hard drive problem
Date: Mon, 9 Feb 2004 11:40:36 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0402091132000.1650-100000@ida.rowland.org>
References: <20040206205929.GB23264@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:14340 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265246AbUBIQkg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 11:40:36 -0500
In-Reply-To: <20040206205929.GB23264@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Joerg Schilling <schilling@fokus.fraunhofer.de>, magliery@csb.yale.edu, appro@fy.chalmers.se, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 6 Feb 2004, Matthew Dharm wrote:

> On Fri, Feb 06, 2004 at 10:24:25AM -0500, James Bottomley wrote:
> > On Fri, 2004-02-06 at 09:59, Alan Stern wrote:
> > > Who says it's wrong to retrieve sense information when there is an
> > > underrun but not Check Condition?  Can you provide a reference to a
> > > published (or draft) document that states this?
> > 
> > It's not wrong according to the SCSI standards, a REQUEST SENSE issued
> > to a device with no sense data will produce a NO SENSE key.
> > 
> > However, because of the way sense is processed in contingent allegiance
> > conditions (suspending the I_T_L nexus until sense is cleared) it is
> > dangerous to issue arbitrary request sense commands because you may
> > receive sense for a different command (and prevent that command from
> > erroring correctly).
> 
> You'll excuse me if I stare at you blankly after you say this?

A surfeit of jargon :-)

> If I'm guessing correctly, this is only an issue with multiple pending
> commands (i.e. TCQ or somesuch)?
> 
> A USB device only ever has one command at a time.
> 
> > The SCSI mid-layer definitely does not expect this behaviour.  A driver
> > either does not do any sense commands at all or it only issues a REQUEST
> > SENSE in response to a Check Condition status in order not to have the
> > nexus halted because of a contingent allegiance condition (simulating
> > ACA if you will).
> 
> 'Check Condition' isn't something we can directly observe.  We get 2 status
> bits back which encode "good", "bad", or "you're screwed -- you are now
> required to perform a reset".

In the absence of anything better, we're forced to assume "bad" status 
corresponds to Check Condition...

What do you think, Matt?  Should we remove the auto-sense for short 
transfers when we get "good" status?  Bearing in mind that it's 
technically legal, but other drivers or programs may not expect it?  Also 
bearing in mind that we have no choice but to auto-sense for non-IN 
transfers with the CB transport.

Maybe we should just log a KERN_DEBUG or _INFO message instead.

Alan Stern

