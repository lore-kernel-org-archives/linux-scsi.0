From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Wed, 7 May 2003 16:44:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030507164427.A28899@infradead.org>
References: <20030505083315.GB8416@beaverton.ibm.com> <20030505093833.A13506@infradead.org> <20030505094818.GH8416@beaverton.ibm.com> <20030505111735.A16914@infradead.org> <20030506010521.GB3852@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:3853 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264058AbTEGPby (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2003 11:31:54 -0400
Content-Disposition: inline
In-Reply-To: <20030506010521.GB3852@beaverton.ibm.com>; from andmike@us.ibm.com on Mon, May 05, 2003 at 06:05:21PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Mon, May 05, 2003 at 06:05:21PM -0700, Mike Anderson wrote:
> Well scsi_proc_host_rm will need to be done through some action prior to
> the completion of the drivers "remove" or "storage_disconnect (usb)"
> functions.

Yes.  I think we should move some more stuff from scsi_register/unregister
to add_host/remove_host, in fact basically anything that interacts with the
scsi midlayer.

> > Then we'd have:
> > 
> > 	scsi_alloc_host
> > 		- allocate storage for struct Scsi_Host, some
> > 		  basic initalization.  refcount set to 1;
> 
> I am using sysfs ref counting and increment the ref count on the Scsi_Host
> through device_register and device_get. The scsi_get/put_host wrapper
> would call device_get/put.

right.

> > 	scsi_get_host
> > 		- get a reference to an existing struct Scsi_Host
> > 	scsi_put_host
> > 		- decrement usecount of an existing struct Scsi_Host,
> > 		  free it if this was the last reference
> 
> The sysfs model splits the registering / unregistering so that is why I
> am unregistering in scsi_remove_host, but may not call the free until
> someone calls the final put.

I completly agree with that.  (did something above read like I was
disagreeing?  I'm a bit confused on this comment..)

> > 	scsi_add_host
> > 		- register host with the scsi midlayer
> 
> This is where I am registering the Scsi_Host struct device as we know
> the parent by this point. On return the ref count on Scsi_Host should be
> at least 1.

yupp, that's fine with me,

> 
> > 	scsi_remove_host
> > 		- unregister host with the scsi midlayer, force all
> > 		  I/O to fail from now on and never call back into
> > 		  the driver.
> 
> This is where I am unregistering the Scsi_Host struct device.

dio.

