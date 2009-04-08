From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH 1/1] cciss: resubmit export uid, model, vendor, rev to
 sysfs
Date: Wed, 08 Apr 2009 16:24:13 +0000
Message-ID: <1239207853.19984.207.camel@grinch>
References: <20090407180411.GA4324@beardog.cca.cpqcorp.net>
	 <20090408061901.GN5178@kernel.dk>
	 <ac3eb2510904080526h36673aa7qb5d530df33a60104@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:43313 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbZDHQYT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2009 12:24:19 -0400
In-Reply-To: <ac3eb2510904080526h36673aa7qb5d530df33a60104@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, LKML-SCSI <linux-scsi@vger.kernel.org>, mike.miller@hp.com

On Wed, 2009-04-08 at 05:26 -0700, Kay Sievers wrote:
> On Tue, Apr 7, 2009 at 23:19, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Tue, Apr 07 2009, Mike Miller (OS Dev) wrote:
> 
> > The patch looks fine to me, but my sysfs foo is very weak though. CC'ing
> > Kay, perhaps he can help take a quick look at this.
> 
> >> + * Initialize sysfs for each logical drive.  This sets up and registers
> >> + * the 'c#d#' directory for each individual logical drive under
> >> + * /sys/bus/pci/devices/<dev/ccis#/. We also create a link from
> >> + * /sys/block/cciss!c#d# to this entry.
> >> + */
> >> +static int cciss_create_ld_sysfs_entry(struct ctlr_info *h,
> >> +                                    drive_info_struct *drv,
> >> +                                    int drv_index)
> >> +{
> >> +     device_initialize(&drv->dev);
> >> +     drv->dev.type = &cciss_dev_type;
> >> +     dev_set_name(&drv->dev, "c%dd%d", h->ctlr, drv_index);
> >> +     drv->dev.parent = &h->dev;
> >> +     return device_add(&drv->dev);
> >> +}
> 
> If I read that correctly, you are creating a hierarchy of devices
> where the devices do not belong to any subsystem? This is what we need
> to avoid in almost all cases, we need a "subsystem" link in sysfs.
> 

Yes, but apparently mistakenly.

> I wold expect the cciss devices not to be a magic, silently created,
> subdirectory of a pci device, but to have their own "cciss" bus in
> sysfs, so the created devices get proper events at creation time. All
> the cciss devices would show up in its own directory
> /sys/bus/cciss/devices/*.
> 
> I think, you should name all "cciss bus devices" uniquely, and assign
> them to a "cciss bus_type". We really do not want unclassified devices
> in the chain of parent devices of a block device.
> 

I'll try this.  Although I am wondering whether to put hosts or logical
drives in /sys/bus/cciss/devices (or both). Can I do what I am doing
now, just moving it to /sys/bus/cciss/devices? That
is, /sys/bus/cciss/devices/ccissX/cYdZ.

Andrew

> Or do I missing something here?
> 
> Kay


