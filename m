From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: [RFC] SCSI Hotplug for lk 2.5
Date: Wed, 7 Aug 2002 08:56:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A664702CD66C5@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from petasus.jf.intel.com (petasus.jf.intel.com [10.7.209.6])
	by caduceus.jf.intel.com (8.11.6/8.11.6/d: outer.mc,v 1.48 2002/05/24 00:39:04 root Exp $) with ESMTP id g77FsIb28339
	for <linux-scsi@vger.kernel.org>; Wed, 7 Aug 2002 15:54:18 GMT
Received: from orsmsxvs040.jf.intel.com (orsmsxvs040.jf.intel.com [192.168.65.206])
	by petasus.jf.intel.com (8.11.6/8.11.6/d: inner.mc,v 1.22 2002/05/24 00:38:22 root Exp $) with SMTP id g77FrcW23516
	for <linux-scsi@vger.kernel.org>; Wed, 7 Aug 2002 15:53:38 GMT
List-Id: linux-scsi@vger.kernel.org
To: 'Patrick Mansfield' <patmans@us.ibm.com>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org


The SCSI SAF-TE interface to hot-swap controllers reports the number of
insertion events by slot number.  If there is a SAF-TE HSC, detecting the
insertion is easy, but if not, the user-space daemon has to have help to
notice that the insertion has happened.  

The two types of disk enclosures I have do generate resets when a new disk
is inserted, but I believe that there are disk units/enclosures that just
bring the disk online.  Perhaps even these have Unit Attention, or Start
Unit, or something to detect.  

TODO:
- Detect the disk insertion, which I think has to be done in kernel space.
  If there is HSC:  Use SAF-TE (or SES) to detect the insertion.
  If there is no HSC:
  Reset is one entry point to trigger looking for new SCSI disks, but we  
  probably need to trigger it at Unit Attention too as you suggest.
  Since the idea is to make this automatic, rather than require user 
  intervention, we don't know which target and/or lun to look for, so I
  think we still have to scan at the whole channel with Inquiry commands 
  (like scan_scsis does).  
- Create and attach a device node for the new disk.
  This logic would be similar to what scan_scsis does, but would be more
  surgical if the HSC is present.

Andy

-----Original Message-----
From: Patrick Mansfield [mailto:patmans@us.ibm.com] 
Sent: Tuesday, August 06, 2002 6:43 PM
Subject: Re: [RFC] SCSI Hotplug for lk 2.5

[...]
Your program polls a special interface to the SAF-TE to figure out
what LUNs (or targets) are attached, and if a new LUN or target shows
up, you scan it? Does mdadm do the scan for you? 

Does it always generate a bus reset when a device is added or removed?

> [...]  This rescan_scsis could be triggered by a scsi reset (and
> maybe by a user directive, which might be needed if the user-space daemon
> detected a SAF-TE insertion, for example).  
[...]

Triggering off of a scsi reset would not be good, since the error handler
can send a reset, and not all SPI busses (enclosures) will generate a bus
reset on device addition or removal. Triggering a rescan via a daemon (like
your SAF-TE) would be ok, especially a rescan of a single LUN.

[...]
When a new LUN is made available on a target, you could get a unit
attention (SPC spec shows a ASC/ASCQ 3F/0E REPORTED LUNS DATA HAS CHANGED),
but this would come back to every initiator on that target for every
LUN (not sure if it is really for every LUN, that could be specific to the
hardware). If it's every LUN, it might be execessive or difficult to
figure out if a rescan of the target is needed (imagine 100 LUNs on one
target, some of them seldom used, and getting a hotplug event flood).
Letting an admin manually rescan might be safer in such cases.

[...]
