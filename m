From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: possible circular locking dependency detected [was: linux-next:
 Tree for Aug 22]
Date: Wed, 23 Aug 2017 13:35:01 +0800
Message-ID: <20170823053501.GJ11771@tardis>
References: <20170822183816.7925e0f8@canb.auug.org.au>
 <20170822104708.GA491@jagdpanzerIV.localdomain>
 <1503438234.2508.27.camel@wdc.com>
 <20170823000304.GK20323@X58A-UD3R>
 <20170823034951.GG11771@tardis>
 <20170823043813.GH11771@tardis>
 <20170823044648.GE10329@jagdpanzerIV.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8bBEDOJVaa9YlTAt"
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170823044648.GE10329@jagdpanzerIV.localdomain>
Sender: linux-block-owner@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Byungchul Park <byungchul.park@lge.com>, Bart Van Assche <Bart.VanAssche@wdc.com>, peterz@infradead.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, kernel-team@lge.com
List-Id: linux-scsi@vger.kernel.org


--8bBEDOJVaa9YlTAt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 23, 2017 at 01:46:48PM +0900, Sergey Senozhatsky wrote:
> On (08/23/17 12:38), Boqun Feng wrote:
> [..]
> > diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> > index 642fb5362507..a3709e15f609 100644
> > --- a/kernel/locking/lockdep.c
> > +++ b/kernel/locking/lockdep.c
> > @@ -1156,6 +1156,23 @@ print_circular_lock_scenario(struct held_lock *s=
rc,
> >  		__print_lock_name(target);
> >  		printk(KERN_CONT ");\n");
>=20
> KERN_CONT and "\n" should not be together. "\n" flushes the cont
> buffer immediately.
>=20

Hmm.. Not quite familiar with printk() stuffs, but I could see several
usages of printk(KERN_CONT "...\n") in kernel.

Did a bit research myself, and I now think the inappropriate use is to
use a KERN_CONT printk *after* another printk ending with a "\n". Am I
missing some recent changes or rules of KERN_CONT?

Regards,
Boqun

> 	-ss
>=20
> >  		printk("\n *** DEADLOCK ***\n\n");
> > +	} else if (cross_lock(src->instance)) {
> > +		printk(" Possible unsafe locking scenario by crosslock:\n\n");
> > +		printk("       CPU0                    CPU1\n");
> > +		printk("       ----                    ----\n");
> > +		printk("  lock(");
> > +		__print_lock_name(target);
> > +		printk(KERN_CONT ");\n");
> > +		printk("  lock(");
> > +		__print_lock_name(source);
> > +		printk(KERN_CONT ");\n");
> > +		printk("                               lock(");
> > +		__print_lock_name(parent =3D=3D source ? target : parent);
> > +		printk(KERN_CONT ");\n");
> > +		printk("                               unlock(");
> > +		__print_lock_name(source);
> > +		printk(KERN_CONT ");\n");
> > +		printk("\n *** DEADLOCK ***\n\n");
> >  	} else {
> >  		printk(" Possible unsafe locking scenario:\n\n");
> >  		printk("       CPU0                    CPU1\n");
> > --=20
> > 2.14.1
> >=20

--8bBEDOJVaa9YlTAt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEj5IosQTPz8XU1wRHSXnow7UH+rgFAlmdE/AACgkQSXnow7UH
+rghYAf/QJJyrcchlLeYocrQzeawL9zb2kSFiKmwkfZsb/AWumOsS2oQrj8mwwiY
u2b1CZ86yfUPyXWT3OAr0dwFXWj0hB1rC8NcmAGK86Fe/D5Snv+Q9qhxZC9w5tb7
RY1GWcOs2CvqGYLFQibcx1tMWngQwGu/KzG/rLFYN/Pf4ctLzFGnrM6KudvjT+zT
727wGTYhFIZSuDjIKH+cIvw+OBUadNMjyhuwWb6S0Us3PsP5Z+q4/J/58H3fPqyC
yoTMJpgA82f0Bz8tP1iQt1NUNRcY95m4VRgN31XuF9dXZ0rutJl1wiD9qyuFAVuB
gUimwVvanmxLLpFj03DElfYz9Iz9jg==
=U+/S
-----END PGP SIGNATURE-----

--8bBEDOJVaa9YlTAt--
