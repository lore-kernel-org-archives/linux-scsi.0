From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sat, 15 Mar 2008 11:16:16 -0500
Message-ID: <1205597776.6767.40.camel@localhost.localdomain>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
	 <1205529619.2904.87.camel@localhost.localdomain>
	 <1205531922.3522.57.camel@lov.site>
	 <1205590788.6767.12.camel@localhost.localdomain>
	 <1205594256.3109.53.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50977 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbYCOQQV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Mar 2008 12:16:21 -0400
In-Reply-To: <1205594256.3109.53.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Sat, 2008-03-15 at 16:17 +0100, Kay Sievers wrote:
> On Sat, 2008-03-15 at 09:19 -0500, James Bottomley wrote:
> > On Fri, 2008-03-14 at 22:58 +0100, Kay Sievers wrote:
> > > On Fri, 2008-03-14 at 16:20 -0500, James Bottomley wrote:
> > > Unfortunately, the enclosure/enclusure-component/component-device
> > > relationship is not a tree. There is only a single "parent" for a
> > > device. The "device" link already expresses the parent device, an=
d the
> > > class devices will show up as childs of the devices, where the "d=
evice"
> > > link pointed to. There can't be a second device which could be us=
ed as a
> > > parent.
> >=20
> > But that's precisely my point: it is a tree; it's not a multi roote=
d
> > tree either.
>=20
> Hmm, the enclosure components have two parents in this model, the
> enclosure itself _and_ the scsi device, so it's not a flat tree anymo=
re.

Only because you're expressing the class relationship as a parent.  It
wasn't designed like this; an interface sits off to the side.

> >  Each enclosure has a fixed number of components (the bays
> > in the enclosure) that's a simple two level tree.
>=20
> I think it's not a second level, it's a second tree if you have two
> parents for one single node. The driver core only supports one flat
> device tree, and one parent relationship per device.
>=20
> > However, both the
> > enclosure and the components may point to devices in the regular tr=
ee
> > (bays only if the bay is actually populated).
>=20
> Sure, that's fine, but still, the component can have only one parent
> managed by the core, we have only one single device tree
> at /sys/devices/ and other relations should be expressed by the drive=
r
> itself.
>=20
> > This was formerly representable in the class_device infrastructure,
> > because class devices were allowed to have parents.
>=20
> The "parent" field was something Greg added for trying to represent
> "input", and it failed, existing userspace logic could not handle it,
> and we immediately deprecated hierarchies in /sys/class. It was never
> supposed to be used with the "dev" field pointing to a different devi=
ce
> at the same time.
> As documented in Documentation/, all this "device" link magic we are
> talking about, will only work in SYSFS_DEPRECATED=3Dy mode anyway, wh=
ich
> no recent distro uses anymore, and the enclosure stuff was added long
> after that.

OK, where is this?  There's no mention of any deprecation in
Documentation/driver-model; grep -i deprec returns an empty list.

> > Class devices are
> > supposed to represent interfaces to devices
>=20
> That's not true. Class devices are just devices, as documented in the
> Documentation/ directory.

OK, which kernel is this?  The latest greatest upstream merge kernel I
know is 2.6.25-rc5-mc6 and that says

Documentation/driver-model/class.txt:
[...]
Each device class defines a set of semantics and a programming interfac=
e
that devices of that class adhere to. Device drivers are the
implementation of that programming interface for a particular device on
a particular bus.

The "programming interface" bit seems pretty clear to me.

The whole of SCSI use of the driver model is designed around the
interface concept.  Essentially, SCSI device represents the generic
object that sits on the end of the bus. We export one set of interfaces
from the upper layer driver that binds (st, sd, sr etc.) we express
another through the SCSI generic, and we express a third (or more)
through the transport class interfaces.

In theory, we could express all this as simply additional attribute
groups on the generic SCSI device or use a parent/child device
relationship for them, or something else ...  This is the piece I still
don't get from you and Greg.  Just saying it isn't an interface any mor=
e
doesn't help me in this regard.

>  Class devices are _not_ supposed to be
> anything special, they just don't have drivers/binding in the kernel
> internals - no other difference. There is no such thing as an
> "interface" in the driver core or sysfs. Every device _is_ the interf=
ace
> itself, otherwise devices would have no functional sysfs attributes.

But if the actual class documentation doesn't say this, how am I
supposed to know it?  I keep asking what you're planning but I don't ge=
t
a complete response.

If I had to guess, I'd say eventually you want all classes to fold up
under the device directory (hence the parent pointer) and so be part of
a continuous tree ... is that it?

> It was one of the biggest mistakes to expose such a kernel
> implementation details as different entities to userspace, and one
> reason sysfs is that hard to understand. The guy who did all that jus=
t
> ran away leaving all this mess behind him. :) And yes, we are too slo=
w
> cleaning all that up, but we will get there over time.
> =EF=BB=BF
> > and not all interfaces are
> > fully flat.
>=20
> True, but the core is only one flat tree, the drivers need to express
> "reverse trees" themselves, just like the raid block devices do.
>=20
> > > =EF=BB=BFA sysfs class device hierarchy, and at the same let the =
"device" link
> > > point to a different device is not supported. Existing userspace =
tools
> > > do not support that.
> > >=20
> > > We have a similar problem for raid block devices, which can't be
> > > expressed in a single device tree. The "reverse tree" is construc=
ted by
> > > custom holders/ slave/ directories at the devices.
> > >=20
> > > =EF=BB=BFI suggest to express the relationship of the enclosure c=
omponents to
> > > the enclosure device by custom symlinks, instead of expecting a "=
device"
> > > link =EF=BB=BFmaintained by the core to build a "reverse tree".
> > >=20
> > > Would that work?
> >=20
> > There are still several problems with the symlink approach; not lea=
st of
> > which is that the component namespace isn't globally unique, it's o=
nly
> > unique to the enclosure:  If you have two separate enclosures conne=
cted,
> > they're likely each going to have a component called slot1 (the nam=
e is
> > actually take from the enclosure).  I also think we're going to hav=
e
> > difficulty going back from a component to an enclosure, which was p=
retty
> > much the whole point of the exercise but I need to get ses/enclosur=
e
> > actually working to look at that.
>=20
> Hmm, I don't understand. The only thing that changed is that you don'=
t
> have a core-managed "device" link at the enclosure component anymore,
> nothing else should be different. The namespace issue should be the s=
ame
> as it was before, right?

No, the way you broke it was removing the functioning component link.
If you boot now, all components are linked to the enclosure devices, no=
t
the component devices ... I can fix this easily, I'm still just trying
to figure out how you want it represented.

> We just need to create something like a "contains" link from the
> component to the scsi device, and a "enclosure" link at the scsi devi=
ce
> back to the component, right?

Assuming you're moving to the single tree model, then I can easily do
this:

<real enclosure device>/<enclosure>/<enclosure component>/device -> lin=
k
to component device

with a back link in the component device pointing to the enclosure
component.

The way components work, probably blowing away enclosure_component_clas=
s
makes the most sense anyway.

James



--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
