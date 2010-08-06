From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [GIT PULL] first round of SCSI updates for the 2.6.36 merge
 window
Date: Thu, 05 Aug 2010 19:32:48 -0500
Message-ID: <1281054768.22157.2.camel@mulgrave.site>
References: <1280895197.11045.317.camel@mulgrave.site>
	 <AANLkTintTMXirWF+Y-CwK4dn8Mqk8=ba9_+yjX9P837V@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTintTMXirWF+Y-CwK4dn8Mqk8=ba9_+yjX9P837V@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-08-04 at 15:51 -0700, Linus Torvalds wrote:
> On Tue, Aug 3, 2010 at 9:13 PM, James Bottomley <James.Bottomley@suse=
=2Ede> wrote:
> >
> > Alan Stern (3):
> >      sd: add support for runtime PM
> >      implement runtime Power Management
> >      convert to the new PM framework
>=20
> Guys, these kind of crazy games really aren't appropriate:
>=20
>   +/* scsi_pm.c */
>   +#ifdef CONFIG_PM_OPS
>   +extern const struct dev_pm_ops scsi_bus_pm_ops;
>   +#else
>   +#define scsi_bus_pm_ops                (*NULL)
>   +#endif
>=20
> that's just crazy. Yes, I see how it's then used (address-of operator
> turns it back into NULL), but the compiler warns about it
> ("drivers/scsi/scsi_sysfs.c:384: warning: dereferencing =E2=80=98void=
 *=E2=80=99
> pointer") and I think the compiler is 100% correct about warning abou=
t
> it.

Sigh ... I did actually check this because I thought the compiler would
warn.  Apparently it only warns on certain versions.

> It's not just the (*NULL) games, btw. The above can cause confusion.
> It's ugly not just because it causes the compiler to warn, but becaus=
e
> you use a very subtle and non-standard way of using #define's, so tha=
t
> when you look at the source code where this is used, it's not at all
> obvious what is going on. The code looks like
>=20
>     .pm             =3D &scsi_bus_pm_ops,
>=20
> and dammit, it would be rather understandable if some _human_ that
> reads that is also confused and thinks that the above means that the
> .pm pointer can never be NULL. The address-of would certainly throw
> me, and not necessarily at all make me grep for "could that possibly
> be some crazy way to say NULL".
>=20
> And there is absolutely no reason to play games like that. It would
> have been entirely understandable if you just put the #ifdef in the C
> code itself, or if you used a #define that just said
>=20
>   #ifdef CONFIG_PM_OPS
>   #define SCSI_BUS_PM_OPS &scsi_bus_pm_ops
>   #else
>   #define SCSI_BUS_PM_OPS NULL
>   #endif
>=20
> and I think it would be less confusing, and it wouldn't upset the com=
piler.
>=20
> Yes, yes, I realize that we do these kinds of things for function
> pointers all the time, so I do understand where the pattern comes
> from. At the same time, I rather think that function pointers are a
> bit different, and they don't have the whole address-of problem.
>=20
> I guess I should be happy that you didn't use some linker tricks to
> make "&scsi_bus_pm_ops" turn into NULL at link time. That could be
> done too, and would have been even more subtly confusing.

Agreed.  Alan already sent a patch to fix it.  I'll add it for the fina=
l
SCSI patch set.

James
