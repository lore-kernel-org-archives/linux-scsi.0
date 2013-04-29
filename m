From: "Steven J. Magnani" <steve@digidescorp.com>
Subject: Re: [PATCH RESEND^2] sd: fix infinite kernel/udev loop on
 non-removable Medium Not Present
Date: Mon, 29 Apr 2013 15:45:34 -0500
Message-ID: <1367268334.1653.47.camel@iscandar.digidescorp.com>
References: <1366994373-13324-1-git-send-email-steve@digidescorp.com>
	 <1366997459.16829.4.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1366997459.16829.4.camel@dabdike>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-04-26 at 10:30 -0700, James Bottomley wrote:
On Fri, 2013-04-26 at 11:39 -0500, Steven J. Magnani wrote:
> > Commit eface65c336eff420d70beb0fb6787a732e05ffb (2.6.38) altered
> > set_media_not_present() in a way that prevents the sd driver from
> > remembering that a non-removable device has reported "Medium Not
Present".
> > This condition can occur on hotplug of a (i.e.) USB Mass Storage
device
> > whose medium is offline due to an unrecoverable controller error,
> > but which is otherwise capable of SCSI communication (to download
new 
> > microcode, etc.).
> 
> This actually sounds to be a bug somewhere in the device.  Only
> removable devices are supposed to signal medium not present.

I don't see that spelled out in the -2 family of standards (SAM-2 /
SPC-2 / SBC-2). We're only claiming SPC-2 compliance; perhaps that's
something that got clarified in a later version? 

> > Under these conditions, the changed code results in an infinite loop
> > between the kernel and udevd. When udevd attempts to open the device
> > in response to a change notification, a SCSI "Medium Not Present"
error
> > occurs which causes the kernel to signal another change. The cycle
> > repeats until the device is unplugged, resulting in udevd consuming
ever-
> > increasing amounts of CPU and virtual memory.

One precondition for the infinite loop that got lost between
investigation of the problem and submission of the patch is that the
device has to identify itself BOTH as  "non-removable" and "write
protected". The reason is this clause in sd_open():

    if (sdev->removable || sdkp->write_prot)
        check_disk_change(bdev);

...which causes READ CAPACITY to be issued, to which the device responds
MEDIUM NOT PRESENT, which causes set_media_not_present() to be invoked
and to signal another "changed" event for userland.

Apologies for the oversight.

> 
> > Resolve this by remembering "media not present" whether the device
has
> > declared itself "removable" or not.
> > 
> > Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> > ---
> > --- a/drivers/scsi/sd.c 2013-04-12 14:16:12.252531097 -0500
> > +++ b/drivers/scsi/sd.c 2013-04-12 14:21:55.197216521 -0500
> > @@ -1298,10 +1298,8 @@ out:
> >  
> >  static void set_media_not_present(struct scsi_disk *sdkp)
> >  {
> > - if (sdkp->media_present)
> > + if (sdkp->media_present) {
> >  sdkp->device->changed = 1;
> > -
> > - if (sdkp->device->removable) {
> >  sdkp->media_present = 0;
> >  sdkp->capacity = 0;
> 
> I don't really like this change because it will affect TUR failure as
> well, which looks like it would then zero the capacity of a
> non-removable device which we aren't expecting.   

I think that concern is easily addressed by tweaking the patch to keep
the "sdkp->capacity = 0" statement conditional on
sdkp->device->removable.

> Can we dig into what's
> going wrong with the device first.  It sounds like it really is a
> removable device and it just needs to be flagged that way (either that
> or the USB SAT is so screwed up that we might need to apply other
> blacklists)

Being a USB Mass Storage device, it is removable from a USB sense, but
not I think in a SCSI sense - there is no ejectable cartridge or
anything. Commands like PREVENT ALLOW MEDIUM REMOVAL, which
identification as removable usually triggers, are nonsensical.

The scenario is generally one of these two uncommon use cases:

1. The device has come up in "failsafe mode" because the user damaged
the normal "operational" microcode by yanking power during an
operational microcode update. Failsafe mode allows for microcode update,
and not much else.

B. The internal controller has experienced an unrecoverable error
(reported with appropriate sense codes) during normal operation and the
USB connection has since been cycled (disconnected and reconnected; the
device is wall-powered, not bus-powered). 

I don't think either is invalid. 

I will stipulate that declaring a block device write-protected when no
medium is present does not make a whole lot of sense, and that's
something we will address going forward. However, I do think it's a Bad
Thing (from a security perspective, at minimum) if simply connecting a
device to a machine can bring down the system. The Windows FAT driver
has such issues. Surely Linux can do better, at least in this particular
case where only a minor tweak is needed, not even the addition of
defensive code.

Regards,
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>
