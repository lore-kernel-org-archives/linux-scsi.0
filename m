From: "Alastair D'Silva" <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>
Subject: RE: [PATCH v2 3/7] lib/hexdump.c: Optionally suppress lines of repeated bytes
Date: Mon, 13 May 2019 17:35:47 +1000
Message-ID: <04de01d5095e$7f6af730$7e40e590$@d-silva.org>
References: <20190508070148.23130-1-alastair@au1.ibm.com> <20190508070148.23130-4-alastair@au1.ibm.com> <CAMuHMdVefYTgHzGKBc0ebku1z8V3wsM0ydN+6-S2nFKaB8eH_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMuHMdVefYTgHzGKBc0ebku1z8V3wsM0ydN+6-S2nFKaB8eH_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-au
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Geert Uytterhoeven' <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, 'Alastair D'Silva' <alastair-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Cc: 'Jani Nikula' <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, 'Joonas Lahtinen' <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, 'Rodrigo Vivi' <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'David Airlie' <airlied-cv59FeDIM0c@public.gmane.org>, 'Daniel Vetter' <daniel-/w4YWyX8dFk@public.gmane.org>, 'Dan Carpenter' <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Karsten Keil' <isdn-iHCpqvpFUx0uJkBD2foKsQ@public.gmane.org>, 'Jassi Brar' <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Tom Lendacky' <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, "'David S. Miller'" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, 'Jose Abreu' <Jose.Abreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, 'Kalle Valo' <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, 'Stanislaw Gruszka' <sgruszka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Benson Leung' <bleung-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, 'Enric Balletbo i Serra' <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, "'James E.J. Bottomley'" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "'Martin K. Petersen'" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
> Sent: Monday, 13 May 2019 5:01 PM
> To: Alastair D'Silva <alastair-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
> Cc: alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org; Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>; =
Joonas
> Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>; Rodrigo Vivi
> <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; David Airlie <airlied-cv59FeDIM0c@public.gmane.org>; Daniel =
Vetter
> <daniel-/w4YWyX8dFk@public.gmane.org>; Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>; Karsten
> Keil <isdn-iHCpqvpFUx0uJkBD2foKsQ@public.gmane.org>; Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>; Tom
> Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>; David S. Miller
> <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>; Jose Abreu <Jose.Abreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>; Kalle
> Valo <kvalo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>; Stanislaw Gruszka <sgruszka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>;
> Benson Leung <bleung-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>; Enric Balletbo i Serra
> <enric.balletbo-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>; James E.J. Bottomley
> <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>; Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>;
> Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>; Alexander Viro
> <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>; Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>; Sergey
> Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>; Steven Rostedt
> <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>; David Laight <David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org>; Andrew
> Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>; Intel Graphics Development <intel-
> gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>; DRI Development <dri-
> devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>; Linux Kernel Mailing List <linux-
> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>;
> ath10k-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org; linux-wireless =
<linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>;
> scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Linux Fbdev development list =
<linux-
> fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; driverdevel <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>; =
Linux
> FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Subject: Re: [PATCH v2 3/7] lib/hexdump.c: Optionally suppress lines =
of
> repeated bytes
>=20
> Hi Alastair,
>=20
> Thanks for your patch!

And thanks for your politeness :)

>=20
> On Wed, May 8, 2019 at 9:04 AM Alastair D'Silva <alastair-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
> wrote:
> > From: Alastair D'Silva <alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org>
> >
> > Some buffers may only be partially filled with useful data, while =
the
> > rest is padded (typically with 0x00 or 0xff).
> >
> > This patch introduces a flag to allow the supression of lines of
> > repeated bytes,
>=20
> Given print_hex_dump() operates on entities of groupsize (1, 2, 4, or =
8)
> bytes, wouldn't it make more sense to consider repeated groups instead =
of
> repeated bytes?

Maybe, it would mean that subsequent addresses may not be a multiple of =
rowsize though, which is useful.

> > which are replaced with '** Skipped %u bytes of value 0x%x **'
>=20
> Using a custom message instead of just "*", like "hexdump" uses, will =
require
> preprocessing the output when recovering the original binary data by
> feeding it to e.g. "xxd".
> This may sound worse than it is, though, as I never got "xxd" to work =
without
> preprocessing anyway ;-)

I think showing the details of the skipped values is useful when reading =
the output directly. In situations where binary extracts are desired, =
the feature can always be disabled.

--=20
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair-fCx97xH5QTlAfugRpC6u6w@public.gmane.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece
