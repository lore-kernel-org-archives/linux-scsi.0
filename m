From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v4 22/23] mac_scsi: Fix pseudo DMA implementation
Date: Thu, 19 May 2016 11:00:02 +0200
Message-ID: <CAMuHMdULODOJH7ozh3Qp=cSnuU=VrZr_CeSaDUJNdjjGf7s=zw@mail.gmail.com>
References: <20160323101009.341929635@telegraphics.com.au>
	<20160323101014.931733618@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33306 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbcESJAE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2016 05:00:04 -0400
In-Reply-To: <20160323101014.931733618@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

Hi Finn,

On Wed, Mar 23, 2016 at 11:10 AM, Finn Thain <fthain@telegraphics.com.a=
u> wrote:
> Fix various issues: Comments about bus errors are incorrect. The
> PDMA asm must return the size of the memory access that faulted so th=
e
> transfer count can be adjusted accordingly. A phase change may cause =
a
> bus error but should not be treated as failure. A bus error does not
> always imply a phase change and generally the transfer may continue.
> Scatter/gather doesn't seem to work with PDMA due to overruns. This i=
s
> a pity because peak throughput seems to double with SG_ALL.
> Tested on a Mac LC III and a PowerBook 520.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

> --- linux.orig/drivers/scsi/mac_scsi.c  2016-03-23 21:09:53.000000000=
 +1100
> +++ linux/drivers/scsi/mac_scsi.c       2016-03-23 21:10:05.000000000=
 +1100

> @@ -104,18 +105,9 @@ static int __init mac_scsi_setup(char *s

>  static int macscsi_pread(struct Scsi_Host *instance,
>                           unsigned char *dst, int len)
>  {
>         struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
> -       unsigned char *d;
> -       unsigned char *s;
> -
> -       s =3D hostdata->pdma_base + (INPUT_DATA_REG << 4);
> -       d =3D dst;
> -
> -       /* These conditions are derived from MacOS */
> -
> -       while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) &&
> -              !(NCR5380_read(STATUS_REG) & SR_REQ))
> -               ;
> -
> -       if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_DRQ) &&
> -           (NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH)) {
> -               pr_err("Error in macscsi_pread\n");
> -               return -1;
> -       }
> -
> -       CP_IO_TO_MEM(s, d, len);
> -
> -       if (len !=3D 0) {
> -               pr_notice("Bus error in macscsi_pread\n");
> -               return -1;
> +       unsigned char *s =3D hostdata->pdma_base + (INPUT_DATA_REG <<=
 4);
> +       unsigned char *d =3D dst;
> +       int n =3D len;
> +       int transferred;
> +
> +       while (!NCR5380_poll_politely(instance, BUS_AND_STATUS_REG,
> +                                     BASR_DRQ | BASR_PHASE_MATCH,
> +                                     BASR_DRQ | BASR_PHASE_MATCH, HZ=
 / 64)) {
> +               CP_IO_TO_MEM(s, d, n);

This is now before the inclusion of NCR5380.c, causing

In file included from drivers/scsi/mac_scsi.c:335:
drivers/scsi/NCR5380.h:295: warning: =E2=80=98NCR5380_poll_politely=E2=80=
=99 declared
inline after being called
drivers/scsi/NCR5380.h:295: warning: previous declaration of
=E2=80=98NCR5380_poll_politely=E2=80=99 was here

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
