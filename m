From: Doug Ledford <dledford@redhat.com>
Subject: Re: slave_destroy called in scsi_scan.c:scsi_probe_and_add_lun()
Date: Tue, 17 Dec 2002 17:24:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021217222459.GD28100@redhat.com>
References: <170040000.1040080786@aslan.btc.adaptec.com> <20021217054102.GH13989@redhat.com> <797140000.1040156703@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <797140000.1040156703@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Dec 17, 2002 at 01:25:07PM -0700, Justin T. Gibbs wrote:
> >> So, you cannot rely on slave_destroy as an indication of a device really
> >> going away in the physical sense.
> > 
> > No, you can.  In the code snippet above you might be destroying something 
> > at scsi0:0:0:0 and adding something at scsi0:0:1:0.  Regardless, the
> > thing  being destroyed is in fact going away permanently.
> 
> The SDEV, yes.  The physical device, not necessarily.

We're arguing semantics here.  On the extra slave_destroy() calls, one of 
two things will be true.  A) there was a device present, another 
slave_alloc() for this exact device has already been made, and we are now 
just destroying the extraneous reference to the device or B) there was no 
device and the destroy is in fact a real destroy event.  So, if in your 
slave_alloc() area you are attaching a scsi_device struct to other 
internal state information, you could in fact do a refcount attachement, 
and then on any transition from non-0 to 0 in the refcount you would in 
fact have a true destroy event.

Now, that being said, I agree that the above is utter crap.  It's dictated 
by historical fact in the scsi_scan.c code.  The scenario you point out 
below is actually what I would prefer and would have done, but I can in 
fact see the point that creating a new block queue for each device you 
scan is insane, especially on some fiber channel controllers doing 
probe_all_luns on very high lun limits.  At bootup I wouldn't really care 
about the overhead of creating all these queues.  I'm more concerned with 
hot plug events that bring a new controller online when a system is 
already under some amount of memory pressure.  My concern is that in that 
situation, allocating 256 block layer request structs plus a few other 
items for each device/lun we scan might in fact be excessive memory churn.  
Anyone who wishes is free to convince me otherwise, in which case we can 
fix the scan code properly and make it do like you are suggesting.

>  The concern is that
> the API should only be called when the system is saying "physical device
> gone", not due to some quirk in how the mid-layer manages its data objects.

Well, whatever other meaning you want to attach to it, it *is* about data 
objects.  That's why it's called slave_alloc()/slave_destroy() which are 
standard object manipulation terms.  One of the reasons I did this was so 
that in my driver I could yank out a bunch of host structs of the form

	unsigned char	queue_depth[MAX_TARGETS][MAX_LUNS};

and instead add a new struct aic_dev_data that I attach directly to 
device->hostdata during slave_alloc(), and in that struct aic_dev_data 
goes *all* the state data needed for that device.  It resulted in a not 
insignificant reduction in memory foot print for the driver.  And, once 
you start talking about higher and higher lun values, need I again mention 
fiber channel here, keeping complete tables like that becomes wasteful in 
the extreme.  So, the actual *primary* reason for adding this interface 
was exactly this manipulation of data objects.  The secondary use that a 
slave_destroy() event can trigger a device shutdown sequence in your 
driver was a bonus, but because of hokey crap in the scsi scan code it's a 
bonus that requires you refcount things instead of just assuming that a 
slave_destroy() is permanent.  My driver doesn't have that particular 
problem because when the scsi mid layer allocates the new sdev and calls 
slave_alloc(), I create a new struct, attach it, init it, then treat the 
two sdevs as totally independant entities, so when the destroy comes in on 
the probe device, all I have to do is kfree() my aic_dev stuff.  If I were 
to hook this for actual device shut down commands, then I would have to 
jump through the same hoops as you (or else do something simpler, like 
have slave_configure() set a AHC_DEVICE_RUNNING flag in your device state 
and on slave_destroy() only bother performing any shutdown operations if 
that flag is set).

> In otherwords, the mid-layer could just as easily free the sdev every
> time a probe fails, retain the already allocated sdev for the "found
> device", and allocate a new sdev for each new probe.  This would avoid
> callbacks for physical devices that Linux has successfully probed.
> 
> > Whenever we do
> > find a  device, we actually allocate a new device struct identical to our
> > current  device struct and call slave_alloc() for the newly created
> > device.  So,  whenever we find a new device, there will be a momentary
> > point in time at  which two device structs will exist that point to the
> > same device.  After  the new device is allocated and set up, the original
> > sdevscan device is  simply renumbered in place (by updating the target or
> > lun value) and then  we call slave_destroy()/slave_alloc() so that the
> > low level driver can  also update their target/lun values to match.
> 
> Actually, this danger only exists if the low lever driver attaches
> something to the SDEV and/or has a pointer to the SDEV.  The device
> at a particular target/lun is still the same device.  The little dance
> performed in the mid-layer can't change that.

Hanging data structs off of the sdev->hostdata place holder is exactly 
what this was intended to support.

> >>  In SPI, for example, the driver can only
> >> tell that the device is gone if a command is issued to it.  I had hoped
> >> that I could detect hot-pull/scsi-remove-single-device operations via
> >> this callback.
> > 
> > You can.  On any device we find, at device tear down time your 
> > slave_destroy() entry point will get called right before the device
> > struct  itself is kfree()ed.
> 
> The problem is that the SDEV lifetime is not representative to the
> device's lifetime.

Only true for the sdev used to scan the devices.  The use of either 
refcounting or the simple flag set during slave_configure() either one 
would solve your problem.  And yes, I do agree that this answer is ugly, 
but I need someone to convince me that block queue allocations on a live 
and possibly busy machine aren't something that could cause problems 
before I would change it myself.

Well, that or I need Jens to clean up the block layer allocation code so 
that it only allocates one request at block queue init time and from then 
on does lazy request allocations once the device needs them, similar to 
what I did with the scsi command blocks.  That way, strong memory pressure 
and huge, wasted allocations would be avoided.  It would also make sense 
to me if Jens would add a feature to the block layer so that when we 
adjust our scsi queue depth on our devices that we can indicate our queue 
depth to the block layer so that the block layer could adjust its request 
depth to some amount > our queue depth for optimum merging and what not.  
Dynamic changes to this depth at the block layer would also be nice.  If 
these changes were made, then I would rip the damn scsi_scan code apart 
and put it back together right using the exact semantics you outlined 
above.

> Actually, the slave_configure() is postponed until way after the inquiry
> data is retrieved.  If slave_congigure() were called as soon as the
> device were properly detected, the slave_destroy() in scsi_scan.c would
> be destroying a device that had been slave_configured.

Heh, if you write your code that way, then yes.  In my driver it would 
not:

alloc_sdev(sdev1)
slave_alloc(sdev1) - attaches struct to sdev
INQUIRY
  found device!
  alloc_sdev(sdev2)
  copy state from sdev1 to sdev2
  slave_alloc(sdev2) - attaches a freshly kmalloced struct to sdev2
  slave_configure(sdev2) - inits sdev2->hostdata struct state
slave_destroy(sdev1) - destroys original struct, leaving the configured 
struct untouched

In my driver I don't attempt to do anything like send cache flush commands 
or the like, so I don't have the shutdown difficulties you do and things 
work quite nicely.

We could make things work much nicer for your driver if Jens makes those 
changes to the block layer that I just suggested (hint! hint!)

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
