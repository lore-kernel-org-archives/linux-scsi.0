From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_scan.c EVPD code
Date: Mon, 5 May 2003 21:11:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505211158.A14613@beaverton.ibm.com>
References: <UTC200304250047.h3P0lhl03517.aeb@smtp.cwi.nl> <3EB619A4.5090407@torque.net> <20030505093834.B7831@beaverton.ibm.com> <20030505174602.GA3433@beaverton.ibm.com> <20030505155127.A11734@beaverton.ibm.com> <3EB7124C.9010701@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:17649 "EHLO
	laptop") by vger.kernel.org with ESMTP id S262322AbTEFEFT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2003 00:05:19 -0400
Content-Disposition: inline
In-Reply-To: <3EB7124C.9010701@torque.net>; from dougg@torque.net on Tue, May 06, 2003 at 11:39:24AM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, May 06, 2003 at 11:39:24AM +1000, Douglas Gilbert wrote:
> Patrick Mansfield wrote:

> > Yes, it looks very close, and has the underlying infrastructure (uses the
> > SCSI_IOCTL_SEND_COMMAND, not sg, so can be used for all upper level linux
> > scsi devices). It looks like we would need functionallity that is in the
> > devlabel script itself (to output just a  single ID), maybe just integrate
> > that into scsi_unique_id. (I did not look closely at devlabel, it has more
> > lines than the scsi_unique_id.c source.)
> 
> Patrick,
> Even if you don't use sg you still have to use
> the appropriate upper level driver and cope with its
> vagaries (e.g. does it need O_NONBLOCK, could it
> lock you out with O_EXCL). Also you need a device
> file node to open: it may not be there (devfs helps
> here) or could have some tricky symlink.

OK, I suppose those can be worked out one way or another.

The hotplug/sysfs should also give us a kdev that we can use for a
(temporary) mknod - one we can use to get an id (at least for upper level
devices, but I don't see why we would want to get an id for anything else
- if we have no upper level device, we have no user access to the
  scsi_device).

> IMO a safe way to work for disks in lk 2.5 would be to
> scan /sys/block, apply some heuristic to filter out
> degenerate devices, make your own device node (i.e. mknod)
> open it and use the SG_IO ioctl on that fd, etc.
> This method needs root privelege.

I thought Greg's udev approach was going to be for all hotplug, no cold
plug.

> Another approach could be to have a device node for
> the scsi mid level (e.g. /dev/scsi) with an ioctl
> that takes a device's toplogical address and some
> parameters (e.g. VPD_83) and yields the response
> of that INQUIRY (or yields an scsi status and a
> sense buffer).

Can something like that be done for a /dev/sg today? It would be very
useful, not only for VPD/id like commands, but also for user level
scanning.

That is open some /dev/sg via an ioctl (or ?) attach it to a nexus. If
there is an existing scsi_device with a matching nexus, it can attach to
it, else create an sdev via scsi_alloc_sdev, attach to it and go.

Then we can send whatever commands we want via current sg interfaces.

-- Patrick Mansfield
