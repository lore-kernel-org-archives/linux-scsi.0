From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] SCSI Hotplug for lk 2.5
Date: Fri, 2 Aug 2002 18:27:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020802182753.A18281@eng2.beaverton.ibm.com>
References: <3D49BCDB.392ACAA4@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D49BCDB.392ACAA4@torque.net>; from dougg@torque.net on Thu, Aug 01, 2002 at 06:57:31PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

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
