From: Martin Hicks <mort@bork.org>
Subject: Re: Transport Attributes -- attempt#3
Date: Fri, 16 Jan 2004 11:54:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116165401.GK27591@localhost>
References: <20040107185420.GA30627@localhost> <20040108131717.A9700@infradead.org> <20040114181241.GK27591@localhost> <20040116145457.C24608@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:8341 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S265769AbUAPQyD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 11:54:03 -0500
Content-Disposition: inline
In-Reply-To: <20040116145457.C24608@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org



On Fri, Jan 16, 2004 at 02:54:57PM +0000, Christoph Hellwig wrote:
> > +menu "SCSI Transport Attributes (EXPERIMENTAL)"
> > +	depends on EXPERIMENTAL && SCSI!=n
> 
> Do you really need the experimental flags? Actually this option is
> rather bogus anyway - with your patches posted the qlogic drivers won't
> compile anymore without those set.  So either make it unconditional or
> let the drives select it.

Nope.  I just turned it on while I was testing stuff.  I will remove it
for the next patch, since a few people have tried it out now :-)

> 
> > +ifdef CONFIG_SCSI_SPI_ATTRS
> > +transport-objs			+= scsi_transport_spi.o
> > +endif
> > +ifdef CONFIG_SCSI_FC_ATTRS
> > +transport-objs			+= scsi_transport_fc.o
> > +endif
> > +
> >  scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o constants.o \
> >  				   scsicam.o scsi_error.o scsi_lib.o \
> >  				   scsi_scan.o scsi_syms.o scsi_sysfs.o \
> > -				   scsi_devinfo.o
> > +				   scsi_devinfo.o $(transport-objs)
> 
> This still looks quite overcomplicated, what about a simple:
> 
> scsi_mod-$(CONFIG_SCSI_SPI_ATTRS) += scsi_transport_spi.o
> scsi_mod-$(CONFIG_SCSI_FC_ATTRS)  += scsi_transport_fc.o

Okay.  I wasn't sure how to do that.  My Makefile foo is lacking.

Thanks.


> > +/* A blank transport template that is used in drivers that don't
> > + * yet implement Transport Attributes */
> > +struct scsi_transport_template blank_transport_template = { NULL };
> 
> The zero-initialization is not needed.

right.

> 
> > +void scsi_sysfs_cleanup_fc_transport(struct scsi_device *sdev)
> > +{
> > +	kfree(sdev->transport_attr_values);
> 
> I think you'll have to do the kfree in the device's ->release, but maybe
> I got all that sysfs-foo wrong :)

I'll take a closer look.

> > +	/* Default values for the transport attributes */
> > +	void *default_attr_values;
> 
> Should this really be a void *?

I think so.  It has to be a struct spi_transport_attrs or a
fc_transport_attrs, depending on which transport template we're talking
about.

> 
> > +extern struct scsi_transport_template blank_transport_template;
> 
> Should be in scsi_priv.h as it's not exported, no?

Yup.

Thanks again,
mh

-- 
Martin Hicks || mort@bork.org || PGP/GnuPG: 0x4C7F2BEE
