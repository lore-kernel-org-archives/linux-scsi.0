From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] 2/2 Use bus dev_attrs to create scsi_device attributes
Date: Thu, 31 Mar 2005 00:12:28 +0200
Message-ID: <1112220748.4631.94.camel@localhost.localdomain>
References: <20050302194432.GA9743@us.ibm.com>
	 <20050302194553.GA9776@us.ibm.com> <20050302194647.GB9776@us.ibm.com>
	 <20050316224551.GA21918@us.ibm.com> <1111071201.5994.4.camel@mulgrave>
	 <1112207564.4631.59.camel@localhost.localdomain>
	 <20050330214452.GA18345@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from soundwarez.org ([217.160.171.123]:56020 "EHLO soundwarez.org")
	by vger.kernel.org with ESMTP id S262457AbVC3WMb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2005 17:12:31 -0500
In-Reply-To: <20050330214452.GA18345@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Wed, 2005-03-30 at 13:44 -0800, Patrick Mansfield wrote:
> On Wed, Mar 30, 2005 at 08:32:44PM +0200, Kay Sievers wrote:
> > On Thu, 2005-03-17 at 09:53 -0500, James Bottomley wrote:
> > > On Wed, 2005-03-16 at 14:45 -0800, Patrick Mansfield wrote:
> > > > Any comments on this? Should I resend these patches?
> > > 
> > > Well, the basic comment is that there are a lot of features that SCSI
> > > has that the driver core lacks:
> > > 
> > > 1) Attribute overrides.  This is actually part of the published API for SCSI
> > 
> > What does this exactly mean? Handle the same attribute dynamically with
> > a different source of data?
> 
> Well a different function handled by the host driver, rather than the
> function in scsi core, for example, the twa_queue_depth_attr in
> drivers/scsi/3w-9xxx.c overrides the simple read attr function in
> scsi_syfs.c created via this line:
> 
> 	sdev_rd_attr (queue_depth, "%d\n").  
> 
> The patch left this in but only for queue_depth, not for all of the
> scsi_devie attributes. We have sht->change_queue_depth that can already
> handle this, some drivers use it, but some still use the sdev_attrs to
> override the queue_depth. IMO, we should get rid of the override, James
> doesn't agree.
> 
> James - are you OK with allowing only specific overrides of attributes?

Ok, I see. But how could that be solved in the core. By allowing to
override the sysfs-operations of already created attributes instead of
letting scsi dispatch these calls itself?

> > > 2) Ability to add extra attributes---several drivers use this
> > 
> > What is missing in the driver core here? Why can't you add/remove
> > attribute files at any time? 
> 
> The patch left this alone, but should be changed to make sure duplicate
> (that we can't override) attributes get errors. It is just a nice way for
> host adapters to add attributes to a scsi_device.
> 
> But, for any of these non bus_attr and class attributes, the hotplug
> notification (for scsi_device or the upper level block/char device) will
> still come before the attributes are created. This is also true for the
> transport attributes. This is a potential problem, I know of no udev
> program or hotplug helpers that use any of these attributes.

I was thinking about adding a special key to udev that will wait for a
attribute to show up. Just like the wait_for_sysfs logic we do today,
but only triggered by a explicit rule-key. In that case a user of that
attribute would need to add a rule to wait for a specific attribute.

> I see no easy way around this problem without a multi-step registration,
> like a device_init(), device_ready(). So a device_add would just be:
> 
> 	device_init()
> 	device_ready()
> 
> Is your kobject_hotplug patch still pending?

It's im -mm now.

> We also need the following, else dev_attrs will show up after the probe
> and hotplug event for a matching driver (for example, an sd block hotplug
> event is generated via the device_attach() call). This could be causing
> problems today, AFAIR you already hack around this problem in udev.

If that is possible, it would be nice, so we can get rid of the
hard-coded lists in udev, that are doing stat() loops at event time
until the attribute arrives.

Thanks,
Kay

