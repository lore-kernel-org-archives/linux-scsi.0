From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Mon, 5 May 2003 18:05:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030506010521.GB3852@beaverton.ibm.com>
References: <20030505083315.GB8416@beaverton.ibm.com> <20030505093833.A13506@infradead.org> <20030505094818.GH8416@beaverton.ibm.com> <20030505111735.A16914@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:6899 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262232AbTEFAuy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2003 20:50:54 -0400
Content-Disposition: inline
In-Reply-To: <20030505111735.A16914@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> On Mon, May 05, 2003 at 02:48:18AM -0700, Mike Anderson wrote:
> > While scsi_remove_host cannot imply a scsi_set_host_offline unless we
> > change the previous definition. We indicated that scsi_set_host_offline
> > may cancel commands in flight which implys some sync point.
> 
> Yes.
>

I guess I should have phrased a better question. Does the yes mean we need to
change the previous definition presented for scsi_set_host_offline.

> Actually what I think must happen is that scsi_unregister will do
> nothing unless the refcount reaches zero.  It should also be renamed
> to scsi_put_host to make this more explicit.
> 

Well scsi_proc_host_rm will need to be done through some action prior to
the completion of the drivers "remove" or "storage_disconnect (usb)"
functions.

> Then we'd have:
> 
> 	scsi_alloc_host
> 		- allocate storage for struct Scsi_Host, some
> 		  basic initalization.  refcount set to 1;

I am using sysfs ref counting and increment the ref count on the Scsi_Host
through device_register and device_get. The scsi_get/put_host wrapper
would call device_get/put.

> 	scsi_get_host
> 		- get a reference to an existing struct Scsi_Host
> 	scsi_put_host
> 		- decrement usecount of an existing struct Scsi_Host,
> 		  free it if this was the last reference

The sysfs model splits the registering / unregistering so that is why I
am unregistering in scsi_remove_host, but may not call the free until
someone calls the final put.

> 	scsi_add_host
> 		- register host with the scsi midlayer

This is where I am registering the Scsi_Host struct device as we know
the parent by this point. On return the ref count on Scsi_Host should be
at least 1.

> 	scsi_remove_host
> 		- unregister host with the scsi midlayer, force all
> 		  I/O to fail from now on and never call back into
> 		  the driver.

This is where I am unregistering the Scsi_Host struct device.

-andmike
--
Michael Anderson
andmike@us.ibm.com

