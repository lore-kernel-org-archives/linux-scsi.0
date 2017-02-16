From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] scsi_dh: only attach to SCSI devices
Date: Thu, 16 Feb 2017 15:38:17 +0100
Message-ID: <20170216143817.GA32302@lst.de>
References: <1487230394-84552-1-git-send-email-hare@suse.de> <1487255419.2973.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35832 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932075AbdBPOiT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 09:38:19 -0500
Content-Disposition: inline
In-Reply-To: <1487255419.2973.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@lst.de" <hch@lst.de>, "keith.busch@inter.com" <keith.busch@inter.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On Thu, Feb 16, 2017 at 02:30:34PM +0000, Bart Van Assche wrote:
> >  	sdev = q->queuedata;
> > -	if (!sdev || !get_device(&sdev->sdev_gendev))
> > +	if (!sdev ||
> > +	    !scsi_is_sdev_device(&sdev->sdev_gendev) ||
> > +	    !get_device(&sdev->sdev_gendev))
> >  		sdev = NULL;
> >  	spin_unlock_irqrestore(q->queue_lock, flags);
> 
> Hello Hannes,
> 
> Sorry but this approach looks wrong to me. A block driver can store any data
> in .queuedata, even data that would cause the scsi_is_sdev_device() function
> to crash.

Yes, I fear you're right.  I guess we need to call into the scsi_dh_*
functions through an indirection mediated by the block layer.
