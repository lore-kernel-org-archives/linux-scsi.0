From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
	directories.
Date: Wed, 27 May 2009 16:24:20 +0000
Message-ID: <1243441460.6067.18.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0905271213040.15613-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0905271213040.15613-100000@iolanthe.rowland.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-05-27 at 12:16 -0400, Alan Stern wrote:
> On Wed, 27 May 2009, James Bottomley wrote:
> 
> > Hardly ... our current refcounting is on destruction (releases).  This
> > problem is an instance of visibility (the del calls) we need the
> > visibility teardown to work nicely.  We currently have no refcounting on
> > the visibility.  Even if we did (and we could add a ref on when the
> > underlying device del calls are done), what happens if the target needs
> > to become visible again.  Apparently the generic device infrastructure
> > can't accept doing an add on a previously del'd device.
> 
> Definitely not.
> 
> > The most obvious way of fixing this is to have a special case for
> > targets of dying hosts ... they could call del early on the
> > understanding that they're never getting new underlying devices.  That
> > would allow the wait to trigger on the last target del, which is what is
> > optimal.
> 
> I don't understand all the subtle issues here.  In other contexts, the 
> solution would be to initialize a refcount to 1 when the target is 
> allocated, increment it when a device is added, and decrement it when a 
> device is removed or the host is removed.  When the refcount goes to 0, 
> the target is deleted.  Why wouldn't this kind of approach work?

Um, well that's exactly how it works (modulo the fact that there are
parts of the lifecycle where the ref count is zero, like scanning).  The
problem you're complaining about is that the device ref on the target
may take a long time to release, so we can't key the del event on the
refcount going to zero, which is what we do today.

James


