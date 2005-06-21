From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Tue, 21 Jun 2005 14:08:17 -0700
Message-ID: <20050621210817.GC30526@us.ibm.com>
References: <20050621171209.GB29396@us.ibm.com> <Pine.LNX.4.44L0.0506211526360.634-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:30682 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262384AbVFUVII (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 17:08:08 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5LL85IL005493
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 17:08:05 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5LL85W1247598
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 17:08:05 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5LL7t8d022236
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 17:07:55 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0506211526360.634-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> > Moving scsi_forget_host to after scsi_host_cancel will cause the sd cache
> > flush routines to fail.
> 
> This objection runs up against an issue we discussed some time ago.  
> Should the intended meaning of scsi_remove_host be simply that the kernel
> needs to stop using the HBA reasonably soon?  In that case you are right.  
> Or should the intended meaning be that the HBA is actually gone
> (hot-unplugged) and all further attempts to use it will fail?  In that
> case it doesn't matter.  The best ways to resolve this issue may be to
> have a separate scsi_host_gone routine or to add an extra argument to
> scsi_remove_host.
> 

I believe this was discussed in the thread below or possible another (we
have had this conversation a number of times), and the action then was not
to create another interface.
http://marc.theaimsgroup.com/?t=108701426000002&r=1&w=2


> I rather agree in principle that the cancel functionality isn't really
> needed.  Removing it will require some tricky changes to the LLDDs,
> however.  And the changes will all have to be made at once.  If some LLDDs 
> are changed and others aren't, then (depending on whether scsi_host_cancel 
> has been removed) either the changed ones will oops as they try to cancel 
> an already-cancelled command or the unchanged ones will oops as 
> uncancelled commands time out.  I've seen both kinds of errors in working 
> with usb-storage.

We really should have scsi_times_out check the state of the host and
possible the device to stop calling into the host when removes are in
progress.

> 
> > The bit is set to SHOST_REMOVE then scsi_host_cancel is called which will
> > set the bit SHOST_CANCEL. Later on scan is stopped only if state is
> > SHOST_REMOVE. Is that what you wanted?
> 
> Remember, at the moment the state is a bit-vector.  It can have both
> SHOST_CANCEL and SHOST_REMOVE set at the same time.  That is what I
> wanted.  Changing to a host state model will of course require you to do
> things differently.

Yes, I guess I should know that :-(. I had my head in the new host state
model. Yes changing to the host state model did require some different
checks, but the concept is the same.

> 
> > >  int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
> > > @@ -1347,11 +1363,14 @@
> > >  		return -EINVAL;
> > >  
> > >  	down(&shost->scan_mutex);
> > > +	if (test_bit(SHOST_REMOVE, &shost->shost_state))
> > > +		goto out;
> > >  	if (channel == SCAN_WILD_CARD) 
> > >  		for (channel = 0; channel <= shost->max_channel; channel++)
> > >  			scsi_scan_channel(shost, channel, id, lun, rescan);
> > >  	else
> > >  		scsi_scan_channel(shost, channel, id, lun, rescan);
> > > +out:
> > >  	up(&shost->scan_mutex);
> > >  
> > >  	return 0;
> > 
> > It might be better to have a wrapper function so if we change the cases
> > where we would allow scanning we can change just one place. Also we might
> > cover more states if we reverse the logic on the check and look for the
> > case we allow scanning (see previous comment about cancel). This is what I
> > did in my previous patch.
> 
> That's okay with me.  So long as all the scanning pathways are covered and 
> all scanning is stopped before scsi_forget_host runs, you can feel free to 
> improve the implementation details.
> 

I already did this in the previous patch series I posted, but received not
comments so I guess there is no need to wrap it.

> 
> I didn't do it that way because it can't be made to work correctly with
> the current code -- there's no way to know whether a target has already
> been removed.  Adding a target state model would make your approach
> feasible, but James has said that targets don't merit a state model.
> 
> Driver model klists also have their disadvantages.  If you delete a node 
> from a klist asynchronously then you cannot re-use it; it must be allowed 
> to deallocate itself when the refcount goes to 0.  And it's not possible 
> to remove nodes from a klist synchronously while traversing the klist.

Is this still true for klists. I thought the locking updates and the
addition of a klist_iter was to fix this issue though I have not spent
much time looking through the code since the changes.

-andmike
--
Michael Anderson
andmike@us.ibm.com

