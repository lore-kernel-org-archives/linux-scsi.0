From: Matt Gulick <gulickconsulting@direcway.com>
Subject: Re: bug 2400
Date: Thu, 08 Apr 2004 11:24:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081441444.6859.14.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0404080941420.961-100000@ida.rowland.org>
Reply-To: gulickconsulting@direcway.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a34-mta01.direcpc.com ([66.82.4.90]:8670 "EHLO
	a34-mta01.direcway.com") by vger.kernel.org with ESMTP
	id S262005AbUDHQY1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 12:24:27 -0400
Received: from [40.0.0.57] (dpc6935101125.direcpc.com [69.35.101.125])
 by a34-mta01.direcway.com
 (iPlanet Messaging Server 5.2 HotFix 1.12 (built Feb 13 2003))
 with ESMTP id <0HVV008PX1K642@a34-mta01.direcway.com> for
 linux-scsi@vger.kernel.org; Thu, 08 Apr 2004 12:24:26 -0400 (EDT)
In-reply-to: <Pine.LNX.4.44L0.0404080941420.961-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>


> There is implicitly _a_ notification, because when the child device is 
> released it drops its reference to the parent (I still think this would be 
> better if it were done differently, but never mind).  However that doesn't 
> do the intermediate driver any good, because the driver doesn't own the 
> parent!  The parent is owned by the higher subsystem.
> 
> A general solution is to have the lower subsystem take a pointer to a 
> kobject (or even a kref) belonging to the intermediate driver, and have it 
> drop its reference when the child device is released.  This approach is 
> just as flexible as the callback made by usbcore.
> 
> It could even be formalized as part of the driver model, although I'm not
> at all certain this would be a good idea.  The concept is simple enough: A
> struct device (or maybe a struct kobject) would have as an additional
> member a pointer to a struct kobject (or maybe to a struct kref).  Call
> this additional member "master".  During the device release (or kobject
> cleanup) the core would do a put on the master pointer if it is set.
> 
> It's not clear that a sufficiently high percentage of all kobjects follow 
> this intermediate-driver pattern for it to be worthwhile adding the master 
> pointer.  But individual systems can still implement it on their own, and 
> they should.

OK, Silly question or maybe not.

When writing drivers for MacOS ( 7-9 & X) and Windose (98 - XP) and when
I architected the USB 2.0 stack at Adaptec for 98SE, ME & 2k, we solved
this issue with a simple heart beat task.

Every so often (1-3 seconds) any device that was at risk of removal
would receive a TEST UNIT READY cdb.

Using the model of 1394, USB, ... being treated as a device with no
media inserted (like a CD drive is treated), then you can query the
device for media availability.

Using the USB model of 7 tiers of devices and most hubs having 4 ports
(7 port hubs are just two 4 port hubs internally connected) you can have
way more than 15 SCSI ID's.  By treating each USB as having its own ID
(EHCI USB chips typically have three USB identities of 1 EHCI and 2 OHCI
interfaces) and the devices on that bus that are mass storage class
devices using SBP-2 or SBP-3 would be a LUN on that device.

By treating each bus as a virtual device, the main struct can be static
with LUN children added or removed as needed.

Any thoughts on this?

Matt

----------------------------------------
Matt Gulick
Sr. Staff Engineer
Adaptec, Inc.
gulickconsulting@direcway.com
matt_gulick@adaptec.com
(715) 426-0884


