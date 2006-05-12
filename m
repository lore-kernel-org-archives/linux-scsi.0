From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] printks in print_inquiry
Date: Fri, 12 May 2006 10:08:54 -0700
Message-ID: <20060512170854.GA11215@us.ibm.com>
References: <20060511150015.GJ12272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:26016 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750818AbWELRJA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 13:09:00 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4CH8w9a009458
	for <linux-scsi@vger.kernel.org>; Fri, 12 May 2006 13:08:58 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4CH8wxo253726
	for <linux-scsi@vger.kernel.org>; Fri, 12 May 2006 13:08:58 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k4CH8w7a020062
	for <linux-scsi@vger.kernel.org>; Fri, 12 May 2006 13:08:58 -0400
Content-Disposition: inline
In-Reply-To: <20060511150015.GJ12272@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Thu, May 11, 2006 at 09:00:15AM -0600, Matthew Wilcox wrote:
> 
> One of the side-effects of my previous patch to parallelise scsi
> scanning is that it causes print_inquiry to run when there's already a
> lot of other printk traffic.  Due to the way it works, it's very easy
> for print_inquiry to be in the middle of printing something when
> something else chooses to emit a printk.  This could of course happen
> without the async scsi scanning patch, it's just a lot more frequent
> with it.
> 
> This is one way of solving the problem -- accumulate each line into a
> buffer, then display each line in one shot.  However, the comment above

Terser one line output would be nice (even for a few devices), with "scsi"
and bus_id. We don't need "Type", like:

SCSI 2:0:0:0: Vendor: FOO      Model: BAR              Rev: 0.2 ANSI rev: 04

And maybe use printk("%-16s") formatting? But garbage might get printed
for non-ASCII (though the SCSI specs say it is not allowed ...).

> the function says we should be packaging all this up into a hotplug
> event.  Is that still true?  If so, I can do that, and we can forget
> about this patch.

There is already a hotplug event. 

But the timing and output of it won't match well with the other SCSI (sd)
messages, they'll likely be output before hotplug handling for the event.

And then if relying on udev for the output: it replays hotplug events when
it starts up, so (AFAICT) you'd get a flurry of output after all the other
scsi kernel messages for no udev in initrd and for monolithic kernels
(well any time udev is started after scsi discovery).

But try a udev rule like:

ACTION=="add", SUBSYSTEM=="scsi_device" RUN+="/sbin/scsi_notify"

And then /sbin/scsi_notify bash script like:

#! /bin/bash
sys=/sys
sdev=${sys}${PHYSDEVPATH}
bus_id=${sdev##*/}
logger -t scsi "$(printf "%s: Vendor: %-8s Model: %-16s\n" ${bus_id} \
        $(cat ${sdev}/vendor) $(cat ${sdev}/model))"

-- Patrick Mansfield
