From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/1] cciss: resubmit export uid, model, vendor, rev to
	sysfs
Date: Wed, 8 Apr 2009 09:34:37 -0700
Message-ID: <ac3eb2510904080934o46a5375qf70ee77ec3ab7171@mail.gmail.com>
References: <20090407180411.GA4324@beardog.cca.cpqcorp.net>
	<20090408061901.GN5178@kernel.dk> <ac3eb2510904080526h36673aa7qb5d530df33a60104@mail.gmail.com>
	<1239207853.19984.207.camel@grinch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:17089 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZDHQey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2009 12:34:54 -0400
In-Reply-To: <1239207853.19984.207.camel@grinch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, LKML-SCSI <linux-scsi@vger.kernel.org>, mike.miller@hp.com

On Wed, Apr 8, 2009 at 09:24, Andrew Patterson <andrew.patterson@hp.com=
> wrote:
> On Wed, 2009-04-08 at 05:26 -0700, Kay Sievers wrote:
>> On Tue, Apr 7, 2009 at 23:19, Jens Axboe <jens.axboe@oracle.com> wro=
te:
>> > On Tue, Apr 07 2009, Mike Miller (OS Dev) wrote:
>>
>> > The patch looks fine to me, but my sysfs foo is very weak though. =
CC'ing
>> > Kay, perhaps he can help take a quick look at this.
>>
>> >> + * Initialize sysfs for each logical drive. =C2=A0This sets up a=
nd registers
>> >> + * the 'c#d#' directory for each individual logical drive under
>> >> + * /sys/bus/pci/devices/<dev/ccis#/. We also create a link from
>> >> + * /sys/block/cciss!c#d# to this entry.
>> >> + */
>> >> +static int cciss_create_ld_sysfs_entry(struct ctlr_info *h,
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0drive_inf=
o_struct *drv,
>> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int drv_i=
ndex)
>> >> +{
>> >> + =C2=A0 =C2=A0 device_initialize(&drv->dev);
>> >> + =C2=A0 =C2=A0 drv->dev.type =3D &cciss_dev_type;
>> >> + =C2=A0 =C2=A0 dev_set_name(&drv->dev, "c%dd%d", h->ctlr, drv_in=
dex);
>> >> + =C2=A0 =C2=A0 drv->dev.parent =3D &h->dev;
>> >> + =C2=A0 =C2=A0 return device_add(&drv->dev);
>> >> +}
>>
>> If I read that correctly, you are creating a hierarchy of devices
>> where the devices do not belong to any subsystem? This is what we ne=
ed
>> to avoid in almost all cases, we need a "subsystem" link in sysfs.
>>
>
> Yes, but apparently mistakenly.
>
>> I wold expect the cciss devices not to be a magic, silently created,
>> subdirectory of a pci device, but to have their own "cciss" bus in
>> sysfs, so the created devices get proper events at creation time. Al=
l
>> the cciss devices would show up in its own directory
>> /sys/bus/cciss/devices/*.
>>
>> I think, you should name all "cciss bus devices" uniquely, and assig=
n
>> them to a "cciss bus_type". We really do not want unclassified devic=
es
>> in the chain of parent devices of a block device.
>>
>
> I'll try this. =C2=A0Although I am wondering whether to put hosts or =
logical
> drives in /sys/bus/cciss/devices (or both). Can I do what I am doing
> now, just moving it to /sys/bus/cciss/devices? That
> is, /sys/bus/cciss/devices/ccissX/cYdZ.

Do what you have today, just make sure all your devices are uniquely
named, and assigned to the cciss bus_type. There can be no hierarchies
in /sys/bus/*/devices, there are only symlinks. The hierarchy is only
in /sys/devices/, and if I correctly look at what you have, you have
that already.

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
