From: Matt Gulick <gulickconsulting@direcway.com>
Subject: Re: bug 2400
Date: Thu, 08 Apr 2004 14:44:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081453443.4777.5.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0404081430000.961-100000@ida.rowland.org>
Reply-To: gulickconsulting@direcway.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a34-mta01.direcpc.com ([66.82.4.90]:57896 "EHLO
	a34-mta01.direcway.com") by vger.kernel.org with ESMTP
	id S262316AbUDHToX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 15:44:23 -0400
Received: from [40.0.0.57] (dpc6935101125.direcpc.com [69.35.101.125])
 by a34-mta01.direcway.com
 (iPlanet Messaging Server 5.2 HotFix 1.12 (built Feb 13 2003))
 with ESMTP id <0HVV00891ATHUF@a34-mta01.direcway.com> for
 linux-scsi@vger.kernel.org; Thu, 08 Apr 2004 15:44:22 -0400 (EDT)
In-reply-to: <Pine.LNX.4.44L0.0404081430000.961-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-04-08 at 13:33, Alan Stern wrote:
> On Thu, 8 Apr 2004, Matt Gulick wrote:
> 
> > OK, Silly question or maybe not.
> > 
> > When writing drivers for MacOS ( 7-9 & X) and Windose (98 - XP) and
> when
> > I architected the USB 2.0 stack at Adaptec for 98SE, ME & 2k, we
> solved
> > this issue with a simple heart beat task.
> > 
> > Every so often (1-3 seconds) any device that was at risk of removal
> > would receive a TEST UNIT READY cdb.
> > 
> > Using the model of 1394, USB, ... being treated as a device with no
> > media inserted (like a CD drive is treated), then you can query the
> > device for media availability.
> > 
> > Using the USB model of 7 tiers of devices and most hubs having 4
> ports
> > (7 port hubs are just two 4 port hubs internally connected) you can
> have
> > way more than 15 SCSI ID's.  By treating each USB as having its own
> ID
> > (EHCI USB chips typically have three USB identities of 1 EHCI and 2
> OHCI
> > interfaces) and the devices on that bus that are mass storage class
> > devices using SBP-2 or SBP-3 would be a LUN on that device.
> > 
> > By treating each bus as a virtual device, the main struct can be
> static
> > with LUN children added or removed as needed.
> > 
> > Any thoughts on this?
> > 
> > Matt
> 
> I think you're talking about a different problem.  Sending heartbeats 
> solves the problem of detecting media availability and device 
> availability.  It doesn't solve the problem we're discussing here,
> which 
> is how to tear down the device driver stack without causing any
> errors, 
> particularly if the user tries to access the device while the stack is
> being deconstructed.
> 
> Alan Stern

True.  This only mitigates the need for the SCSI subsystem from having
to release device structures that might be used for logical SCSI Bus
housekeeping.

I will have to dig into the Linux architecture model for SCSI to put
this in Linux form vs what is done elsewhere.

I'll be back.  ;-)

Matt


----------------------------------------
Matt Gulick
Sr. Staff Engineer
Adaptec, Inc.
gulickconsulting@direcway.com
matt_gulick@adaptec.com
(715) 426-0884


