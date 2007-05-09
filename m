From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 6/7] SCSI: save disk in scsi_device - resend
Date: Wed, 9 May 2007 15:50:32 -0700
Message-ID: <20070509155032.57c3a55d.kristen.c.accardi@intel.com>
References: <20070424074856.005152262@intel.com>
	<20070504111733.f507501d.kristen.c.accardi@intel.com>
	<1178310648.3711.56.camel@mulgrave.il.steeleye.com>
	<20070507082928.17878961.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50944 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252AbXEIWxb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 May 2007 18:53:31 -0400
In-Reply-To: <20070507082928.17878961.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com, akpm@linux-foundation.org

On Mon, 7 May 2007 08:29:28 -0700
Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:

> On Fri, 04 May 2007 15:30:48 -0500
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > On Fri, 2007-05-04 at 11:17 -0700, Kristen Carlson Accardi wrote:
> > > Give anyone who has access to scsi_device access to the genhd struct as well.
> > > 
> > > Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> > > Index: 2.6-git/drivers/scsi/sd.c
> > > ===================================================================
> > > --- 2.6-git.orig/drivers/scsi/sd.c
> > > +++ 2.6-git/drivers/scsi/sd.c
> > > @@ -1711,6 +1711,7 @@ static int sd_probe(struct device *dev)
> > >  
> > >  	dev_set_drvdata(dev, sdkp);
> > >  	add_disk(gd);
> > > +	sdp->disk = gd;
> > >  
> > >  	sdev_printk(KERN_NOTICE, sdp, "Attached scsi %sdisk %s\n",
> > >  		    sdp->removable ? "removable " : "", gd->disk_name);
> > > Index: 2.6-git/drivers/scsi/sr.c
> > > ===================================================================
> > > --- 2.6-git.orig/drivers/scsi/sr.c
> > > +++ 2.6-git/drivers/scsi/sr.c
> > > @@ -604,6 +604,7 @@ static int sr_probe(struct device *dev)
> > >  	if (sdev->media_change_notify)
> > >  		disk->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
> > >  	add_disk(disk);
> > > +	sdev->disk = disk;
> > >  
> > >  	sdev_printk(KERN_DEBUG, sdev,
> > >  		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
> > > Index: 2.6-git/include/scsi/scsi_device.h
> > > ===================================================================
> > > --- 2.6-git.orig/include/scsi/scsi_device.h
> > > +++ 2.6-git/include/scsi/scsi_device.h
> > > @@ -138,7 +138,7 @@ struct scsi_device {
> > >  
> > >  	struct device		sdev_gendev;
> > >  	struct class_device	sdev_classdev;
> > > -
> > > +	struct gendisk 		*disk;
> > >  	struct execute_work	ew; /* used to get process context on put */
> > >  
> > >  	enum scsi_device_state sdev_state;
> > 
> > If you're going to do this, you need to take on board removing the
> > struct gendisk from all the ULD structures (since it's now become
> > generic).
> > 
> > James
> > 
> 
> Ok - I can send that as a separate patch series, or I can include it
> in this one.  Which is preferred?
> 

I interpret the lack of response to this question to mean that I can just
decide for myself - in which case I prefer to send this as a separate 
patchset after this one is integrated.

Thanks!
Kristen
