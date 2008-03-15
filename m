From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sat, 15 Mar 2008 13:31:21 -0500
Message-ID: <1205605881.6767.52.camel@localhost.localdomain>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
	 <1205529619.2904.87.camel@localhost.localdomain>
	 <1205531922.3522.57.camel@lov.site>
	 <1205590788.6767.12.camel@localhost.localdomain>
	 <1205594256.3109.53.camel@lov.site>
	 <1205597776.6767.40.camel@localhost.localdomain>
	 <1205604260.3109.133.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51763 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132AbYCOSbZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Mar 2008 14:31:25 -0400
In-Reply-To: <1205604260.3109.133.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Sat, 2008-03-15 at 19:04 +0100, Kay Sievers wrote:
> On Sat, 2008-03-15 at 11:16 -0500, James Bottomley wrote:
> > > We just need to create something like a "contains" link from the
> > > component to the scsi device, and a "enclosure" link at the scsi =
device
> > > back to the component, right?
> >=20
> > Assuming you're moving to the single tree model, then I can easily =
do
> > this:
> >=20
> > <real enclosure device>/<enclosure>/<enclosure component>/device ->=
 link
> > to component device
>=20
> Yes, sounds good. Only that there will be no meaningful "device" link
> with !SYSFS_DEPRECATED, we need a custom link, maintained by the
> enclosure itself, to do that.
>=20
> > with a back link in the component device pointing to the enclosure
> > component.
>=20
> That sounds fine.
>=20
> > The way components work, probably blowing away enclosure_component_=
class
> > makes the most sense anyway.
>=20
> If we go for a single class, can't we express enclosures and componen=
ts
> in the device name and put them in the same class like:
> /sys/class/enclosure/
> |- enclosure1 -> ../../../devices/<...>/enclosure1
> |- enclosure1.slot1 -> ../../../../devices/<...>/enclosure1/enclosure=
1.slot1
> |- enclosure1.slot2 -> ../../../../devices/<...>/enclosure1/enclosure=
1.slot2
> |- enclosure2 -> =EF=BB=BF../../../devices/<...>/enclosure2
> |- enclosure2.slot1 -> =EF=BB=BF-> ../../../../devices/<...>/enclosur=
e1/enclosure2.slot1
> ...
> =20
> while /sys/devices/<...>/enclosure1/enclosure1.slot1/ has a something
> like a "contains" link pointing to the SCSI device, and the SCSI devi=
ce
> an "enclosure" link back?

OK, I've got a two expander system with six slots each pretending to be
a twelve slot installation.  I've also got two slots populated (slot 1
and 6).  This is what it looks like with the deprecated setting:

sparkweed:/sys/class/enclosure# tree
=2E
|-- 0:0:1:0
|   |-- SLOT 006
|   |   |-- active
|   |   |-- device -> ../../../../devices/pci0000:01/0000:01:02.0/host0=
/port-0:0/expander-0:0/port-0:0:0/end_device-0:0:0/target0:0:0/0:0:0:0
|   |   |-- fault
|   |   |-- locate
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- status
|   |   |-- type
|   |   `-- uevent
|   |-- SLOT 007
|   |   |-- active
|   |   |-- fault
|   |   |-- locate
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- status
|   |   |-- type
|   |   `-- uevent
|   |-- SLOT 008
|   |   |-- active
|   |   |-- fault
|   |   |-- locate
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- status
|   |   |-- type
|   |   `-- uevent
|   |-- SLOT 009
|   |   |-- active
|   |   |-- fault
|   |   |-- locate
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- status
|   |   |-- type
|   |   `-- uevent
|   |-- SLOT 010
|   |   |-- active
|   |   |-- fault
|   |   |-- locate
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- status
|   |   |-- type
|   |   `-- uevent
|   |-- SLOT 011
|   |   |-- active
|   |   |-- fault
|   |   |-- locate
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- status
|   |   |-- type
|   |   `-- uevent
|   |-- components
|   |-- device -> ../../../devices/pci0000:01/0000:01:02.0/host0/port-0=
:0/expander-0:0/port-0:0:12/end_device-0:0:12/target0:0:1/0:0:1:0
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../enclosure
|   `-- uevent
`-- 0:0:3:0
    |-- SLOT 000
    |   |-- active
    |   |-- fault
    |   |-- locate
    |   |-- power
    |   |   `-- wakeup
    |   |-- status
    |   |-- type
    |   `-- uevent
    |-- SLOT 001
    |   |-- active
    |   |-- device -> ../../../../devices/pci0000:01/0000:01:02.0/host0=
