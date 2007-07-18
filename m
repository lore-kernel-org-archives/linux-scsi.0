From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: block/bsg.c
Date: Wed, 18 Jul 2007 09:23:44 -0500
Message-ID: <1184768624.3464.15.camel@localhost.localdomain>
References: <20070717190705T.fujita.tomonori@lab.ntt.co.jp>
	 <20070717101928.GK5195@kernel.dk>
	 <1184698434.3378.15.camel@localhost.localdomain>
	 <20070718092130V.tomof@acm.org>
	 <1184766854.3464.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52471 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753863AbXGROXq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 10:23:46 -0400
In-Reply-To: <1184766854.3464.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2007-07-18 at 08:54 -0500, James Bottomley wrote:
> You're welcome ... although there's still a problem for modular builds.
> This is what my /sys/class/bsg looks like:

Sorry, lets see if I can get the paste to work this time:

jejb@hobholes> ls /sys/class/bsg/
0:0:1:0/  sdb/

> So you see the if (rq->kobj.parent) is causing confusing naming.  The
> reason the first one shows up as 0:0:0:0 is because in an initrd
> scsi_mod is loaded first (which is when bsg binds) followed by sd_mod
> (which is what gives the device the ULD binding and hence the name).  I
> don't see any way around this, so I'd advocate simply using the sdev
> name rather than the block device name and dumping the if.
> 
> > > --- a/drivers/scsi/scsi_sysfs.c
> > > +++ b/drivers/scsi/scsi_sysfs.c
> > > @@ -714,6 +714,7 @@ static int attr_add(struct device *dev, struct device_attribute *attr)
> > >  int scsi_sysfs_add_sdev(struct scsi_device *sdev)
> > >  {
> > >  	int error, i;
> > > +	struct request_queue *rq = sdev->request_queue;
> > >  
> > >  	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
> > >  		return error;
> > > @@ -733,6 +734,16 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
> > >  	/* take a reference for the sdev_classdev; this is
> > >  	 * released by the sdev_class .release */
> > >  	get_device(&sdev->sdev_gendev);
> > > +
> > > +	if (rq->kobj.parent)
> > > +		error = bsg_register_queue(rq, kobject_name(rq->kobj.parent));
> > > +	else
> > > +		error = bsg_register_queue(rq, kobject_name(&sdev->sdev_gendev.kobj));
> > > +	if (error) {
> > > +		sdev_printk(KERN_INFO, sdev, "Failed to register bsg queue\n");
> > > +		goto out;
> > 
> > Needs more cleanup here?
> 
> No ... this bit's magic and clever.  Once you've set up the devices and
> done a get_device, cleanup is simply doing a put_device because it's all
> done in the release routine.
> 
> > We might just ignore the error here since it's not fatal not to create
> > a bsg device, I guess.
> > 
> > I updated the patch against the latest code (which has just be merged
> > to Linus's tree).
> 
> Thanks,
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

