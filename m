From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Deadlock in usb-storage error handling
Date: Thu, 20 Mar 2014 16:43:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1403201642570.866-100000@iolanthe.rowland.org>
References: <1395347234.2244.48.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42568 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759676AbaCTUnk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2014 16:43:40 -0400
In-Reply-To: <1395347234.2244.48.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andreas Reis <andreas.reis@gmail.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 20 Mar 2014, James Bottomley wrote:

> On Thu, 2014-03-20 at 15:59 -0400, Alan Stern wrote:
> > On Thu, 20 Mar 2014, James Bottomley wrote:
> > 
> > > OK, so I think we have three things to do
> > > 
> > >      1. Investigate SCSI and fix it's abort state problem that's causing
> > >         it not to send the abort second time around
> > >      2. Fix usb-storage to fail a reset it can't do (i.e. device reset
> > >         with outstanding commands)
> > >      3. Find out why we're sending a spurious request sense.
> > > 
> > > I can look at 1 and 3 if you want to take 2.
> > 
> > I wrote a patch for 2.  It turned out not to help much, because I was
> > wrong -- while a command is running, usb-storage won't do a bus reset
> > either.  The lock occurs in a separate part of the code, where I wasn't
> > looking earlier.  When I tested the patch, the device reset failed
> > immediately (as desired) and then the attempted bus reset hung.  
> > Overall, not much of an improvement...
> 
> Hm, yes, sorry, after the bus reset fails, we'll just take the device
> offline.
> 
> > In fact, this restriction on bus resets is important and necessary.  
> > USB devices can be composite, meaning they can contain several
> > functions all packed into a single device.  If a driver for one of the
> > other functions needs to perform a bus reset, we don't want it to
> > interrupt an ongoing mass-storage command.  Thus, it is important for
> > the reset routine to wait for an outstanding command to complete.
> > 
> > Anyway, this looks to be a moot point.  With your fix for 1, neither 
> > sort of reset was necessary.
> 
> Well as long as the tiny hammer works ... but there are going to be
> devices that need the bigger one one day.

Maybe so.  I'll worry about them when they appear.  :-)

Alan Stern

