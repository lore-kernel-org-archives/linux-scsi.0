From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: bug 2400
Date: Thu, 8 Apr 2004 14:33:16 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404081430000.961-100000@ida.rowland.org>
References: <1081441444.6859.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:22788 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262182AbUDHSdR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2004 14:33:17 -0400
In-Reply-To: <1081441444.6859.14.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Matt Gulick <gulickconsulting@direcway.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 8 Apr 2004, Matt Gulick wrote:

> OK, Silly question or maybe not.
> 
> When writing drivers for MacOS ( 7-9 & X) and Windose (98 - XP) and when
> I architected the USB 2.0 stack at Adaptec for 98SE, ME & 2k, we solved
> this issue with a simple heart beat task.
> 
> Every so often (1-3 seconds) any device that was at risk of removal
> would receive a TEST UNIT READY cdb.
> 
> Using the model of 1394, USB, ... being treated as a device with no
> media inserted (like a CD drive is treated), then you can query the
> device for media availability.
> 
> Using the USB model of 7 tiers of devices and most hubs having 4 ports
> (7 port hubs are just two 4 port hubs internally connected) you can have
> way more than 15 SCSI ID's.  By treating each USB as having its own ID
> (EHCI USB chips typically have three USB identities of 1 EHCI and 2 OHCI
> interfaces) and the devices on that bus that are mass storage class
> devices using SBP-2 or SBP-3 would be a LUN on that device.
> 
> By treating each bus as a virtual device, the main struct can be static
> with LUN children added or removed as needed.
> 
> Any thoughts on this?
> 
> Matt

I think you're talking about a different problem.  Sending heartbeats 
solves the problem of detecting media availability and device 
availability.  It doesn't solve the problem we're discussing here, which 
is how to tear down the device driver stack without causing any errors, 
particularly if the user tries to access the device while the stack is 
being deconstructed.

Alan Stern

