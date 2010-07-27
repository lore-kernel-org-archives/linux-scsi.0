From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] aic7xxx: Remove OS utility wrappers
Date: Tue, 27 Jul 2010 12:40:04 -0500
Message-ID: <1280252404.2833.168.camel@mulgrave.site>
References: <1279102377-958-1-git-send-email-penberg@cs.helsinki.fi>
	 <4C43F3DE.8000405@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C43F3DE.8000405@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>, Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, =?ISO-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-07-19 at 08:42 +0200, Hannes Reinecke wrote:
> Pekka Enberg wrote:
> > This patch removes malloc(), free(), and printf() wrappers from the=
 aic7xxx
> > SCSI driver. I didn't use pr_debug for printf because of some 'clev=
er' uses of
> > printf don't compile with the pr_debug. I didn't fix the overeager =
uses of
> > GFP_ATOMIC either because I wanted to keep this patch as simple as =
possible.
> >=20
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
> > Cc: Jiri Kosina <jkosina@suse.cz>
> > Cc: "Uwe Kleine-K=C3=B6nig" <u.kleine-koenig@pengutronix.de>
> > Cc: "Andr=C3=A9 Goddard Rosa" <andre.goddard@gmail.com>
> > Cc: <linux-scsi@vger.kernel.org>
> > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
>=20
> Thanks for the work. Long overdue.
>=20
> Acked-by: Hannes Reinecke <hare@suse.de>

A good rule of thumb is compile before acking:

drivers/scsi/aic7xxx/aic7770.c: In function 'aic7770_config':
drivers/scsi/aic7xxx/aic7770.c:224: error: implicit declaration of func=
tion 'free'
drivers/scsi/aic7xxx/aic7770.c:224: error: 'M_DEVBUF' undeclared (first=
 use in this function)
drivers/scsi/aic7xxx/aic7770.c:224: error: (Each undeclared identifier =
is reported only once
drivers/scsi/aic7xxx/aic7770.c:224: error: for each function it appears=
 in.)
make[3]: *** [drivers/scsi/aic7xxx/aic7770.o] Error 1

It looks like a lone missed conversion, so I fixed it up.

James
