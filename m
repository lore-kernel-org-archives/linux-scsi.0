From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: possible circular locking dependency detected [was: linux-next:
 Tree for Aug 22]
Date: Thu, 24 Aug 2017 12:39:09 +0800
Message-ID: <20170824043909.GL11771@tardis>
References: <20170822183816.7925e0f8@canb.auug.org.au>
 <20170822104708.GA491@jagdpanzerIV.localdomain>
 <1503438234.2508.27.camel@wdc.com>
 <20170823000304.GK20323@X58A-UD3R>
 <20170823034951.GG11771@tardis>
 <20170823043813.GH11771@tardis>
 <20170823044648.GE10329@jagdpanzerIV.localdomain>
 <20170823053501.GJ11771@tardis>
 <20170823055517.GB728@jagdpanzerIV.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jIYo0VRlfdMI9fLa"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170823055517.GB728@jagdpanzerIV.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Byungchul Park <byungchul.park@lge.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, peterz@infradead.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, kernel-team@lge.com
List-Id: linux-scsi@vger.kernel.org


--jIYo0VRlfdMI9fLa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 23, 2017 at 02:55:17PM +0900, Sergey Senozhatsky wrote:
> On (08/23/17 13:35), Boqun Feng wrote:
> > > KERN_CONT and "\n" should not be together. "\n" flushes the cont
> > > buffer immediately.
> > >=20
> >=20
> > Hmm.. Not quite familiar with printk() stuffs, but I could see several
> > usages of printk(KERN_CONT "...\n") in kernel.
> >=20
> > Did a bit research myself, and I now think the inappropriate use is to
> > use a KERN_CONT printk *after* another printk ending with a "\n".
>=20
> ah... I didn't check __print_lock_name(): it leaves unflushed cont buffer
> upon the return. sorry, your code is correct.
>=20

So means printk(KERN_CON "..."); + printk(KERN_CONT "...\n") is a
correct usage, right? Thanks. Again, not familiar with printk stuff,
glad you can help me go through this ;-)

Regards,
Boqun

> 	-ss
>=20
> > > >  		printk("\n *** DEADLOCK ***\n\n");
> > > > +	} else if (cross_lock(src->instance)) {
> > > > +		printk(" Possible unsafe locking scenario by crosslock:\n\n");
> > > > +		printk("       CPU0                    CPU1\n");
> > > > +		printk("       ----                    ----\n");
> > > > +		printk("  lock(");
> > > > +		__print_lock_name(target);
> > > > +		printk(KERN_CONT ");\n");
> > > > +		printk("  lock(");
> > > > +		__print_lock_name(source);
> > > > +		printk(KERN_CONT ");\n");
> > > > +		printk("                               lock(");
> > > > +		__print_lock_name(parent =3D=3D source ? target : parent);
> > > > +		printk(KERN_CONT ");\n");
> > > > +		printk("                               unlock(");
> > > > +		__print_lock_name(source);
> > > > +		printk(KERN_CONT ");\n");
> > > > +		printk("\n *** DEADLOCK ***\n\n");
> > > >  	} else {
> > > >  		printk(" Possible unsafe locking scenario:\n\n");
> > > >  		printk("       CPU0                    CPU1\n");
> > > > --=20
> > > > 2.14.1
> > > >=20
>=20
>=20

--jIYo0VRlfdMI9fLa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEj5IosQTPz8XU1wRHSXnow7UH+rgFAlmeWGkACgkQSXnow7UH
+rhIWwf+OmxhdQxb4S1PfW9qANb3TIOPTr4tJTKPe2DZd0itItkSGji81N6X6SZj
j4h3Ha+zaChDnPhxqSotJD5XSBUomQ96Avq4cjnjOxU9TI91zQtH1WIuNrPuggZ+
JK3z8kU3xaWh7YIyKJAkiy6V1h8Q6cONTIT7pheuL4buphbW+FdaTjRgEjlrhsNU
QFHLYyIx7eruJ/KQKOoWDo6Pb+dUGY1tCYzFIzqkJsh4rj6xQLvmJLhvYXAFxSK7
RfbZodZhVANRq7g3dy+S4xtQ3l6N1ViOMe1mOBkKOWYpfXn2aZ39DtiHNbfGn4w2
wxd081KqAcI7BRq3gyPTKDrnHfRNEQ==
=2gpd
-----END PGP SIGNATURE-----

--jIYo0VRlfdMI9fLa--
