From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Wed, 27 May 2009 13:01:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905271255340.15613-100000@iolanthe.rowland.org>
References: <1243441460.6067.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:54120 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756687AbZE0RBH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 13:01:07 -0400
In-Reply-To: <1243441460.6067.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

On Wed, 27 May 2009, James Bottomley wrote:

> > I don't understand all the subtle issues here.  In other contexts, the 
> > solution would be to initialize a refcount to 1 when the target is 
> > allocated, increment it when a device is added, and decrement it when a 
> > device is removed or the host is removed.  When the refcount goes to 0, 
> > the target is deleted.  Why wouldn't this kind of approach work?
> 
> Um, well that's exactly how it works (modulo the fact that there are
> parts of the lifecycle where the ref count is zero, like scanning).

Why does that happen?  It's reasonable that there should be times 
during scanning when the target doesn't have any children, but the 
refcount should still be positive.

>  The
> problem you're complaining about is that the device ref on the target
> may take a long time to release, so we can't key the del event on the
> refcount going to zero, which is what we do today.

Maybe we should be talking about two separate refcounts: a normal 
get_device/put_device kref counter for the target's lifetime, and a 
visibility counter (one for each child device and one overall) which 
keys the del event and must go to 0 before the host removal finishes.

Alan Stern

