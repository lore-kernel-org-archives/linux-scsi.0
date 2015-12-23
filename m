From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v3 68/77] ncr5380: Fix whitespace issues using regexp
Date: Wed, 23 Dec 2015 15:14:28 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512231454350.32341@nippy.intranet>
References: <20151222011737.980475848@telegraphics.com.au>  <20151222011756.506380156@telegraphics.com.au>  <1450795615.21677.10.camel@perches.com>  <alpine.LNX.2.00.1512231138330.28866@nippy.intranet>  <1450833190.3537.2.camel@perches.com>
 <alpine.LNX.2.00.1512231255350.30030@nippy.intranet> <1450837093.3537.6.camel@perches.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463806400-926866220-1450842863=:32341"
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1450837093.3537.6.camel@perches.com>
Content-ID: <alpine.LNX.2.00.1512231508580.32341@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463806400-926866220-1450842863=:32341
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.LNX.2.00.1512231508581.32341@nippy.intranet>


On Tue, 22 Dec 2015, Joe Perches wrote:

> On Wed, 2015-12-23 at 13:03 +1100, Finn Thain wrote:
> > On Tue, 22 Dec 2015, Joe Perches wrote:
> >=20
> > > On Wed, 2015-12-23 at 11:56 +1100, Finn Thain wrote:
> > > > On Tue, 22 Dec 2015, Joe Perches wrote:
> > > >=A0
> > > > > On Tue, 2015-12-22 at 12:18 +1100, Finn Thain wrote:
> > > > > > This patch is just the result of two substitutions. The first=
=A0
> > > > > > removes any tabs and spaces at the end of the line. The second=
=A0
> > > > > > replaces runs of tabs and spaces at the beginning of comment li=
nes=A0
> > > > > > with a single space.
> > > > >=A0
> > > > > I think the second of these isn't done well.
> > > >=A0
> > > > The aim of this patch is not to fix code style, but to make it=A0
> > > > possible to compare these two files so that the fork can be repaire=
d.=A0
> > > > Regexp is very helpful in creating uniformity (and a minimal diff).
> > > >=A0
> > > > If this was a coding style issue, we would be discussing the use of=
=A0
> > > > kernel-doc format for the affected comments, not whitespace.
> > > >=A0
> > > > > Many of these comments post reformatting are much worse to read=
=A0
> > > > > because of lost alignment.
> > > >=A0
> > > > You exaggerate a very trivial point.
> > >=A0
> > >=20
> > >=A0
> > > I prefer that all patches be improvements.
> > >=A0
> >=20
> > Agreed. But the example you cited is an improvement, in that it creates=
=A0
> > consistency.
>=20
> I think "consistency" isn't a useful argument.
> The kernel code doesn't care about any other
> external code bases.

I prefer that the drivers I maintain be self-consistent.

>=20
> > Like you, I prefer to see formal parameters aligned when wrapped. But t=
his=A0
> > isn't a formal parameter list, it is a comment, and no comment should=
=A0
> > duplicate code.
> >=20
> > Can you suggest a better regexp? Since this is patch 68 in the series,=
=A0
> > there is a good chance that it will need to be regenerated.
>=20
> I suggest you do 2 patches here. =A0One that removes
> unnecessary trailing spaces

Those are resolved by this patch.

> and converts multiple leading spaces to tabs where appropriate

As I said, trivial cleanups are better done after the fork is resolved, to=
=20
avoid churn. To assist with resolving the fork, this patch addresses=20
inconsistencies.

> and a
> second patch that fixes whatever odd indentation
> that does exist after comment leading *.

Those are resolved by this patch.

> I think
> there aren't many instances of those and I think
> those should be done by hand rather than regex.

I don't know why a regexp wouldn't work and I don't know what you have in=
=20
mind when you say "[fix] odd indentation". Is there some kind of style=20
guide applicable here, which this patch violates?

Upon re-reading this patch, I did find a table where I think the regexp is=
=20
detrimental.

@@ -2096,7 +2096,7 @@ static void NCR5380_information_transfer
 =09=09=09=09=09 * Byte
 =09=09=09=09=09 * 0=09=09EXTENDED_MESSAGE =3D=3D 1
 =09=09=09=09=09 * 1=09=09length (includes one byte for code, doesn't
-=09=09=09=09=09 *=09=09include first two bytes)
+=09=09=09=09=09 * include first two bytes)
 =09=09=09=09=09 * 2=09=09code
 =09=09=09=09=09 * 3..length+1=09arguments
 =09=09=09=09=09 *
This table is interesting. Even though the author took the trouble to
duplicate a portion of the SCSI spec in the source, they were still able=20
to stuff it up. See patch 44/77 in this series, "ncr5380: Fix off-by-one=20
bug in extended_msg[] bounds check".

So how about I remove this table in patch 67, along with the other dud=20
comments, and then regenerate this patch. That way, perhaps we can all=20
agree that the regexp is not actually detrimental?

--=20
---1463806400-926866220-1450842863=:32341--
