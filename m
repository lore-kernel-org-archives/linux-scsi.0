From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] scsi_device printk helper macro - sdev_printk -> with patch
Date: Tue, 30 Sep 2003 22:16:12 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F79740C.5020007@torque.net>
References: <200309291413.51987.dsteklof@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.triode.net.au ([202.147.124.1]:31950 "EHLO
	iggy.triode.net.au") by vger.kernel.org with ESMTP id S261406AbTI3M2K
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2003 08:28:10 -0400
In-Reply-To: <200309291413.51987.dsteklof@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Daniel Stekloff <dsteklof@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Larry Kessler <lkessler@us.ibm.com>, James Keniston <kenistoj@us.ibm.com>

Daniel Stekloff wrote:
> The purpose of the sdev_printk macro, which is intended for the scsi mid-layer 
> and LLDs, is to help with the following:
> 
> - Adding consistency to printk messages in mid-layer and LLDs where 
> scsi_device is concerned. Scsi_device information will be printed in the same 
> consistent format. A consistent format will help readability and provide a 
> means to automate responding to log messages.
> 
> - Identifing a printk with a specific scsi_device. 
> 
> - Providing one point for changing what identification information is printed. 
> Instead of having to edit every single printk, one could simply change the 
> macro. 
> 
> The patch below does a couple things:
> 
> 1) Moves setting scsi_device's sdev_gendev struct device bus_id from 
> scsi_sysfs.c to scsi_scan.c.
> 
> 2) Adds sdev_printk definition to scsi_device.h
> 
> 3) Replaces many printks in the mid-layer with sdev_printk.
> 
> Please take a look, all comments and suggestions are welcome.

Dan,
Looks great.
We have a fair amount of scsi command and sense decode logic **
laying idle in drivers/scsi/constants.[hc] that might enhance
the output further.

Perhaps while we are at it, we could make a more useful logging
mechanism in the scsi subsystem (rather than, or in addition to,
'echo "scsi log ..." > /proc/scsi/scsi'). Putting a
read/write "log" variable in the /sys/class/scsi_device/*/device
directory would allow per device logging. [Obviously struct
scsi_device would get a new "log" member, initialized to 0.]

This does not cover the debugging or logging of a device
scan. In this case scsi_device::log could be inherited from
somewhere. Since the device might be the first one seen by the
first host, that "somewhere" would need to be be the scsi mid
level. Currently the scsi mid level doesn't have a sysfs
presence. It is obviously a module and also has a pseudo
device at /proc/scsi/scsi. Any suggestions where a scsi
mid level device/driver directory could go in sysfs? Such
a directory could contain scan, timeout and retry parameters
as well as a "next_device_log" type entry.


** Sense buffer decoding should be centralized, especially
since SPC3 has a new (more sane) "descriptor sense data
format" [SPC-3 rev 15 section 4.5.2 at www.t10.org].

Doug Gilbert






