From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: Re: REPORT LUNS
Date: Tue, 24 Jun 2003 08:51:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EF7F4F5.F43CDC5@fujitsu-siemens.com>
References: <3EE9DA00.A429F83F@fujitsu-siemens.com> <20030613112222.A23260@beaverton.ibm.com> <3EED69D6.BDB411F7@fujitsu-siemens.com> <20030623094949.A7705@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plam.fujitsu-siemens.com ([217.115.66.9]:48427 "EHLO
	plam.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S265718AbTFXGhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jun 2003 02:37:03 -0400
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
>=20
> On Mon, Jun 16, 2003 at 08:55:18AM +0200, Josef M=F6llers wrote:
> > Patrick Mansfield wrote:
> > >
> > > On Fri, Jun 13, 2003 at 04:04:48PM +0200, Josef M=F6llers wrote:
> > > > Hi,
> > > >
> > > > Wile trying to figure out how to ignore non-existing LUNs on RA=
ID
> > > > devices, I have fallen across an error in scsilun_to_int() wher=
e it
> > > > doesn't behave as the comment suggests and a problematic piece =
of code
> > > > in scsi_report_lun_scan().
> > > >
> > > > Patch is included.
> > >
> > > If we clear the upper bits (address method, per SAM-3), someone h=
as to
> > > eventually set them again, and this is not handled today in linux=
 scsi
> > > core.
> >
> > The comment said that the upper two bits were ignored which they we=
re
> > not in the original code, so, apart from fixing the shifts, I also =
added
> > the mask to keep the code in sync with the comment. I haven't yet
> > followed the use of the value thus created.
>=20
> Ignored meaning "does nothing with it", when we should probably do
> something - proper conversion, an error or warning output. The curren=
t
> code might work (with high bits set), if we did not exceed the
> host->max_lun. We might need an 8 byte lun everywhere to make it work
> right for all cases.

OK.

> Can you give more details of the problem you are seeing, and software
> (adapter driver) and hardware in use?

The main problem we have is with current 2.4 kernels that some RAID
systems report SCSI-2 but allow for more than 8 LUNs, so rather than pu=
t
each box into the device_list[] (BLIST_SPARSELUN), I was investigating
how this problem could be solved in an orderly fashion: either by using
REPORT LUNS or by examining the Peripheral Qualifier in the INQUIRY dat=
a
(which would require BLIST_SPARSELUN, nonetheless).
I looked at the 2.5 code and found that REPORT LUNS was implemented but
stumbled across the comment. I couln't really make sense out of SCSI-3
and a manual I have for EMC RAID subsystems on the data returned by the
REPORT LUNS command. I then looked at the code, got confused about the
shifts and broke the code with my patch.

> I did not notice your shift changes - I don't see how they work or wh=
at
> it fixes.

Looking at it fresh in the morning: no, it doesn't fix anything, it
breaks code which is OK. I learnt my lesson to be more careful.

> If scsi_lun was: 0x1 0x2 0x3 0x4 0 0 0 0
>=20
> Current code:
>=20
> First loop in scsilun_to_int, with i =3D 0:
>=20
>         lun =3D 0 | ( (0x1 << 8 | 0x2) << 0) =3D 0x0102
>=20
> Second loop i =3D 2:
>=20
>         lun =3D 0x0102 | ( (0x3 << 8 | 0x4) << 16) =3D 0x03040102
>=20
> Your patch would give:
>=20
> First loop i =3D 0:
>=20
>         lun =3D 0 | ((0x1 & 0x3f) << 1) | (0x2 << 0) =3D 0x02
>=20
> Second loop i =3D 2:
>=20
>         lun =3D 0x02 | ( ((0x3 & 0x3f) << 17) | (0x4 << 16) =3D 0x000=
60002

You're absolutely right. If i needed an excuse (other than not having
been careful enough), I'd attribute it to the heat.

I'll test my patches more thoroughly in the future.

Sorry,

Josef
--=20
Josef M=F6llers (Pinguinpfleger bei FSC)
	If failure had no penalty success would not be a prize
						-- T.  Pratchett
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
