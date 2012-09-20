From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Thu, 20 Sep 2012 23:46:25 +0200
Message-ID: <201209202346.25888.rjw@sisk.pl>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <201209191450.37735.rjw@sisk.pl> <1348066345.2479.41.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1348066345.2479.41.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wednesday, September 19, 2012, James Bottomley wrote:
> On Wed, 2012-09-19 at 14:50 +0200, Rafael J. Wysocki wrote:
> > On Wednesday, September 19, 2012, James Bottomley wrote:
> > > On Wed, 2012-09-19 at 16:03 +0800, Aaron Lu wrote:
> > > > Hi James,
> > > > 
> > > > May I know if this patchset will enter v3.7?
> > > 
> > > Sigh, well, I was hoping to persuade the PM people to sort this out
> > > first.
> > > 
> > > The first observation is that all this looks to be too specific.  ZPO
> > > may be ACPI specific, but the property it abstracts: whether the
> > > particular device is powered off or not is generic and probably should
> > > be known at the generic PM level.  Nothing actually really cares about
> > > how we power off the device until you get all the way down to the ACPI
> > > controller.
> > > 
> > > I think we could do this with a couple of flags sitting inside struct
> > > device itself: one for pm state and capabilities defined at a generic
> > > level and one for device specific pm state.  The latter would be for
> > > things like the door lock information which is very specific to CDs
> > > (although not specific to SCSI CDs).  Alternatively, even if we can't
> > > use these capabilities at the generic pm level, we still need an
> > > internal state set of flags because power state stuff traverses the
> > > stack and struct device is the only universal object in that stack.
> > > 
> > > So I definitely think all of the sdev flags should become either generic
> > > or specific flags in device.
> > 
> > Well, the problem is that it is kind of irrelevant to the core whether or
> > not the given device can be powered off.  Moreover, the actual meaning of
> > what "power off" means depends on the platform (it may be an individual device
> > state or a power domain state, for instance).  Also, the set of available
> > low-power states depends on the platform (or the bus type) and generally
> > cannot be universally represented and there are low-power states that
> > aren't "power off" per se, but still require the device state to be
> > restored when putting it back into full power.
> 
> So I don't insist on it being generic, but we do need somewhere to hang
> the state.
> 
> > We've discussed that for a few times and each time we've ended up agreeing
> > that struct device is not the right place to store this information (for
> > example, PCI stores it in struct pci_dev, USB has its own rules etc.).
> 
> So, here's the problem this causes.  In SCSI, lower level devices have
> no access to the drivers (to which the upper layer structures are tied),
> so we have no way to go from device/scsi device to the scsi_disk
> structure say.  This means that a lot of device specific PM stuff tends
> to have flags in scsi_device just so we can get access to it.  A flag in
> device would allow us to carry the information farther (say to struct
> cdrom for instance).
> 
> > I'll have a look at the patchset again and see what can be done about this.

I think I see what you mean.

For example, the sr driver uses its "device" member to pass information
to the libata layer, if I understand things correctly, and the libata
layer cannot go back to its struct scsi_cd, right?

First off, I agree with you that putting those PM fields into struct scsi_device
is not the cleanest approach and it would be good to find some other place
for them.  However, I also don't think that struct device (or struct dev_pm_info
embedded in it for that matter) is any better (those fields in there would make
as little sense as they do in struct scsi_device).

Now, the question is where to store them and I think there are a couple of
places worth considering.  For instance, there's the void *driver_data field
in struct acpi_device that I bet is unused for the ACPI devices associated with
ATA ones and in principle it might be set by libata to point to a PM data
structure (that would require some "platform" helper functions for the
sr, sd etc. drivers to access that structure).  There also is the subsys_data
field in struct dev_pm_info that might be used to point to some libata-specific
PM data (although the question is which struct dev_pm_info to use in that
case, the sdev's one, or the sdev->gendev's one?).

Thanks,
Rafael
