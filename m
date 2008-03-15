From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sat, 15 Mar 2008 20:43:48 +0100
Message-ID: <1205610228.3109.173.camel@lov.site>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
	 <1205529619.2904.87.camel@localhost.localdomain>
	 <1205531922.3522.57.camel@lov.site>
	 <1205590788.6767.12.camel@localhost.localdomain>
	 <1205594256.3109.53.camel@lov.site>
	 <1205597776.6767.40.camel@localhost.localdomain>
	 <1205604260.3109.133.camel@lov.site>
	 <1205605881.6767.52.camel@localhost.localdomain>
	 <1205607366.3109.166.camel@lov.site>
	 <1205609618.6767.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.174]:53176 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYCOTm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Mar 2008 15:42:59 -0400
In-Reply-To: <1205609618.6767.63.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Sat, 2008-03-15 at 14:33 -0500, James Bottomley wrote:
> On Sat, 2008-03-15 at 19:56 +0100, Kay Sievers wrote:
> > On Sat, 2008-03-15 at 13:31 -0500, James Bottomley wrote:
> > > On Sat, 2008-03-15 at 19:04 +0100, Kay Sievers wrote:
> > > > On Sat, 2008-03-15 at 11:16 -0500, James Bottomley wrote:
> > > > > > We just need to create something like a "contains" link fro=
m the
> > > > > > component to the scsi device, and a "enclosure" link at the=
 scsi device
> > > > > > back to the component, right?
> > > > >=20
> > > > > Assuming you're moving to the single tree model, then I can e=
asily do
> > > > > this:
> > > > >=20
> > > > > <real enclosure device>/<enclosure>/<enclosure component>/dev=
ice -> link
> > > > > to component device
> > > >=20
> > > > Yes, sounds good. Only that there will be no meaningful "device=
" link
> > > > with !SYSFS_DEPRECATED, we need a custom link, maintained by th=
e
> > > > enclosure itself, to do that.
> > > >=20
> > > > > with a back link in the component device pointing to the encl=
osure
> > > > > component.
> > > >=20
> > > > That sounds fine.
> > > >=20
> > > > > The way components work, probably blowing away enclosure_comp=
onent_class
> > > > > makes the most sense anyway.
> > > >=20
> > > > If we go for a single class, can't we express enclosures and co=
mponents
> > > > in the device name and put them in the same class like:
> > > > /sys/class/enclosure/
> > > > |- enclosure1 -> ../../../devices/<...>/enclosure1
> > > > |- enclosure1.slot1 -> ../../../../devices/<...>/enclosure1/enc=
losure1.slot1
> > > > |- enclosure1.slot2 -> ../../../../devices/<...>/enclosure1/enc=
losure1.slot2
> > > > |- enclosure2 -> =EF=BB=BF../../../devices/<...>/enclosure2
> > > > |- enclosure2.slot1 -> =EF=BB=BF-> ../../../../devices/<...>/en=
closure1/enclosure2.slot1
> > > > ...
> > > > =20
> > > > while /sys/devices/<...>/enclosure1/enclosure1.slot1/ has a som=
ething
> > > > like a "contains" link pointing to the SCSI device, and the SCS=
I device
> > > > an "enclosure" link back?
> > >=20
> > > OK, I've got a two expander system with six slots each pretending=
 to be
> > > a twelve slot installation.  I've also got two slots populated (s=
lot 1
> > > and 6).  This is what it looks like with the deprecated setting:
> > >=20
> > > sparkweed:/sys/class/enclosure# tree
> > > .
> > > |-- 0:0:1:0
> > > |   |-- SLOT 006
> > > |   |   |-- active
> > > |   |   |-- device -> ../../../../devices/pci0000:01/0000:01:02.0=
/host0/port-0:0/expander-0:0/port-0:0:0/end_device-0:0:0/target0:0:0/0:=
0:0:0
> > > |   |   |-- fault
> > > |   |   |-- locate
> > > |   |   |-- power
> > > |   |   |   `-- wakeup
> > > |   |   |-- status
> > > |   |   |-- type
> > > |   |   `-- uevent
> >=20
> > The components are not assigned to any subsystem. Userspace will no=
t see
> > any event for these devices, which might not be nice. Is that expec=
ted
> > behavior?
>=20
> Hmm, I suppose they might.  Failure of an enclosure bay is most likel=
y a
> failure of the device in that bay, but it could be for some other
> reason, I suppose.
>=20
> > If you assign them to the enclosure class, the device name would ne=
ed
> > the enclosure name prefixed, because they are not unique across
> > different enclosures, right?
>=20
> They can't be assigned to the enclosure class otherwise they'd get th=
e
> enclosure class interface, which is wrong for components.

If we can distinguish the both device types by the device name, that
would still be fine. Like we have disks and partitions in "block, or
mouseX and inputX in "input" at the same time. Or we can have a separat=
e
classes, like it was in the original version, if that fits better.

> > ...
> >=20
> > > |   |-- SLOT 011
> > > |   |   |-- active
> > > |   |   |-- fault
> > > |   |   |-- locate
> > > |   |   |-- power
> > > |   |   |   `-- wakeup
> > > |   |   |-- status
> > > |   |   |-- type
> > > |   |   `-- uevent
> > > |   |-- components
> > > |   |-- device -> ../../../devices/pci0000:01/0000:01:02.0/host0/=
port-0:0/expander-0:0/port-0:0:12/end_device-0:0:12/target0:0:1/0:0:1:0
> >=20
> > Oh, interesting, can the parent for a whole enclosure be =EF=BB=BFa=
 SCSI LUN? Is
> > that because the expander _is_ a LUN itself?
>=20
> In this case, it is; but it's actually worse than that: the enclosure
> spec allows the enclosure device to be embedded in a LUN (i.e. a LUN
> responds as a SCSI disk but also responds to enclosure commands).
> That's why the ses driver has to bind like SG.

Ouch! People have crazy ideas. :)

> > ...
> >=20
> > > So are we now all happy?
> >=20
> > If we don't need uevents for components, and no directory in /sys/c=
lass/
> > which lists all enclosure components for easy finding them. And if =
we
> > never want to send things link "change" events to userspace from an
> > enclosure component, that should be ok. And we can be happy, yes. :=
)
>=20
> It would be nice, but then we run into the enumeration problem again.
> The names are taken from the actual enclosure information and are onl=
y
> guaranteed unique per enclosure.  I could make up unique names, but t=
hen
> they wouldn't correspond with the actual names printed on the enclosu=
re.

If we prefix the component device name with the enclosure device name,
like: "<encl-name>.<comp-name>", it would be unique, right? And still
match the labels, and also identify the enclosure.

> > I still slightly prefer cross link-names between the component and =
the
> > LUN like "contains" -> and "enclosure" ->, but the current one shou=
ld
> > work too.
>=20
> OK.

Kay

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
