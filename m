From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: Tue, 06 May 2003 11:39:24 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB7124C.9010701@torque.net>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl> <3EB619A4.5090407@torque.net> <20030505093834.B7831@beaverton.ibm.com> <20030505174602.GA3433@beaverton.ibm.com> <20030505155127.A11734@beaverton.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:22798 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262239AbTEFBYR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 21:24:17 -0400
In-Reply-To: <20030505155127.A11734@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Mon, May 05, 2003 at 10:46:02AM -0700, Mike Anderson wrote:
> 
>>Patrick Mansfield [patmans@us.ibm.com] wrote:
> 
> 
>>>Right now, we could have an sgid that runs whenever an sg is found (sg
>>>hotplug generated via device_register), and stores a sysfs path and the id
>>>returned into a flat file.
>>
>>I believe devlabel's scsi_unique_id.c file does some of this, though I
>>have not looked at it closely.
>>
>>-andmike
> 
> 
> Yes, it looks very close, and has the underlying infrastructure (uses the
> SCSI_IOCTL_SEND_COMMAND, not sg, so can be used for all upper level linux
> scsi devices). It looks like we would need functionallity that is in the
> devlabel script itself (to output just a  single ID), maybe just integrate
> that into scsi_unique_id. (I did not look closely at devlabel, it has more
> lines than the scsi_unique_id.c source.)

Patrick,
Even if you don't use sg you still have to use
the appropriate upper level driver and cope with its
vagaries (e.g. does it need O_NONBLOCK, could it
lock you out with O_EXCL). Also you need a device
file node to open: it may not be there (devfs helps
here) or could have some tricky symlink.

IMO a safe way to work for disks in lk 2.5 would be to
scan /sys/block, apply some heuristic to filter out
degenerate devices, make your own device node (i.e. mknod)
open it and use the SG_IO ioctl on that fd, etc.
This method needs root privelege.

> It looks like scsi_unique_id should also dump the code set, so it can pick
> one code set (the same one) over anoother (if both were ever used by a
> single LU).
> 
> It fails for character devices, but that is easily fixed by deletion of
> the check (SCSI_IOCTL_SEND_COMMAND works for any scsi device: st, sd, sr
> or sg). I deleted the check and it ran ok on a "processor" scsi device,
> though the device does not support page 80 or page 83. 
> 
> scsi_unique_id should also have some sort of error checking/reporting, so
> we can tell if a device is not functioning (versus does not support page
> 80 or 83).
> 
> I don't know how this would be integrated into the scsi device model tree,
> given the current flux (class or bus for upper level devices, as well as
> for the scsi_device itself).

Another approach could be to have a device node for
the scsi mid level (e.g. /dev/scsi) with an ioctl
that takes a device's toplogical address and some
parameters (e.g. VPD_83) and yields the response
of that INQUIRY (or yields an scsi status and a
sense buffer).

Doug Gilbert


