From: Greg KH <gregkh@suse.de>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Fri, 30 Mar 2007 10:38:31 -0700
Message-ID: <20070330173831.GA4469@suse.de>
References: <460CDBA6.5030608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <460CDBA6.5030608@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: hugh@veritas.com, cornelia.huck@de.ibm.com, dmitry.torokhov@gmail.com, oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net, James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 30, 2007 at 06:43:02PM +0900, Tejun Heo wrote:
> Hello, all.
> 
> This document tries to describe lifetime problems of the current
> device driver model primarily from the point view of device drivers
> and establish consensus, or at least, start discussion about how to
> solve these problems.  This is primarily based on my experience with
> IDE and SCSI layers and my knowledge on other drivers is limited, so I
> might have generalized too aggressively.  Feel free to point out.

Very nice summary of the problems we are trying to address here,
thanks for doing this.

> 2. How do we solve this?
> 
> 2-1. Rule #a and #b
> 
> If you think about it, the impedance matching between rule #a and #b
> should be done somewhere.  Maybe doing it in each low level driver is
> what's intended when the driver model is designed but it's
> impractically painful and the reality reflects that by doing it in
> midlayers.
> 
> It's better if we do it in higher layers.  For example, SCSI has a
> mechanism to reject new requests and drain request_queue to allow low
> level driver to just unregister an existing device.  IDE currently
> doesn't have such feature but it would need to do almost the same
> thing to support hotplug.  If request_queue just had a feature to
> drain and kill itself, both SCSI and IDE could use it.  It would be
> simpler and less error-prone.  On the other hand, if it's pushed
> downward, it will cause much more pain in all the low level drivers.

No, we should not push this kind of thing down to the lower drivers.

In fact, my goal is to try to keep a "normal" driver writer from having
to know anything about the driver model, except for how to add and
remove a sysfs file that is bound to the device controlled by the
driver.

And for the majority of the busses, this is true, it's only people like
you who are mucking around in the bus specific code that know how hard
this whole thing is :)

> Orphaning sysfs nodes on unregistration is a big step in this
> direction.  With sysfs reference counting out of the picture,
> implementing 'disconnect immediate' interface only on a few components
> (including request_queue) should suffice for most block device
> drivers.  I'm not familiar with other drivers but I don't think
> they'll be very different.
> 
> All in all, I'm hoping something like the following can be done in
> device drivers, midlayer or low level.
> 
> * For binding
> 
>  alloc resources;
>  init controller;
>  register to upper layers;
> 
> * For unbinding
> 
>  unregister from upper layers; (no lingering references or objects)
>  deinit controller;
>  release resources;
> 
> This basically nullifies lifetime rule #b from the POV of drivers.

I agree, that should be our goal.  And for almost all busses, this is
true today, right?

> 2-2. Rule #b and #c
> 
> One way to solve this problem is to subordinate lifetime rule #b to
> rule #c.  Each kobject points to its owning module such that grabbing
> a kobject automatically grabs the module.  The problem with this
> approach is that it requires wide update and makes kobject_get
> heavier.

Why would kobject_get become heavier?

> Another more appealing approach is to do nothing.  Solving the problem
> between rule #a and #b in the way described above means virtually
> nullifying rule #b.  With rule #b gone, rule #c can't conflict with
> it.  IOW, no reference from upper layer would be remaining after a
> driver unregisters itself from the upper layer - the module can be
> safely unloaded.

Yes, but you have to watch out for devices that add their own files with
callbacks to that driver.  That is a problem today that Oliver has tried
to address with his recent patches.

> 3. How do we get there from here?
> 
> The current device driver model is used by most device drivers - huge
> amount of code.  We can't update them at once.

No, the majority of the logic is in the busses, and we can update them
pretty easily.

> Fortunately, the
> suggested solution can easily be implemented gradually.  We can add
> 'disconnect now' interface to upper driver interface one-by-one and
> convert its users gradually.  The existing reference counting
> mechanism can be left alone and used to verify that the conversion is
> correct by verifying reference count is 0 after unregistering.
> 
> Once the conversion is complete (maybe after a year), we can remove
> the reference counting mechanism from device driver interface.

I'd be interested in seeing how we can do this.  Do you have any
specific patches started in this area?

> 4. Some afterthoughts
> 
> * Doing this would make module reference counting more flexible.
>  Instead of being confined by implementation, it can be used to
>  define when to allow and disallow module unloading.  (you can't
>  unload a block driver module if a fs on it is mounted but sysfs
>  access doesn't matter.)

Well, remember, module unloading is racy and unrecommended to use anyway
:)

Also, look at the network drivers who all have their own special type of
lock, with no module reference count increment when they are in use.  Is
this what you want to do for everything else?

> * Outside of device driver model, kobject is currently used to supply
>  something sysfs nodes can be attached to, such that both the
>  information supplier and node users have something common to
>  reference count.  With orphaning added, there is no need to use
>  kobject this way.  IMHO, kobject should have been implementation
>  detail inside the device model proper in the first place.

Well, kobject was created because Al Viro wanted to use them for the
block devices and it didn't make sense to use a 'struct device' for them
at the time.  Also, the class code wasn't even around then (this is
_very_ early 2.5 timeframe.

So yes, any cleanups and refactoring that we can do in this area would
be very good and welcome.  Kay has had some ideas for how we can clean
up the whole subsystem/kset mess too.  Hopefully something comes of that
soon.

thanks,

greg k-h
