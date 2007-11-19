From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: SCSI dynamic power management
Date: Mon, 19 Nov 2007 10:57:17 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0711191054360.4806-100000@iolanthe.rowland.org>
References: <20071119154650.GC12494@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35061 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754716AbXKSP5S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 10:57:18 -0500
In-Reply-To: <20071119154650.GC12494@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Oliver Neukum <oliver@neukum.name>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 19 Nov 2007, Matthew Wilcox wrote:

> On Mon, Nov 19, 2007 at 10:36:19AM -0500, Alan Stern wrote:
> > These are conflicting requirements.  How can we send the START-STOP 
> > UNIT commands to spin the disk up/down through the request queue while 
> > delaying or failing all others?
> 
> You can insert commands at the head of a request queue.

Sure.  But that won't do any good if the requests get held on the queue
(or failed immediately) because the disk is supposedly "suspended".
Somehow those requests have to be allowed to proceed while all others 
are forced to wait (or to fail).

> > What happens if one of the 
> > START-STOP UNIT commands encounters a problem and the error handler 
> > needs to send some commands of its own?
> 
> It'll do a reset and recover through the normal paths?

Not if those normal paths can't send commands through to the device.

Alan Stern

