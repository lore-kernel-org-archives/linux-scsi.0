From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Wed, 7 May 2003 09:15:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030507161546.GA3368@beaverton.ibm.com>
References: <20030505083315.GB8416@beaverton.ibm.com> <20030505093833.A13506@infradead.org> <20030505094818.GH8416@beaverton.ibm.com> <20030505111735.A16914@infradead.org> <20030506010521.GB3852@beaverton.ibm.com> <20030507164427.A28899@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:8600 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S264095AbTEGQBR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2003 12:01:17 -0400
Content-Disposition: inline
In-Reply-To: <20030507164427.A28899@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> > > Then we'd have:
> > > 
> > > 	scsi_alloc_host
> > > 		- allocate storage for struct Scsi_Host, some
> > > 		  basic initalization.  refcount set to 1;
> > 
> > I am using sysfs ref counting and increment the ref count on the Scsi_Host
> > through device_register and device_get. The scsi_get/put_host wrapper
> > would call device_get/put.
> 
> right.
> 
> > > 	scsi_get_host
> > > 		- get a reference to an existing struct Scsi_Host
> > > 	scsi_put_host
> > > 		- decrement usecount of an existing struct Scsi_Host,
> > > 		  free it if this was the last reference
> > 
> > The sysfs model splits the registering / unregistering so that is why I
> > am unregistering in scsi_remove_host, but may not call the free until
> > someone calls the final put.
> 
> I completly agree with that.  (did something above read like I was
> disagreeing?  I'm a bit confused on this comment..)

No I did not read that you where disagreeing I was just indicating that
I was not calling any sysfs functions from scsi_register do that the
Scsi_Host's struct device and struct class where not initialized until
scsi_add_host.

After reading you mail the other day I believe a better model would be
to split the device_register using the device_initialize and device_add
functions. This will mean that after the return of scsi_register
(scsi_alloc_host) that refcount will be 1 and the Scsi_Host struct is
ready to be used.

I am writing this down write now so it is a little better explained. I
hope to have it out in just a bit.

-andmike
--
Michael Anderson
andmike@us.ibm.com

