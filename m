From: Martin Hicks <mort@wildopensource.com>
Subject: Re: Transport Attributes -- attempt#2
Date: Thu, 8 Jan 2004 09:01:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040108140155.GD30627@localhost>
References: <20040107185420.GA30627@localhost> <20040108131717.A9700@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:16291 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S264449AbUAHOB7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2004 09:01:59 -0500
Content-Disposition: inline
In-Reply-To: <20040108131717.A9700@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org



On Thu, Jan 08, 2004 at 01:17:17PM +0000, Christoph Hellwig wrote:
> +config SCSI_PSCSI_ATTRS
> +	bool "Parallel SCSI Transport Attributes"
> 
> >> Scan we replacte the PSCSI/pscsi in identifiers with SPI/spi as used in
> >> the t10 standards documents please?  This is a bit shorter and the correct
> >> name.  In user-visible string Parallel SCSI is fine with me, but
> >> maybe it should rather be
> 
> 	bool "Parallel SCSI (SPI) Transport Attributes"

okay.

> 
>  
> +obj-$(CONFIG_SCSI_PSCSI_ATTRS)	+= scsi_transport_pscsi.o
> +obj-$(CONFIG_SCSI_FC_ATTRS)	+= scsi_transport_fc.o
> 
> >> This is wrong.  Currently the option are bool and you'd build them into
> >> the kernel even if the scsi code is modular.  Either use scsi_mod-*
> >> or make them their own modules using tristate (I still think that's
> >> overkill just for the attributes, but jejb seems to like it)
> 

Agreed.  I had the options as tristate inititally, then changed them
to bool.  I missed changing this stuff.

>  		snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
> +			 "%d:%d:%d:%d", sdev->host->host_no,
> +			 sdev->channel, sdev->id, sdev->lun);
> +
> +		class_device_initialize(&sdev->transport_classdev);
> +		sdev->transport_classdev.dev = &sdev->sdev_gendev;
> +		sdev->transport_classdev.class = sdev->host->hostt->transport_class;
> +		snprintf(sdev->transport_classdev.class_id, BUS_ID_SIZE,
> 
> >> Out of curiosity:  Why do we need _another_ classdev.  Can't you
> >> reuse the current one?

It guess we could re-use the scsi_device classdev.  This would mean that
all the attribute files would show up in /sys/class/scsi_device/w:x:y:z.
We would have to export an attribute called "transport" to tell which
transport the device is using.  I'm agreeable to this solution.  I don't
much like having an fc_transport and pscsi_transport directory in
/sys/class.

> 
> +	error = class_register(&sdev_class);
> +	if (error)
> +		goto undo_bus;
> +
> +#ifdef CONFIG_SCSI_PSCSI_ATTRS
> +	error = scsi_pscsi_transport_init();
> +	if (error)
> +		goto undo_sdev;
> +#endif
> +#ifdef CONFIG_SCSI_FC_ATTRS
> +	error = scsi_fc_transport_init();
> +	if (error)
> +		goto undo_all;
> +#endif
> 
> > Please put stubs in the header instead of ifdefs in the code.
> > (And 1:0 for jejb, with the moular approach this would just go away :))
>  

okay.

> + out:
>  	return error;
> +
> +	/* Prevent "unused label" warnings when either of the
> +	 * transport attributes config options are turned off. */
> +	goto undo_all;
> +	goto undo_sdev;
> 
> >> Yikes!

Agreed.

> 
> +extern int scsi_add_transport_attributes(struct scsi_device *sdev);
> 
> >> this is internal to the scsi midlayer, thus should go to scsi_priv.h
> >> (or be static to scsi_sysfs.c as suggested above)

Okay.  I wasn't sure where to put such functions.

> 
> +extern int scsi_export_transport_attributes(struct scsi_device *sdev);
> 
> >> doesn't seem to exist at all..

missed that during a cleanup. Thanks.

> +	host->hostt->transport_attrs = pscsi_transport_attrs;
> +	host->hostt->transport_class = &pscsi_transport_class;
> 
> >> Please set them _directrly_ in the host template. 
> >> Currently you're writing to the host template for every found adapter..
> 
> +static int
> +qla1280_slave_alloc(Scsi_Device *device)
> 
> >> should be struct scsi_device *sdev

I agree.  I'm just following what the rest of the driver does.

> 
> +{
> +	int error = 0;
> +
> +	error = pscsi_alloc_transport_attrs(device);
> +	if (error)
> +		return error;
> +
> +	return error;
> +}
> 
> >> Okay, this is ugly as hell, as every driver needs to duplicate this
> >> verbosely.  Better have a scsi_set_{spi,fc}_transport function that
> >> can be called in module_init and then does not only set the calls
> >> and attributes (so they don't need to exposed anymore but also a
> >> default constructor for the attributes.
> 
> +void qla1280_slave_destroy(Scsi_Device *device)
> +{
> +	pscsi_destroy_transport_attrs(device);
> +}
> 
> >> I don't think the _destroy_transport_attrs call makes sense,
> >> just kfree the transport_attrs field in the core code uncondititionally.
> >> If you plan more complex destructors for some reason put a destructor
> >> in the host teplate, similar to the constructore mentioned above.

okay.  It should be done wherever the sdev is de-allocated.

> 
> In fact after all the above suggestions it might be useful to have
> a struct scsi_transport_attribute instead of stuffing all that into
> the host template (sorry for guiding you into that direction).  The most
> logical interface to set it would be to have a third argument for
> scsi_host_alloc, but we can't break that interface now, so we should
> probably add scsi_set_transport(struct Scsi_host *,
> struct scsi_transport_template *), then and the driver will do in it's probe
> rountine, somewhere between scsi_host_alloc and scsi_add_host a
> scsi_set_transport(shost, &scsi_spi_template);

what do others think about this?  This seems nice to me.  I'm going to
go ahead with working on this.

More feedback is always welcome!
mh

-- 
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296
