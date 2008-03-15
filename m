From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sat, 15 Mar 2008 19:04:20 +0100
Message-ID: <1205604260.3109.133.camel@lov.site>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
	 <1205529619.2904.87.camel@localhost.localdomain>
	 <1205531922.3522.57.camel@lov.site>
	 <1205590788.6767.12.camel@localhost.localdomain>
	 <1205594256.3109.53.camel@lov.site>
	 <1205597776.6767.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61715 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYCOSDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Mar 2008 14:03:34 -0400
In-Reply-To: <1205597776.6767.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Sat, 2008-03-15 at 11:16 -0500, James Bottomley wrote:
> On Sat, 2008-03-15 at 16:17 +0100, Kay Sievers wrote:
> > On Sat, 2008-03-15 at 09:19 -0500, James Bottomley wrote:
> > > On Fri, 2008-03-14 at 22:58 +0100, Kay Sievers wrote:
> > > > On Fri, 2008-03-14 at 16:20 -0500, James Bottomley wrote:
> > > > Unfortunately, the enclosure/enclusure-component/component-devi=
ce
> > > > relationship is not a tree. There is only a single "parent" for=
 a
> > > > device. The "device" link already expresses the parent device, =
and the
> > > > class devices will show up as childs of the devices, where the =
"device"
> > > > link pointed to. There can't be a second device which could be =
used as a
> > > > parent.
> > >=20
> > > But that's precisely my point: it is a tree; it's not a multi roo=
ted
> > > tree either.
> >=20
> > Hmm, the enclosure components have two parents in this model, the
> > enclosure itself _and_ the scsi device, so it's not a flat tree any=
more.
>=20
> Only because you're expressing the class relationship as a parent.

It's that way forever. There are no hierarchies in /sys/class, no
existing tool supports that, or plans to support it, and the "device"
link was always the single parent of a class device, or it had no paren=
t
at all.

> It wasn't designed like this; an interface sits off to the side.

No, that's the way SCSI thinks it works, and unfortunately just
duplicates real devices in the class directory. Class scsi_device- and
scsi_host-devices are just 1:1 mirrors of the real bus devices. It just
makes things far more complicated than needed. There is no such thing a=
s
"off the side interface" in the driver model or in sysfs, we just have
"devices".

> > >  Each enclosure has a fixed number of components (the bays
> > > in the enclosure) that's a simple two level tree.
> >=20
> > I think it's not a second level, it's a second tree if you have two
> > parents for one single node. The driver core only supports one flat
> > device tree, and one parent relationship per device.
> >=20
> > > However, both the
> > > enclosure and the components may point to devices in the regular =
tree
> > > (bays only if the bay is actually populated).
> >=20
> > Sure, that's fine, but still, the component can have only one paren=
t
> > managed by the core, we have only one single device tree
> > at /sys/devices/ and other relations should be expressed by the dri=
ver
> > itself.
> >=20
> > > This was formerly representable in the class_device infrastructur=
e,
> > > because class devices were allowed to have parents.
> >=20
> > The "parent" field was something Greg added for trying to represent
> > "input", and it failed, existing userspace logic could not handle i=
t,
> > and we immediately deprecated hierarchies in /sys/class. It was nev=
er
> > supposed to be used with the "dev" field pointing to a different de=
vice
> > at the same time.
> > As documented in Documentation/, all this "device" link magic we ar=
e
> > talking about, will only work in SYSFS_DEPRECATED=3Dy mode anyway, =
which
> > no recent distro uses anymore, and the enclosure stuff was added lo=
ng
> > after that.
>=20
> OK, where is this?  There's no mention of any deprecation in
> Documentation/driver-model; grep -i deprec returns an empty list.

Documentation/sysfs-rules.txt

"- devices are only "devices"
  There is no such thing like class-, bus-, physical devices,
  interfaces, and such that you can rely on in userspace. Everything is
  just simply a "device". Class-, bus-, physical, ... types are just
  kernel implementation details which should not be expected by
  applications that look for devices in sysfs."

