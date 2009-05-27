From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
	directories.
Date: Wed, 27 May 2009 19:44:23 +0000
Message-ID: <1243453463.6067.63.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0905271356090.15690-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0905271356090.15690-100000@iolanthe.rowland.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-05-27 at 14:07 -0400, Alan Stern wrote:
> On Wed, 27 May 2009, James Bottomley wrote:
> 
> > By refcount, I mean count of underlying devices.
> 
> Does that mean only registered devices, or does it include devices 
> which are unregistered but not yet released?

All devices ... scsi_device has to has a target parent before its
usable.

> > > >  The
> > > > problem you're complaining about is that the device ref on the target
> > > > may take a long time to release, so we can't key the del event on the
> > > > refcount going to zero, which is what we do today.
> > > 
> > > Maybe we should be talking about two separate refcounts: a normal 
> > > get_device/put_device kref counter for the target's lifetime, and a 
> > > visibility counter (one for each child device and one overall) which 
> > > keys the del event and must go to 0 before the host removal finishes.
> > 
> > Um, well, that's roughly how I said we'd have to fix all of this in the
> > email to hannes ... it would be much easier if we could make a del'd
> > device visible,
> 
> I don't follow.  Why would you want to delete a target before the host
> is removed and then make it visible again later?  Because it doesn't
> have any underlying devices at the moment but may gain some later on?

Perhaps I haven't made the problem clear enough.  You only want early
del if the host is going away, otherwise the target might be reused and
it can't be if you've called del on it.  So there needs to be an
integration into the host lifecycle in some form.

James


