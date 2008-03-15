From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sat, 15 Mar 2008 14:33:38 -0500
Message-ID: <1205609618.6767.63.camel@localhost.localdomain>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35536 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686AbYCOTdl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Mar 2008 15:33:41 -0400
In-Reply-To: <1205607366.3109.166.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Sat, 2008-03-15 at 19:56 +0100, Kay Sievers wrote:
> On Sat, 2008-03-15 at 13:31 -0500, James Bottomley wrote:
> > On Sat, 2008-03-15 at 19:04 +0100, Kay Sievers wrote:
> > > On Sat, 2008-03-15 at 11:16 -0500, James Bottomley wrote:
> > > > > We just need to create something like a "contains" link from =
the
> > > > > component to the scsi device, and a "enclosure" link at the s=
csi device
> > > > > back to the component, right?
> > > >=20
> > > > Assuming you're moving to the single tree model, then I can eas=
ily do
> > > > this:
> > > >=20
> > > > <real enclosure device>/<enclosure>/<enclosure component>/devic=
e -> link
> > > > to component device
> > >=20
> > > Yes, sounds good. Only that there will be no meaningful "device" =
link
> > > with !SYSFS_DEPRECATED, we need a custom link, maintained by the
> > > enclosure itself, to do that.
> > >=20
> > > > with a back link in the component device pointing to the enclos=
ure
> > > > component.
> > >=20
> > > That sounds fine.
> > >=20
> > > > The way components work, probably blowing away enclosure_compon=
ent_class
> > > > makes the most sense anyway.
> > >=20
> > > If we go for a single class, can't we express enclosures and comp=
onents
> > > in the device name and put them in the same class like:
> > > /sys/class/enclosure/
> > > |- enclosure1 -> ../../../devices/<...>/enclosure1
> > > |- enclosure1.slot1 -> ../../../../devices/<...>/enclosure1/enclo=
sure1.slot1
> > > |- enclosure1.slot2 -> ../../../../devices/<...>/enclosure1/enclo=
sure1.slot2
> > > |- enclosure2 -> =EF=BB=BF../../../devices/<...>/enclosure2
> > > |- enclosure2.slot1 -> =EF=BB=BF-> ../../../../devices/<...>/encl=
osure1/enclosure2.slot1
> > > ...
> > > =20
> > > while /sys/devices/<...>/enclosure1/enclosure1.slot1/ has a somet=
hing
> > > like a "contains" link pointing to the SCSI device, and the SCSI =
device
> > > an "enclosure" link back?
> >=20
> > OK, I've got a two expander system with six slots each pretending t=
o be
> > a twelve slot installation.  I've also got two slots populated (slo=
t 1
> > and 6).  This is what it looks like with the deprecated setting:
> >=20
> > sparkweed:/sys/class/enclosure# tree
> > .
> > |-- 0:0:1:0
> > |   |-- SLOT 006
> > |   |   |-- active
> > |   |   |-- device -> ../../../../devices/pci0000:01/0000:01:02.0/h=
ost0/port-0:0/expander-0:0/port-0:0:0/end_device-0:0:0/target0:0:0/0:0:=
0:0
> > |   |   |-- fault
> > |   |   |-- locate
> > |   |   |-- power
> > |   |   |   `-- wakeup
> > |   |   |-- status
> > |   |   |-- type
> > |   |   `-- uevent
>=20
> The components are not assigned to any subsystem. Userspace will not =
see
> any event for these devices, which might not be nice. Is that expecte=
d
> behavior?

Hmm, I suppose they might.  Failure of an enclosure bay is most likely =
a
failure of the device in that bay, but it could be for some other
reason, I suppose.

> If you assign them to the enclosure class, the device name would need
> the enclosure name prefixed, because they are not unique across
> different enclosures, right?

They can't be assigned to the enclosure class otherwise they'd get the
enclosure class interface, which is wrong for components.

> ...
>=20
> > |   |-- SLOT 011
> > |   |   |-- active
> > |   |   |-- fault
> > |   |   |-- locate
> > |   |   |-- power
> > |   |   |   `-- wakeup
> > |   |   |-- status
> > |   |   |-- type
> > |   |   `-- uevent
> > |   |-- components
> > |   |-- device -> ../../../devices/pci0000:01/0000:01:02.0/host0/po=
rt-0:0/expander-0:0/port-0:0:12/end_device-0:0:12/target0:0:1/0:0:1:0
>=20
> Oh, interesting, can the parent for a whole enclosure be =EF=BB=BFa S=
CSI LUN? Is
> that because the expander _is_ a LUN itself?

In this case, it is; but it's actually worse than that: the enclosure
spec allows the enclosure device to be embedded in a LUN (i.e. a LUN
responds as a SCSI disk but also responds to enclosure commands).
That's why the ses driver has to bind like SG.

> ...
>=20
> > So are we now all happy?
>=20
> If we don't need uevents for components, and no directory in /sys/cla=
ss/
> which lists all enclosure components for easy finding them. And if we
> never want to send things link "change" events to userspace from an
> enclosure component, that should be ok. And we can be happy, yes. :)

It would be nice, but then we run into the enumeration problem again.
The names are taken from the actual enclosure information and are only
guaranteed unique per enclosure.  I could make up unique names, but the=
n
they wouldn't correspond with the actual names printed on the enclosure=
=2E

> I still slightly prefer cross link-names between the component and th=
e
> LUN like "contains" -> and "enclosure" ->, but the current one should
> work too.

OK.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
