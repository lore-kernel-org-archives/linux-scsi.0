From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Tue, 14 Feb 2012 00:59:06 +0200
Message-ID: <20120213225623.GA2988@redhat.com>
References: <4F38B657.7060405@de.ibm.com>
 <4F38C27E.7030300@redhat.com>
 <1329136806.9333.383.camel@haakon2.linux-iscsi.org>
 <4F3907EB.4030402@redhat.com>
 <20120213130005.GB26773@redhat.com>
 <CAN05THTOY894httm5PjzsHELBB-P8DmpZ4bGoBR7FH1s6Tmcrg@mail.gmail.com>
 <20120213131848.GD26773@redhat.com>
 <4F39287A.9030808@suse.de>
 <CAN05THT=7xJhqAMrAvDsK2Z1_4d+=tV9yhOFkr5Z-i43k5hAGA@mail.gmail.com>
 <CAN05THT6t_w=9Zt+o-B4s8E3jUMWsxiBvTyySxNEK2QfvLe-BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAN05THT6t_w=9Zt+o-B4s8E3jUMWsxiBvTyySxNEK2QfvLe-BA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, Dor Laor <dlaor@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christian Borntraeger <borntraeger@de.ibm.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, Christian Hoff <christian.hoff@de.ibm.com>, borntrae@linux.vnet.ibm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rusty@rustcorp.com.au, Stefan Hajnoczi <stefanha@gmail.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 14, 2012 at 07:53:26AM +1100, ronnie sahlberg wrote:
> On Tue, Feb 14, 2012 at 7:42 AM, ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> > On Tue, Feb 14, 2012 at 2:12 AM, Hannes Reinecke <hare@suse.de> wro=
te:
> >> On 02/13/2012 02:18 PM, Michael S. Tsirkin wrote:
> >>> On Tue, Feb 14, 2012 at 12:13:36AM +1100, ronnie sahlberg wrote:
> >>>> On Tue, Feb 14, 2012 at 12:00 AM, Michael S. Tsirkin <mst@redhat=
=2Ecom> wrote:
> >>>>> On Mon, Feb 13, 2012 at 02:54:03PM +0200, Dor Laor wrote:
> >>>>>> Only if you use the pci multi-function option but that kills
> >>>>>> standard hot unplug
> >>>>>
> >>>>> It doesn't kill it as such, rather you can't unplug luns indivi=
dually.
> >>>>
> >>>> Isnt that just a consequence of the current implementation rathe=
r than
> >>>> a SCSI limitation?
> >>>
> >>> Yes.
> >>>
> >>>> A different way to do hoplug could be to flag all devices as rem=
ovable
> >>>> in the standard inq page then
> >>>> leave the LUN there persistently and what you remove/add is not =
the
> >>>> LUN device itself but just the media in the device.
> >>>>
> >>>> Instead of hot-plug remove the LUN, =A0hot-plug becomes "media e=
ject" or
> >>>> "media insert".
> >>>> The device remains present all time, you never remove it, but in=
stead
> >>>> hot-plug controls if the media is present or not.
> >>>>
> >>>>
> >>>> This would require implementing at least START_STOP_UNIT and
> >>>> PREVENT_ALLOW_MEDIUM_REMOVAL opcode emulation from SBC.
> >>>>
> >>>>
> >>>> regards
> >>>> ronnie sahlberg
> >>>
> >>> That would work.
> >>>
> >> Or we simply use the Peripheral Qualifier that the device is gone;
> >> eg we could simply set PQ =3D 1, return sense code 0x25/00 and be =
done
> >> with ...
> >>
> >
> > That is still similar to "rip a device out from the guest without n=
otice"
> > and can cause the guest to be "surprised".
> >
> >
> > Removable media is standard feature in SCSI SBC (and other commands=
ets).
> > The nice part of removable media is that it activates a contract
> > between the device and the guest
> > to prevent removal of the media when the guest depends on the media
> > not being removed.
> >
> > I.e. =A0If you have a SBC device with the removable-media bit set,
> > this is used to tell the initiator "this media can be removed, be
> > prepared that this might happen".
> > So when you mount such a SBC device in the guest, the guest will is=
sue
> > a "PREVENT_ALLOW_MEDIUM_REMOVAL"
> > to tell the device "this medium is in use and may not be removed".
> >
>=20
> What I mean is that if /dev/sdb is removable,
> if you mount this as   "mount /dev/sdb1 /mnt"
> this will automatically cause the guest kernel to send a
> PREVENT_ALLOW_MEDIUM_REMOVAL to /dev/sdb to prevent removal.
>=20
> When you "umount /dev/sdb1"   the kernel/guest will automagically sen=
d
> PREVENT_ALLOW_MEDIUM_REMOVEAL to /dev/sdb and allow removal of the
> media again.
>=20
>=20
> If you capture this command and track the "prevent/allow removal
> status"  you automatically get a channel where qemu will
> know when it is safe to unplug the device  and when it is not safe to
> unplug the device.
> This is a nice feature.

Presumably there's a way for device to notify the OS
that user requested removal, as well?