"- Hierarchy in a single device tree
  There is only one valid place in sysfs where hierarchy can be examine=
d
  and this is below: /sys/devices.
  It is planned that all device directories will end up in the tree
  below this directory."

> > > Class devices are
> > > supposed to represent interfaces to devices
> >=20
> > That's not true. Class devices are just devices, as documented in t=
he
> > Documentation/ directory.
>=20
> OK, which kernel is this?  The latest greatest upstream merge kernel =
I
> know is 2.6.25-rc5-mc6 and that says

Since some releases. We talked about these plans and the way SCSI does
it in person at FreedomHEC.
The driver model is just too complicated, we are cleaning that up step
by step, and the completely inconsistent "class devices are interfaces"
idea will completely go away. Sure, there will be symlinks preserving
the old interfaces/behavior.

> Documentation/driver-model/class.txt:
> [...]
> Each device class defines a set of semantics and a programming interf=
ace
> that devices of that class adhere to. Device drivers are the
> implementation of that programming interface for a particular device =
on
> a particular bus.
>=20
> The "programming interface" bit seems pretty clear to me.
>=20
> The whole of SCSI use of the driver model is designed around the
> interface concept.  Essentially, SCSI device represents the generic
> object that sits on the end of the bus. We export one set of interfac=
es
> from the upper layer driver that binds (st, sd, sr etc.) we express
> another through the SCSI generic, and we express a third (or more)
> through the transport class interfaces.

Sure, that all makes sense. All what I say, is that we can't have two
driver core parents for the same device, which is only the case for
enclosure, not for all the other stuff you mention. To express the
second parent is the responsibility of the driver itself, not to be don=
e
by the core.

> In theory, we could express all this as simply additional attribute
> groups on the generic SCSI device or use a parent/child device
> relationship for them, or something else ...  This is the piece I sti=
ll
> don't get from you and Greg.  Just saying it isn't an interface any m=
ore
> doesn't help me in this regard.

=EF=BB=BFWe talked about this extensively at LFS a few weeks ago. And H=
annes
gave a whole talk about that. What does a 1:1 mirror of the same device=
,
other than having just doubled the number of devices, do good for us?
Nothing but make it complicated to find information.=20

SCSI bus devices have functional attributes on their own, so it's
completely inconsistent to split off _some_ of the functionality off to
a second "mirror device" and call that an "interface".

We have a SCSI target and host in the /sys/devices/ tree already, there
is no reason to mirror anything in a class scsi_device, same for the
scsi_host. Really, that "interface to a device" idea must die, it never
existed in the kernel code, only in some very confusing "documentation"=
,
which will be replaced pretty soon.

> >  Class devices are _not_ supposed to be
> > anything special, they just don't have drivers/binding in the kerne=
l
> > internals - no other difference. There is no such thing as an
> > "interface" in the driver core or sysfs. Every device _is_ the inte=
rface
> > itself, otherwise devices would have no functional sysfs attributes=
=2E
>=20
> But if the actual class documentation doesn't say this, how am I
> supposed to know it?  I keep asking what you're planning but I don't =
get
> a complete response.

I completely agree, its not as it should be. We talked about that
problem in person several times though, but there is no decent
documentation to read, only the sysfs-rules file.

> If I had to guess, I'd say eventually you want all classes to fold up
> under the device directory (hence the parent pointer) and so be part =
of
> a continuous tree ... is that it?

There will be no "device" link with any meaning with !SYSFS_DEPRECATED,
only a single tree expressing _all_ core hierarchy, and flat
classification symlinks (/sys/bus,class) to lookup the devices in the
single device tree. In the end, there will be no bus or class device
differences any userspace app would need to care about.

