From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Wed, 27 May 2009 12:16:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905271213040.15613-100000@iolanthe.rowland.org>
References: <1243440094.6067.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1243440094.6067.10.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 27 May 2009, James Bottomley wrote:

> Hardly ... our current refcounting is on destruction (releases).  This
> problem is an instance of visibility (the del calls) we need the
> visibility teardown to work nicely.  We currently have no refcounting on
> the visibility.  Even if we did (and we could add a ref on when the
> underlying device del calls are done), what happens if the target needs
> to become visible again.  Apparently the generic device infrastructure
> can't accept doing an add on a previously del'd device.

Definitely not.

> The most obvious way of fixing this is to have a special case for
> targets of dying hosts ... they could call del early on the
> understanding that they're never getting new underlying devices.  That
> would allow the wait to trigger on the last target del, which is what is
> optimal.

I don't understand all the subtle issues here.  In other contexts, the 
solution would be to initialize a refcount to 1 when the target is 
allocated, increment it when a device is added, and decrement it when a 
device is removed or the host is removed.  When the refcount goes to 0, 
the target is deleted.  Why wouldn't this kind of approach work?

Alan Stern

