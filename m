From: Nir Livni <nirl@cyber-ark.com>
Subject: RE: How to build a RedHat driver disk (fusion mpt)]]
Date: Mon, 24 Nov 2003 15:40:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <93F63181B5926E4FA7A5AD02389244940AD87F@ca-prod2.cyber-ark.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxout2.netvision.net.il ([194.90.9.21]:46992 "EHLO
	mxout2.netvision.net.il") by vger.kernel.org with ESMTP
	id S263439AbTKXNhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2003 08:37:08 -0500
Received: from cyber-ark.com ([194.90.225.102]) by mxout2.netvision.net.il
 (iPlanet Messaging Server 5.2 HotFix 1.14 (built Mar 18 2003))
 with SMTP id <0HOU00CT3Z5TGY@mxout2.netvision.net.il> for
 linux-scsi@vger.kernel.org; Mon, 24 Nov 2003 15:37:06 +0200 (IST)
Received: from outgw.cyber-ark.com (127.0.0.1)	by cyber-ark.com (127.0.0.1)
 with [XMail 0.64 (Win32) SMTP Server]	for <linux-scsi@vger.kernel.org> from
 <nirl@cyber-ark.com>; Mon, 24 Nov 2003 15:37:22 +0200
Received: from CA-PROD2.cyber-ark.co.il (192.168.41.203)
	by cyber-ark.co.il (192.168.41.34) with [XMail 0.64 (Win32)
 SMTP Server]	for <linux-scsi@vger.kernel.org> from <nirl@cyber-ark.com>; Mon,
 24 Nov 2003 15:40:35 +0200
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Josef M?llers <josef.moellers@fujitsu-siemens.com>

I am trying to compile the mpt modules again.
It seems that kernel < 2.4.18 require a kernel patch to support fusion =
mpt.

I used make oldconfig to reconfigure the kernel, and added the MPT FUSI=
ON support for modules.

How can I re-create the kernel rpm , so I can replace the rpm exists in=
 my installation cd ?

Thanks,
Nir

>=20
>=20
> > Nir Livni wrote:
> >=20
> > So far so good...
> > That's almost identical to what I've done.
> > I took the original driver disk (2.4.9-e.3smp), and replaced the=20
> > modname.o with a compiled modname.o of my kernel. RedHat identifies=
=20
> > the modules in the driver disk, but when I ask to load the driver=20
> > (using linux dd noprobe when installing) -
> >=20
> > I always get "failed to insert modname.o module".
>=20
> You should be able to get some more information by switching=20
> to an alternate console.
>=20
> > I suspect I do not compile the module as I should.
> >=20
> > The kernel rpm is kernel-smp-2.4.9-e.5.i686.rpm.
> >=20
> > I installed this rpm on a temporary smp PC, with an IDE=20
> controller. I=20
> > uploaded the sources and tried to follow the build=20
> instructions, with=20
> > no special configuration.
>=20
> As Martin wrote, you do need to use the exact configuration=20
> of the kernel. If you have the kernel source installed on y=20
> system, check the /usr/src/linux/configs directory. There=20
> should be a file ...BOOT... which you should use as the=20
> .config file for your installation kernel.
>=20
> > The replaced the *.o files in the disk with my new built=20
> modules. But=20
> > still - no good.
>=20
> > > I've asked my colleague who does all the drivers ...
> > >
> > > > Wilck Martin wrote:
> > > >
> > > > >>Nir Livni wrote:
> > > >  >>I would like to know how can I build a driver disk for
> > > this kernel,
> > > >
> > > > create a driectory structure that looks like this
> > > >
> > > > 2.4.9-e.5
> > > >         modname.o
> > > >         ...
> > > > 2.4.9-e.5BOOT
> > > >         modname.o
> > > >         ...
> > > > 2.4.9-e.5smp
> > > >         modname.o
> > > >         ...
> > > > ...
> > > >
> > > > Of course, the respective .o files must have been compiled
> > > against a
> > > > properly configured kernel. "modname" stands for the=20
> name of your=20
> > > > driver.
> > > >
> > > > At the top of that structure, create a compressed cpio archive
> > like
> > > > this:
> > > >
> > > > find . -depth | cpio -H crc 2>/dev/null | gzip -qc -=20
> >modules.cgz
> > > >
> > > > copy the file "modules.cgz" to a DOS- or ext2-formatted floppy.=
=20
> > > > Besides "modules.cgz", the floppy must contain
> > > >
> > > > 1. a file "modinfo" in the following format:
> > > >
> > > > modname
> > > >         scsi
> > > >         "description of driver"
> > > >
> > > > Caution: TABs at the beginning line 2 and 3!
> > > >
> > > > 2. a file "modules.dep" in the following format:
> > > > modname:        scsi_mod
> > > >
> > > > (scsi_mod is usually the only prerequisite needed)
> > > >
> > > > 3. a file "pcitable" in the following format:
> > > > 0xdead  0xbeef  "modname"       "description of device"
> > > > ...
> > > >
> > > > Caution: TAB as field separator!
> > > > This list must contain the PCI vendor and device IDs of
> > > your device
> > > > in the 1st and 2nd field. The easiest way to obtain=20
> these is from
> > an
> > > > existing driver disk for a different kernel. Alternatively, you
> > can
> > > > read
> > > > the driver source to find them out.
> > > >
> > > > 4. a file called "rhdd-6.1" with a free-format=20
> description of the=20
> > > > floppy
> > > >
> > > > 5. an empty file called "up"
> > > >
> > > > Good luck,
> > > > Martin
> > > >
> > > > --
> > > > Martin Wilck                Phone: +49 5251 8 15113
> > > > Fujitsu Siemens Computers   Fax:   +49 5251 8 20409
> > > > Heinz-Nixdorf-Ring 1
> > mailto:Martin.Wilck@Fujitsu-Siemens.com
> > > > D-33106 Paderborn
> > http://www.fujitsu-siemens.com/primergy
> > >
> > > --
> > > Josef M=F6llers (Pinguinpfleger bei FSC)
> > >       If failure had no penalty success would not be a prize
> > >                                               -- T.  Pratchett
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe=20
> > > linux-scsi" in the body of a message to majordomo@vger.kernel.org=
=20
> > > More majordomo info at http://vger.kernel.org/majordomo-info.html
> > >
>=20
> --=20
> Josef M=F6llers (Pinguinpfleger bei FSC)
> 	If failure had no penalty success would not be a prize
> 						-- T.  Pratchett
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
