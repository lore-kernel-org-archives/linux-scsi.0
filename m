From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: [Fwd: [Fwd: How to build a RedHat driver disk (fusion mpt)]]
Date: Mon, 24 Nov 2003 12:39:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC1EDEF.3F66F58E@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plim.fujitsu-siemens.com ([217.115.66.8]:45100 "EHLO
	plim.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S263734AbTKXLiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2003 06:38:05 -0500
Received: from trulli.pdb.fsc.net ([172.25.96.53])
	by plim.fujitsu-siemens.com (8.11.3/8.11.3) with ESMTP id hAOBc4r12969
	for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2003 12:38:04 +0100
Received: from pdbzex1e.pdb.fsc.net (pdbzex1ealt.pdb.fsc.net [172.25.96.23])
	by trulli.pdb.fsc.net (8.11.6/8.11.6) with ESMTP id hAOBc4V19269
	for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2003 12:38:04 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've asked my colleague who does all the drivers ...

> Wilck Martin wrote:
>=20
> >>Nir Livni wrote:
>  >>I would like to know how can I build a driver disk for this kernel=
,
>=20
> create a driectory structure that looks like this
>=20
> 2.4.9-e.5
>         modname.o
>         ...
> 2.4.9-e.5BOOT
>         modname.o
>         ...
> 2.4.9-e.5smp
>         modname.o
>         ...
> ...
>=20
> Of course, the respective .o files must have been compiled against a
> properly configured kernel. "modname" stands for the name of your
> driver.
>=20
> At the top of that structure, create a compressed cpio archive like
> this:
>=20
> find . -depth | cpio -H crc 2>/dev/null | gzip -qc - >modules.cgz
>=20
> copy the file "modules.cgz" to a DOS- or ext2-formatted floppy.
> Besides "modules.cgz", the floppy must contain
>=20
> 1. a file "modinfo" in the following format:
>=20
> modname
>         scsi
>         "description of driver"
>=20
> Caution: TABs at the beginning line 2 and 3!
>=20
> 2. a file "modules.dep" in the following format:
> modname:        scsi_mod
>=20
> (scsi_mod is usually the only prerequisite needed)
>=20
> 3. a file "pcitable" in the following format:
> 0xdead  0xbeef  "modname"       "description of device"
> ...
>=20
> Caution: TAB as field separator!
> This list must contain the PCI vendor and device IDs of  your device
> in
> the 1st and 2nd field. The easiest way to obtain these is from an
> existing driver disk for a different kernel. Alternatively, you can
> read
> the driver source to find them out.
>=20
> 4. a file called "rhdd-6.1" with a free-format description
> of the floppy
>=20
> 5. an empty file called "up"
>=20
> Good luck,
> Martin
>=20
> --
> Martin Wilck                Phone: +49 5251 8 15113
> Fujitsu Siemens Computers   Fax:   +49 5251 8 20409
> Heinz-Nixdorf-Ring 1        mailto:Martin.Wilck@Fujitsu-Siemens.com
> D-33106 Paderborn           http://www.fujitsu-siemens.com/primergy

--=20
Josef M=F6llers (Pinguinpfleger bei FSC)
	If failure had no penalty success would not be a prize
						-- T.  Pratchett
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
