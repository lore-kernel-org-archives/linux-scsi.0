From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] fix sd open/remove race
Date: Fri, 9 Apr 2004 14:29:09 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404091419520.1932-100000@ida.rowland.org>
References: <1081526932.2203.61.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:16644 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261430AbUDIS3K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2004 14:29:10 -0400
In-Reply-To: <1081526932.2203.61.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 9 Apr 2004, James Bottomley wrote:

> But, as I pointed out before, you can't clear the indicator in sd_remove
> because, fundamentally, that's not where the race is.  The fundamental
> race is the get/put one making sure no-one can get a reference to a
> freed object.
> 
> sd_remove is just the disconnection indication.  It triggers a put of
> the object, causing garbage collection if it's the last put, but that's
> all it does.  To mediate the race, the synchronisation has to be around
> object acquisition/deallocation.

I understand you now.  It's really a matter of what one is trying to 
protect by the synchronization:

	You want to prevent anyone from acquiring a reference to the
	object after it has been deallocated.  Hence you use the
	semaphore around the get and the put.

	I want to prevent anyone from acquiring a reference to the
	object after the driver has decided that no more references
	should be given out, i.e., after sd_remove has been called.
	Hence I use the semaphore around the get and in the remove.

Both approaches are valid.


There's a somewhat similar problem that arises in the relation between the
SCSI core and the low-level drivers.  Here the data structure in question
is the host template.  (Yes, LLDs don't normally deallocate their host
templates, but if they are built as modules they can be unloaded from
memory, which has the same effect.)  After calling scsi_remove_host() the
LLD has no way to know when the SCSI core is finished using the template.

Mike Anderson has suggested that scsi_remove_host could replace the hostt
pointer with a pointer to a dummy template that will fail every operation.
There may still be difficulties involving the procfs interface, though.

Alan Stern

