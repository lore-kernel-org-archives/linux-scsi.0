From: Olaf Hering <olh@suse.de>
Subject: Re: [announce] scsi_id release 0.2
Date: Sun, 7 Dec 2003 20:59:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031207195915.GA6714@suse.de>
References: <20031205151810.A8891@beaverton.ibm.com> <20031207153802.GA6700@suse.de> <20031207114242.A29572@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:63620 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264497AbTLGT7Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2003 14:59:16 -0500
Content-Disposition: inline
In-Reply-To: <20031207114242.A29572@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

 On Sun, Dec 07, Patrick Mansfield wrote:

> On Sun, Dec 07, 2003 at 04:38:02PM +0100, Olaf Hering wrote:
> >  On Fri, Dec 05, Patrick Mansfield wrote:
> >=20
> > > Version 0.2 of scsi_id is available at:
> > >=20
> > > http://www-124.ibm.com/storageio/scsi_id/scsi_id-0.2.tar.gz
> >=20
> > What is $(DEBUG)? It is used by klibc and replaced by true/false.
>=20
> I use it to compile with -g.=20
>=20
> i.e.:
> =09
> 	# make DEBUG=3D-g=20
> 	cc -DSCSI_ID_VERSION=3D\"0.2\" -g -Wall   -c -o scsi_id.o scsi_id.c
> 	cc -DSCSI_ID_VERSION=3D\"0.2\" -g -Wall   -c -o scsi_serial.o scsi_s=
erial.c
> 	cc  -o scsi_id  scsi_id.o scsi_serial.o  -lsysfs =20
>=20
> The udev DEBUG value does not get passed down to the extras, so the
> scsi_id build under udev should be OK.

It does. make EXTRAS=3Dextras/scsi_id will pass DEBUG=3Dfalse/true if
defined.

> Is it breaking your build? If so I'll just remove it.

Yes, just try to build a udev debug binary.

I need also this patch because gcc decides that a printf("\n"); could b=
e
done with a putchar, which is not defined for some reasons.

--- extras/scsi_id/Makefile.orig        2003-12-07 15:05:33.000000000 +=
0100
+++ extras/scsi_id/Makefile     2003-12-07 15:14:09.000000000 +0100
@@ -27,7 +27,7 @@ INSTALL_DATA  =3D ${INSTALL} -m 644
 # Note some of the variables used here are set when built under udev, =
and
 # otherwise might not be set.

-override CFLAGS+=3D-DSCSI_ID_VERSION=3D\"$(SCSI_ID_VERSION)\" $(DEBUG)=
 -Wall
+override CFLAGS+=3D-DSCSI_ID_VERSION=3D\"$(SCSI_ID_VERSION)\" -Wall -f=
no-builtin

 PROG=3Dscsi_id
 SYSFS=3D-lsysfs


Greg has the new scsi_id already merged into the bk repo.


--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
