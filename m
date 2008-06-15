From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [regression] CD-DA delay needed after insertion
Date: Sun, 15 Jun 2008 09:33:56 -0500
Message-ID: <1213540437.3517.13.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <48550F0C.8030907@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759046AbYFOOec@vger.kernel.org>
In-Reply-To: <48550F0C.8030907@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2008-06-15 at 15:46 +0300, Boaz Harrosh wrote:
> Geert Uytterhoeven wrote:
> > We've found another regression in 2.6.25 w.r.t. CD media change on =
PS3.
> >=20
> > It can easily be reproduced by:
> >=20
> >   1. Inserting an audio CD
> >   2. Running the following command as soon as the blue CD/DVD/BD dr=
ive LED
> >      stops blinking and is lit continuously:
> >      =20
> > 	 cdparanoia -Z -q 1-1[:1] /dev/null || echo failed
> >=20
> > On 2.6.25 (and current mainline), you have to wait ca. 10 seconds a=
fter
> > insertion, or it will fail.
> > On 2.6.24 and older, it just works immediately.
> >=20
> > It does not matter whether
> > http://git.kernel.org/?p=3Dlinux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fi=
xes-2.6.git;a=3Dcommitdiff_plain;h=3Dd1daeabf0da5bfa1943272ce508e2ba785=
730bf0
> > is applied or not.
> >=20
> > We haven't bisected it yet.
> >=20
> > With kind regards,
> >=20
> > Geert Uytterhoeven
> > Software Architect
> >=20
> > Sony Techsoft Centre
> > The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zavent=
em =C2=B7 Belgium
> >=20
> > Phone:    +32 (0)2 700 8453
> > Fax:      +32 (0)2 700 8622
> > E-mail:   Geert.Uytterhoeven@sonycom.com
> > Internet: http://www.sony-europe.com/
> >=20
> > Sony Technology and Software Centre Europe
> > A division of Sony Service Centre (Europe) N.V.
> > Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7=
 Belgium
> > VAT BE 0413.825.160 =C2=B7 RPR Brussels
> > Fortis 293-0376800-10 GEBA-BE-BB
>=20
> James hi.
>=20
> It looks like the same problem as before. Any BLOCK_PC command will=20
> eat the UNIT_ATTENTION notification. Which is what I was afraid of.=20
> I was thinking of something like below.

It's a bit unlikely to be the cause of a regression, since the code has
behaved this way by design since at least 2.4.  The problem we're
looking for appeared in 2.6.25+

Also, the taxonomy of the regression: errors returned within 10s of
inserting the CD sounds very much like an ignored NOT_READY.

> Totally untested, never even booted. It is just to demonstrate the co=
ncept.
> Please tell me if it is at all desirable and I'll spend some time to =
see
> if it runs, and test it.

Really, no ... not until there's a proveable problem caused by it.  Eve=
n
then, not like this: the way you've coded it interferes with the cc_ua
processing code.  It would have to go in scsi_decide_disposition().

James
