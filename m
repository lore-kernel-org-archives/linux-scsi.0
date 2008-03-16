From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sun, 16 Mar 2008 16:21:13 -0400
Message-ID: <47DD8139.1040802@emulex.com>
References: <20080313210655.GA13468@kroah.com>	 <1205514958.2904.27.camel@localhost.localdomain>	 <1205529619.2904.87.camel@localhost.localdomain>	 <1205531922.3522.57.camel@lov.site>	 <1205590788.6767.12.camel@localhost.localdomain>	 <1205594256.3109.53.camel@lov.site>	 <1205597776.6767.40.camel@localhost.localdomain> <1205604260.3109.133.camel@lov.site>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59478 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbYCPUVn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Mar 2008 16:21:43 -0400
In-Reply-To: <1205604260.3109.133.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

Kay, James,

I'm not sure I'm following all of the threads, but several of the point=
s give
me some concern.  Bear with me if I'm off in the weeds (and I assume yo=
u'll
straighten me out).

>> It wasn't designed like this; an interface sits off to the side.
>=20
> No, that's the way SCSI thinks it works, and unfortunately just
> duplicates real devices in the class directory. Class scsi_device- an=
d
> scsi_host-devices are just 1:1 mirrors of the real bus devices. It ju=
st
> makes things far more complicated than needed. There is no such thing=
 as
> "off the side interface" in the driver model or in sysfs, we just hav=
e
> "devices".

<ignoring the sas enclosure distinctions>

Is this discussion about removing the class device device object ? at l=
east
from the "class" directory and moving it into the /sys/devices tree ?

E.g.
Today, if I have a scsi hba, I have:
  the scsi_host base device that is in the /sys/devices tree, which may=
 then
  have 2 other objects, a scsi_host device for the /sys/class/scsi_host
  element and a fc_host device for the /sys/class/fc_host element.  The=
 base
  device in /sys/devices has 2 symlinks of the form <class>:<nm_relativ=
e_to_class>,
  and the /sys/class devices have a symlink, named "device" that points=
 back
  to the base device in /sys/devices.

With the modification, you have:
  the scsi_host base device that is in the /sys/devices tree, which the=
n has
  2 other devices underneath of it - one a scsi_host device (for the sc=
si_host
  class) and the other a fc_host device (for the fc_host class).  The n=
aming
  of <class>:<nm_relative_to_class> stays in the base device, but inste=
ad of
  being symlinks these are real directories for the sub-devices. Out in=
 /sys/class,
  there is now a /sys/class/scsi_host/<nm1> that is a symlink back to t=
he
  scsi_host class device, and similarly /sys/class/fc_host/<nm2> is a s=
ymlink
  back to the fc_host class device. And within the class devices, there=
 is a
  "device" symlink to "..", mainly for compatibility ?

Did I follow this right ?


> Since some releases. We talked about these plans and the way SCSI doe=
s
> it in person at FreedomHEC.
> The driver model is just too complicated, we are cleaning that up ste=
p
> by step, and the completely inconsistent "class devices are interface=
s"
> idea will completely go away. Sure, there will be symlinks preserving
> the old interfaces/behavior.

I'm confused... If what I described above is true, then yes, the class =
device
become real devices, at least as far as there is only 1 device struct a=
nd its
always linked under /sys/devices and there's never a "device" object of=
f to
the side for the class.  But isn't there still an interface relationshi=
p to
each of these device structures ?  All this did was clean up where devi=
ce
structures live to a single place.


> =EF=BB=BFWe talked about this extensively at LFS a few weeks ago. And=
 Hannes
> gave a whole talk about that. What does a 1:1 mirror of the same devi=
ce,
> other than having just doubled the number of devices, do good for us?
> Nothing but make it complicated to find information.=20
>=20
> SCSI bus devices have functional attributes on their own, so it's
> completely inconsistent to split off _some_ of the functionality off =
to
> a second "mirror device" and call that an "interface".
>=20
> We have a SCSI target and host in the /sys/devices/ tree already, the=
re
> is no reason to mirror anything in a class scsi_device, same for the
> scsi_host. Really, that "interface to a device" idea must die, it nev=
er
> existed in the kernel code, only in some very confusing "documentatio=
n",
> which will be replaced pretty soon.

So, you are lobbying that we kill those devices for the class(es) and s=
imply
put all the different interface sysfs attributes on the base device ?
If so, I'm concerned about attribute namespace overlap, and just a cong=
lomeration of
attributes on the base device. But I do like killing the other device s=
tructures.

> There will be no "device" link with any meaning with !SYSFS_DEPRECATE=
D,
> only a single tree expressing _all_ core hierarchy, and flat
> classification symlinks (/sys/bus,class) to lookup the devices in the
> single device tree. In the end, there will be no bus or class device
> differences any userspace app would need to care about.

which seems to jive with my description above, with the only exception =
that the
"device" symlink only exists if SYSFS_DEPRECATED.


and from your other email thread :

 > =EF=BB=BFWith !SYSFS_DEPRECATED <classname>:<devname> links are no l=
onger
 > created for any device, the class device directories just live in a
 > subdirectory with the class name.

Well, the <classname> prefix came about because there was namespace ove=
rlap
between different classes (e.g. scsi_host and fc_host classes use the s=
ame name,
and I think where we originally saw this was in the way serial ports we=
re enumerated
for some base systems as well).

So I don't see how you can kill the <classname>:<devname> names by SYSF=
S_DEPRECATED.

-- james s

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
