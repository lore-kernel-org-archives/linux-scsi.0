From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Wed, 29 Nov 2017 13:49:55 -0500
Message-ID: <1511981395.30220.6.camel@localhost.localdomain>
References: <20171129030556.47833-1-yanaijie@huawei.com>
         <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>
         <20171129173947.GC20581@kroah.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57816 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751924AbdK2St5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 13:49:57 -0500
In-Reply-To: <20171129173947.GC20581@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "hch@lst.de" <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>, "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "miaoxie@huawei.com" <miaoxie@huawei.com>

On Wed, 2017-11-29 at 17:39 +0000, gregkh@linuxfoundation.org wrote:
> On Wed, Nov 29, 2017 at 05:20:50PM +0100, hch@lst.de wrote:
> > On Wed, Nov 29, 2017 at 04:18:30PM +0000, Bart Van Assche wrote:
> > > As the above patch description shows it can happen that the SCSI core calls
> > > get_device() after the device reference count has reached zero and before
> > > the memory for struct device is freed. Although the above patch looks fine
> > > to me, would you consider it acceptable to modify get_device() such that it
> > > uses kobject_get_unless_zero() instead of kobject_get()? I'm asking this
> > > because that change would help to reduce the complexity of the already too
> > > complicated SCSI core.
> > 
> > I don't think we can just modify get_device, but we can add a new
> > get_device_unless_zero.  In fact I have an open coded variant of that
> > in nvme, and was planning to submit one for the current merge window..
> 
> I feel like that is just delaying the real fix, shouldn't there be a bus
> lock somewhere on the put_device path for this bus to prevent this?
> 
> thanks,
> 
> greg k-h

Why is it that clients of the kobject code have to have their own
lock / state checking to prevent a duplicate destructor callback?
It seems to me like this is something the core functionality should
provide, because a get inside a destructor would *always* be wrong, no?

It looks like:

void refcount_inc(refcount_t *r)
{
        WARN_ONCE(!refcount_inc_not_zero(r), "refcount_t: increment on 0; use-after-free.\n");
}

would have warned if CONFIG_REFCOUNT_FULL was on, I/we don't normally
enable that though.

-Ewan
