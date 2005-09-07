From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Wed, 7 Sep 2005 14:27:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509071413070.4988-100000@iolanthe.rowland.org>
References: <1126106196.4823.16.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:30938 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932183AbVIGS11
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 14:27:27 -0400
In-Reply-To: <1126106196.4823.16.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 7 Sep 2005, James Bottomley wrote:

> On Tue, 2005-07-26 at 10:12 -0400, Alan Stern wrote:
> > This patch (as542) fixes a few loose ends left by Mike's patches.  It adds 
> > a declaration for the new scsi_host_set_state routine, adds an allowed 
> > transition from the SHOST_RECOVERY state to the SHOST_CANCEL state, and 
> > avoids returning an uninitialized value in __scsi_add_device.
> 
> The first part (external declaration) is already in.
> 
> The second (allow RECOVERY->CANCEL) isn't really an answer.  The correct
> thing, I suppose, is to have scsi_remove_host() wait for the error
> handler to finish if the state transition cannot be accomodated
> (otherwise the error handler will try to transition ->RUNNING part way
> through the removal).

I'm going to argue strongly about this.  scsi_remove_host should _not_
wait for error recovery to complete -- to do so will invite deadlocks.  
(Suppose the error handler is waiting for a bus reset, but the bus reset
routine requires a semaphore held by the LLD during the call to
scsi_remove_host?)  Furthermore, error recovery can potentially take quite
a long time -- much longer than we want to wait during a removal event.  
Instead, the error handler should not be allowed to make the transition to
RUNNING once the removal has started.

> The third (don't allow uninitialised return from __scsi_add_device) is
> correct, but the return is universally ignored (the only actual user
> being ipr).  Unfortunately, now I look at this, ipr gets it wrong too.
> This API currently returns an sdev with an incremented refcount.  If you
> ignore the return, as ipr does, you're leaking refcounts.  So, since the
> only user gets it wrong all the time, I'd vote for modifying the API not
> to return a device.

Changing the API is fine with me, but the existing code is still shaky
because it calls scsi_alloc_target before checking scsi_host_scan_allowed.  
Maybe that's not an out-and-out mistake, but better to avoid it.

Would you like me to submit an updated patch?

Alan Stern

