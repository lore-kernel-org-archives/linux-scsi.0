From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Wed, 29 Nov 2017 14:20:29 -0500
Message-ID: <1511983229.30220.19.camel@localhost.localdomain>
References: <20171129030556.47833-1-yanaijie@huawei.com>
         <1511972310.2671.7.camel@wdc.com> <20171129162050.GA32071@lst.de>
         <20171129173947.GC20581@kroah.com>
         <1511981395.30220.6.camel@localhost.localdomain>
         <1511982666.2671.25.camel@wdc.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751897AbdK2TUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Nov 2017 14:20:31 -0500
In-Reply-To: <1511982666.2671.25.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "miaoxie@huawei.com" <miaoxie@huawei.com>

On Wed, 2017-11-29 at 19:11 +0000, Bart Van Assche wrote:
> On Wed, 2017-11-29 at 13:49 -0500, Ewan D. Milne wrote:
> > because a get inside a destructor would *always* be wrong, no?
> 
> Hello Ewan,
> 
> That's not what we are discussing. What can happen with the SCSI core is that
> get_device() is called concurrently with the destructor. get_device() can be
> called concurrently with the destructor because the destructore removes a
> device from the siblings list and because the SCSI core can call get_device()
> for devices it finds on the siblings list. Personally I think that design is
> superior compared to removing a SCSI device from the sibling list before the
> last put_device() call because the approach followed in the SCSI core leads to
> a simpler implementation. However, it seems like the current get_device()
> implementation does not yet support the SCSI core design ...
> 
> Bart.

OK, well, I think the point still stands, though, once the refcount
goes to zero and the destructor is invoked, a get that then increments
the refcount seems fundamentally wrong to me.  Especially if a
subsequent put causes the destructor to be invoked *simultaneously*
*on another thread*.  The locking has to happen somewhere, why isn't
this done by the kobject?

Relying on the client code to get this right means that there are
opportunities all over the kernel for problems like this to happen,
just like here, where we inadvertently removed the state check that
prevented the get_device() call.

-Ewan
