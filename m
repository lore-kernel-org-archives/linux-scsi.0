From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 25/36] sun3_scsi: Convert to platform device
Date: Sun, 9 Nov 2014 11:25:00 +0100
Message-ID: <CAMuHMdUULx29rmrSPxmSJugTQAbRVnkcjVzg6j3-eN4U7hLpZA@mail.gmail.com>
References: <20141027052607.105914311@telegraphics.com.au>
	<20141027052613.155430175@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:34935 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaKIKZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2014 05:25:03 -0500
In-Reply-To: <20141027052613.155430175@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>

On Mon, Oct 27, 2014 at 6:26 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> --- linux.orig/arch/m68k/sun3/config.c  2014-10-27 16:17:59.000000000 +1100
> +++ linux/arch/m68k/sun3/config.c       2014-10-27 16:25:50.000000000 +1100

> @@ -169,3 +171,61 @@ static void __init sun3_sched_init(irq_h
>          intersil_clear();
>  }
>
> +#ifdef CONFIG_SUN3_SCSI
> +
> +static const struct resource sun3_scsi_vme_rsrc[] __initconst = {
> +       {
> +               .flags = IORESOURCE_IRQ,
> +               .start = SUN3_VEC_VMESCSI0,
> +               .end   = SUN3_VEC_VMESCSI0,
> +       }, {
> +               .flags = IORESOURCE_MEM,
> +               .start = 0xff200000,
> +               .end   = 0xff200000 + PAGE_SIZE - 1,

PAGE_SIZE is a software kernel configuration option, not a hardware
property. It makes sense to use it in an ioremap() call, but not in a
platform device's resource, which describes the hardware.

> +       }, {
> +               .flags = IORESOURCE_IRQ,
> +               .start = SUN3_VEC_VMESCSI1,
> +               .end   = SUN3_VEC_VMESCSI1,
> +       }, {
> +               .flags = IORESOURCE_MEM,
> +               .start = 0xff204000,
> +               .end   = 0xff204000 + PAGE_SIZE - 1,

Likewise

> +       },
> +};
> +
> +/*
> + * Int: level 2 autovector
> + * IO: type 1, base 0x00140000, 5 bits phys space: A<4..0>
> + */
> +static const struct resource sun3_scsi_rsrc[] __initconst = {
> +       {
> +               .flags = IORESOURCE_IRQ,
> +               .start = 2,
> +               .end   = 2,
> +       }, {
> +               .flags = IORESOURCE_MEM,
> +               .start = 0x00140000,
> +               .end   = 0x00140000 + PAGE_SIZE - 1,

Likewise

According to the Sun-3 Architecture Manual v2.0 (May 1985), end should
be 0x0014001f.

I guess the resource length is 0x20 for VME SCSI, too?

> +       },

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
