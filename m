From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi_device refcounting and list lockdown
Date: Tue, 28 Oct 2003 10:07:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028090755.GB7370@lst.de>
References: <20031027155713.GA28140@lst.de> <20031028023235.GE1151@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:24813 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263888AbTJ1JIA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 04:08:00 -0500
Content-Disposition: inline
In-Reply-To: <20031028023235.GE1151@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Mon, Oct 27, 2003 at 06:32:35PM -0800, Mike Anderson wrote:
> > +	/*
> > +	 * Ok, this look a bit strange.  We always look for the first device
> > +	 * on the list as scsi_remove_device removes them from it - thus we
> > +	 * also have to release the lock.
> > +	 * We don't need to get another reference to the device before
> > +	 * releasing the lock as we already own the reference from
> > +	 * scsi_register_device that's release in scsi_remove_device.  And
> > +	 * after that we don't look at sdev anymore.
> > +	 */
> > +	spin_lock_irqsave(shost->host_lock, flags);
> > +	list_for_each_entry_safe(sdev, tmp, &shost->__devices, siblings) {
> > +		spin_unlock_irqrestore(shost->host_lock, flags);
> >  		scsi_remove_device(sdev);
> > +		spin_lock_irqsave(shost->host_lock, flags);
> >  	}
> > +	spin_unlock_irqrestore(shost->host_lock, flags);
> >  }
> >  
> >  /*
> 
> Do we still have issues with other callers of scsi_remove_device?

Well, the other callers aren't walking the list until it's empty but
just remove a single device which is fine with the existing constructs.

> >  void scsi_remove_device(struct scsi_device *sdev)
> >  {
> > -	struct class *class = class_get(&sdev_class);
> > -
> >  	class_device_unregister(&sdev->sdev_classdev);
> > -
> > -	if (class) {
> > -		down_write(&class->subsys.rwsem);
> > -		set_bit(SDEV_DEL, &sdev->sdev_state);
> > -		if (sdev->host->hostt->slave_destroy)
> > -			sdev->host->hostt->slave_destroy(sdev);
> > -		device_del(&sdev->sdev_gendev);
> > -		up_write(&class->subsys.rwsem);
> > -	}
> > -
> > +	if (sdev->host->hostt->slave_destroy)
> > +		sdev->host->hostt->slave_destroy(sdev);
> > +	device_del(&sdev->sdev_gendev);
> >  	put_device(&sdev->sdev_gendev);
> > -
> > -	class_put(&sdev_class);
> >  }
> >  
> 
> Don't we still want to set SDEV_DEL to keep callers to scsi_device_get
> from do more gets.

Indeed!  James, can you add this back when applying?

