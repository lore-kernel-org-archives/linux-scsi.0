From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: [RFC] SCSI Hotplug for lk 2.5
Date: Mon, 5 Aug 2002 08:09:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A664702CD66B7@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmsmsxvs041.fm.intel.com (fmsmsxvs041.fm.intel.com [132.233.42.126])
	by mail2.hd.intel.com (8.11.6/8.11.6/d: solo.mc,v 1.42 2002/05/23 22:21:11 root Exp $) with SMTP id g75F9Ps07312
	for <linux-scsi@vger.kernel.org>; Mon, 5 Aug 2002 15:09:25 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'Patrick Mansfield' <patmans@us.ibm.com>, Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

Doug/Patrick,

I've been working on a scan daemon in user-space for hot-plug disks (case 3
below).  It uses sg to access scsi devices, and also to access access any
SAF-TE HSCs.  It then invokes sfdisk, mdadm, etc. to auto-remove or
auto-insert the disk in a software raid like a hardware raid would.  It
works nicely if the device nodes already exist (replace a disk), but has
enumeration problems for new devices.  I'm currently using kernel 2.4.18,
but I'm interested in the discussion on this topic for 2.5.

I'm thinking that the kernel changes that would help would be to do a
rescan_scsis function, slightly different than scan_scsis, so that existing
devices are left alone, but new devices are initialized and attached to
device nodes.  This rescan_scsis could be triggered by a scsi reset (and
maybe by a user directive, which might be needed if the user-space daemon
detected a SAF-TE insertion, for example).  

What do you think?  Should this kind of thing be done with driverfs rather
than an sg device node?  

If you are interested, the source to what I'm working on is at
http://cvs.carrierlinux.org/viewcvs/viewcvs.cgi/components/scsirastools/src/
sgraidmon.c

Andy Cress

-----Original Message-----
From: Patrick Mansfield [mailto:patmans@us.ibm.com] 
Sent: Friday, August 02, 2002 9:28 PM
To: Douglas Gilbert
Cc: linux-scsi@vger.kernel.org
Subject: Re: [RFC] SCSI Hotplug for lk 2.5

On Thu, Aug 01, 2002 at 06:57:31PM -0400, Douglas Gilbert wrote:
>                  SCSI Hotplug for lk 2.5

Douglas -

I'm still trying to figure out what events we might need for user versus
kernel scanning or some combination. I'm re-reading James original OLS
paper about user scanning, and I've been thinking about how to scan from
user level. It might be best to do work on user level scanning after we
have better driverfs support, and always have initrd. 

I've been trying to re-code scsi_scan.c with user level scanning in mind
(not such a big deal, since we already have proc scanning), especially
so that we can scan a single target, rather than a single LUN via the
proc interface. We probably need a target hotplug event, this would be best
handled by adding a device_register() for each target; this is not so easy
for multi-path, since target id's can be different for the same target 
(even if the linux scsi id was the FC ID), so it would be easier to just
generate a hotplug event that could kick off scanning.

I haven't done anything with the device_list[] (in terms of hotplug or
moving it to user space).

> Here are five categories of SCSI events that are candidates for
> hotplug alerts:
> 	1) scsi (lower level) driver addition or removal
> 	2) scsi host (initiator) addition or removal
> 	3) scsi device (target/lun) addition or removal
> 	4) removable media addition or removal
> 	5) unit attention or "asynchronous event notification"
> I believe hotplug alerts for 2) and 3) are required; for 1)
> is questionable and for 4) + 5) would be "nice to have".

My understanding is that driverfs will automatically generate hotplug
events on each device_register() call. These have been added to scsi,
so the two main events are already handled, and we need not make other
changes.

Multi-path will also hook into driverfs, and driverfs would then
generate hotplug events for them.

-- Patrick Mansfield
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
