From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/1] cciss: resubmit export uid, model, vendor, rev to
	sysfs
Date: Wed, 8 Apr 2009 05:26:59 -0700
Message-ID: <ac3eb2510904080526h36673aa7qb5d530df33a60104@mail.gmail.com>
References: <20090407180411.GA4324@beardog.cca.cpqcorp.net>
	<20090408061901.GN5178@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:45215 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbZDHM1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2009 08:27:17 -0400
In-Reply-To: <20090408061901.GN5178@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, LKML-SCSI <linux-scsi@vger.kernel.org>, andrew.patterson@hp.com, mike.miller@hp.com

On Tue, Apr 7, 2009 at 23:19, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Apr 07 2009, Mike Miller (OS Dev) wrote:

> The patch looks fine to me, but my sysfs foo is very weak though. CC'=
ing
> Kay, perhaps he can help take a quick look at this.

>> + * Initialize sysfs for each logical drive. =C2=A0This sets up and =
registers
>> + * the 'c#d#' directory for each individual logical drive under
>> + * /sys/bus/pci/devices/<dev/ccis#/. We also create a link from
>> + * /sys/block/cciss!c#d# to this entry.
>> + */
>> +static int cciss_create_ld_sysfs_entry(struct ctlr_info *h,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0drive_info_s=
truct *drv,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int drv_inde=
x)
>> +{
>> + =C2=A0 =C2=A0 device_initialize(&drv->dev);
>> + =C2=A0 =C2=A0 drv->dev.type =3D &cciss_dev_type;
>> + =C2=A0 =C2=A0 dev_set_name(&drv->dev, "c%dd%d", h->ctlr, drv_index=
);
>> + =C2=A0 =C2=A0 drv->dev.parent =3D &h->dev;
>> + =C2=A0 =C2=A0 return device_add(&drv->dev);
>> +}

If I read that correctly, you are creating a hierarchy of devices
where the devices do not belong to any subsystem? This is what we need
to avoid in almost all cases, we need a "subsystem" link in sysfs.

I wold expect the cciss devices not to be a magic, silently created,
subdirectory of a pci device, but to have their own "cciss" bus in
sysfs, so the created devices get proper events at creation time. All
the cciss devices would show up in its own directory
/sys/bus/cciss/devices/*.

I think, you should name all "cciss bus devices" uniquely, and assign
them to a "cciss bus_type". We really do not want unclassified devices
in the chain of parent devices of a block device.

Or do I missing something here?

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
