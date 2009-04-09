From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/1] cciss: resubmit export uid, model, vendor, rev to
	sysfs
Date: Thu, 9 Apr 2009 11:12:09 -0700
Message-ID: <ac3eb2510904091112p4d4cc491o703ead8b93d0b45f@mail.gmail.com>
References: <20090407180411.GA4324@beardog.cca.cpqcorp.net>
	<20090408061901.GN5178@kernel.dk> <ac3eb2510904080526h36673aa7qb5d530df33a60104@mail.gmail.com>
	<1239258160.19984.217.camel@grinch> <ac3eb2510904090719n730dededp54b25390a9087a79@mail.gmail.com>
	<1239296221.19984.218.camel@grinch> <ac3eb2510904091005q13e5b5a1j3907de22ad3df70c@mail.gmail.com>
	<1239300433.19984.270.camel@grinch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:34123 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbZDISMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2009 14:12:25 -0400
In-Reply-To: <1239300433.19984.270.camel@grinch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: ens Axboe <jens.axboe@oracle.com>, "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, LKML-SCSI <linux-scsi@vger.kernel.org>

On Thu, Apr 9, 2009 at 11:07, Andrew Patterson <andrew.patterson@hp.com=
> wrote:
> On Thu, 2009-04-09 at 10:05 -0700, Kay Sievers wrote:

>> The block device needs a parent, please assign the cciss bus device.
>> It's the driverfs_dev in the genhd struct.
>>
>
> This is already done in cciss_add_disk():
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0disk->fops =3D &cciss_fops;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0disk->private_data =3D &h->drv[drv_index];
> =C2=A0 =C2=A0 =C2=A0 =C2=A0disk->driverfs_dev =3D &h->drv[drv_index].=
dev;
>
> I think my problem is I was assigning cciss_bus_type to the controlle=
r,
> not the block device. I have fixed that.

> # /sbin/udevadm info --attribute-walk "--path=3D/block/cciss!c0d0"

> =C2=A0looking at parent device
> '/devices/pci0000:4f/0000:4f:00.0/0000:50:00.0/0000:51:04.0/0000:8b:0=
0.0/cciss0':
> =C2=A0 =C2=A0KERNELS=3D=3D"cciss0"
> =C2=A0 =C2=A0SUBSYSTEMS=3D=3D""

This device also needs the cciss bus_type assigned, so the subsystem
becomes cciss, and it also shows up in /sys/bus/cciss/devices/.

Other than that, the sysfs hierarchy looks fine.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
