From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] correct module refcounting
Date: 28 Oct 2003 18:42:11 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067388134.1788.59.camel@mulgrave>
References: <1067377564.1788.39.camel@mulgrave>
	<20031029001724.GA2029@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:17413 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261824AbTJ2AmV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 19:42:21 -0500
In-Reply-To: <20031029001724.GA2029@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-10-28 at 18:17, Mike Anderson wrote:
> > I also think we probably want to move sdev_gendev population into
> > scsi_allocate_sdev.  Note this will change how we do initial scans
> > because now we'll be using the generic device release infrastructure to
> > free even temporary devices.  Unless anyone has a better idea...?
> > 
> 
> If we do this we will need to do a two phase init of the sdev_gendev
> like we do with the host. Otherwise every device_register will cause the
> sd_probe to be called.

well...we really already have this: slave_alloc and slave_configure, so
I think we may be able to slot it into the infrastructure.

> > Finally, when this is done, we can take a device reference over both
> > scsi_get_command/scsi_put_command and also within the scsi_request_fn so
> > we know the device can never be released while it has outstanding
> > commands or while we are running its queues.
> > 
> 
> What case of IO in-flight post a upper level driver release call are you
> trying to protect. Do you think these extra atomic_incs will have any
> negative impact.

It's more symmetry...since the elimination of scsi_device.access_count
we've been moving over to relying on the generic device reference
counting.  This would just be an extension.

I don't think an atomic_inc is particularly expensive compared with the
slab allocation of the commmand.

> > +	if (!try_module_get(sdev->host->hostt->module))
> > +		goto out;
> > +
> >  	sdev = kmalloc(sizeof(*sdev), GFP_ATOMIC);
> >  	if (!sdev)
> >  		goto out;
> 
> Shouldn't this chunk be after the setting of sdev. I applied your patch
> and it oops on me. After I moved it I am booted, but I have not done any
> adds / deletes.

Cut and paste error.  That should read if
(!try_module_get(shost->hostt->module))

but it should be before the kmalloc.

James


