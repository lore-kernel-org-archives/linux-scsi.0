From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Mon, 5 May 2003 11:17:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505111735.A16914@infradead.org>
References: <20030505083315.GB8416@beaverton.ibm.com> <20030505093833.A13506@infradead.org> <20030505094818.GH8416@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:60425 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261199AbTEEKFG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 06:05:06 -0400
Content-Disposition: inline
In-Reply-To: <20030505094818.GH8416@beaverton.ibm.com>; from andmike@us.ibm.com on Mon, May 05, 2003 at 02:48:18AM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

On Mon, May 05, 2003 at 02:48:18AM -0700, Mike Anderson wrote:
> While scsi_remove_host cannot imply a scsi_set_host_offline unless we
> change the previous definition. We indicated that scsi_set_host_offline
> may cancel commands in flight which implys some sync point.

Yes.

> Ok I will look at the change you suggest in the morning after I have
> some sleep. I guess the first step would be moving the kfree(shost) out
> of scsi_unregister. This would then stay around until ref counts go to
> zero.

Actually what I think must happen is that scsi_unregister will do
nothing unless the refcount reaches zero.  It should also be renamed
to scsi_put_host to make this more explicit.

Then we'd have:

	scsi_alloc_host
		- allocate storage for struct Scsi_Host, some
		  basic initalization.  refcount set to 1;
	scsi_get_host
		- get a reference to an existing struct Scsi_Host
	scsi_put_host
		- decrement usecount of an existing struct Scsi_Host,
		  free it if this was the last reference
	scsi_add_host
		- register host with the scsi midlayer
	scsi_remove_host
		- unregister host with the scsi midlayer, force all
		  I/O to fail from now on and never call back into
		  the driver.

To avoid touching all old-style drivers we should probably keep
the scsi_register/scsi_unregister aliases for 2.6.

