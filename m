From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down
 disk
Date: Thu, 27 Sep 2007 15:07:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709271455080.7735-100000@iolanthe.rowland.org>
References: <200709272012.15567.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37089 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755157AbXI0THs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 15:07:48 -0400
In-Reply-To: <200709272012.15567.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thu, 27 Sep 2007, Oliver Neukum wrote:

> > Oliver, I'm surprised at you!  This patch is a big hack, not to mention 
> > a layering violation and an inversion of the proper calling sequence.
> 
> Well,
> 
> 1. autosuspend should not be specific to USB

Correct.  Which means support for it should be added to the SCSI
drivers.  SCSI autosuspend shouldn't be kluged into usb-storage in a
way that basically ignores what the SCSI layer is doing.

> 2. I like to view the generic SCSI code as a library

That viewpoint might work out okay in some cases, but I don't think 
it's tenable when dealing with high-level drivers like sd and sr.

> 3. The low level drivers will have to decide whether to suspend devices,
> as the generic code doesn't know whether the bus is shared.

I'm having trouble understanding this; it's a bit ambiguous.  Does
"devices" mean "SCSI devices", "host adapter devices", or both?  Does
"generic code" refer to the SCSI core, the high-level SCSI drivers, or
something else?  When you say the bus is "shared", do you mean there
are multiple SCSI devices attached to it or do you mean something else?  
(I assume you mean something else, as the SCSI core certainly does know
when multiple SCSI devices are attached to a SCSI bus.)

In any case, that's not how I would put it.  The SCSI core and
high-level drivers will have to decide when they are not using SCSI
devices and the devices can be suspended.  When all the devices the
SCSI core knows about are suspended, it should tell the LLD.  Then the
LLD can suspend the bus and the host adapter, whatever is appropriate,
based on its own private knowledge.

Alan Stern

