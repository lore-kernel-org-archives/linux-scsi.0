From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Tue, 21 Jun 2005 16:04:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506211526360.634-100000@iolanthe.rowland.org>
References: <20050621171209.GB29396@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:1953 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S262290AbVFUUEH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 16:04:07 -0400
In-Reply-To: <20050621171209.GB29396@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 21 Jun 2005, Mike Anderson wrote:

> > --- a/include/scsi/scsi_host.h	Mon Jun 13 14:57:26 2005
> > +++ b/include/scsi/scsi_host.h	Fri Jun 17 22:19:09 2005
> > @@ -411,6 +411,7 @@
> >  	SHOST_DEL,
> >  	SHOST_CANCEL,
> >  	SHOST_RECOVERY,
> > +	SHOST_REMOVE,
> >  };
> 
> Well it is a larger change we should consider migrating the shost state
> model to one like the scsi device uses and also align on similar states
> if possible.

For now I just wanted to make as simple a patch as possible.  I have no 
objection to making a larger change like the one you suggest.

> >  struct Scsi_Host {
> > --- a/drivers/scsi/hosts.c	Mon Jun 13 14:57:14 2005
> > +++ b/drivers/scsi/hosts.c	Fri Jun 17 22:20:19 2005
> > @@ -74,8 +74,13 @@
> >   **/
> >  void scsi_remove_host(struct Scsi_Host *shost)
> >  {
> > -	scsi_forget_host(shost);
> > +	set_bit(SHOST_REMOVE, &shost->shost_state);
> >  	scsi_host_cancel(shost, 0);
> > +
> > +	down(&shost->scan_mutex);	/* Wait for scanning to stop */
> > +	up(&shost->scan_mutex);
> > +
> > +	scsi_forget_host(shost);
> >  	scsi_proc_host_rm(shost);
> >  
> >  	set_bit(SHOST_DEL, &shost->shost_state);
> 
> Moving scsi_forget_host to after scsi_host_cancel will cause the sd cache
> flush routines to fail.

This objection runs up against an issue we discussed some time ago.  
Should the intended meaning of scsi_remove_host be simply that the kernel
needs to stop using the HBA reasonably soon?  In that case you are right.  
Or should the intended meaning be that the HBA is actually gone
(hot-unplugged) and all further attempts to use it will fail?  In that
case it doesn't matter.  The best ways to resolve this issue may be to
have a separate scsi_host_gone routine or to add an extra argument to
scsi_remove_host.

At any rate, we currently face the bigger problem that if scsi_forget_host
comes first then scsi_host_cancel doesn't work right.  Outstanding
commands do not get cancelled.  I didn't try to trace down the exact
reason for this; I just did the simplest thing to make it work.

>  Also as previously mentioned I would like to
> understand if we still need the cancel functionality. I believe there are
> end case races with cancel and LLDD really should be able to return all
> commands prior to calling scsi_remove_host or post (prior to the last
> shost put).

I rather agree in principle that the cancel functionality isn't really
needed.  Removing it will require some tricky changes to the LLDDs,
however.  And the changes will all have to be made at once.  If some LLDDs 
are changed and others aren't, then (depending on whether scsi_host_cancel 
has been removed) either the changed ones will oops as they try to cancel 
an already-cancelled command or the unchanged ones will oops as 
uncancelled commands time out.  I've seen both kinds of errors in working 
with usb-storage.

> The bit is set to SHOST_REMOVE then scsi_host_cancel is called which will
> set the bit SHOST_CANCEL. Later on scan is stopped only if state is
> SHOST_REMOVE. Is that what you wanted?

Remember, at the moment the state is a bit-vector.  It can have both
SHOST_CANCEL and SHOST_REMOVE set at the same time.  That is what I
wanted.  Changing to a host state model will of course require you to do
things differently.

> >  int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
> > @@ -1347,11 +1363,14 @@
> >  		return -EINVAL;
> >  
> >  	down(&shost->scan_mutex);
> > +	if (test_bit(SHOST_REMOVE, &shost->shost_state))
> > +		goto out;
> >  	if (channel == SCAN_WILD_CARD) 
> >  		for (channel = 0; channel <= shost->max_channel; channel++)
> >  			scsi_scan_channel(shost, channel, id, lun, rescan);
> >  	else
> >  		scsi_scan_channel(shost, channel, id, lun, rescan);
> > +out:
> >  	up(&shost->scan_mutex);
> >  
> >  	return 0;
> 
> It might be better to have a wrapper function so if we change the cases
> where we would allow scanning we can change just one place. Also we might
> cover more states if we reverse the logic on the check and look for the
> case we allow scanning (see previous comment about cancel). This is what I
> did in my previous patch.

That's okay with me.  So long as all the scanning pathways are covered and 
all scanning is stopped before scsi_forget_host runs, you can feel free to 
improve the implementation details.

> > @@ -1383,23 +1402,17 @@
> >  
> >  void scsi_forget_host(struct Scsi_Host *shost)
> >  {
> > -	struct scsi_target *starget, *tmp;
> > +	struct scsi_device *sdev;
> >  	unsigned long flags;
> >  
> > -	/*
> > -	 * Ok, this look a bit strange.  We always look for the first device
> > -	 * on the list as scsi_remove_device removes them from it - thus we
> > -	 * also have to release the lock.
> > -	 * We don't need to get another reference to the device before
> > -	 * releasing the lock as we already own the reference from
> > -	 * scsi_register_device that's release in scsi_remove_device.  And
> > -	 * after that we don't look at sdev anymore.
> > -	 */
> > +restart:
> >  	spin_lock_irqsave(shost->host_lock, flags);
> > -	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
> > +	list_for_each_entry(sdev, &shost->__devices, siblings) {
> > +		if (sdev->sdev_state == SDEV_DEL)
> > +			continue;
> >  		spin_unlock_irqrestore(shost->host_lock, flags);
> > -		scsi_remove_target(&starget->dev);
> > -		spin_lock_irqsave(shost->host_lock, flags);
> > +		scsi_remove_device(sdev);
> > +		goto restart;
> >  	}
> >  	spin_unlock_irqrestore(shost->host_lock, flags);
> >  }
> 
> Well it saves some some overhead we really should delete the parent
> and let it handle cleanup of children. If we switch to using the driver
> model lists the code would be easier to migrate.

I didn't do it that way because it can't be made to work correctly with
the current code -- there's no way to know whether a target has already
been removed.  Adding a target state model would make your approach
feasible, but James has said that targets don't merit a state model.

Driver model klists also have their disadvantages.  If you delete a node 
from a klist asynchronously then you cannot re-use it; it must be allowed 
to deallocate itself when the refcount goes to 0.  And it's not possible 
to remove nodes from a klist synchronously while traversing the klist.

Alan Stern

