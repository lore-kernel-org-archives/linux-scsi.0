From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sat, 15 Mar 2008 09:19:48 -0500
Message-ID: <1205590788.6767.12.camel@localhost.localdomain>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
	 <1205529619.2904.87.camel@localhost.localdomain>
	 <1205531922.3522.57.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58641 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804AbYCOOTx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Mar 2008 10:19:53 -0400
In-Reply-To: <1205531922.3522.57.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Fri, 2008-03-14 at 22:58 +0100, Kay Sievers wrote:
> On Fri, 2008-03-14 at 16:20 -0500, James Bottomley wrote:
> > On Fri, 2008-03-14 at 12:15 -0500, James Bottomley wrote:
> > > On Thu, 2008-03-13 at 14:06 -0700, Greg KH wrote:
> > > > Here's a huge patch from Tony and Kay that converts the scsi la=
yer to
> > > > use struct device instead of class_device.
> > > >=20
> > > > It doesn't seem like it could be split up any smaller due to th=
e
> > > > interconectedness of the whole mess, if you have any suggestion=
s
> > > > otherwise, it would be appreciated.
> > > >=20
> > > > If you want, I can take this through my tree as it does depend =
on a
> > > > previous IB patch to make that portion of the patch much smalle=
r.
> > > >=20
> > > > After this, all of the class_device code is now finally gone fr=
om the
> > > > kernel!
> > >=20
> > > Actually, I have it built and running (actually 2.6.25-rc5-mc5 wh=
ich
> > > includes all the changes in your tree).  Amazingly it's pretty mu=
ch
> > > fully functional, except ses which seems to have suffered a break=
down in
> > > the way its model works.  I'll see if I can fix it up.
> >=20
> > OK, I looked at converting ses and enclosure, but it looks impossib=
le
> > given the way you've set all of this up (and at the moment it's alm=
ost
> > non functional).
> >=20
> > What it wants is for the enclosure and component devices to be arra=
nged
> > hierarchically under the enclosure class and then the device link o=
f the
> > components to be populated if they're actually present (which they =
might
> > not be).
> >=20
> > Given the fact that you've chosen to have dev->parent point to the
> > device the original class_device->dev was pointing to, there's almo=
st no
> > way left to express this relationship.  We can do it by having
> > kobj->parent point to the enclosure and dev->parent point to the
> > enclosed device, but I can't encapsulate that information into a st=
ruct
> > device alone.
> >=20
> > >From an interface point of view, this dual use of the parent point=
er
> > looks a bit nasty ... and you have some fun code to prove the point=
 in
> > drivers/base/core.c:get_device_parent()
> >=20
> > How about just adding a struct device *peer; entry to struct device=
 and
> > using it to express the former class relationship?  That way we can=
 do
> > all the parenting stuff correctly.
> >=20
> > Otherwise, I'm going to need something like a device_add_class_pare=
nt()
> > API that allows me to add these former class devices and set up the
> > kobject parent correctly.
>=20
> Unfortunately, the enclosure/enclusure-component/component-device
> relationship is not a tree. There is only a single "parent" for a
> device. The "device" link already expresses the parent device, and th=
e
> class devices will show up as childs of the devices, where the "devic=
e"
> link pointed to. There can't be a second device which could be used a=
s a
> parent.

But that's precisely my point: it is a tree; it's not a multi rooted
tree either.  Each enclosure has a fixed number of components (the bays
in the enclosure) that's a simple two level tree.  However, both the
enclosure and the components may point to devices in the regular tree
(bays only if the bay is actually populated).

This was formerly representable in the class_device infrastructure,
because class devices were allowed to have parents.  Class devices are
supposed to represent interfaces to devices and not all interfaces are
fully flat.

> =EF=BB=BFA sysfs class device hierarchy, and at the same let the "dev=
ice" link
> point to a different device is not supported. Existing userspace tool=
s
> do not support that.
>=20
> We have a similar problem for raid block devices, which can't be
> expressed in a single device tree. The "reverse tree" is constructed =
by
> custom holders/ slave/ directories at the devices.
>=20
> =EF=BB=BFI suggest to express the relationship of the enclosure compo=
nents to
> the enclosure device by custom symlinks, instead of expecting a "devi=
ce"
> link =EF=BB=BFmaintained by the core to build a "reverse tree".
>=20
> Would that work?

There are still several problems with the symlink approach; not least o=
f
which is that the component namespace isn't globally unique, it's only
unique to the enclosure:  If you have two separate enclosures connected=
,
they're likely each going to have a component called slot1 (the name is
actually take from the enclosure).  I also think we're going to have
difficulty going back from a component to an enclosure, which was prett=
y
much the whole point of the exercise but I need to get ses/enclosure
actually working to look at that.

James




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
