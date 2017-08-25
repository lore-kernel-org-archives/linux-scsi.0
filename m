From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 07/19] Fix RCU handling of scsi_device.vpd_pg8[03]
Date: Fri, 25 Aug 2017 08:59:36 +0200
Message-ID: <20170825065936.GC8866@lst.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com> <20170823214009.15015-8-bart.vanassche@wdc.com> <20170824090718.GG19886@lst.de> <1503593651.2702.16.camel@wdc.com> <AT5PR84MB0308689A9E2AA2461DEB35A0FD9B0@AT5PR84MB0308.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53525 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754272AbdHYG7h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 02:59:37 -0400
Content-Disposition: inline
In-Reply-To: <AT5PR84MB0308689A9E2AA2461DEB35A0FD9B0@AT5PR84MB0308.NAMPRD84.PROD.OUTLOOK.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Fri, Aug 25, 2017 at 05:58:16AM +0000, Seymour, Shane M wrote:
> > My understanding of the SCSI VPD code is as follows:
> > * rcu_read_lock() / rcu_read_unlock() is used to prevent that another thread
> >   updates a VPD buffer while it is being read.
> 
> My understanding is that it doesn't do that - you can update an RCU
> pointer with rcu_assign_pointer() after someone has called
> rcu_read_lock() and before they call rcu_read_unlock(). 

Indeed.

> What rcu_read_lock() / rcu_read_unlock() do is mark a read-side critical
> section when accessing an RCU data item. If you have 2 CPUs in a
> read-side critical section and a 3rd CPU replacing the pointer using
> rcu_assign_pointer() one CPU could potentially end up with the old pointer
> and the other one with the new pointer or both old or both new (the only
> guarantee you have is that the pointer won't be partially updated with
> bits of old and the new pointer).

Exactly.

> To free the old pointer directly you have to call synchronize_rcu()
> after which you can call kfree() or if you don't call synchronize_rcu()
> you have to use a delayed freeing mechanism like kfree_rcu()

(or call_rcu for the more general case)

> so you can guarantee that the old pointer is still valid while used in a
> read-side critical section. Using something like kfree_rcu() means that
> you also don’t have to wait like I believe you can do if you call
> synchronize_rcu() since you could be forced to wait for a RCU grace
> period to end before you can call kfree().

Yes, call_rcu (including the kfree_rcu helper) schedules a delayed
action after the grace period, synchronize_rcu synchronously waits
for the end of the grace period.

> > * All code that either updates or reads a VPD buffer holds a reference on
> >   the SCSI device that buffer is associated with. That is why I think it is
> >   not needed to use kfree_rcu() in scsi_device_dev_release_usercontext().

But a reference could be dropped during the grace period.  We'll need
to either wait for the grace period after NULLing out the vpd pointers
or before freeing the allocations for them.  Currently the only rcu
synchronization in the scsi code is after assining the vpd pointers
(in which case we'd only need it whe replacing the previous one, which
should not happen in practice anyway), but I can't find anything in the
free path.
