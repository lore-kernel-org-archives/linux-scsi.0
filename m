From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 10/14] scsi: osd: fix device_register() error handling
Date: Mon, 20 Sep 2010 06:58:17 -0500
Message-ID: <1284983897.2973.11.camel@mulgrave.site>
References: <1284900907-24621-1-git-send-email-segooon@gmail.com>
	 <20100919142653.GF6236@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40901 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab0ITL6Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2010 07:58:25 -0400
In-Reply-To: <20100919142653.GF6236@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>

On Sun, 2010-09-19 at 16:26 +0200, Dan Carpenter wrote:
> On Sun, Sep 19, 2010 at 04:55:07PM +0400, Vasiliy Kulikov wrote:
> > If device_register() fails then call put_device().
> > See comment to device_register.
> > 
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > ---
> >  compile tested.
> > 
> >  drivers/scsi/osd/osd_uld.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> > index cefb2c0..3e0edc2 100644
> > --- a/drivers/scsi/osd/osd_uld.c
> > +++ b/drivers/scsi/osd/osd_uld.c
> > @@ -474,7 +474,7 @@ static int osd_probe(struct device *dev)
> >  	error = device_register(&oud->class_dev);
> >  	if (error) {
> >  		OSD_ERR("device_register failed => %d\n", error);
> > -		goto err_put_cdev;
> > +		goto err_put_device;
> >  	}
> >  
> >  	get_device(&oud->class_dev);
> > @@ -482,6 +482,8 @@ static int osd_probe(struct device *dev)
> >  	OSD_INFO("osd_probe %s\n", disk->disk_name);
> >  	return 0;
> >  
> 
> Hm...  So if device_register() fails then we should always call
> device_put()?  It seems like a lot of existing code does that but I
> hadn't realized until now that that is how it works.

Heh, it wasn't a bug when most of the code was written.  It became a bug
when dev_set_name() was added because now the storage allocated for the
name has to be freed with a put.  Previous to this, the advice was just
to free the device if device_register() failed.

> Why can't the device_put() just be added inside the device_register() so
> the unwinding works automatically?

Since Greg and Kay didn't actually alter any of the device_register()
failure paths, this does sound to be the better course of action ... of
course, every device_register() introduced after the dev_set_name()
change may call put_device() on the cleanup path ... someone needs to
check.

James


