From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] correct module refcounting
Date: Tue, 28 Oct 2003 17:46:54 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031029014654.GB2146@beaverton.ibm.com>
References: <1067377564.1788.39.camel@mulgrave> <20031029001724.GA2029@beaverton.ibm.com> <1067388134.1788.59.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:24234 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261788AbTJ2BmP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 20:42:15 -0500
Content-Disposition: inline
In-Reply-To: <1067388134.1788.59.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> On Tue, 2003-10-28 at 18:17, Mike Anderson wrote:
> > If we do this we will need to do a two phase init of the sdev_gendev
> > like we do with the host. Otherwise every device_register will cause the
> > sd_probe to be called.
> 
> well...we really already have this: slave_alloc and slave_configure, so
> I think we may be able to slot it into the infrastructure.

ok. Since you already have this patch started are you going to add this,
or did you want me to look at this?

> 
> > > Finally, when this is done, we can take a device reference over both
> > > scsi_get_command/scsi_put_command and also within the scsi_request_fn so
> > > we know the device can never be released while it has outstanding
> > > commands or while we are running its queues.
> > > 
> > 
> > What case of IO in-flight post a upper level driver release call are you
> > trying to protect. Do you think these extra atomic_incs will have any
> > negative impact.
> 
> It's more symmetry...since the elimination of scsi_device.access_count
> we've been moving over to relying on the generic device reference
> counting.  This would just be an extension.
> 
> I don't think an atomic_inc is particularly expensive compared with the
> slab allocation of the commmand.
> 

This is probably true. In the past I had thought refs for every
scsi_get_command/scsi_put_command where excessive when you should have
other refs (i.e., open, direct get calls) keeping the device in place.
Though I still cannot track down the usb issue from lkml where the
elv_queue_empty function is oopsing :-(.

> > > +	if (!try_module_get(sdev->host->hostt->module))
> > > +		goto out;
> > > +
> > >  	sdev = kmalloc(sizeof(*sdev), GFP_ATOMIC);
> > >  	if (!sdev)
> > >  		goto out;
> > 
> > Shouldn't this chunk be after the setting of sdev. I applied your patch
> > and it oops on me. After I moved it I am booted, but I have not done any
> > adds / deletes.
> 
> Cut and paste error.  That should read if
> (!try_module_get(shost->hostt->module))
> 
> but it should be before the kmalloc.
> 

ok. You will also need a module_put on failures, but maybe I need to
wait for an update patch.

-andmike
--
Michael Anderson
andmike@us.ibm.com

