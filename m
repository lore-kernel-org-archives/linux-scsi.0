From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
	directories.
Date: Wed, 27 May 2009 20:49:02 +0000
Message-ID: <1243457342.6067.69.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0905271625080.2653-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46020 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755261AbZE0UtD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2009 16:49:03 -0400
In-Reply-To: <Pine.LNX.4.44L0.0905271625080.2653-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

On Wed, 2009-05-27 at 16:40 -0400, Alan Stern wrote:
> On Wed, 27 May 2009, James Bottomley wrote:
> 
> > On Wed, 2009-05-27 at 14:07 -0400, Alan Stern wrote:
> > > On Wed, 27 May 2009, James Bottomley wrote:
> > > 
> > > > By refcount, I mean count of underlying devices.
> > > 
> > > Does that mean only registered devices, or does it include devices 
> > > which are unregistered but not yet released?
> > 
> > All devices ... scsi_device has to has a target parent before its
> > usable.
> 
> I can't tell whether you understood my point.  After a scsi_device is
> unregistered but before it is released -- i.e., when its state is
> SDEV_DEL -- it _is_ essentially unusable.  So why wait until it is
> released to decrement the target's device counter?  Why not do the
> decrement in __scsi_remove_device()?

because the use model of the device still requires a valid target.  Even
though it gets gated in several places in SDEV_DEL, we still have use of
the target parent.  This is fixable, but only by a long audit of all the
sdev uses plus the enforcement of no use of target in DEL state rule,
which adds complexity.

> > > > Um, well, that's roughly how I said we'd have to fix all of this in the
> > > > email to hannes ... it would be much easier if we could make a del'd
> > > > device visible,
> > > 
> > > I don't follow.  Why would you want to delete a target before the host
> > > is removed and then make it visible again later?  Because it doesn't
> > > have any underlying devices at the moment but may gain some later on?
> > 
> > Perhaps I haven't made the problem clear enough.  You only want early
> > del if the host is going away, otherwise the target might be reused and
> > it can't be if you've called del on it.  So there needs to be an
> > integration into the host lifecycle in some form.
> 
> Yes, granted.  That integration doesn't have to be complicated.  
> Basically, you just decrement the counters in all the targets when
> setting a host's state to SHOST_DEL or SHOST_DEL_RECOVERY.  At that 

And SHOST_CANCEL and SHOST_CANCEL_RECOVERY.

> point there's no reason to keep an unpopulated target around, right?

If the child list were empty, sure.  However, it's likely not going to
be at this point.

> Up until that point, the counter's value should be one more than the
> number of underlying sdevs.  So if the counter decrements to 0 then
> there were no underlying sdevs and the target is deleted immediately;
> otherwise it is deleted when the last remaining sdev is deleted.

No, that's the problem.  It can be removed from visibility if it has no
visible sdevs, but it can't be deleted until the last sdev is released.

James


