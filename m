From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: Re: How to build a RedHat driver disk (fusion mpt)]]
Date: Mon, 24 Nov 2003 15:18:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC2131B.43902165@fujitsu-siemens.com>
References: <93F63181B5926E4FA7A5AD02389244940AD87F@ca-prod2.cyber-ark.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plim.fujitsu-siemens.com ([217.115.66.8]:55599 "EHLO
	plim.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S263596AbTKXOQC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2003 09:16:02 -0500
List-Id: linux-scsi@vger.kernel.org
To: Nir Livni <nirl@cyber-ark.com>
Cc: linux-scsi@vger.kernel.org

> Nir Livni wrote:
>=20
> I am trying to compile the mpt modules again.
> It seems that kernel < 2.4.18 require a kernel patch to support fusio=
n
> mpt.

I can't help any further.
Sorry.

> I used make oldconfig to reconfigure the kernel, and added the MPT
> FUSION support for modules.
>=20
> How can I re-create the kernel rpm , so I can replace the rpm exists
> in my installation cd ?
>=20
> Thanks,
> Nir
>=20
> >
> >
> > > Nir Livni wrote:
> > >
> > > So far so good...
> > > That's almost identical to what I've done.
> > > I took the original driver disk (2.4.9-e.3smp), and replaced the
> > > modname.o with a compiled modname.o of my kernel. RedHat
> identifies
> > > the modules in the driver disk, but when I ask to load the driver
> > > (using linux dd noprobe when installing) -
> > >
> > > I always get "failed to insert modname.o module".
> >
> > You should be able to get some more information by switching
> > to an alternate console.
> >
> > > I suspect I do not compile the module as I should.
> > >
> > > The kernel rpm is kernel-smp-2.4.9-e.5.i686.rpm.
> > >
> > > I installed this rpm on a temporary smp PC, with an IDE
> > controller. I
> > > uploaded the sources and tried to follow the build
> > instructions, with
> > > no special configuration.
> >
> > As Martin wrote, you do need to use the exact configuration
> > of the kernel. If you have the kernel source installed on y
> > system, check the /usr/src/linux/configs directory. There
> > should be a file ...BOOT... which you should use as the
> > .config file for your installation kernel.
> >
> > > The replaced the *.o files in the disk with my new built
> > modules. But
> > > still - no good.
> >
> > > > I've asked my colleague who does all the drivers ...
> > > >
> > > > > Wilck Martin wrote:
> > > > >
> > > > > >>Nir Livni wrote:
> > > > >  >>I would like to know how can I build a driver disk for
> > > > this kernel,
> > > > >
> > > > > create a driectory structure that looks like this
> > > > >
> > > > > 2.4.9-e.5
> > > > >         modname.o
> > > > >         ...
> > > > > 2.4.9-e.5BOOT
> > > > >         modname.o
> > > > >         ...
> > > > > 2.4.9-e.5smp
> > > > >         modname.o
> > > > >         ...
> > > > > ...
> > > > >
> > > > > Of course, the respective .o files must have been compiled
> > > > against a
> > > > > properly configured kernel. "modname" stands for the
> > name of your
> > > > > driver.
> > > > >
> > > > > At the top of that structure, create a compressed cpio archiv=
e
>=20
> > > like
> > > > > this:
> > > > >
> > > > > find . -depth | cpio -H crc 2>/dev/null | gzip -qc -
> > >modules.cgz
> > > > >
> > > > > copy the file "modules.cgz" to a DOS- or ext2-formatted
> floppy.
> > > > > Besides "modules.cgz", the floppy must contain
> > > > >
> > > > > 1. a file "modinfo" in the following format:
> > > > >
> > > > > modname
> > > > >         scsi
> > > > >         "description of driver"
> > > > >
> > > > > Caution: TABs at the beginning line 2 and 3!
> > > > >
> > > > > 2. a file "modules.dep" in the following format:
> > > > > modname:        scsi_mod
> > > > >
> > > > > (scsi_mod is usually the only prerequisite needed)
> > > > >
> > > > > 3. a file "pcitable" in the following format:
> > > > > 0xdead  0xbeef  "modname"       "description of device"
> > > > > ...
> > > > >
> > > > > Caution: TAB as field separator!
> > > > > This list must contain the PCI vendor and device IDs of
> > > > your device
> > > > > in the 1st and 2nd field. The easiest way to obtain
> > these is from
> > > an
> > > > > existing driver disk for a different kernel. Alternatively,
> you
> > > can
> > > > > read
> > > > > the driver source to find them out.
> > > > >
> > > > > 4. a file called "rhdd-6.1" with a free-format
> > description of the
> > > > > floppy
> > > > >
> > > > > 5. an empty file called "up"
> > > > >
> > > > > Good luck,
> > > > > Martin
> > > > >
> > > > > --
> > > > > Martin Wilck                Phone: +49 5251 8 15113
> > > > > Fujitsu Siemens Computers   Fax:   +49 5251 8 20409
> > > > > Heinz-Nixdorf-Ring 1
> > > mailto:Martin.Wilck@Fujitsu-Siemens.com
> > > > > D-33106 Paderborn
> > > http://www.fujitsu-siemens.com/primergy
> > > >
> > > > --
> > > > Josef M=F6llers (Pinguinpfleger bei FSC)
> > > >       If failure had no penalty success would not be a prize
> > > >                                               -- T.  Pratchett
> > > > -
> > > > To unsubscribe from this list: send the line "unsubscribe
> > > > linux-scsi" in the body of a message to
> majordomo@vger.kernel.org
> > > > More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> > > >
> >
> > --
> > Josef M=F6llers (Pinguinpfleger bei FSC)
> >       If failure had no penalty success would not be a prize
> >                                               -- T.  Pratchett
> >

--=20
Josef M=F6llers (Pinguinpfleger bei FSC)
	If failure had no penalty success would not be a prize
						-- T.  Pratchett
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
