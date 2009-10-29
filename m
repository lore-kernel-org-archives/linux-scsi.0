From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/5] osduld: Use device->release instead of internal
 kref
Date: Thu, 29 Oct 2009 17:41:13 +0000
Message-ID: <1256838073.7191.24.camel@mulgrave.site>
References: <4AE5D374.80400@panasas.com>
	 <1256576294-10430-1-git-send-email-bharrosh@panasas.com>
	 <1256836303.7191.21.camel@mulgrave.site>  <4AE9CFC6.2080404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54078 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756511AbZJ2RlO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2009 13:41:14 -0400
In-Reply-To: <4AE9CFC6.2080404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On Thu, 2009-10-29 at 19:24 +0200, Boaz Harrosh wrote:
> On 10/29/2009 07:11 PM, James Bottomley wrote:
> > On Mon, 2009-10-26 at 18:58 +0200, Boaz Harrosh wrote:
> >> @@ -335,18 +370,19 @@ static int osd_probe(struct device *dev)
> >>  		OSD_ERR("cdev_add failed\n");
> >>  		goto err_put_disk;
> >>  	}
> >> -	kobject_get(&oud->cdev.kobj); /* 2nd ref see osd_remove() */
> >>  
> >>  	/* class_member */
> >> -	oud->class_member = device_create(osd_sysfs_class, dev,
> >> -		MKDEV(SCSI_OSD_MAJOR, oud->minor), "%s", disk->disk_name);
> >> +	oud->class_member = device_create(&osd_uld_class, dev,
> >> +		MKDEV(SCSI_OSD_MAJOR, oud->minor), oud, disk->disk_name);
> >>  	if (IS_ERR(oud->class_member)) {
> >>  		OSD_ERR("class_device_create failed\n");
> >>  		error = PTR_ERR(oud->class_member);
> >>  		goto err_put_cdev;
> >>  	}
> >> +	oud->save_release = oud->class_member->release;
> >> +	oud->class_member->release = __remove;
> > 
> > What exactly is the reason for this iffy manipulation?  Can't this be
> > done properly by adding a dev_release member to osd_uld_class without
> > this unnecessary and improper function chaining?
> > 
> 
> I tried, it does not work if I use device_create.
> 
> because in device_release(struct kobject *kobj) it has ruffly this:
> 	if (dev->release)
> 		dev->release(dev);
> 	else if (class->dev_release)
> 		class->dev_release(dev);
> 
> (See core.c:110)
> 
> so since device_create sets a dev->release = it masks out my class->dev_release
> 
> Now I have two choice. Above release chaining, or duplicate the 9 lines of code
> done in device_create() before the call to device_register. I prefer the first
> since it is more resilient to future core changes. (And it is less code lines)

Chaining methods like this because of inner knowledge of the
implementation isn't resilient, it's very fragile.

Isn't the correct answer to embed your device in struct osd_uld_device?
They both look to have identical lifetimes and the release rules can
then handle the dual destruction?

James


