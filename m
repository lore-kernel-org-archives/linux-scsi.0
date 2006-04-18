From: James Smart <James.Smart@Emulex.Com>
Subject: Re: lpfc target renumbering problem
Date: Tue, 18 Apr 2006 12:41:10 -0400
Message-ID: <444516A6.6020400@emulex.com>
References: <4441A693.7060004@ludd.luth.se>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:30902 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751068AbWDRQlZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 12:41:25 -0400
In-Reply-To: <4441A693.7060004@ludd.luth.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Roger_H=E5kansson?= <hson@ludd.luth.se>
Cc: linux-scsi@vger.kernel.org

Roger,

First off, the lastest driver for that release is 8.0.16.26 and can be
downloaded from our sourceforge site:
http://sourceforge.net/project/showfiles.php?group_id=103050&package_id=141007
Based on the kernel revision, I am assuming this is a RHEL4-derived
kernel, so be sure to compile with "make OS=RHEL".

> The Infortrend box have four SFP-ports which is connected to two
> redundant controllers which each have two "channels".
> In the Infortrend-box you can configure logical drives (and optionally
> logical volumes) which then can be mapped to LUNs on each channel.
> Each logical drive can only be assigned to one controller, but in case
> of a controller failure, the other controller will take over the logical
> drives from the failed controller.
> A LUN mapped to a logical drive will have the same WWNN on both
> channels, but different WWPN.

Please note - you should not be tracking luns by WWNN and WWPN. These are
target port identifiers, and not lun identifiers. The lun should be
tracked via a SCSI-level Inquiry VPD page 0x83 or page 0x80. The community
position is to use udev (and device-mapper on udev) in conjunction with
scsi_id, etc to identify devices independent of their physical pathing.

If the target has a different WWNN/WWPN pair, then it is indeed a different
target and the luns should be seen at a different target id. From a pure
scsi perspective, there is no guarantee nor relationship that says the
scsi device at 1:0:0:0 should be the same scsi device as 1:0:1:0. It's up
to tools that look at SCSI WWN's and/or Serial numbers that provide this
correlation.

> Now to my problem:
> I was hoping to be able to set up a fault tolerant solution using
> multipathing so that if a controller, fabric, fiber-cable or HBA fails,
> a filesystem is still accessible on the hosts using device-mapper-multipath.
> This works ok if a fabric, fibre-cable or HBA fails, but when a
> controller fails all paths become "stale".
> This seems to be due to the fact that the lpfc-driver maps the LUNs to
> different target numbers after a controller failure, but only if the
> disks are "active" (i.e mounted)

Note: The lpfc driver doesn't map luns. We only track targets, which are
uniquely identified via the WWNN/WWPN pair. Luns are things that just happen
to be discovered (by the scsi midlayer) as it scans each target.

The only thing we, the lpfc driver, can screw up is the target mapping. As
long as the WWNN/WWPN stays the same, the target mapping should stay the same.

The other thing that is important is that you have the proper hardware
handlers and tools within device-mapper to properly manage a Infortrend
array.

> If I do 'cat /proc/scsi/lpfc/*' when everything is ok, it looks like this:
> lpfc0t00 DID 010025 WWPN 21:00:00:d0:23:0b:01:91 WWNN
> 20:00:00:d0:23:0b:01:91
> lpfc1t00 DID 020025 WWPN 22:00:00:d0:23:0b:01:91 WWNN
> 20:00:00:d0:23:0b:01:91
> At the same time, the output from 'multipath -ll' is:
> mpath1 (3600d0230000000000b01910b4d313400)
> [size=97 GB][features=0][hwhandler=0]
> \_ round-robin 0 [prio=0][active]
>  \_ 1:0:0:0 sde 8:16  [active][ready]
>  \_ 2:0:0:0 sdf 8:32  [active][ready]
> 
> 
> If I manually fail the controller, while having the filesystem mounted
> the output from 'cat /proc/scsi/lpfc/*' looks like this:
> lpfc0t01 DID 010025 WWPN 21:00:00:d0:23:0b:01:91 WWNN
> 20:00:00:d0:23:0b:01:91
> lpfc1t01 DID 020025 WWPN 22:00:00:d0:23:0b:01:91 WWNN
> 20:00:00:d0:23:0b:01:91
> Due to this both paths fails and the filsystem is inaccessible

So this is confusing...
Please double-check these values. They are the same WWPN/WWNN's as above.
You implied above, if the LUN becomes active on another controller or
channel, the WWPN would minimally change. That didn't occur here.
Also, assuming the failed-over connection is now via a different switch
port, it would be very odd to see the same device show up with the same
DID address as before. Please check that this is not a cut and paste
error.

If the WWPN/WWNN values are indeed the same, then we have to assume a
driver error, and I recommend testing the 8.0.16.26 driver.

> I've tried:
> echo 1 >/sys/class/scsi_device/1:0:0:0/device/delete
> echo 1 >/sys/class/scsi_device/2:0:0:0/device/delete
> echo "- - -" > /sys/class/scsi_host/host1/scan
> echo "- - -" > /sys/class/scsi_host/host2/scan
> 
> But this will render me new sdb/sdc at 1:0:1:0/2:0:1:0 which isn't what
> I need.

Ok. but the system behavior is consistent with what it should be.

> When I "fix" the failed controller, and the diskarray returns to
> two-controller-mode, 'cat /proc/scsi/lpfc/*' looks like this again:
> lpfc0t00 DID 010025 WWPN 21:00:00:d0:23:0b:01:91 WWNN
> 20:00:00:d0:23:0b:01:91
> lpfc1t00 DID 020025 WWPN 22:00:00:d0:23:0b:01:91 WWNN
> 20:00:00:d0:23:0b:01:91
> 
> If I don't have the filsystem mounted (and not mapped via dm-multipath
> either), but accessible as sdb/sdc, and then manually fail the
> controller, the targetnumber isn't renumbered.

Ok - this is very odd. The driver is the one managing the target id
assignments, and it doesn't know whether a filesystem is active or not,
so it shouldn't matter.

 >> Now my question:
 >> Is there anything I can do to "fix" this, or do I have to "accept" that
 >> this hardware/software-combination can't do what I want?
 >>
 >
 > I've found a "solution" which seems to work, but I'm not sure how to
 > implement it.
 > If I, before device-mapper-multipath determines the devices to be
 > "dead", do "echo 1 > /sys/class/scsi_device/1:0:0:0/device/rescan", both
 > sdb (which 1:0:0:0 was mapped to at the time of my test) and(!, even
 > though its on another HBA) sdc (2:0:0:0) doesn't get marked as dead.
 > But how do this in a more automatic fashion?
 > I could set up a script which polls /var/log/messages, or write a
 > program which opens a pipe and let syslogd write to that pipe, and parse
 > the log in order to watch for SCSI-errors, but none of this seems like
 > the right way to do it.
 > Anyone got a better solution?

I don't have any good answers, and recommend that you first follow the
recommendations above. After that, we can take this off-list and do more
detailed logging to see what's going on.

If it is a cut-n-paste error above, then I believe that if you convert to
using dm based on udev names, then you will likely get the success you
desire.

-- james s

