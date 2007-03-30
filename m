From: Greg KH <gregkh@suse.de>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Fri, 30 Mar 2007 10:41:58 -0700
Message-ID: <20070330174158.GB4469@suse.de>
References: <460CDBA6.5030608@gmail.com> <1175257751.3760.19.camel@mulgrave.il.steeleye.com> <460D12B8.6050101@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <460D12B8.6050101@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, hugh@veritas.com, cornelia.huck@de.ibm.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 30, 2007 at 10:38:00PM +0900, Tejun Heo wrote:
> James Bottomley wrote:
> > On Fri, 2007-03-30 at 18:43 +0900, Tejun Heo wrote:
> >> Orphaning sysfs nodes on unregistration is a big step in this
> >> direction.  With sysfs reference counting out of the picture,
> >> implementing 'disconnect immediate' interface only on a few components
> >> (including request_queue) should suffice for most block device
> >> drivers.  I'm not familiar with other drivers but I don't think
> >> they'll be very different.
> > 
> > I agree with this statement.  The big question in my mind is how do we
> > do it?
> > 
> > The essential problem, and the reason why the lifetime rules are
> > entangled is that fundamentally, sysfs entries are managed by kobjects.
> > The things the device drivers are interested in is struct device, which
> > is usually embedded in driver data structures.  Unfortunately, the
> > required kobject is usually embedded in struct device meaning that the
> > relevant driver structure cannot be freed while the sysfs entry still
> > exists.
> > 
> > It seems to me that the only way to Orphan the sysfs entries is to
> > separate the kobject and the struct device so their lifetime rules are
> > no longer entangled.  Then we can free the driver structure with the
> > embedded struct device while still keeping the necessary kobject around
> > to perform orphaned sysfs operations.
> > 
> > So it seems to me that what we need to do is to give struct device its
> > own kref and a pointer to a kobject.  Then we can manage the separate
> > lifetimes independently.  The device would basically allocate and take a
> > reference to the kobject on device_add() and relinquish it again (and
> > null out the kobject pointer) on device_del().  The complexity here is
> > that we now have to allocate the kobject somewhere else ... probably in
> > device_add() (it doesn't come for free with the device structures).
> 
> My plan was to make sysfs more independent from struct device/kobject.
> e.g. Something like the following.
> 
> * kobject_get() on attr/symlink creation
> * open() doesn't need extra kobject reference
> * deleting a node makes it release the kobject reference and the kobject
> pointer is nullified.

Hm, this sounds good, but I think it will be racy.

Although separating the very tight tie between sysfs and kobject would
be very good to have.  Pat originally wanted to do that years ago,
but he's now lost to the land of a million sheep...

So I don't object to this goal at all.

> This way the sysfs reference counting can be put completely out of
> picture without impacting the rest of code.  Handling symlink and
> suicidal attributes might need some extra attention but I think they can
> be done.

Ok, I'll but I really want to see that code :)

> In the long term, I think sysfs should be independent from driver model
> and kobject such that an entity which wants to use sysfs but is not a
> device doesn't have to dance with kobject just to use sysfs.

I agree.

thanks,

greg k-h
