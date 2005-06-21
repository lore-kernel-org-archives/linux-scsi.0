From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Tue, 21 Jun 2005 17:37:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506211727040.1365-100000@iolanthe.rowland.org>
References: <20050621210817.GC30526@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:20389 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S262489AbVFUVhM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 17:37:12 -0400
In-Reply-To: <20050621210817.GC30526@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 21 Jun 2005, Mike Anderson wrote:

> > I rather agree in principle that the cancel functionality isn't really
> > needed.  Removing it will require some tricky changes to the LLDDs,
> > however.  And the changes will all have to be made at once.  If some LLDDs 
> > are changed and others aren't, then (depending on whether scsi_host_cancel 
> > has been removed) either the changed ones will oops as they try to cancel 
> > an already-cancelled command or the unchanged ones will oops as 
> > uncancelled commands time out.  I've seen both kinds of errors in working 
> > with usb-storage.
> 
> We really should have scsi_times_out check the state of the host and
> possible the device to stop calling into the host when removes are in
> progress.

Or when removes have been completed!

> > That's okay with me.  So long as all the scanning pathways are covered and 
> > all scanning is stopped before scsi_forget_host runs, you can feel free to 
> > improve the implementation details.
> > 
> 
> I already did this in the previous patch series I posted, but received not
> comments so I guess there is no need to wrap it.

I haven't had a chance to take a detailed look at your changes.  In fact I
wasn't even aware of them until yesterday (because I'm not subscribed to
linux-scsi).  I'll try them out when there's time.

> > Driver model klists also have their disadvantages.  If you delete a node 
> > from a klist asynchronously then you cannot re-use it; it must be allowed 
> > to deallocate itself when the refcount goes to 0.  And it's not possible 
> > to remove nodes from a klist synchronously while traversing the klist.
> 
> Is this still true for klists. I thought the locking updates and the
> addition of a klist_iter was to fix this issue though I have not spent
> much time looking through the code since the changes.

klist_iter fixes the problem of one thread deleting nodes while another
thread is traversing the klist.  However the deleted nodes aren't marked
in any way, so the traversing thread might not realize they had been
deleted.  Also, since the klist_iter itself holds a reference to the
deleted node you can't do a synchronous remove -- it will deadlock.

This ended up causing difficulties for the driver_detach routine in the 
driver model core.  I had to rewrite it, avoiding the use of a klist_iter.

Alan Stern

