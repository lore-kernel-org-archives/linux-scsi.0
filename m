From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2.6.19.2] SCSI sd:  udev accessing an uninitialized scsi_disk results in a crash
Date: Fri, 2 Feb 2007 17:56:35 -0800
Message-ID: <20070203015635.GA18467@kroah.com>
References: <200702021734.57161.nagendra_tomar@adaptec.com> <20070202171924.a225cff7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1946228AbXBCCOL@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070202171924.a225cff7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 02, 2007 at 05:19:24PM -0800, Andrew Morton wrote:
> On Fri, 2 Feb 2007 17:34:56 +0530
> Nagendra Singh Tomar <nagendra_tomar@adaptec.com> wrote:
> 
> > Hi,
> > 	sd_probe() calls class_device_add() even before initializing the 
> > sdkp->device variable. class_device_add() eventually results in the user mode 
> > udev program to be called. udev program can read the the allow_restart 
> > attribute of the newly created scsi device. This is resulting in a crash as 
> > the show function for allow_restart (i.e sd_show_allow_restart) returns the 
> > attribute value by reading the sdkp->device->allow_restart variable. As the 
> > sdkp->device is not initialized before calling the user mode hotplug helper, 
> > this results in a crash.
> > 	The patch below solves it by calling class_device_add() only after the 
> > necessary fields in the scsi_disk structure are initialized properly.
> > 
> > 
> > 
> > --- linux-2.6.19.2/drivers/scsi/sd.c.orig	2007-02-02 17:03:03.000000000 +0530
> > +++ linux-2.6.19.2/drivers/scsi/sd.c	2007-02-02 17:04:04.000000000 +0530
> > @@ -1646,16 +1646,6 @@ static int sd_probe(struct device *dev)
> >  	if (error)
> >  		goto out_put;
> >  
> > -	class_device_initialize(&sdkp->cdev);
> > -	sdkp->cdev.dev = &sdp->sdev_gendev;
> > -	sdkp->cdev.class = &sd_disk_class;
> > -	strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
> > -
> > -	if (class_device_add(&sdkp->cdev))
> > -		goto out_put;
> > -
> > -	get_device(&sdp->sdev_gendev);
> > -
> >  	sdkp->device = sdp;
> >  	sdkp->driver = &sd_template;
> >  	sdkp->disk = gd;
> > @@ -1669,6 +1659,16 @@ static int sd_probe(struct device *dev)
> >  			sdp->timeout = SD_MOD_TIMEOUT;
> >  	}
> >  
> > +	class_device_initialize(&sdkp->cdev);
> > +	sdkp->cdev.dev = &sdp->sdev_gendev;
> > +	sdkp->cdev.class = &sd_disk_class;
> > +	strncpy(sdkp->cdev.class_id, sdp->sdev_gendev.bus_id, BUS_ID_SIZE);
> > +
> > +	if (class_device_add(&sdkp->cdev))
> > +		goto out_put;
> > +
> > +	get_device(&sdp->sdev_gendev);
> > +
> >  	gd->major = sd_major((index & 0xf0) >> 4);
> >  	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
> >  	gd->minors = 16;
> 
> Thanks - I'll queue this up for 2.6.20 also.

No objection from me, as long as James says this is ok.

I wonder why we haven't noticed this in the past?

thanks,

greg k-h
