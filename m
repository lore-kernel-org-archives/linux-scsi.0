From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: block/bsg.c
Date: Wed, 18 Jul 2007 08:54:14 -0500
Message-ID: <1184766854.3464.4.camel@localhost.localdomain>
References: <20070717190705T.fujita.tomonori@lab.ntt.co.jp>
	 <20070717101928.GK5195@kernel.dk>
	 <1184698434.3378.15.camel@localhost.localdomain>
	 <20070718092130V.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:53097 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754808AbXGRNyR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 09:54:17 -0400
In-Reply-To: <20070718092130V.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2007-07-18 at 09:20 +0900, FUJITA Tomonori wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> Subject: Re: block/bsg.c
> Date: Tue, 17 Jul 2007 13:53:54 -0500
> 
> > On Tue, 2007-07-17 at 12:19 +0200, Jens Axboe wrote:
> > > > > Since Linus is happily snoring by now, could you test and see if the
> > > > > tree works for you?
> > > > 
> > > > It works for me. I'll submit some minor patches against your bsg
> > > > branch to scsi-ml. Can you push them together?
> > > 
> > > Certainly, I'll pull them into the bsg branch.
> > 
> > While you're at it, here's a patch to separate BSG and SCSI again (so
> > SCSI can be built modular).  The way I did it was simply to move the
> > SCSI specific logic into SCSI.  When you come up with a generic way to
> > register the bsg requiring drivers, then we can move it out again.
> 
> Thanks, looks nice.

You're welcome ... although there's still a problem for modular builds.
This is what my /sys/class/bsg looks like:

So you see the if (rq->kobj.parent) is causing confusing naming.  The
reason the first one shows up as 0:0:0:0 is because in an initrd
scsi_mod is loaded first (which is when bsg binds) followed by sd_mod
(which is what gives the device the ULD binding and hence the name).  I
don't see any way around this, so I'd advocate simply using the sdev
name rather than the block device name and dumping the if.

> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -714,6 +714,7 @@ static int attr_add(struct device *dev, struct device_attribute *attr)
> >  int scsi_sysfs_add_sdev(struct scsi_device *sdev)
> >  {
> >  	int error, i;
> > +	struct request_queue *rq = sdev->request_queue;
> >  
> >  	if ((error = scsi_device_set_state(sdev, SDEV_RUNNING)) != 0)
> >  		return error;
> > @@ -733,6 +734,16 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
> >  	/* take a reference for the sdev_classdev; this is
> >  	 * released by the sdev_class .release */
> >  	get_device(&sdev->sdev_gendev);
> > +
> > +	if (rq->kobj.parent)
> > +		error = bsg_register_queue(rq, kobject_name(rq->kobj.parent));
> > +	else
> > +		error = bsg_register_queue(rq, kobject_name(&sdev->sdev_gendev.kobj));
> > +	if (error) {
> > +		sdev_printk(KERN_INFO, sdev, "Failed to register bsg queue\n");
> > +		goto out;
> 
> Needs more cleanup here?

No ... this bit's magic and clever.  Once you've set up the devices and
done a get_device, cleanup is simply doing a put_device because it's all
done in the release routine.

> We might just ignore the error here since it's not fatal not to create
> a bsg device, I guess.
> 
> I updated the patch against the latest code (which has just be merged
> to Linus's tree).

Thanks,

James


