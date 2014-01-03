From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 0/2] target refcounting infrastructure fixes for usb
Date: Thu, 02 Jan 2014 23:46:49 -0800
Message-ID: <1388735209.2399.48.camel@dabdike.int.hansenpartnership.com>
References: <20131220231810.GA2835@xanatos>
	 <Pine.LNX.4.44L0.1312211547490.12252-100000@netrider.rowland.org>
	 <20140103004551.GA2970@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39568 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbaACHqu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2014 02:46:50 -0500
In-Reply-To: <20140103004551.GA2970@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>

On Thu, 2014-01-02 at 16:45 -0800, Sarah Sharp wrote:
> On Sat, Dec 21, 2013 at 03:51:25PM -0500, Alan Stern wrote:
> > On Fri, 20 Dec 2013, Sarah Sharp wrote:
> > 
> > > On Thu, Dec 19, 2013 at 11:48:47AM -0800, James Bottomley wrote:
> > > > It should apply incrementally on top of the previous two.  If it
> > > > actually works, I'll fold it into the first patch.
> > > 
> > > Well, it doesn't oops anymore, but it does generate a pile of warnings:
> > 
> > This was a simple oversight.  scsi_target_reap() was called at the
> > start of __scsi_remove_device(), but it should be called at the end.
> > The patch below, applied on top of James's three patches, will fix the
> > warnings.
> > 
> > Alan Stern
> > 
> > P.S.: The comment isn't entirely correct any more...
> 
> Ok, Alan's additional patch fixed the warnings I was seeing on UAS
> device unplug.  James, can you Cc me on the finished patch when you send
> it in?

A bit late: it's here, but it should be on your usb list as well:

http://marc.info/?l=linux-scsi&m=138870949118304

James

> Hans, I don't want to send the UAS patches off to Greg until James'
> patches get into mainline.  I believe Greg's usb-next tree is frozen at
> this point, so they'll have to wait until 3.15.
> 
> Sarah Sharp
> 
> > Index: usb-3.13/drivers/scsi/scsi_sysfs.c
> > ===================================================================
> > --- usb-3.13.orig/drivers/scsi/scsi_sysfs.c
> > +++ usb-3.13/drivers/scsi/scsi_sysfs.c
> > @@ -1028,13 +1028,6 @@ void __scsi_remove_device(struct scsi_de
> >  {
> >  	struct device *dev = &sdev->sdev_gendev;
> >  
> > -	/*
> > -	 * Paired with the kref_get() in scsi_sysfs_initialize().  We're
> > -	 * removing sysfs visibility from the device, so make the target
> > -	 * invisible if this was the last device underneath it.
> > -	 */
> > -	scsi_target_reap(scsi_target(sdev));
> > -
> >  	if (sdev->is_visible) {
> >  		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
> >  			return;
> > @@ -1059,6 +1052,13 @@ void __scsi_remove_device(struct scsi_de
> >  		sdev->host->hostt->slave_destroy(sdev);
> >  	transport_destroy_device(dev);
> >  
> > +	/*
> > +	 * Paired with the kref_get() in scsi_sysfs_initialize().  We're
> > +	 * removing sysfs visibility from the device, so make the target
> > +	 * invisible if this was the last device underneath it.
> > +	 */
> > +	scsi_target_reap(scsi_target(sdev));
> > +
> >  	put_device(dev);
> >  }
> >  
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