> > It was one of the biggest mistakes to expose such a kernel
> > implementation details as different entities to userspace, and one
> > reason sysfs is that hard to understand. The guy who did all that j=
ust
> > ran away leaving all this mess behind him. :) And yes, we are too s=
low
> > cleaning all that up, but we will get there over time.
> > =EF=BB=BF
> > > and not all interfaces are
> > > fully flat.
> >=20
> > True, but the core is only one flat tree, the drivers need to expre=
ss
> > "reverse trees" themselves, just like the raid block devices do.
> >=20
> > > > =EF=BB=BFA sysfs class device hierarchy, and at the same let th=
e "device" link
> > > > point to a different device is not supported. Existing userspac=
e tools
> > > > do not support that.
> > > >=20
> > > > We have a similar problem for raid block devices, which can't b=
e
> > > > expressed in a single device tree. The "reverse tree" is constr=
ucted by
> > > > custom holders/ slave/ directories at the devices.
> > > >=20
> > > > =EF=BB=BFI suggest to express the relationship of the enclosure=
 components to
> > > > the enclosure device by custom symlinks, instead of expecting a=
 "device"
> > > > link =EF=BB=BFmaintained by the core to build a "reverse tree".
> > > >=20
> > > > Would that work?
> > >=20
> > > There are still several problems with the symlink approach; not l=
east of
> > > which is that the component namespace isn't globally unique, it's=
 only
> > > unique to the enclosure:  If you have two separate enclosures con=
nected,
> > > they're likely each going to have a component called slot1 (the n=
ame is
> > > actually take from the enclosure).  I also think we're going to h=
ave
> > > difficulty going back from a component to an enclosure, which was=
 pretty
> > > much the whole point of the exercise but I need to get ses/enclos=
ure
> > > actually working to look at that.
> >=20
> > Hmm, I don't understand. The only thing that changed is that you do=
n't
> > have a core-managed "device" link at the enclosure component anymor=
e,
> > nothing else should be different. The namespace issue should be the=
 same
> > as it was before, right?
>=20
> No, the way you broke it was removing the functioning component link.

No, enclosure used the core in a way it isn't supposed to work. As we
have no opaque structures in the kernel, we have no way to prevent
anyone from assigning something to a pointer in a core structure, but
that does not make it work as expected.
Even before this patch, it didn't work with !SYSFS_DEPRECATED, and that
exists much longer than enclosure exists, and is what is used for new
distros.

> If you boot now, all components are linked to the enclosure devices, =
not
> the component devices ... I can fix this easily, I'm still just tryin=
g
> to figure out how you want it represented.

Yes, but that happens only in SYSFS_DEPRECATED mode, which just does no=
t
allow a class device hierarchy like enclosure tries to establish. With
!SYSFS_DEPRECATED, you still have the expected hierarchy
in /sys/devices/.

> > We just need to create something like a "contains" link from the
> > component to the scsi device, and a "enclosure" link at the scsi de=
vice
> > back to the component, right?
>=20
> Assuming you're moving to the single tree model, then I can easily do
> this:
>=20
> <real enclosure device>/<enclosure>/<enclosure component>/device -> l=
ink
> to component device

Yes, sounds good. Only that there will be no meaningful "device" link
with !SYSFS_DEPRECATED, we need a custom link, maintained by the
enclosure itself, to do that.

> with a back link in the component device pointing to the enclosure
> component.

That sounds fine.

> The way components work, probably blowing away enclosure_component_cl=
ass
> makes the most sense anyway.

If we go for a single class, can't we express enclosures and components
in the device name and put them in the same class like:
/sys/class/enclosure/
|- enclosure1 -> ../../../devices/<...>/enclosure1
|- enclosure1.slot1 -> ../../../../devices/<...>/enclosure1/enclosure1.=
slot1
|- enclosure1.slot2 -> ../../../../devices/<...>/enclosure1/enclosure1.=
slot2
|- enclosure2 -> =EF=BB=BF../../../devices/<...>/enclosure2
|- enclosure2.slot1 -> =EF=BB=BF-> ../../../../devices/<...>/enclosure1=
/enclosure2.slot1
=2E..
=20
while /sys/devices/<...>/enclosure1/enclosure1.slot1/ has a something
like a "contains" link pointing to the SCSI device, and the SCSI device
an "enclosure" link back?

Thanks,
Kay

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
