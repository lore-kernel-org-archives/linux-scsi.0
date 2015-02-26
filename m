From: brace <brace@pmcs.com>
Subject: RE: [PATCH 01/43] hpsa: add masked physical devices into h->dev[]
 array
Date: Thu, 26 Feb 2015 15:17:38 +0000
Message-ID: <07F70BBF6832E34FA1C923241E8833AB38D5D96E@BBYEXM01.pmc-sierra.internal>
References: <20150221221553.21954.32599.stgit@brunhilda>
 <20150221221735.21954.24837.stgit@brunhilda>
 <20150223201442.GA11037@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:53280 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbbBZPRo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2015 10:17:44 -0500
In-Reply-To: <20150223201442.GA11037@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Scott Teel <Scott.Teel@pmcs.com>, Kevin Barnett <Kevin.Barnett@pmcs.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, Justin Lindley <Justin.Lindley@pmcs.com>, brace <brace@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Monday, February 23, 2015 2:15 PM
> To: Don Brace
> Cc: Scott Teel; Kevin Barnett; james.bottomley@parallels.com;
> hch@infradead.org; Justin Lindley; brace; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 01/43] hpsa: add masked physical devices into h->dev[]
> array
> 
> > -/* link sdev->hostdata to our per-device structure. */
> >  static int hpsa_slave_alloc(struct scsi_device *sdev)
> >  {
> >  	struct hpsa_scsi_dev_t *sd;
> >  	unsigned long flags;
> >  	struct ctlr_info *h;
> > +	int queue_depth;
> >
> >  	h = sdev_to_hba(sdev);
> >  	spin_lock_irqsave(&h->devlock, flags);
> >  	sd = lookup_hpsa_scsi_dev(h, sdev_channel(sdev),
> >  		sdev_id(sdev), sdev->lun);
> > -	if (sd != NULL) {
> > -		sdev->hostdata = sd;
> > -		if (sd->queue_depth)
> > +
> > +	if (likely(sd)) {
> >  			scsi_change_queue_depth(sdev, sd->queue_depth);
> 
> Looks like the indentation is incorrect here.

Corrected.

> 
> >  		atomic_set(&sd->ioaccel_cmds_out, 0);
> > +		sdev->hostdata = (sd->expose_state & HPSA_SCSI_ADD) ? sd :
> NULL;
> > +		queue_depth = sd->queue_depth != 0 ?
> > +			sd->queue_depth : sdev->host->can_queue;
> > +	} else {
> > +		sdev->hostdata = NULL;
> > +		queue_depth = sdev->host->can_queue;
> >  	}
> > +
> > +	if (shost_use_blk_mq(sdev->host))
> > +		scsi_change_queue_depth(sdev, queue_depth);
> 
> But why do you have another call here only for the mq case?
> Also in general I'd really prefer if you'd only change the queue
> depth in ->slave_configure as most drivers do unless you have a good
> reason to do it differently.

Thanks, I corrected the code. Also, I asked Webb about setting up the queue
Depth in slave_alloc. His reply was " We needed to get tagging set up during allocation so that we could use it in the lead-up to configuration, which is why it was done in hpsa_slave_alloc(); and, given that the code there was then already messing about with queue depth, it made sense to also deal with the rest of it there."

But given your next comment, perhaps I need to clean this up more?
> 
> > +	else /* We depend on tags for cmd allocation. */
> > +		sdev->tagged_supported = 1;
> 
> Since 3.19-rc1 you'll always get tags from the first command sent, as
> we now moved the block tagging configuration earlier.
> 
> > +/* configure scsi device based on internal per-device structure */
> > +static int hpsa_slave_configure(struct scsi_device *sdev)
> > +{
> > +	struct hpsa_scsi_dev_t *sd;
> > +	unsigned long flags;
> > +	struct ctlr_info *h;
> > +
> > +	h = sdev_to_hba(sdev);
> > +	spin_lock_irqsave(&h->devlock, flags);
> > +	sd = sdev->hostdata;
> 
> There should be no need to have this dereference inside the spinlock.
> 
> Also can you explain somewhere why some devices might not have this
> hostdata set?

For our mixed mode controllers, we have started reporting all devices. The masked devices can be part of a logical volume, or it did not respond during the device scan. These do not get their hostdata set.
