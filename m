From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
	directories.
Date: Wed, 27 May 2009 17:08:21 +0000
Message-ID: <1243444101.6067.24.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0905271255340.15613-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0905271255340.15613-100000@iolanthe.rowland.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-05-27 at 13:01 -0400, Alan Stern wrote:
> On Wed, 27 May 2009, James Bottomley wrote:
> 
> > > I don't understand all the subtle issues here.  In other contexts, the 
> > > solution would be to initialize a refcount to 1 when the target is 
> > > allocated, increment it when a device is added, and decrement it when a 
> > > device is removed or the host is removed.  When the refcount goes to 0, 
> > > the target is deleted.  Why wouldn't this kind of approach work?
> > 
> > Um, well that's exactly how it works (modulo the fact that there are
> > parts of the lifecycle where the ref count is zero, like scanning).
> 
> Why does that happen?  It's reasonable that there should be times 
> during scanning when the target doesn't have any children, but the 
> refcount should still be positive.

By refcount, I mean count of underlying devices.

> >  The
> > problem you're complaining about is that the device ref on the target
> > may take a long time to release, so we can't key the del event on the
> > refcount going to zero, which is what we do today.
> 
> Maybe we should be talking about two separate refcounts: a normal 
> get_device/put_device kref counter for the target's lifetime, and a 
> visibility counter (one for each child device and one overall) which 
> keys the del event and must go to 0 before the host removal finishes.

Um, well, that's roughly how I said we'd have to fix all of this in the
email to hannes ... it would be much easier if we could make a del'd
device visible, but now we have to have different behaviours depending
on whether the host is going away or not.

James


