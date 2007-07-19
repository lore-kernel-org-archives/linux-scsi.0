From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 2/3] ps3: BD/DVD/CD-ROM Storage Driver
Date: Thu, 19 Jul 2007 11:02:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707191100270.8661@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.529280000@pademelon.sonytel.be>
	<20070718164351.a92ec032.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-584337861-1835406229-1184835727=:8661"
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <20070718164351.a92ec032.akpm@linux-foundation.org>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1835406229-1184835727=:8661
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Jul 2007, Andrew Morton wrote:
> > +struct ps3rom_private {
> > +	struct ps3_storage_device *dev;
> > +	struct scsi_cmnd *curr_cmd;
> > +};
> > +#define ps3rom_priv(dev)	((dev)->sbd.core.driver_data)
> > +
>=20
> Someone should invent a keyboard which delivers an electric shock when =
the
> operator types "#define".   In the meanwhile, I get to do the honours.
>=20
> Please don't implement in a macro anything which can be implemented in =
C.

All I needed was a shorthand to access driver_data, for both read and wri=
te
access (you cannot do the latter with C, unless you decouple read and wri=
te).

> > +			kaddr =3D kmap_atomic(sgpnt->page, KM_IRQ0);
> > +			if (!kaddr)
> > +				return -1;
>=20
> kmap_atomic() cannot fail.  On i386, at least.  If it can fail on any o=
ther
> arch then we have a biiiiig problem.  (Multiple instances of this)

Thanks, fixed!

With kind regards,
=20
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium
=20
Phone:    +32 (0)2 700 8453=09
Fax:      +32 (0)2 700 8622=09
E-mail:   Geert.Uytterhoeven@sonycom.com=09
Internet: http://www.sony-europe.com/
 =09
Sony Network and Software Technology Center Europe=09
A division of Sony Service Centre (Europe) N.V.=09
Registered office: Technologielaan 7 =C2=B7 B-1840 Londerzeel =C2=B7 Belg=
ium=09
VAT BE 0413.825.160 =C2=B7 RPR Brussels=09
Fortis Bank Zaventem =C2=B7 Swift GEBABEBB08A =C2=B7 IBAN BE3900138235861=
9
---584337861-1835406229-1184835727=:8661
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@ozlabs.org
https://ozlabs.org/mailman/listinfo/linuxppc-dev
---584337861-1835406229-1184835727=:8661--
