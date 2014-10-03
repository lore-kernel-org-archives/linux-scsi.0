From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 12/29] ncr5380: Cleanup host info() methods
Date: Fri, 3 Oct 2014 10:32:15 +0200
Message-ID: <CAMuHMdXVVvbSqZ1fKqbd3TgjO7ymcOLojhUhXsph-Nn8UUStNw@mail.gmail.com>
References: <20141002065628.256592712@telegraphics.com.au>
	<20141002065631.136827342@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141002065631.136827342@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 2, 2014 at 8:56 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> +static void prepare_info(struct Scsi_Host *instance)
> +{
> +       struct NCR5380_hostdata *hostdata = shost_priv(instance);
> +
> +       snprintf(hostdata->info, sizeof(hostdata->info),

[...]

> +                "");
> +       hostdata->info[sizeof(hostdata->info) - 1] = '\0';

snprintf() will make sure the string is zero-terminated, so doing this manually
is not needed.

This applies to all three occurrences.

>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
