From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 2/2 Use bus dev_attrs to create scsi_device attributes
Date: Wed, 30 Mar 2005 13:44:52 -0800
Message-ID: <20050330214452.GA18345@us.ibm.com>
References: <20050302194432.GA9743@us.ibm.com> <20050302194553.GA9776@us.ibm.com> <20050302194647.GB9776@us.ibm.com> <20050316224551.GA21918@us.ibm.com> <1111071201.5994.4.camel@mulgrave> <1112207564.4631.59.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53896 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262403AbVC3VpH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2005 16:45:07 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j2ULj3sj018326
	for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2005 16:45:03 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j2ULj3fl097444
	for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2005 16:45:03 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j2ULiwLC004956
	for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2005 16:44:59 -0500
Content-Disposition: inline
In-Reply-To: <1112207564.4631.59.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Wed, Mar 30, 2005 at 08:32:44PM +0200, Kay Sievers wrote:
> On Thu, 2005-03-17 at 09:53 -0500, James Bottomley wrote:
> > On Wed, 2005-03-16 at 14:45 -0800, Patrick Mansfield wrote:
> > > Any comments on this? Should I resend these patches?
> > 
> > Well, the basic comment is that there are a lot of features that SCSI
> > has that the driver core lacks:
> > 
> > 1) Attribute overrides.  This is actually part of the published API for SCSI
> 
> What does this exactly mean? Handle the same attribute dynamically with
> a different source of data?

Well a different function handled by the host driver, rather than the
function in scsi core, for example, the twa_queue_depth_attr in
drivers/scsi/3w-9xxx.c overrides the simple read attr function in
scsi_syfs.c created via this line:

	sdev_rd_attr (queue_depth, "%d\n").  

The patch left this in but only for queue_depth, not for all of the
scsi_devie attributes. We have sht->change_queue_depth that can already
handle this, some drivers use it, but some still use the sdev_attrs to
override the queue_depth. IMO, we should get rid of the override, James
doesn't agree.

James - are you OK with allowing only specific overrides of attributes?

> > 2) Ability to add extra attributes---several drivers use this
> 
> What is missing in the driver core here? Why can't you add/remove
> attribute files at any time? 

The patch left this alone, but should be changed to make sure duplicate
(that we can't override) attributes get errors. It is just a nice way for
host adapters to add attributes to a scsi_device.

But, for any of these non bus_attr and class attributes, the hotplug
notification (for scsi_device or the upper level block/char device) will
still come before the attributes are created. This is also true for the
transport attributes. This is a potential problem, I know of no udev
program or hotplug helpers that use any of these attributes.

I see no easy way around this problem without a multi-step registration,
like a device_init(), device_ready(). So a device_add would just be:

	device_init()
	device_ready()

Is your kobject_hotplug patch still pending?

We also need the following, else dev_attrs will show up after the probe
and hotplug event for a matching driver (for example, an sd block hotplug
event is generated via the device_attach() call). This could be causing
problems today, AFAIR you already hack around this problem in udev.

--- bleed-2.5/drivers/base/orig-bus.c	Tue Mar 15 17:08:18 2005
+++ bleed-2.5/drivers/base/bus.c	Wed Mar 30 10:48:34 2005
@@ -458,14 +458,14 @@ int bus_add_device(struct device * dev)
 	int error = 0;
 
 	if (bus) {
+		device_add_attrs(bus, dev);
+		sysfs_create_link(&bus->devices.kobj, &dev->kobj, dev->bus_id);
+		sysfs_create_link(&dev->kobj, &dev->bus->subsys.kset.kobj, "bus");
 		down_write(&dev->bus->subsys.rwsem);
 		pr_debug("bus %s: add device %s\n", bus->name, dev->bus_id);
 		list_add_tail(&dev->bus_list, &dev->bus->devices.list);
 		device_attach(dev);
 		up_write(&dev->bus->subsys.rwsem);
-		device_add_attrs(bus, dev);
-		sysfs_create_link(&bus->devices.kobj, &dev->kobj, dev->bus_id);
-		sysfs_create_link(&dev->kobj, &dev->bus->subsys.kset.kobj, "bus");
 	}
 	return error;
 }

-- Patrick Mansfield
