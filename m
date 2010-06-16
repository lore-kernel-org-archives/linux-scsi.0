From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] SCSI: convert to the new PM framework
Date: Wed, 16 Jun 2010 16:56:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006161652230.1327-100000@iolanthe.rowland.org>
References: <1276717458.2847.321.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58310 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759670Ab0FPU4M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 16:56:12 -0400
In-Reply-To: <1276717458.2847.321.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 16 Jun 2010, James Bottomley wrote:

> On Wed, 2010-06-16 at 14:51 -0400, Alan Stern wrote:
> > This patch (as1397) converts the SCSI midlayer to use the new PM
> > callbacks (struct dev_pm_ops).  A new source file, scsi_pm.c, is
> > created to hold the new callback routines, and the existing
> > suspend/resume code is moved there.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > 
> > ---
> > 
> > Index: usb-2.6/drivers/scsi/Makefile
> > ===================================================================
> > --- usb-2.6.orig/drivers/scsi/Makefile
> > +++ usb-2.6/drivers/scsi/Makefile
> > @@ -158,7 +158,8 @@ obj-$(CONFIG_SCSI_WAIT_SCAN)	+= scsi_wai
> >  scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
> >  				   scsicam.o scsi_error.o scsi_lib.o
> >  scsi_mod-$(CONFIG_SCSI_DMA)	+= scsi_lib_dma.o
> > -scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
> > +scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o \
> > +				   scsi_pm.o
> 
> shouldn't this be
> 
> scsi_mod-$(CONFIG_PM_OPS) += scsi_pm.o
> 
> ?  especially since you guard the whole of the file with the ifdef
> otherwise.

That's right; I never noticed that the guard covered the entire source 
file.  Okay, I will revise and resubmit.

> > --- usb-2.6.orig/drivers/scsi/scsi_priv.h
> > +++ usb-2.6/drivers/scsi/scsi_priv.h
> > @@ -144,6 +144,13 @@ static inline void scsi_netlink_init(voi
> >  static inline void scsi_netlink_exit(void) {}
> >  #endif
> >  
> > +/* scsi_pm.c */
> > +#ifdef CONFIG_PM_OPS
> > +extern struct dev_pm_ops scsi_bus_pm_ops;
> > +#else
> > +#define scsi_bus_pm_ops		(*(struct dev_pm_ops *) NULL)
> 
> No need to cast a NULL ... the compiler seems to correctly not warn
> about &*NULL

I never tried it, just assumed the type mismatch would cause a warning.  
Good, that makes the code a little easier to understand.

> Otherwise seems OK.

Thanks for the review.

Alan Stern

