From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sun, 16 Mar 2008 22:04:30 +0100
Message-ID: <1205701470.11374.66.camel@lov.site>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
	 <1205529619.2904.87.camel@localhost.localdomain>
	 <1205531922.3522.57.camel@lov.site>
	 <1205590788.6767.12.camel@localhost.localdomain>
	 <1205594256.3109.53.camel@lov.site>
	 <1205597776.6767.40.camel@localhost.localdomain>
	 <1205604260.3109.133.camel@lov.site>  <47DD8139.1040802@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.183]:58442 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYCPVDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Mar 2008 17:03:44 -0400
In-Reply-To: <47DD8139.1040802@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Sun, 2008-03-16 at 16:21 -0400, James Smart wrote:
> I'm not sure I'm following all of the threads, but several of the poi=
nts give
> me some concern.  Bear with me if I'm off in the weeds (and I assume =
you'll
> straighten me out).
>=20
> >> It wasn't designed like this; an interface sits off to the side.
> >=20
> > No, that's the way SCSI thinks it works, and unfortunately just
> > duplicates real devices in the class directory. Class scsi_device- =
and
> > scsi_host-devices are just 1:1 mirrors of the real bus devices. It =
just
> > makes things far more complicated than needed. There is no such thi=
ng as
> > "off the side interface" in the driver model or in sysfs, we just h=
ave
> > "devices".
>=20
> <ignoring the sas enclosure distinctions>
>=20
> Is this discussion about removing the class device device object ? at=
 least
> from the "class" directory and moving it into the /sys/devices tree ?

The directories move to /sys/devices, /sys/class is functionally the
same, but only a bunch of symlinks pointing to the devices instead of
real directories.

> E.g.
> Today, if I have a scsi hba, I have:
>   the scsi_host base device that is in the /sys/devices tree, which m=
ay then
>   have 2 other objects, a scsi_host device for the /sys/class/scsi_ho=
st
>   element and a fc_host device for the /sys/class/fc_host element.  T=
he base
>   device in /sys/devices has 2 symlinks of the form <class>:<nm_relat=
ive_to_class>,
>   and the /sys/class devices have a symlink, named "device" that poin=
ts back
>   to the base device in /sys/devices.

The class devices needed to be connected to their bus parents by the
"<class>:<name>" link and the "device" link, yes.
This became a real mess when people tried to put hierarchies between
class devices. So we deprecated the "lots of disconnected trees spread
around" model, and moved all into a single tree, with proper device
DEVPATH's, which include all the parent dependencies, for the devices.=20

> With the modification, you have:
>   the scsi_host base device that is in the /sys/devices tree, which t=
hen has
>   2 other devices underneath of it - one a scsi_host device (for the =
scsi_host
>   class) and the other a fc_host device (for the fc_host class).  The=
 naming
>   of <class>:<nm_relative_to_class> stays in the base device, but ins=
tead of
>   being symlinks these are real directories for the sub-devices. Out =
in /sys/class,
>   there is now a /sys/class/scsi_host/<nm1> that is a symlink back to=
 the
>   scsi_host class device, and similarly /sys/class/fc_host/<nm2> is a=
 symlink
>   back to the fc_host class device. And within the class devices, the=
re is a
>   "device" symlink to "..", mainly for compatibility ?

The class devices appear where they belong, below their parents. In
the /sys/class directories will be only symlinks. The "<class>:<name>"
links are  gone. The "device" link is not needed, it's just the next
parent device. It is still created at the moment, but will go away some
day.

> Did I follow this right ?
>=20
>=20
> > Since some releases. We talked about these plans and the way SCSI d=
oes
> > it in person at FreedomHEC.
> > The driver model is just too complicated, we are cleaning that up s=
tep
> > by step, and the completely inconsistent "class devices are interfa=
ces"
> > idea will completely go away. Sure, there will be symlinks preservi=
ng
> > the old interfaces/behavior.
>=20
> I'm confused... If what I described above is true, then yes, the clas=
s device
> become real devices, at least as far as there is only 1 device struct=
 and its
> always linked under /sys/devices and there's never a "device" object =
off to
> the side for the class.  But isn't there still an interface relations=
hip to
> each of these device structures ?  All this did was clean up where de=
vice
> structures live to a single place.

All devices live in /sys/devices/, all the rest is symlinks. All device=
s
will continue to exist, have the same names and attributes, and will
still looks the same, just all in one single hierarchy. The /sys/class/
directory will on be a classification directory to lookup devices in th=
e
tree, just like /sys/bus/*/devices/ was forever.

> > =EF=BB=BFWe talked about this extensively at LFS a few weeks ago. A=
nd Hannes
> > gave a whole talk about that. What does a 1:1 mirror of the same de=
vice,
> > other than having just doubled the number of devices, do good for u=
s?
> > Nothing but make it complicated to find information.=20
> >=20
> > SCSI bus devices have functional attributes on their own, so it's
> > completely inconsistent to split off _some_ of the functionality of=
f to
> > a second "mirror device" and call that an "interface".
> >=20
> > We have a SCSI target and host in the /sys/devices/ tree already, t=
here
> > is no reason to mirror anything in a class scsi_device, same for th=
e
> > scsi_host. Really, that "interface to a device" idea must die, it n=
ever
> > existed in the kernel code, only in some very confusing "documentat=
ion",
> > which will be replaced pretty soon.
>=20
> So, you are lobbying that we kill those devices for the class(es) and=
 simply
> put all the different interface sysfs attributes on the base device ?
> If so, I'm concerned about attribute namespace overlap, and just a co=
nglomeration of
> attributes on the base device. But I do like killing the other device=
 structures.

Only the 1:1 duplicated devices, both refcounted objects embedded in th=
e
same scsi struct, like scsi_device and scsi_host. We should move the
attributes to the real device, and create a symlink at the old place,
there is no need for two device directories for the same thing.

> > There will be no "device" link with any meaning with !SYSFS_DEPRECA=
TED,
> > only a single tree expressing _all_ core hierarchy, and flat
> > classification symlinks (/sys/bus,class) to lookup the devices in t=
he
> > single device tree. In the end, there will be no bus or class devic=
e
> > differences any userspace app would need to care about.
>=20
> which seems to jive with my description above, with the only exceptio=
n that the
> "device" symlink only exists if SYSFS_DEPRECATED.

It still exists in both cases, but it will go away some day.

> and from your other email thread :
>=20
>  > =EF=BB=BFWith !SYSFS_DEPRECATED <classname>:<devname> links are no=
 longer
>  > created for any device, the class device directories just live in =
a
>  > subdirectory with the class name.
>=20
> Well, the <classname> prefix came about because there was namespace o=
verlap
> between different classes (e.g. scsi_host and fc_host classes use the=
 same name,
> and I think where we originally saw this was in the way serial ports =
were enumerated
> for some base systems as well).
>=20
> So I don't see how you can kill the <classname>:<devname> names by SY=
SFS_DEPRECATED.

With SYSFS_DEPRECATED, nothing will change. But these links don't exist
with !SYSFS_DEPRECATED, because the class devices live in
subdirectories, named after the class they come from, there is no
namespace problem, or any problem to find these devices, you don't even
need readdir() to look them up.

Thanks,
Kay

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
