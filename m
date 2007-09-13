From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [1/4] 2.6.23-rc6: known regressions
Date: Thu, 13 Sep 2007 10:19:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709131013270.3619-100000@iolanthe.rowland.org>
References: <20070913093651.GA5077@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33270 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753595AbXIMOTw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Sep 2007 10:19:52 -0400
In-Reply-To: <20070913093651.GA5077@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Oliver Neukum <oneukum@suse.de>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 13 Sep 2007, Greg KH wrote:

> Ok, after conferring with Oliver this morning, I think the best solution
> here is to both revert the usb-storage suspend patch as it has some
> basic problems that can cause data loss, _and_ add the change to the
> kernel that by default disables autosuspend on all USB devices except
> hubs.

Are you referring to the disk spin-down issue?  As far as I know, 
that's the only troublesome aspect of usb-storage autosuspend (apart 
from the fact that so many devices don't seem to support it very well, 
if at all).

Solving the spin-down problem will require coordination with the SCSI 
developers.  Basically, the SCSI core has to notify the HBA driver 
whenever the bus has been idle sufficiently long and all its devices 
are ready to be suspended.  In particular, all disk heads should be 
parked and drives spun down, if they need to be.

Alan Stern