/port-0:1/expander-0:1/port-0:1:11/end_device-0:1:11/target0:0:2/0:0:2:=
0
    |   |-- fault
    |   |-- locate
    |   |-- power
    |   |   `-- wakeup
    |   |-- status
    |   |-- type
    |   `-- uevent
    |-- SLOT 002
    |   |-- active
    |   |-- fault
    |   |-- locate
    |   |-- power
    |   |   `-- wakeup
    |   |-- status
    |   |-- type
    |   `-- uevent
    |-- SLOT 003
    |   |-- active
    |   |-- fault
    |   |-- locate
    |   |-- power
    |   |   `-- wakeup
    |   |-- status
    |   |-- type
    |   `-- uevent
    |-- SLOT 004
    |   |-- active
    |   |-- fault
    |   |-- locate
    |   |-- power
    |   |   `-- wakeup
    |   |-- status
    |   |-- type
    |   `-- uevent
    |-- SLOT 005
    |   |-- active
    |   |-- fault
    |   |-- locate
    |   |-- power
    |   |   `-- wakeup
    |   |-- status
    |   |-- type
    |   `-- uevent
    |-- components
    |-- device -> ../../../devices/pci0000:01/0000:01:02.0/host0/port-0=
:1/expander-0:1/port-0:1:12/end_device-0:1:12/target0:0:3/0:0:3:0
    |-- power
    |   `-- wakeup
    |-- subsystem -> ../../enclosure
    `-- uevent


And without the deprecated setting:

sparkweed:/sys/class/enclosure# tree
=2E
|-- 0:0:1:0 -> ../../devices/pci0000:01/0000:01:02.0/host0/port-0:0/exp=
ander-0:0/port-0:0:12/end_device-0:0:12/target0:0:1/0:0:1:0/enclosure/0=
:0:1:0
`-- 0:0:3:0 -> ../../devices/pci0000:01/0000:01:02.0/host0/port-0:1/exp=
ander-0:1/port-0:1:12/end_device-0:1:12/target0:0:3/0:0:3:0/enclosure/0=
:0:3:0

sparkweed:/sys/class/enclosure/0:0:1:0# tree
=2E
|-- SLOT 006
|   |-- active
|   |-- device -> ../../../../../../../port-0:0:0/end_device-0:0:0/targ=
et0:0:0/0:0:0:0
|   |-- fault
|   |-- locate
|   |-- power
|   |   `-- wakeup
|   |-- status
|   |-- type
|   `-- uevent
|-- SLOT 007
|   |-- active
|   |-- fault
|   |-- locate
|   |-- power
|   |   `-- wakeup
|   |-- status
|   |-- type
|   `-- uevent
|-- SLOT 008
|   |-- active
|   |-- fault
|   |-- locate
|   |-- power
|   |   `-- wakeup
|   |-- status
|   |-- type
|   `-- uevent
|-- SLOT 009
|   |-- active
|   |-- fault
|   |-- locate
|   |-- power
|   |   `-- wakeup
|   |-- status
|   |-- type
|   `-- uevent
|-- SLOT 010
|   |-- active
|   |-- fault
|   |-- locate
|   |-- power
|   |   `-- wakeup
|   |-- status
|   |-- type
|   `-- uevent
|-- SLOT 011
|   |-- active
|   |-- fault
|   |-- locate
|   |-- power
|   |   `-- wakeup
|   |-- status
|   |-- type
|   `-- uevent
|-- components
|-- device -> ../../../0:0:1:0
|-- power
|   `-- wakeup
|-- subsystem -> ../../../../../../../../../../../../class/enclosure
`-- uevent


So are we now all happy?

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
