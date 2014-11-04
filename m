From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/11] scsi: don't set tagging state from
	scsi_adjust_queue_depth
Date: Tue, 4 Nov 2014 11:47:39 +0100
Message-ID: <20141104104739.GE19154@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-10-git-send-email-hch@lst.de> <54589BE1.6070106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51330 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaKDKrq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 05:47:46 -0500
Content-Disposition: inline
In-Reply-To: <54589BE1.6070106@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

> > diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> > index a759cb2..596c2f4 100644
> > --- a/drivers/scsi/aacraid/linit.c
> > +++ b/drivers/scsi/aacraid/linit.c
> > @@ -462,9 +462,8 @@ static int aac_slave_configure(struct scsi_device *sdev)
> >  			depth = 256;
> >  		else if (depth < 2)
> >  			depth = 2;
> > -		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
> > -	} else
> > -		scsi_adjust_queue_depth(sdev, 0, 1);
> > +		scsi_adjust_queue_depth(sdev, depth);
> > +	}
> >  
> >  	return 0;
> >  }
> Why did you omit the 'else' branch?
> cmd_per_lun is set to 256 for aacraid AFAICS ...

Thanks, fixed.

> Hmm. This is actually wrong; it should be set to '1'.
> '2' is a left-over from the (long since removed) internal queueing
> within the aic7xxx driver.

Please send a separate patch for that.  Interestingly your patch that
sets it to 1 for aic79xx sais that's only temporarily.  If you still
have the hardware (either one should be fine) that driver could use
some major cleanup in how it deals with queuing and tags.

> > diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
> > index d8dcf36..aa0f403 100644
> > --- a/drivers/scsi/u14-34f.c
> > +++ b/drivers/scsi/u14-34f.c
> > @@ -696,25 +696,25 @@ static int u14_34f_slave_configure(struct scsi_device *dev) {
> >     if (TLDEV(dev->type) && dev->tagged_supported)
> >  
> >        if (tag_mode == TAG_SIMPLE) {
> > -         scsi_adjust_queue_depth(dev, MSG_SIMPLE_TAG, tqd);
> > +         scsi_adjust_queue_depth(dev, tqd);
> >           tag_suffix = ", simple tags";
> >           }
> >        else if (tag_mode == TAG_ORDERED) {
> > -         scsi_adjust_queue_depth(dev, MSG_ORDERED_TAG, tqd);
> > +         scsi_adjust_queue_depth(dev, tqd);
> >           tag_suffix = ", ordered tags";
> >           }
> >        else {
> > -         scsi_adjust_queue_depth(dev, 0, tqd);
> > +         scsi_adjust_queue_depth(dev, tqd);
> >           tag_suffix = ", no tags";
> >           }
> >  
> >     else if (TLDEV(dev->type) && linked_comm) {
> > -      scsi_adjust_queue_depth(dev, 0, tqd);
> > +      scsi_adjust_queue_depth(dev, tqd);
> >        tag_suffix = ", untagged";
> >        }
> >  
> >     else {
> > -      scsi_adjust_queue_depth(dev, 0, utqd);
> > +      scsi_adjust_queue_depth(dev, utqd);
> >        tag_suffix = "";
> >        }
> >  
> See my comment on the previous patches. As we're not using
> ordered tags that branch is never used.

The tag_mode is a module parameter.  I've kept it for compatibility
(or lazyness..), but there's no effect left, similar to the queue_type
sysfs file that still accept the "ordered" value.
