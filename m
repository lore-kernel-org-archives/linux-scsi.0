From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 07/29] ncr5380: Cleanup TAG_NEXT and TAG_NONE macros
Date: Fri, 3 Oct 2014 10:09:35 +0200
Message-ID: <CAMuHMdUKkyj-27iqrhSZS9GpaB1GHpztnScW+0X4Fi62AdwOvw@mail.gmail.com>
References: <20141002065628.256592712@telegraphics.com.au>
	<20141002065629.926686164@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:37290 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaJCIJh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2014 04:09:37 -0400
In-Reply-To: <20141002065629.926686164@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>

On Thu, Oct 2, 2014 at 8:56 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> --- linux.orig/drivers/scsi/NCR5380.h   2014-10-02 16:55:55.000000000 +1000
> +++ linux/drivers/scsi/NCR5380.h        2014-10-02 16:55:57.000000000 +1000
> @@ -224,14 +224,11 @@
>  #define DISCONNECT_LONG                2
>
>  /*
> - * These are "special" values for the tag parameter passed to NCR5380_select.
> + * "Special" value for the (unsigned char) command tag, to indicate
> + * I_T_L nexus instead of I_T_L_Q.
>   */

I guess the above comment can just be removed instead of changed, as
the I_T_L nexus definitions below are removed?

> -#define TAG_NEXT       -1      /* Use next free tag */
> -#define TAG_NONE       -2      /*
> -                                * Establish I_T_L nexus instead of I_T_L_Q
> -                                * even on SCSI-II devices.
> -                                */
> +#define TAG_NONE       0xff
>
>  /*
>   * These are "special" values for the irq and dma_channel fields of the
> @@ -323,7 +320,7 @@ static irqreturn_t NCR5380_intr(int irq,

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
