From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Transport Attributes -- attempt#3
Date: Fri, 16 Jan 2004 14:54:57 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116145457.C24608@infradead.org>
References: <20040107185420.GA30627@localhost> <20040108131717.A9700@infradead.org> <20040114181241.GK27591@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:62980 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265357AbUAPOzM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 09:55:12 -0500
Content-Disposition: inline
In-Reply-To: <20040114181241.GK27591@localhost>; from mort@wildopensource.com on Wed, Jan 14, 2004 at 01:12:41PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

> +menu "SCSI Transport Attributes (EXPERIMENTAL)"
> +	depends on EXPERIMENTAL && SCSI!=n

Do you really need the experimental flags? Actually this option is
rather bogus anyway - with your patches posted the qlogic drivers won't
compile anymore without those set.  So either make it unconditional or
let the drives select it.

> +ifdef CONFIG_SCSI_SPI_ATTRS
> +transport-objs			+= scsi_transport_spi.o
> +endif
> +ifdef CONFIG_SCSI_FC_ATTRS
> +transport-objs			+= scsi_transport_fc.o
> +endif
> +
>  scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
>  				   scsicam.o scsi_error.o scsi_lib.o \
>  				   scsi_scan.o scsi_syms.o scsi_sysfs.o \
> -				   scsi_devinfo.o
> +				   scsi_devinfo.o $(transport-objs)

This still looks quite overcomplicated, what about a simple:

scsi_mod-$(CONFIG_SCSI_SPI_ATTRS) += scsi_transport_spi.o
scsi_mod-$(CONFIG_SCSI_FC_ATTRS)  += scsi_transport_fc.o

> +#ifdef CONFIG_SCSI_SPI_ATTRS
> +EXPORT_SYMBOL(spi_transport_template);
> +#endif
> +#ifdef CONFIG_SCSI_FC_ATTRS
> +EXPORT_SYMBOL(fc_transport_template);
> +#endif

Should just move to the files declaring it.

> +	if (sdev->transport_classdev.class) {
> +		attrs = sdev->host->transportt->attrs;
> +		for (i = 0; attrs[i]; i++) {
> +			error = class_device_create_file(&sdev->transport_classdev,
> +							 attrs[i]);
> +			if (error)
> +				scsi_remove_device(sdev);

Missing break here, in fact the cleanup mioght better be after a lable
you goto to.

> +/* A blank transport template that is used in drivers that don't
> + * yet implement Transport Attributes */
> +struct scsi_transport_template blank_transport_template = { NULL };

The zero-initialization is not needed.

> +void scsi_sysfs_cleanup_fc_transport(struct scsi_device *sdev)
> +{
> +	kfree(sdev->transport_attr_values);

I think you'll have to do the kfree in the device's ->release, but maybe
I got all that sysfs-foo wrong :)

> +	void			* transport_attr_values;

	void			*transport_attr_values;

> +	/* Default values for the transport attributes */
> +	void *default_attr_values;

Should this really be a void *?

> +extern struct scsi_transport_template blank_transport_template;

Should be in scsi_priv.h as it's not exported, no?

