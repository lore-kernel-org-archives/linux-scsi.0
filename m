From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
	directories.
Date: Wed, 27 May 2009 21:42:30 +0000
Message-ID: <1243460550.6067.82.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0905271710040.2669-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55684 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755153AbZE0Vma (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2009 17:42:30 -0400
In-Reply-To: <Pine.LNX.4.44L0.0905271710040.2669-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

On Wed, 2009-05-27 at 17:31 -0400, Alan Stern wrote:
> On Wed, 27 May 2009, James Bottomley wrote:
> 
> > > I can't tell whether you understood my point.  After a scsi_device is
> > > unregistered but before it is released -- i.e., when its state is
> > > SDEV_DEL -- it _is_ essentially unusable.  So why wait until it is
> > > released to decrement the target's device counter?  Why not do the
> > > decrement in __scsi_remove_device()?
> > 
> > because the use model of the device still requires a valid target.  Even
> > though it gets gated in several places in SDEV_DEL, we still have use of
> > the target parent.  This is fixable, but only by a long audit of all the
> > sdev uses plus the enforcement of no use of target in DEL state rule,
> > which adds complexity.
> 
> You're failing to distinguish properly between "delete" and "release".  
> A target (or device in general) is deleted when it is removed from
> visibility -- i.e., when device_del() is called.  It is released when
> the final put_device() call occurs and the data structure is
> deallocated.

I find the terms delete and release too close for comfort, which is why
I've always been careful to say remove from visibility.

> So, all I'm saying is there's nothing wrong with deleting a target
> when all its children are deleted, provided the target isn't released
> until all the children are released.  Below you say the same thing.
> 
> 
> > > > Perhaps I haven't made the problem clear enough.  You only want early
> > > > del if the host is going away, otherwise the target might be reused and
> > > > it can't be if you've called del on it.  So there needs to be an
> > > > integration into the host lifecycle in some form.
> > > 
> > > Yes, granted.  That integration doesn't have to be complicated.  
> > > Basically, you just decrement the counters in all the targets when
> > > setting a host's state to SHOST_DEL or SHOST_DEL_RECOVERY.  At that 
> > 
> > And SHOST_CANCEL and SHOST_CANCEL_RECOVERY.
> 
> If you prefer.  I thought SHOST_DEL would be more appropriate because
> it occurs after scsi_forget_host() is called.  All those transitions
> occur in scsi_remove_host(), anyway.

I mean in all four states.

> > > point there's no reason to keep an unpopulated target around, right?
> > 
> > If the child list were empty, sure.  However, it's likely not going to
> > be at this point.
> 
> Regardless, it will work either way.
> 
> > > Up until that point, the counter's value should be one more than the
> > > number of underlying sdevs.  So if the counter decrements to 0 then
> > > there were no underlying sdevs and the target is deleted immediately;
> > > otherwise it is deleted when the last remaining sdev is deleted.
> > 
> > No, that's the problem.  It can be removed from visibility if it has no
> > visible sdevs, but it can't be deleted until the last sdev is released.
> 
> Allow me to rephrase this: A target can be removed from visibility if 
> it has no visible sdevs, but it can't be _released_ until the last sdev 
> is released.
> 
> That's fine.  You remove a target from visibility when target->reap_ref
> becomes 0.  The target isn't released until the target's embedded
> struct device's refcount becomes 0.  To make this work, simply have
> scsi_alloc_sdev() call
> 
> 	get_device(&starget->dev);
> 
> and have scsi_device_dev_release_usercontext() call
> 
> 	put_device(&starget->dev);
> 
> Doesn't that do exactly what you're asking for?

That's um what we do to day ... the addition has to be to the visibility
management.

James


