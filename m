From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Fri, 14 Mar 2008 22:58:42 +0100
Message-ID: <1205531922.3522.57.camel@lov.site>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
	 <1205529619.2904.87.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:64669 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbYCNV5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Mar 2008 17:57:52 -0400
In-Reply-To: <1205529619.2904.87.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Fri, 2008-03-14 at 16:20 -0500, James Bottomley wrote:
> On Fri, 2008-03-14 at 12:15 -0500, James Bottomley wrote:
> > On Thu, 2008-03-13 at 14:06 -0700, Greg KH wrote:
> > > Here's a huge patch from Tony and Kay that converts the scsi laye=
r to
> > > use struct device instead of class_device.
> > >=20
> > > It doesn't seem like it could be split up any smaller due to the
> > > interconectedness of the whole mess, if you have any suggestions
> > > otherwise, it would be appreciated.
> > >=20
> > > If you want, I can take this through my tree as it does depend on=
 a
> > > previous IB patch to make that portion of the patch much smaller.
> > >=20
> > > After this, all of the class_device code is now finally gone from=
 the
> > > kernel!
> >=20
> > Actually, I have it built and running (actually 2.6.25-rc5-mc5 whic=
h
> > includes all the changes in your tree).  Amazingly it's pretty much
> > fully functional, except ses which seems to have suffered a breakdo=
wn in
> > the way its model works.  I'll see if I can fix it up.
>=20
> OK, I looked at converting ses and enclosure, but it looks impossible
> given the way you've set all of this up (and at the moment it's almos=
t
> non functional).
>=20
> What it wants is for the enclosure and component devices to be arrang=
ed
> hierarchically under the enclosure class and then the device link of =
the
> components to be populated if they're actually present (which they mi=
ght
> not be).
>=20
> Given the fact that you've chosen to have dev->parent point to the
> device the original class_device->dev was pointing to, there's almost=
 no
> way left to express this relationship.  We can do it by having
> kobj->parent point to the enclosure and dev->parent point to the
> enclosed device, but I can't encapsulate that information into a stru=
ct
> device alone.
>=20
> >From an interface point of view, this dual use of the parent pointer
> looks a bit nasty ... and you have some fun code to prove the point i=
n
> drivers/base/core.c:get_device_parent()
>=20
> How about just adding a struct device *peer; entry to struct device a=
nd
> using it to express the former class relationship?  That way we can d=
o
> all the parenting stuff correctly.
>=20
> Otherwise, I'm going to need something like a device_add_class_parent=
()
> API that allows me to add these former class devices and set up the
> kobject parent correctly.

Unfortunately, the enclosure/enclusure-component/component-device
relationship is not a tree. There is only a single "parent" for a
device. The "device" link already expresses the parent device, and the
class devices will show up as childs of the devices, where the "device"
link pointed to. There can't be a second device which could be used as =
a
parent.
=EF=BB=BFA sysfs class device hierarchy, and at the same let the "devic=
e" link
point to a different device is not supported. Existing userspace tools
do not support that.

We have a similar problem for raid block devices, which can't be
expressed in a single device tree. The "reverse tree" is constructed by
custom holders/ slave/ directories at the devices.

=EF=BB=BFI suggest to express the relationship of the enclosure compone=
nts to
the enclosure device by custom symlinks, instead of expecting a "device=
"
link =EF=BB=BFmaintained by the core to build a "reverse tree".

Would that work?

Thanks,
Kay

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
