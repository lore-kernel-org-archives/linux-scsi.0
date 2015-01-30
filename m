From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH 1/3] scsi: serialize ->rescan against ->remove
Date: Fri, 30 Jan 2015 09:08:49 +0800
Message-ID: <20150130010849.GA4794@ad.nay.redhat.com>
References: <1422486056-11591-1-git-send-email-hch@lst.de>
 <54CABE29.5080909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbbA3BJD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 20:09:03 -0500
Content-Disposition: inline
In-Reply-To: <54CABE29.5080909@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>

On Fri, 01/30 00:11, Paolo Bonzini wrote:
> 
> 
> On 29/01/2015 00:00, Christoph Hellwig wrote:
> > Lock the device embedded in the scsi_device to protect against
> > concurrent calls to ->remove.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I wonder if this makes this problem: https://lkml.org/lkml/2015/1/5/9 go
> away.

A quick test says yes.

Fam

> 
> Paolo
> 
> > ---
> >  drivers/scsi/scsi_scan.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index 983aed1..523faee 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -1593,16 +1593,15 @@ EXPORT_SYMBOL(scsi_add_device);
> >  
> >  void scsi_rescan_device(struct device *dev)
> >  {
> > -	if (!dev->driver)
> > -		return;
> > -
> > -	if (try_module_get(dev->driver->owner)) {
> > +	device_lock(dev);
> > +	if (dev->driver && try_module_get(dev->driver->owner)) {
> >  		struct scsi_driver *drv = to_scsi_driver(dev->driver);
> >  
> >  		if (drv->rescan)
> >  			drv->rescan(dev);
> >  		module_put(dev->driver->owner);
> >  	}
> > +	device_unlock(dev);
> >  }
> >  EXPORT_SYMBOL(scsi_rescan_device);
> >  
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
