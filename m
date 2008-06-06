From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Fri, 06 Jun 2008 13:40:12 -0500
Message-ID: <1212777612.16182.21.camel@localhost.localdomain>
References: <200806010415.05290.chris2553@googlemail.com>
	 <20080605221709.f248eb90.akpm@linux-foundation.org>
	 <200806060607.29460.chris2553@googlemail.com>
	 <20080605232145.cdae753f.akpm@linux-foundation.org>
	 <20080605232538.fb85021e.akpm@linux-foundation.org>
	 <1212765742.16182.8.camel@localhost.localdomain>
	 <20080606110345.581fdc77.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40443 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbYFFSkU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 14:40:20 -0400
In-Reply-To: <20080606110345.581fdc77.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: chris2553@googlemail.com, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>

On Fri, 2008-06-06 at 11:03 -0700, Andrew Morton wrote:
> On Fri, 06 Jun 2008 10:22:22 -0500 James Bottomley <James.Bottomley@H=
ansenPartnership.com> wrote:
>=20
> > On Thu, 2008-06-05 at 23:25 -0700, Andrew Morton wrote:
> > > On Thu, 5 Jun 2008 23:21:45 -0700 Andrew Morton <akpm@linux-found=
ation.org> wrote:
> > >=20
> > > > <watches wodim wibble for five minutes then report "CD/DVD-Reco=
rder
> > > > not ready."  Pretends not to have noticed.>
> > >=20
> > > It goes much better when the CD is inserted upside up.
> >=20
> > So I can close this regression if I send you a pack of CD ring labe=
ls
> > with "other way up" on them for you to affix to the underside of yo=
ur
> > CDs ... ?
> >=20
>=20
> Would prefer double-sided CDs.

I just discovered my budget only runs to a permanent marker for you to
write the instructions on the rim yourself ...

> Is this 20-second-delay thing known-about/expected/etc?

If it's not the scsi_bus_uevent problem, then no, it isn't.

The odd thing is that it occurs in the middle of USB initialisation fro=
m
the log:

> =EF=BB=BFJun  6 17:25:19 upstairs kernel: uhci_hcd 0000:00:1d.0: UHCI=
 Host Controller=20
> Jun  6 17:25:19 upstairs kernel: uhci_hcd 0000:00:1d.0: new USB bus r=
egistered, assigned bus number 1=20
> Jun  6 17:25:19 upstairs kernel: uhci_hcd 0000:00:1d.0: irq 16, io ba=
se 0x0000a800=20
> Jun  6 17:25:19 upstairs kernel: usb usb1: configuration #1 chosen fr=
om 1 choice=20
> Jun  6 17:25:19 upstairs kernel: hub 1-0:1.0: USB hub found=20
> Jun  6 17:25:19 upstairs kernel: hub 1-0:1.0: 2 ports detected=20
> Jun  6 17:25:44 upstairs kernel: ohci_hcd: 2006 August 04 USB 1.1 'Op=
en' Host Controller (OHCI) Driver=20
> Jun  6 17:25:44 upstairs kernel: usb usb1: New USB device found, idVe=
ndor=3D1d6b, idProduct=3D0001=20
> Jun  6 17:25:44 upstairs kernel: usb usb1: New USB device strings: Mf=
r=3D3, Product=3D2, SerialNumber=3D1=20
> Jun  6 17:25:44 upstairs kernel: usb usb1: Product: UHCI Host Control=
ler=20
> Jun  6 17:25:44 upstairs kernel: usb usb1: Manufacturer: Linux 2.6.26=
-rc5 uhci_hcd=20

Note the jump from 19 to 44 seconds.

There's another one here:


> =EF=BB=BFJun  6 17:25:44 upstairs kernel: EXT3-fs: mounted filesystem=
 with ordered data mode.=20
> Jun  6 17:25:44 upstairs kernel: Adding 4096532k swap on /dev/sda5.  =
Priority:-1 extents:1 across:4096532k=20
> Jun  6 17:25:44 upstairs kernel: eth0: link up, 100Mbps, full-duplex,=
 lpa 0x45E1=20
> Jun  6 17:25:44 upstairs kernel: ip_tables: (C) 2000-2006 Netfilter C=
ore Team=20
> Jun  6 17:25:44 upstairs kernel: nf_conntrack version 0.5.0 (16384 bu=
ckets, 65536 max)=20
> Jun  6 17:25:44 upstairs kernel: parport_pc 00:06: disabled=20
> Jun  6 17:25:44 upstairs kernel: pnp: the driver 'parport_pc' has bee=
n unregistered=20
> Jun  6 17:25:44 upstairs kernel: ieee1394: Node removed: ID:BUS[0-00:=
1023]  GUID[00110666000013cc]=20
> Jun  6 17:26:31 upstairs kernel: usb 11-2: new high speed USB device =
using ehci_hcd and address 3=20
> Jun  6 17:26:31 upstairs kernel: usb 11-2: configuration #1 chosen fr=
om 1 choice=20
> Jun  6 17:26:31 upstairs kernel: usb 11-2: New USB device found, idVe=
ndor=3D0930, idProduct=3D6545=20
> Jun  6 17:26:31 upstairs kernel: usb 11-2: New USB device strings: Mf=
r=3D0, Product=3D2, SerialNumber=3D3=20
> Jun  6 17:26:31 upstairs kernel: usb 11-2: Product: USB Flash Memory=20
> Jun  6 17:26:31 upstairs kernel: usb 11-2: SerialNumber: 0EC065712361=
A91E=20


I'm a bit baffled as to how that could be SCSI related, but I suppose i=
t
could be udev related somehow.  Perhaps turning on driver core debuggin=
g
might help (that's CONFIG_DEBUG DRIVER ... it depends on
CONFIG_DEBUG_KERNEL for activation).  Hopefully the verbose kernel logs
from here might tell us what's going on in the lacunae.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
