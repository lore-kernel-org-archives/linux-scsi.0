From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [23/27] kernel.h: add printk_ratelimited and pr_<level>_rl
Date: Tue, 24 Jan 2012 16:35:50 +0000
Message-ID: <1327422950.5400.40.camel@deadeye>
References: <20120123234224.GA19510@kroah.com>
	 <20120123234203.649739932@clark.kroah.org>
	 <20120124144613.GD3180@pcarmody2.research.nokia.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bRtAGwA5ctm1rsqCZGr7"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120124144613.GD3180@pcarmody2.research.nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: ext Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, Paolo Bonzini <pbonzini@redhat.com>, Petr Matousek <pmatouse@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels>
List-Id: linux-scsi@vger.kernel.org


--=-bRtAGwA5ctm1rsqCZGr7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-01-24 at 16:46 +0200, Phil Carmody wrote:
> On 23/01/12 15:41 -0800, ext Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let=
 me know.
>=20
> This looks like an added feature with no users in .32 - does it really=
=20
> belong in a stable tree?
> (But to be explicit, I have no issue with its contents at all.)

It's required for commit 0bfc96cb77224736dfa35c3c555d37b3646ef35e
('block: fail SCSI passthrough ioctls on partition devices'), though
that hasn't actually been included in this series.  I think that's
because there is still ongoing discussion of which error codes need to
be used.

Ben.

> Phil
>=20
> > ------------------
> >=20
> >=20
> > From: Joe Perches <joe@perches.com>
> >=20
> > commit 8a64f336bc1d4aa203b138d29d5a9c414a9fbb47 upstream.
> >=20
> > Add a printk_ratelimited statement expression macro that uses a per-cal=
l
> > ratelimit_state so that multiple subsystems output messages are not
> > suppressed by a global __ratelimit state.
> >=20
> > [akpm@linux-foundation.org: coding-style fixes]
> > [akpm@linux-foundation.org: s/_rl/_ratelimited/g]
> > Signed-off-by: Joe Perches <joe@perches.com>
> > Cc: Naohiro Ooiwa <nooiwa@miraclelinux.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >=20
> > ---
> >  include/linux/kernel.h |   44 ++++++++++++++++++++++++++++++++++++++++=
++++
> >  1 file changed, 44 insertions(+)
> >=20
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -407,6 +407,50 @@ static inline char *pack_hex_byte(char *
> >  #endif
> > =20
> >  /*
> > + * ratelimited messages with local ratelimit_state,
> > + * no local ratelimit_state used in the !PRINTK case
> > + */
> > +#ifdef CONFIG_PRINTK
> > +#define printk_ratelimited(fmt, ...)  ({		\
> > +	static struct ratelimit_state _rs =3D {		\
> > +		.interval =3D DEFAULT_RATELIMIT_INTERVAL, \
> > +		.burst =3D DEFAULT_RATELIMIT_BURST,       \
> > +	};                                              \
> > +							\
> > +	if (!__ratelimit(&_rs))                         \
> > +		printk(fmt, ##__VA_ARGS__);		\
> > +})
> > +#else
> > +/* No effect, but we still get type checking even in the !PRINTK case:=
 */
> > +#define printk_ratelimited printk
> > +#endif
> > +
> > +#define pr_emerg_ratelimited(fmt, ...) \
> > +	printk_ratelimited(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_alert_ratelimited(fmt, ...) \
> > +	printk_ratelimited(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_crit_ratelimited(fmt, ...) \
> > +	printk_ratelimited(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_err_ratelimited(fmt, ...) \
> > +	printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_warning_ratelimited(fmt, ...) \
> > +	printk_ratelimited(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_notice_ratelimited(fmt, ...) \
> > +	printk_ratelimited(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_info_ratelimited(fmt, ...) \
> > +	printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
> > +/* no pr_cont_ratelimited, don't do that... */
> > +/* If you are writing a driver, please use dev_dbg instead */
> > +#if defined(DEBUG)
> > +#define pr_debug_ratelimited(fmt, ...) \
> > +	printk_ratelimited(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> > +#else
> > +#define pr_debug_ratelimited(fmt, ...) \
> > +	({ if (0) printk_ratelimited(KERN_DEBUG pr_fmt(fmt), \
> > +				     ##__VA_ARGS__); 0; })
> > +#endif
> > +
> > +/*
> >   * General tracing related utility functions - trace_printk(),
> >   * tracing_on/tracing_off and tracing_start()/tracing_stop
> >   *
> >=20
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Ben Hutchings
Horngren's Observation:
                   Among economists, the real world is often a special case=
.

--=-bRtAGwA5ctm1rsqCZGr7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATx7d5ue/yOyVhhEJAQqVhhAAuzYvBQ4jP2EiJT6dM0kemBK2EGCDTcMi
4ScHTn5P6wWYkCCOfl9gNN2jQjnQEKopXEmD3UZliEVnNxvgaqeTKMWpFtwrhHE/
+XxF51sAwH3kY4F6UmAHEFGvOIlcAgLNd43ppy4R8gCSX1kFbzMxrQ+EdpZzhWlR
bTv0c7zVdCVaHK1ptMZQfUkNaQ0BWWLwgB6yEx/upmCyabTbPjxYjLgLiOq9gQ74
+Sop3ofmZwjHzTM5Rmq4TliNpKBUpaA/F5G3j92n0linVUAnbPIkBrcHm0gPqN1T
eQpRSELXeGJ3tTMaDMEiIeIQDysX9yIlsiqY+MPuB4bWzBVCSW6iOwnThs/VUNq8
BwqxnNVxricvp8+Y60J448zLOqc+fR3/rTrM2y+3kW4Wf9+8xyyyVfIEqVKKns9Z
ym36WgY8Wru0xkTM+ByjP0PJdT1vJ2ObAmni+Yh42Kq9jTPC7AAnqXuHtQs0Be6x
1dcvItpky2EhNZQynwdwQ1KP/aUVPfawQeXrjGWvR0ftuZbR55ULrl0ew06Jgt8v
Evx43P09yGyDYJ3WPxa8dhCL3btguTQhWgs3dS0we5fVYl98H2Qmbz5zYJ6uyCRw
iqrztvIdJNSNJ9/iPQrMemV0R1khZ9MKJ0Kt2gQgUDfZgzwTK+V7CaCSLoObrC8T
dSrKPDcVxm4=
=SMBY
-----END PGP SIGNATURE-----

--=-bRtAGwA5ctm1rsqCZGr7--
