From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sat, 15 Mar 2008 16:17:36 +0100
Message-ID: <1205594256.3109.53.camel@lov.site>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
	 <1205529619.2904.87.camel@localhost.localdomain>
	 <1205531922.3522.57.camel@lov.site>
	 <1205590788.6767.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.183]:53640 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYCOPQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Mar 2008 11:16:51 -0400
In-Reply-To: <1205590788.6767.12.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Sat, 2008-03-15 at 09:19 -0500, James Bottomley wrote:
> On Fri, 2008-03-14 at 22:58 +0100, Kay Sievers wrote:
> > On Fri, 2008-03-14 at 16:20 -0500, James Bottomley wrote:
> > > On Fri, 2008-03-14 at 12:15 -0500, James Bottomley wrote:
> > > > On Thu, 2008-03-13 at 14:06 -0700, Greg KH wrote:
> > > > > Here's a huge patch from Tony and Kay that converts the scsi =
layer to
> > > > > use struct device instead of class_device.
> > > > >=20
> > > > > It doesn't seem like it could be split up any smaller due to =
the
> > > > > interconectedness of the whole mess, if you have any suggesti=
ons
> > > > > otherwise, it would be appreciated.
> > > > >=20
> > > > > If you want, I can take this through my tree as it does depen=
d on a
> > > > > previous IB patch to make that portion of the patch much smal=
ler.
> > > > >=20
> > > > > After this, all of the class_device code is now finally gone =
from the
> > > > > kernel!
> > > >=20
> > > > Actually, I have it built and running (actually 2.6.25-rc5-mc5 =
which
> > > > includes all the changes in your tree).  Amazingly it's pretty =
much
> > > > fully functional, except ses which seems to have suffered a bre=
akdown in
> > > > the way its model works.  I'll see if I can fix it up.
> > >=20
> > > OK, I looked at converting ses and enclosure, but it looks imposs=
ible
> > > given the way you've set all of this up (and at the moment it's a=
lmost
> > > non functional).
> > >=20
> > > What it wants is for the enclosure and component devices to be ar=
ranged
> > > hierarchically under the enclosure class and then the device link=
 of the
> > > components to be populated if they're actually present (which the=
y might
> > > not be).
> > >=20
> > > Given the fact that you've chosen to have dev->parent point to th=
e
> > > device the original class_device->dev was pointing to, there's al=
most no
> > > way left to express this relationship.  We can do it by having
> > > kobj->parent point to the enclosure and dev->parent point to the
> > > enclosed device, but I can't encapsulate that information into a =
struct
> > > device alone.
> > >=20
> > > >From an interface point of view, this dual use of the parent poi=
nter
> > > looks a bit nasty ... and you have some fun code to prove the poi=
nt in
> > > drivers/base/core.c:get_device_parent()
> > >=20
> > > How about just adding a struct device *peer; entry to struct devi=
ce and
> > > using it to express the former class relationship?  That way we c=
an do
> > > all the parenting stuff correctly.
> > >=20
> > > Otherwise, I'm going to need something like a device_add_class_pa=
rent()
> > > API that allows me to add these former class devices and set up t=
he
> > > kobject parent correctly.
> >=20
> > Unfortunately, the enclosure/enclusure-component/component-device
> > relationship is not a tree. There is only a single "parent" for a
> > device. The "device" link already expresses the parent device, and =
the
> > class devices will show up as childs of the devices, where the "dev=
ice"
> > link pointed to. There can't be a second device which could be used=
 as a
> > parent.
>=20
> But that's precisely my point: it is a tree; it's not a multi rooted
> tree either.

Hmm, the enclosure components have two parents in this model, the
enclosure itself _and_ the scsi device, so it's not a flat tree anymore=
=2E

>  Each enclosure has a fixed number of components (the bays
> in the enclosure) that's a simple two level tree.

I think it's not a second level, it's a second tree if you have two
parents for one single node. The driver core only supports one flat
device tree, and one parent relationship per device.

> However, both the
> enclosure and the components may point to devices in the regular tree
> (bays only if the bay is actually populated).

Sure, that's fine, but still, the component can have only one parent
managed by the core, we have only one single device tree
at /sys/devices/ and other relations should be expressed by the driver
itself.

> This was formerly representable in the class_device infrastructure,
> because class devices were allowed to have parents.

The "parent" field was something Greg added for trying to represent
"input", and it failed, existing userspace logic could not handle it,
and we immediately deprecated hierarchies in /sys/class. It was never
supposed to be used with the "dev" field pointing to a different device
at the same time.
As documented in Documentation/, all this "device" link magic we are
talking about, will only work in SYSFS_DEPRECATED=3Dy mode anyway, whic=
h
no recent distro uses anymore, and the enclosure stuff was added long
after that.

> Class devices are
> supposed to represent interfaces to devices

That's not true. Class devices are just devices, as documented in the
Documentation/ directory. Class devices are _not_ supposed to be
anything special, they just don't have drivers/binding in the kernel
internals - no other difference. There is no such thing as an
"interface" in the driver core or sysfs. Every device _is_ the interfac=
e
itself, otherwise devices would have no functional sysfs attributes.

It was one of the biggest mistakes to expose such a kernel
implementation details as different entities to userspace, and one
reason sysfs is that hard to understand. The guy who did all that just
ran away leaving all this mess behind him. :) And yes, we are too slow
cleaning all that up, but we will get there over time.
=EF=BB=BF
> and not all interfaces are
> fully flat.

True, but the core is only one flat tree, the drivers need to express
"reverse trees" themselves, just like the raid block devices do.

> > =EF=BB=BFA sysfs class device hierarchy, and at the same let the "d=
evice" link
> > point to a different device is not supported. Existing userspace to=
ols
> > do not support that.
> >=20
> > We have a similar problem for raid block devices, which can't be
> > expressed in a single device tree. The "reverse tree" is constructe=
d by
> > custom holders/ slave/ directories at the devices.
> >=20
> > =EF=BB=BFI suggest to express the relationship of the enclosure com=
ponents to
> > the enclosure device by custom symlinks, instead of expecting a "de=
vice"
> > link =EF=BB=BFmaintained by the core to build a "reverse tree".
> >=20
> > Would that work?
>=20
> There are still several problems with the symlink approach; not least=
 of
> which is that the component namespace isn't globally unique, it's onl=
y
> unique to the enclosure:  If you have two separate enclosures connect=
ed,
> they're likely each going to have a component called slot1 (the name =
is
> actually take from the enclosure).  I also think we're going to have
> difficulty going back from a component to an enclosure, which was pre=
tty
> much the whole point of the exercise but I need to get ses/enclosure
> actually working to look at that.

Hmm, I don't understand. The only thing that changed is that you don't
have a core-managed "device" link at the enclosure component anymore,
nothing else should be different. The namespace issue should be the sam=
e
as it was before, right?

We just need to create something like a "contains" link from the
component to the scsi device, and a "enclosure" link at the scsi device
back to the component, right?

Thanks,
Kay

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
