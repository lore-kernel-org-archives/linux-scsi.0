From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Wed, 29 Nov 2017 17:39:04 +0000
Message-ID: <20171129173904.GB20581@kroah.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
 <1511972310.2671.7.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57644 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933812AbdK2RjB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Nov 2017 12:39:01 -0500
Content-Disposition: inline
In-Reply-To: <1511972310.2671.7.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "miaoxie@huawei.com" <miaoxie@huawei.com>

On Wed, Nov 29, 2017 at 04:18:30PM +0000, Bart Van Assche wrote:
> On Wed, 2017-11-29 at 11:05 +0800, Jason Yan wrote:
> > In commit fbce4d97fd43 ("scsi: fixup kernel warning during rmmod()"), we
> > removed scsi_device_get() and directly called get_device() to increase
> > the refcount of the device. But actullay scsi_device_get() will fail in
> > three cases:
> > 1. the scsi device is in SDEV_DEL or SDEV_CANCEL state
> > 2. get_device() fail
> > 3. the module is not alive
> > 
> > The intended purpose was to remove the check of the module alive.
> > Unfortunately the check of the device state was droped too. And this
> > introduced a race condition like this:
> > 
> >       CPU0                                           CPU1
> > __scsi_remove_target()
> >   ->iterate shost->__devices
> >   ->scsi_remove_device()
> >   ->put_device()
> >       someone still hold a refcount
> >                                                    sd_release()
> >                                                       ->scsi_disk_put()
> >                                                       ->put_device() last put and trigger the device release
> > 
> >   ->goto restart
> >   ->iterate shost->__devices and got the same device
> >   ->get_device() while refcount is 0
> >   ->scsi_remove_device()
> >   ->put_device() refcount decreased to 0 again
> >   ->scsi_device_dev_release()
> >   ->scsi_device_dev_release_usercontext()
> > 
> >                                                       ->scsi_device_dev_release()
> >                                                       ->scsi_device_dev_release_usercontext()
> > 
> > The same scsi device will be found agian because it is in the shost->__devices
> > list until scsi_device_dev_release_usercontext() called, although the device
> > state was set to SDEV_DEL after the first scsi_remove_device().
> > 
> > Finally we got a oops in scsi_device_dev_release_usercontext() when the second
> > time be called.
> > 
> > Call trace:
> > [<ffff0000086bc624>] scsi_device_dev_release_usercontext+0x7c/0x1c0
> > [<ffff0000080f1f90>] execute_in_process_context+0x70/0x80
> > [<ffff0000086bc598>] scsi_device_dev_release+0x28/0x38
> > [<ffff0000086662cc>] device_release+0x3c/0xa0
> > [<ffff000008c2e780>] kobject_put+0x80/0xf0
> > [<ffff0000086666fc>] put_device+0x24/0x30
> > [<ffff0000086aeee0>] scsi_device_put+0x30/0x40
> > [<ffff000008704894>] scsi_disk_put+0x44/0x60
> > [<ffff000008704a50>] sd_release+0x50/0x80
> > [<ffff0000082bc704>] __blkdev_put+0x21c/0x230
> > [<ffff0000082bcb2c>] blkdev_put+0x54/0x118
> > [<ffff0000082bcc1c>] blkdev_close+0x2c/0x40
> > [<ffff000008279b64>] __fput+0x94/0x1d8
> > [<ffff000008279d20>] ____fput+0x20/0x30
> > [<ffff0000080f6f54>] task_work_run+0x9c/0xb8
> > [<ffff0000080dba64>] do_exit+0x2b4/0x9f8
> > [<ffff0000080dc234>] do_group_exit+0x3c/0xa0
> > [<ffff0000080dc2b8>] __wake_up_parent+0x0/0x40
> > 
> > And sometimes in __scsi_remove_target() it will loop for a long time
> > removing the same device if someone else holding a refcount until the
> > last refcount is released.
> > 
> > Notice that if CONFIG_REFCOUNT_FULL is open this race won't be triggered
> > because the full refcount implement will prevent the refcount increase
> > when it is 0.
> > 
> > Fix this by checking the sdev_state again like we did before in
> > scsi_device_get(). Then when iterating shost again we will skip the device
> > deleted because scsi_remove_device() will set the device state to
> > SDEV_CANCEL or SDEV_DEL.
> > 
> > Fixes: fbce4d97fd43 ("scsi: fixup kernel warning during rmmod()")
> > Signed-off-by: Jason Yan <yanaijie@huawei.com>
> > CC: Hannes Reinecke <hare@suse.de>
> > CC: Christoph Hellwig <hch@lst.de>
> > CC: Johannes Thumshirn <jthumshirn@suse.de>
> > CC: Zhaohongjiang <zhaohongjiang@huawei.com>
> > CC: Miao Xie <miaoxie@huawei.com>
> > ---
> >  drivers/scsi/scsi_sysfs.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index 50e7d7e..d398894 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -1398,6 +1398,15 @@ void scsi_remove_device(struct scsi_device *sdev)
> >  }
> >  EXPORT_SYMBOL(scsi_remove_device);
> >  
> > +static int scsi_device_get_not_deleted(struct scsi_device *sdev)
> > +{
> > +	if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
> > +		return -ENXIO;
> > +	if (!get_device(&sdev->sdev_gendev))
> > +		return -ENXIO;
> > +	return 0;
> > +}
> > +
> >  static void __scsi_remove_target(struct scsi_target *starget)
> >  {
> >  	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> > @@ -1415,7 +1424,7 @@ static void __scsi_remove_target(struct scsi_target *starget)
> >  		 */
> >  		if (sdev->channel != starget->channel ||
> >  		    sdev->id != starget->id ||
> > -		    !get_device(&sdev->sdev_gendev))
> > +		    scsi_device_get_not_deleted(sdev))
> >  			continue;
> >  		spin_unlock_irqrestore(shost->host_lock, flags);
> >  		scsi_remove_device(sdev);
> 
> Hi Greg,
> 
> As the above patch description shows it can happen that the SCSI core calls
> get_device() after the device reference count has reached zero and before
> the memory for struct device is freed. Although the above patch looks fine
> to me, would you consider it acceptable to modify get_device() such that it
> uses kobject_get_unless_zero() instead of kobject_get()? I'm asking this
> because that change would help to reduce the complexity of the already too
> complicated SCSI core.

Shouldn't there be a bus lock somewhere preventing this race?  Having an
open-coded put call isn't good, as you see here.

thanks,

greg k-h
