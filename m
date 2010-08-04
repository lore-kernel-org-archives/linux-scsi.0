From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] first round of SCSI updates for the 2.6.36 merge
	window
Date: Wed, 4 Aug 2010 15:51:17 -0700
Message-ID: <AANLkTintTMXirWF+Y-CwK4dn8Mqk8=ba9_+yjX9P837V@mail.gmail.com>
References: <1280895197.11045.317.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1280895197.11045.317.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 3, 2010 at 9:13 PM, James Bottomley <James.Bottomley@suse.d=
e> wrote:
>
> Alan Stern (3):
> =A0 =A0 =A0sd: add support for runtime PM
> =A0 =A0 =A0implement runtime Power Management
> =A0 =A0 =A0convert to the new PM framework

Guys, these kind of crazy games really aren't appropriate:

  +/* scsi_pm.c */
  +#ifdef CONFIG_PM_OPS
  +extern const struct dev_pm_ops scsi_bus_pm_ops;
  +#else
  +#define scsi_bus_pm_ops                (*NULL)
  +#endif

that's just crazy. Yes, I see how it's then used (address-of operator
turns it back into NULL), but the compiler warns about it
("drivers/scsi/scsi_sysfs.c:384: warning: dereferencing =91void *=92
pointer") and I think the compiler is 100% correct about warning about
it.

It's not just the (*NULL) games, btw. The above can cause confusion.
It's ugly not just because it causes the compiler to warn, but because
you use a very subtle and non-standard way of using #define's, so that
when you look at the source code where this is used, it's not at all
obvious what is going on. The code looks like

    .pm             =3D &scsi_bus_pm_ops,

and dammit, it would be rather understandable if some _human_ that
reads that is also confused and thinks that the above means that the
=2Epm pointer can never be NULL. The address-of would certainly throw
me, and not necessarily at all make me grep for "could that possibly
be some crazy way to say NULL".

And there is absolutely no reason to play games like that. It would
have been entirely understandable if you just put the #ifdef in the C
code itself, or if you used a #define that just said

  #ifdef CONFIG_PM_OPS
  #define SCSI_BUS_PM_OPS &scsi_bus_pm_ops
  #else
  #define SCSI_BUS_PM_OPS NULL
  #endif

and I think it would be less confusing, and it wouldn't upset the compi=
ler.

Yes, yes, I realize that we do these kinds of things for function
pointers all the time, so I do understand where the pattern comes
from. At the same time, I rather think that function pointers are a
bit different, and they don't have the whole address-of problem.

I guess I should be happy that you didn't use some linker tricks to
make "&scsi_bus_pm_ops" turn into NULL at link time. That could be
done too, and would have been even more subtly confusing.

                      Linus
