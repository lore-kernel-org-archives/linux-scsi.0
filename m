From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] dpt_i2o: 64 bit support (take 4)
Date: Fri, 25 Apr 2008 21:02:19 -0700
Message-ID: <20080426040219.GA17049@suse.de>
References: <20080424213459.GA21698@xs4all.net> <200804250948.43190.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:48323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbYDZEVM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2008 00:21:12 -0400
Content-Disposition: inline
In-Reply-To: <200804250948.43190.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, linux-scsi@vger.kernel.org

On Fri, Apr 25, 2008 at 09:48:42AM +0200, Rolf Eike Beer wrote:
> Miquel van Smoorenburg wrote:
> > sysfs code.
> >
> > # -------
> >
> > This patch is an update for drivers/scsi/dpt_i2o.c.
> > It applies to both 2.6.24.4 and 2.6.25
> >
> > It contains the following changes:
> >
> > * 64 bit code based on unofficial Adaptec 64 bit driver
> > * removes scsi_module.c dependency, adds module_init / module_exit
> >   this is needed because we need to pass the proper device to
> >   scsi_add_host(), and the scsi_module.c passes NULL. With NULL,
> >   code like arch/x64/kernel/pci-gart_64.c::need_iommu() crashes
> >   because the dev pointer it is passed is NULL.
> > * adds sysfs entry for /sys/class/dpt_i2o/dptiX so that udev
> >   can create /dev/dptiX dynamically
> >
> > Obviously there are more cleanups that can be done to this code,
> > but we need to start somewhere. Patch has been tested heavily on
> > both 32 and 64 bit x86 platforms.
> >
> > Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>
> >
> > diff -ruN linux-2.6.25/drivers/scsi/dpt_i2o.c
> > linux-2.6.25-sysfs/drivers/scsi/dpt_i2o.c ---
> > linux-2.6.25/drivers/scsi/dpt_i2o.c	2008-04-24 22:30:29.000000000 +0200 +++
> > linux-2.6.25-sysfs/drivers/scsi/dpt_i2o.c	2008-04-24 23:26:08.000000000
> > +0200 @@ -116,6 +116,8 @@
> >  static adpt_hba* hba_chain = NULL;
> >  static int hba_count = 0;
> >
> > +static struct class *adpt_sysfs_class;
> > +
> >  #ifdef CONFIG_COMPAT
> >  static long compat_adpt_ioctl(struct file *, unsigned int, unsigned long);
> >  #endif
> > @@ -259,6 +261,10 @@
> >  		adpt_inquiry(pHba);
> >  	}
> >
> > +	adpt_sysfs_class = class_create(THIS_MODULE, "dpt_i2o");
> > +	if (IS_ERR(adpt_sysfs_class))
> > +		adpt_sysfs_class = NULL;
> > +
> >  	for (pHba = hba_chain; pHba; pHba = pHba->next) {
> >  		if (adpt_scsi_host_alloc(pHba, sht) < 0){
> >  			adpt_i2o_delete_hba(pHba);
> > @@ -266,6 +272,11 @@
> >  		}
> >  		pHba->initialized = TRUE;
> >  		pHba->state &= ~DPTI_STATE_RESET;
> > +		if (adpt_sysfs_class) {
> > +			class_device_create(adpt_sysfs_class,
> > +				NULL, MKDEV(DPTI_I2O_MAJOR, pHba->unit),
> > +				NULL, "dpti%d", pHba->unit);
> > +		}
> >  	}
> >
> >  	// Register our control device node
> 
> class_device_create() has a return value that should probably be used for 
> something. Also Greg did many work to get rid of that class_device stuff 
> AFAIK so it's probably a bad idea to introduce a new one.

Yes, just use device_create() instead, it works just the same and as
class_device_create() will be gone in a week or so, it is something that
will work in 2.6.26 :)

thanks,

greg k-h
