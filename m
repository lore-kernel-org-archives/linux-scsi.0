From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 3/7] lib/hexdump.c: Optionally suppress lines of
 repeated bytes
Date: Mon, 13 May 2019 09:01:14 +0200
Message-ID: <CAMuHMdVefYTgHzGKBc0ebku1z8V3wsM0ydN+6-S2nFKaB8eH_Q@mail.gmail.com>
References: <20190508070148.23130-1-alastair@au1.ibm.com> <20190508070148.23130-4-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190508070148.23130-4-alastair@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alastair D'Silva <alastair@au1.ibm.com>
Cc: alastair@d-silva.org, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Dan Carpenter <dan.carpenter@oracle.com>, Karsten Keil <isdn@linux-pingi.de>, Jassi Brar <jassisinghbrar@gmail.com>, Tom Lendacky <thomas.lendacky@amd.com>, "David S. Miller" <davem@davemloft.net>, Jose Abreu <Jose.Abreu@synopsys.com>, Kalle Valo <kvalo@codeaurora.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Benson Leung <bleung@chromium.org>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundati>
List-Id: linux-scsi@vger.kernel.org

Hi Alastair,

Thanks for your patch!

On Wed, May 8, 2019 at 9:04 AM Alastair D'Silva <alastair@au1.ibm.com> wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
>
> Some buffers may only be partially filled with useful data, while the rest
> is padded (typically with 0x00 or 0xff).
>
> This patch introduces a flag to allow the supression of lines of repeated
> bytes,

Given print_hex_dump() operates on entities of groupsize (1, 2, 4, or 8)
bytes, wouldn't it make more sense to consider repeated groups instead
of repeated bytes?

> which are replaced with '** Skipped %u bytes of value 0x%x **'

Using a custom message instead of just "*", like "hexdump" uses, will
require preprocessing the output when recovering the original binary
data by feeding it to e.g. "xxd".
This may sound worse than it is, though, as I never got "xxd" to work
without preprocessing anyway ;-)

    $ cat $(type -p unhexdump)
    #!/bin/sh
    sed 's/^[0-9a-f]*//' $1 | xxd -r -p | dd conv=swab

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
