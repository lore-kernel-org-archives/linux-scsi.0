From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Tue, 14 Feb 2012 11:49:55 +1100
Message-ID: <CAN05THTTva709Dab9f_PBWxehMWnP9Gg4T7Nnmg7Swk3xuz7aQ@mail.gmail.com>
References: <1329136806.9333.383.camel@haakon2.linux-iscsi.org>
	<4F3907EB.4030402@redhat.com>
	<20120213130005.GB26773@redhat.com>
	<CAN05THTOY894httm5PjzsHELBB-P8DmpZ4bGoBR7FH1s6Tmcrg@mail.gmail.com>
	<20120213131848.GD26773@redhat.com>
	<4F39287A.9030808@suse.de>
	<CAN05THT=7xJhqAMrAvDsK2Z1_4d+=tV9yhOFkr5Z-i43k5hAGA@mail.gmail.com>
	<CAN05THT6t_w=9Zt+o-B4s8E3jUMWsxiBvTyySxNEK2QfvLe-BA@mail.gmail.com>
	<20120213225623.GA2988@redhat.com>
	<CAN05THS_zTf2VRz6QdccHbkOacnE86LNhtxp7b8twe+XezBU6Q@mail.gmail.com>
	<20120213233334.GC4430@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58718 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832Ab2BNAt4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 19:49:56 -0500
In-Reply-To: <20120213233334.GC4430@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Dor Laor <dlaor@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christian Borntraeger <borntraeger@de.ibm.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, Christian Hoff <christian.hoff@de.ibm.com>, borntrae@linux.vnet.ibm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, Stefan Hajnoczi <stefanha@gmail.com>, target-devel <target-devel@vger.kernel.org>

On Tue, Feb 14, 2012 at 10:33 AM, Michael S. Tsirkin <mst@redhat.com> w=
rote:
> On Tue, Feb 14, 2012 at 10:30:59AM +1100, ronnie sahlberg wrote:
>> On Tue, Feb 14, 2012 at 9:59 AM, Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>> > On Tue, Feb 14, 2012 at 07:53:26AM +1100, ronnie sahlberg wrote:
>> >> On Tue, Feb 14, 2012 at 7:42 AM, ronnie sahlberg
>> >> <ronniesahlberg@gmail.com> wrote:
>> >> > On Tue, Feb 14, 2012 at 2:12 AM, Hannes Reinecke <hare@suse.de>=
 wrote:
>> >> >> On 02/13/2012 02:18 PM, Michael S. Tsirkin wrote:
>> >> >>> On Tue, Feb 14, 2012 at 12:13:36AM +1100, ronnie sahlberg wro=
te:
>> >> >>>> On Tue, Feb 14, 2012 at 12:00 AM, Michael S. Tsirkin <mst@re=
dhat.com> wrote:
>> >> >>>>> On Mon, Feb 13, 2012 at 02:54:03PM +0200, Dor Laor wrote:
>> >> >>>>>> Only if you use the pci multi-function option but that kil=
ls
>> >> >>>>>> standard hot unplug
>> >> >>>>>
>> >> >>>>> It doesn't kill it as such, rather you can't unplug luns in=
dividually.
>> >> >>>>
>> >> >>>> Isnt that just a consequence of the current implementation r=
ather than
>> >> >>>> a SCSI limitation?
>> >> >>>
>> >> >>> Yes.
>> >> >>>
>> >> >>>> A different way to do hoplug could be to flag all devices as=
 removable
