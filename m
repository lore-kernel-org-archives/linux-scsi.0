From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v4 22/23] mac_scsi: Fix pseudo DMA implementation
Date: Thu, 19 May 2016 14:55:24 +0200
Message-ID: <CAMuHMdVerwqZmxZtxabSegvAQ2W1o3t55SVzU-Er3i2D+HmW0A@mail.gmail.com>
References: <20160323101009.341929635@telegraphics.com.au>
	<20160323101014.931733618@telegraphics.com.au>
	<CAMuHMdULODOJH7ozh3Qp=cSnuU=VrZr_CeSaDUJNdjjGf7s=zw@mail.gmail.com>
	<alpine.LNX.2.00.1605192148110.12845@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1605192148110.12845@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Thu, May 19, 2016 at 2:02 PM, Finn Thain <fthain@telegraphics.com.au=
> wrote:
> On Thu, 19 May 2016, Geert Uytterhoeven wrote:
>> In file included from drivers/scsi/mac_scsi.c:335:
>> drivers/scsi/NCR5380.h:295: warning: `NCR5380_poll_politely' declare=
d inline after being called
>> drivers/scsi/NCR5380.h:295: warning: previous declaration of `NCR538=
0_poll_politely' was here
>
> Thanks for letting me know. My compiler (v4.4.6) doesn't warn about t=
his.
> What GCC version are you using? Does this (untested) patch help?

The venerable gcc version 4.1.2 20061115 (prerelease) (Ubuntu 4.1.1-21)=
=2E
Which seems to disobey __attribute__((unused)):

     drivers/scsi/NCR5380.c:385: warning: =E2=80=98NCR5380_probe_irq=E2=
=80=99 defined
but not used

> Index: linux/drivers/scsi/NCR5380.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/NCR5380.c   2016-05-19 21:31:05.000000000=
 +1000
> +++ linux/drivers/scsi/NCR5380.c        2016-05-19 21:39:08.000000000=
 +1000
> @@ -230,13 +230,6 @@ static int NCR5380_poll_politely2(struct
>         return -ETIMEDOUT;
>  }
>
> -static inline int NCR5380_poll_politely(struct Scsi_Host *instance,
> -                                        int reg, int bit, int val, i=
nt wait)
> -{
> -       return NCR5380_poll_politely2(instance, reg, bit, val,
> -                                               reg, bit, val, wait);
> -}
> -
>  #if NDEBUG
>  static struct {
>         unsigned char mask;
> Index: linux/drivers/scsi/NCR5380.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/scsi/NCR5380.h   2016-05-19 19:47:06.000000000=
 +1000
> +++ linux/drivers/scsi/NCR5380.h        2016-05-19 21:40:15.000000000=
 +1000
> @@ -292,8 +292,10 @@ static void NCR5380_reselect(struct Scsi
>  static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *, struct s=
csi_cmnd *);
>  static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned=
 char *phase, int *count, unsigned char **data);
>  static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned=
 char *phase, int *count, unsigned char **data);
> -static int NCR5380_poll_politely(struct Scsi_Host *, int, int, int, =
int);
>  static int NCR5380_poll_politely2(struct Scsi_Host *, int, int, int,=
 int, int, int, int);
>
> +#define NCR5380_poll_politely(instance, reg, bit, val, wait) \
> +        NCR5380_poll_politely2(instance, reg, bit, val, reg, bit, va=
l, wait)

Thanks, that silences the warning.

BTW, what about using the static inline variant here? That works, too.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
                                -- Linus Torvalds
