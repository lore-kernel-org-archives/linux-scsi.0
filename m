From: Guillaume Bedot <littletux-QFiJtcdG+fw@public.gmane.org>
Subject: Re: [usb-storage] PATCH: usb-storage-set-last-sector-bug-flag.patch
Date: Sun, 20 Jan 2008 22:39:19 +0100
Message-ID: <1200865159.7104.22.camel@localhost>
References: <47932211.90105@hhs.nl>  <20080120205625.GB28842@kroah.com>
	 <1200863008.3105.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1200863008.3105.30.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, USB development list <linux-usb-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


Le dimanche 20 janvier 2008 =C3=A0 15:03 -0600, James Bottomley a =C3=A9=
crit :
> On Sun, 2008-01-20 at 12:56 -0800, Greg KH wrote:
> > On Sun, Jan 20, 2008 at 11:27:29AM +0100, Hans de Goede wrote:
> > > Hi all,
> > >
> > > This patch sets the last_sector_bug flag to 1 for all USB disks. =
This is
> > > needed to makes the cardreader on various HP multifunction printe=
rs work.
> > >
> > > Since the performance impact is negible we set this flag for all =
USB disks=20
> > > to avoid an unusual_devs.h nightmare.
> >=20
> > Oh great, now my "working just fine" USB devices, which happen to h=
ave
> > data in the last sector, suddenly stop working.
> >=20
> > That's not acceptable :(
>=20
> I don't see how this will happen, might you not be confusing this cha=
nge
> (which allows access to the last sector, just insists that it be
> accessed by a single sector read) with US_FL_FIX_CAPACITY which is fo=
r
> devices that report having one more sectors than they actually have a=
nd
> therefore adjusts the access limits down by one?

Well, i was the one suggesting more than 2 devices might be impacted
(i'm absolutely not sure about this, but it could be).
It seems caused by a common error when using 0 as a base index.

I don't like loosing performance for broken devices, but i'm not agains=
t
keeping that patch for all devices.

1) As the last sectors are read when the card is inserted, it results i=
n
not working at all devices :
Users may think they are just not supported, and won't report any bug.
See how Hans worked hard to find 3 other cases in fedora, ubuntu, etc
forums !

2) It should not break in the other cases, IIUC, it just splits the rea=
d
in two.

3) It's just about the last sector, so any issue should only be greater
timing when using realtime perhaps ?

Whatever, this patch, or an other form of it, is needed (because of
1) ).
If it is a default, an option or dedicated to a limited set of devices
must be chosen.

I hope you will soon find this solution.

Best regards,

Guillaume B.
