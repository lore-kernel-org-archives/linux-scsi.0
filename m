From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: Re: REPORT LUNS
Date: Mon, 16 Jun 2003 08:55:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EED69D6.BDB411F7@fujitsu-siemens.com>
References: <3EE9DA00.A429F83F@fujitsu-siemens.com> <20030613112222.A23260@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plim.fujitsu-siemens.com ([217.115.66.8]:14119 "EHLO
	plim.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S262176AbTFPGlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jun 2003 02:41:03 -0400
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
>=20
> On Fri, Jun 13, 2003 at 04:04:48PM +0200, Josef M=F6llers wrote:
> > Hi,
> >
> > Wile trying to figure out how to ignore non-existing LUNs on RAID
> > devices, I have fallen across an error in scsilun_to_int() where it
> > doesn't behave as the comment suggests and a problematic piece of c=
ode
> > in scsi_report_lun_scan().
> >
> > Patch is included.
>=20
> If we clear the upper bits (address method, per SAM-3), someone has t=
o
> eventually set them again, and this is not handled today in linux scs=
i
> core.

The comment said that the upper two bits were ignored which they were
not in the original code, so, apart from fixing the shifts, I also adde=
d
the mask to keep the code in sync with the comment. I haven't yet
followed the use of the value thus created.

> > @@ -1027,13 +1027,18 @@
> >        * the header, so start at 1 and go up to and including num_l=
uns.
> >        */
> >       for (lunp =3D &lun_data[1]; lunp <=3D &lun_data[num_luns]; lu=
np++) {
> > +             int j;
> > +
> >               lun =3D scsilun_to_int(lunp);
> >
> >               /*
> >                * Check if the unused part of lunp is non-zero, and =
so
> >                * does not fit in lun.
> >                */
> > -             if (memcmp(&lunp->scsi_lun[sizeof(lun)], "\0\0\0\0", =
4)) {
> > +             for (j =3D sizeof(lun); j < sizeof(struct scsi_lun); =
j++)
> > +                 if (lunp->scsi_lun[j] !=3D 0)
> > +                     break;
> > +             if (j < sizeof(struct scsi_lun)) {
> >                       int i;
> >
> >                       /*
>=20
> What does the above patch fix? It looks like they both check if the l=
ast
> four bytes are 0.

It does so, iff sizeof(lun) is 4 and sizeof(struct scsi_lun) is 8.
Perhaps it was more a question of personal taste to change the code so
that it also works for 64 bit ints.

--=20
Josef M=F6llers (Pinguinpfleger bei FSC)
	If failure had no penalty success would not be a prize
						-- T.  Pratchett
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
