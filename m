From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] SCSI Hotplug for lk 2.5
Date: Tue, 6 Aug 2002 15:43:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020806154309.A13999@eng2.beaverton.ibm.com>
References: <A5974D8E5F98D511BB910002A50A664702CD66B7@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <A5974D8E5F98D511BB910002A50A664702CD66B7@hdsmsx103.hd.intel.com>; from andrew.r.cress@intel.com on Mon, Aug 05, 2002 at 08:09:34AM -0700
List-Id: linux-scsi@vger.kernel.org
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

Andy -

On Mon, Aug 05, 2002 at 08:09:34AM -0700, Cress, Andrew R wrote:
> Doug/Patrick,
> 
> I've been working on a scan daemon in user-space for hot-plug disks (case 3
> below).  It uses sg to access scsi devices, and also to access access any
> SAF-TE HSCs.  It then invokes sfdisk, mdadm, etc. to auto-remove or
> auto-insert the disk in a software raid like a hardware raid would.  It
> works nicely if the device nodes already exist (replace a disk), but has
> enumeration problems for new devices.  I'm currently using kernel 2.4.18,
> but I'm interested in the discussion on this topic for 2.5.

I'm not very familiar with SAF-TE or the software raid tools.

Your program polls a special interface to the SAF-TE to figure out
what LUNs (or targets) are attached, and if a new LUN or target shows
up, you scan it? Does mdadm do the scan for you? 

Does it always generate a bus reset when a device is added or removed?

> I'm thinking that the kernel changes that would help would be to do a
> rescan_scsis function, slightly different than scan_scsis, so that existing
> devices are left alone, but new devices are initialized and attached to
> device nodes.  This rescan_scsis could be triggered by a scsi reset (and
> maybe by a user directive, which might be needed if the user-space daemon
> detected a SAF-TE insertion, for example).  
> 
> What do you think?  Should this kind of thing be done with driverfs rather
> than an sg device node?  

I don't have any specific answers.

There should probably be a hotplug event (via driverfs) for a new target
showing up - not part of the mid-layer or scanning, something the low
level driver might trigger (and not one of the 5 events Douglas listed,
unless his item 3 target/lun means target *or* lun on a target). 

Triggering off of a scsi reset would not be good, since the error handler
can send a reset, and not all SPI busses (enclosures) will generate a bus
reset on device addition or removal. Triggering a rescan via a daemon (like
your SAF-TE) would be ok, especially a rescan of a single LUN.

Generally, an entire rescan would be too much when we want to only scan
a target (or maybe even a single LUN). We also want an un-scan
or something to remove a target (and all of its LUNs), like the 
scsi proc remove-single-device (plus a way to remove a single Scsi_Host,
a problem with pci hotplug removing an adapter).

For FCP, adding a new target will generate an SCN (or a LIP), and there
could then be a hotplug event (via driverfs) for the new target (or the
removed target); removal generates an SCN (but not always a LIP).

For iSCSI there could be user level commands to add or remove connections,
generating a hotplug event (via driverfs), I don't know much about iSCSI.

When a new LUN is made available on a target, you could get a unit
attention (SPC spec shows a ASC/ASCQ 3F/0E REPORTED LUNS DATA HAS CHANGED),
but this would come back to every initiator on that target for every
LUN (not sure if it is really for every LUN, that could be specific to the
hardware). If it's every LUN, it might be execessive or difficult to
figure out if a rescan of the target is needed (imagine 100 LUNs on one
target, some of them seldom used, and getting a hotplug event flood).
Letting an admin manually rescan might be safer in such cases.

The current proc interface is good enough for selective scanning of
a specific LUN; it is not SMP safe right now - if the error handler
is running, or someone else is trying to access the host_queue list
without the BKL (outside of the proc interface) it is not SMP safe.
A Scsi_Device list lock is needed to protect removal/insertion of
a Scsi_Device.

-- Patrick Mansfield

> > Here are five categories of SCSI events that are candidates for
> > hotplug alerts:
> > 	1) scsi (lower level) driver addition or removal
> > 	2) scsi host (initiator) addition or removal
> > 	3) scsi device (target/lun) addition or removal
> > 	4) removable media addition or removal
> > 	5) unit attention or "asynchronous event notification"
> > I believe hotplug alerts for 2) and 3) are required; for 1)
> > is questionable and for 4) + 5) would be "nice to have".