>> >> >>>> in the standard inq page then
>> >> >>>> leave the LUN there persistently and what you remove/add is =
not the
>> >> >>>> LUN device itself but just the media in the device.
>> >> >>>>
>> >> >>>> Instead of hot-plug remove the LUN, =A0hot-plug becomes "med=
ia eject" or
>> >> >>>> "media insert".
>> >> >>>> The device remains present all time, you never remove it, bu=
t instead
>> >> >>>> hot-plug controls if the media is present or not.
>> >> >>>>
>> >> >>>>
>> >> >>>> This would require implementing at least START_STOP_UNIT and
>> >> >>>> PREVENT_ALLOW_MEDIUM_REMOVAL opcode emulation from SBC.
>> >> >>>>
>> >> >>>>
>> >> >>>> regards
>> >> >>>> ronnie sahlberg
>> >> >>>
>> >> >>> That would work.
>> >> >>>
>> >> >> Or we simply use the Peripheral Qualifier that the device is g=
one;
>> >> >> eg we could simply set PQ =3D 1, return sense code 0x25/00 and=
 be done
>> >> >> with ...
>> >> >>
>> >> >
>> >> > That is still similar to "rip a device out from the guest witho=
ut notice"
>> >> > and can cause the guest to be "surprised".
>> >> >
>> >> >
>> >> > Removable media is standard feature in SCSI SBC (and other comm=
andsets).
>> >> > The nice part of removable media is that it activates a contrac=
t
>> >> > between the device and the guest
>> >> > to prevent removal of the media when the guest depends on the m=
edia
>> >> > not being removed.
>> >> >
>> >> > I.e. =A0If you have a SBC device with the removable-media bit s=
et,
>> >> > this is used to tell the initiator "this media can be removed, =
be
>> >> > prepared that this might happen".
>> >> > So when you mount such a SBC device in the guest, the guest wil=
l issue
>> >> > a "PREVENT_ALLOW_MEDIUM_REMOVAL"
>> >> > to tell the device "this medium is in use and may not be remove=
d".
>> >> >
>> >>
>> >> What I mean is that if /dev/sdb is removable,
>> >> if you mount this as =A0 "mount /dev/sdb1 /mnt"
>> >> this will automatically cause the guest kernel to send a
>> >> PREVENT_ALLOW_MEDIUM_REMOVAL to /dev/sdb to prevent removal.
>> >>
>> >> When you "umount /dev/sdb1" =A0 the kernel/guest will automagical=
ly send
>> >> PREVENT_ALLOW_MEDIUM_REMOVEAL to /dev/sdb and allow removal of th=
e
>> >> media again.
>> >>
>> >>
>> >> If you capture this command and track the "prevent/allow removal
>> >> status" =A0you automatically get a channel where qemu will
>> >> know when it is safe to unplug the device =A0and when it is not s=
afe to
>> >> unplug the device.
>> >> This is a nice feature.
>> >
>> > Presumably there's a way for device to notify the OS
>> > that user requested removal, as well?
>>
>>
>> I think that is done by responding with sense =A0to one of the comma=
nds,
>> like the every few second TEST_UNIT_READY that the
>> initiator/guest-kernel will send.
>
> Does it do this even for mounted media?
> I didn't realize ...

Yes it does. At least for SBC devices that are flagged as removable.
"Normal" SBC devices that are not removable might trigger different
behaviour in the kernel.
(endless string of TEST_UNIT_READY is a way to check if something
"unexpected" happens on the device.)

I just tested on a 3.0.0  kernel.

I have a mediachanger for SBC and the SBC is flagged as removable.
/dev/sdd is the iscsi lun with a removable SBC disk.

By just exposing this device to the kernel, the kernel keeps sending,
or if not the kernel maybe some other process trying to poll the
status?

every few seconds :
PREVENT_ALLOW_MEDIUM_REMOVAL  prevent removal
PREVENT_ALLOW_MEDIUM_REMOVAL  to immediatel change it back to allow
removal again
TEST_UNIT_READY


After I run this
mount /dev/sdd1 /mnt

The kernel sends a single
PREVENT_ALLOW_MEDIUM_REMOVAL to prevent removal
then every few seconds a
TEST_UNIT_READY


This is what it does for removable SBC disks. Maybe it does something
differently for "permanent" SBC disks.

regards
ronnie sahlberg
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
