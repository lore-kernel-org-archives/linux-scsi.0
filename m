From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi sysfs cleanups
Date: Tue, 19 Nov 2002 10:39:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021119183908.GA1120@beaverton.ibm.com>
References: <20021119153008.GA1544@beaverton.ibm.com> <20021119164856.A11391@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021119164856.A11391@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> On Tue, Nov 19, 2002 at 07:30:08AM -0800, Mike Anderson wrote:
> > +static inline void scsi_class_data_set(struct device *dev,
> > +				       struct Scsi_Host *host)
> > +{
> > +	dev->class_data = (void *)host;
> > +};
> > +
> > +static inline struct Scsi_Host *scsi_class_data_get(struct device *dev)
> > +{
> > +	return (struct Scsi_Host *) dev->class_data;
> > +};
> 
> These casts look rather pointless.
> 

These interfaces allow LLDD to use the probe / remove device model
driver interfaces without having to store a previously registered
scsi_host pointer away in there private data. On remove a LLD is passed
a struct device pointer and would need to determine the associated
scsi_host to call scsi_remove_host.

I was trying to ensure consistency and type checking of class_data used
by host of class type scsi-host.

In the device model the struct device contains three void pointers for
use by associated member. driver_data is a private data pointer for the
device driver. class_data is for use by the class in this case scsi-host
class.


> > -module_init(init_scsi);
> > +subsys_initcall(init_scsi);
> >  module_exit(exit_scsi);
> 
> 
> What's the exact reason for this change?
> 

This could be removed. Without this change the
scsi_subsystem defaults to device_initcall level the same as upper and
lower levels. The original Makefile ordering SCSI has works around
this same level issue.

> >  /*
> > - * driverfs support for determining driver types
> > + * sysfs support
> >   */
> > -EXPORT_SYMBOL(scsi_driverfs_bus_type);
> > +EXPORT_SYMBOL(scsi_device_driver_register);
> > +EXPORT_SYMBOL(scsi_device_driver_unregister);
> > +EXPORT_SYMBOL(scsi_host_class_register);
> > +EXPORT_SYMBOL(scsi_host_class_unregister);
> > +EXPORT_SYMBOL(shost_devclass);
> 
> Why are these exported?
> 

The *device_driver* interfaces are possibly not needed any more as I
originally had them exported because they where being called directly by
the upper layers.  Now they are being called by the mid-layer which this
*.o is linked. In the future the upper layers could call these directly
as the operations in scsi_register_device are handled by the sysfs layer
if upper layers fully support the device model probe / remove / release.

The *host_class* are interfaces for the LLDD to call to register and
unregister as a scsi host class driver.

These interfaces are used in a scsi_debug patch I have beyond scsi_debug
1.65 that demonstrate the used of these interfaces.


> > +/**
> > + * scsi_host_class_register - register class scsi host
> > + * @dev:	class device to register
> > + * @shost:	scsi host associtated with class device
> > + *
> > + * Return value:
> > + **/
> > +int scsi_host_class_register(struct device *dev, struct Scsi_Host *shost)
> > +{
> > +	scsi_class_data_set(dev, shost);
> > +	scsi_host_dev_set(shost, dev);
> > +
> > +	scsi_add_host(shost);
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * scsi_host_class_unregister - unregister class scsi host.
> > + * @dev:	class device to unregister
> > + **/
> > +void scsi_host_class_unregister(struct device *dev)
> > +{
> > +	struct Scsi_Host *shost;
> > +
> > +	shost = scsi_class_data_get(dev);
> > +
> > +	scsi_remove_host(shost);
> > +
> > +	scsi_class_data_set(dev, NULL);
> > +
> > +}
> > diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> 
> What the point of these?  They don't seem to be used at all..
> 

See previous comment.

-andmike
--
Michael Anderson
andmike@us.ibm.com

