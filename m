From: Nir Livni <nirl@cyber-ark.com>
Subject: RE: How to build a RedHat driver disk (fusion mpt)]]
Date: Mon, 24 Nov 2003 14:01:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <93F63181B5926E4FA7A5AD0238924494025E5A@ca-prod2.cyber-ark.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxout4.netvision.net.il ([194.90.9.27]:44166 "EHLO
	mxout4.netvision.net.il") by vger.kernel.org with ESMTP
	id S263763AbTKXL6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2003 06:58:17 -0500
Received: from cyber-ark.com ([194.90.225.102]) by mxout4.netvision.net.il
 (iPlanet Messaging Server 5.2 HotFix 1.14 (built Mar 18 2003))
 with SMTP id <0HOU005TKUL4I0@mxout4.netvision.net.il> for
 linux-scsi@vger.kernel.org; Mon, 24 Nov 2003 13:58:16 +0200 (IST)
Received: from outgw.cyber-ark.com (127.0.0.1)	by cyber-ark.com (127.0.0.1)
 with [XMail 0.64 (Win32) SMTP Server]	for <linux-scsi@vger.kernel.org> from
 <nirl@cyber-ark.com>; Mon, 24 Nov 2003 13:58:33 +0200
Received: from CA-PROD2.cyber-ark.co.il (192.168.41.203)
	by cyber-ark.co.il (192.168.41.34) with [XMail 0.64 (Win32)
 SMTP Server]	for <linux-scsi@vger.kernel.org> from <nirl@cyber-ark.com>; Mon,
 24 Nov 2003 14:01:18 +0200
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Josef M?llers <josef.moellers@fujitsu-siemens.com>

So far so good...
That's almost identical to what I've done.
I took the original driver disk (2.4.9-e.3smp), and replaced the modnam=
e.o with a compiled modname.o of my kernel.
RedHat identifies the modules in the driver disk, but when I ask to loa=
d the driver (using linux dd noprobe when installing) -=20
I always get "failed to insert modname.o module".

I suspect I do not compile the module as I should.

The kernel rpm is kernel-smp-2.4.9-e.5.i686.rpm.

I installed this rpm on a temporary smp PC, with an IDE controller.
I uploaded the sources and tried to follow the build instructions, with=
 no special configuration.

The replaced the *.o files in the disk with my new built modules. But s=
till - no good.

Any suggestions ?

Thanks for the effort,
Nir

>=20
>=20
> I've asked my colleague who does all the drivers ...
>=20
> > Wilck Martin wrote:
> >=20
> > >>Nir Livni wrote:
> >  >>I would like to know how can I build a driver disk for=20
> this kernel,
> >=20
> > create a driectory structure that looks like this
> >=20
> > 2.4.9-e.5
> >         modname.o
> >         ...
> > 2.4.9-e.5BOOT
> >         modname.o
> >         ...
> > 2.4.9-e.5smp
> >         modname.o
> >         ...
> > ...
> >=20
> > Of course, the respective .o files must have been compiled=20
> against a=20
> > properly configured kernel. "modname" stands for the name of your=20
> > driver.
> >=20
> > At the top of that structure, create a compressed cpio archive like
> > this:
> >=20
> > find . -depth | cpio -H crc 2>/dev/null | gzip -qc - >modules.cgz
> >=20
> > copy the file "modules.cgz" to a DOS- or ext2-formatted floppy.=20
> > Besides "modules.cgz", the floppy must contain
> >=20
> > 1. a file "modinfo" in the following format:
> >=20
> > modname
> >         scsi
> >         "description of driver"
> >=20
> > Caution: TABs at the beginning line 2 and 3!
> >=20
> > 2. a file "modules.dep" in the following format:
> > modname:        scsi_mod
> >=20
> > (scsi_mod is usually the only prerequisite needed)
> >=20
> > 3. a file "pcitable" in the following format:
> > 0xdead  0xbeef  "modname"       "description of device"
> > ...
> >=20
> > Caution: TAB as field separator!
> > This list must contain the PCI vendor and device IDs of =20
> your device=20
> > in the 1st and 2nd field. The easiest way to obtain these is from a=
n
> > existing driver disk for a different kernel. Alternatively, you can
> > read
> > the driver source to find them out.
> >=20
> > 4. a file called "rhdd-6.1" with a free-format description
> > of the floppy
> >=20
> > 5. an empty file called "up"
> >=20
> > Good luck,
> > Martin
> >=20
> > --
> > Martin Wilck                Phone: +49 5251 8 15113
> > Fujitsu Siemens Computers   Fax:   +49 5251 8 20409
> > Heinz-Nixdorf-Ring 1        mailto:Martin.Wilck@Fujitsu-Siemens.com
> > D-33106 Paderborn           http://www.fujitsu-siemens.com/primergy
>=20
> --=20
> Josef M=F6llers (Pinguinpfleger bei FSC)
> 	If failure had no penalty success would not be a prize
> 						-- T.  Pratchett
> -
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-scsi" in the body of a message to=20
> majordomo@vger.kernel.org More majordomo info at =20
> http://vger.kernel.org/majordomo-info.html
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
